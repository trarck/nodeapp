package com.cntv.common.view.ui
{
    import com.cntv.common.view.*;
    import flash.events.*;
    import flash.text.*;

    public class CommonButton extends CommonSprite
    {
        private var skin:Class;
        private var bg:Object;
        private var _w:Number;
        private var _h:Number;
        private var txt_panel:TextField;
        private var targetArea:CommonMask;

        public function CommonButton(param1:String)
        {
            this.skin = CommonButton_skin;
            this.bg = new this.skin();
            this.addChild(this.bg);
            this.txt_panel = TextGenerator.createTxt(16777215, 13, param1, false, 0, true);
            this._w = this.txt_panel.width + 20;
            this._h = this.txt_panel.height + 12;
            this.bg.width = this._w;
            this.bg.height = 30;
            this.txt_panel.x = 10;
            this.txt_panel.y = 4;
            this.addChild(this.txt_panel);
            this.targetArea = new CommonMask(this._w, this._h, 0, 0);
            this.targetArea.addEventListener(MouseEvent.ROLL_OVER, this.mouseOver);
            this.targetArea.addEventListener(MouseEvent.ROLL_OUT, this.mouseOut);
            this.targetArea.buttonMode = true;
            this.addChild(this.targetArea);
            return;
        }// end function

        private function mouseOver(event:MouseEvent) : void
        {
            this.bg["alpha"] = 0.5;
            return;
        }// end function

        private function mouseOut(event:MouseEvent) : void
        {
            this.bg["alpha"] = 1;
            return;
        }// end function

        override public function get width() : Number
        {
            return this._w;
        }// end function

        override public function get height() : Number
        {
            return this._h;
        }// end function

    }
}
