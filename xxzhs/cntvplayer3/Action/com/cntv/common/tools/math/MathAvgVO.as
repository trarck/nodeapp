package com.cntv.common.tools.math
{

    public class MathAvgVO extends Object
    {
        public var va:Number;
        public var vi:Number;
        public var vx:Number;

        public function MathAvgVO()
        {
            return;
        }// end function

        public function toString() : String
        {
            return this.va + "-" + this.vi + "-" + this.vx;
        }// end function

    }
}
