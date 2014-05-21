package com.cntv.player.playerCom.controlBar.view.volume
{
    import com.cntv.common.events.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.common.tools.text.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.volume.embed.*;
    import com.cntv.player.playerCom.video.events.*;
    import flash.events.*;

    public class ButtonView extends CommonSprite
    {
        private var volumeButton:VolumeButton;
        private var muteButton:MuteButton;
        private var midButton:MidVolumeButton;

        public function ButtonView()
        {
            _dispatcher.addEventListener(ControlBarEvent.EVENT_ACTIVE_MUTE, this.activeMuteHandler);
            return;
        }// end function

        override protected function init() : void
        {
            super.init();
            this.volumeButton = new VolumeButton();
            this.volumeButton.addEventListener(MouseEvent.CLICK, this.turnOnMute);
            this.addChild(this.volumeButton);
            this.muteButton = new MuteButton();
            this.muteButton.addEventListener(MouseEvent.CLICK, this.turnOffMute);
            this.muteButton.visible = false;
            this.addChild(this.muteButton);
            this.midButton = new MidVolumeButton();
            this.midButton.addEventListener(MouseEvent.CLICK, this.turnOnMute);
            this.midButton.visible = false;
            this.addChild(this.midButton);
            MyToolTip.Create(this, _modelLocator.i18n.CONTROLBAR_NOTICE_VOLUME);
            return;
        }// end function

        public function setButtonView() : void
        {
            if (_modelLocator.volumeValue >= 1)
            {
                this.volumeButton.visible = true;
                this.muteButton.visible = false;
                this.midButton.visible = false;
            }
            else if (_modelLocator.volumeValue <= 0)
            {
                this.volumeButton.visible = false;
                this.muteButton.visible = true;
                this.midButton.visible = false;
            }
            else
            {
                this.volumeButton.visible = false;
                this.muteButton.visible = false;
                this.midButton.visible = true;
            }
            return;
        }// end function

        private function turnOnMute(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.MUTEON_CLICK));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_TURN_ON_MUTE));
            this.volumeButton.visible = false;
            this.muteButton.visible = true;
            this.midButton.visible = false;
            _modelLocator.isMute = true;
            return;
        }// end function

        private function turnOffMute(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.MUTEOFF_CLICK));
            _modelLocator.isMute = false;
            this.setButtonView();
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_TURN_OFF_MUTE));
            return;
        }// end function

        override public function get height() : Number
        {
            return 16;
        }// end function

        override public function set height(param1:Number) : void
        {
            super.height = param1;
            return;
        }// end function

        override public function get width() : Number
        {
            return 24;
        }// end function

        override public function set width(param1:Number) : void
        {
            super.width = param1;
            return;
        }// end function

        private function activeMuteHandler(event:ControlBarEvent) : void
        {
            return;
        }// end function

    }
}
