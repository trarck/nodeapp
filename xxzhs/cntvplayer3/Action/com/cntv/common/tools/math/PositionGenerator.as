package com.cntv.common.tools.math
{
    import flash.display.*;
    import flash.geom.*;

    public class PositionGenerator extends Object
    {

        public function PositionGenerator()
        {
            return;
        }// end function

        public static function createSize(param1:DisplayObject, param2:DisplayObject) : Point
        {
            var _loc_3:* = new Point();
            var _loc_4:* = new Point();
            var _loc_5:* = param1.width / param1.height;
            if (param2 is Stage)
            {
                _loc_4.x = Stage(param2).stageWidth;
                _loc_4.y = Stage(param2).stageHeight;
            }
            else
            {
                _loc_4.x = param2.width;
                _loc_4.y = param2.height;
            }
            var _loc_6:* = _loc_4.x / _loc_4.y;
            if (_loc_5 > _loc_6)
            {
                _loc_3.x = _loc_4.x;
                _loc_3.y = _loc_3.x / _loc_5;
            }
            else if (_loc_5 < _loc_6)
            {
                _loc_3.y = _loc_4.y;
                _loc_3.x = _loc_3.y * _loc_5;
            }
            else
            {
                _loc_3.x = _loc_4.x;
                _loc_3.y = _loc_4.y;
            }
            return _loc_3;
        }// end function

        public static function createPosition(param1:DisplayObject, param2:DisplayObject) : Point
        {
            var _loc_3:* = new Point();
            var _loc_4:* = new Point();
            if (param2 is Stage)
            {
                _loc_4.x = Stage(param2).stageWidth;
                _loc_4.y = Stage(param2).stageHeight;
            }
            else
            {
                _loc_4.x = param2.width;
                _loc_4.y = param2.height;
            }
            _loc_3.x = (_loc_4.x - param1.width) / 2;
            _loc_3.y = (_loc_4.y - param1.height) / 2;
            return _loc_3;
        }// end function

    }
}
