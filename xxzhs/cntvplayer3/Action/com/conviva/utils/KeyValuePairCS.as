package com.conviva.utils
{

    public class KeyValuePairCS extends Object
    {
        private var _key:Object;
        private var _val:Object;

        public function KeyValuePairCS(param1, param2)
        {
            this._key = param1;
            this._val = param2;
            return;
        }// end function

        public function get Key()
        {
            return this._key;
        }// end function

        public function get Value()
        {
            return this._val;
        }// end function

    }
}
