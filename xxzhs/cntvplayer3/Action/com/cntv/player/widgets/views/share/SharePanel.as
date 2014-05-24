package com.cntv.player.widgets.views.share
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.common.view.ui.radioButton.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;

    public class SharePanel extends PopUpWindowBG
    {
        public var label_refSwf:TextField;
        public var txt_refSwf:TextField;
        public var label_refURL:TextField;
        public var txt_refURL:TextField;
        public var label_refHTML:TextField;
        public var txt_refHTML:TextField;
        public var copyButton1:CommonButton;
        public var copyButton2:CommonButton;
        public var copyButton3:CommonButton;
        private var appleSelectBk:Sprite;
        private var appleUnSelectBk:Sprite;
        private var appleSelect:RadioButton;
        private var appleUnSelect:RadioButton;
        public static const W:Number = 375;
        public static const H:Number = 200;
        public static const TEXT_W:Number = 250;
        public static const TXT_LEFT_GAP:Number = 15;
        public static const TXT_TOP_GAP:Number = 30;

        public function SharePanel()
        {
            _modelLocator = ModelLocator.getInstance();
            super(W, H, _modelLocator.i18n.WIDEGTS_SHARE);
            this.label_refURL = TextGenerator.createFontTxt(0, 14, _modelLocator.i18n.WIDEGTS_SHARE_URL, "");
            this.label_refURL.x = TXT_LEFT_GAP;
            this.label_refURL.y = TXT_TOP_GAP + INNER_BG_TOP_GAP;
            this.addChild(this.label_refURL);
            this.txt_refURL = TextGenerator.createBorderEditableSingleLineTxt(16777215, 0, 14, TEXT_W, this.label_refURL.height);
            this.txt_refURL.text = _modelLocator.currentVideoInfo.refURL;
            this.txt_refURL.x = this.label_refURL.x + this.label_refURL.width + TXT_LEFT_GAP;
            this.txt_refURL.y = TXT_TOP_GAP + INNER_BG_TOP_GAP;
            this.txt_refURL.selectable = false;
            this.addChild(this.txt_refURL);
            this.label_refHTML = TextGenerator.createFontTxt(0, 14, _modelLocator.i18n.WIDEGTS_SHARE_EMBED, "");
            this.label_refHTML.x = TXT_LEFT_GAP;
            this.label_refHTML.y = this.label_refURL.y + this.label_refURL.height + TXT_TOP_GAP;
            this.addChild(this.label_refHTML);
            this.txt_refHTML = TextGenerator.createInputMutliLineTxt(16777215, 0, 14, TEXT_W, 45);
            if (_modelLocator.paramVO.playBackMode == "audio" && _modelLocator.currentAudioInfo)
            {
                this.txt_refHTML.text = _modelLocator.currentAudioInfo.refHtml;
            }
            else
            {
                this.txt_refHTML.text = _modelLocator.currentVideoInfo.refHtml;
            }
            this.txt_refHTML.x = this.txt_refURL.x;
            this.txt_refHTML.y = this.label_refHTML.y;
            this.txt_refHTML.selectable = false;
            this.addChild(this.txt_refHTML);
            this.copyButton1 = new CommonButton(_modelLocator.i18n.WIDEGTS_COPY_SHARE_URL);
            this.copyButton1.x = this.txt_refURL.x + this.txt_refURL.width - this.copyButton1.width;
            this.copyButton1.y = this.txt_refURL.y + this.txt_refURL.height + 3;
            this.copyButton1.addEventListener(MouseEvent.CLICK, this.copyRefURL);
            this.addChild(this.copyButton1);
            this.copyButton2 = new CommonButton(_modelLocator.i18n.WIDEGTS_COPY_SHARE_EMBED);
            this.copyButton2.x = this.txt_refHTML.x + this.txt_refHTML.width - this.copyButton2.width;
            this.copyButton2.y = this.txt_refHTML.y + this.txt_refHTML.height + 3;
            this.copyButton2.addEventListener(MouseEvent.CLICK, this.copyRefHTML);
            this.addChild(this.copyButton2);
            this.appleUnSelect = new RadioButton(1, "pc:", "", true);
            this.addChild(this.appleUnSelect);
            this.appleUnSelect.x = this.label_refHTML.x + 70;
            this.appleUnSelect.y = this.label_refHTML.y + 50;
            this.appleSelect = new RadioButton(1, "ipad:", "", true);
            this.addChild(this.appleSelect);
            this.appleSelect.x = this.label_refHTML.x + 140;
            this.appleSelect.y = this.label_refHTML.y + 50;
            this.appleUnSelect.isSelected = true;
            this.appleSelect.isSelected = false;
            this.appleUnSelect.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onAppleUnSelect);
            this.appleSelect.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onAppleSelect);
            return;
        }// end function

        private function onAppleUnSelect(event:RadioButtonEvent) : void
        {
            this.appleSelect.isSelected = false;
            this.appleUnSelect.isSelected = true;
            if (_modelLocator.paramVO.playBackMode == "audio" && _modelLocator.currentAudioInfo)
            {
                this.txt_refHTML.text = _modelLocator.currentAudioInfo.refHtml;
            }
            else
            {
                this.txt_refHTML.text = _modelLocator.currentVideoInfo.refHtml;
            }
            return;
        }// end function

        private function onAppleSelect(event:RadioButtonEvent) : void
        {
            this.appleSelect.isSelected = true;
            this.appleUnSelect.isSelected = false;
            if (_modelLocator.paramVO.playBackMode == "audio" && _modelLocator.currentAudioInfo)
            {
                this.txt_refHTML.text = _modelLocator.currentAudioInfo.refIpadHtml;
            }
            else
            {
                this.txt_refHTML.text = _modelLocator.currentVideoInfo.refIpadHtml;
            }
            return;
        }// end function

        private function copyRefURL(event:MouseEvent) : void
        {
            var _loc_2:* = new StatusVO(_modelLocator.i18n.WIDEGTS_AFTER_COPY_SHARE_URL, StatuBoxEvent.TYPE_CENTER, true);
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            System.setClipboard(this.txt_refURL.text);
            return;
        }// end function

        private function copyRefHTML(event:MouseEvent) : void
        {
            var _loc_2:* = new StatusVO(_modelLocator.i18n.WIDEGTS_AFTER_COPY_SHARE_EMBED, StatuBoxEvent.TYPE_CENTER, true);
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            System.setClipboard(this.txt_refHTML.text);
            return;
        }// end function

    }
}
