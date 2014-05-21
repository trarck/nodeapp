package com.cntv.common.view.ui.checkbox
{
    import com.cntv.common.model.vo.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.common.view.ui.checkbox.select.*;
    import com.cntv.common.view.ui.checkbox.unselect.*;
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class CheckBox extends CommonSprite
    {
        private var select:CommonSprite;
        private var unselect:CommonSprite;
        public var txt:TextField;
        private var clickLayer:Sprite;
        public var vo:CheckBoxVO;
        public var eventStr:String = "checkEvent";

        public function CheckBox(param1:CheckBoxVO, param2:CommonSprite = null, param3:CommonSprite = null)
        {
            this.vo = param1;
            if (param2 == null)
            {
                this.select = new CheckBoxSelected();
            }
            else
            {
                this.select = param2;
            }
            if (param3 == null)
            {
                this.unselect = new CheckBoxUnselect();
            }
            else
            {
                this.unselect = param3;
            }
            this.update();
            this.addChild(this.select);
            this.addChild(this.unselect);
            this.txt = TextGenerator.createTxt(13487565, 13, param1.text, false, 0, true);
            this.txt.x = this.select.width + 5;
            this.txt.y = 5;
            var _loc_4:* = (this.txt.height - this.unselect.height) / 2;
            this.unselect.y = (this.txt.height - this.unselect.height) / 2;
            this.select.y = _loc_4;
            this.clickLayer = new Sprite();
            this.addChild(this.clickLayer);
            this.clickLayer.y = 6;
            this.clickLayer.graphics.beginFill(16711680, 0);
            this.clickLayer.graphics.drawRect(0, 0, this.txt.width + 20, this.txt.height);
            this.clickLayer.graphics.endFill();
            this.buttonMode = true;
            this.mouseChildren = false;
            this.addChild(this.txt);
            this.addEventListener(MouseEvent.CLICK, this.changeSelect);
            return;
        }// end function

        private function changeSelect(event:MouseEvent) : void
        {
            this.vo.isSelect = !this.vo.isSelect;
            this.update();
            this.dispatchEvent(new CommonEvent(this.eventStr));
            return;
        }// end function

        private function doselect(event:MouseEvent) : void
        {
            this.vo.isSelect = true;
            this.update();
            return;
        }// end function

        private function doDiselect(event:MouseEvent) : void
        {
            this.vo.isSelect = false;
            this.update();
            return;
        }// end function

        private function update() : void
        {
            this.select.visible = this.vo.isSelect;
            this.unselect.visible = !this.vo.isSelect;
            return;
        }// end function

        public function set isSelect(param1:Boolean) : void
        {
            this.vo.isSelect = param1;
            this.update();
            return;
        }// end function

        public function get isSelect() : Boolean
        {
            return this.vo.isSelect;
        }// end function

    }
}
