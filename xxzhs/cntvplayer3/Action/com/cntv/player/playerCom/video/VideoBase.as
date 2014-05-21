package com.cntv.player.playerCom.video
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.proxy.*;
    import com.cntv.common.tools.graphics.*;
    import com.cntv.common.tools.math.*;
    import com.cntv.common.tools.memory.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.hotDot.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.playerCom.statuBox.view.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.cntv.player.widgets.views.playSceneButton.*;
    import com.cntv.player.widgets.views.tragetAD.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class VideoBase extends CommonSprite
    {
        protected var BUFFER_TIME:Number = 2;
        protected var HOTMAP_TIMER:Number = 60;
        protected var RTMP_BUFFER_TIME:Number = 0.5;
        private const DOUBLE_CLICK_DISTANCE:int = 250;
        protected var FLOAT_LOGO_WIDTH_RATIO:Number = 0.23;
        protected var FLOAT_LOGO_X_RATIO:Number = 0.01;
        protected var FLOAT_LOGO_Y_RATIO:Number = 0.01;
        private var tempTime:int = 0;
        private var videoMask:CommonMask;
        private var timer:Timer;
        private var pauseADPlayer:DisplayObject;
        protected var cornerADPlayer:DisplayObject;
        private var canadd:Boolean = true;
        private var lc:LocalConnection;
        private var lcCorner:LocalConnection;
        private var lc2:LocalConnection;
        private var lcCorner2:LocalConnection;
        protected var loadVideoTime:int;
        protected var keepOnPlayButton:PlaySceneButton;
        protected var isCanCheckBuffer:Boolean = false;
        protected var isPsFilterActive:Boolean = false;
        private var pauseAdIndex:int = 0;
        protected var nowRateString:String = "";
        protected var haveAStopRequest:Boolean = false;
        protected var lastTimeMark:Number = 0;
        private var hotmapTimer:Timer;
        protected var bufferTimesCount:Number = 0;
        protected var bufferTimeOutMark:Number = 0;
        protected var bufferIntevalIndex:Number = 3.14159;
        protected var bufferTimeOutValue:Number = 20;
        private var convivaMonitor:ConvivaMonitor;
        protected var enableConviva:Boolean = false;
        private var convivaRate:Number = 1;
        private var miniWindowTimer:Timer;
        private var miniWindowTimer2:Timer;
        private var miniHart:Number = 0;
        public var bufferTimeLength:Number = 0;
        private var timeCount:Number = 0;
        private var timeCountTimer:Timer;
        protected var targetADModule:TargetADModule;
        public var canSendBt:Boolean = false;
        public var googlePauseW:Number = 336;
        public var googlePauseH:Number = 290;
        protected var rotationSetter:DynamicRegistration;
        protected var OR_STAGE_WIDTH:Number = 640;
        protected var OR_STAGE_HEIGHT:Number = 510;
        protected var videoContainer:Sprite;
        protected var videoBaseContainer:Sprite;
        private var currentKeyCode:String;
        private var keyTimer:Timer;
        private var fpsTimer:Timer;
        private var fpsArr:Array;
        private var fpsNumber:int = 0;
        private var debugFpsTimer:Timer;
        private var getFpsTime:int = 0;
        private var seekTime:Number = 0;
        private var canCountSeek:Boolean = false;
        private var memTimer:Timer;
        private var memArr:Array;
        private var memNumber:int = 0;
        protected var memoryTimeOuter:uint = 0;
        private var bestRateTimer:Timer;
        private var canDoBestRate:Boolean = true;
        protected var floatLogo:DisplayObject;
        public static const HTTP_VIDEO_SERVER_NAME:String = "http://v.cctv.com";
        public static const CORNER_AD_W:int = 75;
        public static const CORNER_AD_H:int = 75;
        public static const FPS_2ND_TIME:int = 5;
        public static const BEST_RATE_TIME:int = 2;
        public static var isCheckIngP2p:Boolean = false;
        public static const END_TIME_DIFF:Number = 1;
        public static var isMiniWindowLive:Boolean = false;

        public function VideoBase()
        {
            if (ExternalInterface.available && _modelLocator.ISWEBSITE)
            {
                ExternalInterface.addCallback("getTimeInSeconds", this.getTimeInSeconds);
                ExternalInterface.addCallback("setTimeInSeconds", this.setTimeInSeconds);
                ExternalInterface.addCallback("getTotalInSeconds", this.getTotalInSeconds);
                ExternalInterface.addCallback("seekByWeb", this.seekByWeb);
                ExternalInterface.addCallback("openSmallWindowByWeb", this.openSmall);
            }
            this.createConvivaMonitor(HTTP_VIDEO_SERVER_NAME, _modelLocator.currentVideoInfo.title);
            this.initNetConnection();
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_SIZE, this.setSizeRate);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_PROPORTIONS, this.setPropor);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_VIDEO_ROTATE, this.setAngle);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_RATE, this.setRate);
            return;
        }// end function

        protected function setPoint(param1:Point) : void
        {
            return;
        }// end function

        protected function setRate(event:VideoPlayEvent) : void
        {
            return;
        }// end function

        protected function setAngle(event:VideoPlayEvent, param2:Boolean = true) : void
        {
            return;
        }// end function

        protected function setSizeRate(event:VideoPlayEvent) : void
        {
            return;
        }// end function

        protected function setPropor(event:VideoPlayEvent) : void
        {
            _modelLocator.videoSizeMode = Number(event.data);
            return;
        }// end function

        private function getTimeInSeconds() : Number
        {
            return this.getTime();
        }// end function

        private function getTotalInSeconds() : Number
        {
            return this.getTotalTime();
        }// end function

        private function setTimeInSeconds(param1:Number) : void
        {
            this.seekInSeconds(param1);
            return;
        }// end function

        protected function initNetConnection() : void
        {
            return;
        }// end function

        public function play() : void
        {
            return;
        }// end function

        public function playByList() : void
        {
            return;
        }// end function

        public function pause() : void
        {
            return;
        }// end function

        public function resume() : void
        {
            return;
        }// end function

        public function seek(param1:Number) : void
        {
            return;
        }// end function

        public function setVolume(param1:Number) : void
        {
            this.muteOff();
            return;
        }// end function

        public function muteOn() : void
        {
            return;
        }// end function

        public function muteOff() : void
        {
            return;
        }// end function

        public function seekByWeb(param1:Number) : void
        {
            if (this.keepOnPlayButton != null && stage.contains(this.keepOnPlayButton))
            {
                this.removeKeepOnPlayButton();
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SINGLE_CLICK));
            }
            this.seekInSeconds(param1);
            return;
        }// end function

        public function seekInSeconds(param1:Number) : void
        {
            return;
        }// end function

        public function startTimeTimer() : void
        {
            if (this.timeCountTimer == null)
            {
                this.timeCountTimer = new Timer(5000);
                this.timeCountTimer.addEventListener(TimerEvent.TIMER, this.onTimeCount);
                this.timeCountTimer.start();
            }
            return;
        }// end function

        public function stopTimeTimer() : void
        {
            if (this.timeCountTimer != null)
            {
                this.timeCountTimer.stop();
            }
            var _loc_1:* = ShareObjecter.getObject("cntvPlayerOptions", "/");
            if (_loc_1 != null)
            {
                _loc_1["data"]["lastVideoCenterId"] = _modelLocator.paramVO.videoCenterId;
                _loc_1["data"]["lastWatchedTime"] = 0;
                ShareObjecter.setObject(_loc_1);
            }
            return;
        }// end function

        private function onTimeCount(event:TimerEvent = null) : void
        {
            var _loc_2:* = ShareObjecter.getObject("cntvPlayerOptions", "/");
            if (_loc_2 != null)
            {
                _loc_2["data"]["lastVideoCenterId"] = _modelLocator.paramVO.videoCenterId;
                _loc_2["data"]["lastWatchedTime"] = int(_modelLocator.currentTime);
                ShareObjecter.setObject(_loc_2);
            }
            var _loc_6:String = this;
            var _loc_7:* = this.timeCount + 1;
            _loc_6.timeCount = _loc_7;
            if (this.timeCount < 4)
            {
                return;
            }
            this.timeCount = 0;
            var _loc_3:Array = [];
            var _loc_4:* = new ValueOBJ("t", "pt");
            _loc_3.push(_loc_4);
            _loc_4 = new ValueOBJ("v", "20");
            _loc_3.push(_loc_4);
            var _loc_5:* = String(Math.random());
            _loc_4 = new ValueOBJ("radom", _loc_5);
            _loc_3.push(_loc_4);
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_PLAY_LENGTH, _loc_3));
            return;
        }// end function

        public function openSmall() : void
        {
            if (this.keepOnPlayButton == null)
            {
                this.addKeepOnPlayButton("");
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SINGLE_CLICK));
            }
            return;
        }// end function

        public function getTime() : Number
        {
            return 0;
        }// end function

        public function getTotalTime() : Number
        {
            return 0;
        }// end function

        public function setBrightness(param1:int) : void
        {
            this.isPsFilterActive = true;
            return;
        }// end function

        public function setContrast(param1:Number) : void
        {
            this.isPsFilterActive = true;
            return;
        }// end function

        public function screenWide() : void
        {
            return;
        }// end function

        public function screenNormal() : void
        {
            return;
        }// end function

        public function chargeHttp() : void
        {
            return;
        }// end function

        public function clear() : void
        {
            return;
        }// end function

        public function showCornerAD() : void
        {
            if (this.cornerADPlayer == null)
            {
                if (_modelLocator.adVosCorner == null && _modelLocator.paramVO.adCorner != "")
                {
                    _dispatcher.addEventListener(ADEvent.EVENT_GET_CORNER_AD_DATA, this.getCornerADData);
                    new GetADDataProxy(GetADDataProxy.TYPE_CORNER);
                }
                else
                {
                    this.doCornerAD();
                }
            }
            return;
        }// end function

        private function doCornerAD() : void
        {
            if (_modelLocator.adVosCorner != null && _modelLocator.adVosCorner.length > 0 && _modelLocator.adVosCorner[0]["url"] != "null")
            {
                new SWFLoader(new URLRequest(_modelLocator.paramVO.cornerAdplayerPath), this.getCornerAD, this.getCornerADError);
            }
            return;
        }// end function

        private function getCornerADData(event:ADEvent) : void
        {
            _dispatcher.removeEventListener(ADEvent.EVENT_GET_CORNER_AD_DATA, this.getCornerADData);
            this.doCornerAD();
            return;
        }// end function

        private function getCornerAD(param1:DisplayObject) : void
        {
            var v:* = param1;
            this.cornerADPlayer = v;
            this.addChild(this.cornerADPlayer);
            this.adjust();
            if (this.lcCorner == null)
            {
                this.lcCorner = new LocalConnection();
                this.lcCorner.allowDomain("*");
                this.lcCorner.client = this;
                this.lcCorner.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.lcAsynError2);
                this.lcCorner.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.lcSecurityError2);
                this.lcCorner.addEventListener(StatusEvent.STATUS, this.lcStatu2);
                try
                {
                    this.lcCorner.connect("_cntvPlayer_pause");
                    this.lcCorner.send("_cornerIconAdPlayer", "playAD", _modelLocator.adVosCorner);
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        private function getCornerADError(param1:String) : void
        {
            return;
        }// end function

        public function iconAdPlayOver() : void
        {
            if (this.cornerADPlayer != null && this.contains(this.cornerADPlayer))
            {
                this.removeChild(this.cornerADPlayer);
                this.lcCorner.close();
                this.lcCorner = null;
                this.cornerADPlayer = null;
            }
            return;
        }// end function

        protected function listenMiniWindow() : void
        {
            if (this.miniWindowTimer == null)
            {
                this.lc2 = new LocalConnection();
                this.lc2.allowDomain("*");
                this.lc2.client = this;
                try
                {
                    this.lc2.connect("_cntvBasePlayer");
                }
                catch (e:Error)
                {
                }
                this.lc2.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.lcAsynError);
                this.lc2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.lcSecurityError);
                this.lc2.addEventListener(StatusEvent.STATUS, this.lcStatu3);
                this.miniWindowTimer = new Timer(1500);
                this.miniWindowTimer.addEventListener(TimerEvent.TIMER, this.checkMiniwindow);
            }
            this.miniWindowTimer.start();
            return;
        }// end function

        private function checkMiniwindow2(event:TimerEvent) : void
        {
            this.lc2.send("_cntvMiniPlayer", "isLive", "a");
            return;
        }// end function

        private function checkMiniwindow(event:TimerEvent) : void
        {
            var _loc_3:Number = NaN;
            var _loc_2:* = ShareObjecter.getObject(_modelLocator.localDataObjectName, _modelLocator.localDataPath);
            if (_loc_2 != null)
            {
                if (_loc_2["data"]["miniWindow"] != null)
                {
                    _loc_3 = Date.parse(new Date().toString());
                    if (_loc_3 - Number(_loc_2["data"]["miniWindow"].time) < 20000)
                    {
                        this.miniWindowTimer.stop();
                        if (this.miniWindowTimer2 == null)
                        {
                            this.miniWindowTimer2 = new Timer(1500);
                            this.miniWindowTimer2.addEventListener(TimerEvent.TIMER, this.checkMiniwindow2);
                        }
                        this.miniWindowTimer2.start();
                    }
                }
            }
            return;
        }// end function

        public function hideCorner() : void
        {
            return;
        }// end function

        public function showCorner() : void
        {
            return;
        }// end function

        protected function setAkamaiAnality(param1:Object, param2:String, param3:Boolean = true, param4:Number = 0) : void
        {
            return;
        }// end function

        public function showPauseAD() : void
        {
            if (_modelLocator.adVosPause == null && _modelLocator.paramVO.adPause != "")
            {
                _dispatcher.addEventListener(ADEvent.EVENT_GET_PAUSE_AD_DATA, this.getPauseADData);
                new GetADDataProxy(GetADDataProxy.TYPE_PAUSE);
            }
            else
            {
                this.doPauseAD();
            }
            return;
        }// end function

        private function doPauseAD() : void
        {
            if (_modelLocator.adVosPause != null && _modelLocator.adVosPause.length > 0 && _modelLocator.adVosPause[this.pauseAdIndex]["url"] != "null")
            {
                this.canadd = true;
                new SWFLoader(new URLRequest(_modelLocator.paramVO.pauseAdplayerPath), this.getPauseAD, this.getPauseADError);
            }
            else if (_modelLocator.paramVO.showGooglePauseAd)
            {
                new SWFLoader(new URLRequest(_modelLocator.paramVO.googlePausePath), this.getGooglePauseAD, this.getPauseADError);
            }
            return;
        }// end function

        private function getPauseADData(event:ADEvent) : void
        {
            _dispatcher.removeEventListener(ADEvent.EVENT_GET_PAUSE_AD_DATA, this.getPauseADData);
            this.doPauseAD();
            return;
        }// end function

        private function getGooglePauseAD(param1:DisplayObject) : void
        {
            var _loc_2:* = param1 as SWFLoader;
            if (_loc_2)
            {
                this.pauseADPlayer = param1;
                stage.addChild(this.pauseADPlayer);
                this.pauseADPlayer.x = (stage.stageWidth - this.googlePauseW) / 2;
                this.pauseADPlayer.y = (stage.stageHeight - this.googlePauseH) / 2;
            }
            return;
        }// end function

        private function loadAdComplete(event:Event) : void
        {
            var _loc_2:* = this.pauseADPlayer as SWFLoader;
            _loc_2.addEventListener("pauseClosed", this.adPlayOver);
            return;
        }// end function

        private function getPauseAD(param1:DisplayObject) : void
        {
            if (this.canadd)
            {
                this.pauseADPlayer = param1;
                if ((this.pauseAdIndex + 1) <= (_modelLocator.adVosPause.length - 1))
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.pauseAdIndex + 1;
                    _loc_2.pauseAdIndex = _loc_3;
                }
                else
                {
                    this.pauseAdIndex = 0;
                }
                this.addChild(this.pauseADPlayer);
                this.lc = new LocalConnection();
                this.lc.allowDomain("*");
                this.lc.client = this;
                try
                {
                    this.lc.connect("_cntvPlayer_pause");
                }
                catch (e:Error)
                {
                }
                this.lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.lcAsynError);
                this.lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.lcSecurityError);
                this.lc.addEventListener(StatusEvent.STATUS, this.lcStatu);
                this.lc.send("_pauseAdPlayer", "playADVO", _modelLocator.adVosPause[this.pauseAdIndex]);
            }
            return;
        }// end function

        private function getPauseADError(param1:String) : void
        {
            return;
        }// end function

        public function adPlayOver() : void
        {
            this.canadd = false;
            if (this.pauseADPlayer != null && this.contains(this.pauseADPlayer))
            {
                this.removeChild(this.pauseADPlayer);
                try
                {
                    this.lc.close();
                }
                catch (e:Error)
                {
                }
                this.lc = null;
            }
            else if (this.pauseADPlayer != null && stage.contains(this.pauseADPlayer))
            {
                stage.removeChild(this.pauseADPlayer);
            }
            this.pauseADPlayer = null;
            return;
        }// end function

        public function addkeyListener() : void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            this.keyTimer = new Timer(2000);
            this.keyTimer.addEventListener(TimerEvent.TIMER, this.onTimer);
            return;
        }// end function

        private function onKeyDown(event:KeyboardEvent) : void
        {
            switch(String(event.keyCode))
            {
                case "32":
                {
                    this.playOrPause();
                    break;
                }
                case "39":
                {
                    this.backSeek();
                    this.keyTimer.start();
                    break;
                }
                case "37":
                {
                    this.preSeek();
                    this.keyTimer.start();
                    break;
                }
                case "38":
                {
                    this.shoundUp();
                    this.keyTimer.start();
                    break;
                }
                case "40":
                {
                    this.shoundDown();
                    this.keyTimer.start();
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.currentKeyCode = String(event.keyCode);
            _dispatcher.dispatchEvent(new CommonEvent(ControlBarEvent.EVENT_SHOW_CONTROLBAR));
            return;
        }// end function

        private function playOrPause() : void
        {
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SINGLE_CLICK));
            return;
        }// end function

        private function onTimer(event:TimerEvent) : void
        {
            switch(this.currentKeyCode)
            {
                case "39":
                {
                    this.backSeek();
                    break;
                }
                case "37":
                {
                    this.preSeek();
                    break;
                }
                case "38":
                {
                    this.shoundUp();
                    break;
                }
                case "40":
                {
                    this.shoundDown();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onKeyUp(event:KeyboardEvent) : void
        {
            this.keyTimer.stop();
            this.currentKeyCode = "";
            return;
        }// end function

        protected function shoundUp() : void
        {
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_SHOUND_UP));
            return;
        }// end function

        protected function shoundDown() : void
        {
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_SHOUND_DOWN));
            return;
        }// end function

        private function setProgressClick(event:VideoPlayEvent) : void
        {
            if (event.data == "back")
            {
                this.preSeek();
            }
            else if (event.data == "pre")
            {
                this.backSeek();
            }
            return;
        }// end function

        protected function preSeek() : void
        {
            return;
        }// end function

        protected function backSeek() : void
        {
            return;
        }// end function

        public function setMask() : void
        {
            this.videoMask = new CommonMask(stage.stageWidth, stage.stageHeight, 16777215, 0, CommonMask.TYPE_S);
            this.videoMask.buttonMode = true;
            this.addChild(this.videoMask);
            if (!_dispatcher.hasEventListener(HotDot.Event_pauseVideo))
            {
                _dispatcher.addEventListener(HotDot.Event_pauseVideo, this.onPauseVideo);
            }
            if (!_dispatcher.hasEventListener(VideoPlayEvent.EVENT_PLAY_SETPROGRES))
            {
                _dispatcher.addEventListener(VideoPlayEvent.EVENT_PLAY_SETPROGRES, this.setProgressClick);
            }
            this.videoMask.addEventListener(MouseEvent.CLICK, this.doMaskClickHandler);
            if (!_modelLocator.ISWEBSITE)
            {
                _dispatcher.addEventListener(VideoPlayEvent.EVENT_OUTSIDE_FULLSCREEN_CLICK, this.onFullOutClick);
            }
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SMALL_WINDOW_CLICK, this.smallWindowStarted);
            this.graphics.clear();
            this.graphics.beginFill(0);
            this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            this.graphics.endFill();
            return;
        }// end function

        private function smallWindowStarted(event:VideoPlayEvent) : void
        {
            if (!isMiniWindowLive)
            {
                isMiniWindowLive = true;
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PAUSE));
                this.removeKeepOnPlayButton();
                this.addKeepOnPlayButton("");
                this.listenMiniWindow();
            }
            return;
        }// end function

        private function onFullOutClick(event:VideoPlayEvent) : void
        {
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PAUSE));
            NativeToURLTool.openAURL(_modelLocator.paramVO.url);
            this.removeKeepOnPlayButton();
            this.addKeepOnPlayButton("");
            return;
        }// end function

        override protected function adjust() : void
        {
            if (this.videoMask != null && stage != null)
            {
                this.videoMask.width = stage.stageWidth;
                this.videoMask.height = stage.stageHeight;
                this.graphics.clear();
                this.graphics.beginFill(0);
                this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
                this.graphics.endFill();
            }
            if (this.cornerADPlayer != null && stage != null)
            {
                this.cornerADPlayer.x = stage.stageWidth - CORNER_AD_W - _modelLocator.paramVO.cornerAdPX;
                this.cornerADPlayer.y = stage.stageHeight - CORNER_AD_H - _modelLocator.paramVO.cornerAdPY - 30;
            }
            if (this.pauseADPlayer && _modelLocator.paramVO.showGooglePauseAd)
            {
                this.pauseADPlayer.x = (stage.stageWidth - this.googlePauseW) / 2;
                this.pauseADPlayer.y = (stage.stageHeight - this.googlePauseH) / 2;
            }
            return;
        }// end function

        private function onPauseVideo(event:Event) : void
        {
            if (!HotDot.suggested)
            {
                HotDot.suggested = true;
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SINGLE_CLICK));
            }
            return;
        }// end function

        private function doMaskClickHandler(event:MouseEvent) : void
        {
            if (!_modelLocator.ISWEBSITE)
            {
                if (_modelLocator.paramVO.url == "")
                {
                }
                else
                {
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PAUSE));
                    NativeToURLTool.openAURL(_modelLocator.paramVO.url);
                    this.removeKeepOnPlayButton();
                    this.addKeepOnPlayButton("");
                    return;
                }
            }
            var _loc_2:* = getTimer();
            if (_loc_2 - this.tempTime > this.DOUBLE_CLICK_DISTANCE)
            {
                this.timer = new Timer(this.DOUBLE_CLICK_DISTANCE + 5, 1);
                this.timer.addEventListener("timer", this.timerHandler);
                this.timer.start();
            }
            else
            {
                this.removeTimer();
                if (_modelLocator.ISWEBSITE)
                {
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_DOUBLE_CLICK));
                }
                else if (_modelLocator.paramVO.url == "")
                {
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_DOUBLE_CLICK));
                }
            }
            this.tempTime = _loc_2;
            return;
        }// end function

        private function removeTimer() : void
        {
            this.timer.stop();
            this.timer.removeEventListener("timer", this.timerHandler);
            this.timer = null;
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.CENTER_PLAY_CLICK));
            this.removeTimer();
            if (!_modelLocator.ISWEBSITE && _modelLocator.paramVO.url != "")
            {
                NativeToURLTool.openAURL(_modelLocator.paramVO.url);
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PAUSE));
                this.removeKeepOnPlayButton();
                this.addKeepOnPlayButton("");
                return;
            }
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SINGLE_CLICK));
            return;
        }// end function

        public function setVideoStatu(param1:String) : void
        {
            switch(param1)
            {
                case "NetConnection.Connect.Success":
                {
                    this.setStatuToManager("7");
                    break;
                }
                case "NetStream.Play.Start":
                {
                    this.setStatuToManager("3");
                    break;
                }
                case "NetStream.Pause.Notify":
                {
                    this.setStatuToManager("2");
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    this.setStatuToManager("4");
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this.setStatuToManager("10");
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    this.setStatuToManager("6");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function setStatuToManager(param1:String) : void
        {
            _modelLocator.recordManager.setVideoStatus(param1);
            return;
        }// end function

        private function lcAsynError(event:AsyncErrorEvent) : void
        {
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

        private function lcStatu3(event:StatusEvent) : void
        {
            var _loc_2:Object = null;
            if (event.level == "error")
            {
                isMiniWindowLive = false;
                this.miniWindowTimer2.stop();
                _loc_2 = ShareObjecter.getObject(_modelLocator.localDataObjectName, _modelLocator.localDataPath);
                if (_loc_2 != null)
                {
                    if (_loc_2["data"]["miniWindow"] != null)
                    {
                        this.seekByWeb(_loc_2["data"]["miniWindow"].pos);
                    }
                }
                else
                {
                    this.seekByWeb(_modelLocator.currentTime);
                }
            }
            return;
        }// end function

        private function lcAsynError2(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function lcSecurityError2(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

        private function lcStatu2(event:StatusEvent) : void
        {
            return;
        }// end function

        protected function get fps() : Number
        {
            return 0;
        }// end function

        protected function get isPlaying() : Boolean
        {
            return false;
        }// end function

        protected function get isInBuffer() : Boolean
        {
            return false;
        }// end function

        protected function startGetFps() : void
        {
            if (this.getFpsTime < 2)
            {
                if (this.fpsTimer != null)
                {
                    this.stopFpsTimer();
                }
                this.fpsTimer = new Timer(500);
                this.fpsTimer.addEventListener(TimerEvent.TIMER, this.getFps);
                this.fpsTimer.start();
                this.fpsArr = [];
                if (_modelLocator.debugMode)
                {
                    if (this.debugFpsTimer != null)
                    {
                        this.debugFpsTimer.stop();
                        this.debugFpsTimer.removeEventListener(TimerEvent.TIMER, this.debugFps);
                        this.debugFpsTimer = null;
                    }
                    this.debugFpsTimer = new Timer(1000);
                    this.debugFpsTimer.addEventListener(TimerEvent.TIMER, this.debugFps);
                    this.debugFpsTimer.start();
                }
                var _loc_1:String = this;
                var _loc_2:* = this.getFpsTime + 1;
                _loc_1.getFpsTime = _loc_2;
            }
            return;
        }// end function

        private function getFps(event:TimerEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:MathAvgVO = null;
            var _loc_4:ValueOBJ = null;
            if (this.isPlaying && !this.isInBuffer && this.isCanCheckBuffer)
            {
                this.fpsArr[this.fpsNumber] = this.fps;
                var _loc_5:String = this;
                var _loc_6:* = this.fpsNumber + 1;
                _loc_5.fpsNumber = _loc_6;
                if (this.fpsNumber == 60)
                {
                    _loc_2 = new Array();
                    _loc_3 = MathUtil.avgExp(this.fpsArr, 0);
                    _loc_4 = new ValueOBJ("t", "fs");
                    _loc_2.push(_loc_4);
                    _loc_4 = new ValueOBJ("va", _loc_3.va.toString());
                    _loc_2.push(_loc_4);
                    _loc_4 = new ValueOBJ("vi", _loc_3.vi.toString());
                    _loc_2.push(_loc_4);
                    _loc_4 = new ValueOBJ("vx", _loc_3.vx.toString());
                    _loc_2.push(_loc_4);
                    _loc_4 = new ValueOBJ("times", this.getFpsTime.toString());
                    _loc_2.push(_loc_4);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_FRAME_SKIP, _loc_2));
                    this.stopFpsTimer();
                }
            }
            return;
        }// end function

        private function debugFps(event:TimerEvent) : void
        {
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SHOW_FPS, MathUtil.roundToDecimal(this.fps, 2)));
            return;
        }// end function

        private function stopFpsTimer() : void
        {
            this.fpsNumber = 0;
            this.fpsTimer.stop();
            this.fpsTimer.removeEventListener(TimerEvent.TIMER, this.getFps);
            this.fpsArr = null;
            MemClean.run();
            return;
        }// end function

        protected function startSeek() : void
        {
            this.seekTime = getTimer();
            this.canCountSeek = true;
            return;
        }// end function

        protected function afterSeek() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            if (this.canCountSeek)
            {
                _loc_1 = getTimer() - this.seekTime;
                _loc_2 = [];
                _loc_3 = new ValueOBJ("t", "sk");
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("v", _loc_1.toString());
                _loc_2.push(_loc_3);
                _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_SEEK_TIME, _loc_2));
                this.canCountSeek = false;
            }
            return;
        }// end function

        protected function startMemoryCheck() : void
        {
            if (this.memTimer != null)
            {
                this.stopMemTimer();
            }
            this.memTimer = new Timer(1000 * 60);
            this.memTimer.addEventListener(TimerEvent.TIMER, this.getMem);
            this.memTimer.start();
            this.memArr = [];
            return;
        }// end function

        public function sendConvivaPackage(param1:String, param2:Object) : void
        {
            this.convivaMonitor.sendPackage(param1, param2);
            return;
        }// end function

        public function startAConvivaMonitor(param1:Object, param2:String) : void
        {
            if (_modelLocator.isConviva)
            {
                if (this.enableConviva)
                {
                    this.convivaMonitor.start(param1, param2);
                }
            }
            return;
        }// end function

        public function createConvivaMonitor(param1:String, param2:String) : void
        {
            if (_modelLocator.isConviva)
            {
                if (Math.random() < this.convivaRate)
                {
                    this.enableConviva = true;
                }
                if (_modelLocator.isConviva && this.convivaMonitor == null)
                {
                    this.convivaMonitor = new ConvivaMonitor();
                    this.convivaMonitor.init(param1, param2);
                }
                else
                {
                    this.convivaMonitor.cleanUp();
                }
            }
            return;
        }// end function

        public function createSession(param1:String, param2:String) : void
        {
            if (this.convivaMonitor)
            {
                this.convivaMonitor.createSession(param1, param2);
            }
            return;
        }// end function

        public function switchAConvivaMonitor(param1:Object, param2:String) : void
        {
            if (_modelLocator.isConviva && this.enableConviva)
            {
                this.convivaMonitor.switchStreamer(param1, param2);
            }
            return;
        }// end function

        public function stopAConvivaMonitor() : void
        {
            if (_modelLocator.isConviva && this.enableConviva)
            {
                this.convivaMonitor.cleanUp();
            }
            return;
        }// end function

        private function getMem(event:TimerEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Object = null;
            var _loc_6:String = null;
            var _loc_7:int = 0;
            var _loc_8:Array = null;
            var _loc_9:ValueOBJ = null;
            var _loc_10:Number = NaN;
            if (this.isPlaying)
            {
                if (this.memArr[0] == null)
                {
                    this.memArr[0] = MathUtil.roundToDecimal(System.totalMemory / 1000000, 2);
                }
                else
                {
                    _loc_2 = System.totalMemory;
                    _loc_3 = this.memArr[0];
                    _loc_4 = _loc_2 / 1000000 - _loc_3;
                    this.memArr[this.memNumber] = MathUtil.roundToDecimal(_loc_4, 2);
                }
                var _loc_11:String = this;
                var _loc_12:* = this.memNumber + 1;
                _loc_11.memNumber = _loc_12;
                if (this.memNumber == 10)
                {
                    _loc_5 = new Object();
                    _loc_6 = "";
                    _loc_7 = 1;
                    while (_loc_7 < this.memArr.length)
                    {
                        
                        _loc_10 = MathUtil.roundToDecimal(Number(this.memArr[_loc_7]), 1);
                        if (_loc_10 >= 0)
                        {
                            _loc_6 = _loc_6 + ("P" + Math.abs(_loc_10));
                        }
                        else
                        {
                            _loc_6 = _loc_6 + ("N" + Math.abs(_loc_10));
                        }
                        if (_loc_7 != (this.memArr.length - 1))
                        {
                            _loc_6 = _loc_6 + "_";
                        }
                        _loc_7++;
                    }
                    _loc_8 = [];
                    _loc_9 = new ValueOBJ("t", "mem");
                    _loc_8.push(_loc_9);
                    _loc_9 = new ValueOBJ("v", String(this.memArr[0]));
                    _loc_8.push(_loc_9);
                    _loc_9 = new ValueOBJ("d", _loc_6);
                    _loc_8.push(_loc_9);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_MEMORY, _loc_8));
                    this.stopMemTimer();
                }
            }
            return;
        }// end function

        private function stopMemTimer() : void
        {
            this.memNumber = 0;
            this.memTimer.stop();
            this.memTimer.removeEventListener(TimerEvent.TIMER, this.getMem);
            this.memArr = null;
            MemClean.run();
            return;
        }// end function

        protected function startHotmap() : void
        {
            if (_modelLocator.paramVO.isHotmap)
            {
                setTimeout(this.realStartHotmap, 30000);
            }
            return;
        }// end function

        private function realStartHotmap() : void
        {
            this.hotmapTimer = new Timer(this.HOTMAP_TIMER * 1000);
            this.hotmapTimer.addEventListener(TimerEvent.TIMER, this.sendHotmap);
            this.hotmapTimer.start();
            this.sendHotmap(null);
            return;
        }// end function

        private function sendHotmap(event:TimerEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            if (this.isPlaying)
            {
                _loc_2 = [];
                _loc_3 = new ValueOBJ("t", "hotmap");
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("v", int(this.getTime()).toString());
                _loc_2.push(_loc_3);
                _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_HOT_MAP, _loc_2));
            }
            return;
        }// end function

        protected function stopHotmap() : void
        {
            if (_modelLocator.paramVO.isHotmap)
            {
                this.hotmapTimer.stop();
                this.hotmapTimer.removeEventListener(TimerEvent.TIMER, this.sendHotmap);
                this.hotmapTimer = null;
            }
            return;
        }// end function

        protected function addKeepOnPlayButton(param1:String) : void
        {
            if (this.keepOnPlayButton != null && stage.contains(this.keepOnPlayButton))
            {
                stage.removeChild(this.keepOnPlayButton);
            }
            this.keepOnPlayButton = new PlaySceneButton();
            this.keepOnPlayButton.alpha = 0.8;
            this.keepOnPlayButton.x = 25;
            this.keepOnPlayButton.y = stage.stageHeight - this.keepOnPlayButton.height - 55;
            this.keepOnPlayButton.addEventListener(MouseEvent.MOUSE_OVER, this.keepOnOverHandler);
            this.keepOnPlayButton.addEventListener(MouseEvent.MOUSE_OUT, this.keepOnOutHandler);
            this.keepOnPlayButton.addEventListener(MouseEvent.CLICK, this.keepOnPlayHandler);
            this.keepOnPlayButton.name = "keepOnPlayButton";
            stage.addChild(this.keepOnPlayButton);
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_P2P_NOTICE, null));
            return;
        }// end function

        private function keepOnOverHandler(event:MouseEvent) : void
        {
            this.keepOnPlayButton.alpha = 1;
            return;
        }// end function

        private function keepOnOutHandler(event:MouseEvent) : void
        {
            this.keepOnPlayButton.alpha = 0.8;
            return;
        }// end function

        protected function removeKeepOnPlayButton() : void
        {
            if (this.keepOnPlayButton != null && stage.contains(this.keepOnPlayButton))
            {
                this.keepOnPlayButton.removeEventListener(MouseEvent.CLICK, this.keepOnPlayHandler);
                stage.removeChild(this.keepOnPlayButton);
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_P2P_NOTICE, null));
            }
            var _loc_1:* = stage.getChildByName("keepOnPlayButton");
            if (_loc_1 != null)
            {
                stage.removeChild(_loc_1);
            }
            return;
        }// end function

        protected function keepOnPlayHandler(event:MouseEvent) : void
        {
            this.playOrPauseHandler(null);
            return;
        }// end function

        protected function playOrPauseHandler(event:VideoPlayEvent) : void
        {
            return;
        }// end function

        protected function startRecordBestRate() : void
        {
            if (this.canDoBestRate)
            {
                if (this.bestRateTimer == null)
                {
                    this.bestRateTimer = new Timer(BEST_RATE_TIME * 60 * 1000, 1);
                    this.bestRateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.getBestRate);
                }
                else
                {
                    this.bestRateTimer.stop();
                    this.bestRateTimer.reset();
                }
                this.bestRateTimer.start();
            }
            return;
        }// end function

        private function getBestRate(event:TimerEvent) : void
        {
            this.bestRateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.getBestRate);
            this.canDoBestRate = false;
            var _loc_2:Array = [];
            var _loc_3:* = new ValueOBJ("t", "_bstr0003");
            _loc_2.push(_loc_3);
            _loc_3 = new ValueOBJ("v", this.nowRateString);
            _loc_2.push(_loc_3);
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BEST_RATE, _loc_2));
            return;
        }// end function

        public function addHotDot(param1:Number, param2:Boolean = false) : void
        {
            _modelLocator.paramVO.hotmapData.totalTime = param1;
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_SHOW_HOTDOT, param2));
            return;
        }// end function

        public function addNBA() : void
        {
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_SHOW_NBA));
            return;
        }// end function

        public function addFloatLogo() : void
        {
            if (_modelLocator.paramVO.floatLogoTrigger)
            {
                if (_modelLocator.paramVO.floatLogoURL != null && _modelLocator.paramVO.floatLogoURL != "")
                {
                    new ImageLoader(new URLRequest(_modelLocator.paramVO.floatLogoURL), this.getFloatLogo, this.getFloatLogoError);
                }
                else
                {
                    this.addDefaultLogo();
                }
            }
            return;
        }// end function

        private function getFloatLogo(param1:DisplayObject) : void
        {
            this.floatLogo = param1;
            this.floatLogo.alpha = 0.5;
            this.floatLogo.visible = false;
            this.addChild(this.floatLogo);
            return;
        }// end function

        private function getFloatLogoError(param1:String) : void
        {
            this.addDefaultLogo();
            return;
        }// end function

        public function removeFloatLogo() : void
        {
            if (this.floatLogo)
            {
                this.removeChild(this.floatLogo);
                this.floatLogo = null;
            }
            return;
        }// end function

        protected function setLogoPos() : void
        {
            return;
        }// end function

        private function addDefaultLogo() : void
        {
            this.floatLogo = new FloatLogo();
            this.floatLogo.visible = false;
            this.addChild(this.floatLogo);
            return;
        }// end function

        protected function updateTargetUrl(param1:String, param2:Number) : void
        {
            if (_modelLocator.paramVO.isTargetAD && this.targetADModule)
            {
                this.targetADModule.updateUrl(param1, param2);
                this.addChild(this.targetADModule);
            }
            return;
        }// end function

        protected function startTargetAD(param1:String, param2:Number, param3:Number) : void
        {
            if (_modelLocator.paramVO.isTargetAD)
            {
                if (this.targetADModule == null)
                {
                    this.targetADModule = new TargetADModule();
                    this.addChild(this.targetADModule);
                }
                this.targetADModule.startUp(param1, param2, param3);
            }
            return;
        }// end function

        protected function updateTargetADTime(param1:Number) : void
        {
            if (_modelLocator.paramVO.isTargetAD && this.targetADModule)
            {
                this.targetADModule.updateTime(param1);
            }
            return;
        }// end function

        protected function updateTargetADSize(param1:Number, param2:Number, param3:Number, param4:Number) : void
        {
            var _loc_5:Boolean = false;
            if (_modelLocator.paramVO.isTargetAD && this.targetADModule)
            {
                _loc_5 = false;
                this.addChild(this.targetADModule);
                if (stage.displayState == "fullScreen")
                {
                    _loc_5 = true;
                }
                this.targetADModule.updateSize(param1, param2, param3, param4, _loc_5);
            }
            return;
        }// end function

    }
}
