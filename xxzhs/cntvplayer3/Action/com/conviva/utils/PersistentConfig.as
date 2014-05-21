package com.conviva.utils
{
    import flash.events.*;
    import flash.net.*;

    public class PersistentConfig extends Object
    {
        private static var _shObj:SharedObject = null;
        private static var _data:Object = null;
        private static var _flushOK:Boolean = true;

        public function PersistentConfig()
        {
            Utils.ReportError("PersistentConfig is an all-static class");
            return;
        }// end function

        public static function Init(param1:Boolean, param2:Function) : void
        {
            var disallowPersistence:* = param1;
            var cont:* = param2;
            var initDisabled:* = function () : void
            {
                _shObj = null;
                _data = {};
                _flushOK = false;
                return;
            }// end function
            ;
            if (disallowPersistence)
            {
                PersistentConfig.initDisabled();
            }
            else
            {
                try
                {
                    _shObj = SharedObject.getLocal("com.conviva.livePass", "/");
                    _shObj.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                    _data = _shObj.data;
                }
                catch (e:Error)
                {
                    PersistentConfig.initDisabled();
                }
            }
            PersistentConfig.cont();
            return;
        }// end function

        public static function Cleanup() : void
        {
            safeFlush();
            if (_shObj != null)
            {
                _shObj.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                _shObj = null;
            }
            _data = null;
            _flushOK = true;
            return;
        }// end function

        public static function HasProperty(param1:String) : Boolean
        {
            return _data.hasOwnProperty(param1);
        }// end function

        public static function GetProperty(param1:String) : Object
        {
            return _data[param1];
        }// end function

        public static function SafeGetPropElse(param1:String, param2:Object) : Object
        {
            if (_data.hasOwnProperty(param1))
            {
                return _data[param1];
            }
            return param2;
        }// end function

        public static function SetProperty(param1:String, param2:Object) : void
        {
            _data[param1] = param2;
            safeFlush();
            return;
        }// end function

        public static function DeleteProperty(param1:String) : Boolean
        {
            var _loc_2:* = _data.hasOwnProperty(param1);
            delete _data[param1];
            safeFlush();
            return _loc_2;
        }// end function

        static function netStatusHandler(event:NetStatusEvent) : void
        {
            var event:* = event;
            Utils.RunProtected(function () : void
            {
                switch(event.info.code)
                {
                    case "SharedObject.Flush.Success":
                    {
                        _flushOK = true;
                        ;
                    }
                    case "SharedObject.Flush.Failed":
                    {
                        _flushOK = false;
                        ;
                    }
                    default:
                    {
                        ;
                    }
                }
                return;
            }// end function
            , "PersistentConfig.netStatusHandler()");
            return;
        }// end function

        static function safeFlush() : Boolean
        {
            if (_shObj == null)
            {
                return true;
            }
            var res:String;
            try
            {
                res = _shObj.flush();
                _flushOK = res == SharedObjectFlushStatus.FLUSHED;
            }
            catch (e:Error)
            {
                _flushOK = false;
            }
            return _flushOK;
        }// end function

        public static function get FlushOK() : Boolean
        {
            return _flushOK;
        }// end function

        public static function HasPendingAction() : Boolean
        {
            return false;
        }// end function

        static function Init() : void
        {
            Init(true, function () : void
            {
                return;
            }// end function
            );
            return;
        }// end function

    }
}
