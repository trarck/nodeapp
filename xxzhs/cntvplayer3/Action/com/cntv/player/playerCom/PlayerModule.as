package com.cntv.player.playerCom
{
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.memory.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.playerCom.statuBox.view.*;
    import com.cntv.player.playerCom.video.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.cntv.player.playerCom.video.view.audio.*;
    import com.cntv.player.playerCom.video.view.cycle.*;
    import com.cntv.player.playerCom.video.view.http.*;
    import com.cntv.player.playerCom.video.view.live.*;
    import com.cntv.player.playerCom.video.view.vod.*;
    import com.utils.net.request.*;
    import flash.external.*;

    public class PlayerModule extends CommonSprite
    {
        private var videoView:VideoBase;
        private var isReallyStart:Boolean = false;
        private var candoInvoke:Boolean = true;
        public static const NAME:String = "PlayerModule";

        public function PlayerModule()
        {
            if (_modelLocator.paramVO.isCycle)
            {
                this.videoView = new CyclePlayer();
                this.addChild(this.videoView);
            }
            else if (_modelLocator.paramVO.playBackMode == "audio" && _modelLocator.currentAudioInfo != null)
            {
                this.videoView = new AudioPlayer();
                this.addChild(this.videoView);
            }
            else if (_modelLocator.currentVideoInfo.isRtmp)
            {
                new HttpRequest(new AttributeVo(_modelLocator.p2pJsPath), this.checkP2pJs, this.checkP2pJsError);
            }
            else if (_modelLocator.paramVO.playMode == "live")
            {
                this.videoView = new LivePlayer(_modelLocator.paramVO.startTime);
                this.addChild(this.videoView);
            }
            else if (_modelLocator.paramVO.playMode == "back")
            {
                this.videoView = new LiveBackHttpPlayer(_modelLocator.paramVO.startTime);
                this.addChild(this.videoView);
            }
            else if (_modelLocator.isConvivaMode)
            {
                this.videoView = new ConvivaHttpPlayer(_modelLocator.paramVO.startTime);
                this.addChild(this.videoView);
            }
            else if (_modelLocator.isP2pMode)
            {
                this.videoView = new P2pPlayer(_modelLocator.paramVO.startTime);
                this.addChild(this.videoView);
            }
            else
            {
                this.videoView = new HttpPlayer(_modelLocator.paramVO.startTime);
                this.addChild(this.videoView);
            }
            if (_modelLocator.currentAudioInfo && _modelLocator.currentVideoInfo)
            {
                ExternalInterface.addCallback("setPlayBackMode", this.setPlayBackMode);
            }
            return;
        }// end function

        private function setPlayBackMode(param1:String) : void
        {
            _modelLocator.brightness = 0.5;
            _modelLocator.contrast = 0.1;
            if (param1 == _modelLocator.paramVO.playBackMode)
            {
                return;
            }
            if (param1 == "video" && _modelLocator.currentVideoInfo)
            {
                _modelLocator.paramVO.playBackMode = param1;
                this.resetPlayer();
            }
            else if (param1 == "audio" && _modelLocator.currentAudioInfo)
            {
                _modelLocator.paramVO.playBackMode = param1;
                this.resetPlayer();
            }
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_HIDE_REPLAY));
            return;
        }// end function

        private function checkP2pJs(param1:Object) : void
        {
            _modelLocator.currentVideoInfo = HttpVideoInfoVO.cloneFromRtmp(_modelLocator.currentVideoInfo);
            this.videoView = new HttpPlayer(_modelLocator.paramVO.startTime);
            this.addChild(this.videoView);
            this.realPlay();
            return;
        }// end function

        private function checkP2pJsError(param1:String) : void
        {
            this.videoView = new VodPlayer(_modelLocator.paramVO.startTime);
            this.addChild(this.videoView);
            this.realPlay();
            return;
        }// end function

        override protected function init() : void
        {
            super.init();
            if (this.videoView != null)
            {
                this.realPlay();
            }
            return;
        }// end function

        private function realPlay() : void
        {
            if (!this.isReallyStart)
            {
                if (_modelLocator.currentVideoInfo.is_invalid_copyright)
                {
                    this.addChild(new AreaProtectNoticePanel());
                }
                else
                {
                    _modelLocator.isReady = true;
                    this.isReallyStart = true;
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_LOADING, null));
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_REAL_START));
                    this.videoView.play();
                    PlayerFacade.getInstance(NAME).startUp(this);
                }
            }
            return;
        }// end function

        public function setBrightness(param1:int) : void
        {
            if (this.candoInvoke)
            {
                this.videoView.setBrightness(param1);
            }
            return;
        }// end function

        public function setContrast(param1:Number) : void
        {
            if (this.candoInvoke)
            {
                this.videoView.setContrast(param1);
            }
            return;
        }// end function

        public function play() : void
        {
            if (this.candoInvoke)
            {
                this.videoView.play();
            }
            return;
        }// end function

        public function pause() : void
        {
            if (this.candoInvoke)
            {
                this.videoView.pause();
            }
            return;
        }// end function

        public function seek(param1:Number) : void
        {
            if (this.candoInvoke)
            {
                this.videoView.seek(param1);
            }
            return;
        }// end function

        public function setVolume(param1:Number) : void
        {
            if (this.candoInvoke)
            {
                this.videoView.setVolume(param1);
            }
            return;
        }// end function

        public function muteOn() : void
        {
            if (this.candoInvoke)
            {
                this.videoView.muteOn();
            }
            return;
        }// end function

        public function muteOff() : void
        {
            if (this.candoInvoke)
            {
                this.videoView.muteOff();
            }
            return;
        }// end function

        public function setWideScreen() : void
        {
            if (this.candoInvoke)
            {
                this.videoView.screenWide();
            }
            return;
        }// end function

        public function setNormalScreen() : void
        {
            if (this.candoInvoke)
            {
                this.videoView.screenNormal();
            }
            return;
        }// end function

        override protected function release() : void
        {
            this.videoView.clear();
            this.removeChild(this.videoView);
            this.videoView = null;
            this.candoInvoke = false;
            super.release();
            return;
        }// end function

        public function resetPlayer() : void
        {
            if (this.videoView != null)
            {
                this.videoView.clear();
                this.removeChild(this.videoView);
                this.videoView = null;
                MemClean.run();
            }
            if (_modelLocator.paramVO.isCycle)
            {
                this.videoView = new CyclePlayer();
                _modelLocator.cycleIndex = 0;
            }
            else
            {
                if (_modelLocator.paramVO.playBackMode == "audio" && _modelLocator.currentAudioInfo != null)
                {
                    this.videoView = new AudioPlayer();
                }
                else if (_modelLocator.currentVideoInfo.isRtmp)
                {
                    this.videoView = new VodPlayer();
                }
                if (_modelLocator.paramVO.playMode == "live")
                {
                    this.videoView = new LivePlayer();
                }
                else
                {
                    this.videoView = new HttpPlayer();
                }
            }
            this.addChild(this.videoView);
            this.isReallyStart = false;
            this.realPlay();
            return;
        }// end function

    }
}
