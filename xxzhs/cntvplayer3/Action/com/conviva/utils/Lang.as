package com.conviva.utils
{

    public class Lang extends Object
    {
        private static var intRegex:RegExp = new RegExp("^[+-]?[0-9]+$");
        private static var uintRegex:RegExp = new RegExp("^[0-9]+$");
        private static var doubleRegex:RegExp = new RegExp("^[+-]?[0-9]*\\.?[0-9]+([eE][+-]?[0-9]+)?$");

        public function Lang()
        {
            return;
        }// end function

        public static function StringIndexOf(param1:String, param2:String, param3:int = 0) : int
        {
            return param1.indexOf(param2, param3);
        }// end function

        public static function StringSubstring(param1:String, param2:int, param3:int = 2147483647) : String
        {
            if (param2 < 0 || param2 >= param1.length || param3 != 2147483647 && (param3 < 0 || param2 + param3 > param1.length))
            {
                throw new Error("ArgumentOutOfRange");
            }
            if (param3 == 2147483647)
            {
                return param1.substr(param2);
            }
            return param1.substr(param2, param3);
        }// end function

        public static function StringGetChar(param1:String, param2:int) : String
        {
            return param1.charAt(param2);
        }// end function

        public static function StringContains(param1:String, param2:String) : Boolean
        {
            return param1.indexOf(param2) >= 0;
        }// end function

        public static function StringStartsWith(param1:String, param2:String) : Boolean
        {
            return param1.indexOf(param2) == 0;
        }// end function

        public static function StringSplit(param1:String, param2:String) : ArrayCS
        {
            return ArrayCS.FromRepr(param1.split(param2));
        }// end function

        public static function StringTrim(param1:String) : String
        {
            var _loc_2:* = param1.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (param1.charAt(_loc_3) != " " && param1.charAt(_loc_3) != "\t" && param1.charAt(_loc_3) != "\n")
                {
                    break;
                }
                _loc_3++;
            }
            if (_loc_3 == _loc_2)
            {
                return "";
            }
            if (_loc_3 > 0)
            {
                param1 = param1.substr(_loc_3);
                _loc_2 = _loc_2 - _loc_3;
            }
            _loc_3 = _loc_2 - 1;
            while (_loc_3 >= 0)
            {
                
                if (param1.charAt(_loc_3) != " " && param1.charAt(_loc_3) != "\t" && param1.charAt(_loc_3) != "\n")
                {
                    break;
                }
                _loc_3 = _loc_3 - 1;
            }
            if (_loc_3 < (_loc_2 - 1))
            {
                return param1.substr(0, (_loc_3 + 1));
            }
            return param1;
        }// end function

        public static function StringCompareTo(param1:String, param2:String) : int
        {
            if (param1 == null)
            {
                if (param2 == null)
                {
                    return 0;
                }
                return -1;
            }
            if (param2 == null)
            {
                return 1;
            }
            if (param1 < param2)
            {
                return -1;
            }
            if (param1 == param2)
            {
                return 0;
            }
            return 1;
        }// end function

        public static function ToString(param1:Object) : String
        {
            return param1.toString();
        }// end function

        public static function StringReplace(param1:String, param2:String, param3:String) : String
        {
            var _loc_5:int = 0;
            if (param2 == null || param2.length == 0 || param3 == null)
            {
                throw new Error("ArgumentOutOfRange");
            }
            var _loc_4:* = param1.indexOf(param2);
            if (param1.indexOf(param2) >= 0)
            {
                _loc_5 = param2.length;
                return param1.substr(0, _loc_4) + param3 + StringReplace(param1.substr(_loc_4 + _loc_5), param2, param3);
            }
            return param1;
        }// end function

        public static function StringLastIndexOf(param1:String, param2:String) : int
        {
            return param1.lastIndexOf(param2);
        }// end function

        public static function ArrayFromRepr(param1:Array) : ArrayCS
        {
            return ArrayCS.FromRepr(param1);
        }// end function

        public static function ArrayToRepr(param1:ArrayCS) : Array
        {
            if (param1 == null)
            {
                return null;
            }
            return param1.ToRepr();
        }// end function

        public static function ListFromRepr(param1:Array) : ListCS
        {
            return ListCS.FromRepr(param1);
        }// end function

        public static function ListToRepr(param1:ListCS) : Array
        {
            if (param1 == null)
            {
                return null;
            }
            return param1.ToRepr();
        }// end function

        public static function DictionaryFromRepr(param1:Object) : DictionaryCS
        {
            return DictionaryCS.FromRepr(param1);
        }// end function

        public static function StringDictionaryToRepr(param1:DictionaryCS) : Object
        {
            if (param1 == null)
            {
                return null;
            }
            return param1.ToObject();
        }// end function

        public static function StringFromRepr(param1:String) : String
        {
            return param1;
        }// end function

        public static function StringToXml(param1:String) : XML
        {
            var str:* = param1;
            try
            {
                return new XML(str);
            }
            catch (e:TypeError)
            {
            }
            return null;
        }// end function

        public static function XmlToString(param1:XML) : String
        {
            return param1.toXMLString();
        }// end function

        public static function StringToLower(param1:String) : String
        {
            return param1.toLowerCase();
        }// end function

        public static function StringToInt(param1:String) : int
        {
            return Lang.int(param1);
        }// end function

        public static function parseInt(param1:String) : int
        {
            parseChecker(param1, intRegex, "int");
            return int(param1);
        }// end function

        public static function parseUInt(param1:String) : uint
        {
            parseChecker(param1, uintRegex, "uint");
            return uint(param1);
        }// end function

        public static function parseDouble(param1:String) : Number
        {
            parseChecker(param1, doubleRegex, "double");
            return Number(param1);
        }// end function

        private static function parseChecker(param1:String, param2:RegExp, param3:String) : void
        {
            if (!param2.test(param1))
            {
                throw new Error("Invalid string for " + param3 + ": " + param1);
            }
            return;
        }// end function

    }
}
