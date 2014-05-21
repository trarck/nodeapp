package com.conviva.pdl
{
    import com.conviva.pdl.utils.*;

    public class BitrateLock extends Object
    {
        private var _bitrate:Number;
        private var _count:int;
        private var _unlockTime:Number;
        public static const LOCK_STEP_MS:Number = 30000;

        public function BitrateLock(param1:Number, param2:int, param3:Number)
        {
            this._bitrate = param1;
            this._count = param2;
            this._unlockTime = param3;
            return;
        }// end function

        public function isLocked(param1:Number) : Boolean
        {
            return this._unlockTime > param1;
        }// end function

        public function lock(param1:int) : void
        {
            var _loc_2:* = LOCK_STEP_MS + param1 * 5 * 1000;
            var _loc_3:String = this;
            _loc_3.count = this.count + 1;
            this.unlockTime = new Date().getTime() + _loc_2 * Math.pow(2, this.count++);
            Ptrace.pinfo("BitrateLock.lock() unlockTime=" + this.unlockTime / 1000 + " count=" + this.count + " step=" + _loc_2);
            return;
        }// end function

        public function unlock() : void
        {
            if (this._count > 0)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._count - 1;
                _loc_1._count = _loc_2;
            }
            return;
        }// end function

        public function get bitrate() : Number
        {
            return this._bitrate;
        }// end function

        public function get unlockTime() : Number
        {
            return this._unlockTime;
        }// end function

        public function set unlockTime(param1:Number) : void
        {
            this._unlockTime = param1;
            return;
        }// end function

        public function get count() : int
        {
            return this._count;
        }// end function

        public function set count(param1:int) : void
        {
            this._count = param1;
            return;
        }// end function

    }
}
