package com.conviva.stream
{

    public class MbrStreamItem extends Object
    {
        private var _url:String = "";
        private var _objectId:String = "";
        private var _bitrate:Number = 0;

        public function MbrStreamItem(param1:String, param2:Number, param3:String = "")
        {
            this._url = param1;
            this._bitrate = param2;
            this._objectId = param3 == "" ? (param1) : (param3);
            return;
        }// end function

        public function cleanup() : void
        {
            this._url = "";
            this._objectId = "";
            this._bitrate = 0;
            return;
        }// end function

        public function get url() : String
        {
            return this._url;
        }// end function

        public function set url(param1:String) : void
        {
            this._url = param1;
            return;
        }// end function

        public function get objectId() : String
        {
            return this._objectId;
        }// end function

        public function set objectId(param1:String) : void
        {
            this._objectId = param1;
            return;
        }// end function

        public function get bitrate() : Number
        {
            return this._bitrate;
        }// end function

        public function set bitrate(param1:Number) : void
        {
            this._bitrate = param1;
            return;
        }// end function

        public function setDeep(param1:Object) : void
        {
            this.cleanup();
            this._url = param1.url;
            this._bitrate = param1.bitrate;
            if (param1.hasOwnProperty("objectId") && param1.objectId != "")
            {
                this._objectId = param1.objectId;
            }
            else
            {
                this._objectId = param1.url;
            }
            return;
        }// end function

        public function set __url(param1:String) : void
        {
            this._url = param1;
            return;
        }// end function

        public function set __bitrate(param1:Number) : void
        {
            this._bitrate = param1;
            return;
        }// end function

    }
}
