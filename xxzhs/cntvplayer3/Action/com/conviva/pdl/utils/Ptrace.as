package com.conviva.pdl.utils
{

    public class Ptrace extends Object
    {
        private static var _info2Count:int = -1;
        private static var _info3Count:int = -1;

        public function Ptrace()
        {
            return;
        }// end function

        public static function pinfo(param1:String) : void
        {
            var _loc_2:* = new Date();
            trace("[PDL" + _loc_2.getTime() / 1000 + "]" + param1);
            return;
        }// end function

        public static function pinfo2(param1:String, param2:int = 0) : void
        {
            var _loc_3:* = new Date();
            if (_info2Count == -1)
            {
                _info2Count = param2;
            }
            if (--_info2Count == 0)
            {
                trace("[PDL" + _loc_3.getTime() / 1000 + "]" + param1);
            }
            return;
        }// end function

        public static function pinfo3(param1:String, param2:int = 0) : void
        {
            var _loc_3:* = new Date();
            if (_info3Count == -1)
            {
                _info3Count = param2;
            }
            if (--_info3Count == 0)
            {
                trace("[PDL" + _loc_3.getTime() / 1000 + "]" + param1);
            }
            return;
        }// end function

    }
}
