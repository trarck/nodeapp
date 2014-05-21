package com.conviva.utils
{

    public class ListCS extends Object
    {
        private var _array:Array;

        public function ListCS(... args)
        {
            if (args.length > 1)
            {
                Ping.Send("Error: Instantiate ListCS with too many arguments");
            }
            else if (args.length == 0)
            {
                this._array = new Array();
            }
            else if (args[0] is Array)
            {
                this._array = args[0];
            }
            else if (args[0] is int)
            {
                this._array = new Array(args[0]);
            }
            else if (args[0] is ArrayCS)
            {
                this._array = (args[0] as ArrayCS).ToRepr();
            }
            else
            {
                Ping.Send("Error: Instantiate ListCS with inappropriate arguments");
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

        public function GetValue(param1:int)
        {
            return this._array[param1];
        }// end function

        public function SetValue(param1:int, param2) : void
        {
            this._array[param1] = param2;
            return;
        }// end function

        public function get Count() : int
        {
            return this._array.length;
        }// end function

        public function Add(param1) : void
        {
            this._array.push(param1);
            return;
        }// end function

        public function Clear() : void
        {
            this._array.length = 0;
            return;
        }// end function

        public function Contains(param1) : Boolean
        {
            return this._array.indexOf(param1) >= 0;
        }// end function

        public function IndexOf(param1, param2:int = 0) : int
        {
            return this._array.indexOf(param1, param2);
        }// end function

        public function Insert(param1:int, param2) : void
        {
            this._array.splice(param1, 0, param2);
            return;
        }// end function

        public function Remove(param1) : Boolean
        {
            var _loc_2:* = this._array.indexOf(param1);
            if (_loc_2 < 0)
            {
                return false;
            }
            this.RemoveAt(_loc_2);
            return true;
        }// end function

        public function RemoveAt(param1:int) : void
        {
            this.RemoveRange(param1, 1);
            return;
        }// end function

        public function RemoveRange(param1:int, param2:int) : void
        {
            this._array.splice(param1, param2);
            return;
        }// end function

        public function Sort(... args) : void
        {
            this._array.sort.apply(this, args);
            return;
        }// end function

        public function ToArray() : ArrayCS
        {
            return ArrayCS.FromRepr(this._array.slice());
        }// end function

        public function GetRange(param1:int, param2:int) : ListCS
        {
            var _loc_3:* = new ListCS();
            var _loc_4:int = 0;
            while (_loc_4 < param2)
            {
                
                _loc_3.Add(this._array[param1 + _loc_4]);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function New(... args) : ListCS
        {
            args = new ListCS;
            args._array = args._array.concat(args);
            return args;
        }// end function

        public static function FromRepr(param1:Array) : ListCS
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = new ListCS;
            _loc_2._array = param1;
            return _loc_2;
        }// end function

    }
}
