package com.cntv.common.tools.psFilterTool
{
    import flash.utils.*;

    public class Map extends Object
    {
        private var props:Dictionary = null;
        private var _keys:Array = null;

        public function Map()
        {
            this._keys = null;
            this.props = null;
            this.clear();
            return;
        }// end function

        public function containsKey(param1:String) : Boolean
        {
            return this.props[param1] != null;
        }// end function

        public function values() : Array
        {
            var _loc_1:Array = null;
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            _loc_1 = new Array();
            _loc_2 = this.size();
            if (_loc_2 > 0)
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1.push(this.props[this._keys[_loc_3]]);
                    _loc_3 = _loc_3 + 1;
                }
            }
            return _loc_1;
        }// end function

        public function isEmpty() : Boolean
        {
            return this.size() < 1;
        }// end function

        public function remove(param1:String) : Object
        {
            var _loc_2:* = undefined;
            var _loc_3:int = 0;
            _loc_2 = null;
            if (this.containsKey(param1))
            {
                delete this.props[param1];
                _loc_3 = this._keys.indexOf(param1);
                if (_loc_3 > -1)
                {
                    this._keys.splice(_loc_3, 1);
                }
            }
            return _loc_2;
        }// end function

        public function size() : uint
        {
            return this._keys.length;
        }// end function

        public function toString() : String
        {
            var _loc_1:String = null;
            var _loc_2:uint = 0;
            _loc_1 = "";
            _loc_2 = 0;
            while (_loc_2 < this.size())
            {
                
                _loc_1 = _loc_1 + (this._keys[_loc_2] + ":" + this.get(this._keys[_loc_2]) + "\n");
                _loc_2 = _loc_2 + 1;
            }
            return _loc_1;
        }// end function

        public function clear() : void
        {
            this.props = new Dictionary();
            this._keys = new Array();
            return;
        }// end function

        public function put(param1:String, param2:Object) : Object
        {
            var _loc_3:* = undefined;
            _loc_3 = null;
            if (this.containsKey(param1))
            {
                _loc_3 = this.get(param1);
                this.props[param1] = param2;
            }
            else
            {
                this.props[param1] = param2;
                this._keys.push(param1);
            }
            return _loc_3;
        }// end function

        public function containsValue(param1:Object) : Boolean
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            _loc_2 = this.size();
            if (_loc_2 > 0)
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    if (this.props[this._keys[_loc_3]] == param1)
                    {
                        return true;
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return false;
        }// end function

        public function keys() : Array
        {
            return this._keys;
        }// end function

        public function get(param1:Object) : Object
        {
            return this.props[param1];
        }// end function

        public function putAll(param1:Map) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:Array = null;
            var _loc_4:uint = 0;
            this.clear();
            _loc_2 = param1.size();
            if (_loc_2 > 0)
            {
                _loc_3 = param1.keys();
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    this.put(_loc_3[_loc_4], param1.get(_loc_3[_loc_4]));
                    _loc_4 = _loc_4 + 1;
                }
            }
            return;
        }// end function

    }
}
