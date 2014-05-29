package com.conviva.utils
{
    import flash.utils.*;

    public class DataLoadable extends Object
    {
        private var _arr:ByteArray = null;

        public function DataLoadable()
        {
            return;
        }// end function

        public function ToRepr() : ByteArray
        {
            return this._arr;
        }// end function

        public function ToByteArray() : ArrayCS
        {
            var _loc_1:* = new Array();
            var _loc_2:int = 0;
            while (_loc_2 < this._arr.length)
            {
                
                _loc_1.push(this._arr[_loc_2]);
                _loc_2++;
            }
            return ArrayCS.FromRepr(_loc_1);
        }// end function

        public function ToStr() : String
        {
            if (this._arr == null)
            {
                return null;
            }
            var _loc_1:* = this._arr.position;
            var _loc_2:* = this._arr.readUTFBytes(this._arr.length);
            this._arr.position = _loc_1;
            return _loc_2;
        }// end function

        public function ToDebugStr() : String
        {
            if (this._arr == null)
            {
                return null;
            }
            var _loc_1:* = this._arr.position;
            var _loc_2:String = "";
            while (this._arr.bytesAvailable > 0)
            {
                
                _loc_2 = _loc_2 + (this._arr.readByte() + ",");
            }
            this._arr.position = _loc_1;
            return _loc_2;
        }// end function

        public function ToXml() : XML
        {
            if (this._arr == null)
            {
                return null;
            }
            try
            {
                return new XML(this._arr);
            }
            catch (e:TypeError)
            {
            }
            return null;
        }// end function

        public static function FromRepr(param1:ByteArray) : DataLoadable
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = new DataLoadable;
            _loc_2._arr = param1;
            return _loc_2;
        }// end function

        public static function FromByteArray(param1:Object) : DataLoadable
        {
            var _loc_2:ByteArray = null;
            var _loc_3:int = 0;
            if (param1 is ByteArray)
            {
                return FromRepr(param1 as ByteArray);
            }
            _loc_2 = new ByteArray();
            while (_loc_3 < param1.Length)
            {
                
                _loc_2.writeByte(param1.GetValue(_loc_3));
                _loc_3++;
            }
            _loc_2.position = 0;
            return FromRepr(_loc_2);
        }// end function

        public static function FromString(param1:String) : DataLoadable
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = new ByteArray();
            _loc_2.writeUTFBytes(param1);
            _loc_2.position = 0;
            return FromRepr(_loc_2);
        }// end function

    }
}
