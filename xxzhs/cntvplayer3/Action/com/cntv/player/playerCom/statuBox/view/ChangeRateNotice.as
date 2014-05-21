package com.cntv.player.playerCom.statuBox.view
{
    import com.cntv.common.events.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;

    public class ChangeRateNotice extends CommonSprite
    {
        private var bg:CommonMask;
        private var txtTitle:TextField;
        private var gFilter:GlowFilter;
        private var cover:Sprite;
        private var tip:String = "若您感觉画面不流畅，可 ";
        private var textBtn:TextField;
        public var btnText:String = "";
        private var modeText:String = "切换到更佳流畅模式";
        public var modeTextField:TextField;
        private var format:TextFormat;
        public static const EVENT_CLOSE:String = "event.close";
        public static const W:Number = 420;
        public static const H:Number = 50;

        public function ChangeRateNotice()
        {
            this.cover = new Sprite();
            this.tip = _modelLocator.i18n.WIDEGTS_NOTICE_CHANGE_RATE;
            this.btnText = _modelLocator.i18n.WIDEGTS_NOTICE_CLICK_HERE;
            this.textBtn = new TextField();
            this.textBtn.text = this.btnText;
            this.format = new TextFormat();
            this.format.underline = true;
            this.format.bold = false;
            this.format.size = 14;
            this.format.color = 33023;
            this.textBtn.setTextFormat(this.format);
            this.textBtn.y = 18;
            this.cover.addChild(this.textBtn);
            this.modeTextField = TextGenerator.createTxt(16777215, 12, _modelLocator.i18n.WIDEGTS_NOTICE_CHANGE_RATE);
            this.modeTextField.y = 18;
            this.addChild(this.modeTextField);
            this.textBtn.x = this.modeTextField.textWidth;
            this.cover.buttonMode = true;
            this.cover.mouseChildren = false;
            this.cover.addEventListener(MouseEvent.CLICK, this.onClick);
            this.addChild(this.cover);
            return;
        }// end function

        public function set Visible(param1:Boolean) : void
        {
            this.visible = param1;
            this.modeTextField.text = _modelLocator.i18n.WIDEGTS_NOTICE_CHANGE_RATE;
            this.textBtn.text = _modelLocator.i18n.WIDEGTS_NOTICE_CLICK_HERE;
            this.textBtn.setTextFormat(this.format);
            this.modeTextField.setTextFormat(new TextFormat("", 14, 16777215));
            this.modeTextField.x = 0;
            this.textBtn.x = this.modeTextField.x + this.modeTextField.textWidth;
            return;
        }// end function

        public function setbtnText(param1:String) : void
        {
            this.btnText = param1;
            return;
        }// end function

        public function setModeText(param1:Number) : void
        {
            switch(param1)
            {
                case 1:
                {
                    this.modeText = "切换到流畅模式";
                    break;
                }
                case 2:
                {
                    this.modeText = "切换到超流畅模式";
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function getWidth() : Number
        {
            return this.textBtn.textWidth + this.modeTextField.textWidth + 5;
        }// end function

        private function onTextBtnClick(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.CHANGE_RATE_CLICK));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_CHANGERATE_CLICKED, null));
            return;
        }// end function

        private function onClick(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.CHANGE_RATE_CLICK));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_CHANGERATE_CLICKED, null));
            return;
        }// end function

        override protected function release() : void
        {
            super.release();
            this.cover.removeEventListener(MouseEvent.CLICK, this.onClick);
            return;
        }// end function

    }
}
