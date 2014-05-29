package com.cntv.player.floatLayer.share
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.common.view.ui.radioButton.*;
    import com.cntv.player.playerCom.relativeList.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;

    public class CSharePanel extends CommonSprite
    {
        private var closeBGSkin:Class;
        private var closeBTNSkin:Class;
        private var hotBackSkin:Class;
        private var titleBgSkin:Class;
        private var okSkin:Class;
        private var infobgSkin:Class;
        private var copy1Skin:Class;
        private var copy2Skin:Class;
        private var share_sina1:Class;
        public var ob_sina:DisplayObject;
        private var share_qq1:Class;
        public var ob_qq:DisplayObject;
        private var share_sohu1:Class;
        public var ob_sohu:DisplayObject;
        private var share_qzone1:Class;
        public var ob_qzone:DisplayObject;
        private var share_renren1:Class;
        public var ob_renren:DisplayObject;
        private var share_kaixin1:Class;
        public var ob_kaixin:DisplayObject;
        public var copyButton1:Sprite;
        public var copyButton2:Sprite;
        public var copyButton3:Sprite;
        private var panelBg:Sprite;
        private var panelTitle:Sprite;
        private var titleText:TextField;
        private var closeBtn:Sprite;
        private var closeBtnBg:Sprite;
        private var closeBG:Sprite;
        private var closeBTN:Sprite;
        private var closeLayer:Sprite;
        private var clickLayer:Sprite;
        private var sureBtn:Sprite;
        private var sureText:TextField;
        public var label_refSwf:TextField;
        public var txt_refSwf:TextField;
        public var label_refURL:TextField;
        public var txt_refURL:TextField;
        public var label_refHTML:TextField;
        public var txt_refHTML:TextField;
        public var label_flashURL:TextField;
        public var txt_flashURL:TextField;
        public var label_share:TextField;
        public var label_copyTo:TextField;
        private var icons:Array;
        private var appleSelectBk:Sprite;
        private var appleUnSelectBk:Sprite;
        private var appleSelect:RadioButton;
        private var appleUnSelect:RadioButton;
        private var isfirst:Boolean = true;
        private const INNER_BG_TOP_GAP:Number = 25;
        private var infoBg:Sprite;
        private var copybtn1:CommonButton;
        private var copybtn2:CommonButton;
        private var copybtn3:CommonButton;
        public static const W:Number = 375;
        public static const H:Number = 200;
        public static const TEXT_W:Number = 200;
        public static const TXT_LEFT_GAP:Number = 30;
        public static const TXT_TOP_GAP:Number = 40;

        public function CSharePanel()
        {
            this.closeBGSkin = CSharePanel_closeBGSkin;
            this.closeBTNSkin = CSharePanel_closeBTNSkin;
            this.hotBackSkin = CSharePanel_hotBackSkin;
            this.titleBgSkin = CSharePanel_titleBgSkin;
            this.okSkin = CSharePanel_okSkin;
            this.infobgSkin = CSharePanel_infobgSkin;
            this.copy1Skin = CSharePanel_copy1Skin;
            this.copy2Skin = CSharePanel_copy2Skin;
            this.share_sina1 = CSharePanel_share_sina1;
            this.ob_sina = new this.share_sina1();
            this.share_qq1 = CSharePanel_share_qq1;
            this.ob_qq = new this.share_qq1();
            this.share_sohu1 = CSharePanel_share_sohu1;
            this.ob_sohu = new this.share_sohu1();
            this.share_qzone1 = CSharePanel_share_qzone1;
            this.ob_qzone = new this.share_qzone1();
            this.share_renren1 = CSharePanel_share_renren1;
            this.ob_renren = new this.share_renren1();
            this.share_kaixin1 = CSharePanel_share_kaixin1;
            this.ob_kaixin = new this.share_kaixin1();
            this.icons = [];
            _modelLocator = ModelLocator.getInstance();
            return;
        }// end function

        public function initView() : void
        {
            if (this.label_refURL != null)
            {
                return;
            }
            this.label_share = TextGenerator.createFontTxt(13487565, 13, _modelLocator.i18n.RELATIVA_SHARE, "", true);
            this.label_share.x = TXT_LEFT_GAP;
            this.label_share.y = TXT_TOP_GAP + this.INNER_BG_TOP_GAP - 10;
            this.addChild(this.label_share);
            this.label_copyTo = TextGenerator.createFontTxt(13487565, 13, _modelLocator.i18n.COPY_URL, "", true);
            this.label_copyTo.x = TXT_LEFT_GAP;
            this.label_copyTo.y = TXT_TOP_GAP + this.INNER_BG_TOP_GAP + 40;
            this.addChild(this.label_copyTo);
            this.copybtn1 = new CommonButton(_modelLocator.i18n.WIDEGTS_COPY_SHARE_URL);
            this.addChild(this.copybtn1);
            this.copybtn1.addEventListener(MouseEvent.CLICK, this.copyRefURL);
            this.copybtn1.x = TXT_LEFT_GAP;
            this.copybtn1.y = this.label_copyTo.y + 30;
            this.copybtn2 = new CommonButton(_modelLocator.i18n.WIDEGTS_COPY_SHARE_EMBED);
            this.addChild(this.copybtn2);
            this.copybtn2.addEventListener(MouseEvent.CLICK, this.copyRefHTML);
            this.copybtn2.x = TXT_LEFT_GAP;
            this.copybtn2.y = this.copybtn1.y + 50;
            if (_modelLocator.paramVO.isFlashAddress)
            {
                this.copybtn3 = new CommonButton(_modelLocator.i18n.WIDEGTS_COPY_FLASH_URL);
                this.addChild(this.copybtn3);
                this.copybtn3.addEventListener(MouseEvent.CLICK, this.copyFlashAddress);
                this.copybtn3.x = TXT_LEFT_GAP;
                this.copybtn1.y = this.label_copyTo.y + 20;
                this.copybtn2.y = this.copybtn1.y + 40;
                this.copybtn3.y = this.copybtn2.y + 40;
            }
            this.titleText.text = _modelLocator.i18n.WIDEGTS_SHARE;
            this.txt_refHTML = new TextField();
            if (_modelLocator.paramVO.playBackMode == "audio" && _modelLocator.currentAudioInfo)
            {
                this.txt_refHTML.text = _modelLocator.currentAudioInfo.refHtml;
            }
            else
            {
                this.txt_refHTML.text = _modelLocator.currentVideoInfo.refHtml;
            }
            this.appleUnSelect = new RadioButton(1, "PC", "", false);
            this.addChild(this.appleUnSelect);
            this.appleUnSelect.x = this.copybtn1.x + 120;
            this.appleSelect = new RadioButton(1, "iPad", "", false);
            this.addChild(this.appleSelect);
            this.appleSelect.x = this.copybtn2.x + 170;
            var _loc_1:* = this.copybtn2.y + 10;
            this.appleSelect.y = this.copybtn2.y + 10;
            this.appleUnSelect.y = _loc_1;
            if (_modelLocator.paramVO.isFlashAddress)
            {
                var _loc_1:* = this.copybtn3.y + 10;
                this.appleSelect.y = this.copybtn3.y + 10;
                this.appleUnSelect.y = _loc_1;
            }
            this.appleUnSelect.isSelected = true;
            this.appleSelect.isSelected = false;
            this.appleUnSelect.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onAppleUnSelect);
            this.appleSelect.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onAppleSelect);
            return;
        }// end function

        override protected function init() : void
        {
            var _loc_1:DisplayObject = null;
            _loc_1 = new this.hotBackSkin();
            this.panelBg = new Sprite();
            this.panelBg.addChild(_loc_1);
            this.panelBg.x = 0;
            this.panelBg.y = 30;
            this.panelBg.width = 260;
            this.panelBg.height = 220;
            this.addChild(this.panelBg);
            _loc_1 = new this.titleBgSkin();
            this.panelTitle = new Sprite();
            this.panelTitle.addChild(_loc_1);
            this.panelTitle.x = 0;
            this.panelTitle.y = 0;
            this.panelTitle.width = 260;
            this.addChild(this.panelTitle);
            this.titleText = new TextField();
            this.titleText.defaultTextFormat = new TextFormat("雅黑", 14, 14540253, true);
            this.titleText.height = 30;
            this.titleText.x = 10;
            this.titleText.y = 5;
            this.titleText.width = 300;
            this.titleText.text = _modelLocator.i18n.WIDEGTS_SHARE;
            this.addChild(this.titleText);
            _loc_1 = new this.closeBTNSkin();
            this.closeBTN = new Sprite();
            this.closeBTN.addChild(_loc_1);
            this.addChild(this.closeBTN);
            this.closeBTN.x = 233;
            this.closeBTN.y = 4.5;
            this.closeLayer = new Sprite();
            this.addChild(this.closeLayer);
            _loc_1 = new this.infobgSkin();
            this.infoBg = new Sprite();
            this.infoBg.addChild(_loc_1);
            this.infoBg.x = 10;
            this.infoBg.y = 37;
            this.infoBg.width = 240;
            this.addChild(this.infoBg);
            _loc_1 = new this.closeBGSkin();
            this.closeBG = new Sprite();
            this.closeBG.addChild(_loc_1);
            this.closeLayer.addChild(this.closeBG);
            this.closeBG.x = 224;
            this.closeBG.y = 0;
            this.closeLayer.visible = false;
            this.clickLayer = new Sprite();
            this.clickLayer.graphics.beginFill(16711680, 0);
            this.clickLayer.graphics.drawRect(0, 0, 36, 29);
            this.clickLayer.graphics.endFill();
            this.clickLayer.x = 224;
            this.clickLayer.buttonMode = true;
            this.addChild(this.clickLayer);
            _loc_1 = new this.okSkin();
            this.sureBtn = new Sprite();
            this.sureBtn.addChild(_loc_1);
            this.sureBtn.x = (440 - this.sureBtn.width) / 2;
            this.sureBtn.y = 130;
            this.sureBtn.buttonMode = true;
            var _loc_2:* = new quickShareBtn("新浪微博", this.ob_sina);
            this.addChild(_loc_2);
            this.icons.push(_loc_2);
            _loc_2.addEventListener(MouseEvent.CLICK, this.onSinaClick);
            var _loc_3:* = new quickShareBtn("腾讯微博", this.ob_qq);
            this.addChild(_loc_3);
            this.icons.push(_loc_3);
            _loc_3.addEventListener(MouseEvent.CLICK, this.onQQWeiboClick);
            var _loc_4:* = new quickShareBtn("搜狐微博", this.ob_sohu);
            this.addChild(_loc_4);
            this.icons.push(_loc_4);
            _loc_4.addEventListener(MouseEvent.CLICK, this.onSohuClick);
            var _loc_5:* = new quickShareBtn("QQ空间", this.ob_qzone);
            this.addChild(_loc_5);
            this.icons.push(_loc_5);
            _loc_5.addEventListener(MouseEvent.CLICK, this.onQQClick);
            var _loc_6:* = new quickShareBtn("人人网", this.ob_renren);
            this.addChild(_loc_6);
            this.icons.push(_loc_6);
            _loc_6.addEventListener(MouseEvent.CLICK, this.onRenrenClick);
            var _loc_7:* = new quickShareBtn("开心网", this.ob_kaixin);
            this.addChild(_loc_7);
            this.icons.push(_loc_7);
            _loc_7.addEventListener(MouseEvent.CLICK, this.onKaixinClick);
            var _loc_8:int = 0;
            while (_loc_8 < this.icons.length)
            {
                
                this.icons[_loc_8].x = TXT_LEFT_GAP + _loc_8 * 25;
                this.icons[_loc_8].y = TXT_TOP_GAP + this.INNER_BG_TOP_GAP + 10;
                _loc_8++;
            }
            this.clickLayer.addEventListener(MouseEvent.MOUSE_OVER, this.oncloseBtnOver);
            this.clickLayer.addEventListener(MouseEvent.MOUSE_OUT, this.oncloseBtnOut);
            this.clickLayer.addEventListener(MouseEvent.CLICK, this.oncloseBtnClick);
            return;
        }// end function

        private function oncloseBtnOver(event:MouseEvent) : void
        {
            this.closeLayer.visible = true;
            this.closeLayer.addChild(this.closeBTN);
            return;
        }// end function

        private function oncloseBtnOut(event:MouseEvent) : void
        {
            this.closeLayer.visible = false;
            this.addChild(this.closeBTN);
            return;
        }// end function

        private function oncloseBtnClick(event:MouseEvent) : void
        {
            this.visible = false;
            return;
        }// end function

        private function onOkClick(event:MouseEvent) : void
        {
            this.visible = false;
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
            System.setClipboard(_modelLocator.currentVideoInfo.refURL);
            return;
        }// end function

        private function copyRefHTML(event:MouseEvent) : void
        {
            var _loc_2:* = new StatusVO(_modelLocator.i18n.WIDEGTS_AFTER_COPY_SHARE_EMBED, StatuBoxEvent.TYPE_CENTER, true);
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            System.setClipboard(this.txt_refHTML.text);
            return;
        }// end function

        private function copyFlashAddress(event:MouseEvent) : void
        {
            var _loc_2:* = new StatusVO(_modelLocator.i18n.WIDEGTS_AFTER_COPY_SWF_EMBED, StatuBoxEvent.TYPE_CENTER, true);
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            System.setClipboard(_modelLocator.currentVideoInfo.FlashURL);
            return;
        }// end function

        private function onSinaClick(event:MouseEvent) : void
        {
            NativeToURLTool.openAURL("http://v.t.sina.com.cn/share/share.php?appkey=2078561600&url=" + escape(_modelLocator.paramVO.url));
            return;
        }// end function

        private function onQQClick(event:MouseEvent) : void
        {
            NativeToURLTool.openAURL("http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=" + escape(_modelLocator.paramVO.url));
            return;
        }// end function

        private function onQQWeiboClick(event:MouseEvent) : void
        {
            NativeToURLTool.openAURL("http://v.t.qq.com/share/share.php?appkey=ce5e42dabdeb46069382c3554333f281&url=" + escape(_modelLocator.paramVO.url));
            return;
        }// end function

        private function onSohuClick(event:MouseEvent) : void
        {
            NativeToURLTool.openAURL("http://t.sohu.com/third/post.jsp?url=" + escape(_modelLocator.paramVO.url));
            return;
        }// end function

        private function onRenrenClick(event:MouseEvent) : void
        {
            NativeToURLTool.openAURL("http://share.renren.com/share/buttonshare.do?link=" + escape(_modelLocator.paramVO.url));
            return;
        }// end function

        private function onKaixinClick(event:MouseEvent) : void
        {
            NativeToURLTool.openAURL("http://www.kaixin001.com/repaste/share.php?type=video&rurl=" + escape(_modelLocator.paramVO.url));
            return;
        }// end function

    }
}
