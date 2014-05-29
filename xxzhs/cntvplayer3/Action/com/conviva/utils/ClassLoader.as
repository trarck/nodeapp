package com.conviva.utils
{
    import flash.net.*;

    public class ClassLoader extends GenericLoader
    {
        private var _swfUrl:String;

        public function ClassLoader(param1:String, param2:Function, param3:uint = 0)
        {
            super(GenericLoader.CLASS_LOADER, param2);
            _timeoutMs = param3;
            this._swfUrl = param1;
            var _loc_4:* = new URLRequest(this._swfUrl);
            load(_loc_4);
            return;
        }// end function

        public function get ModuleUrl() : String
        {
            return this._swfUrl;
        }// end function

    }
}
