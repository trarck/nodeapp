package com.conviva.pdl
{
    import com.conviva.pdl.utils.*;

    public class SwitchLock extends Object
    {
        private var _lock:Array;

        public function SwitchLock(param1:Array, param2:Array)
        {
            var _loc_3:String = null;
            this._lock = new Array();
            for each (_loc_3 in param1)
            {
                
                this._lock.push(new ResourceLock(_loc_3, param2));
            }
            return;
        }// end function

        private function getResourceLock(param1:String) : ResourceLock
        {
            var _loc_2:int = 0;
            while (_loc_2 < this._lock.length)
            {
                
                if (this._lock[_loc_2].res == param1)
                {
                    return this._lock[_loc_2];
                }
                _loc_2++;
            }
            Ptrace.pinfo("No Resource Lock for Res=" + param1 + " Use" + this._lock[0].res);
            return this._lock[0];
        }// end function

        public function isLocked(param1:String, param2:Number, param3:Number) : Boolean
        {
            var _loc_4:* = this.getResourceLock(param1);
            return this.getResourceLock(param1).isLocked(param2, param3);
        }// end function

        public function lockResource(param1:String, param2:int = 0) : void
        {
            var _loc_3:* = this.getResourceLock(param1);
            if (_loc_3 != null)
            {
                _loc_3.lock(param2);
            }
            return;
        }// end function

        public function lockResourceBitrate(param1:String, param2:Number, param3:int = 0) : void
        {
            Ptrace.pinfo("SwitchLock.lockResourceBitrate() " + param1 + "," + param2);
            var _loc_4:* = this.getResourceLock(param1);
            if (this.getResourceLock(param1) != null)
            {
                _loc_4.lockBitrate(param2, param3);
            }
            return;
        }// end function

        public function unlockResource(param1:String) : void
        {
            var _loc_2:* = this.getResourceLock(param1);
            if (_loc_2 != null)
            {
                _loc_2.unlock();
            }
            return;
        }// end function

        public function lockBirate(param1:Number, param2:int = 0) : void
        {
            var _loc_3:ResourceLock = null;
            Ptrace.pinfo("SwitchLock.lockBitrate() on all res " + param1);
            for each (_loc_3 in this._lock)
            {
                
                _loc_3.lockBitrate(param1, param2);
            }
            return;
        }// end function

        public function unlockResourceBitrate(param1:String, param2:Number) : void
        {
            var _loc_3:* = this.getResourceLock(param1);
            if (_loc_3 != null)
            {
                _loc_3.unlockBitrate(param2);
            }
            return;
        }// end function

        public function unlockAll() : void
        {
            var _loc_1:ResourceLock = null;
            for each (_loc_1 in this._lock)
            {
                
                _loc_1.unlock();
            }
            return;
        }// end function

        public function cleanup() : void
        {
            var _loc_1:ResourceLock = null;
            for each (_loc_1 in this._lock)
            {
                
                _loc_1.cleanup();
            }
            this._lock = null;
            return;
        }// end function

    }
}
