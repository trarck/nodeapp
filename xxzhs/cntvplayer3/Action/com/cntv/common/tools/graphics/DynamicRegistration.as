package com.cntv.common.tools.graphics
{
    import flash.display.*;
    import flash.geom.*;

    public class DynamicRegistration extends Object
    {
        private var regpoint:Point;
        private var target:DisplayObject;

        public function DynamicRegistration(param1:DisplayObject, param2:Point)
        {
            this.target = param1;
            this.regpoint = param2;
            return;
        }// end function

        public function setPoint(param1:Point) : void
        {
            this.regpoint = param1;
            return;
        }// end function

        public function flush(param1:String, param2:Number) : void
        {
            var _loc_5:Point = null;
            var _loc_3:* = this.target;
            var _loc_4:* = _loc_3.parent.globalToLocal(_loc_3.localToGlobal(this.regpoint));
            if (param1 == "x" || param1 == "y")
            {
                _loc_3[param1] = param2 - this.regpoint[param1];
            }
            else
            {
                _loc_3[param1] = param2;
                _loc_5 = _loc_3.parent.globalToLocal(_loc_3.localToGlobal(this.regpoint));
                _loc_3.x = _loc_3.x + (_loc_4.x - _loc_5.x);
                _loc_3.y = _loc_3.y + (_loc_4.y - _loc_5.y);
            }
            return;
        }// end function

    }
}
