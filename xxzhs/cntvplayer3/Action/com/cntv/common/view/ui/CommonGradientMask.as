package com.cntv.common.view.ui
{
    import flash.display.*;
    import flash.geom.*;

    public class CommonGradientMask extends Sprite
    {
        private var _w:Number;
        private var _h:Number;
        private var _al1:Number;
        private var _al2:Number;
        private var _color1:uint;
        private var _color2:uint;
        private var _type:String;
        private var ratio:Number;

        public function CommonGradientMask(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:uint, param8:Number = 0)
        {
            this._type = param1;
            this._w = param2;
            this._h = param3;
            this._al1 = param4;
            this._al2 = param5;
            this._color1 = param6;
            this._color2 = param7;
            this.ratio = param8;
            this.drawBG();
            return;
        }// end function

        public function drawBG() : void
        {
            graphics.clear();
            var _loc_1:* = new Matrix();
            if (this._type == "r")
            {
                _loc_1.createGradientBox(this._w, this._h, 0, 0, 0);
                graphics.beginGradientFill(GradientType.RADIAL, [this._color1, this._color2], [this._al1, this._al2], [0, 255], _loc_1);
            }
            else
            {
                _loc_1.createGradientBox(this._w, this._h, this.ratio);
                graphics.beginGradientFill(GradientType.LINEAR, [this._color1, this._color2], [this._al1, this._al2], [0, 255], _loc_1);
            }
            graphics.drawRect(0, 0, this._w, this._h);
            graphics.endFill();
            return;
        }// end function

        override public function get width() : Number
        {
            return this._w;
        }// end function

        override public function set width(param1:Number) : void
        {
            this._w = param1;
            this.drawBG();
            return;
        }// end function

    }
}
