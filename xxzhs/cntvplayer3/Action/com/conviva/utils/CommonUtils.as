package com.conviva.utils
{

    public class CommonUtils extends Object
    {

        public function CommonUtils()
        {
            return;
        }// end function

        public static function splitUrlForNetConnection(param1:String) : Array
        {
            var url:* = param1;
            var splitUrl:* = function (param1:String) : Array
            {
                var _loc_2:Number = NaN;
                _loc_2 = param1.lastIndexOf("#");
                if (_loc_2 > 0)
                {
                    return [param1.substr(0, _loc_2), param1.substr((_loc_2 + 1))];
                }
                _loc_2 = param1.lastIndexOf("mp4:");
                if (_loc_2 > 0)
                {
                    return [param1.substr(0, (_loc_2 - 1)), param1.substr(_loc_2)];
                }
                _loc_2 = param1.lastIndexOf("/");
                return [param1.substr(0, _loc_2), param1.substr((_loc_2 + 1))];
            }// end function
            ;
            var splitPlayPart:* = function (param1:String) : Array
            {
                var _loc_2:* = param1.indexOf("?");
                if (_loc_2 != -1)
                {
                    return [param1.substr(0, _loc_2), param1.substr(_loc_2)];
                }
                return [param1, ""];
            }// end function
            ;
            if (url.substr(0, 4) != "rtmp")
            {
                return [null, url];
            }
            var urlComponents:* = CommonUtils.splitUrl(url);
            var connectPart:* = urlComponents[0];
            var playPart:* = urlComponents[1];
            var playPartComponents:* = CommonUtils.splitPlayPart(playPart);
            var streamName:* = playPartComponents[0];
            var playQuery:* = playPartComponents[1];
            if (streamName.match(/^.*.flv$""^.*.flv$/))
            {
                streamName = streamName.substring(0, streamName.lastIndexOf(".flv"));
            }
            else if (streamName.match(/^.*.mp4$""^.*.mp4$/) && streamName.substr(0, 4) != "mp4:")
            {
                streamName = streamName.substring(0, streamName.lastIndexOf(".mp4"));
                streamName = "mp4:" + streamName;
            }
            return [connectPart, streamName + playQuery];
        }// end function

        public static function splitUrlForOvpConnection(param1:String) : Array
        {
            var _loc_6:Array = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:* = CommonUtils.splitUrlForNetConnection(param1);
            if (CommonUtils.splitUrlForNetConnection(param1))
            {
                if (_loc_5[0] != null)
                {
                    _loc_2 = (_loc_5[0] as String).split("://")[1];
                    _loc_6 = _loc_2.split(":");
                    if (_loc_6.length > 1)
                    {
                        _loc_7 = _loc_6[0];
                        _loc_3 = _loc_6[1].split("/")[0];
                        _loc_8 = _loc_6[1].split("/")[1];
                        _loc_2 = _loc_7 + "/" + _loc_8;
                    }
                }
                _loc_4 = _loc_5[1];
            }
            else
            {
                _loc_4 = param1;
            }
            return [_loc_2, _loc_3, _loc_4];
        }// end function

        public static function random() : Number
        {
            var _loc_1:* = uint(Math.random() * Number(2147483648));
            var _loc_2:* = uint(Math.random() * Number(2147483648));
            return Number(uint(_loc_1 + 2 * _loc_2)) / Number(4294967296);
        }// end function

        public static function formatTime(param1:Date) : String
        {
            var _loc_2:String = "";
            _loc_2 = _loc_2 + (formatUint(param1.hours, 2) + ":");
            _loc_2 = _loc_2 + (formatUint(param1.minutes, 2) + ":");
            _loc_2 = _loc_2 + (formatUint(param1.seconds, 2) + ".");
            _loc_2 = _loc_2 + formatUint(param1.milliseconds, 3);
            return _loc_2;
        }// end function

        public static function formatUint(param1:uint, param2:uint, param3:String = "0") : String
        {
            var _loc_4:* = param1.toString();
            if (param3 == null || param3 == "")
            {
                param3 = "0";
            }
            while (_loc_4.length < param2)
            {
                
                _loc_4 = param3 + _loc_4;
            }
            return _loc_4;
        }// end function

    }
}
