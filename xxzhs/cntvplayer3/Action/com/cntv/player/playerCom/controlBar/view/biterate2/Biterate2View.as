package com.cntv.player.playerCom.controlBar.view.biterate2
{
    import com.cntv.common.events.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.common.view.ui.radioButton.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.cntv.player.playerCom.video.events.*;
    import flash.events.*;
    import flash.text.*;

    public class Biterate2View extends CommonSprite
    {
        public var H:Number = 0;
        private var nowSelectButton:RadioButton;
        private var buttonGroup:Array;
        private var labels:Array;
        private var bg:CommonMask;
        private var closeButton:CloseButton;
        private var title:TextField;
        private var W:Number = 120;
        public static const TOP_GAP:Number = 5;
        public static const LEFT_GAP:Number = 10;

        public function Biterate2View()
        {
            var _loc_3:RadioButton = null;
            this.buttonGroup = [];
            this.labels = ["标清", "高清", "流畅", "超清", "绝清"];
            this.title = TextGenerator.createTxt(16777215, 13, _modelLocator.i18n.CONTROLBAR_QUALITY_ADJUSTMENT, false, 0, true);
            this.addChild(this.title);
            this.title.x = 2;
            this.title.y = 2;
            if (this.title.textWidth > this.W)
            {
                this.W = this.title.textWidth + 23;
            }
            this.labels[0] = _modelLocator.i18n.CONTROLBAR_STANDARDDEFINITION;
            this.labels[1] = _modelLocator.i18n.CONTROLBAR_HIGHDEFINITION;
            this.closeButton = new CloseButton();
            this.closeButton.y = 6;
            this.addChild(this.closeButton);
            this.closeButton.addEventListener(MouseEvent.CLICK, this.closeHandler);
            var _loc_1:int = 0;
            if (_modelLocator.currentVideoInfo.chapters.length != 0)
            {
                _loc_1++;
            }
            if (_modelLocator.currentVideoInfo.chapters2.length != 0)
            {
                _loc_1++;
            }
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = new RadioButton(_loc_2, this.labels[_loc_2], "");
                _loc_3.x = LEFT_GAP;
                _loc_3.y = (RadioButton.BUTTON_H + TOP_GAP) * (_loc_2 + 1) + TOP_GAP;
                _loc_3.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.radioSelected);
                this.buttonGroup.push(_loc_3);
                this.addChild(_loc_3);
                if (_loc_3.textWidth > this.W)
                {
                    this.W = _loc_3.textWidth + 23;
                }
                this.H = this.H + 25;
                _loc_2++;
            }
            this.closeButton.x = this.W - 15;
            this.H = this.H + 25;
            this.bg = new CommonMask(this.W, this.H, 2236962, 0.8);
            this.addChildAt(this.bg, 0);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_CHANGE_RATE_BY_DATA, this.changeRateByData);
            this.nowSelectButton = this.buttonGroup[_modelLocator.currentHttpBiteRateMode];
            this.nowSelectButton.isSelected = true;
            return;
        }// end function

        private function changeRateByData(event:ControlBarEvent) : void
        {
            this.nowSelectButton = this.buttonGroup[_modelLocator.currentHttpBiteRateMode];
            this.nowSelectButton.isSelected = true;
            return;
        }// end function

        private function radioSelected(event:RadioButtonEvent) : void
        {
            this.nowSelectButton.isSelected = false;
            this.nowSelectButton = RadioButton(event.currentTarget);
            if (_modelLocator.currentHttpBiteRateMode != this.nowSelectButton.index && !_modelLocator.isInSwitch)
            {
                _modelLocator.currentHttpBiteRateMode = this.nowSelectButton.index;
                ShareObjecter.setOptions(_modelLocator.localDataObjectName, _modelLocator.localDataPath, "currentHttpBiteRateMode2", _modelLocator.currentHttpBiteRateMode.toString());
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_HTTP_BITERATE_MODE_CHANGE));
            }
            this.closeHandler(null);
            return;
        }// end function

        private function closeHandler(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ControlBarModule.EVENT_CLOSE_WINDOW));
            return;
        }// end function

        override public function get height() : Number
        {
            return this.bg.height;
        }// end function

        override public function get width() : Number
        {
            return this.bg.width;
        }// end function

        override public function set width(param1:Number) : void
        {
            super.width = param1;
            return;
        }// end function

    }
}
