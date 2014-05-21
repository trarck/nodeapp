package com.cntv.player.floatLayer.quality
{
    import com.cntv.common.events.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.common.view.ui.radioButton.*;
    import com.cntv.player.floatLayer.event.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class CQualityPanel extends CommonSprite
    {
        private var panelBg:Sprite;
        private var panelTitle:Sprite;
        private var titleText:TextField;
        private var closeBtn:Sprite;
        private var closeBtnBg:Sprite;
        private var closeBG:Sprite;
        private var closeBTN:Sprite;
        private var closeLayer:Sprite;
        private var clickLayer:Sprite;
        private var sureText:TextField;
        private var closeBGSkin:Class;
        private var closeBTNSkin:Class;
        private var hotBackSkin:Class;
        private var titleBgSkin:Class;
        private var button_arr:Array;
        private var currentIndex:Number = 0;
        private var surebtn:CommonButton;

        public function CQualityPanel()
        {
            this.closeBGSkin = CQualityPanel_closeBGSkin;
            this.closeBTNSkin = CQualityPanel_closeBTNSkin;
            this.hotBackSkin = CQualityPanel_hotBackSkin;
            this.titleBgSkin = CQualityPanel_titleBgSkin;
            this.button_arr = [];
            _dispatcher.addEventListener(FLayerEvent.EVENT_SHOW_QUALITY_RADIAOS, this.onShowRadios);
            return;
        }// end function

        private function onShowRadios(event:CommonEvent) : void
        {
            if (_modelLocator.isConvivaMode && !_modelLocator.currentVideoInfo.isRtmp)
            {
                this.setConvivaRadios();
                this.reOrderBtns(true);
            }
            else if (_modelLocator.currentVddBitRates.length > 0)
            {
                this.setRadios(_modelLocator.currentVddBitRates);
                this.reOrderBtns();
            }
            return;
        }// end function

        private function setConvivaRadios() : void
        {
            var _loc_1:RadioButton = null;
            if (_modelLocator.currentVideoInfo.chapters.length != 0)
            {
                _loc_1 = new RadioButton(0, _modelLocator.i18n.CONTROLBAR_LOWERDEFINITION, "LD");
                this.addChild(_loc_1);
                this.button_arr.push(_loc_1);
                _loc_1.removeClickListener();
            }
            if (_modelLocator.currentVideoInfo.chapters2.length != 0)
            {
                _loc_1 = new RadioButton(1, _modelLocator.i18n.CONTROLBAR_STANDARDDEFINITION, "STD");
                this.addChild(_loc_1);
                this.button_arr.push(_loc_1);
                _loc_1.removeClickListener();
            }
            if (_modelLocator.currentVideoInfo.chapters3.length != 0)
            {
                _loc_1 = new RadioButton(1, _modelLocator.i18n.CONTROLBAR_HIGHDEFINITION, "HD");
                this.addChild(_loc_1);
                this.button_arr.push(_loc_1);
                _loc_1.removeClickListener();
            }
            if (_modelLocator.currentVideoInfo.chapters4.length != 0)
            {
                _loc_1 = new RadioButton(1, _modelLocator.i18n.CONTROLBAR_SUPERDIFINITION, "SD");
                this.addChild(_loc_1);
                this.button_arr.push(_loc_1);
                _loc_1.removeClickListener();
            }
            if (_modelLocator.currentVideoInfo.chapters5.length != 0)
            {
                _loc_1 = new RadioButton(1, _modelLocator.i18n.CONTROLBAR_SUPERHIGHDIFINITION, "SHD");
                this.addChild(_loc_1);
                this.button_arr.push(_loc_1);
                _loc_1.removeClickListener();
            }
            _dispatcher.addEventListener(RadioButtonEvent.EVENT_STREAM_CHANGED, this.onBitRateChange);
            return;
        }// end function

        private function reOrderBtns(param1:Boolean = false) : void
        {
            var _loc_5:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_2:Number = 0;
            var _loc_3:Number = 0;
            var _loc_4:Number = 0;
            var _loc_6:Boolean = false;
            var _loc_7:Array = [];
            if (!param1 && this.button_arr.length >= 3)
            {
                _loc_7.push(this.button_arr[2]);
                _loc_7.push(this.button_arr[0]);
                _loc_7.push(this.button_arr[1]);
                if (this.button_arr.length > 3)
                {
                    _loc_7.push(this.button_arr[4]);
                }
            }
            else
            {
                _loc_7 = this.button_arr;
            }
            var _loc_8:Number = 0;
            while (_loc_8 < _loc_7.length)
            {
                
                _loc_2 = _loc_2 + _loc_7[_loc_8].textWidth;
                if (_loc_2 > 350)
                {
                    _loc_5 = _loc_8;
                    _loc_6 = true;
                    break;
                }
                _loc_8 = _loc_8 + 1;
            }
            if (_loc_6)
            {
                _loc_9 = 0;
                while (_loc_9 < _loc_5)
                {
                    
                    _loc_3 = _loc_3 + _loc_7[_loc_9].textWidth;
                    _loc_9 = _loc_9 + 1;
                }
                _loc_7[0].x = (440 - _loc_3) / 2;
                _loc_7[0].y = 70;
                _loc_10 = 1;
                while (_loc_10 < _loc_5)
                {
                    
                    _loc_7[_loc_10].x = _loc_7[(_loc_10 - 1)].x + _loc_7[(_loc_10 - 1)].textWidth;
                    _loc_7[_loc_10].y = 70;
                    _loc_10 = _loc_10 + 1;
                }
                _loc_11 = _loc_5;
                while (_loc_11 < _loc_7.length)
                {
                    
                    _loc_4 = _loc_4 + _loc_7[_loc_9].textWidth;
                    _loc_11 = _loc_11 + 1;
                }
                _loc_7[_loc_5].x = (440 - _loc_4) / 2;
                _loc_7[_loc_5].y = 110;
                _loc_12 = _loc_5 + 1;
                while (_loc_12 < _loc_7.length)
                {
                    
                    _loc_7[_loc_12].x = _loc_7[(_loc_12 - 1)].x + _loc_7[(_loc_12 - 1)].textWidth;
                    _loc_7[_loc_12].y = 110;
                    _loc_12 = _loc_12 + 1;
                }
            }
            else
            {
                _loc_7[0].x = (440 - _loc_2) / 2;
                _loc_7[0].y = 90;
                _loc_13 = 1;
                while (_loc_13 < _loc_7.length)
                {
                    
                    _loc_7[_loc_13].x = _loc_7[(_loc_13 - 1)].x + _loc_7[(_loc_13 - 1)].textWidth;
                    _loc_7[_loc_13].y = 90;
                    _loc_13 = _loc_13 + 1;
                }
            }
            return;
        }// end function

        private function onBitRateChange(event:RadioButtonEvent) : void
        {
            this.button_arr[this.currentIndex].isSelected = false;
            this.button_arr[_modelLocator.currentHttpBiteRateMode].isSelected = true;
            this.currentIndex = _modelLocator.currentHttpBiteRateMode;
            return;
        }// end function

        public function setRadios(param1:Array) : void
        {
            var _loc_2:RadioButton = null;
            var _loc_3:Number = 0;
            if (_modelLocator.currentVideoInfo.isRtmp)
            {
                _loc_3 = 1;
            }
            var _loc_4:Number = 0;
            while (_loc_4 < param1.length)
            {
                
                switch(param1[_loc_4])
                {
                    case "LD":
                    {
                        _loc_2 = new RadioButton(_loc_4, _modelLocator.i18n.CONTROLBAR_LOWERDEFINITION, param1[_loc_4]);
                        this.addChild(_loc_2);
                        this.button_arr.push(_loc_2);
                        break;
                    }
                    case "STD":
                    {
                        _loc_2 = new RadioButton(_loc_4, _modelLocator.i18n.CONTROLBAR_STANDARDDEFINITION, param1[_loc_4]);
                        this.addChild(_loc_2);
                        this.button_arr.push(_loc_2);
                        break;
                    }
                    case "HD":
                    {
                        _loc_2 = new RadioButton(_loc_4, _modelLocator.i18n.CONTROLBAR_HIGHDEFINITION, param1[_loc_4]);
                        this.addChild(_loc_2);
                        this.button_arr.push(_loc_2);
                        break;
                    }
                    case "SD":
                    {
                        _loc_2 = new RadioButton(_loc_4, _modelLocator.i18n.CONTROLBAR_SUPERDIFINITION, param1[_loc_4]);
                        this.addChild(_loc_2);
                        this.button_arr.push(_loc_2);
                        break;
                    }
                    case "SHD":
                    {
                        _loc_2 = new RadioButton(_loc_4, _modelLocator.i18n.CONTROLBAR_SUPERHIGHDIFINITION, param1[_loc_4]);
                        this.addChild(_loc_2);
                        this.button_arr.push(_loc_2);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this.button_arr[_loc_4].addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onradioBtnSelected);
                _loc_4 = _loc_4 + 1;
            }
            if (_modelLocator.currentVideoInfo.isRtmp)
            {
                _loc_2 = new RadioButton(_loc_4, "自适应", "AUTO");
                _loc_2.x = (440 - (param1.length + _loc_3) * 68) / 2 + 68 * _loc_4;
                _loc_2.y = 90;
                this.addChild(_loc_2);
                this.button_arr.push(_loc_2);
                this.button_arr[_loc_4].addEventListener(RadioButtonEvent.EVENT_SELECTED, this.onradioBtnSelected);
            }
            return;
        }// end function

        public function setCurrentStatus() : void
        {
            if (_modelLocator.currentVideoInfo.isRtmp)
            {
                _modelLocator.currentVideoInfo.vddStreamRate = this.button_arr[_modelLocator.currentRtmpBiteRateMode].mode;
            }
            else
            {
                _modelLocator.currentVideoInfo.vddStreamRate = this.button_arr[_modelLocator.currentHttpBiteRateMode].mode;
            }
            this.titleText.text = _modelLocator.i18n.CONTROLBAR_QUALITY_ADJUSTMENT;
            var _loc_1:Number = 0;
            while (_loc_1 < this.button_arr.length)
            {
                
                if (_modelLocator.currentVideoInfo.vddStreamRate == this.button_arr[_loc_1].mode)
                {
                    this.button_arr[_loc_1].setStatus(true);
                }
                else
                {
                    this.button_arr[_loc_1].setStatus(false);
                }
                _loc_1 = _loc_1 + 1;
            }
            this.surebtn = new CommonButton(_modelLocator.i18n.MULTI_SURE_TEXT);
            this.addChild(this.surebtn);
            this.surebtn.x = (440 - this.surebtn.width) / 2;
            this.surebtn.y = 130;
            this.surebtn.addEventListener(MouseEvent.CLICK, this.onOkClick);
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
            this.panelBg.width = 440;
            this.addChild(this.panelBg);
            _loc_1 = new this.titleBgSkin();
            this.panelTitle = new Sprite();
            this.panelTitle.addChild(_loc_1);
            this.panelTitle.x = 0;
            this.panelTitle.y = 0;
            this.panelTitle.width = 440;
            this.addChild(this.panelTitle);
            this.titleText = new TextField();
            this.titleText.defaultTextFormat = new TextFormat("雅黑", 14, 14540253, true);
            this.titleText.height = 30;
            this.titleText.x = 10;
            this.titleText.y = 5;
            this.titleText.width = 300;
            this.titleText.text = _modelLocator.i18n.CONTROLBAR_QUALITY_ADJUSTMENT;
            this.addChild(this.titleText);
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
            this.clickLayer.addEventListener(MouseEvent.MOUSE_OVER, this.oncloseBtnOver);
            this.clickLayer.addEventListener(MouseEvent.MOUSE_OUT, this.oncloseBtnOut);
            this.clickLayer.addEventListener(MouseEvent.CLICK, this.oncloseBtnClick);
            return;
        }// end function

        private function onradioBtnSelected(event:RadioButtonEvent) : void
        {
            if (_modelLocator.isInSwitch)
            {
                this.button_arr[event.data].isSelected = false;
                return;
            }
            this.clearAll();
            this.currentIndex = this.selectedIndex();
            this.button_arr[event.data].isSelected = true;
            return;
        }// end function

        private function selectedIndex() : Number
        {
            var _loc_1:Number = 0;
            while (_loc_1 < this.button_arr.length)
            {
                
                if (this.button_arr[_loc_1].isSelected)
                {
                    return _loc_1;
                }
                _loc_1 = _loc_1 + 1;
            }
            return 0;
        }// end function

        private function clearAll() : void
        {
            var _loc_1:Number = 0;
            while (_loc_1 < this.button_arr.length)
            {
                
                this.button_arr[_loc_1].isSelected = false;
                _loc_1 = _loc_1 + 1;
            }
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

        private function onOkClick(event:MouseEvent) : void
        {
            var _loc_2:* = _modelLocator.currentHttpBiteRateMode;
            if (_modelLocator.currentVideoInfo.isRtmp)
            {
                _loc_2 = _modelLocator.currentRtmpBiteRateMode;
            }
            if (_loc_2 != this.selectedIndex())
            {
                if (_modelLocator.currentVideoInfo.isRtmp)
                {
                    _modelLocator.currentRtmpBiteRateMode = this.selectedIndex();
                    _modelLocator.currentVideoInfo.vddStreamRate = this.button_arr[_modelLocator.currentRtmpBiteRateMode].mode;
                    ShareObjecter.setOptions(_modelLocator.localDataObjectName, _modelLocator.localDataPath, "currentRtmpBiteRateMode2", _modelLocator.currentRtmpBiteRateMode.toString());
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_BITERATE_MODE_CHANGE));
                }
                else
                {
                    _modelLocator.currentHttpBiteRateMode = this.selectedIndex();
                    ShareObjecter.setOptions(_modelLocator.localDataObjectName, _modelLocator.localDataPath, "currentHttpBiteRateMode2", _modelLocator.currentHttpBiteRateMode.toString());
                    _modelLocator.currentVideoInfo.vddStreamRate = this.button_arr[_modelLocator.currentHttpBiteRateMode].mode;
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_HTTP_BITERATE_MODE_CHANGE));
                }
            }
            this.visible = false;
            return;
        }// end function

        private function oncloseBtnClick(event:MouseEvent) : void
        {
            this.visible = false;
            this.clearAll();
            this.button_arr[this.currentIndex].isSelected = true;
            return;
        }// end function

    }
}
