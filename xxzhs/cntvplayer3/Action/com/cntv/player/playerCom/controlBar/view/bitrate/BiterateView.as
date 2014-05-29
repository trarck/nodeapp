package com.cntv.player.playerCom.controlBar.view.bitrate
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.common.view.ui.radioButton.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.cntv.player.playerCom.video.events.*;
    import flash.events.*;
    import flash.text.*;

    public class BiterateView extends CommonSprite
    {
        public var H:Number = 135;
        private var nowSelectButton:RadioButton;
        private var buttonGroup:Array;
        private var labels:Array;
        private var bg:CommonMask;
        private var closeButton:CloseButton;
        private var title:TextField;
        private var W:Number = 160;
        public static const TOP_GAP:Number = 5;
        public static const LEFT_GAP:Number = 10;

        public function BiterateView()
        {
            this.buttonGroup = [];
            this.labels = ["流畅", "标清", "高清", "超高清", "自适应"];
            _modelLocator = ModelLocator.getInstance();
            this.title = TextGenerator.createTxt(16777215, 13, _modelLocator.i18n.CONTROLBAR_QUALITY_ADJUSTMENT, false, 0, true);
            this.addChild(this.title);
            this.title.x = 2;
            this.title.y = 2;
            if (this.title.textWidth > this.W)
            {
                this.W = this.title.textWidth + 23;
            }
            this.closeButton = new CloseButton();
            this.closeButton.y = 6;
            this.addChild(this.closeButton);
            this.closeButton.addEventListener(MouseEvent.CLICK, this.closeHandler);
            this.labels[0] = _modelLocator.i18n.CONTROLBAR_LOWERDEFINITION;
            this.labels[1] = _modelLocator.i18n.CONTROLBAR_STANDARDDEFINITION;
            this.labels[2] = _modelLocator.i18n.CONTROLBAR_HIGHDEFINITION;
            this.labels[3] = _modelLocator.i18n.CONTROLBAR_SUPERHIGHDIFINITION;
            this.labels[4] = _modelLocator.i18n.CONTROLBAR_AUTOADAPT;
            this.setButtons();
            this.closeButton.x = this.W - 15;
            this.bg = new CommonMask(this.W, this.H, 2236962, 0.8);
            this.addChildAt(this.bg, 0);
            this.nowSelectButton = this.buttonGroup[_modelLocator.currentRtmpBiteRateMode];
            this.nowSelectButton.isSelected = true;
            return;
        }// end function

        public function setButtons() : void
        {
            var _loc_2:RadioButton = null;
            var _loc_3:String = null;
            var _loc_4:StreamVO = null;
            var _loc_1:int = 0;
            while (_loc_1 < (_modelLocator.currentVideoInfo.streams.length + 1))
            {
                
                _loc_3 = "";
                if (_loc_1 <= (_modelLocator.currentVideoInfo.streams.length - 1))
                {
                    _loc_4 = _modelLocator.currentVideoInfo.streams[_loc_1] as StreamVO;
                    if (Number(_loc_4.bitRate) <= 300)
                    {
                        _loc_3 = this.labels[0];
                    }
                    else if (Number(_loc_4.bitRate) <= 500)
                    {
                        _loc_3 = this.labels[1];
                    }
                    else if (Number(_loc_4.bitRate) <= 900)
                    {
                        _loc_3 = this.labels[2];
                    }
                    else if (Number(_loc_4.bitRate) <= 1500)
                    {
                        _loc_3 = this.labels[3];
                    }
                    _loc_2 = new RadioButton(_loc_1, _loc_3, "");
                }
                else
                {
                    _loc_2 = new RadioButton(_loc_1, _modelLocator.i18n.CONTROLBAR_NOTICE_RTMP_RATE_ADAPTIVE);
                }
                _loc_2.x = LEFT_GAP;
                _loc_2.y = (RadioButton.BUTTON_H + TOP_GAP) * (_loc_1 + 1) + TOP_GAP;
                _loc_2.addEventListener(RadioButtonEvent.EVENT_SELECTED, this.radioSelected);
                this.buttonGroup.push(_loc_2);
                this.addChild(_loc_2);
                if (_loc_2.textWidth > this.W)
                {
                    this.W = _loc_2.textWidth + 23;
                }
                _loc_1++;
            }
            this.H = (this.buttonGroup.length - 1) * 35 + 25;
            if (_modelLocator.currentVideoInfo.streams.length == 1)
            {
                this.H = this.H + 10;
            }
            if (_modelLocator.currentRtmpBiteRateMode >= _modelLocator.currentVideoInfo.streams.length)
            {
                _modelLocator.currentRtmpBiteRateMode = _modelLocator.currentVideoInfo.streams.length;
            }
            return;
        }// end function

        private function onCheckOver(event:VideoPlayEvent) : void
        {
            this.nowSelectButton = this.buttonGroup[0];
            this.nowSelectButton.isSelected = true;
            return;
        }// end function

        private function radioSelected(event:RadioButtonEvent) : void
        {
            this.nowSelectButton.isSelected = false;
            this.nowSelectButton = RadioButton(event.currentTarget);
            if (_modelLocator.currentRtmpBiteRateMode != this.nowSelectButton.index && !_modelLocator.isInSwitch)
            {
                _modelLocator.currentRtmpBiteRateMode = this.nowSelectButton.index;
                ShareObjecter.setOptions(_modelLocator.localDataObjectName, _modelLocator.localDataPath, "currentRtmpBiteRateMode2", _modelLocator.currentRtmpBiteRateMode.toString());
                this.closeHandler(null);
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_BITERATE_MODE_CHANGE));
            }
            else
            {
                this.closeHandler(null);
            }
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

    }
}
