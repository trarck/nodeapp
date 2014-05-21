package com.utils.net.request
{

    public class AttributeSortVo extends Object
    {
        private var _url:String;
        private var _request:Array;
        private var _method:String = "GET";

        public function AttributeSortVo(param1:String, param2:Array, param3:Boolean = false)
        {
            this._url = param1;
            if (param3)
            {
                this._method = "POST";
            }
            if (param2 != null)
            {
                this._request = param2;
            }
            return;
        }// end function

        public function get url() : String
        {
            return this._url;
        }// end function

        public function get request() : Array
        {
            return this._request;
        }// end function

        public function get method() : String
        {
            return this._method;
        }// end function

    }
}
