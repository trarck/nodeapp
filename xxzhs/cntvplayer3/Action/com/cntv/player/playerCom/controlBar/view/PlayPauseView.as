package com.cntv.player.playerCom.controlBar.view
{
    import com.cntv.common.events.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.pausebutton.*;
    import com.cntv.player.playerCom.controlBar.view.playbutton.*;
    import flash.events.*;

    public class PlayPauseView extends CommonSprite
    {
        private var playButton:PlayButton;
        private var pauseButton:PauseButton;
        private var _isPlaying:Boolean;

        public function PlayPauseView()
        {
            this.playButton = new PlayButton();
            this.playButton.addEventListener(MouseEvent.CLICK, this.playHandler);
            this.addChild(this.playButton);
            this.pauseButton = new PauseButton();
            this.pauseButton.addEventListener(MouseEvent.CLICK, this.pauseHandler);
            this.addChild(this.pauseButton);
            this.isPlaying = false;
            return;
        }// end function

        public function set isPlaying(param1:Boolean) : void
        {
            this._isPlaying = param1;
            this.playButton.visible = !this._isPlaying;
            this.pauseButton.visible = this._isPlaying;
            return;
        }// end function

        public function get isPlaying() : Boolean
        {
            return this._isPlaying;
        }// end function

        private function playHandler(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.PLAY_CLICK));
            dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
            return;
        }// end function

        private function pauseHandler(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.PAUSE_CLICK));
            dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PAUSE));
            return;
        }// end function

        override public function get width() : Number
        {
            return this.playButton.width;
        }// end function

        override public function get height() : Number
        {
            return this.playButton.height;
        }// end function

    }
}
