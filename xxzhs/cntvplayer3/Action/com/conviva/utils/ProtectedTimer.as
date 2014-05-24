package com.conviva.utils
{
    import com.conviva.internal_access.*;
    import com.conviva.utils.*;
    import flash.events.*;
    import flash.utils.*;

    public class ProtectedTimer extends Object implements IProtectedTimer
    {
        public var callback:Function;
        public var isPeriodic:Boolean = true;
        public var debugMsg:String = null;
        public var milliseconds:int = 0;
        public var autoStart:Boolean = true;
        private var _timer:Timer = null;
        var mockTimer:IProtectedTimer = null;
        static var mockTimerFactory:Function = null;
        static var timeOffset:Number = 0;
        private static var _tickCountOffsetMs:Number = 0;

        public function ProtectedTimer(param1:int, param2:Function, param3:String, param4:Boolean = true)
        {
            this.callback = param2;
            this.debugMsg = param3;
            this.milliseconds = param1;
            this.autoStart = param4;
            this.isPeriodic = true;
            this._timer = null;
            if (TESTAPI::mockTimerFactory != null)
            {
                TESTAPI::mockTimer = .TESTAPI::mockTimerFactory(this);
                if (TESTAPI::mockTimer != null)
                {
                    return;
                }
            }
            this._timer = new Timer(param1, 0);
            this._timer.addEventListener(TimerEvent.TIMER, this.Tick);
            if (param4)
            {
                this.Start();
            }
            return;
        }// end function

        public function Cleanup() : void
        {
            if (this._timer != null)
            {
                this._timer.stop();
                this._timer.reset();
                this._timer.removeEventListener(TimerEvent.TIMER, this.Tick);
                this._timer = null;
            }
            if (TESTAPI::mockTimer != null)
            {
                TESTAPI::mockTimer.Cleanup();
            }
            this.callback = null;
            return;
        }// end function

        public function Reset() : void
        {
            var _loc_1:Boolean = false;
            if (TESTAPI::mockTimer != null)
            {
                TESTAPI::mockTimer.Reset();
                return;
            }
            if (this._timer)
            {
                _loc_1 = this._timer.running;
                this._timer.reset();
                if (_loc_1 && this.autoStart)
                {
                    this._timer.start();
                }
            }
            return;
        }// end function

        public function Start() : void
        {
            if (TESTAPI::mockTimer != null)
            {
                TESTAPI::mockTimer.Start();
                return;
            }
            if (this._timer)
            {
                this._timer.start();
            }
            return;
        }// end function

        public function Stop() : void
        {
            if (TESTAPI::mockTimer != null)
            {
                TESTAPI::mockTimer.Stop();
                return;
            }
            if (this._timer)
            {
                this._timer.stop();
            }
            return;
        }// end function

        public function IsRunning() : Boolean
        {
            if (TESTAPI::mockTimer != null)
            {
                return Boolean(TESTAPI::mockTimer.IsRunning());
            }
            return this._timer != null && this._timer.running;
        }// end function

        public function ChangeInterval(param1:int) : void
        {
            this.milliseconds = param1;
            if (TESTAPI::mockTimer != null)
            {
                TESTAPI::mockTimer.ChangeInterval(param1);
                return;
            }
            if (this._timer != null)
            {
                this._timer.delay = param1;
            }
            return;
        }// end function

        private function Tick(event:Event) : void
        {
            var ev:* = event;
            Utils.ResetBreadCrumbs();
            Utils.RunProtected(function ()
            {
                if (callback != null)
                {
                    callback();
                }
                finally
                {
                    var _loc_2:* = new catch0;
                    throw null;
                }
                finally
                {
                    if (!isPeriodic)
                    {
                        Cleanup();
                    }
                }
                return;
            }// end function
            , this.debugMsg ? (this.debugMsg) : ("ProtectedTimer.Tick"));
            return;
        }// end function

        public static function DelayAction(param1:Function, param2:int, param3:String) : Object
        {
            var _loc_4:* = new ProtectedTimer(param2, param1, param3, false);
            new ProtectedTimer(param2, param1, param3, false).isPeriodic = false;
            _loc_4.Start();
            return _loc_4;
        }// end function

        public static function CancelDelayedAction(param1) : void
        {
            if (param1 != null)
            {
                param1.Cleanup();
            }
            return;
        }// end function

        public static function GetEpochMilliseconds() : Number
        {
            return new Date().getTime() + TESTAPI::timeOffset;
        }// end function

        public static function GetTickCountMs() : Number
        {
            return getTimer() + _tickCountOffsetMs + TESTAPI::timeOffset;
        }// end function

    }
}
