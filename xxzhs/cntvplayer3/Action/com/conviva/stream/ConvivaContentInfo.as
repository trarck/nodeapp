package com.conviva.stream
{
    import com.conviva.utils.*;

    public class ConvivaContentInfo extends Object
    {
        private var _objectId:String = "noobj";
        private var _bitrate:Number = 0;
        private var _candidateResources:Array = null;
        private var _tags:Object;
        private var _resourceSelection:Boolean = false;
        private var _rtmpPortSearchList:Array;
        private var _rtmpPortSearchMaxTimeMs:Number = 10000;
        private var _rtmpPortSearchEquivalenceWindowMs:Number = 100;
        private var _urlGenerator:Function;
        private var _start:Number = -2;
        private var _len:Number = -1;
        private var _reset:Number = 1;
        private var _mbrInfo:MbrStreamInfo = null;
        private var _isLive:Boolean = false;
        private var _mediaType:String;
        private var _monitoringOptions:Object;
        private var _authAtConnect:Boolean = false;
        private var _authMode:int = 0;
        public static const _allowableMonitoringOptions:Array = ["joinStartTime", "bitrateKbps", "bitrateEstimators", "playFailedAfterNSecondsBuffering", "playFailedAfterNSecondsJoining", "contentDuration"];
        public static const MAX_PARAMETER_LENGTH:int = 128;

        public function ConvivaContentInfo(param1:String, param2:Object, param3:Object)
        {
            this._tags = {};
            this._rtmpPortSearchList = [{protocol:"rtmp", port:1935}, {protocol:"rtmp", port:443}, {protocol:"rtmp", port:80}, {protocol:"rtmpt", port:80}];
            this._urlGenerator = this.simpleConcatenate;
            this._mediaType = Utils.MEDIA_TYPE_RTMP_STREAM;
            this._monitoringOptions = {};
            this._objectId = param1;
            if (param2 is Array)
            {
                this._candidateResources = param2 as Array;
                this._resourceSelection = true;
            }
            else if (param2 is ArrayCS)
            {
                this._candidateResources = Lang.ArrayToRepr(param2 as ArrayCS);
                this._resourceSelection = true;
            }
            else if (param2 is ListCS)
            {
                this._candidateResources = Lang.ListToRepr(param2 as ListCS);
                this._resourceSelection = true;
            }
            else if (param2 is String)
            {
                this._candidateResources = [param2 as String];
                this._resourceSelection = false;
            }
            else
            {
                Utils.ReportError("TypeError, candidateResources should be String or Array");
            }
            this._tags = param3;
            this._mbrInfo = null;
            this._bitrate = 0;
            this._start = -2;
            this._len = -1;
            this._reset = 1;
            this._authAtConnect = false;
            this._authMode = 0;
            this._mediaType = Utils.MEDIA_TYPE_RTMP_STREAM;
            this._isLive = false;
            return;
        }// end function

        public function sanitizeData() : void
        {
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            this._objectId = this.sanitizeString(this._objectId, "Null title", true, "objectId");
            if (this._tags == null)
            {
                this._tags = new Object();
            }
            var _loc_1:* = this._tags;
            if (this._tags.hasOwnProperty("ToObject"))
            {
                _loc_1 = this._tags.ToObject();
            }
            var _loc_2:* = new Array();
            for (_loc_3 in _loc_1)
            {
                
                _loc_2.push(_loc_3);
            }
            for each (_loc_4 in _loc_2)
            {
                
                _loc_5 = this.sanitizeString(_loc_4, "null", false, "tag name");
                _loc_6 = this.sanitizeString(_loc_1[_loc_4], "null", false, "tag value");
                if (_loc_5 != _loc_4)
                {
                    delete _loc_1[_loc_4];
                    _loc_1[_loc_5] = _loc_6;
                }
                if (_loc_6 != _loc_1[_loc_5])
                {
                    _loc_1[_loc_5] = _loc_6;
                }
            }
            this._tags = _loc_1;
            return;
        }// end function

        private function sanitizeString(param1:Object, param2:String, param3:Boolean, param4:String) : String
        {
            var _loc_5:String = null;
            if (!param1)
            {
                Utils.ReportErrorContinue("ConvivaContentInfo: " + param4 + " is null", false);
                param1 = param2;
            }
            if (param1 is String)
            {
                _loc_5 = param1 as String;
            }
            else
            {
                _loc_5 = param1.toString();
            }
            _loc_5 = Lang.StringTrim(_loc_5);
            if (param3 && _loc_5 == Utils.GLOBAL_SESSION_ASSET_NAME)
            {
            }
            else if (_loc_5.length >= 3 && _loc_5.substr(0, 3) == "c3.")
            {
                Utils.ReportErrorContinue("ConvivaContentInfo: " + param4 + " is reserved IGNORE:" + this.objectId, false);
                _loc_5 = "_" + _loc_5;
            }
            if (_loc_5.length > MAX_PARAMETER_LENGTH)
            {
                Utils.ReportErrorContinue("ConvivaContentInfo: " + param4 + " is too long IGNORE:" + this.objectId, false);
                _loc_5 = _loc_5.substr(0, MAX_PARAMETER_LENGTH);
            }
            return _loc_5;
        }// end function

        public function cleanup() : void
        {
            this._isLive = false;
            this._candidateResources = new Array();
            this._urlGenerator = this.simpleConcatenate;
            if (this._mbrInfo)
            {
                this._mbrInfo.cleanup();
                this._mbrInfo = null;
            }
            this._authAtConnect = false;
            this._authMode = 0;
            this._mediaType = Utils.MEDIA_TYPE_RTMP_STREAM;
            return;
        }// end function

        public function get objectId() : String
        {
            return this._objectId;
        }// end function

        public function get bitrate() : Number
        {
            return this._bitrate;
        }// end function

        public function set bitrate(param1:Number) : void
        {
            this._bitrate = param1;
            return;
        }// end function

        public function get tags() : Object
        {
            return this._tags;
        }// end function

        public function set tags(param1:Object) : void
        {
            this._tags = param1;
            return;
        }// end function

        public function get initFromHttpService() : Boolean
        {
            return false;
        }// end function

        public function get resourceSelection() : Boolean
        {
            return this._resourceSelection;
        }// end function

        public function set resourceSelection(param1:Boolean) : void
        {
            this._resourceSelection = param1;
            return;
        }// end function

        public function get candidateResources() : Array
        {
            return this._candidateResources;
        }// end function

        public function set candidateResources(param1:Array) : void
        {
            var _loc_2:String = null;
            for each (_loc_2 in param1)
            {
                
            }
            var _loc_3:* = param1;
            this._candidateResources = param1;
            return;
        }// end function

        public function get mbrInfo() : MbrStreamInfo
        {
            return this._mbrInfo;
        }// end function

        public function set mbrInfo(param1:MbrStreamInfo) : void
        {
            var _loc_2:* = param1;
            this._mbrInfo = param1;
            return;
        }// end function

        public function set urlGenerator(param1:Function) : void
        {
            var _loc_2:* = param1;
            this._urlGenerator = param1;
            return;
        }// end function

        public function get urlGenerator() : Function
        {
            return this._urlGenerator;
        }// end function

        public function get start() : Number
        {
            return this._start;
        }// end function

        public function set start(param1:Number) : void
        {
            Utils.Assert(param1 == -2 || param1 == -1 || param1 >= 0, "allowable values");
            var _loc_2:* = param1;
            this._start = param1;
            return;
        }// end function

        public function get len() : Number
        {
            return this._len;
        }// end function

        public function set len(param1:Number) : void
        {
            Utils.Assert(param1 == -1 || param1 >= 0, "allowable values");
            var _loc_2:* = param1;
            this._len = param1;
            return;
        }// end function

        public function get reset() : Object
        {
            return this._reset;
        }// end function

        public function set reset(param1:Object) : void
        {
            if (param1 is Boolean)
            {
                var _loc_2:* = param1 ? (1) : (0);
                this._reset = param1 ? (1) : (0);
            }
            else if (param1 is Number)
            {
                Utils.Assert(param1 == 0 || param1 == 1 || param1 == 2 || param1 == 3, "allowable values");
                var _loc_2:* = param1 as Number;
                this._reset = param1 as Number;
            }
            else
            {
                Utils.ReportError("wrong type");
            }
            return;
        }// end function

        public function get rtmpPortSearchList() : Array
        {
            return this._rtmpPortSearchList;
        }// end function

        public function set rtmpPortSearchList(param1:Array) : void
        {
            this.confirmPortsSameFamily(param1);
            var _loc_2:* = param1;
            this._rtmpPortSearchList = param1;
            return;
        }// end function

        public function get rtmpPortSearchMaxTimeMs() : Number
        {
            return this._rtmpPortSearchMaxTimeMs;
        }// end function

        public function set rtmpPortSearchMaxTimeMs(param1:Number) : void
        {
            var _loc_2:* = param1;
            this._rtmpPortSearchMaxTimeMs = param1;
            return;
        }// end function

        public function get rtmpPortSearchEquivalenceWindowMs() : Number
        {
            return this._rtmpPortSearchEquivalenceWindowMs;
        }// end function

        public function set rtmpPortSearchEquivalenceWindowMs(param1:Number) : void
        {
            var _loc_2:* = param1;
            this._rtmpPortSearchEquivalenceWindowMs = param1;
            return;
        }// end function

        private function simpleConcatenate(param1:String, param2:String, param3:int) : String
        {
            return param1 + "/" + param2;
        }// end function

        public function highwindsUrlGenerator(param1:String, param2:String, param3:int, param4:Function) : void
        {
            var smilLoader:DataLoader;
            var loadSuccess:Function;
            var loadFailure:Function;
            var selectedResource:* = param1;
            var baseUrl:* = param2;
            var bitrate:* = param3;
            var callback:* = param4;
            var smilUrl:* = selectedResource + "/" + baseUrl;
            smilLoader;
            loadSuccess = function ()
            {
                highwindsDataLoadSuccess(smilLoader, callback);
                return;
            }// end function
            ;
            loadFailure = function ()
            {
                callback(null);
                return;
            }// end function
            ;
            var _loc_6:* = new DataLoader(smilUrl, function (param1:Error, param2:DataLoader) : void
            {
                if (param1 != null)
                {
                    Trace.Info("CCI", "Error loading highwinds SMIL file" + param1.name);
                    Utils.RunProtected(loadFailure, "ConvivaContentInfo.highwindsGenerator.failure");
                }
                else
                {
                    Utils.RunProtected(loadSuccess, "ConvivaContentInfo.highwindsGenerator.success");
                }
                return;
            }// end function
            , null, {timeoutMs:10000, noHeaders:true});
            smilLoader = new DataLoader(smilUrl, function (param1:Error, param2:DataLoader) : void
            {
                if (param1 != null)
                {
                    Trace.Info("CCI", "Error loading highwinds SMIL file" + param1.name);
                    Utils.RunProtected(loadFailure, "ConvivaContentInfo.highwindsGenerator.failure");
                }
                else
                {
                    Utils.RunProtected(loadSuccess, "ConvivaContentInfo.highwindsGenerator.success");
                }
                return;
            }// end function
            , null, {timeoutMs:10000, noHeaders:true});
            return;
        }// end function

        private function highwindsDataLoadSuccess(param1:DataLoader, param2:Function) : void
        {
            var _loc_3:* = param1.xml;
            if (_loc_3 == null)
            {
                Trace.Error("CCI", "Error parsing highwinds XMIL file (step 1)");
                this.param2(null);
                return;
            }
            var _loc_4:* = _loc_3..meta;
            var _loc_5:* = _loc_3..video;
            if (_loc_4 == null || _loc_5 == null || _loc_4.length() == 0 || _loc_5.length() == 0)
            {
                Trace.Error("CCI", "Error parsing highwinds SMIL file (step 2)");
                this.param2(null);
                return;
            }
            var _loc_6:* = _loc_4[0].@base;
            var _loc_7:* = _loc_5[0].@src;
            if (_loc_6 == null || _loc_7 == null || _loc_6 == "" || _loc_7 == "")
            {
                Trace.Error("CCI", "Error parsing highwinds SMIL file (step 3)");
                this.param2(null);
                return;
            }
            Trace.Info("CCI", "Base=" + _loc_6);
            Trace.Info("CCI", "src=" + _loc_7);
            this.param2(_loc_6 + "#" + _loc_7);
            return;
        }// end function

        private function confirmPortsSameFamily(param1:Array) : void
        {
            var _loc_3:Object = null;
            if (param1 == null)
            {
                throw new ArgumentError("ports array cannot be null");
            }
            if (param1.length == 0)
            {
                throw new ArgumentError("ports array cannot be empty");
            }
            var _loc_2:Number = 0;
            for each (_loc_6 in param1)
            {
                
                _loc_3 = _loc_5[_loc_4];
                switch(_loc_3.protocol)
                {
                    case "rtmp":
                    case "rtmpt":
                    {
                        break;
                    }
                    case "rtmpe":
                    case "rtmpte":
                    {
                        _loc_2 = ++_loc_2 - 1;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            if (Math.abs(_loc_2) != param1.length)
            {
                throw new ArgumentError("cannot mix encrypted with unencrypted protocols");
            }
            return;
        }// end function

        public function get authAtConnect() : Boolean
        {
            return this._authAtConnect;
        }// end function

        public function set authAtConnect(param1:Boolean) : void
        {
            var _loc_2:* = param1;
            this._authAtConnect = param1;
            return;
        }// end function

        public function get authMode() : int
        {
            return this._authMode;
        }// end function

        public function set authMode(param1:int) : void
        {
            var _loc_2:* = param1;
            this._authMode = param1;
            return;
        }// end function

        public function get mediaType() : String
        {
            return this._mediaType;
        }// end function

        public function set mediaType(param1:String) : void
        {
            var _loc_2:* = param1;
            this._mediaType = param1;
            return;
        }// end function

        public function get isLive() : Boolean
        {
            return this._isLive;
        }// end function

        public function set isLive(param1:Boolean) : void
        {
            var _loc_2:* = param1;
            this._isLive = param1;
            return;
        }// end function

        public function get monitoringOptions() : Object
        {
            return this._monitoringOptions;
        }// end function

        public function set monitoringOptions(param1:Object) : void
        {
            var _loc_2:* = param1;
            this._monitoringOptions = param1;
            return;
        }// end function

        function set objectId(param1:String) : void
        {
            var _loc_2:* = param1;
            this._objectId = param1;
            return;
        }// end function

    }
}
