package com.conviva.pdl.manifest
{
    import com.conviva.pdl.utils.*;

    public class Chunk extends Object
    {
        private var _status:int = 0;
        private var _resource:String;
        private var _bitrate:Number;
        private var _isCached:Boolean = false;
        private var _durSec:Number;
        private var _image:String;
        private var _url:String;
        private var _num:int;
        private var _bytesLoaded:Number;
        public static const OK:int = 0;
        public static const OBJ_MISSING:int = 1;
        public static const OBJ_ERROR:int = 2;
        public static const LOAD_TIMEOUT:int = 3;

        public function Chunk(param1:String, param2:Number, param3:Number, param4:String, param5:String, param6:int)
        {
            this._resource = param1;
            this._bitrate = param2;
            this._durSec = param3;
            this._image = param4;
            this._status = OK;
            if (ChunkManifest.ifReplaceHost)
            {
                this._url = Utils.replaceHost(param5, this._resource);
            }
            else
            {
                this._url = param5;
            }
            this._bytesLoaded = 0;
            this._num = param6;
            return;
        }// end function

        public function newResource(param1:String) : void
        {
            this._resource = param1;
            var _loc_2:* = this._url;
            this._url = Utils.replaceHost(_loc_2, param1);
            return;
        }// end function

        public function get resource() : String
        {
            return this._resource;
        }// end function

        public function set resource(param1:String) : void
        {
            this._resource = param1;
            return;
        }// end function

        public function get bitrate() : Number
        {
            return this._bitrate;
        }// end function

        public function set durSec(param1:Number) : void
        {
            this._durSec = param1;
            return;
        }// end function

        public function get durSec() : Number
        {
            return this._durSec;
        }// end function

        public function get image() : String
        {
            return this._image;
        }// end function

        public function get url() : String
        {
            return this._url;
        }// end function

        public function get bytesLoaded() : Number
        {
            return this._bytesLoaded;
        }// end function

        public function set bytesLoaded(param1:Number) : void
        {
            this._bytesLoaded = param1;
            return;
        }// end function

        public function get isCached() : Boolean
        {
            return this._isCached;
        }// end function

        public function set isCached(param1:Boolean) : void
        {
            this._isCached = param1;
            return;
        }// end function

        public function get num() : int
        {
            return this._num;
        }// end function

        public function set num(param1:int) : void
        {
            this._num = param1;
            return;
        }// end function

        public function get status() : int
        {
            return this._status;
        }// end function

        public function set status(param1:int) : void
        {
            this._status = param1;
            return;
        }// end function

    }
}
