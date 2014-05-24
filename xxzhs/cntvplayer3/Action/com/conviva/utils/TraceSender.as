package com.conviva.utils
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class TraceSender extends Object
    {
        private var _logToDisk:Boolean = true;
        private var tracerConnection:LocalConnection;
        private var lastCheckedForConnection:int = 0;
        private var tracerEnabled:Boolean = true;
        private var _channelName:String = "_conviva_trace_viewer";
        private var _senderId:String = "";
        private static const humanReadableTime:Boolean = false;
        private static const LOG_TO_DISK:String = "logToDisk";

        public function TraceSender()
        {
            this.tracerConnection = new LocalConnection();
            this.tracerConnection.addEventListener(StatusEvent.STATUS, this.tracerEventHandler);
            this.tracerConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.tracerEventHandler);
            this.tracerConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.tracerEventHandler);
            return;
        }// end function

        public function ReadConfig() : void
        {
            var _loc_1:* = PersistentConfig.SafeGetPropElse(LOG_TO_DISK, null);
            this._logToDisk = _loc_1 as String == "true" ? (true) : (false);
            return;
        }// end function

        public function Info(param1:String, ... args) : void
        {
            this.AddToTrace(param1, "", args);
            return;
        }// end function

        public function Warning(param1:String, ... args) : void
        {
            this.AddToTrace(param1, "WARNING", args);
            return;
        }// end function

        public function Error(param1:String, ... args) : void
        {
            this.AddToTrace(param1, "ERROR", args);
            return;
        }// end function

        private function AddToTrace(param1:String, param2:String, ... args) : void
        {
            args = new activation;
            var t:Function;
            var module:* = param1;
            var priority:* = param2;
            var rest:* = args;
            var dt:* = new Date();
            var msgBare:* = toString();
            if ( != null && length > 0)
            {
                msgBare =  + ": " + ;
            }
            if ( != null && length > 0)
            {
                msgBare =  + ": " + ;
            }
            var msg:* = "[" + (humanReadableTime ? (CommonUtils.formatTime()) : (time / 1000)) + "] " + ;
            if (this._logToDisk)
            {
                trace();
            }
            if (Trace.extraTracers.length > 0)
            {
                var _loc_5:int = 0;
                var _loc_6:* = Trace.extraTracers;
                do
                {
                    
                    t = _loc_6[_loc_5];
                    try
                    {
                        this.();
                    }
                    catch (e)
                    {
                    }
                }while (_loc_6 in _loc_5)
            }
            if (Trace.traceToTraceViewer)
            {
                this.sendToTracer("traceInfo", );
            }
            return;
        }// end function

        public function Stats(param1:Object) : void
        {
            if (Trace.traceToTraceViewer)
            {
                this.sendToTracer("traceStats", param1);
            }
            return;
        }// end function

        public function set ChannelName(param1:String) : void
        {
            this._channelName = "_conviva_trace_viewer" + param1;
            return;
        }// end function

        public function set SenderId(param1:String) : void
        {
            this._senderId = param1;
            return;
        }// end function

        public function get SenderId() : String
        {
            if (this._senderId == "")
            {
                this.SenderName = "LivePass";
            }
            return this._senderId;
        }// end function

        public function set SenderName(param1:String) : void
        {
            this._senderId = param1 + "@" + (1 + int(134217726 * CommonUtils.random()));
            return;
        }// end function

        private function tracerEventHandler(param1:Object) : void
        {
            if (param1.level == "error")
            {
                this.tracerEnabled = false;
            }
            return;
        }// end function

        private function sendToTracer(param1:String, param2:Object) : void
        {
            var now:int;
            var method:* = param1;
            var data:* = param2;
            if (!this.tracerEnabled)
            {
                now = getTimer();
                if (now > this.lastCheckedForConnection + 2000)
                {
                    this.tracerEnabled = true;
                    this.lastCheckedForConnection = now;
                }
            }
            if (this.tracerEnabled)
            {
                if (data is String)
                {
                    data = "!" + this.SenderId + "!" + data;
                }
                else
                {
                    data["Trace.senderId"] = this.SenderId;
                }
                try
                {
                    this.tracerConnection.send(this._channelName, method, data);
                }
                catch (e)
                {
                    tracerEnabled = false;
                }
            }
            return;
        }// end function

    }
}
