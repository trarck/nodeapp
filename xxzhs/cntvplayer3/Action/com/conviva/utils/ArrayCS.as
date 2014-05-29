package com.conviva.utils
{

    public class ArrayCS extends Object
    {
        private var _array:Array;

        public function ArrayCS(param1:int = -1)
        {
            if (param1 >= 0)
            {
                this._array = new Array(param1);
            }
            else
            {
                this._array = new Array();
            }
            return;
        }// end function

        public function ToRepr() : Array
        {
            return this._array;
        }// end function

        public function get Values() : Array
        {
            return this._array;
        }// end function

        public function get Length() : int
        {
            return this._array.length;
        }// end function

        public function GetValue(param1:int)
        {
            if (param1 >= this._array.length)
            {
                throw new Error("Index out of bounds: " + param1 + " (length " + this._array.length + ")");
            }
            if (param1 < 0)
            {
                throw new Error("Index out of bounds: " + param1);
            }
            return this._array[param1];
        }// end function

        public function SetValue(param1:int, param2) : void
        {
            if (param1 >= this._array.length)
            {
                throw new Error("Index out of bounds: " + param1 + " (length " + this._array.length + ")");
            }
            if (param1 < 0)
            {
                throw new Error("Index out of bounds: " + param1);
            }
            this._array[param1] = param2;
            return;
        }// end function

        public static function New(... args) : ArrayCS
        {
            args = new ArrayCS;
            args._array = args._array.concat(args);
            return args;
        }// end function

        public static function FromRepr(param1:Array) : ArrayCS
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = new ArrayCS;
            _loc_2._array = param1;
            return _loc_2;
        }// end function

    }
}
