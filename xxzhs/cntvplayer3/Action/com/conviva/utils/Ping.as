package com.conviva.utils
{

    public class Ping extends Object
    {
        private static var _pingUrl:String = null;
        private static var defaultPingUrl:String = "http://livepass.conviva.com";
        private static var _pingId:uint = 0;
        private static var _whileSendingPing:Boolean = false;
        private static var _extraFields:DictionaryCS;
        private static var _hasSentDic:DictionaryCS;
        private static var _dispatcher:PingEventDispatcher = null;
        private static var _loader:DataLoader;
        private static var _outstanding:ListCS;
        private static var _pingHistory:ListCS;
        private static const PING_MIN_INTERVAL_MS:int = 1000;
        private static var pingMinIntervalMs:int = 1000;
        private static const PING_WINDOW_SIZE_MS:int = 60000;
        private static var pingWindowSizeMs:int = 60000;
        private static const PING_MAX_IN_WINDOW:int = 3;
        private static var pingMaxInWindow:int = 3;
        private static const PING_MAX_OUTSTANDING:int = 10;
        private static var _pingWaiter:Object;
        public static const _PING_ID:String = "pingid";

        public function Ping()
        {
            Utils.ReportError("Ping: is an all-static class");
            return;
        }// end function

        public static function Init(param1:String, param2:uint, param3:DictionaryCS) : void
        {
            var _loc_5:Object = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            _pingId = param2;
            _pingUrl = param1;
            _hasSentDic = new DictionaryCS();
            _extraFields = param3;
            _whileSendingPing = false;
            _outstanding = new ListCS();
            _pingHistory = new ListCS();
            _dispatcher = null;
            _pingWaiter = null;
            var _loc_4:* = Lang.StringIndexOf(_pingUrl, "?");
            if (Lang.StringIndexOf(_pingUrl, "?") < 0)
            {
                _pingUrl = _pingUrl + "/ping.ping?";
            }
            else
            {
                _pingUrl = Lang.StringSubstring(_pingUrl, 0, _loc_4) + "/ping.ping?" + Lang.StringSubstring(_pingUrl, (_loc_4 + 1)) + "&";
            }
            if (_pingId == 0)
            {
                try
                {
                    _loc_5 = PersistentConfig.SafeGetPropElse(_PING_ID, _pingId);
                    _loc_6 = _loc_5 as String;
                    _pingId = Lang.parseUInt(_loc_6);
                }
                catch (e:Error)
                {
                }
            }
            if (_pingId == 0)
            {
                _pingId = Utils.NextRandom32();
                if (_pingId == 0)
                {
                    var _loc_9:* = _pingId + 1;
                    _pingId = _loc_9;
                }
            }
            PersistentConfig.SetProperty(_PING_ID, _pingId.toString());
            _pingUrl = _pingUrl + ("uuid=" + _pingId.toString());
            _pingUrl = _pingUrl + ("&ver=" + LivePassVersion.versionStr);
            if (_extraFields != null)
            {
                for each (_loc_7 in _extraFields.Keys)
                {
                    
                    _pingUrl = _pingUrl + ("&" + Utils.UrlEncodeString(_loc_7) + "=" + Utils.UrlEncodeString(_extraFields.GetValue(_loc_7)));
                }
            }
            return;
        }// end function

        public static function Cleanup() : void
        {
            if (_pingWaiter != null)
            {
                ProtectedTimer.CancelDelayedAction(_pingWaiter);
                _pingWaiter = null;
            }
            _pingUrl = null;
            _dispatcher = null;
            if (_loader)
            {
                _loader.Cleanup();
                _loader = null;
            }
            _outstanding = null;
            _pingHistory = null;
            return;
        }// end function

        public static function Send(param1:String) : void
        {
            SendWithRate(param1, 100);
            return;
        }// end function

        public static function SendWithRate(param1:String, param2:int) : void
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            if (param2 < 0)
            {
                param2 = 0;
            }
            if (param2 > 100)
            {
                param2 = 100;
            }
            if (_pingUrl == null)
            {
                _loc_3 = "";
                if (Lang.StringContains(_loc_3, "localhost:8888"))
                {
                    defaultPingUrl = _loc_3;
                }
                Init(defaultPingUrl, 0, null);
            }
            Trace.Error("Ping", param1);
            param1 = "d=" + Utils.UrlEncodeString(param1);
            if (_hasSentDic.ContainsKey(param1))
            {
                return;
            }
            if (Utils.NextRandom() * 100 >= param2 * LivePassConfigLoader.PingRatePercent / 100)
            {
                _hasSentDic.SetValue(param1, true);
                return;
            }
            if (_hasSentDic.Count > 2000)
            {
                _loc_4 = "d=" + Utils.UrlEncodeString("2000 PING!!!!");
                if (!_hasSentDic.ContainsKey(_loc_4))
                {
                    _hasSentDic.SetValue(_loc_4, true);
                    queuePing(_loc_4);
                }
                return;
            }
            _hasSentDic.SetValue(param1, true);
            queuePing(param1);
            return;
        }// end function

        private static function queuePing(param1:String) : void
        {
            var _loc_2:String = null;
            for each (_loc_2 in _outstanding.Values)
            {
                
                if (_loc_2 == param1)
                {
                    return;
                }
            }
            if (_whileSendingPing)
            {
                return;
            }
            if (_outstanding.Count < PING_MAX_OUTSTANDING)
            {
                _outstanding.Add(param1);
            }
            else
            {
                return;
            }
            if (_pingWaiter == null)
            {
                sendPing();
            }
            return;
        }// end function

        private static function sendPing() : void
        {
            var now:Number;
            var msg:String;
            var toWait:int;
            if (_outstanding == null || _pingHistory == null)
            {
                return;
            }
            if (_outstanding.Count > 0)
            {
                now = ProtectedTimer.GetEpochMilliseconds();
                msg = _outstanding.GetValue(0);
                _outstanding.RemoveAt(0);
                _whileSendingPing = true;
                if (_loader)
                {
                    _loader.Cleanup();
                }
                _loader = new DataLoader(_pingUrl + "&" + msg, function (param1:Error, param2:DataLoader)
            {
                if (param1 != null)
                {
                    Trace.Error("Ping", "Failed to send ping: " + param1.toString());
                }
                return;
            }// end function
            , null, null);
                _pingHistory.Add(now);
                toWait;
                if (_pingHistory.Count >= pingMaxInWindow)
                {
                    _pingHistory.RemoveRange(0, _pingHistory.Count - pingMaxInWindow + 1);
                    toWait = int(_pingHistory.GetValue(0) + pingWindowSizeMs - now);
                }
                if (toWait <= pingMinIntervalMs)
                {
                    toWait = pingMinIntervalMs;
                }
                _pingWaiter = ProtectedTimer.DelayAction(sendPing, toWait, "Ping.wait");
            }
            else
            {
                _pingWaiter = null;
            }
            _whileSendingPing = false;
            return;
        }// end function

        public static function get Id() : uint
        {
            return _pingId;
        }// end function

        public static function set Id(param1:uint) : void
        {
            _pingId = param1;
            try
            {
                PersistentConfig.SetProperty(_PING_ID, param1.toString());
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        static function get outstandingPings() : ListCS
        {
            return _outstanding;
        }// end function

        static function get MIN_PING_INTERVAL_MS() : int
        {
            return pingMinIntervalMs;
        }// end function

        static function set MIN_PING_INTERVAL_MS(param1:int) : void
        {
            pingMinIntervalMs = param1;
            return;
        }// end function

        static function get WINDOW_SIZE_MS() : int
        {
            return pingWindowSizeMs;
        }// end function

        static function set WINDOW_SIZE_MS(param1:int) : void
        {
            pingWindowSizeMs = param1;
            return;
        }// end function

        static function get MAX_IN_WINDOW() : int
        {
            return pingMaxInWindow;
        }// end function

        static function set MAX_IN_WINDOW(param1:int) : void
        {
            pingMaxInWindow = param1;
            return;
        }// end function

    }
}
