package com.conviva.utils
{

    public class CrossLangUtils extends Object
    {

        public function CrossLangUtils()
        {
            return;
        }// end function

        public static function TraceDict(param1:Object) : String
        {
            var _loc_4:String = null;
            if (param1 == null)
            {
                return "null";
            }
            var _loc_2:* = Lang.DictionaryFromRepr(param1);
            var _loc_3:String = "{";
            for each (_loc_4 in _loc_2.Keys)
            {
                
                _loc_3 = _loc_3 + (_loc_4 + ":\"" + _loc_2.GetValue(_loc_4) + "\" ");
            }
            _loc_3 = _loc_3 + "}";
            return _loc_3;
        }// end function

        public static function TraceList(param1:ListCS) : String
        {
            if (param1 == null)
            {
                return "null";
            }
            var _loc_2:String = "[";
            var _loc_3:int = 0;
            while (_loc_3 < param1.Count)
            {
                
                _loc_2 = _loc_2 + param1.GetValue(_loc_3);
                if (_loc_3 < (param1.Count - 1))
                {
                    _loc_2 = _loc_2 + ", ";
                }
                _loc_3++;
            }
            _loc_2 = _loc_2 + "]";
            return _loc_2;
        }// end function

    }
}
