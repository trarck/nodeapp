package com.cntv.common.tools.psFilterTool
{
    import flash.display.*;
    import flash.filters.*;

    public class PSFilterTools extends Object
    {
        private var owner:DisplayObject;
        private var filters:Map;
        private var owners:Array;

        public function PSFilterTools(param1:DisplayObject = null)
        {
            this.owner = param1;
            this.filters = new Map();
            return;
        }// end function

        public function setOwners(param1:Array) : void
        {
            this.owners = param1;
            return;
        }// end function

        public function setOwner(param1:DisplayObject) : void
        {
            this.owner = param1;
            return;
        }// end function

        public function set brightness(param1:int) : void
        {
            var _loc_2:ColorMatrixFilter = null;
            if (param1 > 255)
            {
                param1 = 255;
            }
            if (param1 < -255)
            {
                param1 = -255;
            }
            _loc_2 = new ColorMatrixFilter();
            _loc_2.matrix = [1, 0, 0, 0, param1, 0, 1, 0, 0, param1, 0, 0, 1, 0, param1, 0, 0, 0, 1, 0];
            this.applyFilter("brightness", _loc_2);
            return;
        }// end function

        public function set contrast(param1:Number) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:ColorMatrixFilter = null;
            if (param1 > 1)
            {
                param1 = 1;
            }
            if (param1 < 0)
            {
                param1 = 0;
            }
            _loc_2 = param1 * 11;
            _loc_3 = 63.5 - param1 * 698.5;
            _loc_4 = new ColorMatrixFilter();
            _loc_4.matrix = [_loc_2, 0, 0, 0, _loc_3, 0, _loc_2, 0, 0, _loc_3, 0, 0, _loc_2, 0, _loc_3, 0, 0, 0, 1, 0];
            this.applyFilter("contrast", _loc_4);
            return;
        }// end function

        private function applyFilter(param1:String, param2:BitmapFilter) : void
        {
            var _loc_3:Number = NaN;
            this.filters.put(param1, param2);
            if (this.owner != null)
            {
                this.owner.filters = this.filters.values();
            }
            if (this.owners != null)
            {
                _loc_3 = 0;
                while (_loc_3 < this.owners.length)
                {
                    
                    if (this.owners[_loc_3] != null)
                    {
                        this.owners[_loc_3].filters = this.filters.values();
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return;
        }// end function

    }
}
