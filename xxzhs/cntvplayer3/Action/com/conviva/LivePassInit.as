package com.conviva
{
    import com.conviva.internal_access.*;
    import com.conviva.utils.*;
    import flash.utils.*;

    public class LivePassInit extends Object
    {
        private static var _moduleLoader:ClassLoader = null;
        private static var _configLoader:LivePassConfigLoader = null;
        private static var _serviceUrl:String = null;
        private static var _initDoneCbk:Function = null;
        private static var _customerId:String;
        private static var _currentConfig:String = null;
        private static var _livePassReadyActions:ListCS;
        private static var _debugStats:DictionaryCS;
        private static const LAST_USED_MODULES:String = "lastSwfUrls";
        private static var _moduleInstance:Object;
        private static var _globalMetricsSession:ConvivaMetricsSession;
        public static var disablePersistentStorage:Boolean = false;
        public static var sPlayerTypeOverride:String = null;
        private static var _lastModuleURL:String = null;
        private static var _noModuleLoading:Boolean = false;
        static var Testing:Boolean = false;
        private static var LivePassModuleMainClass:Class = null;

        public function LivePassInit()
        {
            Utils.ReportError("LivePassInit: is a static class");
            return;
        }// end function

        public static function Init(param1:String, param2:String, param3:Function) : void
        {
            var serviceUrl:* = param1;
            var customerId:* = param2;
            var initDoneCbk:* = param3;
            _serviceUrl = serviceUrl;
            _customerId = customerId;
            _initDoneCbk = initDoneCbk;
            _moduleInstance = null;
            _globalMetricsSession = null;
            _currentConfig = null;
            _lastModuleURL = null;
            _livePassReadyActions = new ListCS();
            _debugStats = new DictionaryCS();
            StreamSwitch.StaticInit();
            PersistentConfig.Init(disablePersistentStorage, function ()
            {
                InitAfterPersistentStorage(serviceUrl, customerId, initDoneCbk);
                return;
            }// end function
            );
            return;
        }// end function

        private static function InitAfterPersistentStorage(param1:String, param2:String, param3:Function) : void
        {
            var moduleUrl:String;
            var serviceUrl:* = param1;
            var customerId:* = param2;
            var initDoneCbk:* = param3;
            Uuid.Init();
            var extraPingFields:* = DictionaryCS.New("cust", customerId);
            Ping.Init(serviceUrl, uint(Uuid.uuid.GetValue(0)), extraPingFields);
            Trace.Init();
            Trace.Info("LivePassInit", "serviceUrl=" + serviceUrl);
            _configLoader = LivePassConfigLoader.CreateOneTimeLoader(serviceUrl, customerId, LivePassConfigLoaded, function (param1:Error)
            {
                if (_initDoneCbk != null)
                {
                    _initDoneCbk(new ConvivaNotification(ConvivaNotification.ERROR_LOAD_CONFIGURATION, "Error loading module: " + param1.toString(), null));
                }
                return;
            }// end function
            );
            _configLoader.GatherStats(_debugStats);
            var lastModuleUrls:DictionaryCS;
            try
            {
                lastModuleUrls = Lang.DictionaryFromRepr(PersistentConfig.SafeGetPropElse(LAST_USED_MODULES, lastModuleUrls));
            }
            catch (e:Error)
            {
            }
            if (_noModuleLoading)
            {
                CheckInitDone();
                return;
            }
            if (lastModuleUrls != null && lastModuleUrls.ContainsKey(serviceUrl))
            {
                moduleUrl = lastModuleUrls.GetValue(serviceUrl);
                StartLoadingModule(moduleUrl);
                _lastModuleURL = moduleUrl;
            }
            return;
        }// end function

        public static function Cleanup() : void
        {
            if (_globalMetricsSession != null)
            {
                _globalMetricsSession.cleanup();
                _globalMetricsSession = null;
            }
            if (_moduleInstance != null)
            {
                Reflection.InvokeMethod("cleanup", _moduleInstance);
                _moduleInstance = null;
            }
            if (_moduleLoader != null)
            {
                _moduleLoader.Cleanup();
                _moduleLoader = null;
            }
            if (_configLoader != null)
            {
                _configLoader.Cleanup();
                _configLoader = null;
            }
            _initDoneCbk = null;
            _serviceUrl = null;
            _currentConfig = null;
            _livePassReadyActions = null;
            _lastModuleURL = null;
            StreamSwitch.StaticCleanup();
            Ping.Cleanup();
            PersistentConfig.Cleanup();
            disablePersistentStorage = false;
            return;
        }// end function

        private static function StartLoadingModule(param1:String) : void
        {
            _debugStats.SetValue("LivePass.moduleUrl", param1);
            Trace.Info("LivePassInit", "loading module " + param1);
            _moduleLoader = new ClassLoader(param1, ModuleLoadFinished, 0);
            return;
        }// end function

        private static function ModuleLoadFinished(param1:Error, param2:Object) : void
        {
            var _loc_3:DictionaryCS = null;
            if (param1 == null)
            {
                _loc_3 = PersistentConfig.SafeGetPropElse(LAST_USED_MODULES, null) as DictionaryCS;
                if (_loc_3 == null)
                {
                    _loc_3 = new DictionaryCS();
                }
                _loc_3.SetValue(_serviceUrl, _moduleLoader.ModuleUrl);
                PersistentConfig.SetProperty(LAST_USED_MODULES, Lang.StringDictionaryToRepr(_loc_3));
                CheckInitDone();
            }
            else
            {
                if (_currentConfig == null)
                {
                    return;
                }
                _debugStats.SetValue("LivePass.moduleLoadError", param1.toString());
                Utils.ReportErrorContinue("Error: failed to load the module " + _moduleLoader.ModuleUrl, true);
                if (_initDoneCbk != null)
                {
                    _initDoneCbk(new ConvivaNotification(ConvivaNotification.ERROR_LOAD_MODULE, param1.toString(), null));
                }
                Cleanup();
            }
            return;
        }// end function

        private static function LivePassConfigLoaded() : void
        {
            if (_currentConfig != null)
            {
                return;
            }
            _currentConfig = _configLoader.CurrentConfig;
            if (_noModuleLoading)
            {
                Trace.Info("LivePassInit", "Not loading module; using built-in");
                CheckInitDone();
                return;
            }
            if (_moduleLoader != null)
            {
                if (CheckModuleUrl(_moduleLoader.ModuleUrl))
                {
                    CheckInitDone();
                    return;
                }
                _moduleLoader.Cleanup();
                _moduleLoader = null;
            }
            StartLoadingModule(PickModuleUrl());
            return;
        }// end function

        private static function PickModuleUrl() : String
        {
            var _loc_1:* = _configLoader.AllModuleUrls();
            Utils.Assert(_loc_1.Count > 0, "have module url");
            return _loc_1.GetValue(0);
        }// end function

        private static function CheckModuleUrl(param1:String) : Boolean
        {
            var _loc_2:* = _configLoader.AllModuleUrls();
            Utils.Assert(_loc_2.Count > 0, "have module url");
            return _loc_2.IndexOf(param1) >= 0;
        }// end function

        private static function CheckInitDone() : void
        {
            if (_currentConfig == null)
            {
                return;
            }
            if (!_noModuleLoading)
            {
                if (_moduleLoader == null || !_moduleLoader.Loaded)
                {
                    return;
                }
            }
            _moduleInstance = Reflection.CreateInstance(.TESTAPI::GetModuleClass("LivePassModuleMain", "ConvivaLivePass", ""));
            var _loc_1:* = new DictionaryCS();
            _loc_1.SetValue("loaderVersionMajor", LivePassVersion.VERSION_MAJOR);
            _loc_1.SetValue("loaderVersionMinor", LivePassVersion.VERSION_MINOR);
            _loc_1.SetValue("loaderVersionRelease", LivePassVersion.VERSION_RELEASE);
            _loc_1.SetValue("loaderVersionSvn", LivePassVersion.VERSION_SVN);
            _loc_1.SetValue("traceSenderId", Trace.senderId);
            _loc_1.SetValue("disablePersistentStorage", disablePersistentStorage);
            if (TESTAPI::Testing)
            {
                _loc_1.SetValue("TESTAPI_Testing", TESTAPI::Testing);
            }
            if (sPlayerTypeOverride != null)
            {
                _loc_1.SetValue("playerTypeOverride", sPlayerTypeOverride);
            }
            if (NoModuleLoading)
            {
                _loc_1.SetValue("noModuleLoading", NoModuleLoading);
            }
            _loc_1.SetValue("loaderNotificationCallback", ReportNotificationApi);
            Reflection.InvokeMethod("setModuleOptions", _moduleInstance, Lang.StringDictionaryToRepr(_loc_1));
            Reflection.InvokeMethod("init", _moduleInstance, _serviceUrl, _customerId, _currentConfig);
            Trace.Info("LivePassInit", "complete");
            GetGlobalMetrics();
            NotifyLivePassReady();
            return;
        }// end function

        static function GetGlobalMetrics() : ICustomMetrics
        {
            if (_globalMetricsSession != null)
            {
                return _globalMetricsSession.metrics;
            }
            _globalMetricsSession = new ConvivaMetricsSession(Utils.GLOBAL_SESSION_ASSET_NAME);
            return _globalMetricsSession.metrics;
        }// end function

        static function ReportNotificationApi(param1:Object) : void
        {
            if (_initDoneCbk == null || param1 == null)
            {
                return;
            }
            var _loc_2:* = Reflection.Clone(param1) as ConvivaNotification;
            if (_loc_2 == null)
            {
                return;
            }
            if (_initDoneCbk != null)
            {
                _initDoneCbk(_loc_2);
            }
            return;
        }// end function

        public static function InvokeWhenReady(param1:String, param2:Function) : void
        {
            if (LivePass.ready)
            {
                Utils.RunProtected(param2, "InvokeWhenReady." + param1);
            }
            else if (_livePassReadyActions != null)
            {
                _livePassReadyActions.Add(param2);
            }
            return;
        }// end function

        public static function InvokeWhenReadyTimeout(param1:String, param2:Function, param3:int) : void
        {
            var what:* = param1;
            var callback:* = param2;
            var timeoutMs:* = param3;
            if (!LivePass.pending)
            {
                LivePassInit.callback();
                return;
            }
            _livePassReadyActions.Add(callback);
            if (timeoutMs > 0)
            {
                ProtectedTimer.DelayAction(function ()
            {
                CheckNotifierTimeout(callback);
                return;
            }// end function
            , timeoutMs, "LPInit.invokeWhenReady");
            }
            return;
        }// end function

        private static function CheckNotifierTimeout(param1:Function) : void
        {
            if (_livePassReadyActions == null)
            {
                return;
            }
            var _loc_2:* = _livePassReadyActions.IndexOf(param1);
            if (_loc_2 >= 0)
            {
                _livePassReadyActions.RemoveAt(_loc_2);
                LivePassInit.param1();
            }
            return;
        }// end function

        static function NotifyLivePassReady() : void
        {
            var _loc_1:ListCS = null;
            var _loc_2:Function = null;
            LivePass.setReady();
            if (_livePassReadyActions != null && _livePassReadyActions.Count > 0)
            {
                _loc_1 = _livePassReadyActions;
                _livePassReadyActions = new ListCS();
                for each (_loc_2 in _loc_1.Values)
                {
                    
                    Utils.RunProtected(_loc_2, "LivePassInit.NotifyLivePassReady");
                }
            }
            if (_initDoneCbk != null)
            {
                _initDoneCbk(new ConvivaNotification(ConvivaNotification.SUCCESS_LIVEPASS_READY, "Conviva LivePass is ready", null));
            }
            return;
        }// end function

        public static function get Module() : Object
        {
            return _moduleInstance;
        }// end function

        static function GetModuleClass(param1:String, param2:String, param3:String) : Class
        {
            if (param3 != "")
            {
                param1 = param3 + "." + param1;
            }
            if (!_noModuleLoading)
            {
                if (_moduleLoader == null || !_moduleLoader.Loaded || _currentConfig == null)
                {
                    return null;
                }
            }
            if (_noModuleLoading)
            {
                if (LivePassModuleMainClass != null)
                {
                    if (param1 == "LivePassModuleMain")
                    {
                        return LivePassModuleMainClass;
                    }
                    return getDefinitionByName(param1) as Class;
                }
            }
            return _moduleLoader.GetType(param1);
        }// end function

        static function get NoModuleLoading() : Boolean
        {
            return _noModuleLoading;
        }// end function

        static function set NoModuleLoading(param1:Boolean) : void
        {
            _noModuleLoading = param1;
            return;
        }// end function

        public static function get NoModuleLoading() : Boolean
        {
            return _noModuleLoading;
        }// end function

        static function GetLastModuleURL() : String
        {
            return _lastModuleURL;
        }// end function

        static function set LivePassModuleMainInstance(param1:Object) : void
        {
            LivePassModuleMainClass = Reflection.GetType(param1);
            return;
        }// end function

        static function GatherStats(param1:DictionaryCS) : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            if (_configLoader != null)
            {
                _configLoader.GatherStats(param1);
            }
            if (_moduleInstance != null)
            {
                _loc_2 = new Object();
                Reflection.InvokeMethod("gatherStats", _moduleInstance, _loc_2);
                for (_loc_3 in _loc_2)
                {
                    
                    param1.SetValue(_loc_3, _loc_2[_loc_3]);
                }
            }
            return;
        }// end function

    }
}
