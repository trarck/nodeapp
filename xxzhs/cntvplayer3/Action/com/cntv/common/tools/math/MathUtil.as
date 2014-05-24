package com.cntv.common.tools.math
{

    public class MathUtil extends Object
    {

        public function MathUtil()
        {
            return;
        }// end function

        public static function roundToDecimal(param1:Number, param2:int) : Number
        {
            var _loc_3:* = Math.pow(10, param2);
            var _loc_4:* = param1 * _loc_3;
            _loc_4 = Math.round(_loc_4);
            _loc_4 = _loc_4 / _loc_3;
            return _loc_4;
        }// end function

        public static function avg(param1:Array) : int
        {
            var _loc_6:int = 0;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            while (_loc_5 < param1.length)
            {
                
                _loc_6 = int(param1[_loc_5]);
                _loc_3 = Math.min(_loc_3, _loc_6);
                _loc_4 = Math.max(_loc_4, _loc_6);
                _loc_2 = _loc_2 + _loc_6;
                _loc_5++;
            }
            return (_loc_2 - _loc_3 - _loc_4) / (param1.length - 2);
        }// end function

        public static function avgExp(param1:Array, param2:Number) : MathAvgVO
        {
            var _loc_9:Number = NaN;
            var _loc_3:Number = 0;
            var _loc_4:* = int.MAX_VALUE;
            var _loc_5:Number = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            while (_loc_7 < param1.length)
            {
                
                _loc_9 = Number(param1[_loc_7]);
                if (_loc_9 == param2)
                {
                    _loc_6++;
                }
                else
                {
                    _loc_4 = Math.min(_loc_4, _loc_9);
                    _loc_5 = Math.max(_loc_5, _loc_9);
                    _loc_3 = _loc_3 + _loc_9;
                }
                _loc_7++;
            }
            var _loc_8:* = new MathAvgVO();
            new MathAvgVO().va = roundToDecimal(_loc_3 / (param1.length - _loc_6), 2);
            _loc_8.vi = roundToDecimal(_loc_4, 2);
            _loc_8.vx = roundToDecimal(_loc_5, 2);
            return _loc_8;
        }// end function

        public static function getRangeRandomInt(param1:int, param2:int) : int
        {
            var _loc_3:* = Math.random() * param2 + param1;
            return _loc_3;
        }// end function

    }
}
