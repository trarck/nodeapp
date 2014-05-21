package com.cntv.common.tools.string
{

    public class StringUtils extends Object
    {

        public function StringUtils()
        {
            return;
        }// end function

        public static function trim(param1:String) : String
        {
            if (param1 == null)
            {
                return "";
            }
            return param1.replace(/^\s+|\s+$""^\s+|\s+$/g, "");
        }// end function

        public static function remove(param1:String, param2:String, param3:Boolean = true) : String
        {
            if (param1 == null)
            {
                return "";
            }
            var _loc_4:* = escapePattern(param2);
            var _loc_5:* = !param3 ? ("ig") : ("g");
            return param1.replace(new RegExp(_loc_4, _loc_5), "");
        }// end function

        private static function escapePattern(param1:String) : String
        {
            return param1.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\\)""(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, "\\$1");
        }// end function

        public static function replaceP2pUrl(param1:String) : String
        {
            var _loc_2:* = param1.split("://");
            param1 = "http://127.0.0.1:4092/" + _loc_2[1];
            return param1;
        }// end function

        public static function fillTo2Byte(param1:int) : String
        {
            var _loc_2:String = "";
            if (param1 < 10)
            {
                _loc_2 = "a" + param1;
            }
            else
            {
                _loc_2 = param1.toString();
            }
            return _loc_2;
        }// end function

        public static function stringToNumber(param1:String) : Number
        {
            var _loc_2:* = param1;
            while (_loc_2.indexOf("0") == 0 && _loc_2.length > 1)
            {
                
                _loc_2 = _loc_2.slice(1);
            }
            return Number(_loc_2);
        }// end function

    }
}
