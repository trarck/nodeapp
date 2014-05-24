package com.conviva.utils
{
    import flash.utils.*;

    public class DictionaryCS extends Object
    {
        private var _obj:Dictionary;

        public function DictionaryCS()
        {
            this._obj = new Dictionary();
            return;
        }// end function

        public function ToObject() : Object
        {
            var _loc_1:Object = {};
            this.CopyToObject(_loc_1);
            return _loc_1;
        }// end function

        public function CopyToObject(param1:Object) : void
        {
            var _loc_2:String = null;
            for (_loc_2 in this._obj)
            {
                
                param1[_loc_2] = this._obj[_loc_2];
            }
            return;
        }// end function

        public function GetValue(param1)
        {
            return this._obj[param1];
        }// end function

        public function SetValue(param1, param2) : void
        {
            this._obj[param1] = param2;
            return;
        }// end function

        public function Clear() : void
        {
            var _loc_1:* = undefined;
            for (_loc_1 in this._obj)
            {
                
                delete this._obj[_loc_1];
            }
            return;
        }// end function

        public function ContainsKey(param1) : Boolean
        {
            return this._obj[param1] !== undefined;
        }// end function

        public function Contains(param1) : Boolean
        {
            return this.ContainsKey(param1);
        }// end function

        public function get Keys() : Array
        {
            var _loc_2:* = undefined;
            var _loc_1:* = new Array();
            for (_loc_2 in this._obj)
            {
                
                _loc_1.push(_loc_2);
            }
            return _loc_1;
        }// end function

        public function get Values() : Array
        {
            var _loc_2:* = undefined;
            var _loc_1:* = new Array();
            for each (_loc_2 in this._obj)
            {
                
                _loc_1.push(_loc_2);
            }
            return _loc_1;
        }// end function

        public function get KeyValuePairs() : Array
        {
            var _loc_2:* = undefined;
            var _loc_1:* = new Array();
            for (_loc_2 in this._obj)
            {
                
                _loc_1.push(new KeyValuePairCS(_loc_2, this._obj[_loc_2]));
            }
            return _loc_1;
        }// end function

        public function get Count() : int
        {
            var _loc_2:* = undefined;
            var _loc_1:int = 0;
            for (_loc_2 in this._obj)
            {
                
                _loc_1++;
            }
            return _loc_1;
        }// end function

        public function Add(param1, param2) : void
        {
            this._obj[param1] = param2;
            return;
        }// end function

        public function Remove(param1) : Boolean
        {
            if (this.ContainsKey(param1))
            {
                delete this._obj[param1];
                return true;
            }
            return false;
        }// end function

        public static function New(... args) : DictionaryCS
        {
            args = new DictionaryCS;
            var _loc_3:int = 0;
            while ((_loc_3 + 1) < args.length)
            {
                
                args._obj[args[_loc_3]] = args[(_loc_3 + 1)];
                _loc_3 = _loc_3 + 2;
            }
            return args;
        }// end function

        public static function FromRepr(param1:Object) : DictionaryCS
        {
            var _loc_3:String = null;
            if (param1 == null)
            {
                return null;
            }
            if (param1 is DictionaryCS)
            {
                return param1 as DictionaryCS;
            }
            if (param1.hasOwnProperty("ToObject"))
            {
                return FromRepr(param1.ToObject());
            }
            var _loc_2:* = new DictionaryCS;
            if (param1 is Dictionary)
            {
                _loc_2._obj = param1 as Dictionary;
            }
            else
            {
                for (_loc_3 in param1)
                {
                    
                    _loc_2._obj[_loc_3] = param1[_loc_3];
                }
            }
            return _loc_2;
        }// end function

    }
}
