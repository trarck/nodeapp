package com.conviva
{
    import com.conviva.stream.*;
    import com.conviva.utils.*;

    public class ConvivaContentInfo extends Object
    {
        private var _useStrictChecking:Boolean = false;
        private var _assetName:String = null;
        private var _tags:DictionaryCS;
        private var _candidateResources:ListCS;
        private var _resourceSelection:Boolean = false;
        private var _monitoringOptions:DictionaryCS;
        private var _cdnName:String = null;
        private var _validCdnNames:ListCS = null;
        private var _resourceStateOverride:String = null;
        private var _ovppName:String = null;
        private var _frameworkName:String = null;
        private var _frameworkVersion:String = null;
        private var _pluginName:String = null;
        private var _pluginVersion:String = null;
        private var _viewerId:String = null;
        private var _deviceId:String = null;
        private var _deviceType:String = null;
        private var _validDeviceTypes:ListCS = null;
        private var _playerName:String = null;
        private var _streamUrl:String = null;
        private var _bitrate:Number = 0;
        private var _isLive:Boolean = false;
        private var _resource:String = null;
        private var _mbrInfo:MbrStreamInfo = null;
        private var _urlGenerator:Function;
        private var _start:Number = -2;
        private var _len:Number = -1;
        private var _reset:Number = 1;
        private var _rtmpPortSearchList:Array;
        private var _rtmpPortSearchMaxTimeMs:Number = 10000;
        private var _rtmpPortSearchEquivalenceWindowMs:Number = 100;
        private var _authAtConnect:Boolean = false;
        private var _authMode:int = 0;
        private var _mediaType:String;
        public static const CDN_NAME_AKAMAI:String = "AKAMAI";
        public static const CDN_NAME_AMAZON:String = "AMAZON";
        public static const CDN_NAME_ATT:String = "ATT";
        public static const CDN_NAME_BITGRAVITY:String = "BITGRAVITY";
        public static const CDN_NAME_BT:String = "BT";
        public static const CDN_NAME_CDNETWORKS:String = "CDNETWORKS";
        public static const CDN_NAME_CHINACACHE:String = "CHINACACHE";
        public static const CDN_NAME_EDGECAST:String = "EDGECAST";
        public static const CDN_NAME_HIGHWINDS:String = "HIGHWINDS";
        public static const CDN_NAME_INTERNAP:String = "INTERNAP";
        public static const CDN_NAME_LEVEL3:String = "LEVEL3";
        public static const CDN_NAME_LIMELIGHT:String = "LIMELIGHT";
        public static const CDN_NAME_OCTOSHAPE:String = "OCTOSHAPE";
        public static const CDN_NAME_SWARMCAST:String = "SWARMCAST";
        public static const CDN_NAME_VELOCIX:String = "VELOCIX";
        public static const CDN_NAME_TELEFONICA:String = "TELEFONICA";
        public static const CDN_NAME_MICROSOFT:String = "MICROSOFT";
        public static const CDN_NAME_INHOUSE:String = "INHOUSE";
        public static const CDN_NAME_OTHER:String = "OTHER";
        public static const OVPP_NAME_BRIGHTCOVE:String = "Brightcove";
        public static const OVPP_NAME_KALTURA:String = "Kaltura";
        public static const OVPP_NAME_OOYALA:String = "Ooyala";
        public static const OVPP_NAME_THE_PLATFORM:String = "thePlatform";
        public static const FRAMEWORK_NAME_BRIGHTCOVE:String = "Brightcove";
        public static const FRAMEWORK_NAME_KALTURA:String = "Kaltura";
        public static const FRAMEWORK_NAME_OOYALA:String = "Ooyala";
        public static const FRAMEWORK_NAME_OSMF:String = "OSMF";
        public static const FRAMEWORK_NAME_THE_PLATFORM:String = "thePlatform";
        public static const DEVICE_TYPE_CONSOLE:String = "Console";
        public static const DEVICE_TYPE_MOBILE:String = "Mobile";
        public static const DEVICE_TYPE_PC:String = "PC";
        public static const DEVICE_TYPE_SET_TOP_BOX:String = "Settop";
        public static const PLUGIN_NAME_KALTURA:String = "ConvivaKalturaPlugin";
        public static const MO_KEY_NOMINAL_BITRATE_OVERRIDE:String = "nominalBitrateOverride";
        public static const DEFAULT_BITRATE_VAL:Number = 0;
        public static const DEFAULT_START_VAL:Number = -2;
        public static const DEFAULT_LEN_VAL:Number = -1;
        public static const DEFAULT_RESET_VAL:Number = 1;
        public static const DEFAULT_RTMP_PORT_SEARCH_LIST_VAL:Array = [{protocol:"rtmp", port:1935}, {protocol:"rtmp", port:443}, {protocol:"rtmp", port:80}, {protocol:"rtmpt", port:80}];
        public static const DEFAULT_RTMP_PORT_SEARCH_MAX_TIME_MS_VAL:Number = 10000;
        public static const DEFAULT_RTMP_PORT_SEARCH_EQUIVALENCE_WINDOW_MS_VAL:Number = 100;
        public static const DEFAULT_AUTH_MODE_VAL:int = 0;
        public static const DEFAULT_MEDIA_TYPE_VAL:String = Utils.MEDIA_TYPE_RTMP_STREAM;
        public static const MAX_PARAMETER_LENGTH:int = 128;
        private static const DEFAULT_ASSET_NAME:String = "Null title";

        public function ConvivaContentInfo(param1:String, param2:Object, param3:Object)
        {
            this._urlGenerator = this.simpleConcatenate;
            this._rtmpPortSearchList = DEFAULT_RTMP_PORT_SEARCH_LIST_VAL;
            this._mediaType = DEFAULT_MEDIA_TYPE_VAL;
            this.populateValidationConstants();
            var _loc_4:Boolean = false;
            this.useStrictChecking = false;
            var _loc_4:* = param1;
            this.assetName = param1;
            var _loc_4:* = param3;
            this.tags = param3;
            if (this._tags == null)
            {
                var _loc_4:* = new DictionaryCS();
                this._tags = new DictionaryCS();
            }
            if (param2 is Array)
            {
                var _loc_4:* = param2 as Array;
                this.candidateResources = param2 as Array;
                var _loc_4:Boolean = true;
                this.resourceSelection = true;
            }
            else if (param2 is ArrayCS)
            {
                var _loc_4:* = Lang.ArrayToRepr(param2 as ArrayCS);
                this.candidateResources = Lang.ArrayToRepr(param2 as ArrayCS);
                var _loc_4:Boolean = true;
                this.resourceSelection = true;
            }
            else if (param2 is ListCS)
            {
                var _loc_4:* = Lang.ListToRepr(param2 as ListCS);
                this.candidateResources = Lang.ListToRepr(param2 as ListCS);
                var _loc_4:Boolean = true;
                this.resourceSelection = true;
            }
            else if (param2 is String)
            {
                var _loc_4:* = [param2 as String];
                this.candidateResources = [param2 as String];
                var _loc_4:Boolean = false;
                this.resourceSelection = false;
            }
            else if (param2 != null)
            {
                Trace.Error("ConvivaContentInfo: candidateResources is not a String, Array, ArrayCS, or ListCS.");
                var _loc_4:String = null;
                this.candidateResources = null;
                var _loc_4:Boolean = false;
                this.resourceSelection = false;
            }
            else
            {
                var _loc_4:String = null;
                this.candidateResources = null;
                var _loc_4:Boolean = false;
                this.resourceSelection = false;
            }
            if (this._candidateResources == null)
            {
                var _loc_4:* = new ListCS();
                this._candidateResources = new ListCS();
            }
            var _loc_4:* = new DictionaryCS();
            this._monitoringOptions = new DictionaryCS();
            var _loc_4:int = 0;
            this._bitrate = 0;
            var _loc_4:Boolean = false;
            this._isLive = false;
            var _loc_4:String = null;
            this._mbrInfo = null;
            var _loc_4:int = -2;
            this._start = -2;
            var _loc_4:int = -1;
            this._len = -1;
            var _loc_4:int = 1;
            this._reset = 1;
            var _loc_4:Boolean = false;
            this._authAtConnect = false;
            var _loc_4:int = 0;
            this._authMode = 0;
            var _loc_4:* = Utils.MEDIA_TYPE_RTMP_STREAM;
            this._mediaType = Utils.MEDIA_TYPE_RTMP_STREAM;
            return;
        }// end function

        public function get useStrictChecking() : Boolean
        {
            return this._useStrictChecking;
        }// end function

        public function set useStrictChecking(param1:Boolean) : void
        {
            this._useStrictChecking = param1;
            return;
        }// end function

        public function get assetName() : String
        {
            return this._assetName;
        }// end function

        public function set assetName(param1:String) : void
        {
            this._assetName = param1;
            return;
        }// end function

        public function get tags() : Object
        {
            return Lang.StringDictionaryToRepr(this._tags);
        }// end function

        public function set tags(param1:Object) : void
        {
            this._tags = Lang.DictionaryFromRepr(param1);
            return;
        }// end function

        public function get candidateResources() : Array
        {
            return Lang.ListToRepr(this._candidateResources);
        }// end function

        public function set candidateResources(param1:Array) : void
        {
            var _loc_2:String = null;
            for each (_loc_2 in param1)
            {
                
            }
            var _loc_3:* = Lang.ListFromRepr(param1);
            this._candidateResources = Lang.ListFromRepr(param1);
            return;
        }// end function

        public function get resourceSelection() : Boolean
        {
            return this._resourceSelection;
        }// end function

        public function set resourceSelection(param1:Boolean) : void
        {
            var _loc_2:* = param1;
            this._resourceSelection = param1;
            return;
        }// end function

        public function get monitoringOptions() : Object
        {
            return Lang.StringDictionaryToRepr(this._monitoringOptions);
        }// end function

        public function set monitoringOptions(param1:Object) : void
        {
            var _loc_2:* = Lang.DictionaryFromRepr(param1);
            this._monitoringOptions = Lang.DictionaryFromRepr(param1);
            return;
        }// end function

        public function get cdnName() : String
        {
            return this._cdnName;
        }// end function

        public function set cdnName(param1:String) : void
        {
            var _loc_2:* = param1;
            this._cdnName = param1;
            return;
        }// end function

        public function get resourceStateOverride() : String
        {
            return this._resourceStateOverride;
        }// end function

        public function set resourceStateOverride(param1:String) : void
        {
            var _loc_2:* = param1;
            this._resourceStateOverride = param1;
            return;
        }// end function

        public function get ovppName() : String
        {
            return this._ovppName;
        }// end function

        public function set ovppName(param1:String) : void
        {
            var _loc_2:* = param1;
            this._ovppName = param1;
            return;
        }// end function

        public function get frameworkName() : String
        {
            return this._frameworkName;
        }// end function

        public function set frameworkName(param1:String) : void
        {
            var _loc_2:* = param1;
            this._frameworkName = param1;
            return;
        }// end function

        public function get frameworkVersion() : String
        {
            return this._frameworkVersion;
        }// end function

        public function set frameworkVersion(param1:String) : void
        {
            var _loc_2:* = param1;
            this._frameworkVersion = param1;
            return;
        }// end function

        public function get pluginName() : String
        {
            return this._pluginName;
        }// end function

        public function set pluginName(param1:String) : void
        {
            var _loc_2:* = param1;
            this._pluginName = param1;
            return;
        }// end function

        public function get pluginVersion() : String
        {
            return this._pluginVersion;
        }// end function

        public function set pluginVersion(param1:String) : void
        {
            var _loc_2:* = param1;
            this._pluginVersion = param1;
            return;
        }// end function

        public function get viewerId() : String
        {
            return this._viewerId;
        }// end function

        public function set viewerId(param1:String) : void
        {
            var _loc_2:* = param1;
            this._viewerId = param1;
            return;
        }// end function

        public function get deviceId() : String
        {
            return this._deviceId;
        }// end function

        public function set deviceId(param1:String) : void
        {
            var _loc_2:* = param1;
            this._deviceId = param1;
            return;
        }// end function

        public function get deviceType() : String
        {
            return this._deviceType;
        }// end function

        public function set deviceType(param1:String) : void
        {
            var _loc_2:* = param1;
            this._deviceType = param1;
            return;
        }// end function

        public function get playerName() : String
        {
            return this._playerName;
        }// end function

        public function set playerName(param1:String) : void
        {
            var _loc_2:* = param1;
            this._playerName = param1;
            return;
        }// end function

        public function get streamUrl() : String
        {
            return this._streamUrl;
        }// end function

        public function set streamUrl(param1:String) : void
        {
            var _loc_2:* = param1;
            this._streamUrl = param1;
            return;
        }// end function

        public function get bitrate() : Number
        {
            return this._bitrate;
        }// end function

        public function set bitrate(param1:Number) : void
        {
            var _loc_2:* = param1;
            this._bitrate = param1;
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

        public function get resource() : String
        {
            return this._resource;
        }// end function

        public function set resource(param1:String) : void
        {
            var _loc_2:* = param1;
            this._resource = param1;
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

        public function get urlGenerator() : Function
        {
            return this._urlGenerator;
        }// end function

        public function set urlGenerator(param1:Function) : void
        {
            var _loc_2:* = param1;
            this._urlGenerator = param1;
            return;
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
                var _loc_2:* = Number(param1);
                this._reset = Number(param1);
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

        public function cleanup() : void
        {
            var _loc_1:Boolean = false;
            this._isLive = false;
            var _loc_1:* = new ListCS();
            this._candidateResources = new ListCS();
            var _loc_1:* = this.simpleConcatenate;
            this._urlGenerator = this.simpleConcatenate;
            var _loc_1:* = Utils.genericCleanup(this._mbrInfo);
            this._mbrInfo = Utils.genericCleanup(this._mbrInfo);
            var _loc_1:Boolean = false;
            this._authAtConnect = false;
            var _loc_1:int = 0;
            this._authMode = 0;
            var _loc_1:* = Utils.MEDIA_TYPE_RTMP_STREAM;
            this._mediaType = Utils.MEDIA_TYPE_RTMP_STREAM;
            return;
        }// end function

        public function sanitizeData() : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:* = sanitizeString(this.assetName, DEFAULT_ASSET_NAME, true, "assetName");
            this.assetName = sanitizeString(this.assetName, DEFAULT_ASSET_NAME, true, "assetName");
            var _loc_6:* = sanitizeString(this.ovppName, null, false, "ovppName");
            this.ovppName = sanitizeString(this.ovppName, null, false, "ovppName");
            var _loc_6:* = sanitizeString(this.frameworkName, null, false, "frameworkName");
            this.frameworkName = sanitizeString(this.frameworkName, null, false, "frameworkName");
            var _loc_6:* = sanitizeString(this.frameworkVersion, null, false, "frameworkVersion");
            this.frameworkVersion = sanitizeString(this.frameworkVersion, null, false, "frameworkVersion");
            var _loc_6:* = sanitizeString(this.pluginName, null, false, "pluginName");
            this.pluginName = sanitizeString(this.pluginName, null, false, "pluginName");
            var _loc_6:* = sanitizeString(this.pluginVersion, null, false, "pluginVersion");
            this.pluginVersion = sanitizeString(this.pluginVersion, null, false, "pluginVersion");
            var _loc_6:* = sanitizeString(this.viewerId, null, false, "viewerId");
            this.viewerId = sanitizeString(this.viewerId, null, false, "viewerId");
            var _loc_6:* = sanitizeString(this.deviceId, null, false, "deviceId");
            this.deviceId = sanitizeString(this.deviceId, null, false, "deviceId");
            var _loc_6:* = sanitizeString(this.deviceType, null, false, "deviceType");
            this.deviceType = sanitizeString(this.deviceType, null, false, "deviceType");
            var _loc_6:* = sanitizeString(this.playerName, null, false, "playerName");
            this.playerName = sanitizeString(this.playerName, null, false, "playerName");
            if (this._tags == null)
            {
                var _loc_6:* = new DictionaryCS();
                this._tags = new DictionaryCS();
            }
            var _loc_1:* = new ListCS();
            for each (_loc_8 in this._tags.Keys)
            {
                
                _loc_2 = _loc_7[_loc_6];
                _loc_1.Add(_loc_2);
            }
            for each (_loc_8 in _loc_1.Values)
            {
                
                _loc_3 = _loc_7[_loc_6];
                _loc_4 = sanitizeString(_loc_3, "null", false, "tag name");
                _loc_5 = sanitizeString(this._tags.GetValue(_loc_3), "null", false, "value for tag \'" + _loc_3.toString() + "\'");
                if (_loc_4 != _loc_3)
                {
                    this._tags.Remove(_loc_3);
                    this._tags.SetValue(_loc_4, _loc_5);
                }
                if (_loc_5 != this._tags.GetValue(_loc_4))
                {
                    this._tags.SetValue(_loc_4, _loc_5);
                }
            }
            if (this.assetName != Utils.GLOBAL_SESSION_ASSET_NAME)
            {
                Trace.Info("ConvivaContentInfo:", "user input=" + this.toTrace());
            }
            return;
        }// end function

        private function populateValidationConstants() : void
        {
            var _loc_1:* = new ListCS();
            this._validCdnNames = new ListCS();
            this._validCdnNames.Add(CDN_NAME_AKAMAI);
            this._validCdnNames.Add(CDN_NAME_AMAZON);
            this._validCdnNames.Add(CDN_NAME_ATT);
            this._validCdnNames.Add(CDN_NAME_BITGRAVITY);
            this._validCdnNames.Add(CDN_NAME_BT);
            this._validCdnNames.Add(CDN_NAME_CDNETWORKS);
            this._validCdnNames.Add(CDN_NAME_CHINACACHE);
            this._validCdnNames.Add(CDN_NAME_EDGECAST);
            this._validCdnNames.Add(CDN_NAME_HIGHWINDS);
            this._validCdnNames.Add(CDN_NAME_INTERNAP);
            this._validCdnNames.Add(CDN_NAME_LEVEL3);
            this._validCdnNames.Add(CDN_NAME_LIMELIGHT);
            this._validCdnNames.Add(CDN_NAME_OCTOSHAPE);
            this._validCdnNames.Add(CDN_NAME_SWARMCAST);
            this._validCdnNames.Add(CDN_NAME_VELOCIX);
            this._validCdnNames.Add(CDN_NAME_TELEFONICA);
            this._validCdnNames.Add(CDN_NAME_MICROSOFT);
            this._validCdnNames.Add(CDN_NAME_INHOUSE);
            this._validCdnNames.Add(CDN_NAME_OTHER);
            var _loc_1:* = new ListCS();
            this._validDeviceTypes = new ListCS();
            this._validDeviceTypes.Add(DEVICE_TYPE_CONSOLE);
            this._validDeviceTypes.Add(DEVICE_TYPE_MOBILE);
            this._validDeviceTypes.Add(DEVICE_TYPE_PC);
            this._validDeviceTypes.Add(DEVICE_TYPE_SET_TOP_BOX);
            return;
        }// end function

        private function toTrace() : String
        {
            var _loc_2:Object = null;
            var _loc_1:String = "{";
            var _loc_3:* = _loc_1 + ("\n  useStrictChecking=" + this._useStrictChecking.toString());
            _loc_1 = _loc_1 + ("\n  useStrictChecking=" + this._useStrictChecking.toString());
            var _loc_3:* = _loc_1 + ("\n  assetName=\"" + this._assetName + "\"");
            _loc_1 = _loc_1 + ("\n  assetName=\"" + this._assetName + "\"");
            var _loc_3:* = _loc_1 + ("\n  bitrate=" + this._bitrate.toString());
            _loc_1 = _loc_1 + ("\n  bitrate=" + this._bitrate.toString());
            var _loc_3:* = _loc_1 + ("\n  isLive=" + this._isLive.toString());
            _loc_1 = _loc_1 + ("\n  isLive=" + this._isLive.toString());
            var _loc_3:* = _loc_1 + ("\n  monitoringOptions=" + CrossLangUtils.TraceDict(this._monitoringOptions));
            _loc_1 = _loc_1 + ("\n  monitoringOptions=" + CrossLangUtils.TraceDict(this._monitoringOptions));
            var _loc_3:* = _loc_1 + ("\n  resourceSelection=" + this._resourceSelection.toString());
            _loc_1 = _loc_1 + ("\n  resourceSelection=" + this._resourceSelection.toString());
            var _loc_3:* = _loc_1 + ("\n  candidateResources=" + CrossLangUtils.TraceList(this._candidateResources));
            _loc_1 = _loc_1 + ("\n  candidateResources=" + CrossLangUtils.TraceList(this._candidateResources));
            var _loc_3:* = _loc_1 + ("\n  cdnName=" + (this.cdnName != null ? ("\"" + this.cdnName + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  cdnName=" + (this.cdnName != null ? ("\"" + this.cdnName + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  resource=" + (this.resource != null ? ("\"" + this.resource + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  resource=" + (this.resource != null ? ("\"" + this.resource + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  resourceStateOverride=" + (this.resourceStateOverride != null ? ("\"" + this.resourceStateOverride + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  resourceStateOverride=" + (this.resourceStateOverride != null ? ("\"" + this.resourceStateOverride + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  ovppName=" + (this.ovppName != null ? ("\"" + this.ovppName + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  ovppName=" + (this.ovppName != null ? ("\"" + this.ovppName + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  frameworkName=" + (this.frameworkName != null ? ("\"" + this.frameworkName + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  frameworkName=" + (this.frameworkName != null ? ("\"" + this.frameworkName + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  frameworkVersion=" + (this.frameworkVersion != null ? ("\"" + this.frameworkVersion + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  frameworkVersion=" + (this.frameworkVersion != null ? ("\"" + this.frameworkVersion + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  pluginName=" + (this.pluginName != null ? ("\"" + this.pluginName + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  pluginName=" + (this.pluginName != null ? ("\"" + this.pluginName + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  pluginVersion=" + (this.pluginVersion != null ? ("\"" + this.pluginVersion + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  pluginVersion=" + (this.pluginVersion != null ? ("\"" + this.pluginVersion + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  streamUrl=" + (this.streamUrl != null ? ("\"" + this.streamUrl + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  streamUrl=" + (this.streamUrl != null ? ("\"" + this.streamUrl + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  viewerId=" + (this.viewerId != null ? ("\"" + this.viewerId + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  viewerId=" + (this.viewerId != null ? ("\"" + this.viewerId + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  deviceId=" + (this.deviceId != null ? ("\"" + this.deviceId + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  deviceId=" + (this.deviceId != null ? ("\"" + this.deviceId + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  deviceType=" + (this.deviceType != null ? ("\"" + this.deviceType + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  deviceType=" + (this.deviceType != null ? ("\"" + this.deviceType + "\"") : ("null")));
            var _loc_3:* = _loc_1 + ("\n  playerName=" + (this.playerName != null ? ("\"" + this.playerName + "\"") : ("null")));
            _loc_1 = _loc_1 + ("\n  playerName=" + (this.playerName != null ? ("\"" + this.playerName + "\"") : ("null")));
            if (this._mbrInfo != null)
            {
                var _loc_3:* = _loc_1 + ("\n  mbrInfo={" + this._mbrInfo.debugString() + " }");
                _loc_1 = _loc_1 + ("\n  mbrInfo={" + this._mbrInfo.debugString() + " }");
            }
            else
            {
                var _loc_3:* = _loc_1 + "\n  mbrInfo=null ";
                _loc_1 = _loc_1 + "\n  mbrInfo=null ";
            }
            var _loc_3:* = _loc_1 + ("\n  start=" + this._start);
            _loc_1 = _loc_1 + ("\n  start=" + this._start);
            var _loc_3:* = _loc_1 + ("\n  len=" + this._len);
            _loc_1 = _loc_1 + ("\n  len=" + this._len);
            var _loc_3:* = _loc_1 + ("\n  reset=" + this._reset);
            _loc_1 = _loc_1 + ("\n  reset=" + this._reset);
            var _loc_3:* = _loc_1 + ("\n  tags=" + CrossLangUtils.TraceDict(this._tags));
            _loc_1 = _loc_1 + ("\n  tags=" + CrossLangUtils.TraceDict(this._tags));
            var _loc_3:* = _loc_1 + "\n  rtmpPortSearchList=[";
            _loc_1 = _loc_1 + "\n  rtmpPortSearchList=[";
            for each (_loc_5 in this._rtmpPortSearchList)
            {
                
                _loc_2 = _loc_4[_loc_3];
                var _loc_5:* = _loc_1 + (CrossLangUtils.TraceDict(_loc_2) + ", ");
                _loc_1 = _loc_1 + (CrossLangUtils.TraceDict(_loc_2) + ", ");
            }
            var _loc_3:* = _loc_1 + "]";
            _loc_1 = _loc_1 + "]";
            var _loc_3:* = _loc_1 + ("\n  rtmpPortSearchMaxTimeMs=" + this._rtmpPortSearchMaxTimeMs);
            _loc_1 = _loc_1 + ("\n  rtmpPortSearchMaxTimeMs=" + this._rtmpPortSearchMaxTimeMs);
            var _loc_3:* = _loc_1 + ("\n  rtmpPortSearchEquivalenceWindowMs=" + this._rtmpPortSearchEquivalenceWindowMs);
            _loc_1 = _loc_1 + ("\n  rtmpPortSearchEquivalenceWindowMs=" + this._rtmpPortSearchEquivalenceWindowMs);
            var _loc_3:* = _loc_1 + ("\n  authAtConnect=" + this._authAtConnect);
            _loc_1 = _loc_1 + ("\n  authAtConnect=" + this._authAtConnect);
            var _loc_3:* = _loc_1 + ("\n  authMode=" + this._authMode);
            _loc_1 = _loc_1 + ("\n  authMode=" + this._authMode);
            var _loc_3:* = _loc_1 + ("\n  mediaType=" + this._mediaType + "\n}; ");
            _loc_1 = _loc_1 + ("\n  mediaType=" + this._mediaType + "\n}; ");
            return _loc_1;
        }// end function

        public function printContentInfo(param1:int) : void
        {
            Trace.Info("ConvivaContentInfo[" + param1 + "]", "user input=" + this.toTrace());
            return;
        }// end function

        public function checkValidity(param1:Function, param2:Function, param3:Boolean) : void
        {
            if (!this.useStrictChecking)
            {
                var _loc_4:* = param2;
                param1 = param2;
            }
            if (this.assetName == null)
            {
                this.param1("assetName is null.", null);
            }
            if (this.assetName == DEFAULT_ASSET_NAME)
            {
                this.param1("assetName is null.", null);
            }
            if (this.deviceType != null && !this._validDeviceTypes.Contains(this.deviceType))
            {
                this.param1("deviceType is not one of the recognized device types enumerated in ConvivaContentInfo.", "Actual value: " + this.deviceType + " .");
            }
            if (param3)
            {
                if (this.resourceStateOverride != null)
                {
                    this.param2("resourceStateOverride is in use.  CDN-based metrics may be inaccurate.", null);
                }
                else
                {
                    if (this.cdnName == null)
                    {
                        this.param1("cdnName is null.", null);
                    }
                    if (this.cdnName != null && !this._validCdnNames.Contains(this.cdnName))
                    {
                        this.param1("cdnName is not one of the recognized CDN names enumerated in ConvivaContentInfo.", "Actual value: " + this.cdnName + " .");
                    }
                    if (this.cdnName == CDN_NAME_OTHER)
                    {
                        this.param2("cdnName is CDN_NAME_OTHER.  If possible, please specify a real CDN.", null);
                    }
                }
                if (this.streamUrl == null)
                {
                    this.param1("streamUrl is null.", null);
                }
                if (this.bitrate < 0)
                {
                    this.param1("bitrate is negative.", "Actual value: " + this.bitrate + " .");
                }
                if (this.mbrInfo != null)
                {
                    this.param1("mbrInfo is set, but this integration does not support that field.", null);
                }
            }
            return;
        }// end function

        public function canHandleManifest() : Boolean
        {
            return this._mediaType == Utils.MEDIA_TYPE_HTTP_ZERI_STREAM || this._mediaType == Utils.MEDIA_TYPE_HTTP_CHUNK_STREAM || this._mediaType == Utils.MEDIA_TYPE_RTMP_SMIL_STREAM || this._mediaType == Utils.MEDIA_TYPE_RTMP_F4M_STREAM || this._ovppName == OVPP_NAME_KALTURA;
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

        public static function createInfoForLightSession(param1:String) : ConvivaContentInfo
        {
            return new ConvivaContentInfo(param1, null, null);
        }// end function

        private static function sanitizeString(param1:Object, param2:String, param3:Boolean, param4:String) : String
        {
            if (param1 == null && param2 == null)
            {
                return null;
            }
            if (param1 == null)
            {
                Utils.ReportErrorContinue("ConvivaContentInfo: " + param4 + " is null", false);
                param1 = param2;
            }
            var _loc_5:* = param1.toString();
            _loc_5 = Lang.StringTrim(_loc_5);
            if (param3 && _loc_5 == Utils.GLOBAL_SESSION_ASSET_NAME)
            {
            }
            else if (_loc_5.length >= 3 && Lang.StringSubstring(_loc_5, 0, 3) == "c3.")
            {
                Utils.ReportErrorContinue("ConvivaContentInfo: " + param4 + " is reserved IGNORE:" + _loc_5, false);
                _loc_5 = "_" + _loc_5;
            }
            if (_loc_5.length > MAX_PARAMETER_LENGTH)
            {
                Utils.ReportErrorContinue("ConvivaContentInfo: " + param4 + " is too long IGNORE:" + _loc_5, false);
                _loc_5 = Lang.StringSubstring(_loc_5, 0, MAX_PARAMETER_LENGTH);
            }
            return _loc_5;
        }// end function

        public static function clone(param1:Object) : ConvivaContentInfo
        {
            var _loc_2:String = null;
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            _loc_2 = Reflection.HasProperty("assetName", param1) ? (Reflection.GetMember("assetName", param1, null) as String) : (Reflection.GetMember("objectId", param1, null) as String);
            _loc_3 = Reflection.GetMember("tags", param1, null);
            _loc_4 = Reflection.GetMember("candidateResources", param1, null);
            var _loc_5:* = new ConvivaContentInfo(_loc_2, _loc_4, _loc_3);
            new ConvivaContentInfo(_loc_2, _loc_4, _loc_3).useStrictChecking = Boolean(Reflection.GetMember("useStrictChecking", param1, false));
            _loc_5.monitoringOptions = Reflection.GetMember("monitoringOptions", param1, null);
            _loc_5.resourceSelection = Boolean(Reflection.GetMember("resourceSelection", param1, _loc_5.resourceSelection));
            _loc_5.isLive = Boolean(Reflection.GetMember("isLive", param1, _loc_5.isLive));
            _loc_5.bitrate = Number(Reflection.GetMember("bitrate", param1, _loc_5.bitrate));
            _loc_5.cdnName = Reflection.GetMember("cdnName", param1, _loc_5.cdnName) as String;
            _loc_5.resource = Reflection.GetMember("resource", param1, _loc_5.resource) as String;
            _loc_5.resourceStateOverride = Reflection.GetMember("resourceStateOverride", param1, _loc_5.resourceStateOverride) as String;
            _loc_5.ovppName = Reflection.GetMember("ovppName", param1, _loc_5.ovppName) as String;
            _loc_5.frameworkName = Reflection.GetMember("frameworkName", param1, _loc_5.frameworkName) as String;
            _loc_5.frameworkVersion = Reflection.GetMember("frameworkVersion", param1, _loc_5.frameworkVersion) as String;
            _loc_5.pluginName = Reflection.GetMember("pluginName", param1, _loc_5.pluginName) as String;
            _loc_5.pluginVersion = Reflection.GetMember("pluginVersion", param1, _loc_5.pluginVersion) as String;
            _loc_5.streamUrl = Reflection.GetMember("streamUrl", param1, _loc_5.streamUrl) as String;
            _loc_5.viewerId = Reflection.GetMember("viewerId", param1, _loc_5.viewerId) as String;
            _loc_5.deviceId = Reflection.GetMember("deviceId", param1, _loc_5.deviceId) as String;
            _loc_5.deviceType = Reflection.GetMember("deviceType", param1, _loc_5.deviceType) as String;
            _loc_5.playerName = Reflection.GetMember("playerName", param1, _loc_5.playerName) as String;
            var _loc_6:* = Reflection.GetMember("mbrInfo", param1, null);
            if (Reflection.GetMember("mbrInfo", param1, null) != null)
            {
                _loc_5.mbrInfo = new MbrStreamInfo();
                _loc_5.mbrInfo.setDeep(_loc_6);
            }
            else
            {
                _loc_5.mbrInfo = null;
            }
            _loc_5.urlGenerator = Reflection.GetMember("urlGenerator", param1, _loc_5.urlGenerator) as Function;
            _loc_5.start = int(Reflection.GetMember("start", param1, _loc_5.start));
            _loc_5.len = int(Reflection.GetMember("len", param1, _loc_5.len));
            _loc_5.reset = int(Reflection.GetMember("reset", param1, _loc_5.reset));
            _loc_5.rtmpPortSearchList = Reflection.GetMember("rtmpPortSearchList", param1, _loc_5.rtmpPortSearchList) as Array;
            _loc_5.rtmpPortSearchMaxTimeMs = Number(Reflection.GetMember("rtmpPortSearchMaxTimeMs", param1, _loc_5.rtmpPortSearchMaxTimeMs));
            _loc_5.rtmpPortSearchEquivalenceWindowMs = Number(Reflection.GetMember("rtmpPortSearchEquivalenceWindowMs", param1, _loc_5.rtmpPortSearchEquivalenceWindowMs));
            _loc_5.authAtConnect = Boolean(Reflection.GetMember("authAtConnect", param1, _loc_5.authAtConnect));
            _loc_5.authMode = int(Reflection.GetMember("authMode", param1, _loc_5.authMode));
            _loc_5.mediaType = Reflection.GetMember("mediaType", param1, _loc_5.mediaType) as String;
            _loc_5.sanitizeData();
            return _loc_5;
        }// end function

    }
}
