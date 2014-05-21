package com.cntv.common.tools.graphics
{
    import flash.display.*;
    import flash.geom.*;

    public class CPhotoProgress extends Object
    {

        public function CPhotoProgress()
        {
            return;
        }// end function

        public function DrawPoint(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
        {
            return;
        }// end function

        public static function gradientFill(param1:Sprite, param2:Object, param3:Object, param4:Array, param5:Array, param6:Array) : void
        {
            var _loc_7:String = null;
            var _loc_12:String = null;
            var _loc_13:String = null;
            if (param1 == null || param3 == null || param4 == null || param5 == null || param6 == null)
            {
                return;
            }
            if (param2.focus == null)
            {
                param2.focus = 0;
            }
            switch(param2.linearFill)
            {
                case true:
                {
                    _loc_7 = "linear";
                    break;
                }
                case false:
                {
                    _loc_7 = "radial";
                    break;
                }
                default:
                {
                    _loc_7 = "linear";
                    break;
                }
            }
            var _loc_8:* = param4;
            var _loc_9:* = param5;
            var _loc_10:* = param6;
            var _loc_11:* = new Matrix();
            new Matrix().createGradientBox(param3.w, param3.h, param3.a, param3.x, param3.y);
            switch(param2.spread)
            {
                case 1:
                {
                    _loc_12 = "pad";
                    break;
                }
                case 2:
                {
                    _loc_12 = "reflect";
                    break;
                }
                case 3:
                {
                    _loc_12 = "repeat";
                    break;
                }
                default:
                {
                    _loc_12 = "pad";
                    break;
                }
            }
            switch(param2.linearRGB)
            {
                case false:
                {
                    _loc_13 = "RGB";
                    break;
                }
                case true:
                {
                    _loc_13 = "linearRGB";
                    break;
                }
                default:
                {
                    _loc_13 = "RGB";
                    break;
                }
            }
            var _loc_14:* = param2.focus;
            param1.graphics.beginGradientFill(_loc_7, _loc_8, _loc_9, _loc_10, _loc_11, _loc_12);
            param1.graphics.drawRect(0, 0, param3.w, param3.h);
            return;
        }// end function

        public static function DrawTable(param1:Sprite, param2:Number = 10, param3:Number = 6, param4:Number = 100, param5:Number = 100, param6:Number = 13421772, param7:Number = 1, param8:Number = 1) : void
        {
            var _loc_9:* = param1;
            var _loc_10:* = param4 / param2;
            var _loc_11:* = param5 / param3;
            var _loc_12:int = 0;
            while (_loc_12 <= param3)
            {
                
                _loc_9.graphics.lineStyle(param7, param6, param8);
                _loc_9.graphics.moveTo(0, _loc_11 * _loc_12);
                _loc_9.graphics.lineTo(param4, _loc_12 * _loc_11);
                _loc_12++;
            }
            var _loc_13:int = 0;
            while (_loc_13 <= param2)
            {
                
                _loc_9.graphics.lineStyle(param7, param6, param8);
                _loc_9.graphics.moveTo(_loc_10 * _loc_13, 0);
                _loc_9.graphics.lineTo(_loc_13 * _loc_10, param5);
                _loc_13++;
            }
            return;
        }// end function

        public static function BlackAndWhiteDotLine(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
        {
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_7:Number = 0;
            if (param3 > param5)
            {
                _loc_10 = param5;
                param5 = param3;
                param3 = _loc_10;
            }
            if (param4 > param6)
            {
                _loc_10 = param6;
                param6 = param4;
                param4 = _loc_10;
            }
            param1.graphics.lineStyle(param2, 0, 0);
            param1.graphics.moveTo(param3, param4);
            _loc_8 = param3;
            _loc_9 = param4;
            if (param3 != param5)
            {
                while (_loc_8 < param5)
                {
                    
                    if (++_loc_7 % 2 == 0)
                    {
                        param1.graphics.lineStyle(param2, 16711680);
                    }
                    else
                    {
                        param1.graphics.lineStyle(param2, 0);
                    }
                    _loc_8 = _loc_8 + 1 / Math.sqrt((param6 - param4) * (param6 - param4) + (param5 - param3) * (param5 - param3)) * (param5 - param3);
                    param1.graphics.lineTo(_loc_8, _loc_9);
                }
            }
            else
            {
                while (_loc_9 < param6)
                {
                    
                    _loc_7 = ++_loc_7 + 1;
                    if (_loc_7 % 2 == 0)
                    {
                        param1.graphics.lineStyle(param2, 16777215);
                    }
                    else
                    {
                        param1.graphics.lineStyle(param2, 0, 0);
                    }
                    _loc_9 = _loc_9 + 1;
                    param1.graphics.lineTo(_loc_8, _loc_9);
                }
            }
            return;
        }// end function

    }
}
