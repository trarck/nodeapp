package com.cntv.player.playerCom.video.view.audio
{
    import com.cntv.common.model.vo.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.playerCom.video.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class AudioPlayer extends VideoBase
    {
        private var player:DisplayObject;
        private var isPause:Boolean = false;
        private var isStartPlay:Boolean = false;
        private var isMute:Boolean = false;

        public function AudioPlayer()
        {
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_REPLAY, this.replayHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SINGLE_CLICK, this.playOrPauseHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_DOUBLE_CLICK, this.screenChangeHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_RESET_BUFFER_FLAG, this.resetBufferFlag);
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_AUDIO_MODEL));
            return;
        }// end function

        override protected function initNetConnection() : void
        {
            this.loadPlayer();
            return;
        }// end function

        public function replayHandler(event:VideoPlayEvent) : void
        {
            this.player.dispatchEvent(new CommonEvent("replay"));
            return;
        }// end function

        override protected function playOrPauseHandler(event:VideoPlayEvent) : void
        {
            if (this.isPause)
            {
                removeKeepOnPlayButton();
                if (cornerADPlayer != null)
                {
                    cornerADPlayer.visible = true;
                }
                _modelLocator.isInSwitch = false;
                adPlayOver();
                this.play();
            }
            else
            {
                addKeepOnPlayButton("rtmp");
                if (cornerADPlayer != null)
                {
                    cornerADPlayer.visible = false;
                }
                _modelLocator.isInSwitch = true;
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_MESSAGE, null));
                this.pause();
                showPauseAD();
            }
            return;
        }// end function

        override public function play() : void
        {
            if (!this.isStartPlay)
            {
            }
            else
            {
                this.player.dispatchEvent(new CommonEvent("resume"));
                this.isPause = false;
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
            }
            return;
        }// end function

        override public function pause() : void
        {
            this.player.dispatchEvent(new CommonEvent("pause"));
            this.isPause = true;
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PAUSE));
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            if (this.player != null)
            {
                isCanCheckBuffer = false;
                removeKeepOnPlayButton();
                this.player.dispatchEvent(new CommonEvent("resume"));
                this.player.dispatchEvent(new CommonEvent("seek", param1));
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
                this.isPause = false;
            }
            return;
        }// end function

        override public function setVolume(param1:Number) : void
        {
            this.player.dispatchEvent(new CommonEvent("mute.off"));
            this.player.dispatchEvent(new CommonEvent("volume", param1));
            return;
        }// end function

        override public function muteOn() : void
        {
            this.player.dispatchEvent(new CommonEvent("mute.on"));
            return;
        }// end function

        override public function muteOff() : void
        {
            this.player.dispatchEvent(new CommonEvent("mute.off"));
            return;
        }// end function

        public function screenChangeHandler(event:VideoPlayEvent) : void
        {
            return;
        }// end function

        private function resetBufferFlag(event:VideoPlayEvent) : void
        {
            return;
        }// end function

        private function loadPlayer() : void
        {
            new SWFLoader(new URLRequest(_modelLocator.paramVO.audioPlayerPath + "&haveLoadingIcon=false&havePauseIcon=true&language=" + _modelLocator.paramVO.language), this.getPlayer, this.getPlayerError);
            return;
        }// end function

        private function getPlayer(param1:Loader) : void
        {
            this.player = param1.content;
            this.addChild(this.player);
            this.initPlayerListener();
            this.player.dispatchEvent(new CommonEvent("play", _modelLocator.currentAudioInfo.audioUrl));
            return;
        }// end function

        private function getPlayerError(param1:String) : void
        {
            var _loc_2:* = new StatusVO(_modelLocator.i18n.AUDIO_PLAYER_LOAD_FAIL, StatuBoxEvent.TYPE_CENTER, true);
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            return;
        }// end function

        private function initPlayerListener() : void
        {
            this.player.addEventListener("start.play", this.playerStartPlayHandler);
            this.player.addEventListener("stop.play", this.playerStopPlayHandler);
            this.player.addEventListener("duration", this.playerDurationHandler);
            this.player.addEventListener("played", this.playerPlayedHandler);
            this.player.addEventListener("process", this.playerProcessHandler);
            this.player.addEventListener("volume", this.playerVolumeHandler);
            this.player.addEventListener("error", this.playerErrorHandler);
            return;
        }// end function

        private function playerStartPlayHandler(event:Event) : void
        {
            this.isStartPlay = true;
            this.setVolume(_modelLocator.volumeValue);
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_UNLOCK_CONTROLBAR));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, 0));
            return;
        }// end function

        private function playerStopPlayHandler(event:Event) : void
        {
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PLAY_STOP));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_MESSAGE, null));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
            return;
        }// end function

        private function playerDurationHandler(event:Event) : void
        {
            _modelLocator.movieDuration = event["data"]["totalTime"];
            return;
        }// end function

        private function playerPlayedHandler(event:Event) : void
        {
            var _loc_2:Number = 0;
            if (Number(event["data"]["totalTime"]) != 0)
            {
                _loc_2 = Number(event["data"]["time"]) / Number(event["data"]["totalTime"]);
            }
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_PLAYED, _loc_2));
            return;
        }// end function

        private function playerProcessHandler(event:Event) : void
        {
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_LOADED, event["data"]["loadedPercent"]));
            return;
        }// end function

        private function playerVolumeHandler(event:Event) : void
        {
            return;
        }// end function

        private function playerErrorHandler(event:Event) : void
        {
            return;
        }// end function

        override public function clear() : void
        {
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_REPLAY, this.replayHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_SINGLE_CLICK, this.playOrPauseHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_DOUBLE_CLICK, this.screenChangeHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_RESET_BUFFER_FLAG, this.resetBufferFlag);
            this.player.removeEventListener("start.play", this.playerStartPlayHandler);
            this.player.removeEventListener("stop.play", this.playerStopPlayHandler);
            this.player.removeEventListener("duration", this.playerDurationHandler);
            this.player.removeEventListener("played", this.playerPlayedHandler);
            this.player.removeEventListener("process", this.playerProcessHandler);
            this.player.removeEventListener("volume", this.playerVolumeHandler);
            this.player.removeEventListener("error", this.playerErrorHandler);
            this.player.dispatchEvent(new CommonEvent("pause"));
            this.removeChild(this.player);
            this.player = null;
            return;
        }// end function

    }
}
