package com.cntv.common.view.ui
{
    import flash.display.*;

    public class CommonMask extends Sprite
    {
        private var _w:Number;
        private var _h:Number;
        private var _al:Number;
        private var _color:uint;
        private var _type:String;
        private var _ellipseW:Number;
        private var _ellipseH:Number;
        public static const TYPE_S:String = "s";
        public static const TYPE_R:String = "r";

        public function CommonMask(param1:Number = 100, param2:Number = 30, param3:uint = 0, param4:Number = 1, param5:String = "r", param6:Number = 8, param7:Number = 8)
        {
            this._w = param1;
            this._h = param2;
            this._al = param4;
            this._color = param3;
            this._type = param5;
            this._ellipseW = param6;
            this._ellipseH = param7;
            this.drawBG();
            return;
        }// end function

        public function drawBG() : void
        {
            graphics.clear();
            graphics.beginFill(this._color, this._al);
            if (this._type == TYPE_S)
            {
                graphics.drawRect(0, 0, this._w, this._h);
            }
            else
            {
                graphics.drawRoundRect(0, 0, this._w, this._h, this._ellipseW, this._ellipseH);
            }
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

        override public function get height() : Number
        {
            return this._h;
        }// end function

        override public function set height(param1:Number) : void
        {
            this._h = param1;
            this.drawBG();
            return;
        }// end function

    }
}
