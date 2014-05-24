package com.cntv.common.tools.array
{

    public class ArrayUtils extends Object
    {

        public function ArrayUtils()
        {
            return;
        }// end function

        public static function getObjectByKey(param1:Array, param2:String, param3:String) : Object
        {
            var _loc_4:int = 0;
            while (_loc_4 < param1.length)
            {
                
                if (param1[_loc_4][param2] == param3)
                {
                    return param1[_loc_4];
                }
                _loc_4++;
            }
            return null;
        }// end function

        public static function setObjectByKey(param1:Array, param2:String, param3:String, param4:Object) : Array
        {
            var _loc_5:int = 0;
            var _loc_6:Boolean = false;
            while (_loc_5 < param1.length)
            {
                
                if (param1[_loc_5][param2] == param3)
                {
                    param1[_loc_5] = param4;
                    _loc_6 = true;
                    break;
                }
                _loc_5++;
            }
            if (!_loc_6)
            {
                param1.push(param4);
            }
            _loc_5 = 0;
            while (_loc_5 < param1.length)
            {
                
                _loc_5++;
            }
            return param1;
        }// end function

        public static function removeObjectByKey(param1:Array, param2:String, param3:String) : Array
        {
            var _loc_4:int = 0;
            var _loc_5:Boolean = false;
            while (_loc_4 < param1.length)
            {
                
                if (param1[_loc_4][param2] == param3)
                {
                    param1.splice(_loc_4, 1);
                    break;
                }
                _loc_4++;
            }
            return param1;
        }// end function

    }
}
