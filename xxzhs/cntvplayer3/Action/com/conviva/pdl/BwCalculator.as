package com.conviva.pdl
{

    public class BwCalculator extends Object
    {
        private var _sampleArray:Array = null;
        private var _preBytes:Number = 0;
        private var _preTime:Number = 0;
        public static const LOADING:int = 1;
        public static const NOT_LOADING:int = 0;
        public static const UNKNOW:int = 2;
        private static const SAMPLE_NUM:int = 19;
        public static const INVALID_BW:int = -1;

        public function BwCalculator()
        {
            this._sampleArray = [];
            return;
        }// end function

        public function get bwKbps() : Number
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_1:Number = 0;
            var _loc_2:Number = 0;
            if (this._sampleArray.length < 3)
            {
                return INVALID_BW;
            }
            var _loc_3:int = 0;
            while (_loc_3 < this._sampleArray.length)
            {
                
                if (_loc_3 > 0 && _loc_3 < (this._sampleArray.length - 1))
                {
                    _loc_4 = this._sampleArray[(_loc_3 - 1)].t == 0 ? (0) : (this._sampleArray[(_loc_3 - 1)].b / this._sampleArray[(_loc_3 - 1)].t);
                    _loc_5 = this._sampleArray[_loc_3].t == 0 ? (0) : (this._sampleArray[_loc_3].b / this._sampleArray[_loc_3].t);
                    _loc_6 = this._sampleArray[(_loc_3 + 1)].b == 0 ? (0) : (this._sampleArray[(_loc_3 + 1)].b / this._sampleArray[(_loc_3 + 1)].t);
                    if (_loc_4 == 0 && _loc_5 > 0 && _loc_5 < _loc_6 || _loc_6 == 0 && _loc_5 > 0 && _loc_4 > _loc_5)
                    {
                        ;
                    }
                }
                _loc_1 = _loc_1 + this._sampleArray[_loc_3].b;
                _loc_2 = _loc_2 + this._sampleArray[_loc_3].t;
                _loc_3++;
            }
            if (_loc_2 > 0)
            {
                return _loc_1 * 8 / _loc_2;
            }
            return INVALID_BW;
        }// end function

        public function addData(param1:Number, param2:int, param3:Number) : void
        {
            if (this._preBytes == 0 || this._preTime == param3)
            {
                this._preBytes = param1;
                this._preTime = param3;
                return;
            }
            var _loc_4:* = param1 - this._preBytes;
            var _loc_5:* = param3 - this._preTime;
            this._preBytes = param1;
            this._preTime = param3;
            var _loc_6:* = this._sampleArray.length;
            if (param2 == LOADING)
            {
                if (_loc_4 > 0)
                {
                    this._sampleArray.push({b:_loc_4, t:_loc_5});
                    if (this._sampleArray.length > SAMPLE_NUM)
                    {
                        this._sampleArray.splice(0, 1);
                    }
                }
                else if (_loc_6 > 0)
                {
                    this._sampleArray[(_loc_6 - 1)].t = this._sampleArray[(_loc_6 - 1)].t + _loc_5;
                }
            }
            else if (param2 == UNKNOW)
            {
                if (_loc_4 > 0)
                {
                    this._sampleArray.push({b:_loc_4, t:_loc_5});
                    if (this._sampleArray.length > SAMPLE_NUM)
                    {
                        this._sampleArray.splice(0, 1);
                    }
                }
                else
                {
                    this.inputOneNotReadingSample();
                }
            }
            else
            {
                this.inputOneNotReadingSample();
            }
            return;
        }// end function

        private function inputOneNotReadingSample() : void
        {
            var _loc_1:* = this._sampleArray.length;
            if (_loc_1 > 0)
            {
                if (this._sampleArray[(_loc_1 - 1)].t != 0)
                {
                    this._sampleArray.push({b:0, t:0});
                    if (this._sampleArray.length > SAMPLE_NUM)
                    {
                        this._sampleArray.splice(0, 1);
                    }
                }
            }
            else
            {
                this._sampleArray.push({b:0, t:0});
            }
            return;
        }// end function

        public function samples() : String
        {
            var _loc_1:* = this._sampleArray.length;
            var _loc_2:String = "";
            var _loc_3:int = 0;
            while (_loc_3 < _loc_1)
            {
                
                if (this._sampleArray[_loc_3].t != 0)
                {
                    _loc_2 = _loc_2 + (" " + this._sampleArray[_loc_3].b + "/" + this._sampleArray[_loc_3].t + "=" + (this._sampleArray[_loc_3].b * 8 / this._sampleArray[_loc_3].t).toString());
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function cleanup() : void
        {
            this._preBytes = 0;
            this._preTime = 0;
            this._sampleArray = [];
            return;
        }// end function

    }
}
