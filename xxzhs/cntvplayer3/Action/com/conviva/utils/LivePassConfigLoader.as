package com.conviva.utils
{
    import com.conviva.internal_access.*;

    public class LivePassConfigLoader extends Object
    {
        private var _configUpdated:Eventer;
        private var _fullConfigXmlElement:XmlElement;
        private var _configXmlElement:XmlElement;
        private var _configLoader:DataLoader;
        private var _serviceUrl:String;
        private var _customerName:String;
        private var _failureHandler:Function;
        private var _altName:String;
        private var _ccsWallTimeMs:Number;
        private var _isPeriodic:Boolean = false;
        private var _nextConfigParserFragment:int;
        private static const BASENAME_XML:String = "livePassConfig.xml";
        private static var _basenameXml:String = "livePassConfig.xml";
        private static const DEFAULT_PING_PERCENT_RATE:int = 100;
        private static var _pingRatePercent:int = 100;
        private static var _loaderInstance:LivePassConfigLoader = null;
        private static var _configLoadTimeoutIntervalMs:int = 15000;
        static var configLoadTimeoutIntervalMs:int = 0;
        private static var _attributeOverrides:DictionaryCS = null;
        static var FakeUpdate:Boolean = false;

        public function LivePassConfigLoader(param1:String, param2:String, param3:Function, param4:Function, param5:String)
        {
            this._serviceUrl = param1;
            this._customerName = param2;
            this._failureHandler = param4;
            this._configUpdated = new Eventer();
            if (param3 != null)
            {
                this._configUpdated.AddHandler(param3);
            }
            this._fullConfigXmlElement = null;
            this._configXmlElement = null;
            this._altName = null;
            this._nextConfigParserFragment = 0;
            if (param5 != null)
            {
            }
            else
            {
                this.StartLoadConfig();
            }
            return;
        }// end function

        public function get AlternativeName() : String
        {
            return this._altName;
        }// end function

        public function get CcsWallTimeMs() : Number
        {
            return this._ccsWallTimeMs;
        }// end function

        public function Cleanup() : void
        {
            if (this._configLoader != null)
            {
                this._configLoader.Cleanup();
                this._configLoader = null;
            }
            if (this._configUpdated != null)
            {
                this._configUpdated.Cleanup();
                this._configUpdated = null;
            }
            this._configXmlElement = null;
            this._fullConfigXmlElement = null;
            this._serviceUrl = null;
            return;
        }// end function

        private function ConfigUrl() : String
        {
            var _loc_1:* = new DictionaryCS();
            _loc_1.SetValue("c3.customerName", this._customerName);
            _loc_1.SetValue("c3.platform", "FL");
            var _loc_2:Boolean = false;
            _loc_1.SetValue("c3.token", Lang.ToString(Utils.NextRandom32()));
            if (_loc_2)
            {
                _loc_1.SetValue("c3.dver", LivePassVersion.versionStr);
            }
            else
            {
                _loc_1.SetValue("c3.sver", LivePassVersion.versionStr);
            }
            if (this._altName != null)
            {
                _loc_1.SetValue("c3.alt", this._altName);
            }
            return this._serviceUrl + "/lpconfig/cfg/" + Utils.UrlEncodeQuery(_loc_1) + "?random=" + Utils.NextRandom32() + "&uuid=" + Ping.Id.toString();
        }// end function

        public function get CurrentConfig() : String
        {
            return this._configXmlElement.ToStr();
        }// end function

        protected function LoadConfigGeneral(param1:Function, param2:Function) : void
        {
            var success:* = param1;
            var fail:* = param2;
            var url:* = this.ConfigUrl();
            Trace.Info("LivePassConfigLoader", "loading " + url);
            var options:DictionaryCS;
            if (fail != null)
            {
                options = new DictionaryCS();
                if (TESTAPI::configLoadTimeoutIntervalMs != 0)
                {
                    options.Add("timeoutMs", TESTAPI::configLoadTimeoutIntervalMs.toString());
                }
                else
                {
                    options.Add("timeoutMs", _configLoadTimeoutIntervalMs.toString());
                }
            }
            this._configLoader = new DataLoader(url, function (param1:Error, param2:DataLoader)
            {
                var newConfigDoc:*;
                var err:* = param1;
                var dl:* = param2;
                if (err == null)
                {
                    newConfigDoc = dl.Response.ToXml();
                    if (newConfigDoc != null)
                    {
                        _fullConfigXmlElement = XmlElement.FromRepr(newConfigDoc);
                        Utils.RunProtected(success, "LPConfigLoader.LoadConfigGeneral.1");
                    }
                    else
                    {
                        Ping.Send("LivePassConfigLoader newConfigDoc==null");
                    }
                }
                else
                {
                    Utils.RunProtected(function ()
                {
                    if (fail != null)
                    {
                        fail(err);
                    }
                    return;
                }// end function
                , "LPConfigLoader.LoadConfigGeneral.2");
                }
                return;
            }// end function
            , null, options);
            return;
        }// end function

        private function StartLoadConfig() : void
        {
            this.LoadConfigGeneral(this.HandleNewConfig, this._failureHandler);
            return;
        }// end function

        private function HandleNewConfig() : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            if (this._fullConfigXmlElement == null)
            {
                return;
            }
            if (!this.isLivePassConfig(this._fullConfigXmlElement))
            {
                _loc_2 = "LivePassConfigLoader.HandleNewConfig:" + "Got an invalid livePassConfig ";
                if (Utils.NextRandom() < 0.001)
                {
                    _loc_2 = _loc_2 + ("doc=" + this._fullConfigXmlElement.ToStr());
                    _loc_2 = Lang.StringSubstring(_loc_2, 0, 1000);
                }
                Utils.ReportErrorContinue(_loc_2, true);
                return;
            }
            if (this._altName == null)
            {
                this._altName = this.ChooseAlternative();
            }
            this._configXmlElement = this._fullConfigXmlElement.FilterAlternatives(this._altName);
            var _loc_1:* = this._configXmlElement.GetElements("alternative").Count;
            if (_loc_1 != 1)
            {
                _loc_3 = "LivePassConfigLoader.processConfigXML:" + "Did not find exactly one alternative. alt=" + this._altName.toString() + ", " + "count=" + _loc_1;
                if (Utils.NextRandom() < 0.001)
                {
                    _loc_3 = _loc_3 + ("doc=" + this._fullConfigXmlElement.ToStr());
                    _loc_3 = Lang.StringSubstring(_loc_3, 0, 1000);
                }
                Utils.ReportErrorContinue(_loc_3, true);
            }
            this._nextConfigParserFragment = 0;
            this.parseConfig(int.MAX_VALUE);
            return;
        }// end function

        private function parseConfig(param1:int) : void
        {
            _pingRatePercent = this.GetIntAttribute("pingRatePercent", "value", DEFAULT_PING_PERCENT_RATE);
            this._nextConfigParserFragment = 0;
            if (this._configUpdated != null)
            {
                this._configUpdated.DispatchEvent();
            }
            return;
        }// end function

        public function AllModuleUrls() : ListCS
        {
            var _loc_4:XmlElement = null;
            var _loc_1:String = null;
            _loc_1 = "modulePath";
            var _loc_2:* = new ListCS();
            var _loc_3:* = this._configXmlElement.GetElements(_loc_1);
            for each (_loc_4 in _loc_3.Values)
            {
                
                _loc_2.Add(_loc_4.GetValue());
            }
            return _loc_2;
        }// end function

        public function GatewayList() : ListCS
        {
            return this._configXmlElement.GetElements("gateway");
        }// end function

        private function ChooseAlternative() : String
        {
            var _loc_2:AltAffinity = null;
            var _loc_4:XmlElement = null;
            var _loc_5:Number = NaN;
            var _loc_6:AltAffinity = null;
            var _loc_7:Number = NaN;
            var _loc_8:AltAffinity = null;
            var _loc_1:* = new ListCS();
            var _loc_3:* = this._fullConfigXmlElement.GetElements("alternative");
            for each (_loc_4 in _loc_3.Values)
            {
                
                _loc_2 = new AltAffinity();
                _loc_2.Name = _loc_4.GetAltName();
                _loc_2.Affinity = _loc_4.GetAltAffinity();
                if (_loc_2.Affinity > 0)
                {
                    _loc_1.Add(_loc_2);
                }
            }
            _loc_5 = 0;
            for each (_loc_6 in _loc_1.Values)
            {
                
                _loc_5 = _loc_5 + _loc_6.Affinity;
            }
            _loc_7 = Utils.NextRandom() * _loc_5;
            for each (_loc_8 in _loc_1.Values)
            {
                
                _loc_7 = _loc_7 - _loc_8.Affinity;
                if (_loc_7 <= 0)
                {
                    return _loc_8.Name;
                }
            }
            return null;
        }// end function

        public function GetAttribute(param1:String, param2:String, param3:String) : String
        {
            var _loc_5:ListCS = null;
            var _loc_6:XmlElement = null;
            if (_attributeOverrides != null && _attributeOverrides.ContainsKey(param1))
            {
                return _attributeOverrides.GetValue(param1);
            }
            var _loc_4:* = param3;
            try
            {
                _loc_5 = this._configXmlElement.GetElements(param1);
                if (_loc_5 != null && _loc_5.Count > 0)
                {
                    _loc_6 = _loc_5.GetValue(0);
                    _loc_4 = _loc_6.GetAttribute(param2);
                    if (_loc_4 == null)
                    {
                        _loc_4 = param3;
                    }
                }
            }
            catch (e:Error)
            {
            }
            return _loc_4;
        }// end function

        public function GetIntAttribute(param1:String, param2:String, param3:int) : int
        {
            var _loc_4:* = param3;
            try
            {
                _loc_4 = Lang.parseInt(this.GetAttribute(param1, param2, param3.toString()));
            }
            catch (e:Error)
            {
            }
            return _loc_4;
        }// end function

        public function AddConfigUpdatedHandler(param1:Function) : void
        {
            this._configUpdated.AddHandler(param1);
            return;
        }// end function

        public function DeleteConfigUpdatedHandler(param1:Function) : void
        {
            if (this._configUpdated != null)
            {
                this._configUpdated.DeleteHandler(param1);
            }
            return;
        }// end function

        public function GatherStats(param1:DictionaryCS) : void
        {
            var _loc_2:* = this.ConfigUrl();
            if (Lang.StringIndexOf(_loc_2, "?") >= 0)
            {
                _loc_2 = Lang.StringSubstring(_loc_2, 0, Lang.StringIndexOf(_loc_2, "?"));
            }
            param1.SetValue("LivePass.configUrl", _loc_2);
            param1.SetValue("LivePass.uuid", Ping.Id.toString());
            return;
        }// end function

        private function isLivePassConfig(param1:XmlElement) : Boolean
        {
            if (param1 != null)
            {
                if (param1.GetName() == "livePassConfig")
                {
                    return true;
                }
            }
            return false;
        }// end function

        public static function get PingRatePercent() : int
        {
            return _pingRatePercent;
        }// end function

        public static function CreateOneTimeLoader(param1:String, param2:String, param3:Function, param4:Function) : LivePassConfigLoader
        {
            if (_loaderInstance != null)
            {
                _loaderInstance.Cleanup();
                _loaderInstance = null;
            }
            _loaderInstance = new LivePassConfigLoader(param1, param2, param3, param4, null);
            _loaderInstance._isPeriodic = false;
            return _loaderInstance;
        }// end function

        public static function GetInstance() : LivePassConfigLoader
        {
            Utils.Assert(_loaderInstance != null, "LivePassConfigLoader.getInstance");
            return _loaderInstance;
        }// end function

        public static function StaticCleanup() : void
        {
            if (_loaderInstance != null)
            {
                _loaderInstance.Cleanup();
                _loaderInstance = null;
            }
            TESTAPI::fakeXML = null;
            TESTAPI::FakeUpdate = false;
            _attributeOverrides = null;
            _basenameXml = BASENAME_XML;
            return;
        }// end function

        static function ClearOverrides() : void
        {
            _attributeOverrides = null;
            return;
        }// end function

        static function AddOverride(param1:String, param2:String) : void
        {
            if (_attributeOverrides == null)
            {
                _attributeOverrides = new DictionaryCS();
            }
            _attributeOverrides.SetValue(param1, param2);
            return;
        }// end function

        static function set BasenameXML(param1:String) : void
        {
            _basenameXml = param1;
            return;
        }// end function

    }
}

class AltAffinity extends Object
{
    public var Name:String;
    public var Affinity:int;

    function AltAffinity()
    {
        return;
    }// end function

}

