package com.cntv.common.view.ui.radioButton
{
    import com.cntv.common.events.*;
    import com.cntv.common.view.*;
    import com.puremvc.view.ui.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class RadioButton extends CommonSprite
    {
        public var index:int;
        private var select:RadioSelectedButton;
        private var unselect:RadioUnselectedButton;
        private var _isSelected:Boolean;
        private var txt_panel:TextField;
        private var bk:Sprite;
        private var clickLayer:Sprite;
        public var mode:String = "";
        public static const BUTTON_H:int = 20;

        public function RadioButton(param1:int, param2:String, param3:String = "", param4:Boolean = false, param5:Number = 6710886)
        {
            if (param4)
            {
                this.bk = new Sprite();
                this.addChild(this.bk);
            }
            this.mode = param3;
            this.index = param1;
            this.select = new RadioSelectedButton();
            this.addChild(this.select);
            this.unselect = new RadioUnselectedButton();
            this.addChild(this.unselect);
            this.txt_panel = TextGenerator.createTxt(13487565, 13, param2, false, 0, true, "");
            this.txt_panel.x = 16;
            this.txt_panel.y = -4;
            this.addChild(this.txt_panel);
            this.isSelected = false;
            this.clickLayer = new Sprite();
            this.addChild(this.clickLayer);
            this.clickLayer.y = -2;
            this.clickLayer.graphics.beginFill(16711680, 0);
            this.clickLayer.graphics.drawRect(0, 0, this.txt_panel.width + 20, this.txt_panel.height);
            this.clickLayer.graphics.endFill();
            this.buttonMode = true;
            this.mouseChildren = false;
            this.addEventListener(MouseEvent.CLICK, this.selectHandler);
            if (this.bk)
            {
                this.bk.graphics.beginFill(param5);
                this.bk.graphics.drawRect(0, 0, 30 + this.txt_panel.textWidth, 15);
                this.bk.graphics.endFill();
            }
            return;
        }// end function

        public function set txt(param1:String) : void
        {
            this.txt_panel.text = param1;
            return;
        }// end function

        public function set isSelected(param1:Boolean) : void
        {
            this._isSelected = param1;
            this.select.visible = this._isSelected;
            this.unselect.visible = !this._isSelected;
            if (this._isSelected)
            {
                this.txt_panel.textColor = 5949713;
            }
            else
            {
                this.txt_panel.textColor = 13487565;
            }
            return;
        }// end function

        public function setStatus(param1:Boolean) : void
        {
            this.isSelected = param1;
            return;
        }// end function

        public function get isSelected() : Boolean
        {
            return this._isSelected;
        }// end function

        public function removeClickListener() : void
        {
            this.removeEventListener(MouseEvent.CLICK, this.selectHandler);
            this.buttonMode = false;
            this.mouseChildren = false;
            return;
        }// end function

        public function get textWidth() : Number
        {
            if (this.txt_panel == null)
            {
                return this.select.width;
            }
            return this.txt_panel.textWidth + 20 + this.select.width;
        }// end function

        private function selectHandler(event:MouseEvent) : void
        {
            this.isSelected = true;
            dispatchEvent(new RadioButtonEvent(RadioButtonEvent.EVENT_SELECTED, this.index));
            return;
        }// end function

    }
}
