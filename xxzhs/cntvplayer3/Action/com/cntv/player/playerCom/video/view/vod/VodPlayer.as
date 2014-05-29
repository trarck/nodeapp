package com.cntv.player.playerCom.video.view.vod
{
    import caurina.transitions.*;
    import com.cntv.common.events.*;
    import com.cntv.common.model.proxy.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.math.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.tools.psFilterTool.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.player.playerCom.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.cntv.player.playerCom.controlBar.view.hotDot.*;
    import com.cntv.player.playerCom.controlBar.view.nba.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.playerCom.video.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.cntv.player.playerCom.video.model.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class VodPlayer extends VideoBase
    {
        private var nc:NetConnection;
        private var ns:NetStream;
        private var video:Video;
        private var metaObject:Object;
        private var videoWidth:Number;
        private var videoHeight:Number;
        private var w_videoWidth:Number;
        private var w_videoHeight:Number;
        private var psFilter:PSFilterTools;
        private var isGetMeta:Boolean = false;
        private var isStartPlay:Boolean = false;
        private var soundTrans:SoundTransform;
        private var isPause:Boolean = false;
        private var isCanBuffer:Boolean = false;
        private var isMute:Boolean = false;
        private var isSetVideoLength:Boolean = false;
        private var defaultStartTime:Number = 0;
        private var defaultStartTimer:Timer;
        private var bufferCheckTimer:Timer;
        private var startLoadTime:int = 0;
        private var canDoSwitchUp:Boolean = true;
        private var ncConnectTimer:Timer;
        private var lastTime:Number = 0;
        private var haltTimes:int = 0;
        private var canCheckBW:Boolean = true;
        private var isSlice:Boolean = false;
        private var sliceStart:Number = 0;
        private var sliceEnd:Number = 0;
        private var slicestarted:Boolean = false;
        private var hotStarted:Boolean = false;
        private var isMatchStarted:Boolean = false;
        private var isHotDotSeek:Boolean = false;
        private var pauseDuring:Number = 0;
        private var pauseTimeOutPoint:Number = -1;
        private var isLoadedVideo:Boolean = false;
        private var reconnectTimes:Number = 0;
        private var hasAReConnect:Boolean = false;
        private var hasCallBW:Boolean = false;
        private var timeOuter:uint;
        private var frameSkipOuter:uint = 0;
        private var bwCont:int = 0;
        private var levels:Array;
        private var lowLevels:Array;
        private var nowLevel:int = 0;
        private var countUp:int = 0;
        private var countDown:int = 0;
        private var lowBufferTime:int = 0;
        private var nowRate:int = 0;
        private var isUseAutoSwitchMode:Boolean = true;
        private var lastBW:int = 0;
        private var hasSendHaltError:Boolean = false;
        private var smaplingTimes:int = 0;
        private var samplingArr:Array;
        private var nowStream:StreamVO;
        private var nowStreamIndex:int = 0;

        public function VodPlayer(param1:Number = 0)
        {
            this.levels = [100, 350, 600, 1000];
            this.lowLevels = [0, 100, 350, 600];
            this.samplingArr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            this.defaultStartTime = param1;
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_BITERATE_MODE_CHANGE, this.switchRateHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_REPLAY, this.replayHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SINGLE_CLICK, this.playOrPauseHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_DOUBLE_CLICK, this.screenChangeHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_RESET_BUFFER_FLAG, this.resetBufferFlag);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_CHANGERATE_CLICKED, this.onNoticeChangeRateClicked);
            _dispatcher.addEventListener(GetVideoMatchProxy.getMatchEvent, this.onGetMatch);
            this.bufferCheckTimer = new Timer(10000);
            this.bufferCheckTimer.addEventListener(TimerEvent.TIMER, this.bufferCheckTimerHandler);
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_MODEL));
            return;
        }// end function

        override protected function release() : void
        {
            this.removeNetStreamListen();
            this.removeNetConnectListen();
            return;
        }// end function

        private function removeNetConnectListen() : void
        {
            if (this.nc != null)
            {
                this.nc.removeEventListener(NetStatusEvent.NET_STATUS, this.ncNetStatuHandler);
                this.nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.ncAsyncErrorHandler);
                this.nc.removeEventListener(IOErrorEvent.IO_ERROR, this.ncIOErrorHandler);
                this.nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.ncSecurityHandler);
                this.nc.close();
                this.nc = null;
            }
            return;
        }// end function

        private function removeNetStreamListen() : void
        {
            if (this.ns != null)
            {
                this.ns.removeEventListener(NetStatusEvent.NET_STATUS, this.nsNetStatusHandler);
                this.ns.removeEventListener(IOErrorEvent.IO_ERROR, this.nsIOErrorHandler);
                this.ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.nsAsyncErrorHandler);
                this.ns.close();
                this.ns = null;
            }
            return;
        }// end function

        override protected function initNetConnection() : void
        {
            this.nc = new NetConnection();
            this.nc.objectEncoding = 0;
            this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.ncNetStatuHandler);
            this.nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.ncSecurityHandler);
            this.nc.addEventListener(IOErrorEvent.IO_ERROR, this.ncIOErrorHandler);
            this.nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.ncAsyncErrorHandler);
            this.nc.client = new VideoPlayerClient(this);
            return;
        }// end function

        private function reConnectionNormal() : void
        {
            var _loc_1:* = new StatusVO(_modelLocator.i18n.ERROR_CAN_NOT_GET_VIDEO_FILE, StatuBoxEvent.TYPE_CENTER, true);
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_1));
            return;
        }// end function

        private function reConnection() : void
        {
            if (this.ns)
            {
                this.ns.close();
            }
            if (this.video)
            {
                this.video.clear();
            }
            this.nc.removeEventListener(NetStatusEvent.NET_STATUS, this.ncNetStatuHandler);
            this.nc.close();
            this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.ncNetStatuHandler);
            this.nc.connect(_modelLocator.currentVideoInfo.streams[_modelLocator.currentRtmpBiteRate]["rtmpHost"]);
            return;
        }// end function

        private function rconnectAndSeek(param1:Number = 0) : void
        {
            if (this.ns != null)
            {
                if (param1 == 0)
                {
                    this.pauseTimeOutPoint = this.ns.time;
                }
                else if (param1 > 0)
                {
                    this.pauseTimeOutPoint = param1;
                }
                this.video.clear();
                this.ns.close();
                this.ns = null;
                this.bufferCheckTimer.stop();
                this.bufferCheckTimer.removeEventListener(TimerEvent.TIMER, this.bufferCheckTimerHandler);
                setStatuToManager("8");
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
                this.isStartPlay = false;
                haveAStopRequest = false;
                stopHotmap();
                this.release();
            }
            this.nc = null;
            this.initNetConnection();
            this.nc.connect(_modelLocator.currentVideoInfo.streams[_modelLocator.currentRtmpBiteRate]["rtmpHost"]);
            var _loc_2:String = this;
            var _loc_3:* = this.reconnectTimes + 1;
            _loc_2.reconnectTimes = _loc_3;
            return;
        }// end function

        override public function play() : void
        {
            var _loc_1:Array = null;
            var _loc_2:ValueOBJ = null;
            var _loc_3:Array = null;
            this.pauseDuring = (getTimer() - this.pauseDuring) / 1000;
            bufferTimeLength = getTimer();
            if (!this.isStartPlay)
            {
                this.nc.connect(_modelLocator.currentVideoInfo.streams[_modelLocator.currentRtmpBiteRate]["rtmpHost"]);
            }
            else if (this.ns != null)
            {
                if (this.pauseDuring > 240)
                {
                    this.rconnectAndSeek();
                    _loc_1 = [];
                    _loc_2 = new ValueOBJ("t", "rcs");
                    _loc_1.push(_loc_2);
                    _loc_2 = new ValueOBJ("v", String(this.reconnectTimes));
                    _loc_1.push(_loc_2);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_RECONNECT_SERVER, _loc_1));
                    _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
                    this.isPause = false;
                    this.pauseDuring = getTimer();
                    _loc_3 = [];
                    _loc_3.push(0);
                    _loc_3.push(0);
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, _loc_3));
                }
                else
                {
                    this.ns.resume();
                    this.isPause = false;
                    _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
                }
            }
            return;
        }// end function

        override protected function get isPlaying() : Boolean
        {
            return !this.isPause && !this.isInBuffer;
        }// end function

        override public function pause() : void
        {
            if (this.ns != null)
            {
                this.pauseDuring = getTimer();
                this.ns.pause();
                this.isPause = true;
                this.clearBandCont();
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PAUSE));
            }
            return;
        }// end function

        override protected function adjust() : void
        {
            if (stage == null)
            {
                return;
            }
            super.adjust();
            this.resizeVideo();
            if (keepOnPlayButton != null)
            {
                keepOnPlayButton.x = 25;
                keepOnPlayButton.y = stage.stageHeight - keepOnPlayButton.height - 55;
            }
            return;
        }// end function

        override public function setBrightness(param1:int) : void
        {
            this.psFilter.brightness = param1;
            super.setBrightness(param1);
            return;
        }// end function

        override public function setContrast(param1:Number) : void
        {
            this.psFilter.contrast = param1;
            super.setContrast(param1);
            return;
        }// end function

        override protected function preSeek() : void
        {
            if (this.ns.time > 20)
            {
                this.seek((this.ns.time - 20) / this.getTotalTime());
            }
            return;
        }// end function

        override protected function backSeek() : void
        {
            if (this.ns.time < this.getTotalTime() - 20)
            {
                this.seek((this.ns.time + 20) / this.getTotalTime());
            }
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            var _loc_3:Array = null;
            var _loc_4:ValueOBJ = null;
            if (this.isPause)
            {
                this.pauseDuring = (getTimer() - this.pauseDuring) / 1000;
            }
            if (this.pauseDuring > 240)
            {
                this.rconnectAndSeek(param1 * this.metaObject["duration"]);
                _loc_3 = [];
                _loc_4 = new ValueOBJ("t", "rcs");
                _loc_3.push(_loc_4);
                _loc_4 = new ValueOBJ("v", String(this.reconnectTimes));
                _loc_3.push(_loc_4);
                _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_RECONNECT_SERVER, _loc_3));
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
                this.isPause = false;
                isCanCheckBuffer = false;
                removeKeepOnPlayButton();
            }
            else if (this.ns != null && this.metaObject != null)
            {
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_BUFFER_READY, null));
                clearTimeout(this.timeOuter);
                isCanCheckBuffer = false;
                startSeek();
                this.ns.seek(param1 * this.metaObject["duration"]);
                if (!this.isHotDotSeek)
                {
                    _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_SEEK, param1));
                }
                this.isHotDotSeek = false;
            }
            if (this.isPause)
            {
                this.pauseDuring = getTimer();
            }
            var _loc_2:Array = [];
            _loc_2.push(0);
            _loc_2.push(0);
            this.isCanBuffer = true;
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, _loc_2));
            return;
        }// end function

        override public function setVolume(param1:Number) : void
        {
            this.isMute = false;
            this.soundTrans = new SoundTransform(param1);
            if (this.ns != null)
            {
                this.ns.soundTransform = this.soundTrans;
            }
            return;
        }// end function

        override public function muteOn() : void
        {
            this.isMute = true;
            this.setVolume(0);
            return;
        }// end function

        override public function muteOff() : void
        {
            this.isMute = false;
            this.setVolume(_modelLocator.volumeValue);
            return;
        }// end function

        override public function screenNormal() : void
        {
            var _loc_1:* = ControlBarModule.CONTROL_BAR_HEIGHT;
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                _loc_1 = 0;
            }
            var _loc_2:* = (stage.stageWidth - this.videoWidth) / 2;
            var _loc_3:* = (stage.stageHeight - _loc_1 - this.videoHeight) / 2;
            Tweener.removeTweens(this.video);
            Tweener.addTween(this.video, {time:0.5, x:_loc_2, y:_loc_3, width:this.videoWidth, height:this.videoHeight, onComplete:this.afterScreenSwitch});
            return;
        }// end function

        override public function screenWide() : void
        {
            var _loc_1:* = ControlBarModule.CONTROL_BAR_HEIGHT;
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                _loc_1 = 0;
            }
            var _loc_2:* = (stage.stageWidth - this.w_videoWidth) / 2;
            var _loc_3:* = (stage.stageHeight - _loc_1 - this.w_videoHeight) / 2;
            Tweener.removeTweens(this.video);
            Tweener.addTween(this.video, {time:0.5, x:_loc_2, y:_loc_3, width:this.w_videoWidth, height:this.w_videoHeight, onComplete:this.afterScreenSwitch});
            return;
        }// end function

        private function afterScreenSwitch() : void
        {
            updateTargetADSize(this.video.width, this.video.height, this.video.x, this.video.y);
            _modelLocator.isInScreenSwitch = false;
            this.setLogoPos();
            return;
        }// end function

        private function ncNetStatuHandler(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.createStream();
                    break;
                }
                case "NetConnection.Connect.Rejected":
                case "NetConnection.Connect.Failed":
                {
                    this.reConnectionNormal();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function ncSecurityHandler(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

        private function ncIOErrorHandler(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function ncAsyncErrorHandler(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function createStream() : void
        {
            var _loc_1:Array = null;
            var _loc_2:Number = NaN;
            if (bufferIntevalIndex != Math.PI)
            {
                clearTimeout(bufferIntevalIndex);
                bufferIntevalIndex = Math.PI;
            }
            this.nc.removeEventListener(NetStatusEvent.NET_STATUS, this.ncNetStatuHandler);
            this.ns = new NetStream(this.nc);
            this.ns.bufferTime = RTMP_BUFFER_TIME;
            this.ns.addEventListener(NetStatusEvent.NET_STATUS, this.nsNetStatusHandler);
            this.ns.addEventListener(IOErrorEvent.IO_ERROR, this.nsIOErrorHandler);
            this.ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.nsAsyncErrorHandler);
            this.ns.client = new VideoPlayerClient(this);
            if (stage)
            {
                this.videoWidth = stage.stageWidth;
                this.videoHeight = stage.stageHeight;
            }
            this.video = new Video(this.videoWidth, this.videoHeight);
            this.video.smoothing = true;
            this.video.attachNetStream(this.ns);
            this.psFilter = new PSFilterTools(this.video);
            this.addChild(this.video);
            addFloatLogo();
            setMask();
            addkeyListener();
            if (!_modelLocator.paramVO.isCycle && _modelLocator.currentVideoInfo.streams[1] != null)
            {
                _modelLocator.currentRtmpBiteRate = 1;
                this.nowRate = 1;
            }
            if (_modelLocator.currentVideoInfo.vddStreamRate != "")
            {
                _loc_1 = _modelLocator.vddBitRates;
                _loc_2 = 0;
                while (_loc_2 < _modelLocator.currentVideoInfo.streams.length)
                {
                    
                    if (_modelLocator.currentVideoInfo.streams[_loc_2] != null && _modelLocator.currentVideoInfo.vddStreamRate == _modelLocator.currentVideoInfo.streams[_loc_2].streamMode)
                    {
                        _modelLocator.currentRtmpBiteRate = _loc_2;
                        _modelLocator.currentRtmpBiteRateMode = _loc_2;
                        this.isUseAutoSwitchMode = false;
                        break;
                    }
                    _loc_2 = _loc_2 + 1;
                }
                if (this.isUseAutoSwitchMode)
                {
                    _modelLocator.currentRtmpBiteRate = _modelLocator.currentVideoInfo.streams.length - 1;
                    _modelLocator.currentRtmpBiteRateMode = _modelLocator.currentVideoInfo.streams.length - 1;
                    this.isUseAutoSwitchMode = false;
                }
            }
            this.nowRate = _modelLocator.currentRtmpBiteRate;
            this.nowStream = _modelLocator.currentVideoInfo.streams[_modelLocator.currentRtmpBiteRate];
            _modelLocator.currentFile = this.nowStream.streamName;
            nowRateString = this.nowStream.bitRate;
            _modelLocator.currentVideoInfo.vddStreamRate = this.nowStream.streamMode;
            this.ns.play(this.nowStream.streamName);
            _modelLocator.currentBitrate = Number(_modelLocator.currentVideoInfo.streams[_modelLocator.currentRtmpBiteRate].bitRate);
            if (!BeforePlayerADMoudle.isPlayingAd)
            {
                createSession(HTTP_VIDEO_SERVER_NAME, _modelLocator.currentVideoInfo.title);
                startAConvivaMonitor(this.ns, HTTP_VIDEO_SERVER_NAME);
                startTimeTimer();
            }
            if (this.defaultStartTime != 0)
            {
                this.ns.seek(this.defaultStartTime);
            }
            if (this.pauseTimeOutPoint > 0)
            {
                this.ns.seek(this.pauseTimeOutPoint);
                this.pauseTimeOutPoint = 0;
            }
            loadVideoTime = getTimer();
            return;
        }// end function

        private function checkLoadVideo() : void
        {
            var _loc_1:Array = null;
            var _loc_2:ValueOBJ = null;
            if (!this.isLoadedVideo)
            {
                _loc_1 = [];
                _loc_2 = new ValueOBJ("t", "lvto");
                _loc_1.push(_loc_2);
                _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_LOAD_VIDEO_TIME_OUT, _loc_1));
            }
            return;
        }// end function

        private function startBWCheck() : void
        {
            this.canCheckBW = true;
            if (!this.hasCallBW)
            {
                this.hasCallBW = true;
                this.nc.call("checkBandwidth", null);
                setTimeout(function () : void
            {
                canCheckBW = false;
                _modelLocator.currentRtmpBiteRateMode = nowLevel;
                var _loc_1:* = _modelLocator.currentVideoInfo.streams[nowLevel].bitRate;
                sendConvivaPackage("biteRate", {value:_loc_1});
                return;
            }// end function
            , 120000);
            }
            return;
        }// end function

        private function nsNetStatusHandler(event:NetStatusEvent) : void
        {
            var _loc_2:ValueOBJ = null;
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_5:Number = NaN;
            var _loc_6:String = null;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            setVideoStatu(event.info.code);
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
                {
                    startGetFps();
                    startHotmap();
                    showCornerAD();
                    startRecordBestRate();
                    startMemoryCheck();
                    startTargetAD(this.nowStream.getP2pUrl(), this.video.x, this.video.y);
                    this.timeOuter = setTimeout(this.changeToCanCheckBuffer, 10000);
                    if (memoryTimeOuter != 0)
                    {
                        clearTimeout(memoryTimeOuter);
                    }
                    memoryTimeOuter = setTimeout(startMemoryCheck, 1000 * 5);
                    if (this.frameSkipOuter != 0)
                    {
                        clearTimeout(this.frameSkipOuter);
                    }
                    this.frameSkipOuter = setTimeout(startGetFps, 1000 * 60 * FPS_2ND_TIME);
                    this.bufferCheckTimer.start();
                    setTimeout(this.checkLoadVideo, 15000);
                    this.isStartPlay = true;
                    _loc_3 = [];
                    _loc_2 = new ValueOBJ("t", "lv");
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("v", int(getTimer() - loadVideoTime).toString());
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("isp2p", "false");
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("isHaveAD", _modelLocator.paramVO.adCall != "" ? ("true") : ("false"));
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("adLen", _modelLocator.adVosBF.length.toString());
                    _loc_3.push(_loc_2);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_LOAD_VIDEO_TIME, _loc_3));
                    if (!this.isPause)
                    {
                        _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
                    }
                    _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_UNLOCK_CONTROLBAR));
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, [0, 0]));
                    startTimeTimer();
                    bufferTimeLength = getTimer();
                    canSendBt = true;
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    if (this.metaObject)
                    {
                        if (Math.abs(this.metaObject["duration"] - this.ns.time) <= END_TIME_DIFF)
                        {
                            this.playOver();
                        }
                        else
                        {
                            haveAStopRequest = true;
                        }
                    }
                    break;
                }
                case "NetStream.Play.InsufficientBW":
                {
                    (this.lowBufferTime + 1);
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    if (this.ns != null)
                    {
                        if (RTMP_BUFFER_TIME < 4)
                        {
                            RTMP_BUFFER_TIME = RTMP_BUFFER_TIME + 2;
                        }
                        else
                        {
                            RTMP_BUFFER_TIME = 10;
                        }
                        this.ns.bufferTime = RTMP_BUFFER_TIME;
                    }
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_BUFFER_READY, null));
                    if (isCanCheckBuffer)
                    {
                        _loc_8 = [];
                        _loc_2 = new ValueOBJ("t", "bf");
                        _loc_8.push(_loc_2);
                        if (this.ns != null)
                        {
                            _loc_2 = new ValueOBJ("time", this.ns.time.toString());
                        }
                        else
                        {
                            _loc_2 = new ValueOBJ("time", bufferTimesCount.toString());
                        }
                        _loc_8.push(_loc_2);
                        _loc_2 = new ValueOBJ("v", bufferTimesCount.toString());
                        _loc_8.push(_loc_2);
                        _loc_2 = new ValueOBJ("file", _modelLocator.currentFile);
                        _loc_8.push(_loc_2);
                        _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_AFFLUENT, _loc_8));
                        var _loc_10:* = bufferTimesCount + 1;
                        bufferTimesCount = _loc_10;
                    }
                    (this.lowBufferTime + 1);
                    this.isCanBuffer = true;
                    bufferTimeLength = getTimer();
                    canSendBt = true;
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this.isCanBuffer = false;
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
                    if (!canSendBt)
                    {
                        return;
                    }
                    canSendBt = false;
                    _loc_4 = [];
                    _loc_2 = new ValueOBJ("t", "bt");
                    _loc_4.push(_loc_2);
                    if (this.ns != null)
                    {
                        _loc_2 = new ValueOBJ("time", this.ns.time.toString());
                    }
                    else
                    {
                        _loc_2 = new ValueOBJ("time", bufferTimesCount.toString());
                    }
                    _loc_4.push(_loc_2);
                    bufferTimeLength = getTimer() - bufferTimeLength;
                    _loc_5 = Math.floor(bufferTimeLength);
                    if (_loc_5 > 0 && _loc_5 < 150000)
                    {
                        _loc_2 = new ValueOBJ("v", _loc_5.toString());
                        _loc_4.push(_loc_2);
                    }
                    _loc_6 = String(Math.random());
                    _loc_2 = new ValueOBJ("radom", _loc_6);
                    _loc_4.push(_loc_2);
                    _loc_2 = new ValueOBJ("file", _modelLocator.currentFile);
                    _loc_4.push(_loc_2);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUFFER_LENGTH, _loc_4));
                    var _loc_10:* = bufferTimesCount + 1;
                    bufferTimesCount = _loc_10;
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                case "NetStream.Play.FileStructureInvalid":
                {
                    _loc_7 = [];
                    _loc_2 = new ValueOBJ("t", "err");
                    _loc_7.push(_loc_2);
                    _loc_2 = new ValueOBJ("file", _modelLocator.currentFile);
                    _loc_7.push(_loc_2);
                    _loc_2 = new ValueOBJ("v", QualityMonitorEvent.ERROR_CAN_NOT_GET_VIDEO_FILE);
                    _loc_7.push(_loc_2);
                    _loc_2 = new ValueOBJ("errmsg", event.info.code);
                    _loc_7.push(_loc_2);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_7));
                    this.reConnectionNormal();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function playOver() : void
        {
            if (_modelLocator.paramVO.isCycle)
            {
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_CYCLE_PLAY_NEXT));
            }
            else
            {
                this.bufferCheckTimer.stop();
                this.bufferCheckTimer.removeEventListener(TimerEvent.TIMER, this.bufferCheckTimerHandler);
                setStatuToManager("8");
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PLAY_STOP));
            }
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_SHUT_DOWN));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_MESSAGE, null));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
            this.removeEventListener(Event.ENTER_FRAME, this.loop);
            this.isStartPlay = false;
            haveAStopRequest = false;
            stopAConvivaMonitor();
            stopTimeTimer();
            stopHotmap();
            if (ExternalInterface.available)
            {
                ExternalInterface.call("cntv_player_review_start_time", -1);
            }
            return;
        }// end function

        private function resetBufferFlag(event:VideoPlayEvent) : void
        {
            this.isCanBuffer = false;
            return;
        }// end function

        override protected function get isInBuffer() : Boolean
        {
            return this.isCanBuffer;
        }// end function

        override protected function get fps() : Number
        {
            if (this.ns != null)
            {
                return this.ns.currentFPS;
            }
            return 0;
        }// end function

        private function changeToCanCheckBuffer() : void
        {
            isCanCheckBuffer = true;
            return;
        }// end function

        private function doSliceStart() : void
        {
            var _loc_1:* = this.sliceStart / this.metaObject.duration;
            this.seek(_loc_1);
            return;
        }// end function

        private function doDefaultSeek(event:TimerEvent) : void
        {
            var _loc_2:* = this.defaultStartTime / this.metaObject.duration;
            return;
        }// end function

        private function nsIOErrorHandler(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function nsAsyncErrorHandler(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function loop(event:Event) : void
        {
            var _loc_3:Array = null;
            var _loc_2:* = this.ns.time / this.metaObject.duration;
            _modelLocator.currentTime = this.ns.time;
            if (_modelLocator.paramVO.isHotDotNotice && _modelLocator.paramVO.isSlicedByHotDot)
            {
                _loc_2 = (this.ns.time - this.sliceStart) / _modelLocator.sliceMovieDuration;
            }
            if (_modelLocator.paramVO.isHotDotNotice && this._modelLocator.paramVO.hotmapData != null)
            {
                if (_modelLocator.paramVO.isSlicedByHotDot)
                {
                    if (this.ns.time >= this.sliceEnd && this.sliceEnd != 0)
                    {
                        this.ns.close();
                        this.playOver();
                        this.hotStarted = false;
                    }
                }
            }
            if (ExternalInterface.available)
            {
                ExternalInterface.call("cntv_player_review_start_time", _modelLocator.paramVO.videoCenterId, this.getTotalTime(), this.ns.time);
            }
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_PLAYED, _loc_2));
            updateTargetADTime(this.ns.time);
            if (this.ns.time == lastTimeMark && !this.isPause)
            {
                if (this.isCanBuffer)
                {
                    this.isCanBuffer = false;
                    _loc_3 = [];
                    _loc_3.push(this.bufferPercent);
                    _loc_3.push(0);
                    if (_modelLocator.currentRtmpBiteRateMode > 0 && _modelLocator.currentRtmpBiteRate > 0)
                    {
                        _loc_3[1] = 1;
                    }
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, _loc_3));
                }
            }
            else
            {
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
            }
            lastTimeMark = this.ns.time;
            if (haveAStopRequest)
            {
                if (Math.abs(this.metaObject["duration"] - this.ns.time) <= END_TIME_DIFF)
                {
                    this.playOver();
                }
            }
            return;
        }// end function

        private function onBufferTimeOut() : void
        {
            bufferIntevalIndex = Math.PI;
            this.rconnectAndSeek();
            bufferIntevalIndex = setTimeout(this.onBufferTimeOut, (bufferTimeOutValue + 5) * 1000);
            return;
        }// end function

        public function get bufferPercent() : int
        {
            var _loc_1:int = 0;
            if (this.isCanBuffer)
            {
                _loc_1 = this.ns.bufferLength / RTMP_BUFFER_TIME * 100;
                if (_loc_1 > 100)
                {
                    return 100;
                }
                return _loc_1;
            }
            else
            {
                return 100;
            }
        }// end function

        public function onBWDone(param1:Number) : void
        {
            var _loc_2:* = param1;
            _loc_2 = this.bwSmapling(_loc_2);
            if (this.canCheckBW)
            {
                this.nc.call("checkBandwidth", null);
            }
            if (this.isUseAutoSwitchMode && !_modelLocator.isInSwitch && this.isStartPlay && this.isPlaying)
            {
                if (_loc_2 > this.levels[this.nowLevel])
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this.countUp + 1;
                    _loc_3.countUp = _loc_4;
                    if (this.countUp > 10)
                    {
                        this.switchUp();
                    }
                }
                else if (this.countUp > 0)
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this.countUp - 1;
                    _loc_3.countUp = _loc_4;
                }
            }
            return;
        }// end function

        private function switchUp() : void
        {
            if (this.nowLevel < (_modelLocator.currentVideoInfo.streams.length - 1))
            {
                (this.nowLevel + 1);
                this.switchBiteRate(this.nowLevel);
            }
            return;
        }// end function

        private function switchDown() : void
        {
            var _loc_1:Array = null;
            var _loc_2:ValueOBJ = null;
            if (this.nowLevel > 0)
            {
                this.canDoSwitchUp = false;
                (this.nowLevel - 1);
                this.switchBiteRate(this.nowLevel);
                _loc_1 = [];
                _loc_2 = new ValueOBJ("t", "_smr0002");
                _loc_1.push(_loc_2);
                _loc_2 = new ValueOBJ("v", _modelLocator.currentVideoInfo.streams[this.nowLevel]["bitRate"]);
                _loc_1.push(_loc_2);
                _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_SMOOTH_RATE, _loc_1));
            }
            return;
        }// end function

        private function bufferCheckTimerHandler(event:TimerEvent) : void
        {
            if (this.lowBufferTime > 2)
            {
                this.switchDown();
            }
            this.lowBufferTime = 0;
            if (this.lastTime == this.ns.time && this.lastTime != 0 && !this.isInBuffer)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.haltTimes + 1;
                _loc_2.haltTimes = _loc_3;
            }
            if (this.haltTimes > 1)
            {
                this.haltTimes = 0;
                this.sendAHaltError();
            }
            this.lastTime = this.ns.time;
            return;
        }// end function

        private function sendAHaltError() : void
        {
            var _loc_1:Array = null;
            var _loc_2:ValueOBJ = null;
            if (!this.hasSendHaltError)
            {
                this.hasSendHaltError = true;
                _loc_1 = [];
                _loc_2 = new ValueOBJ("t", "err");
                _loc_1.push(_loc_2);
                _loc_2 = new ValueOBJ("file", _modelLocator.currentFile);
                _loc_1.push(_loc_2);
                _loc_2 = new ValueOBJ("v", QualityMonitorEvent.ERROR_VIDEO_HALT);
                _loc_1.push(_loc_2);
                _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_1));
            }
            return;
        }// end function

        private function getBWArea(param1:int) : int
        {
            if (param1 < 500)
            {
                return 0;
            }
            if (param1 >= 500 && param1 < 900)
            {
                return 1;
            }
            if (param1 >= 900 && param1 < 1600)
            {
                return 2;
            }
            return 3;
        }// end function

        private function bwSmapling(param1:int) : int
        {
            var _loc_2:String = null;
            var _loc_3:int = 0;
            if (this.smaplingTimes < this.samplingArr.length)
            {
                this.samplingArr[this.smaplingTimes] = param1;
                var _loc_4:String = this;
                var _loc_5:* = this.smaplingTimes + 1;
                _loc_4.smaplingTimes = _loc_5;
            }
            else
            {
                _loc_2 = "";
                _loc_3 = 0;
                while (_loc_3 < this.samplingArr.length)
                {
                    
                    if (_loc_3 != (this.samplingArr.length - 1))
                    {
                        this.samplingArr[_loc_3] = this.samplingArr[(_loc_3 + 1)];
                    }
                    _loc_3++;
                }
                this.samplingArr[(this.samplingArr.length - 1)] = param1;
            }
            return MathUtil.avg(this.samplingArr);
        }// end function

        public function switchBiteRate(param1:int) : void
        {
            var _loc_2:NetStreamPlayOptions = null;
            var _loc_3:StatusVO = null;
            if (this.nowRate != param1 && !_modelLocator.isInSwitch && !_modelLocator.paramVO.isCycle)
            {
                this.nowRate = param1;
                _modelLocator.currentRtmpBiteRate = this.nowRate;
                ShareObjecter.setOptions(_modelLocator.localDataObjectName, _modelLocator.localDataPath, "currentRtmpBiteRate", _modelLocator.currentRtmpBiteRate.toString());
                _modelLocator.isInSwitch = true;
                _loc_2 = new NetStreamPlayOptions();
                _loc_2.oldStreamName = this.nowStream.streamName;
                this.nowStream = _modelLocator.currentVideoInfo.streams[this.nowRate];
                _loc_2.streamName = this.nowStream.streamName;
                _loc_2.transition = NetStreamPlayTransitions.SWITCH;
                _modelLocator.currentFile = this.nowStream.streamName;
                nowRateString = this.nowStream.bitRate;
                startRecordBestRate();
                this.ns.play2(_loc_2);
                _loc_3 = new StatusVO(_modelLocator.i18n.STATU_RATE_IN_SWITCH, StatuBoxEvent.TYPE_FLIP, false);
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_3));
                this.clearBandCont();
                _modelLocator.currentBitrate = Number(this.nowStream.bitRate);
                if (_modelLocator.isConviva && enableConviva)
                {
                    _dispatcher.dispatchEvent(new CommonEvent(ConvivaMonitor.EVENT_UPDATE_CONVIVA_BIT, Number(this.nowStream.bitRate)));
                }
            }
            return;
        }// end function

        private function clearBandCont() : void
        {
            this.lastBW = 0;
            this.bwCont = 0;
            this.countDown = 0;
            this.countUp = 0;
            return;
        }// end function

        public function switchRateHandler(event:VideoPlayEvent) : void
        {
            if (_modelLocator.currentRtmpBiteRateMode < _modelLocator.currentVideoInfo.streams.length)
            {
                this.isUseAutoSwitchMode = false;
                this.clearBandCont();
                this.switchBiteRate(_modelLocator.currentRtmpBiteRateMode);
            }
            else
            {
                this.isUseAutoSwitchMode = true;
                this.clearBandCont();
                this.canCheckBW = true;
                this.nc.call("checkBandwidth", null);
            }
            return;
        }// end function

        private function onNoticeChangeRateClicked(event:StatuBoxEvent) : void
        {
            (_modelLocator.currentRtmpBiteRate - 1);
            if (_modelLocator.currentRtmpBiteRate < _modelLocator.currentVideoInfo.streams.length && _modelLocator.currentRtmpBiteRate >= 0)
            {
                _modelLocator.currentRtmpBiteRateMode = _modelLocator.currentRtmpBiteRate;
                this.isUseAutoSwitchMode = false;
                this.clearBandCont();
                this.switchBiteRate(_modelLocator.currentRtmpBiteRateMode);
            }
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

        private function screenChangeHandler(event:VideoPlayEvent) : void
        {
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                stage.displayState = StageDisplayState.NORMAL;
            }
            else
            {
                stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            return;
        }// end function

        public function replayHandler(event:VideoPlayEvent) : void
        {
            bufferTimeLength = getTimer();
            var _loc_2:Number = 0;
            this.hotStarted = true;
            if (_modelLocator.paramVO.isHotDotNotice && this._modelLocator.paramVO.hotmapData != null && !this.hotStarted && _modelLocator.paramVO.isSlicedByHotDot)
            {
                _loc_2 = this.sliceStart;
            }
            if (this.ns != null)
            {
                this.reset();
                this.ns.seek(_loc_2);
            }
            else
            {
                this.initNetConnection();
            }
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            afterSeek();
            if (_modelLocator.currentVideoInfo.streams.length > 1 && _modelLocator.currentRtmpBiteRateMode == 4)
            {
                setTimeout(this.startBWCheck, 10000);
            }
            else if (_modelLocator.currentRtmpBiteRateMode < _modelLocator.currentVideoInfo.streams.length)
            {
                this.isUseAutoSwitchMode = false;
                this.canCheckBW = false;
            }
            this.metaObject = param1;
            _modelLocator.movieDuration = this.metaObject.duration;
            if (!this.isSetVideoLength)
            {
                this.isSetVideoLength = true;
                _modelLocator.recordManager.setVideoLength(_modelLocator.movieDuration.toString());
            }
            this.videoWidth = this.metaObject.width;
            this.videoHeight = this.metaObject.height;
            this.addEventListener(Event.ENTER_FRAME, this.loop);
            this.resizeVideo();
            this.setStatus();
            if (_modelLocator.paramVO.isHotDotNotice && (this._modelLocator.paramVO.hotmapData != null || _modelLocator.paramVO.icanNBAData != "") && !this.hotStarted)
            {
                this.hotStarted = true;
                if (_modelLocator.paramVO.isNBA)
                {
                    this.addNBA();
                    this._dispatcher.addEventListener(iconNba.EVENT_SEEK_VIDEO, this.onNbaSeek);
                }
                else if (_modelLocator.paramVO.isSlicedByHotDot)
                {
                    this.isSlice = true;
                    if (_modelLocator.paramVO.sliceEndTime == -1 || _modelLocator.paramVO.sliceEndTime == 0)
                    {
                        _modelLocator.paramVO.sliceEndTime = this.getTotalTime();
                    }
                    this.sliceStart = _modelLocator.paramVO.sliceStartTime;
                    this.sliceEnd = _modelLocator.paramVO.sliceEndTime;
                    setTimeout(this.doSliceStart, 200);
                    _modelLocator.sliceMovieDuration = this.sliceEnd - this.sliceStart;
                }
                else
                {
                    this._dispatcher.addEventListener(HotDot.EVENT_SEEK_VIDEO, this.onHotDotSeek);
                    addHotDot(this.getTotalTime());
                }
            }
            if (!this.isMatchStarted)
            {
                this.isMatchStarted = true;
                new GetVideoMatchProxy().load();
            }
            if (BeforePlayerADMoudle.isPlayingAd)
            {
                if (!this.isPause)
                {
                    _dispatcher.addEventListener(VideoPlayEvent.EVENT_PREDOWNLOAD_OVER, this.onPreLoadOver);
                    this.pause();
                }
            }
            this.isLoadedVideo = true;
            return;
        }// end function

        private function onNbaSeek(event:CommonEvent) : void
        {
            this.seek(Number(event["data"]) / this.getTotalTime());
            return;
        }// end function

        private function onPreLoadOver(event:VideoPlayEvent) : void
        {
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_PREDOWNLOAD_OVER, this.onPreLoadOver);
            createSession(HTTP_VIDEO_SERVER_NAME, _modelLocator.currentVideoInfo.title);
            startAConvivaMonitor(this.ns, HTTP_VIDEO_SERVER_NAME);
            startTimeTimer();
            this.play();
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_ADPLAY_OVER));
            bufferTimeLength = getTimer();
            return;
        }// end function

        public function onPlayStatus(param1:Object) : void
        {
            var _loc_2:StatusVO = null;
            if (param1.code == "NetStream.Play.TransitionComplete")
            {
                _loc_2 = new StatusVO(_modelLocator.i18n.STATU_RATE_SWITCH_COMPLETE, StatuBoxEvent.TYPE_FLIP, true);
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
                _modelLocator.isInSwitch = false;
            }
            return;
        }// end function

        public function resizeVideo() : void
        {
            var _loc_1:* = ControlBarModule.CONTROL_BAR_HEIGHT;
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                _loc_1 = 0;
            }
            var _loc_2:* = this.videoWidth / this.videoHeight;
            if (this.videoWidth != stage.stageWidth)
            {
                this.videoWidth = stage.stageWidth;
                this.videoHeight = this.videoWidth / _loc_2;
                if (this.videoHeight > stage.stageHeight - _loc_1)
                {
                    this.videoHeight = stage.stageHeight - _loc_1;
                    this.videoWidth = this.videoHeight * _loc_2;
                }
            }
            else if (this.videoHeight != stage.stageHeight - _loc_1)
            {
                this.videoHeight = stage.stageHeight - _loc_1;
                this.videoWidth = this.videoHeight * _loc_2;
                if (this.videoWidth > stage.stageWidth)
                {
                    this.videoWidth = stage.stageWidth;
                    this.videoHeight = this.videoWidth / _loc_2;
                }
            }
            this.w_videoWidth = stage.stageWidth;
            this.w_videoHeight = this.w_videoWidth * 9 / 16 - _loc_1;
            if (this.video != null)
            {
                if (_modelLocator.wideMode == _modelLocator.NORMAL_SCREEN)
                {
                    this.video.width = this.videoWidth;
                    this.video.height = this.videoHeight;
                }
                else
                {
                    this.video.width = this.w_videoWidth;
                    this.video.height = this.w_videoHeight;
                }
                this.video.x = (stage.stageWidth - this.video.width) / 2;
                this.video.y = (stage.stageHeight - _loc_1 - this.video.height) / 2;
            }
            updateTargetADSize(this.video.width, this.video.height, this.video.x, this.video.y);
            this.setLogoPos();
            return;
        }// end function

        private function onHotDotSeek(event:CommonEvent) : void
        {
            this.isHotDotSeek = true;
            var _loc_2:* = event["data"];
            var _loc_3:Array = [];
            var _loc_4:* = new ValueOBJ("t", "hpclick");
            _loc_3.push(_loc_4);
            _loc_4 = new ValueOBJ("v", _loc_2);
            _loc_3.push(_loc_4);
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_HOT_CLICKED, _loc_3));
            this.seek(Number(event["data"]) / this.getTotalTime());
            return;
        }// end function

        public function reset() : void
        {
            _modelLocator.isInSwitch = false;
            this.canDoSwitchUp = true;
            this.clearBandCont();
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_MESSAGE, null));
            return;
        }// end function

        public function setStatus() : void
        {
            if (isPsFilterActive)
            {
                this.setBrightness(_modelLocator.brightness * 510 - 255);
                this.setContrast(_modelLocator.contrast);
            }
            if (_modelLocator.isMute)
            {
                this.muteOn();
            }
            else
            {
                this.muteOff();
            }
            if (_modelLocator.wideMode == _modelLocator.NORMAL_SCREEN)
            {
                this.screenNormal();
            }
            else
            {
                this.screenWide();
            }
            return;
        }// end function

        override public function clear() : void
        {
            if (this.hasEventListener(Event.ENTER_FRAME))
            {
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            if (this.ns != null)
            {
                this.ns.pause();
                this.removeNetStreamListen();
            }
            if (this.nc != null)
            {
                this.removeNetConnectListen();
            }
            if (this.video != null)
            {
                this.video.clear();
                this.removeChild(this.video);
            }
            removeKeepOnPlayButton();
            this.video = null;
            if (_dispatcher.hasEventListener(GetVideoMatchProxy.getMatchEvent))
            {
                _dispatcher.removeEventListener(GetVideoMatchProxy.getMatchEvent, this.onGetMatch);
            }
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_BITERATE_MODE_CHANGE, this.switchRateHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_REPLAY, this.replayHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_SINGLE_CLICK, this.playOrPauseHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_DOUBLE_CLICK, this.screenChangeHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_RESET_BUFFER_FLAG, this.resetBufferFlag);
            this.bufferCheckTimer.stop();
            this.bufferCheckTimer.removeEventListener(TimerEvent.TIMER, this.bufferCheckTimerHandler);
            try
            {
                System.gc();
            }
            catch (e:Error)
            {
            }
            removeFloatLogo();
            return;
        }// end function

        override protected function setLogoPos() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (floatLogo)
            {
                floatLogo.visible = true;
                _loc_1 = floatLogo.width / floatLogo.height;
                floatLogo.width = this.video.width * FLOAT_LOGO_WIDTH_RATIO;
                floatLogo.height = floatLogo.width / _loc_1;
                _loc_2 = FLOAT_LOGO_Y_RATIO * this.video.height;
                _loc_3 = FLOAT_LOGO_X_RATIO * this.video.width;
                floatLogo.x = this.video.x + this.video.width - floatLogo.width - _loc_3;
                floatLogo.y = this.video.y + _loc_2;
            }
            return;
        }// end function

        override public function seekInSeconds(param1:Number) : void
        {
            this.ns.seek(param1);
            return;
        }// end function

        override public function getTotalTime() : Number
        {
            if (this.metaObject != null)
            {
                return this.metaObject["duration"];
            }
            return 0;
        }// end function

        override public function getTime() : Number
        {
            if (this.ns != null)
            {
                return this.ns.time;
            }
            return 0;
        }// end function

        private function onGetMatch(event:Event) : void
        {
            var _loc_2:Object = {};
            if (_modelLocator.paramVO.matchData.isPrecise)
            {
                this._dispatcher.addEventListener(HotDot.EVENT_SEEK_VIDEO, this.onChangeVideo);
                _loc_2.points = _modelLocator.paramVO.matchData.options;
                _modelLocator.paramVO.hotmapData = _loc_2;
                addHotDot(this.getTotalTime(), true);
                this.hotStarted = true;
            }
            else if (!_modelLocator.paramVO.isSlicedByHotDot && _modelLocator.paramVO.isHotDotNotice && _modelLocator.hotDotPluginLoaded)
            {
                _dispatcher.dispatchEvent(new Event(HotDot.EVENT_ADD));
            }
            else
            {
                this._dispatcher.addEventListener(HotDot.EVENT_SEEK_VIDEO, this.onHotDotSeek);
                _loc_2.points = _modelLocator.paramVO.matchData.options;
                _modelLocator.paramVO.hotmapData = _loc_2;
                addHotDot(this.getTotalTime(), true);
                this.hotStarted = true;
            }
            return;
        }// end function

        private function onChangeVideo(event:CommonEvent) : void
        {
            return;
        }// end function

    }
}
