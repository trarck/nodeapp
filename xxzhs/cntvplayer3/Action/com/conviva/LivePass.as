package com.conviva
{
    import com.conviva.internal_access.*;
    import com.conviva.utils.*;

    public class LivePass extends Object
    {
        private static var _currentState:int = STATE_NOT_INITIALIZED;
        private static var _statsTimer:ProtectedTimer;
        private static var _initHandler:Function;
        private static var _sess:DictionaryCS = new DictionaryCS();
        private static const STATE_READY:int = 0;
        private static const STATE_NOT_INITIALIZED:int = -1;
        private static const STATE_INIT_PENDING:int = -2;
        private static const STATE_ERROR:int = -3;
        static var overrideServiceUrl:String = null;

        public function LivePass()
        {
            return;
        }// end function

        public static function init(param1:String, param2:String, param3:Function, param4:Object = null) : void
        {
            var serviceUrl:* = param1;
            var customerId:* = param2;
            var callback:* = param3;
            var optionsObsolete:* = param4;
            if (TESTAPI::overrideServiceUrl != null && TESTAPI::overrideServiceUrl != "")
            {
                serviceUrl = TESTAPI::overrideServiceUrl;
            }
            Trace.Info("LivePass", "Initializing " + LivePassVersion.versionLogo);
            Utils.RunProtected(function ()
            {
                if (_currentState == STATE_INIT_PENDING || _currentState == STATE_READY)
                {
                    return;
                }
                Trace.senderName = "LivePass";
                _initHandler = callback;
                _currentState = STATE_INIT_PENDING;
                _statsTimer = null;
                LivePassInit.Init(serviceUrl, customerId, ourInitHandler);
                return;
            }// end function
            , "LivePass.init");
            return;
        }// end function

        public static function cleanup() : void
        {
            Utils.RunProtected(function ()
            {
                var _loc_1:Object = null;
                for each (_loc_1 in _sess.Keys)
                {
                    
                    cleanupMonitoringSession(_loc_1);
                }
                _sess.Clear();
                if (_statsTimer != null)
                {
                    _statsTimer.Cleanup();
                    _statsTimer = null;
                }
                _initHandler = null;
                LivePassInit.Cleanup();
                _currentState = STATE_NOT_INITIALIZED;
                return;
            }// end function
            , "LivePass.cleanup");
            return;
        }// end function

        public static function createMonitoringSession(param1:Object, param2:String, param3:Object, param4:Object) : ConvivaLightSession
        {
            var streamer:* = param1;
            var contentName:* = param2;
            var tags:* = param3;
            var options:* = param4;
            return Utils.RunProtectedResult(function ()
            {
                var _loc_1:* = new ConvivaContentInfo(contentName, new ListCS(), tags);
                _loc_1.monitoringOptions = options;
                return createSessionWithCci(streamer, _loc_1);
            }// end function
            , "LivePass.createMonitoringSession", null);
        }// end function

        public static function createSession(param1:Object, param2:ConvivaContentInfo) : ConvivaLightSession
        {
            param2.useStrictChecking = true;
            return createSessionWithCci(param1, param2);
        }// end function

        private static function createSessionWithCci(param1:Object, param2:ConvivaContentInfo) : ConvivaLightSession
        {
            var streamer:* = param1;
            var cci:* = param2;
            return Utils.RunProtectedResult(function ()
            {
                if (streamer != null && getMonitoringSession(streamer) != null)
                {
                    Trace.Error("LivePass", "createSessionWithCci called twice for the same streamer");
                    return null;
                }
                ConvivaLightSession.SetJoinStartTimeContentInfo(cci);
                var _loc_1:* = new ConvivaLightSession(cci);
                if (streamer != null)
                {
                    addStreamer(streamer, _loc_1);
                }
                _loc_1.startMonitor(streamer, null);
                return _loc_1;
            }// end function
            , "LivePass.createSessionWithCci", null);
        }// end function

        public static function getMonitoringSession(param1:Object) : ConvivaLightSession
        {
            var _loc_2:* = getStreamerKey(param1, false, 0);
            if (_sess.ContainsKey(_loc_2))
            {
                return _sess.GetValue(_loc_2);
            }
            return null;
        }// end function

        public static function cleanupMonitoringSession(param1:Object) : void
        {
            var streamer:* = param1;
            Utils.RunProtected(function ()
            {
                if (streamer == null || _sess == null)
                {
                    Trace.Error("LivePass", "cleanupMonitoringSession called before createMonitoringSession");
                    return;
                }
                var _loc_1:* = getMonitoringSession(streamer);
                if (_loc_1 != null)
                {
                    _loc_1.cleanup();
                    removeStreamer(streamer);
                }
                return;
            }// end function
            , "LivePass.cleanupMonitoringSession");
            return;
        }// end function

        private static function ourInitHandler(param1:ConvivaNotification) : void
        {
            var note:* = param1;
            if (note.code == ConvivaNotification.SUCCESS_LIVEPASS_READY)
            {
                _currentState = STATE_READY;
                _statsTimer = new ProtectedTimer(1000, function ()
            {
                Trace.Stats(stats);
                return;
            }// end function
            , "LP.Stats");
            }
            else if (note.code == ConvivaNotification.ERROR_LOAD_CONFIGURATION || note.code == ConvivaNotification.ERROR_LOAD_MODULE)
            {
                _currentState = STATE_ERROR;
            }
            if (_initHandler != null)
            {
                Utils.RunProtected(function ()
            {
                _initHandler(note);
                return;
            }// end function
            , "LivePass notifier");
            }
            return;
        }// end function

        public static function get ready() : Boolean
        {
            return _currentState == STATE_READY;
        }// end function

        static function setReady() : void
        {
            _currentState = STATE_READY;
            return;
        }// end function

        public static function get pending() : Boolean
        {
            return _currentState == STATE_INIT_PENDING;
        }// end function

        public static function get version() : String
        {
            return LivePassVersion.versionStr;
        }// end function

        public static function get stats() : Object
        {
            var _loc_1:* = new DictionaryCS();
            _loc_1.SetValue("LivePass.version", LivePassVersion.versionStr);
            LivePassInit.GatherStats(_loc_1);
            return Lang.StringDictionaryToRepr(_loc_1);
        }// end function

        public static function get metrics() : ICustomMetrics
        {
            return LivePassInit.GetGlobalMetrics();
        }// end function

        public static function toggleTraces(param1:Boolean) : void
        {
            var b:* = param1;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("toggleTraces", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Reflection.InvokeMethod("toggleTraces", _loc_1, b);
                    Trace.traceToConsole = b;
                    return;
                }// end function
                );
                return;
            }// end function
            , "LivePass.toggleTraces");
            return;
        }// end function

        public static function disablePersistentStorage() : void
        {
            LivePassInit.disablePersistentStorage = true;
            return;
        }// end function

        private static function getStreamerKey(param1:Object, param2:Boolean, param3:int) : Object
        {
            return param1;
        }// end function

        private static function addStreamer(param1:Object, param2:ConvivaLightSession) : void
        {
            var _loc_3:* = getStreamerKey(param1, true, param2.id);
            _sess.SetValue(_loc_3, param2);
            return;
        }// end function

        private static function removeStreamer(param1:Object) : void
        {
            var _loc_2:* = getStreamerKey(param1, false, 0);
            _sess.Remove(_loc_2);
            return;
        }// end function

    }
}
