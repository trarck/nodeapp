package com.cntv.player.playerCom
{
    import caurina.transitions.*;
    import com.cntv.common.*;
    import com.cntv.common.events.*;
    import com.cntv.common.tools.math.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.cntv.player.widgets.views.playSceneButton.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class BeforePlayerADMoudle extends CommonSprite
    {
        private var adPlayer:SWFLoader;
        private var ad3rdPlayer:DisplayObject;
        private var adCurtainPlayer:DisplayObject;
        private var startPlayButton:PlaySceneButton;
        private var startUpTrigger:Boolean = true;
        private var bgCover:CommonMask;
        private var lc:LocalConnection;
        private var isReallyStart:Boolean = false;
        private var imageFrame:Sprite;
        private var isADready:Boolean = false;
        private var isADPlaying:Boolean = false;
        private var isNoticePreLoad:Boolean = false;
        private var is3rdStarted:Boolean = false;
        private var ad3rdTimer:Number;
        public static const ECM_AD_EVENT_PLAYER_OVER:String = "show_end";
        public static const ECM_AD_EVENT_PLAYER_NO_AD:String = "ad_none";
        public static const ECM_AD_EVENT_PLAYER_ERROR:String = "load_failed";
        public static const ECM_AD_EVENT_PLAYER_START:String = "show_start";
        public static const CURTAIN_AD_EVENT_PLAYER_START:String = "curtain_start";
        public static const CURTAIN_AD_EVENT_PLAYER_OVER:String = "curtain_over";
        public static var isPlayingAd:Boolean = false;

        public function BeforePlayerADMoudle()
        {
            if (ExternalInterface.available && _modelLocator.ISWEBSITE)
            {
                ExternalInterface.addCallback("playAfterAction", this.playAfterAction);
            }
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_CYCLE_PLAY_OVER, this.removeStartButton);
            return;
        }// end function

        override protected function init() : void
        {
            super.init();
            this.bgCover = new CommonMask(stage.stageWidth, stage.stageHeight, 0, 1, CommonMask.TYPE_S);
            stage.addChild(this.bgCover);
            if (_modelLocator.paramVO.isAutoPlay)
            {
                this.startCurtainAd();
            }
            else
            {
                this.addStartPlayButton();
                _modelLocator.paramVO.isAutoPlay = true;
            }
            return;
        }// end function

        private function addStartPlayButton() : void
        {
            this.imageFrame = new Sprite();
            stage.addChild(this.imageFrame);
            new ImageLoader(new URLRequest(_modelLocator.paramVO.preImage), this.getPreImage, this.getPreImageError);
            this.startPlayButton = new PlaySceneButton();
            this.startPlayButton.x = (stage.stageWidth - this.startPlayButton.width) / 2;
            this.startPlayButton.y = (stage.stageHeight - this.startPlayButton.height) / 2;
            this.startPlayButton.addEventListener(MouseEvent.CLICK, this.startUp);
            stage.addChild(this.startPlayButton);
            return;
        }// end function

        private function getPreImage(param1:DisplayObject) : void
        {
            var _loc_2:* = param1;
            var _loc_3:* = PositionGenerator.createSize(_loc_2, stage);
            _loc_2.width = _loc_3.x;
            _loc_2.height = _loc_3.y;
            var _loc_4:* = PositionGenerator.createPosition(_loc_2, stage);
            _loc_2.x = _loc_4.x;
            _loc_2.y = _loc_4.y;
            this.imageFrame.addChild(_loc_2);
            return;
        }// end function

        private function getPreImageError(param1:String) : void
        {
            return;
        }// end function

        private function playAfterAction() : void
        {
            if (this.startUpTrigger)
            {
                this.startUp(null);
            }
            return;
        }// end function

        private function startCurtainAd() : void
        {
            if (_modelLocator.paramVO.isPlayCurtainAd && _modelLocator.paramVO.curtainAdPlayerPath != "" && _modelLocator.paramVO.adCurtain != "")
            {
                new SWFLoader(new URLRequest(_modelLocator.paramVO.curtainAdPlayerPath), this.getCurtainADPlayer, this.getCurtainADPlayerError);
            }
            else
            {
                this.endCurtainAd(1);
            }
            return;
        }// end function

        private function getCurtainADPlayer(param1:DisplayObject) : void
        {
            this.adCurtainPlayer = param1;
            SWFLoader(this.adCurtainPlayer).contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadCurtainComplete);
            SWFLoader(this.adCurtainPlayer).contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadCurtainAdError);
            return;
        }// end function

        private function loadCurtainComplete(event:Event) : void
        {
            stage.addChild(this.adCurtainPlayer);
            SWFLoader(this.adCurtainPlayer).content.dispatchEvent(new ADEvent(CURTAIN_AD_EVENT_PLAYER_START, _modelLocator.paramVO.adCurtain));
            SWFLoader(this.adCurtainPlayer).content.addEventListener(CURTAIN_AD_EVENT_PLAYER_OVER, this.adCurtainOver);
            return;
        }// end function

        private function getCurtainADPlayerError(param1:String) : void
        {
            this.endCurtainAd(2);
            return;
        }// end function

        private function loadCurtainAdError(event:IOErrorEvent) : void
        {
            this.endCurtainAd(3);
            return;
        }// end function

        private function adCurtainOver(event:Event) : void
        {
            this.endCurtainAd(4);
            return;
        }// end function

        private function endCurtainAd(param1:int) : void
        {
            if (this.adCurtainPlayer != null && stage.contains(this.adCurtainPlayer))
            {
                SWFLoader(this.adCurtainPlayer).content.removeEventListener(ECM_AD_EVENT_PLAYER_OVER, this.adCurtainOver);
                stage.removeChild(this.adCurtainPlayer);
                this.adCurtainPlayer = null;
            }
            this.start3rdAd();
            return;
        }// end function

        private function start3rdAd() : void
        {
            if (_modelLocator.paramVO.isPlay3rdAd)
            {
                new SWFLoader(new URLRequest(_modelLocator.paramVO.ecmAdPlayerUrl), this.get3rdPlayer, this.get3rdPlayerError);
            }
            else
            {
                this.end3rdAd();
            }
            return;
        }// end function

        private function get3rdPlayer(param1:Loader) : void
        {
            var _loc_2:* = param1.content["setSize"];
            this._loc_2(_modelLocator.screenW, _modelLocator.screenH);
            this.ad3rdPlayer = param1;
            SWFLoader(this.ad3rdPlayer).contentLoaderInfo.addEventListener(Event.COMPLETE, this.load3rdAdComplete);
            SWFLoader(this.ad3rdPlayer).contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.load3rdAdError);
            return;
        }// end function

        private function load3rdAdComplete(event:Event) : void
        {
            stage.addChild(this.ad3rdPlayer);
            SWFLoader(this.ad3rdPlayer).content.addEventListener(ECM_AD_EVENT_PLAYER_OVER, this.ad3rdOver);
            SWFLoader(this.ad3rdPlayer).content.addEventListener(ECM_AD_EVENT_PLAYER_NO_AD, this.ad3rdOver);
            SWFLoader(this.ad3rdPlayer).content.addEventListener(ECM_AD_EVENT_PLAYER_ERROR, this.ad3rdOver);
            SWFLoader(this.ad3rdPlayer).content.addEventListener(ECM_AD_EVENT_PLAYER_START, this.ad3rdStart);
            this.ad3rdTimer = setTimeout(this.check3rd, 6000);
            return;
        }// end function

        private function check3rd() : void
        {
            if (!this.is3rdStarted)
            {
                this.end3rdAd();
            }
            return;
        }// end function

        private function ad3rdStart(event:Event) : void
        {
            this.is3rdStarted = true;
            return;
        }// end function

        private function load3rdAdError(event:IOErrorEvent) : void
        {
            this.end3rdAd();
            return;
        }// end function

        private function ad3rdOver(event:Event) : void
        {
            this.end3rdAd();
            return;
        }// end function

        private function get3rdPlayerError(param1:String) : void
        {
            this.end3rdAd();
            return;
        }// end function

        private function end3rdAd() : void
        {
            clearTimeout(this.ad3rdTimer);
            if (this.ad3rdPlayer != null && stage.contains(this.ad3rdPlayer))
            {
                stage.removeChild(this.ad3rdPlayer);
                this.ad3rdPlayer = null;
            }
            this.startBuildinAD();
            return;
        }// end function

        private function startBuildinAD() : void
        {
            if (this.bgCover != null && stage.contains(this.bgCover))
            {
                stage.removeChild(this.bgCover);
                this.bgCover = null;
            }
            this.removeStartButton();
            this.startUpTrigger = false;
            if (_modelLocator.paramVO.adCall != null && _modelLocator.paramVO.adCall != "")
            {
                _dispatcher.addEventListener(ApplicationFacade.NOTI_PLAY_AD, this.playAD);
                _dispatcher.dispatchEvent(new CommonEvent(ApplicationFacade.EVENT_LOAD_AD));
            }
            else
            {
                this.realPlay();
            }
            return;
        }// end function

        private function startUp(event:MouseEvent) : void
        {
            this.startCurtainAd();
            this.removeStartButton();
            return;
        }// end function

        private function removeStartButton(event:VideoPlayEvent = null) : void
        {
            if (this.startPlayButton != null && stage.contains(this.startPlayButton))
            {
                this.startPlayButton.removeEventListener(MouseEvent.CLICK, this.startUp);
                stage.removeChild(this.startPlayButton);
                this.startPlayButton = null;
                stage.removeChild(this.imageFrame);
                this.imageFrame = null;
            }
            return;
        }// end function

        private function playAD(event:CommonEvent) : void
        {
            if (!this.isReallyStart)
            {
                if (_modelLocator.adVosBF != null && _modelLocator.adVosBF.length > 0 && _modelLocator.adVosBF[0]["url"] != "null")
                {
                    new SWFLoader(new URLRequest(_modelLocator.paramVO.adplayerPath), this.getADPlayer, this.getADPlayerError);
                }
                else
                {
                    this.realPlay();
                }
            }
            return;
        }// end function

        private function getADPlayer(param1:DisplayObject) : void
        {
            isPlayingAd = true;
            this.adPlayer = param1 as SWFLoader;
            this.adPlayer.content.addEventListener("startLoadVideo", this.canStartLoadVideo);
            _dispatcher.addEventListener("adPlayerCompelet", this.adPlayerReady);
            _dispatcher.addEventListener("adPlayComp", this.adPlayComp);
            stage.addChild(this.adPlayer);
            setTimeout(this.checkADState, 1000);
            return;
        }// end function

        private function adPlayerReady(event:Event) : void
        {
            if (!this.isADready && !this.isADPlaying)
            {
                this.isADPlaying = true;
                this.isADready = true;
                _dispatcher.dispatchEvent(new ADEvent("ADaddres", _modelLocator.adVosBF));
            }
            return;
        }// end function

        private function checkADState() : void
        {
            if (!this.isADready && !this.isADPlaying)
            {
                this.lc = new LocalConnection();
                this.lc.allowDomain("*");
                this.lc.client = this;
                try
                {
                    this.lc.connect("_cntvPlayer");
                }
                catch (e:Error)
                {
                }
                this.lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.lcAsynError);
                this.lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.lcSecurityError);
                this.lc.addEventListener(StatusEvent.STATUS, this.lcStatu);
                this.lc.send("_adPlayer", "playADArr", _modelLocator.adVosBF);
            }
            return;
        }// end function

        private function getADPlayerError(param1:String) : void
        {
            if (!this.isADready && !this.isADPlaying)
            {
                this.isADPlaying = true;
                this.isADready = true;
                this.realPlay();
            }
            return;
        }// end function

        public function adPlayComp(event:Event = null) : void
        {
            var _loc_2:Number = 0;
            if (stage != null)
            {
                _loc_2 = -stage.stageHeight;
            }
            else if (this.adPlayer != null)
            {
                _loc_2 = -this.adPlayer.height;
            }
            else
            {
                _loc_2 = -3000;
            }
            Tweener.addTween(this.adPlayer, {time:1, y:_loc_2, onComplete:this.afterADClose});
            return;
        }// end function

        public function adPlayOver(param1:String) : void
        {
            var _loc_2:Number = 0;
            if (stage == null)
            {
                _loc_2 = -this.adPlayer.height;
            }
            else
            {
                _loc_2 = -stage.stageHeight;
            }
            Tweener.addTween(this.adPlayer, {time:1, y:_loc_2, onComplete:this.afterADClose});
            return;
        }// end function

        public function afterADClose() : void
        {
            if (stage)
            {
                stage.removeChild(this.adPlayer);
            }
            else if (this.adPlayer.parent != null)
            {
                this.adPlayer.parent.removeChild(this.adPlayer);
            }
            this.adPlayer = null;
            if (this.lc != null)
            {
                this.lc.close();
                this.lc = null;
            }
            System.gc();
            this.realPlay();
            return;
        }// end function

        private function lcAsynError(event:AsyncErrorEvent) : void
        {
            this.adPlayComp();
            return;
        }// end function

        private function lcSecurityError(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

        private function lcStatu(event:StatusEvent) : void
        {
            return;
        }// end function

        private function realPlay() : void
        {
            isPlayingAd = false;
            if (_modelLocator.paramVO.isAutoPlay)
            {
                this.callOver(null);
            }
            else
            {
                this.addStartPlayButton();
            }
            return;
        }// end function

        private function canStartLoadVideo(event:Event) : void
        {
            if (this.adPlayer != null && this.adPlayer.content != null)
            {
                this.adPlayer.content.removeEventListener("startLoadVideo", this.canStartLoadVideo);
            }
            this.isNoticePreLoad = true;
            _dispatcher.dispatchEvent(new CommonEvent(ApplicationFacade.NOTI_AFTER_BEFORE_ADS));
            return;
        }// end function

        private function callOver(event:MouseEvent) : void
        {
            if (!this.isNoticePreLoad)
            {
                _dispatcher.dispatchEvent(new CommonEvent(ApplicationFacade.NOTI_AFTER_BEFORE_ADS));
            }
            else
            {
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_PREDOWNLOAD_OVER));
            }
            this.removeStartButton();
            return;
        }// end function

        override protected function release() : void
        {
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_CYCLE_PLAY_OVER, this.removeStartButton);
            super.release();
            return;
        }// end function

    }
}
