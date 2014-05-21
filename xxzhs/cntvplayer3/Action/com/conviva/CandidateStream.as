package com.conviva
{
    import com.conviva.utils.*;

    public class CandidateStream extends Object
    {
        private var __auto_id:String;
        private var __auto_bitrate:int;
        private var __auto_resource:String;

        public function CandidateStream(param1:String, param2:int, param3:String)
        {
            this.id = param1;
            this.bitrate = param2;
            this.resource = param3;
            return;
        }// end function

        public function Cleanup() : void
        {
            this.id = null;
            this.bitrate = 0;
            this.resource = null;
            return;
        }// end function

        public function get id() : String
        {
            return this.__auto_id;
        }// end function

        public function set id(param1:String) : void
        {
            this.__auto_id = param1;
            return;
        }// end function

        public function GetId() : String
        {
            return this.id;
        }// end function

        public function SetId(param1:String) : void
        {
            this.id = param1;
            return;
        }// end function

        public function get bitrate() : int
        {
            return this.__auto_bitrate;
        }// end function

        public function set bitrate(param1:int) : void
        {
            this.__auto_bitrate = param1;
            return;
        }// end function

        public function GetBitrate() : int
        {
            return this.bitrate;
        }// end function

        public function SetBitrate(param1:int) : void
        {
            this.bitrate = param1;
            return;
        }// end function

        public function get resource() : String
        {
            return this.__auto_resource;
        }// end function

        public function set resource(param1:String) : void
        {
            this.__auto_resource = param1;
            return;
        }// end function

        public function GetResource() : String
        {
            return this.resource;
        }// end function

        public function SetResource(param1:String) : void
        {
            this.resource = param1;
            return;
        }// end function

        public function CheckValidity() : String
        {
            return null;
        }// end function

        public function StoreCloningData(param1:Object) : void
        {
            var _loc_2:* = new DictionaryCS();
            _loc_2.SetValue("id", this.id);
            _loc_2.SetValue("bitrate", this.bitrate);
            _loc_2.SetValue("resource", this.resource);
            Reflection.StoreCloningData(_loc_2, param1);
            return;
        }// end function

        public static function ConstructFromCloningData(param1:Object) : CandidateStream
        {
            var _loc_2:* = Lang.DictionaryFromRepr(param1);
            var _loc_3:* = new CandidateStream(null, 0, null);
            _loc_3.id = _loc_2.GetValue("id") as String;
            _loc_3.resource = _loc_2.GetValue("resource") as String;
            _loc_3.bitrate = int(_loc_2.GetValue("bitrate"));
            return _loc_3;
        }// end function

    }
}
