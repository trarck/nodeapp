package com.conviva.pdl.utils
{
    import flash.events.*;
    import flash.net.*;

    public class ViewHistory extends Object
    {
        public static const BANDWIDTH_HISTORY:String = "BandwidthHistory";
        public static const PHT_HISTORY:String = "PlayHeadTimeHistory";
        private static var _shObj:SharedObject = null;
        private static var _data:Object = null;
        private static var _flushOK:Boolean = true;
        private static var _inited:Boolean = false;
        private static var _bwHistorySize:int = 5;
        private static var _phtNumber:int = 10;
        private static var _bwInfo:Object = null;
        private static var _phtInfo:Object = null;
        private static var _bwCount:int = 0;
        private static var _phtCount:int = 0;

        public function ViewHistory()
        {
            trace("BwHistory is a static class");
            return;
        }// end function

        static function netStatusHandler(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "SharedObject.Flush.Success":
                {
                    _flushOK = true;
                    break;
                }
                case "SharedObject.Flush.Failed":
                {
                    _flushOK = false;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public static function init() : void
        {
            var p:String;
            var q:String;
            if (!_inited)
            {
                try
                {
                    _shObj = SharedObject.getLocal("com.conviva.pdl", "/");
                    _shObj.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                    _data = _shObj.data;
                }
                catch (e:Error)
                {
                    _shObj = null;
                    _data = {};
                    _flushOK = false;
                }
                if (_data.hasOwnProperty(BANDWIDTH_HISTORY))
                {
                    _bwInfo = _data[BANDWIDTH_HISTORY];
                }
                else
                {
                    _bwInfo = null;
                }
                if (_bwInfo != null)
                {
                    var _loc_2:int = 0;
                    var _loc_3:* = _bwInfo;
                    while (_loc_3 in _loc_2)
                    {
                        
                        p = _loc_3[_loc_2];
                        var _loc_5:* = _bwCount + 1;
                        _bwCount = _loc_5;
                    }
                }
                if (_data.hasOwnProperty(PHT_HISTORY))
                {
                    _phtInfo = _data[PHT_HISTORY];
                }
                else
                {
                    _phtInfo = null;
                }
                if (_phtInfo != null)
                {
                    var _loc_2:int = 0;
                    var _loc_3:* = _phtInfo;
                    while (_loc_3 in _loc_2)
                    {
                        
                        q = _loc_3[_loc_2];
                        var _loc_5:* = _phtCount + 1;
                        _phtCount = _loc_5;
                    }
                }
                _inited = true;
            }
            return;
        }// end function

        public static function cleanup() : void
        {
            _inited = false;
            _bwInfo = null;
            _bwCount = 0;
            _phtInfo = null;
            _phtCount = 0;
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

        public static function updateBw(param1:String, param2:Number) : void
        {
            if (!_inited)
            {
                init();
            }
            if (_bwInfo == null)
            {
                _bwInfo = new Object();
            }
            if (!_bwInfo[param1])
            {
                if (_bwCount >= _bwHistorySize)
                {
                    removeOldestBwElement();
                }
                else
                {
                    var _loc_5:* = _bwCount + 1;
                    _bwCount = _loc_5;
                }
            }
            var _loc_3:* = new Date().getTime();
            _bwInfo[param1] = {bw:param2, timeMs:_loc_3};
            _data[BANDWIDTH_HISTORY] = _bwInfo;
            safeFlush();
            return;
        }// end function

        public static function getBw(param1:String) : Number
        {
            if (!_inited)
            {
                init();
            }
            return _bwInfo && _bwInfo[param1] ? (_bwInfo[param1].bw) : (0);
        }// end function

        public static function updatePht(param1:String, param2:Number) : void
        {
            if (!_inited)
            {
                init();
            }
            if (_phtInfo == null)
            {
                _phtInfo = new Object();
            }
            if (!_phtInfo[param1])
            {
                if (_phtCount >= _phtNumber)
                {
                    removeOldestPhtElement();
                }
                else
                {
                    var _loc_5:* = _phtCount + 1;
                    _phtCount = _loc_5;
                }
            }
            var _loc_3:* = new Date().getTime();
            _phtInfo[param1] = {pht:param2, timeMs:_loc_3};
            _data[PHT_HISTORY] = _phtInfo;
            safeFlush();
            return;
        }// end function

        public static function getPht(param1:String) : Number
        {
            if (!_inited)
            {
                init();
            }
            return _phtInfo && _phtInfo[param1] ? (_phtInfo[param1].pht) : (0);
        }// end function

        private static function removeOldestBwElement() : void
        {
            var _loc_3:String = null;
            var _loc_1:Number = 0;
            var _loc_2:String = "";
            for (_loc_3 in _bwInfo)
            {
                
                if (_loc_1 == 0 || _bwInfo[_loc_3].timeMs < _loc_1)
                {
                    _loc_2 = _loc_3;
                    _loc_1 = _bwInfo[_loc_3].timeMs;
                }
            }
            delete _bwInfo[_loc_2];
            return;
        }// end function

        private static function removeOldestPhtElement() : void
        {
            var _loc_3:String = null;
            var _loc_1:Number = 0;
            var _loc_2:String = "";
            for (_loc_3 in _phtInfo)
            {
                
                if (_loc_1 == 0 || _phtInfo[_loc_3].timeMs < _loc_1)
                {
                    _loc_2 = _loc_3;
                    _loc_1 = _bwInfo[_loc_3].timeMs;
                }
            }
            delete _phtInfo[_loc_2];
            return;
        }// end function

    }
}
