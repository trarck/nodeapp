package com.cntv.common.view.ui
{
    import com.cntv.common.view.*;
    import com.puremvc.view.event.*;
    import flash.events.*;
    import flash.text.*;

    public class PopUpWindowBG extends CommonSprite
    {
        protected const INNER_BG_TOP_GAP:Number = 25;
        protected const INNER_BG_OTHER_GAP:Number = 10;
        private var outerBG:CommonMask;
        protected var innerBG:CommonMask;
        private var w:Number;
        private var h:Number;
        private var closeButton:CloseButton;
        private var title_txt:TextField;
        public static const EVENT_POPUP_CLOSE:String = "event.popup.close";

        public function PopUpWindowBG(param1:Number, param2:Number, param3:String, param4:Boolean = true)
        {
            this.w = param1;
            this.h = param2;
            this.outerBG = new CommonMask(this.w, this.h, 0, 0.6);
            this.addChild(this.outerBG);
            this.innerBG = new CommonMask(this.w - this.INNER_BG_OTHER_GAP * 2, this.h - this.INNER_BG_TOP_GAP - this.INNER_BG_OTHER_GAP, 16777215, 0.75);
            this.innerBG.x = this.INNER_BG_OTHER_GAP;
            this.innerBG.y = this.INNER_BG_TOP_GAP;
            this.addChild(this.innerBG);
            if (param4)
            {
                this.closeButton = new CloseButton();
                this.closeButton.x = this.w - this.closeButton.width - this.INNER_BG_OTHER_GAP;
                this.closeButton.y = (this.INNER_BG_TOP_GAP - this.closeButton.height) / 2;
                this.closeButton.addEventListener(MouseEvent.CLICK, this.closeSelf);
                this.addChild(this.closeButton);
            }
            this.title_txt = TextGenerator.createFontTxt(16777215, 15, param3, "");
            this.title_txt.x = this.INNER_BG_OTHER_GAP;
            this.title_txt.y = (this.INNER_BG_TOP_GAP - this.title_txt.height) / 2;
            this.addChild(this.title_txt);
            this.alpha = 0;
            this.scaleX = 0.3;
            this.scaleY = 0.3;
            return;
        }// end function

        protected function closeSelf(event:MouseEvent) : void
        {
            dispatchEvent(new CommonEvent(EVENT_POPUP_CLOSE, null, true));
            return;
        }// end function

        override protected function init() : void
        {
            super.init();
            return;
        }// end function

        override public function get width() : Number
        {
            return this.w;
        }// end function

        override public function set width(param1:Number) : void
        {
            this.w = param1;
            this.outerBG.width = this.w;
            this.innerBG.width = this.w - this.INNER_BG_OTHER_GAP * 2;
            return;
        }// end function

        override public function get height() : Number
        {
            return this.h;
        }// end function

        override public function set height(param1:Number) : void
        {
            this.h = param1;
            this.outerBG.height = this.h;
            this.innerBG.height = this.h - this.INNER_BG_TOP_GAP - this.INNER_BG_OTHER_GAP;
            return;
        }// end function

    }
}
