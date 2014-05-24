package com.cntv.player.playerCom.video.mediator
{
    import com.cntv.common.model.*;
    import com.cntv.player.playerCom.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.puremvc.view.*;

    public class PlayerMediator extends CommonMediator
    {
        private var _dispatcher:GlobalDispatcher;
        public static const NAME:String = "PlayerMediator";
        public static var instance:PlayerMediator;

        public function PlayerMediator(param1:Object)
        {
            if (instance != null)
            {
                instance.release();
            }
            instance = this;
            super(NAME);
            viewComponent = param1;
            this._dispatcher = GlobalDispatcher.getInstance();
            this.initListener();
            return;
        }// end function

        public function release() : void
        {
            this.removeListener();
            return;
        }// end function

        public function get app() : PlayerModule
        {
            return viewComponent as PlayerModule;
        }// end function

        public function set app(param1:PlayerModule) : void
        {
            viewComponent = param1;
            this.initListener();
            return;
        }// end function

        private function initListener() : void
        {
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_BRIGHTNESS, this.setBrightness);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_CONTRAST, this.setContrast);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_PLAY, this.setVideoPlay);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_PAUSE, this.setVideoPause);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_VIDEO_SEEK, this.setVideoSeek);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VOLUME, this.setVideoVolume);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_TURN_ON_MUTE, this.setMuteOn);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_TURN_OFF_MUTE, this.setMuteOff);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_SCREEN_WIDE, this.setScreenWide);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_SCREEN_NORMAL, this.setScreenNormal);
            this.app.addEventListener(ControlBarEvent.EVENT_VIDEO_PLAY, this.setControlBarPlay);
            this.app.addEventListener(ControlBarEvent.EVENT_VIDEO_PAUSE, this.setControlBarPause);
            return;
        }// end function

        private function removeListener() : void
        {
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_VIDEO_BRIGHTNESS, this.setBrightness);
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_VIDEO_CONTRAST, this.setContrast);
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_VIDEO_PLAY, this.setVideoPlay);
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_VIDEO_PAUSE, this.setVideoPause);
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_VIDEO_SEEK, this.setVideoSeek);
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_VOLUME, this.setVideoVolume);
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_TURN_ON_MUTE, this.setMuteOn);
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_TURN_OFF_MUTE, this.setMuteOff);
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_VIDEO_SCREEN_WIDE, this.setScreenWide);
            this._dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_VIDEO_SCREEN_NORMAL, this.setScreenNormal);
            this.app.removeEventListener(ControlBarEvent.EVENT_VIDEO_PLAY, this.setControlBarPlay);
            this.app.removeEventListener(ControlBarEvent.EVENT_VIDEO_PAUSE, this.setControlBarPause);
            return;
        }// end function

        private function setBrightness(event:VideoPlayEvent) : void
        {
            this.app.setBrightness(int(event.data));
            return;
        }// end function

        private function setContrast(event:VideoPlayEvent) : void
        {
            this.app.setContrast(Number(event.data));
            return;
        }// end function

        private function setVideoPlay(event:VideoPlayEvent) : void
        {
            this.app.play();
            return;
        }// end function

        private function setVideoPause(event:VideoPlayEvent) : void
        {
            this.app.pause();
            return;
        }// end function

        private function setVideoSeek(event:VideoPlayEvent) : void
        {
            this.app.seek(Number(event.data));
            return;
        }// end function

        private function setVideoVolume(event:VideoPlayEvent) : void
        {
            this.app.setVolume(Number(event.data));
            return;
        }// end function

        private function setMuteOn(event:VideoPlayEvent) : void
        {
            this.app.muteOn();
            return;
        }// end function

        private function setMuteOff(event:VideoPlayEvent) : void
        {
            this.app.muteOff();
            return;
        }// end function

        private function setScreenWide(event:VideoPlayEvent) : void
        {
            this.app.setWideScreen();
            return;
        }// end function

        private function setScreenNormal(event:VideoPlayEvent) : void
        {
            this.app.setNormalScreen();
            return;
        }// end function

        private function setControlBarPlay(event:ControlBarEvent) : void
        {
            this._dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
            return;
        }// end function

        private function setControlBarPause(event:ControlBarEvent) : void
        {
            this._dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PAUSE));
            return;
        }// end function

    }
}
