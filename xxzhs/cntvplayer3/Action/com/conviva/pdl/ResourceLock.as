package com.conviva.pdl
{

    public class ResourceLock extends Object
    {
        private var _resource:String;
        private var _lock:Array;

        public function ResourceLock(param1:String, param2:Array)
        {
            var _loc_3:Number = NaN;
            this._lock = new Array();
            this._resource = param1;
            for each (_loc_3 in param2)
            {
                
                this._lock.push(new BitrateLock(_loc_3, 0, 0));
            }
            return;
        }// end function

        private function getBitrateLock(param1:Number) : BitrateLock
        {
            var _loc_2:int = 0;
            while (_loc_2 < this._lock.length)
            {
                
                if (this._lock[_loc_2].bitrate == param1)
                {
                    return this._lock[_loc_2];
                }
                _loc_2++;
            }
            return null;
        }// end function

        public function get res() : String
        {
            return this._resource;
        }// end function

        public function lock(param1:int = 0) : void
        {
            var _loc_2:BitrateLock = null;
            for each (_loc_2 in this._lock)
            {
                
                _loc_2.lock(param1);
            }
            return;
        }// end function

        public function unlock() : void
        {
            var _loc_1:BitrateLock = null;
            for each (_loc_1 in this._lock)
            {
                
                _loc_1.unlock();
            }
            return;
        }// end function

        public function unlockBitrate(param1:Number) : void
        {
            var _loc_2:* = this.getBitrateLock(param1);
            if (_loc_2 != null)
            {
                _loc_2.unlock();
            }
            return;
        }// end function

        public function lockBitrate(param1:Number, param2:int = 0) : void
        {
            var _loc_3:* = this.getBitrateLock(param1);
            if (_loc_3 != null)
            {
                _loc_3.lock(param2);
            }
            return;
        }// end function

        public function isLocked(param1:Number, param2:Number) : Boolean
        {
            var _loc_3:* = this.getBitrateLock(param1);
            return _loc_3 != null ? (_loc_3.isLocked(param2)) : (false);
        }// end function

        public function cleanup() : void
        {
            this._lock = null;
            return;
        }// end function

    }
}
