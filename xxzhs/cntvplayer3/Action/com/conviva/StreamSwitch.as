package com.conviva
{
    import com.conviva.utils.*;

    public class StreamSwitch extends Object
    {
        private var _id:String;
        private var _timeoutMs:int;
        private var _mode:String;
        private var _sourceStream:CandidateStream;
        private var _targetStream:CandidateStream;
        private var __auto_status:String;
        private static var _nextId:int = 0;
        public static const PENDING:String = "PENDING";
        public static const IN_PROGRESS:String = "IN_PROGRESS";
        public static const SUCCEEDED:String = "SUCCEEDED";
        public static const FAILED:String = "FAILED";
        public static const INTERRUPTED:String = "INTERRUPTED";

        public function StreamSwitch(param1:String, param2:CandidateStream, param3:CandidateStream, param4:int, param5:String, param6:String)
        {
            this._id = param1;
            this._sourceStream = param2;
            this._targetStream = param3;
            this._timeoutMs = param4;
            this._mode = param5;
            this.status = param6;
            return;
        }// end function

        public function Cleanup() : void
        {
            return;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        public function GetId() : String
        {
            return this.id;
        }// end function

        public function get timeoutMs() : int
        {
            return this._timeoutMs;
        }// end function

        public function GetTimeoutMs() : int
        {
            return this.timeoutMs;
        }// end function

        public function get sourceStream() : CandidateStream
        {
            return this._sourceStream;
        }// end function

        public function GetSourceStream() : CandidateStream
        {
            return this.sourceStream;
        }// end function

        public function get targetStream() : CandidateStream
        {
            return this._targetStream;
        }// end function

        public function GetTargetStream() : CandidateStream
        {
            return this.targetStream;
        }// end function

        public function get mode() : String
        {
            return this._mode;
        }// end function

        public function GetMode() : String
        {
            return this.mode;
        }// end function

        public function get status() : String
        {
            return this.__auto_status;
        }// end function

        public function set status(param1:String) : void
        {
            this.__auto_status = param1;
            return;
        }// end function

        public function GetStatus() : String
        {
            return this.status;
        }// end function

        public function SetStatus(param1:String) : void
        {
            this.status = param1;
            return;
        }// end function

        public function CheckValidity() : String
        {
            if (this._id == null)
            {
                return "StreamSwitch.id is null (and must be non-null)";
            }
            var _loc_1:* = this._sourceStream != null ? (this._sourceStream.CheckValidity()) : (null);
            if (_loc_1 != null)
            {
                return _loc_1;
            }
            var _loc_2:* = this._targetStream != null ? (this._targetStream.CheckValidity()) : (null);
            if (_loc_2 != null)
            {
                return _loc_2;
            }
            return null;
        }// end function

        public function StoreCloningData(param1:Object) : void
        {
            var _loc_2:* = new DictionaryCS();
            _loc_2.SetValue("_id", this._id);
            _loc_2.SetValue("_sourceStream", this._sourceStream);
            _loc_2.SetValue("_targetStream", this._targetStream);
            _loc_2.SetValue("_timeoutMs", this._timeoutMs);
            _loc_2.SetValue("_mode", this._mode);
            _loc_2.SetValue("status", this.status);
            Reflection.StoreCloningData(_loc_2, param1);
            return;
        }// end function

        public static function MakeSwitch(param1:CandidateStream, param2:CandidateStream, param3:String) : StreamSwitch
        {
            return new StreamSwitch(GetNextId(false), param1, param2, -1, null, param3);
        }// end function

        public static function MakeSwitchToStream(param1:CandidateStream, param2:String) : StreamSwitch
        {
            return new StreamSwitch(GetNextId(false), null, param1, -1, null, param2);
        }// end function

        public static function ConstructFromCloningData(param1:Object) : StreamSwitch
        {
            var _loc_2:* = Lang.DictionaryFromRepr(param1);
            var _loc_3:* = new StreamSwitch(null, null, null, 0, null, null);
            var _loc_4:* = _loc_2.ContainsKey("_sourceStream") && _loc_2.GetValue("_sourceStream") != null;
            var _loc_5:* = _loc_2.ContainsKey("_targetStream") && _loc_2.GetValue("_targetStream") != null;
            _loc_3._id = _loc_2.GetValue("_id") as String;
            _loc_3._sourceStream = _loc_4 ? (Reflection.Clone(_loc_2.GetValue("_sourceStream")) as CandidateStream) : (null);
            _loc_3._targetStream = _loc_5 ? (Reflection.Clone(_loc_2.GetValue("_targetStream")) as CandidateStream) : (null);
            _loc_3.status = _loc_2.GetValue("status") as String;
            _loc_3._mode = _loc_2.GetValue("_mode") as String;
            _loc_3._timeoutMs = int(_loc_2.GetValue("_timeoutMs"));
            return _loc_3;
        }// end function

        public static function StaticInit() : void
        {
            _nextId = 0;
            return;
        }// end function

        public static function StaticCleanup() : void
        {
            _nextId = 0;
            return;
        }// end function

        private static function GetNextId(param1:Boolean) : String
        {
            var _loc_2:* = _nextId;
            (_nextId + 1);
            if (param1)
            {
                return "c3." + _loc_2.toString();
            }
            return _loc_2.toString();
        }// end function

    }
}
