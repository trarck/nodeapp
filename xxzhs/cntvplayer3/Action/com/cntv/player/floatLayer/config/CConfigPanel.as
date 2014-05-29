package com.cntv.player.floatLayer.config
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.common.view.ui.checkbox.*;
    import com.cntv.common.view.ui.progress.*;
    import com.cntv.common.view.ui.radioButton.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class CConfigPanel extends CommonSprite
    {
        private var panelBg:Sprite;
        private var panelTitle:Sprite;
        private var titleText:TextField;
        private var closeBtn:Sprite;
        private var closeBtnBg:Sprite;
        private var _parent:ControlBarModule;
        private var closeBG:Sprite;
        private var closeBTN:Sprite;
        private var closeLayer:Sprite;
        private var clickLayer:Sprite;
        private var recovery:TextField;
        private var rec:Sprite;
        private var infoBg:Sprite;
        private var color:Sprite;
        private var playset:Sprite;
        private var playset1:Sprite;
        private var colorText:TextField;
        private var playsetText:TextField;
        private var photoText:TextField;
        private var colorText1:TextField;
        private var playsetText1:TextField;
        private var photoText1:TextField;
        private var turnleft:TextField;
        private var turnright:TextField;
        private var colorMask:Sprite;
        private var playsetMask:Sprite;
        private var photoMask:Sprite;
        private var colorLayer:Sprite;
        private var playsetLayer:Sprite;
        private var photosetLayer:Sprite;
        private var checkbox1:CheckBox;
        private var checkboxVO1:CheckBoxVO;
        private var checkbox2:CheckBox;
        private var checkboxVO2:CheckBoxVO;
        private var brightNessSlider:CHProgress;
        private var contrastSlider:CHProgress;
        private var brightNessText:TextField;
        private var contrastText:TextField;
        private var photosizeSlider:CHProgress;
        private var photorateText:TextField;
        private var photosizeText:TextField;
        private var photorotationText:TextField;
        private var surebtn:CommonButton;
        private var cancelbtn:CommonButton;
        private var titlebg1:Sprite;
        private var titlebg2:Sprite;
        private var titlebg3:Sprite;
        private var toleft:Sprite;
        private var toright:Sprite;
        private var left:Sprite;
        private var right:Sprite;
        private var rate1:RadioButton;
        private var rate2:RadioButton;
        private var rate3:RadioButton;
        private var rate4:RadioButton;
        private var closeBGSkin:Class;
        private var closeBTNSkin:Class;
        private var hotBackSkin:Class;
        private var infobgSkin:Class;
        private var configSkin:Class;
        private var colorSkin:Class;
        private var playsetSkin:Class;
        private var titleBGSkin:Class;
        private var toleftSkin:Class;
        private var torightSkin:Class;
        private var _contrast:Number = 0.1;
        private var _brightness:Number = 0.5;
        private var _isRemenberLastTime:Boolean = true;
        private var _size:Number = 1;
        private var _rate:Number = 1;
        private var _angel:Number = 0;

        public function CConfigPanel()
        {
            this.closeBGSkin = CConfigPanel_closeBGSkin;
            this.closeBTNSkin = CConfigPanel_closeBTNSkin;
            this.hotBackSkin = CConfigPanel_hotBackSkin;
            this.infobgSkin = CConfigPanel_infobgSkin;
            this.configSkin = CConfigPanel_configSkin;
            this.colorSkin = CConfigPanel_colorSkin;
            this.playsetSkin = CConfigPanel_playsetSkin;
            this.titleBGSkin = CConfigPanel_titleBGSkin;
            this.toleftSkin = CConfigPanel_toleftSkin;
            this.torightSkin = CConfigPanel_torightSkin;
            return;
        }// end function

        override protected function init() : void
        {
            var _loc_1:DisplayObject = null;
            _loc_1 = new this.configSkin();
            this.panelBg = new Sprite();
            this.panelBg.addChild(_loc_1);
            this.panelBg.y = 30;
            this.panelBg.width = 440;
            this.addChild(this.panelBg);
            this.panelTitle = new Sprite();
            this.panelTitle.graphics.beginFill(0, 1);
            this.panelTitle.graphics.drawRect(0, 0, 440, 30);
            this.panelTitle.graphics.endFill();
            this.addChild(this.panelTitle);
            this.titleText = new TextField();
            this.titleText.defaultTextFormat = new TextFormat("雅黑", 14, 14540253, true);
            this.titleText.height = 30;
            this.titleText.x = 10;
            this.titleText.y = 5;
            this.titleText.width = 300;
            this.titleText.text = _modelLocator.i18n.CONTROLBAR_NOTICE_CONFIG;
            this.panelTitle.addChild(this.titleText);
            _loc_1 = new this.closeBTNSkin();
            this.closeBTN = new Sprite();
            this.closeBTN.addChild(_loc_1);
            this.addChild(this.closeBTN);
            this.closeBTN.x = 413;
            this.closeBTN.y = 4.5;
            this.closeLayer = new Sprite();
            this.addChild(this.closeLayer);
            _loc_1 = new this.closeBGSkin();
            this.closeBG = new Sprite();
            this.closeBG.addChild(_loc_1);
            this.closeLayer.addChild(this.closeBG);
            this.closeBG.x = 404;
            this.closeBG.y = 0;
            this.closeLayer.visible = false;
            this.clickLayer = new Sprite();
            this.clickLayer.graphics.beginFill(16711680, 0);
            this.clickLayer.graphics.drawRect(0, 0, 36, 29);
            this.clickLayer.graphics.endFill();
            this.clickLayer.x = 404;
            this.clickLayer.buttonMode = true;
            this.addChild(this.clickLayer);
            this.rec = new Sprite();
            this.recovery = new TextField();
            this.recovery.defaultTextFormat = new TextFormat("", 14, 13487565, true, false, true);
            this.recovery.height = 30;
            this.recovery.width = 100;
            this.recovery.text = _modelLocator.i18n.CONFIG_RECOVERY;
            this.rec.addChild(this.recovery);
            this.rec.buttonMode = true;
            this.rec.mouseChildren = false;
            this.addChild(this.rec);
            _loc_1 = new this.infobgSkin();
            this.infoBg = new Sprite();
            this.infoBg.addChild(_loc_1);
            this.infoBg.x = 10;
            this.infoBg.y = 67;
            this.infoBg.width = 420;
            this.addChild(this.infoBg);
            this.colorLayer = new Sprite();
            this.addChild(this.colorLayer);
            this.colorLayer.visible = true;
            this.playsetLayer = new Sprite();
            this.addChild(this.playsetLayer);
            this.playsetLayer.visible = false;
            this.photosetLayer = new Sprite();
            this.addChild(this.photosetLayer);
            this.photosetLayer.visible = false;
            _loc_1 = new this.titleBGSkin();
            this.titlebg1 = new Sprite();
            this.titlebg1.addChild(_loc_1);
            this.titlebg1.y = 36;
            this.titlebg1.x = 10;
            this.titlebg1.width = 98;
            this.colorLayer.addChild(this.titlebg1);
            this.brightNessText = new TextField();
            this.brightNessText.defaultTextFormat = new TextFormat("", 13, 13487565, true);
            this.brightNessText.text = _modelLocator.i18n.CONTROLBAR_NOTICE_PICTURE_ADJUST_BRIGHT;
            this.brightNessText.height = 20;
            this.brightNessText.width = this.brightNessText.textWidth;
            this.brightNessText.x = 40;
            this.brightNessText.y = 114;
            this.colorLayer.addChild(this.brightNessText);
            this.brightNessSlider = new CHProgress(230, 5, 0.5, "brightChange");
            this.brightNessSlider.x = 130;
            this.brightNessSlider.y = 120;
            this.colorLayer.addChild(this.brightNessSlider);
            this.brightNessSlider.addEventListener("brightChange", this.onBrightChange);
            this.contrastText = new TextField();
            this.contrastText.defaultTextFormat = new TextFormat("", 13, 13487565, true);
            this.contrastText.text = _modelLocator.i18n.CONTROLBAR_NOTICE_PICTURE_ADJUST_CONTRAST;
            this.contrastText.height = 20;
            this.contrastText.width = this.contrastText.textWidth;
            this.contrastText.x = 40;
            this.contrastText.y = 148;
            this.colorLayer.addChild(this.contrastText);
            this.contrastSlider = new CHProgress(230, 5, 0.1, "contrastChange");
            this.contrastSlider.x = 130;
            this.contrastSlider.y = 154;
            this.colorLayer.addChild(this.contrastSlider);
            this.contrastSlider.addEventListener("contrastChange", this.onContrastChange);
            this.colorText = new TextField();
            this.colorText.defaultTextFormat = new TextFormat("雅黑", 14, 10066329, true);
            this.colorText.text = _modelLocator.i18n.CONFIG_COLOR;
            this.colorText.x = 42;
            this.colorText.y = 41;
            this.colorText.height = 30;
            this.addChild(this.colorText);
            this.colorText1 = new TextField();
            this.colorText1.defaultTextFormat = new TextFormat("雅黑", 14, 16777215, true);
            this.colorText1.text = _modelLocator.i18n.CONFIG_COLOR;
            this.colorText1.x = 42;
            this.colorText1.y = 41;
            this.colorText1.height = 30;
            this.addChild(this.colorText1);
            this.colorMask = new Sprite();
            this.colorMask.graphics.beginFill(16711680, 0);
            this.colorMask.graphics.drawRect(0, 0, 100, 34);
            this.colorMask.graphics.endFill();
            this.colorMask.x = 10;
            this.colorMask.y = 36;
            this.addChild(this.colorMask);
            this.rate1 = new RadioButton(1, _modelLocator.i18n.CONFIG_OLDRATE, "", false);
            this.rate1.x = 115;
            this.rate1.y = 95;
            this.photosetLayer.addChild(this.rate1);
            this.rate2 = new RadioButton(1, "4:3", "", false);
            this.rate2.x = 215;
            this.rate2.y = 95;
            this.photosetLayer.addChild(this.rate2);
            this.rate3 = new RadioButton(1, "16:9", "", false);
            this.rate3.x = 265;
            this.rate3.y = 95;
            this.photosetLayer.addChild(this.rate3);
            this.rate4 = new RadioButton(1, _modelLocator.i18n.CONFIG_ALLSCREEN, "", false);
            this.rate4.x = 315;
            this.rate4.y = 95;
            this.photosetLayer.addChild(this.rate4);
            this.rate1.isSelected = true;
            var _loc_2:Boolean = false;
            this.rate4.isSelected = false;
            var _loc_2:* = _loc_2;
            this.rate3.isSelected = _loc_2;
            this.rate2.isSelected = _loc_2;
            this.photosizeSlider = new CHProgress(230, 5, 1, "photosizeChange");
            this.photosizeSlider.x = 130;
            this.photosizeSlider.y = 130;
            this.photosetLayer.addChild(this.photosizeSlider);
            this.photosizeSlider.addEventListener("photosizeChange", this.onPhotosizeChange);
            this.left = new Sprite();
            this.photosetLayer.addChild(this.left);
            this.left.mouseChildren = false;
            this.left.buttonMode = true;
            _loc_1 = new this.toleftSkin();
            this.toleft = new Sprite();
            this.toleft.addChild(_loc_1);
            this.toleft.x = 110;
            this.toleft.y = 150;
            this.toleft.buttonMode = true;
            this.left.addChild(this.toleft);
            this.turnleft = new TextField();
            this.turnleft.defaultTextFormat = new TextFormat("雅黑", 14, 16777215, true);
            this.turnleft.text = _modelLocator.i18n.CONFIG_TUNRLEFT;
            this.turnleft.height = 40;
            this.turnleft.x = 145;
            this.turnleft.y = 154;
            this.turnleft.width = 80;
            this.left.addChild(this.turnleft);
            this.right = new Sprite();
            this.photosetLayer.addChild(this.right);
            this.right.mouseChildren = false;
            this.right.buttonMode = true;
            _loc_1 = new this.torightSkin();
            this.toright = new Sprite();
            this.toright.addChild(_loc_1);
            this.toright.x = 250;
            this.toright.y = 150;
            this.right.addChild(this.toright);
            this.turnright = new TextField();
            this.turnright.defaultTextFormat = new TextFormat("雅黑", 14, 16777215, true);
            this.turnright.text = _modelLocator.i18n.CONFIG_TUNRRIGHT;
            this.turnright.height = 40;
            this.turnright.x = 285;
            this.turnright.y = 154;
            this.turnright.width = 80;
            this.right.addChild(this.turnright);
            _loc_1 = new this.titleBGSkin();
            this.titlebg3 = new Sprite();
            this.titlebg3.addChild(_loc_1);
            this.titlebg3.y = 36;
            this.titlebg3.x = 110;
            this.photosetLayer.addChild(this.titlebg3);
            this.photorateText = new TextField();
            this.photorateText.defaultTextFormat = new TextFormat("", 13, 13487565, true);
            this.photorateText.text = _modelLocator.i18n.CONFIG_PHOTORATE;
            this.photorateText.height = 20;
            this.photorateText.width = 80;
            this.photorateText.x = 30;
            this.photorateText.y = 93;
            this.photosetLayer.addChild(this.photorateText);
            this.photosizeText = new TextField();
            this.photosizeText.defaultTextFormat = new TextFormat("", 13, 13487565, true);
            this.photosizeText.text = _modelLocator.i18n.CONFIG_PHOTOSIZE;
            this.photosizeText.height = 20;
            this.photosizeText.width = this.photosizeText.textWidth + 5;
            this.photosizeText.x = 30;
            this.photosizeText.y = 123;
            this.photosetLayer.addChild(this.photosizeText);
            this.photorotationText = new TextField();
            this.photorotationText.defaultTextFormat = new TextFormat("", 13, 13487565, true);
            this.photorotationText.text = _modelLocator.i18n.CONFIG_PHOTOROTATION;
            this.photorotationText.height = 20;
            this.photorotationText.width = this.photorotationText.textWidth + 5;
            this.photorotationText.x = 30;
            this.photorotationText.y = 153;
            this.photosetLayer.addChild(this.photorotationText);
            _loc_1 = new this.titleBGSkin();
            this.titlebg2 = new Sprite();
            this.titlebg2.addChild(_loc_1);
            this.titlebg2.y = 36;
            this.titlebg2.x = 202;
            this.playsetLayer.addChild(this.titlebg2);
            this.playsetText = new TextField();
            this.playsetText.defaultTextFormat = new TextFormat("雅黑", 14, 10066329, true);
            this.playsetText.text = _modelLocator.i18n.CONFIG_PLAY_SET;
            this.playsetText.height = 40;
            this.playsetText.x = 217;
            this.playsetText.y = 41;
            this.playsetText.width = this.playsetText.textWidth + 5;
            this.addChild(this.playsetText);
            this.playsetText1 = new TextField();
            this.playsetText1.defaultTextFormat = new TextFormat("雅黑", 14, 16777215, true);
            this.playsetText1.text = _modelLocator.i18n.CONFIG_PLAY_SET;
            this.playsetText1.height = 40;
            this.playsetText1.x = 217;
            this.playsetText1.y = 41;
            this.playsetText1.width = this.playsetText.textWidth + 5;
            this.playsetText1.visible = false;
            this.addChild(this.playsetText1);
            this.photoText = new TextField();
            this.photoText.defaultTextFormat = new TextFormat("雅黑", 14, 10066329, true);
            this.photoText.text = _modelLocator.i18n.CONFIG_PHOTO_SET;
            this.photoText.height = 40;
            this.photoText.x = 125;
            this.photoText.y = 41;
            this.photoText.width = this.photoText.textWidth + 5;
            this.addChild(this.photoText);
            this.photoText1 = new TextField();
            this.photoText1.defaultTextFormat = new TextFormat("雅黑", 14, 16777215, true);
            this.photoText1.text = _modelLocator.i18n.CONFIG_PHOTO_SET;
            this.photoText1.height = 40;
            this.photoText1.x = 125;
            this.photoText1.y = 41;
            this.photoText1.width = this.photoText1.textWidth + 5;
            this.photoText1.visible = false;
            this.addChild(this.photoText1);
            this.checkboxVO1 = new CheckBoxVO();
            this.checkboxVO1.text = _modelLocator.i18n.CONFIG_AUTO_PLAY_NEXT;
            this.checkboxVO1.isSelect = false;
            this.checkbox1 = new CheckBox(this.checkboxVO1);
            this.checkbox1.x = 60;
            this.checkbox1.y = 110;
            this.checkbox1.visible = false;
            this.playsetLayer.addChild(this.checkbox1);
            this.checkboxVO2 = new CheckBoxVO();
            this.checkboxVO2.text = _modelLocator.i18n.CONFIG_REMENBER_BREAK_POINT;
            this.checkboxVO2.isSelect = _modelLocator.isRemenberLastTime;
            this.checkbox2 = new CheckBox(this.checkboxVO2);
            this.checkbox2.x = 60;
            this.checkbox2.y = 120;
            this.playsetLayer.addChild(this.checkbox2);
            this.checkbox2.addEventListener(this.checkbox2.eventStr, this.onBox2Clicked);
            this.photoMask = new Sprite();
            this.photoMask.graphics.beginFill(65280, 0);
            this.photoMask.graphics.drawRect(0, 0, 92, 34);
            this.photoMask.graphics.endFill();
            this.photoMask.x = 110;
            this.photoMask.y = 36;
            this.addChild(this.photoMask);
            this.playsetMask = new Sprite();
            this.playsetMask.graphics.beginFill(255, 0);
            this.playsetMask.graphics.drawRect(0, 0, 92, 34);
            this.playsetMask.graphics.endFill();
            this.playsetMask.x = 202;
            this.playsetMask.y = 36;
            this.addChild(this.playsetMask);
            this.photoMask.x = 110;
            this.playsetMask.x = 202;
            this.colorMask.addEventListener(MouseEvent.MOUSE_OVER, this.oncolorMaskOver);
            this.playsetMask.addEventListener(MouseEvent.MOUSE_OVER, this.onplaysetMaskOver);
            this.photoMask.addEventListener(MouseEvent.MOUSE_OVER, this.onphotoMaskOver);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_CHANGEBTN, this.setpro2);
            this.left.addEventListener(MouseEvent.CLICK, this.onToleftClick);
            this.right.addEventListener(MouseEvent.CLICK, this.onTorightClick);
            this.rec.addEventListener(MouseEvent.MOUSE_OVER, this.onrecOver);
            this.rec.addEventListener(MouseEvent.MOUSE_OUT, this.onrecOut);
            this.rec.addEventListener(MouseEvent.CLICK, this.onrecClick);
            this.clickLayer.addEventListener(MouseEvent.MOUSE_OVER, this.oncloseBtnOver);
            this.clickLayer.addEventListener(MouseEvent.MOUSE_OUT, this.oncloseBtnOut);
            this.clickLayer.addEventListener(MouseEvent.CLICK, this.oncancelBtnClick);
            this.rate1.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onRate1Select);
            this.rate2.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onRate2Select);
            this.rate3.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onRate3Select);
            this.rate4.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onRate4Select);
            return;
        }// end function

        private function onToleftClick(event:MouseEvent) : void
        {
            this._angel = this._angel + 270;
            this._angel = this._angel % 360;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_ROTATE, this._angel));
            return;
        }// end function

        private function onTorightClick(event:MouseEvent) : void
        {
            this._angel = this._angel + 90;
            this._angel = this._angel % 360;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_ROTATE, this._angel));
            return;
        }// end function

        private function onRate1Select(event:RadioButtonEvent = null) : void
        {
            this.rate1.isSelected = true;
            var _loc_2:Boolean = false;
            this.rate4.isSelected = false;
            var _loc_2:* = _loc_2;
            this.rate3.isSelected = _loc_2;
            this.rate2.isSelected = _loc_2;
            _modelLocator.videoSizeMode = 1;
            this._rate = 1;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PROPORTIONS, this._rate));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CHANGEBTN2, this._rate));
            return;
        }// end function

        private function onRate2Select(event:RadioButtonEvent = null) : void
        {
            this.rate2.isSelected = true;
            var _loc_2:Boolean = false;
            this.rate4.isSelected = false;
            var _loc_2:* = _loc_2;
            this.rate3.isSelected = _loc_2;
            this.rate1.isSelected = _loc_2;
            _modelLocator.videoSizeMode = 2;
            this._rate = 2;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PROPORTIONS, this._rate));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CHANGEBTN2, this._rate));
            return;
        }// end function

        private function onRate3Select(event:RadioButtonEvent = null) : void
        {
            this.rate3.isSelected = true;
            var _loc_2:Boolean = false;
            this.rate4.isSelected = false;
            var _loc_2:* = _loc_2;
            this.rate2.isSelected = _loc_2;
            this.rate1.isSelected = _loc_2;
            _modelLocator.videoSizeMode = 3;
            this._rate = 3;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PROPORTIONS, this._rate));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CHANGEBTN2, this._rate));
            return;
        }// end function

        private function onRate4Select(event:RadioButtonEvent = null) : void
        {
            this.rate4.isSelected = true;
            var _loc_2:Boolean = false;
            this.rate3.isSelected = false;
            var _loc_2:* = _loc_2;
            this.rate2.isSelected = _loc_2;
            this.rate1.isSelected = _loc_2;
            _modelLocator.videoSizeMode = 4;
            this._rate = 4;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PROPORTIONS, this._rate));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CHANGEBTN2, this._rate));
            return;
        }// end function

        private function onPhotosizeChange(event:CommonEvent) : void
        {
            this._size = event.data;
            _modelLocator.videoSizeRate = this._size;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_SIZE, this._size));
            return;
        }// end function

        public function setStatus() : void
        {
            this.checkbox1.txt.text = _modelLocator.i18n.CONFIG_AUTO_PLAY_NEXT;
            this.checkbox2.txt.text = _modelLocator.i18n.CONFIG_REMENBER_BREAK_POINT;
            this.rate1.txt = _modelLocator.i18n.CONFIG_OLDRATE;
            this.rate4.txt = _modelLocator.i18n.CONFIG_ALLSCREEN;
            this.playsetText.text = _modelLocator.i18n.CONFIG_PLAY_SET;
            this.colorText.text = _modelLocator.i18n.CONFIG_COLOR;
            this.playsetText1.text = _modelLocator.i18n.CONFIG_PLAY_SET;
            this.colorText1.text = _modelLocator.i18n.CONFIG_COLOR;
            this.recovery.text = _modelLocator.i18n.CONFIG_RECOVERY;
            this.photoText.text = _modelLocator.i18n.CONFIG_PHOTO_SET;
            this.photoText1.text = _modelLocator.i18n.CONFIG_PHOTO_SET;
            this.turnleft.text = _modelLocator.i18n.CONFIG_TUNRLEFT;
            this.turnright.text = _modelLocator.i18n.CONFIG_TUNRRIGHT;
            this.titleText.text = _modelLocator.i18n.CONTROLBAR_NOTICE_CONFIG;
            this.brightNessText.text = _modelLocator.i18n.CONTROLBAR_NOTICE_PICTURE_ADJUST_BRIGHT;
            this.contrastText.text = _modelLocator.i18n.CONTROLBAR_NOTICE_PICTURE_ADJUST_CONTRAST;
            this.brightNessText.width = this.brightNessText.textWidth + 5;
            this.contrastText.width = this.contrastText.textWidth + 5;
            this.playsetText.width = this.playsetText.textWidth + 5;
            this.playsetText1.width = this.playsetText.textWidth + 5;
            this.photoText.width = this.photoText.textWidth + 5;
            this.photoText1.width = this.photoText1.textWidth + 5;
            this.playsetText1.x = this.photoText.x + this.photoText.textWidth + 25;
            this.playsetText.x = this.photoText.x + this.photoText.textWidth + 25;
            this.photorateText.text = _modelLocator.i18n.CONFIG_PHOTORATE;
            this.photosizeText.text = _modelLocator.i18n.CONFIG_PHOTOSIZE;
            this.photorotationText.text = _modelLocator.i18n.CONFIG_PHOTOROTATION;
            this.surebtn = new CommonButton(_modelLocator.i18n.MULTI_SURE_TEXT);
            this.addChild(this.surebtn);
            this.surebtn.x = 20;
            this.surebtn.y = 230;
            this.titlebg3.width = this.photoText1.textWidth + 30;
            this.titlebg2.x = this.titlebg3.x + this.titlebg3.width;
            this.titlebg2.width = this.playsetText1.textWidth + 30;
            this.playsetMask.x = this.titlebg2.x;
            this.photoMask.graphics.clear();
            this.photoMask.graphics.beginFill(65280, 0);
            this.photoMask.graphics.drawRect(0, 0, this.titlebg3.width, 34);
            this.photoMask.graphics.endFill();
            this.playsetMask.graphics.clear();
            this.playsetMask.graphics.beginFill(255, 0);
            this.playsetMask.graphics.drawRect(0, 0, this.titlebg2.width, 34);
            this.playsetMask.graphics.endFill();
            this.cancelbtn = new CommonButton(_modelLocator.i18n.MULTI_CANCEL_TEXT);
            this.addChild(this.cancelbtn);
            this.cancelbtn.y = 230;
            this.cancelbtn.x = this.surebtn.width + this.surebtn.x + 5;
            this.recovery.x = this.cancelbtn.width + this.cancelbtn.x + 5;
            this.recovery.y = 235;
            this.recovery.width = this.recovery.textWidth + 5;
            this.surebtn.addEventListener(MouseEvent.CLICK, this.onokBtnClick);
            this.cancelbtn.addEventListener(MouseEvent.CLICK, this.oncancelBtnClick);
            return;
        }// end function

        private function onBox2Clicked(event:CommonEvent) : void
        {
            this._isRemenberLastTime = this.checkbox2.isSelect;
            return;
        }// end function

        private function setRemenberLastTime() : void
        {
            var _loc_1:* = ShareObjecter.getObject("cntvPlayerOptions", "/");
            if (_loc_1 != null)
            {
                _loc_1["data"]["isRemenberLastTime"] = _modelLocator.isRemenberLastTime;
            }
            else
            {
                _loc_1 = {data:{isRemenberLastTime:_modelLocator.isRemenberLastTime}};
            }
            ShareObjecter.setObject(_loc_1);
            return;
        }// end function

        private function onokBtnClick(event:MouseEvent) : void
        {
            this.setConfig(this._brightness, this._contrast);
            _modelLocator.size = this._size;
            _modelLocator.videoSizeMode = this._rate;
            _modelLocator.isRemenberLastTime = this.checkbox2.isSelect;
            _modelLocator.angle = this._angel % 360;
            this.setRemenberLastTime();
            this.visible = false;
            return;
        }// end function

        public function oncancelBtnClick(event:MouseEvent = null) : void
        {
            this.visible = false;
            return;
        }// end function

        private function setpro2(event:VideoPlayEvent) : void
        {
            switch(event.data)
            {
                case 1:
                {
                    this.onRate1Select();
                    break;
                }
                case 2:
                {
                    this.onRate2Select();
                    break;
                }
                case 3:
                {
                    this.onRate3Select();
                    break;
                }
                case 4:
                {
                    this.onRate4Select();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function setpro(param1:Number) : void
        {
            switch(param1)
            {
                case 1:
                {
                    this.onRate1Select();
                    break;
                }
                case 2:
                {
                    this.onRate2Select();
                    break;
                }
                case 3:
                {
                    this.onRate3Select();
                    break;
                }
                case 4:
                {
                    this.onRate4Select();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onContrastChange(event:CommonEvent) : void
        {
            this._contrast = event.data;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CONTRAST, this._contrast));
            return;
        }// end function

        private function onBrightChange(event:CommonEvent) : void
        {
            this._brightness = event.data;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_BRIGHTNESS, this._brightness * 510 - 255));
            return;
        }// end function

        private function onrecClick(event:MouseEvent = null) : void
        {
            this.brightNessSlider.setdefault(0.5);
            this.contrastSlider.setdefault(0.1);
            _modelLocator.angle = 0;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_ROTATE, _modelLocator.angle));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PROPORTIONS, 1));
            _modelLocator.videoSizeMode = 1;
            this.contrastSlider.resetRate(0.1);
            this.brightNessSlider.resetRate(0.5);
            this.photosizeSlider.resetRate(1);
            this._brightness = 0.5;
            this._contrast = 0.1;
            this._size = 1;
            this.onRate1Select();
            this.checkbox2.isSelect = true;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_BRIGHTNESS, 0));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CONTRAST, 0.1));
            return;
        }// end function

        private function setConfig(param1:Number, param2:Number) : void
        {
            this.brightNessSlider.setdefault(param1);
            this.contrastSlider.setdefault(param2);
            _modelLocator.brightness = param1;
            _modelLocator.contrast = param2;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_BRIGHTNESS, param1 * 510 - 255));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CONTRAST, param2));
            return;
        }// end function

        private function oncolorMaskOver(event:MouseEvent) : void
        {
            this.colorLayer.visible = true;
            this.playsetLayer.visible = false;
            this.photosetLayer.visible = false;
            this.photoText1.visible = false;
            this.playsetText1.visible = false;
            this.colorText1.visible = true;
            return;
        }// end function

        private function onplaysetMaskOver(event:MouseEvent) : void
        {
            this.colorLayer.visible = false;
            this.playsetLayer.visible = true;
            this.photosetLayer.visible = false;
            this.photoText1.visible = false;
            this.playsetText1.visible = true;
            this.colorText1.visible = false;
            return;
        }// end function

        private function onphotoMaskOver(event:MouseEvent) : void
        {
            this.colorLayer.visible = false;
            this.playsetLayer.visible = false;
            this.photosetLayer.visible = true;
            this.photoText1.visible = true;
            this.playsetText1.visible = false;
            this.colorText1.visible = false;
            return;
        }// end function

        private function onrecOver(event:MouseEvent) : void
        {
            var _loc_2:* = this.recovery.defaultTextFormat;
            _loc_2.color = 16711680;
            this.recovery.setTextFormat(_loc_2);
            return;
        }// end function

        private function onrecOut(event:MouseEvent) : void
        {
            var _loc_2:* = this.recovery.defaultTextFormat;
            _loc_2.color = 13487565;
            this.recovery.setTextFormat(_loc_2);
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

    }
}
