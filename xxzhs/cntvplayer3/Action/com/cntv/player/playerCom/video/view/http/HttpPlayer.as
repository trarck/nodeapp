package com.cntv.player.playerCom.video.view.http
{
    import caurina.transitions.*;
    import com.cntv.common.events.*;
    import com.cntv.common.model.proxy.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.graphics.*;
    import com.cntv.common.tools.memory.*;
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
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class HttpPlayer extends VideoBase
    {
        private var videoWidth:Number = 640;
        private var videoHeight:Number = 480;
        private var w_videoWidth:Number = 640;
        private var w_videoHeight:Number = 480;
        private var video:Video;
        private var video2:Video;
        private var ns:NetStream;
        private var netStream:NetStream;
        private var netStream2:NetStream;
        private var netCon:NetConnection;
        private var playList:Array;
        private var playConut:int;
        private var _totalTime:Number;
        private var _totalHour:int;
        private var _totalMinute:int;
        private var _totalSecond:int;
        private var _currentTime:Number;
        private var _currentHour:int;
        private var _currentMinute:int;
        private var _currentSecond:int;
        private var _movieWidth:Number;
        private var _movieHeight:Number;
        private var _isPause:Boolean;
        private var _isPlaying:Boolean;
        private var _isSoundOn:Boolean;
        private var _volume:Number;
        private var _isGetMetaData:Boolean = true;
        private var nowPlaying:int = 1;
        public var isCanFufferNext:Boolean = true;
        public var isCanFuffer:Boolean = true;
        private var isHighRate:Number = 1;
        private var isInPlaying:Boolean = false;
        public var localData1:Object;
        public var localData2:Object;
        private var tempSound:SoundTransform;
        public var canShowLoaded:Boolean = true;
        public var loadedAll:Boolean = false;
        public var startLoadTime:int = 0;
        private var urlListIndex:int = 0;
        private var urlListIndex2:int = 0;
        private var urlListIndex3:int = 0;
        private var psFilter1:PSFilterTools;
        private var psFilter2:PSFilterTools;
        private var defaultStartTime:Number = 0;
        private var defaultStartTimer:Timer;
        private var bufferedTimer:int = 0;
        private var canDoBWCheck:Boolean = true;
        private var isSlice:Boolean = false;
        private var sliceStart:Number = 0;
        private var sliceEnd:Number = 0;
        private var slicestarted:Boolean = false;
        private var hotStarted:Boolean = false;
        private var reSetStart:Boolean = false;
        private var offerSetTime:Number = 0;
        private var isHotDotSeek:Boolean = false;
        private var isMatchStarted:Boolean = false;
        private var currentNetStream:NetStream;
        private var currentVideo:Video;
        private var checkMemoTimer:Timer;
        private var memoryCookieName:String = "";
        private var memoFullTip:String = "如果您打开多个播放页面,建议关闭不观看的页面,以免资源占用过多";
        private var memoryFullTip:Sprite;
        private var psFilters:Array;
        private var isLoadedVideo:Boolean = false;
        private var lastBfNs:Object;
        private var timeOuter:uint;
        private var frameSkipOuter:uint = 0;
        public var bufferTimes:int = 0;
        public var nowPlayingURL:String;
        private var bufferNextSuccess:Boolean = true;
        private var keyframes:Object;
        private var mp4:Boolean = false;
        private var firstUse:Boolean = true;
        private var doLengthCheck:Boolean = true;
        private var startPlayAVideo:Boolean = true;
        private var nowLocalData:Object;
        private var my_position:Number = 0;
        private var isSetVideoLength:Boolean = false;
        private var isSetDefault:Boolean = false;
        private var setCopyOfVod:Boolean = false;
        private var localStartTime:int = 0;
        private var currentChapterBaseTime:Number = 0;
        private var my_offset:Number = 0;
        private var my_byteoffset:Number = 0;
        private var isStreamed:Boolean = false;
        private var pos:Number = 0;
        private var seekTimes:int = 0;
        private var tempSeekValue:Number;
        private var global_baseTime:Number = 0;

        public function HttpPlayer(param1:Number = 0)
        {
            this.defaultStartTime = param1;
            this.playConut = 0;
            this._isSoundOn = true;
            this._isPause = false;
            this._volume = 0.5;
            this.tempSound = new SoundTransform();
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_HTTP_BITERATE_MODE_CHANGE, this.switchRateHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_REPLAY, this.replayHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SINGLE_CLICK, this.playOrPauseHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_DOUBLE_CLICK, this.screenChangeHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_RESET_BUFFER_FLAG, this.resetBufferFlag);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_CHANGERATE_CLICKED, this.onNoticeChangeRateClicked);
            _dispatcher.addEventListener(GetVideoMatchProxy.getMatchEvent, this.onGetMatch);
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_MODEL));
            var _loc_2:* = new Date();
            this.memoryCookieName = "httpPlayer" + Date.parse(_loc_2.toString());
            return;
        }// end function

        override protected function setPropor(event:VideoPlayEvent) : void
        {
            super.setPropor(event);
            this.setVideoSize2();
            return;
        }// end function

        override protected function init() : void
        {
            OR_STAGE_WIDTH = stage.stageWidth;
            OR_STAGE_HEIGHT = stage.stageHeight - ControlBarModule.CONTROL_BAR_HEIGHT;
            setMask();
            addkeyListener();
            return;
        }// end function

        override protected function release() : void
        {
            this.removeNetStreamListen();
            this.removeNetConnectListen();
            return;
        }// end function

        override protected function initNetConnection() : void
        {
            this.netCon = new NetConnection();
            this.netCon.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
            this.netCon.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this.netCon.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            return;
        }// end function

        override public function setBrightness(param1:int) : void
        {
            var _loc_2:Array = null;
            ChapterVO.brightness = param1;
            if (this.isHighRate == 1)
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters2;
            }
            else if (this.isHighRate == 2)
            {
                _loc_2 = _modelLocator.currentVideoInfo.lowChapters;
            }
            else
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters;
            }
            var _loc_3:Number = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                if (_loc_2[_loc_3].video != null)
                {
                    _loc_2[_loc_3].psFilter.setOwner(_loc_2[_loc_3].video);
                    _loc_2[_loc_3].psFilter.brightness = param1;
                }
                _loc_3 = _loc_3 + 1;
            }
            super.setBrightness(param1);
            return;
        }// end function

        override public function setContrast(param1:Number) : void
        {
            var _loc_2:Array = null;
            ChapterVO.contrast = param1;
            if (this.isHighRate == 1)
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters2;
            }
            else if (this.isHighRate == 2)
            {
                _loc_2 = _modelLocator.currentVideoInfo.lowChapters;
            }
            else
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters;
            }
            var _loc_3:Number = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                if (_loc_2[_loc_3].video != null)
                {
                    _loc_2[_loc_3].psFilter.setOwner(_loc_2[_loc_3].video);
                    _loc_2[_loc_3].psFilter.contrast = param1;
                }
                _loc_3 = _loc_3 + 1;
            }
            super.setContrast(param1);
            return;
        }// end function

        override protected function preSeek() : void
        {
            if (this.currentTime > 20)
            {
                this.seek((this.currentTime - 20) / this.totalTime);
            }
            return;
        }// end function

        override protected function backSeek() : void
        {
            if (this.currentTime < this.totalTime - 20)
            {
                this.seek((this.currentTime + 20) / this.totalTime);
            }
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            this.currentTime = param1 * _modelLocator.movieDuration;
            return;
        }// end function

        override public function screenNormal() : void
        {
            return;
        }// end function

        override public function screenWide() : void
        {
            return;
        }// end function

        private function afterScreenSwitch() : void
        {
            updateTargetADSize(stage.stageWidth, stage.stageHeight, this.video.x, this.video.y);
            _modelLocator.isInScreenSwitch = false;
            this.setLogoPos();
            return;
        }// end function

        private function loop(event:Event) : void
        {
            var cvo2:ChapterVO;
            var cvo:ChapterVO;
            var ccp:ChapterVO;
            var playTime:Number;
            var played:Number;
            var arr:Array;
            var bwTime:int;
            var bw:Number;
            var bv:int;
            var qd:Array;
            var vo:ValueOBJ;
            var d:Number;
            var e:* = event;
            try
            {
                if (this.ns.bytesLoaded >= this.ns.bytesTotal && this.ns.bytesLoaded > 0)
                {
                    if (this.isHighRate == 1 && this.urlListIndex2 < (_modelLocator.currentVideoInfo.chapters2.length - 1))
                    {
                        cvo = _modelLocator.currentVideoInfo.chapters2[(this.urlListIndex2 + 1)];
                        ccp = _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2];
                    }
                    else if (this.isHighRate == 0 && this.urlListIndex < (_modelLocator.currentVideoInfo.chapters.length - 1))
                    {
                        cvo = _modelLocator.currentVideoInfo.chapters[(this.urlListIndex + 1)];
                        ccp = _modelLocator.currentVideoInfo.chapters[this.urlListIndex];
                    }
                    else if (this.isHighRate == 2 && this.urlListIndex3 < (_modelLocator.currentVideoInfo.lowChapters.length - 1))
                    {
                        cvo = _modelLocator.currentVideoInfo.lowChapters[(this.urlListIndex3 + 1)];
                        ccp = _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3];
                    }
                    if (cvo != null && ccp != null)
                    {
                        playTime = ccp.chapterStart + ccp.ns.time;
                        if (cvo != null && (cvo.chapterStart != 0 || !cvo.isLoadComp) && this.isCanFufferNext && (playTime >= _modelLocator.buffer_next_time || ccp.duration - playTime < _modelLocator.Buffer_next_distance))
                        {
                            this.bufferNext();
                        }
                    }
                }
                if (this.isHighRate == 1)
                {
                    cvo2 = _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2];
                }
                else if (this.isHighRate == 2)
                {
                    cvo2 = _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3];
                }
                else
                {
                    cvo2 = _modelLocator.currentVideoInfo.chapters[this.urlListIndex];
                }
                if (!_modelLocator.paramVO.isCycle)
                {
                    played = this.currentTime / this.totalTime;
                    _modelLocator.currentTime = this.currentTime;
                    if (_modelLocator.paramVO.isHotDotNotice && _modelLocator.paramVO.isSlicedByHotDot)
                    {
                        played = (this.currentTime - this.sliceStart) / _modelLocator.sliceMovieDuration;
                        if (played < 0)
                        {
                            played;
                        }
                    }
                    if (cvo2)
                    {
                        updateTargetADTime(this.currentTime);
                    }
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_PLAYED, played));
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_LOADED, this.loaded));
                    if (ExternalInterface.available && _modelLocator.ISWEBSITE)
                    {
                        ExternalInterface.call("cntv_player_review_start_time", _modelLocator.paramVO.videoCenterId, this.totalTime, this.currentTime);
                    }
                }
                if (_modelLocator.paramVO.isHotDotNotice && this._modelLocator.paramVO.startTime != -1)
                {
                    if (_modelLocator.paramVO.isSlicedByHotDot)
                    {
                        if (this.currentTime >= this.sliceEnd && this.sliceEnd != 0)
                        {
                            this.ns.close();
                            this.callPlayOver();
                            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_PLAYED, 0));
                            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
                            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_LOADED, 0));
                            this.hotStarted = false;
                        }
                    }
                }
                if (this.ns != null && (lastTimeMark == this.ns.time || this.ns.time == 0) && !this.isPause)
                {
                    if (this.isCanFuffer)
                    {
                        arr;
                        arr.push(this.bufferPercent);
                        arr.push(0);
                        arr[1] = this.isHighRate;
                        _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, arr));
                    }
                }
                else
                {
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
                }
                if (this.ns != null)
                {
                    lastTimeMark = this.ns.time;
                }
                if (this.canDoBWCheck && this.ns != null)
                {
                    if (this.ns.bytesLoaded > 5 * 1000 * 1000)
                    {
                        bwTime = getTimer() - this.startLoadTime;
                        bw = this.ns.bytesLoaded / bwTime * 8;
                        bv;
                        if (bw > 10000)
                        {
                            bv;
                        }
                        this.canDoBWCheck = false;
                        qd;
                        vo = new ValueOBJ("t", "_bw0004");
                        qd.push(vo);
                        vo = new ValueOBJ("v", bw.toString());
                        qd.push(vo);
                        vo = new ValueOBJ("bv", bv.toString());
                        qd.push(vo);
                        _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BAND_WIDTH, qd));
                    }
                }
                if (haveAStopRequest)
                {
                    d;
                    if (this.nowLocalData != null)
                    {
                        d = this.nowLocalData.duration;
                    }
                    else
                    {
                        d = cvo2.localData.localData.duration;
                    }
                    if (Math.abs(this.ns.time - d) <= END_TIME_DIFF)
                    {
                        this.playNext();
                    }
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function onBufferTimeOut() : void
        {
            clearTimeout(bufferIntevalIndex);
            bufferIntevalIndex = Math.PI;
            var _loc_1:* = this.urlListIndex;
            if (this.isHighRate == 1)
            {
                _loc_1 = this.urlListIndex2;
            }
            else if (this.isHighRate == 2)
            {
                _loc_1 = this.urlListIndex3;
            }
            var _loc_2:Number = 0;
            _loc_2 = this.getCurrentChapterBaseTime();
            this.toChapter(_loc_1, this.currentTime - _loc_2);
            var _loc_3:Array = [];
            var _loc_4:* = new ValueOBJ("t", "bfrs");
            _loc_3.push(_loc_4);
            _loc_4 = new ValueOBJ("v", bufferTimesCount.toString());
            _loc_3.push(_loc_4);
            _loc_4 = new ValueOBJ("time", this.currentTime.toString());
            _loc_3.push(_loc_4);
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_AFFLUENT, _loc_3));
            return;
        }// end function

        public function clearStream() : void
        {
            if (this.netCon != null)
            {
                this.video.clear();
                this.video.visible = false;
                if (this.ns != null)
                {
                    this.removeNetStreamListen();
                }
                this.removeNetConnectListen();
            }
            return;
        }// end function

        private function removeNetConnectListen() : void
        {
            if (this.netCon != null)
            {
                this.netCon.removeEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
                this.netCon.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                this.netCon.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
                this.netCon.close();
                this.netCon = null;
            }
            return;
        }// end function

        private function netStatusHandler(event:NetStatusEvent) : void
        {
            var _loc_2:ValueOBJ = null;
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_5:Number = NaN;
            var _loc_6:String = null;
            var _loc_7:Array = null;
            var _loc_8:StatusVO = null;
            var _loc_9:NetStream = null;
            var _loc_10:Array = null;
            setVideoStatu(event.info.code);
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.connectStream();
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                case "NetStream.Play.FileStructureInvalid":
                {
                    if (this.ns == event.target)
                    {
                        _loc_7 = [];
                        _loc_2 = new ValueOBJ("t", "err");
                        _loc_7.push(_loc_2);
                        _loc_2 = new ValueOBJ("v", QualityMonitorEvent.ERROR_CAN_NOT_GET_VIDEO_FILE);
                        _loc_7.push(_loc_2);
                        _loc_2 = new ValueOBJ("file", _modelLocator.currentFile);
                        _loc_7.push(_loc_2);
                        _loc_2 = new ValueOBJ("errmsg", event.info.code);
                        _loc_7.push(_loc_2);
                        _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_7));
                        _loc_8 = new StatusVO(_modelLocator.i18n.ERROR_CAN_NOT_GET_VIDEO_FILE, StatuBoxEvent.TYPE_CENTER, true);
                        _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_8));
                        _loc_9 = event.target as NetStream;
                        _loc_9 = null;
                    }
                    break;
                }
                case "NetStream.Play.Start":
                {
                    showCornerAD();
                    startGetFps();
                    startHotmap();
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
                    this.startLoadTime = getTimer() - loadVideoTime;
                    _loc_3 = [];
                    _loc_2 = new ValueOBJ("t", "lv");
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("v", this.startLoadTime.toString());
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("file", _modelLocator.currentFile);
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("isHaveAD", _modelLocator.paramVO.adCall != "" ? ("true") : ("false"));
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("adLen", _modelLocator.adVosBF.length.toString());
                    _loc_3.push(_loc_2);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_LOAD_VIDEO_TIME, _loc_3));
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_LOADING, null));
                    this.setVolume(_modelLocator.volumeValue);
                    if (_modelLocator.isMute)
                    {
                        this.muteOn();
                    }
                    else
                    {
                        this.muteOff();
                    }
                    if (!this._isPause)
                    {
                        _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
                    }
                    _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_UNLOCK_CONTROLBAR));
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, [0, 0]));
                    if (this.hasEventListener(Event.ENTER_FRAME))
                    {
                        this.removeEventListener(Event.ENTER_FRAME, this.loop);
                    }
                    this.addEventListener(Event.ENTER_FRAME, this.loop);
                    bufferTimeLength = getTimer();
                    this.lastBfNs = this.ns;
                    if (this.lastBfNs == event.target)
                    {
                        canSendBt = true;
                    }
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    if (this.nowLocalData && Math.abs(this.ns.time - this.nowLocalData.duration) <= END_TIME_DIFF || this.nowLocalData.duration <= END_TIME_DIFF)
                    {
                        this.playNext();
                    }
                    else
                    {
                        haveAStopRequest = true;
                    }
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    this.isCanFuffer = true;
                    if (this.ns != null)
                    {
                        if (BUFFER_TIME < 4)
                        {
                            BUFFER_TIME = BUFFER_TIME + 2;
                        }
                        else
                        {
                            BUFFER_TIME = 10;
                        }
                        this.ns.bufferTime = BUFFER_TIME;
                    }
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_BUFFER_READY, null));
                    bufferTimeLength = getTimer();
                    this.lastBfNs = this.ns;
                    if (this.lastBfNs == event.target)
                    {
                        canSendBt = true;
                    }
                    if (isCanCheckBuffer)
                    {
                        if (this.ns != null && this.ns.bytesLoaded == this.ns.bytesTotal)
                        {
                            return;
                        }
                        _loc_10 = [];
                        _loc_2 = new ValueOBJ("t", "bf");
                        _loc_10.push(_loc_2);
                        _loc_2 = new ValueOBJ("v", bufferTimesCount.toString());
                        _loc_10.push(_loc_2);
                        _loc_2 = new ValueOBJ("time", this.currentTime.toString());
                        _loc_10.push(_loc_2);
                        _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_AFFLUENT, _loc_10));
                        _loc_10 = [];
                        _loc_2 = new ValueOBJ("t", "_switchbf0001");
                        _loc_10.push(_loc_2);
                        _loc_2 = new ValueOBJ("v", "1");
                        _loc_10.push(_loc_2);
                        _loc_2 = new ValueOBJ("time", this.currentTime.toString());
                        _loc_10.push(_loc_2);
                        _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_SWITCH_BUFFER, _loc_10));
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    MemClean.run();
                    this.isCanFuffer = false;
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, "full"));
                    bufferTimeLength = getTimer() - bufferTimeLength;
                    if (this.lastBfNs != event.target || !canSendBt)
                    {
                        return;
                    }
                    canSendBt = false;
                    _loc_4 = [];
                    _loc_2 = new ValueOBJ("t", "bt");
                    _loc_4.push(_loc_2);
                    _loc_5 = Math.floor(bufferTimeLength);
                    if (_loc_5 > 0 && _loc_5 < 150000)
                    {
                        _loc_2 = new ValueOBJ("v", _loc_5.toString());
                        _loc_4.push(_loc_2);
                    }
                    _loc_2 = new ValueOBJ("time", this.currentTime.toString());
                    _loc_4.push(_loc_2);
                    _loc_2 = new ValueOBJ("file", _modelLocator.currentFile);
                    _loc_4.push(_loc_2);
                    _loc_6 = String(Math.random());
                    _loc_2 = new ValueOBJ("radom", _loc_6);
                    _loc_4.push(_loc_2);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUFFER_LENGTH, _loc_4));
                    var _loc_12:* = bufferTimesCount + 1;
                    bufferTimesCount = _loc_12;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function resetBufferFlag(event:VideoPlayEvent) : void
        {
            this.isCanFuffer = false;
            return;
        }// end function

        override protected function get isInBuffer() : Boolean
        {
            return this.isCanFuffer;
        }// end function

        override protected function get fps() : Number
        {
            if (this.ns != null)
            {
                return this.ns.currentFPS;
            }
            return 0;
        }// end function

        override protected function get isPlaying() : Boolean
        {
            return !this._isPause && !this.isInBuffer;
        }// end function

        private function changeToCanCheckBuffer() : void
        {
            isCanCheckBuffer = true;
            return;
        }// end function

        private function showBufferLoop(event:Event) : void
        {
            return;
        }// end function

        private function addNewStream(param1:ChapterVO, param2:Boolean = false) : void
        {
            var _loc_3:* = param1;
            if (_loc_3.ns != null && _loc_3.video != null)
            {
                return;
            }
            _loc_3.ns = new NetStream(this.netCon);
            var _loc_4:* = new Object();
            new Object().onMetaData = _loc_3.onMetaData;
            if (param2)
            {
                _loc_3.onMetaData2 = this.onMetaData;
            }
            else
            {
                _loc_3.onMetaData2 = this.onMetaData2;
            }
            _loc_3.ns.client = _loc_4;
            _loc_3.ns.checkPolicyFile = true;
            _loc_3.ns.bufferTime = BUFFER_TIME;
            _loc_3.ns.soundTransform = this.tempSound;
            _loc_3.ns.addEventListener(NetStatusEvent.NET_STATUS, this.netErrorHandler);
            _loc_3.video = new Video(this.videoWidth, this.videoHeight);
            _loc_3.video.deblocking = 1;
            _loc_3.video.smoothing = true;
            _loc_3.video.attachNetStream(_loc_3.ns);
            _loc_3.ns.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
            _loc_3.ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            _loc_3.rotationSetter = new DynamicRegistration(_loc_3.video, new Point(this.videoWidth / 2, this.videoHeight / 2));
            _loc_3.psFilter = new PSFilterTools(_loc_3.video);
            if (ChapterVO.brightness != -1)
            {
                _loc_3.psFilter.brightness = ChapterVO.brightness;
            }
            if (ChapterVO.contrast != -1)
            {
                _loc_3.psFilter.contrast = ChapterVO.contrast;
            }
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

        private function dealDefaultTime() : void
        {
            this.getCurrentChapterBaseTime();
            return;
        }// end function

        private function connectStream() : void
        {
            var _loc_1:int = 0;
            var _loc_2:ChapterVO = null;
            var _loc_3:String = null;
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            var _loc_6:ValueOBJ = null;
            var _loc_7:StatusVO = null;
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_LOADING, "full"));
            if (_modelLocator.currentVideoInfo.vddStreamRate != "")
            {
                _loc_4 = _modelLocator.vddBitRates;
                switch(_modelLocator.currentVideoInfo.vddStreamRate)
                {
                    case _loc_4[0]:
                    case _loc_4[1]:
                    {
                        _modelLocator.currentHttpBiteRateMode = 0;
                        break;
                    }
                    case _loc_4[2]:
                    case _loc_4[3]:
                    {
                        _modelLocator.currentHttpBiteRateMode = 1;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            videoContainer = new Sprite();
            videoBaseContainer = new Sprite();
            videoContainer.addChild(videoBaseContainer);
            this.addChild(videoContainer);
            this._isGetMetaData = false;
            this.canShowLoaded = true;
            this.my_position = this.defaultStartTime;
            if (_modelLocator.currentHttpBiteRateMode == 1 && _modelLocator.currentVideoInfo.chapters2.length > 0)
            {
                _modelLocator.currentVideoInfo.vddStreamRate = "HD";
                this.isHighRate = 1;
                if (this.defaultStartTime != 0 && !this.isSetDefault)
                {
                    this.urlListIndex2 = this.getClickChapterIndex(this.defaultStartTime);
                    this.defaultStartTime = this.defaultStartTime - this.getCurrentChapterBaseTime(this.urlListIndex2);
                }
                this.global_baseTime = this.getCurrentChapterBaseTime();
                _modelLocator.currentBitrate = 850;
                _modelLocator.currentHttpBiteRate = 1;
                _modelLocator.currentHttpBiteRateMode = 1;
                _loc_2 = _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2];
                this.addNewStream(_loc_2, true);
                this.video = _loc_2.video;
                this.ns = _loc_2.ns;
                videoBaseContainer.addChild(this.video);
                _loc_2.chapterStart = 0;
                _loc_3 = _loc_2.url;
                _modelLocator.currentFile = _loc_3;
                _loc_2.chapterStart = this.defaultStartTime;
                if (this.defaultStartTime != 0 && !this.isSetDefault)
                {
                    _loc_2.loaded = true;
                    this.ns.play(_loc_3 + "?start=" + this.defaultStartTime);
                }
                else
                {
                    this.ns.play(_loc_3);
                }
                this.isSetDefault = true;
                this._isPlaying = true;
            }
            else if (_modelLocator.currentVideoInfo.chapters.length > 0)
            {
                _modelLocator.currentVideoInfo.vddStreamRate = "STD";
                _modelLocator.currentBitrate = 450;
                this.isHighRate = 0;
                if (this.defaultStartTime != 0 && !this.isSetDefault)
                {
                    this.urlListIndex = this.getClickChapterIndex(this.defaultStartTime);
                    this.defaultStartTime = this.defaultStartTime - this.getCurrentChapterBaseTime(this.urlListIndex);
                }
                this.global_baseTime = this.getCurrentChapterBaseTime();
                _modelLocator.currentHttpBiteRate = 0;
                _modelLocator.currentHttpBiteRateMode = 0;
                _loc_2 = _modelLocator.currentVideoInfo.chapters[this.urlListIndex];
                this.addNewStream(_loc_2, true);
                this.video = _loc_2.video;
                this.ns = _loc_2.ns;
                videoBaseContainer.addChild(this.video);
                _loc_2.chapterStart = 0;
                _loc_3 = _loc_2.url;
                _modelLocator.currentFile = _loc_3;
                _loc_2.chapterStart = this.defaultStartTime;
                if (this.defaultStartTime != 0 && !this.isSetDefault)
                {
                    _loc_2.loaded = true;
                    this.ns.play(_loc_3 + "?start=" + this.defaultStartTime);
                }
                else
                {
                    this.ns.play(_loc_3);
                }
                this.isSetDefault = true;
                this._isPlaying = true;
            }
            else if (_modelLocator.currentVideoInfo.lowChapters.length > 0)
            {
                _modelLocator.currentVideoInfo.vddStreamRate = "LD";
                _modelLocator.currentBitrate = 250;
                this.isHighRate = 0;
                if (this.defaultStartTime != 0 && !this.isSetDefault)
                {
                    this.urlListIndex3 = this.getClickChapterIndex(this.defaultStartTime);
                    this.defaultStartTime = this.defaultStartTime - this.getCurrentChapterBaseTime(this.urlListIndex3);
                }
                this.global_baseTime = this.getCurrentChapterBaseTime();
                _modelLocator.currentHttpBiteRate = 2;
                _modelLocator.currentHttpBiteRateMode = 2;
                _loc_2 = _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3];
                this.addNewStream(_loc_2, true);
                this.video = _loc_2.video;
                this.ns = _loc_2.ns;
                videoBaseContainer.addChild(this.video);
                _loc_2.chapterStart = 0;
                _loc_3 = _loc_2.url;
                _modelLocator.currentFile = _loc_3;
                _loc_2.chapterStart = this.defaultStartTime;
                if (this.defaultStartTime != 0 && !this.isSetDefault)
                {
                    _loc_2.loaded = true;
                    this.ns.play(_loc_3 + "?start=" + this.defaultStartTime);
                }
                else
                {
                    this.ns.play(_loc_3);
                }
                this.isSetDefault = true;
                this._isPlaying = true;
            }
            else
            {
                _loc_5 = [];
                _loc_6 = new ValueOBJ("t", "err");
                _loc_5.push(_loc_6);
                _loc_6 = new ValueOBJ("file", _modelLocator.currentFile);
                _loc_5.push(_loc_6);
                _loc_6 = new ValueOBJ("v", QualityMonitorEvent.ERROR_PLAY_LIST_EMPTY);
                _loc_5.push(_loc_6);
                _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_5));
                _loc_7 = new StatusVO(_modelLocator.i18n.ERROR_PLAY_LIST_EMPTY, StatuBoxEvent.TYPE_CENTER, true);
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_7));
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_LOADING, null));
            }
            addFloatLogo();
            if (BeforePlayerADMoudle.isPlayingAd)
            {
                _modelLocator.isMute = true;
            }
            if (cornerADPlayer != null)
            {
                this.addChild(cornerADPlayer);
            }
            loadVideoTime = getTimer();
            if (!BeforePlayerADMoudle.isPlayingAd)
            {
                createSession(HTTP_VIDEO_SERVER_NAME, _modelLocator.currentVideoInfo.title);
                startAConvivaMonitor(this.ns, HTTP_VIDEO_SERVER_NAME);
                startTimeTimer();
            }
            else
            {
                this.ns.pause();
            }
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_CHANGE_RATE_BY_DATA));
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_SET_TEXT, _modelLocator.currentVideoInfo.vddStreamRate));
            return;
        }// end function

        private function netErrorHandler(event:NetStatusEvent) : void
        {
            if (event.info.code == "NetStream.Play.StreamNotFound")
            {
                this.bufferNextSuccess = false;
            }
            return;
        }// end function

        private function removeNetStreamListen() : void
        {
            if (this.ns != null)
            {
                this.ns.removeEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
                this.ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                this.ns.close();
                this.ns = null;
            }
            return;
        }// end function

        private function asyncErrorHandler(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            var _loc_2:ChapterVO = null;
            var _loc_3:Boolean = false;
            var _loc_4:Array = null;
            var _loc_5:ValueOBJ = null;
            this.localData1 = null;
            this.localData1 = param1;
            afterSeek();
            _modelLocator.movieDuration = _modelLocator.currentVideoInfo.length;
            this.videoWidth = this.localData1.width;
            this.videoHeight = this.localData1.height;
            if (this.localData1.seekpoints)
            {
                this.keyframes = this.convertSeekpoints(this.localData1.seekpoints);
            }
            if (!this._isGetMetaData)
            {
                if (this.firstUse)
                {
                    _loc_3 = false;
                    if (this.isHighRate == 1)
                    {
                        _loc_2 = _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2];
                        if (_modelLocator.currentVideoInfo.chapters2.length == 1)
                        {
                            _loc_3 = true;
                        }
                    }
                    else if (this.isHighRate == 2)
                    {
                        _loc_2 = _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3];
                        if (_modelLocator.currentVideoInfo.lowChapters.length == 1)
                        {
                            _loc_3 = true;
                        }
                    }
                    else
                    {
                        _loc_2 = _modelLocator.currentVideoInfo.chapters[this.urlListIndex];
                        if (_modelLocator.currentVideoInfo.chapters.length == 1)
                        {
                            _loc_3 = true;
                        }
                    }
                    if (_loc_2 != null && _loc_2.duration == 0 && this.doLengthCheck)
                    {
                        _loc_2.duration = this.localData1.duration;
                        if (_loc_3)
                        {
                            _modelLocator.currentVideoInfo.length = this.localData1.duration;
                            _modelLocator.movieDuration = _modelLocator.currentVideoInfo.length;
                        }
                        this.doLengthCheck = false;
                    }
                    _loc_2.onMetaData2 = this.onMetaData2;
                    if (!this.isSetVideoLength)
                    {
                        this.isSetVideoLength = true;
                        _modelLocator.recordManager.setVideoLength(_modelLocator.currentVideoInfo.length.toString());
                        if (this.isHighRate)
                        {
                            _loc_4 = [];
                            _loc_5 = new ValueOBJ("t", "_switch0000");
                            _loc_4.push(_loc_5);
                            _loc_5 = new ValueOBJ("v", "1");
                            _loc_4.push(_loc_5);
                            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_SWITCH, _loc_4));
                        }
                    }
                    this.firstUse = false;
                    this.nowLocalData = _loc_2.localData;
                }
                this.resetTotal();
            }
            if (this.defaultStartTime != 0 && !this.isSetDefault)
            {
                this.isSetDefault = true;
                this.defaultStartTimer = new Timer(200, 1);
                this.defaultStartTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.doDoDefaultSeek);
                this.defaultStartTimer.start();
            }
            if (!this.isMatchStarted && _modelLocator.paramVO.isHotDotNotice)
            {
                if (_modelLocator.paramVO.isFromPrecise)
                {
                    setTimeout(this.doMatchStart, 200);
                }
                this.isMatchStarted = true;
                new GetVideoMatchProxy().load();
            }
            if (_modelLocator.paramVO.isHotDotNotice && (_modelLocator.paramVO.hotmapData != null || _modelLocator.paramVO.icanNBAData != "") && !this.hotStarted)
            {
                this.hotStarted = true;
                if (_modelLocator.paramVO.isNBA)
                {
                    setTimeout(this.addNBA, 1000);
                    this._dispatcher.addEventListener(iconNba.EVENT_SEEK_VIDEO, this.onNbaSeek);
                }
                else if (_modelLocator.paramVO.isSlicedByHotDot)
                {
                    this.isSlice = true;
                    if (_modelLocator.paramVO.sliceEndTime == -1 || _modelLocator.paramVO.sliceEndTime == 0)
                    {
                        _modelLocator.paramVO.sliceEndTime = this.totalTime;
                    }
                    this.sliceStart = _modelLocator.paramVO.sliceStartTime;
                    this.sliceEnd = _modelLocator.paramVO.sliceEndTime;
                    setTimeout(this.doSliceStart, 200);
                    _modelLocator.sliceMovieDuration = this.sliceEnd - this.sliceStart;
                }
                else if (_modelLocator.paramVO.hotmapData.points != null)
                {
                    this._dispatcher.addEventListener(HotDot.EVENT_SEEK_VIDEO, this.onHotDotSeek);
                    addHotDot(this.totalTime);
                }
            }
            this._isGetMetaData = true;
            this._isPlaying = true;
            this._movieWidth = param1.width;
            this._movieHeight = param1.height;
            this.setOffSets(1);
            this.setOringinSize();
            this.rotationSetter = new DynamicRegistration(videoBaseContainer, new Point(this.videoWidth / 2, this.videoHeight / 2));
            this.setStatus();
            if (BeforePlayerADMoudle.isPlayingAd)
            {
                if (!this.isPause)
                {
                    _dispatcher.addEventListener(VideoPlayEvent.EVENT_PREDOWNLOAD_OVER, this.onPreLoadOver);
                    this.pause();
                }
            }
            if (targetADModule == null)
            {
                startTargetAD(_modelLocator.currentFile, this.video.x, this.video.y);
            }
            return;
        }// end function

        private function setOffSets(param1:int) : void
        {
            var _loc_2:ChapterVO = null;
            var _loc_3:ChapterVO = null;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Boolean = false;
            if (this.isHighRate == 0)
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters[this.urlListIndex];
                if (_modelLocator.currentVideoInfo.chapters.length > (this.urlListIndex + 1))
                {
                    _loc_3 = _modelLocator.currentVideoInfo.chapters[(this.urlListIndex + 1)];
                }
            }
            else if (this.isHighRate == 1)
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2];
                if (_modelLocator.currentVideoInfo.chapters2.length > (this.urlListIndex2 + 1))
                {
                    _loc_3 = _modelLocator.currentVideoInfo.chapters2[(this.urlListIndex2 + 1)];
                }
            }
            else if (this.isHighRate == 2)
            {
                _loc_2 = _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3];
                if (_modelLocator.currentVideoInfo.lowChapters.length > (this.urlListIndex3 + 1))
                {
                    _loc_3 = _modelLocator.currentVideoInfo.lowChapters[(this.urlListIndex3 + 1)];
                }
            }
            if (_loc_2 != null)
            {
                _loc_5 = 0;
                _loc_6 = false;
                if (param1 == 1)
                {
                    _loc_4 = _loc_2.duration - int(this.localData1.duration);
                }
                else
                {
                    _loc_4 = _loc_2.duration - int(this.localData2.duration);
                    if (_loc_3 != null && Math.abs(this.localData2.duration - _loc_3.duration) <= 0.9)
                    {
                        _loc_6 = true;
                    }
                }
                if (!_loc_6 && (this.urlListIndex != 0 && this.urlListIndex2 != 0))
                {
                    this.my_position = this.global_baseTime + _loc_4;
                    if (_modelLocator.paramVO.isSlicedByHotDot && this.sliceStart != 0 && this.my_position != this.sliceStart && !this.reSetStart)
                    {
                        this.reSetStart = true;
                        this.sliceStart = this.my_position;
                        _modelLocator.paramVO.sliceStartTime = this.sliceStart;
                        _modelLocator.sliceMovieDuration = this.sliceEnd - this.sliceStart;
                    }
                }
            }
            return;
        }// end function

        private function onPreLoadOver(event:VideoPlayEvent) : void
        {
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_PREDOWNLOAD_OVER, this.onPreLoadOver);
            this.doRealPlay();
            _modelLocator.isMute = false;
            this.setVolume(_modelLocator.volumeValue);
            if (this.ns != null)
            {
                this._isPause = false;
                this.ns.seek(0);
                this.ns.resume();
                createSession(HTTP_VIDEO_SERVER_NAME, _modelLocator.currentVideoInfo.title);
                startAConvivaMonitor(this.ns, HTTP_VIDEO_SERVER_NAME);
                startTimeTimer();
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_ADPLAY_OVER));
            }
            return;
        }// end function

        private function onChangeVideo(event:CommonEvent) : void
        {
            return;
        }// end function

        private function onNbaSeek(event:CommonEvent) : void
        {
            this.seek(Number(event["data"]) / this.totalTime);
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
            this.seek(Number(event["data"]) / this.totalTime);
            return;
        }// end function

        private function doMatchStart() : void
        {
            if (_modelLocator.matchStartime > 0)
            {
                this.currentTime = _modelLocator.matchStartime;
            }
            return;
        }// end function

        private function doSliceStart() : void
        {
            this.currentTime = this.sliceStart;
            return;
        }// end function

        private function doDoDefaultSeek(event:TimerEvent) : void
        {
            this.currentTime = this.defaultStartTime;
            return;
        }// end function

        private function onNewChapterMate(param1:Object) : void
        {
            return;
        }// end function

        public function onMetaData2(param1:Object) : void
        {
            this.localData2 = param1;
            this.nowLocalData = param1;
            afterSeek();
            if (this.localData1.seekpoints)
            {
                this.keyframes = this.convertSeekpoints(this.localData1.seekpoints);
            }
            if (!this._isGetMetaData)
            {
                if (this.firstUse)
                {
                    this.firstUse = false;
                    this.nowLocalData = this.localData2;
                }
                this.resetTotal();
            }
            this._isGetMetaData = true;
            this._isPlaying = true;
            this._movieWidth = param1.width;
            this._movieHeight = param1.height;
            this.setOffSets(2);
            this.setVideoSize2();
            this.setStatus();
            return;
        }// end function

        private function convertSeekpoints(param1:Object) : Object
        {
            var _loc_3:String = null;
            var _loc_2:* = new Object();
            _loc_2.times = new Array();
            _loc_2.filepositions = new Array();
            for (_loc_3 in param1)
            {
                
                _loc_2.times[_loc_3] = Number(param1[_loc_3]["time"]);
                _loc_2.filepositions[_loc_3] = Number(param1[_loc_3]["offset"]);
            }
            return _loc_2;
        }// end function

        private function resetTotal() : void
        {
            this.bufferNextSuccess = true;
            var _loc_1:* = this._totalTime;
            this._totalTime = 0;
            if (_modelLocator.currentVideoInfo.isCopyOfVod)
            {
                if (this.nowLocalData != null && !this.setCopyOfVod)
                {
                    this._totalTime = this.nowLocalData.duration;
                    _modelLocator.movieDuration = this._totalTime;
                    this.setCopyOfVod = true;
                }
                else
                {
                    this._totalTime = _loc_1;
                    _modelLocator.movieDuration = this._totalTime;
                }
            }
            else if (_modelLocator.currentVideoInfo.length != 0)
            {
                this._totalTime = _modelLocator.currentVideoInfo.length;
            }
            else if (this.nowLocalData != null)
            {
                this._totalTime = this.nowLocalData.duration;
                _modelLocator.movieDuration = this._totalTime;
                _modelLocator.currentVideoInfo.isCopyOfVod = false;
            }
            else
            {
                this._totalTime = _loc_1;
                _modelLocator.movieDuration = this._totalTime;
            }
            this._totalHour = this._totalTime / 3600;
            this._totalMinute = this._totalTime % 3600 / 60;
            this._totalSecond = this._totalTime % 3600 % 60;
            return;
        }// end function

        override public function pause() : void
        {
            if (this.ns != null)
            {
                this.ns.pause();
                this._isPause = true;
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PAUSE));
            }
            return;
        }// end function

        override public function play() : void
        {
            this.doRealPlay();
            return;
        }// end function

        private function doRealPlay() : void
        {
            bufferTimeLength = getTimer();
            if (!this._isPlaying)
            {
                this.netCon.connect(null);
            }
            else if (this.ns != null)
            {
                this._isPause = false;
                this.ns.resume();
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
            }
            return;
        }// end function

        public function stop() : void
        {
            this.ns.close();
            this._isPlaying = false;
            return;
        }// end function

        public function close() : void
        {
            this.ns.close();
            this.netCon.close();
            this.netStream = null;
            this.netCon = null;
            return;
        }// end function

        override public function muteOn() : void
        {
            this.tempSound.volume = 0;
            this.ns.soundTransform = this.tempSound;
            this._isSoundOn = false;
            return;
        }// end function

        override public function muteOff() : void
        {
            this.tempSound.volume = this._volume;
            this.ns.soundTransform = this.tempSound;
            this._isSoundOn = true;
            return;
        }// end function

        override public function setVolume(param1:Number) : void
        {
            var _loc_2:SoundTransform = null;
            super.setVolume(param1);
            if (this._isSoundOn)
            {
                _loc_2 = new SoundTransform();
                _loc_2.volume = param1;
                this.ns.soundTransform = _loc_2;
            }
            this._volume = param1;
            return;
        }// end function

        private function setCurrentTime() : void
        {
            var _loc_1:ChapterVO = null;
            var _loc_2:Boolean = false;
            if (this.isHighRate == 1)
            {
                _loc_1 = _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2] as ChapterVO;
                if (_modelLocator.currentVideoInfo.chapters2.length == 1)
                {
                    _loc_2 = true;
                }
            }
            else if (this.isHighRate == 0)
            {
                _loc_1 = _modelLocator.currentVideoInfo.chapters[this.urlListIndex] as ChapterVO;
                if (_modelLocator.currentVideoInfo.chapters.length == 1)
                {
                    _loc_2 = true;
                }
            }
            else if (this.isHighRate == 2)
            {
                _loc_1 = _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3] as ChapterVO;
                if (_modelLocator.currentVideoInfo.lowChapters.length == 1)
                {
                    _loc_2 = true;
                }
            }
            if (_loc_1 != null)
            {
                if (_loc_1.loaded || _loc_2)
                {
                    this._currentTime = this.ns.time + _loc_1.chapterStart + this.global_baseTime;
                }
                else
                {
                    this._currentTime = this.ns.time + this.global_baseTime;
                }
            }
            else
            {
                this._currentTime = this.ns.time + this.my_position;
            }
            this._currentHour = this._currentTime / 3600;
            this._currentMinute = this._currentHour * 60 + this._currentTime % 3600 / 60;
            this._currentSecond = this._currentTime % 3600 % 60;
            return;
        }// end function

        private function timeFormat(param1:int) : String
        {
            if (param1 < 10)
            {
                return "0" + param1;
            }
            return param1.toString(10);
        }// end function

        public function getCurrentTimeString() : String
        {
            var _loc_1:String = null;
            this.setCurrentTime();
            if (this._currentHour > 0)
            {
                _loc_1 = this.timeFormat(this._currentMinute) + ":" + this.timeFormat(this._currentSecond);
            }
            else
            {
                _loc_1 = this.timeFormat(this._currentMinute) + ":" + this.timeFormat(this._currentSecond);
            }
            return _loc_1;
        }// end function

        public function getTotalTimeString() : String
        {
            var _loc_1:String = null;
            if (this._totalHour > 0)
            {
                _loc_1 = this.timeFormat(this._totalMinute) + ":" + this.timeFormat(this._totalSecond);
            }
            else
            {
                _loc_1 = this.timeFormat(this._totalMinute) + ":" + this.timeFormat(this._totalSecond);
            }
            return _loc_1;
        }// end function

        public function get totalTime() : Number
        {
            return this._totalTime;
        }// end function

        public function get currentTime() : Number
        {
            this.setCurrentTime();
            return this._currentTime;
        }// end function

        protected function getOffset(param1:Number, param2:Boolean = false) : Number
        {
            if (!this.keyframes || param1 < 0)
            {
                return 0;
            }
            var _loc_3:Number = 0;
            while (_loc_3 < (this.keyframes.times.length - 1))
            {
                
                if (this.keyframes.times[_loc_3] <= param1 && this.keyframes.times[(_loc_3 + 1)] >= param1)
                {
                    break;
                }
                _loc_3 = _loc_3 + 1;
            }
            if (param2 == true)
            {
                return this.keyframes.times[_loc_3];
            }
            return this.keyframes.filepositions[_loc_3];
        }// end function

        public function toChapter(param1:int, param2:Number = 0) : void
        {
            var cvo:ChapterVO;
            var chapterIndex:* = param1;
            var startTime:* = param2;
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_BUFFER_READY, null));
            startSeek();
            this.firstUse = true;
            this._isGetMetaData = false;
            this.isCanFuffer = true;
            this.isCanFufferNext = true;
            this.isInPlaying = false;
            this.currentChapterBaseTime = int(startTime);
            if (this.isHighRate == 1)
            {
                if (chapterIndex == (this.urlListIndex2 + 1))
                {
                    this.dealLastBufferCVO(true);
                }
                else
                {
                    this.dealLastBufferCVO();
                }
                this.urlListIndex2 = chapterIndex;
                _modelLocator.currentVideoClipIndex = this.urlListIndex2;
            }
            else if (this.isHighRate == 0)
            {
                if (chapterIndex == (this.urlListIndex + 1))
                {
                    this.dealLastBufferCVO(true);
                }
                else
                {
                    this.dealLastBufferCVO(false);
                }
                this.urlListIndex = chapterIndex;
                _modelLocator.currentVideoClipIndex = this.urlListIndex;
            }
            else if (this.isHighRate == 2)
            {
                if (chapterIndex == (this.urlListIndex3 + 1))
                {
                    this.dealLastBufferCVO(true);
                }
                else
                {
                    this.dealLastBufferCVO(false);
                }
                this.urlListIndex3 = chapterIndex;
                _modelLocator.currentVideoClipIndex = this.urlListIndex3;
            }
            var segment:Number;
            if (this.isHighRate == 1)
            {
                cvo = ChapterVO(_modelLocator.currentVideoInfo.chapters2[this.urlListIndex2]);
            }
            else if (this.isHighRate == 0)
            {
                cvo = ChapterVO(_modelLocator.currentVideoInfo.chapters[this.urlListIndex]);
            }
            else if (this.isHighRate == 2)
            {
                cvo = ChapterVO(_modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3]);
            }
            cvo.loaded = true;
            var url:* = cvo.url;
            url = url + ("?start=" + int(startTime));
            this.localStartTime = int(startTime);
            _modelLocator.currentFile = url;
            if (cvo.ns != null && cvo.chapterStart != -1 && cvo.chapterStart <= startTime && cvo.isLoadComp)
            {
                this.nowLocalData = cvo.localData;
                this.ns = cvo.ns;
                if (this.video != null && videoBaseContainer.contains(this.video))
                {
                    videoBaseContainer.removeChild(this.video);
                }
                this.video = cvo.video;
                this.nowLocalData = cvo.localData;
                videoBaseContainer.addChild(this.video);
                this.ns.resume();
                this.ns.seek(startTime - cvo.chapterStart);
                setTimeout(function () : void
            {
                videoBaseContainer.addChild(video);
                if (cornerADPlayer != null)
                {
                    addChild(cornerADPlayer);
                }
                return;
            }// end function
            , 250);
                this.sendSeekPackage(1);
            }
            else
            {
                if (cvo.ns == null || cvo.video == null)
                {
                    this.addNewStream(cvo);
                }
                this.sendSeekPackage(3);
                if (cvo.cacheStart >= 0 && cvo.cacheStart <= startTime && cvo.isCacheComp && _modelLocator.paramVO.isUseCatche)
                {
                    if (cvo.cacheStart == 0)
                    {
                        url = cvo.url;
                    }
                    else
                    {
                        url = cvo.url + "?start=" + int(cvo.cacheStart);
                    }
                    cvo.isUseingCatch = true;
                    cvo.seekingTime = startTime;
                }
                this.ns = cvo.ns;
                if (this.video != null && videoBaseContainer.contains(this.video))
                {
                    videoBaseContainer.removeChild(this.video);
                }
                this.video = cvo.video;
                videoBaseContainer.addChild(this.video);
                this.ns.play(url);
                cvo.chapterStart = startTime;
                cvo.isLoadComp = false;
            }
            if (_modelLocator.isConviva && enableConviva)
            {
                this._dispatcher.dispatchEvent(new CommonEvent(ConvivaMonitor.EVENT_UPDATE_STREAM, this.ns));
            }
            updateTargetUrl(_modelLocator.currentFile, this.global_baseTime);
            if (cornerADPlayer != null)
            {
                this.addChild(cornerADPlayer);
            }
            this.global_baseTime = this.getCurrentChapterBaseTime();
            if (this._isPause)
            {
                this.pause();
            }
            if (cornerADPlayer != null)
            {
                this.addChild(cornerADPlayer);
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

        private function getClickChapterIndex(param1:Number) : int
        {
            var _loc_2:int = 0;
            var _loc_5:ChapterVO = null;
            _loc_2 = 0;
            var _loc_3:Number = 0;
            var _loc_4:int = 0;
            if (this.isHighRate == 1)
            {
                while (_loc_2 < _modelLocator.currentVideoInfo.chapters2.length)
                {
                    
                    _loc_5 = _modelLocator.currentVideoInfo.chapters2[_loc_2] as ChapterVO;
                    if (_loc_3 < param1)
                    {
                        _loc_3 = _loc_3 + _loc_5.duration;
                        _loc_4 = _loc_2;
                    }
                    else
                    {
                        break;
                    }
                    _loc_2++;
                }
            }
            else if (this.isHighRate == 0)
            {
                while (_loc_2 < _modelLocator.currentVideoInfo.chapters.length)
                {
                    
                    _loc_5 = _modelLocator.currentVideoInfo.chapters[_loc_2] as ChapterVO;
                    if (_loc_3 < param1)
                    {
                        _loc_3 = _loc_3 + _loc_5.duration;
                        _loc_4 = _loc_2;
                    }
                    else
                    {
                        break;
                    }
                    _loc_2++;
                }
            }
            else if (this.isHighRate == 2)
            {
                while (_loc_2 < _modelLocator.currentVideoInfo.lowChapters.length)
                {
                    
                    _loc_5 = _modelLocator.currentVideoInfo.lowChapters[_loc_2] as ChapterVO;
                    if (_loc_3 < param1)
                    {
                        _loc_3 = _loc_3 + _loc_5.duration;
                        _loc_4 = _loc_2;
                    }
                    else
                    {
                        break;
                    }
                    _loc_2++;
                }
            }
            return _loc_4;
        }// end function

        public function set currentTime(param1:Number) : void
        {
            this.doRealSeek(param1);
            return;
        }// end function

        private function doRealSeek(param1:Number) : void
        {
            var _loc_3:Number = NaN;
            clearTimeout(this.timeOuter);
            isCanCheckBuffer = false;
            var _loc_6:String = this;
            var _loc_7:* = this.seekTimes + 1;
            _loc_6.seekTimes = _loc_7;
            if (param1 < 0)
            {
                return;
            }
            if (param1 >= this.totalTime)
            {
                param1 = this.totalTime - 10;
                return;
            }
            if (!this.isHotDotSeek)
            {
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_SEEK, param1 / this.totalTime));
            }
            this.isHotDotSeek = false;
            this.currentChapterBaseTime = 0;
            var _loc_2:* = this.getClickChapterIndex(param1);
            var _loc_4:* = this.urlListIndex;
            if (this.isHighRate == 1)
            {
                _loc_4 = this.urlListIndex2;
            }
            else if (this.isHighRate == 2)
            {
                _loc_4 = this.urlListIndex3;
            }
            if (_loc_2 == _loc_4)
            {
                this.dealLastCVO(true, _loc_2 == 0);
            }
            else
            {
                this.dealLastCVO(false, _loc_2 == 0);
            }
            if (_loc_2 == _loc_4)
            {
                _loc_3 = this.getCurrentChapterBaseTime();
            }
            else
            {
                _loc_3 = this.getCurrentChapterBaseTime(_loc_2);
            }
            var _loc_5:* = this.getOffset(this.pos);
            this.global_baseTime = this.getCurrentChapterBaseTime();
            if (this.isHighRate == 0)
            {
                if (_modelLocator.currentVideoInfo.chapters.length != 0)
                {
                    if (_loc_2 == this.urlListIndex)
                    {
                        this.my_position = this.global_baseTime + _modelLocator.currentVideoInfo.chapters[this.urlListIndex].chapterStart;
                        this.pos = param1 - this.my_position;
                        if (param1 > this.my_position && param1 < this.loadedPercent * this.totalTime)
                        {
                            this.isStreamed = false;
                            this.ns.seek(this.pos);
                            this.ns.resume();
                            if (this._isPause)
                            {
                                this.pause();
                            }
                            this.sendSeekPackage(0);
                        }
                        else
                        {
                            this.isStreamed = true;
                            this.my_position = param1;
                            this.ns.pause();
                            this.toChapter(this.urlListIndex, param1 - _loc_3);
                        }
                    }
                    else
                    {
                        this.isStreamed = true;
                        this.my_position = param1;
                        this.ns.pause();
                        this.toChapter(_loc_2, param1 - _loc_3);
                    }
                }
                else if (param1 >= this.my_position && param1 <= this.loadedPercent * this.totalTime)
                {
                    this.isStreamed = false;
                    this.ns.seek(param1);
                    this.sendSeekPackage(0);
                }
            }
            else if (this.isHighRate == 1)
            {
                if (_modelLocator.currentVideoInfo.chapters2.length != 0)
                {
                    if (_loc_2 == this.urlListIndex2)
                    {
                        this.my_position = this.global_baseTime + _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2].chapterStart;
                        this.pos = param1 - this.my_position;
                        if (param1 > this.my_position && param1 < this.loadedPercent * this.totalTime)
                        {
                            this.isStreamed = false;
                            this.ns.seek(this.pos);
                            this.ns.resume();
                            if (this._isPause)
                            {
                                this.pause();
                            }
                            this.sendSeekPackage(0);
                        }
                        else
                        {
                            this.my_offset = this.getOffset(param1 - _loc_3, true);
                            this.my_byteoffset = _loc_5;
                            this.isStreamed = true;
                            this.my_position = param1;
                            this.ns.pause();
                            this.toChapter(this.urlListIndex2, param1 - _loc_3);
                        }
                    }
                    else
                    {
                        this.isStreamed = true;
                        this.my_position = param1;
                        this.ns.pause();
                        this.toChapter(_loc_2, param1 - _loc_3);
                    }
                }
                else if (param1 >= this.my_position && param1 <= this.loadedPercent * this.totalTime)
                {
                    this.isStreamed = false;
                    this.ns.seek(param1);
                    this.sendSeekPackage(0);
                    if (this._isPause)
                    {
                        this.pause();
                    }
                }
            }
            else if (this.isHighRate == 2)
            {
                if (_modelLocator.currentVideoInfo.lowChapters.length != 0)
                {
                    if (_loc_2 == this.urlListIndex3)
                    {
                        this.my_position = this.global_baseTime + _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3].chapterStart;
                        this.pos = param1 - this.my_position;
                        if (param1 > this.my_position && param1 < this.loadedPercent * this.totalTime)
                        {
                            this.isStreamed = false;
                            this.ns.seek(this.pos);
                            this.ns.resume();
                            if (this._isPause)
                            {
                                this.pause();
                            }
                            this.sendSeekPackage(0);
                        }
                        else
                        {
                            this.my_offset = this.getOffset(param1 - _loc_3, true);
                            this.my_byteoffset = _loc_5;
                            this.isStreamed = true;
                            this.my_position = param1;
                            this.ns.pause();
                            this.toChapter(this.urlListIndex3, param1 - _loc_3);
                        }
                    }
                    else
                    {
                        this.isStreamed = true;
                        this.my_position = param1;
                        this.ns.pause();
                        this.toChapter(_loc_2, param1 - _loc_3);
                    }
                }
                else if (param1 >= this.my_position && param1 <= this.loadedPercent * this.totalTime)
                {
                    this.isStreamed = false;
                    this.ns.seek(param1);
                    this.sendSeekPackage(0);
                    if (this._isPause)
                    {
                        this.pause();
                    }
                }
            }
            this.checkMemory();
            return;
        }// end function

        private function sendSeekPackage(param1:Number) : void
        {
            var _loc_2:Array = [];
            var _loc_3:* = new ValueOBJ("t", "seekcode");
            _loc_2.push(_loc_3);
            _loc_3 = new ValueOBJ("v", String(param1));
            _loc_2.push(_loc_3);
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_SEEK_CODE, _loc_2));
            return;
        }// end function

        private function releaseCharpterVO(param1:ChapterVO) : void
        {
            if (param1 != null && param1.ns != null)
            {
                param1.ns.removeEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
                param1.ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                param1.ns.close();
                param1.video.clear();
                param1.ns = null;
                if (this.videoBaseContainer.contains(param1.video))
                {
                    this.videoBaseContainer.removeChild(param1.video);
                }
                param1.video = null;
                param1.isLoadComp = false;
                param1.chapterStart = -1;
                MemClean.run();
            }
            return;
        }// end function

        private function releaseMemory(param1:Number) : void
        {
            var _loc_2:ChapterVO = null;
            var _loc_3:Array = null;
            var _loc_6:Number = NaN;
            var _loc_4:Boolean = false;
            var _loc_5:Number = 0;
            var _loc_7:* = param1;
            if (this.isHighRate == 1)
            {
                _loc_3 = _modelLocator.currentVideoInfo.chapters2;
                _loc_6 = this.urlListIndex2;
            }
            else if (this.isHighRate == 0)
            {
                _loc_3 = _modelLocator.currentVideoInfo.chapters;
                _loc_6 = this.urlListIndex;
            }
            else if (this.isHighRate == 2)
            {
                _loc_3 = _modelLocator.currentVideoInfo.lowChapters;
                _loc_6 = this.urlListIndex3;
            }
            _loc_5 = 0;
            while (_loc_5 < _loc_6)
            {
                
                _loc_2 = _loc_3[_loc_5];
                if (_loc_2.chapterStart >= 0 && _loc_2.ns != null && _loc_2.isLoadComp)
                {
                    _loc_7 = _loc_7 - int(_loc_2.ns.bytesTotal / 1048576);
                    this.releaseCharpterVO(_loc_2);
                    if (_loc_7 <= _modelLocator.paramVO.maxMemoryUse)
                    {
                        return;
                    }
                }
                _loc_5 = _loc_5 + 1;
            }
            _loc_5 = _loc_3.length - 1;
            while (_loc_5 > (_loc_6 + 1))
            {
                
                _loc_2 = _loc_3[_loc_5];
                if (_loc_2.chapterStart >= 0 && _loc_2.ns != null && _loc_2.isLoadComp)
                {
                    _loc_7 = _loc_7 - int(_loc_2.ns.bytesTotal / 1048576);
                    this.releaseCharpterVO(_loc_2);
                    if (_loc_7 <= _modelLocator.paramVO.maxMemoryUse)
                    {
                        return;
                    }
                }
                _loc_5 = _loc_5 - 1;
            }
            return;
        }// end function

        private function dealLastBufferCVO(param1:Boolean = false) : void
        {
            var _loc_2:ChapterVO = null;
            if (this.isHighRate == 1)
            {
                if ((this.urlListIndex2 + 1) < _modelLocator.currentVideoInfo.chapters2.length)
                {
                    _loc_2 = _modelLocator.currentVideoInfo.chapters2[(this.urlListIndex2 + 1)];
                }
            }
            else if (this.isHighRate == 0)
            {
                if ((this.urlListIndex + 1) < _modelLocator.currentVideoInfo.chapters.length)
                {
                    _loc_2 = _modelLocator.currentVideoInfo.chapters[(this.urlListIndex + 1)];
                }
            }
            else if (this.isHighRate == 2)
            {
                if ((this.urlListIndex + 1) < _modelLocator.currentVideoInfo.lowChapters.length)
                {
                    _loc_2 = _modelLocator.currentVideoInfo.lowChapters[(this.urlListIndex3 + 1)];
                }
            }
            if (_loc_2 != null && _loc_2.ns != null)
            {
                if (_loc_2.ns.bytesLoaded >= _loc_2.ns.bytesTotal && _loc_2.ns.bytesLoaded > 0)
                {
                    if (_loc_2.cacheStart >= _loc_2.chapterStart && _loc_2.chapterStart >= 0 || _loc_2.cacheStart == -1)
                    {
                        _loc_2.cacheStart = _loc_2.chapterStart;
                    }
                    _loc_2.ns.pause();
                    _loc_2.isLoadComp = true;
                    _loc_2.isCacheComp = true;
                }
                else if (!param1)
                {
                    this.releaseCharpterVO(_loc_2);
                }
            }
            return;
        }// end function

        private function onNoticeChangeRateClicked(event:StatuBoxEvent) : void
        {
            if (_modelLocator.currentHttpBiteRateMode == 0)
            {
                this.changeStreamRate(2);
                _modelLocator.currentVideoInfo.vddStreamRate = "LD";
            }
            else if (_modelLocator.currentHttpBiteRateMode == 1)
            {
                this.changeStreamRate(0);
                _modelLocator.currentVideoInfo.vddStreamRate = "STD";
            }
            return;
        }// end function

        private function getCurrentMemoryStatus() : Number
        {
            var _loc_1:ChapterVO = null;
            var _loc_2:Array = null;
            var _loc_3:Number = 0;
            if (this.isHighRate == 1)
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters2;
            }
            else if (this.isHighRate == 0)
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters;
            }
            else if (this.isHighRate == 2)
            {
                _loc_2 = _modelLocator.currentVideoInfo.lowChapters;
            }
            var _loc_4:Number = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_1 = _loc_2[_loc_4];
                if (_loc_1.chapterStart >= 0 && _loc_1.isLoadComp && _loc_1.ns != null)
                {
                    _loc_3 = _loc_3 + int(_loc_1.ns.bytesTotal / 1048576);
                }
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        private function checkMemory() : void
        {
            var _loc_1:* = this.getCurrentMemoryStatus();
            if (_loc_1 > _modelLocator.paramVO.maxMemoryUse)
            {
                this.releaseMemory(_loc_1);
            }
            MemClean.run();
            return;
        }// end function

        private function dealLastCVO(param1:Boolean = false, param2:Boolean = false) : void
        {
            var _loc_3:ChapterVO = null;
            var _loc_4:Number = NaN;
            if (this.isHighRate == 1)
            {
                _loc_3 = _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2];
                _loc_4 = _modelLocator.currentVideoInfo.chapters2.length;
            }
            else if (this.isHighRate == 0)
            {
                _loc_3 = _modelLocator.currentVideoInfo.chapters[this.urlListIndex];
                _loc_4 = _modelLocator.currentVideoInfo.chapters.length;
            }
            else if (this.isHighRate == 2)
            {
                _loc_3 = _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3];
                _loc_4 = _modelLocator.currentVideoInfo.lowChapters.length;
            }
            if (_loc_3 == null)
            {
                return;
            }
            if (_loc_3.ns.bytesLoaded >= _loc_3.ns.bytesTotal && _loc_3.ns.bytesLoaded > 0)
            {
                if (_loc_3.cacheStart > _loc_3.chapterStart && _loc_3.chapterStart != -1 || _loc_3.cacheStart == -1)
                {
                    _loc_3.cacheStart = _loc_3.chapterStart;
                }
                _loc_3.isLoadComp = true;
                _loc_3.ns.pause();
                _loc_3.isCacheComp = true;
            }
            else if (!param1)
            {
                this.releaseCharpterVO(_loc_3);
            }
            MemClean.run();
            if (this.checkMemoTimer == null && _loc_4 > 2)
            {
                this.checkMemoTimer = new Timer(60000);
                this.checkMemoTimer.addEventListener(TimerEvent.TIMER, this.onCheckMemory);
                this.checkMemoTimer.start();
            }
            return;
        }// end function

        private function onCheckMemory(event:TimerEvent) : void
        {
            var _loc_3:Array = null;
            var _loc_7:Number = NaN;
            var _loc_8:Boolean = false;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Object = null;
            var _loc_12:Array = null;
            var _loc_13:ValueOBJ = null;
            var _loc_14:StatusVO = null;
            var _loc_2:* = ShareObjecter.getObject(_modelLocator.localDataObjectName, _modelLocator.localDataPath);
            var _loc_4:* = Date.parse(new Date().toString());
            var _loc_5:* = this.getCurrentMemoryStatus();
            var _loc_6:Object = {playerName:this.memoryCookieName, size:_loc_5, time:_loc_4};
            if (_loc_2 != null)
            {
                if (_loc_2["data"]["memoCookie"] != null)
                {
                    _loc_7 = 0;
                    _loc_3 = _loc_2["data"]["memoCookie"] as Array;
                    if (_loc_3 != null)
                    {
                        _loc_10 = 0;
                        while (_loc_10 < _loc_3.length)
                        {
                            
                            if (Number(_loc_4 - Number(_loc_3[_loc_10].time)) > 70000)
                            {
                                _loc_11 = _loc_3[(_loc_3.length - 1)];
                                _loc_3[(_loc_3.length - 1)] = _loc_3[_loc_10];
                                _loc_3[_loc_10] = _loc_11;
                                _loc_3.pop();
                            }
                            _loc_10 = _loc_10 + 1;
                        }
                        _loc_10 = 0;
                        while (_loc_10 < _loc_3.length)
                        {
                            
                            _loc_7 = _loc_7 + Number(_loc_3[_loc_10].size);
                            _loc_10 = _loc_10 + 1;
                        }
                    }
                    if (_loc_7 > _modelLocator.paramVO.maxPageMemoryUse && this.memoFullTip != "")
                    {
                        _loc_12 = [];
                        _loc_13 = new ValueOBJ("t", "memofull");
                        _loc_12.push(_loc_13);
                        _loc_13 = new ValueOBJ("v", QualityMonitorEvent.EVENT_MEMORY_FULL);
                        _loc_12.push(_loc_13);
                        _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_MEMORY_FULL, _loc_12));
                        _loc_14 = new StatusVO(this.memoFullTip, StatuBoxEvent.TYPE_CENTER, true);
                        _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_NOTICE_MESSAGE, _loc_14));
                        this.memoFullTip = "";
                    }
                    _loc_8 = false;
                    _loc_9 = 0;
                    while (_loc_9 < _loc_3.length)
                    {
                        
                        if (_loc_3[_loc_9].playerName == this.memoryCookieName)
                        {
                            _loc_3[_loc_9].size = _loc_5;
                            _loc_3[_loc_9].time = _loc_4;
                            _loc_8 = true;
                        }
                        _loc_9 = _loc_9 + 1;
                    }
                    if (!_loc_8)
                    {
                        _loc_3.push(_loc_6);
                    }
                    _loc_2["data"]["memoCookie"] = _loc_3;
                    ShareObjecter.setObject(_loc_2);
                }
                else
                {
                    _loc_2["data"]["memoCookie"] = [_loc_6];
                    ShareObjecter.setObject(_loc_2);
                }
            }
            return;
        }// end function

        public function get totalHour() : int
        {
            return this._totalHour;
        }// end function

        public function get totalMinute() : int
        {
            return this._totalMinute;
        }// end function

        public function get totalSecond() : int
        {
            return this._totalSecond;
        }// end function

        public function get currentHour() : int
        {
            this.setCurrentTime();
            return this._currentHour;
        }// end function

        public function get currentMinute() : int
        {
            this.setCurrentTime();
            return this._currentMinute;
        }// end function

        public function get currentSecond() : int
        {
            this.setCurrentTime();
            return this._currentSecond;
        }// end function

        public function get isPlaning() : Boolean
        {
            return this._isPlaying;
        }// end function

        public function get isPause() : Boolean
        {
            return this._isPause;
        }// end function

        public function set isPause(param1:Boolean) : void
        {
            this._isPause = param1;
            return;
        }// end function

        public function get bytesTotal() : uint
        {
            return this.ns.bytesTotal;
        }// end function

        public function get loadedPercent() : Number
        {
            return this.getCurrentChapterLoad();
        }// end function

        public function get loaded() : Number
        {
            return this.getCurrentChapterLoad();
        }// end function

        public function get bufferPercent() : int
        {
            var _loc_1:int = 0;
            if (this.isCanFuffer)
            {
                _loc_1 = this.ns.bufferLength / BUFFER_TIME * 100;
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

        public function get isSoundOn() : Boolean
        {
            return this._isSoundOn;
        }// end function

        public function get isGetMetaData() : Boolean
        {
            return this._isGetMetaData;
        }// end function

        public function get movieWidth() : Number
        {
            return this._movieWidth;
        }// end function

        public function get movieHeight() : Number
        {
            return this._movieHeight;
        }// end function

        private function getCurrentChapterBaseTime(param1:int = -1) : Number
        {
            var _loc_3:int = 0;
            var _loc_5:ChapterVO = null;
            var _loc_2:int = 0;
            if (param1 != -1)
            {
                _loc_2 = param1;
            }
            else if (this.isHighRate == 1)
            {
                _loc_2 = this.urlListIndex2;
            }
            else if (this.isHighRate == 2)
            {
                _loc_2 = this.urlListIndex3;
            }
            else
            {
                _loc_2 = this.urlListIndex;
            }
            _loc_3 = 0;
            var _loc_4:Number = 0;
            if (this.isHighRate == 1)
            {
                while (_loc_3 < _modelLocator.currentVideoInfo.chapters2.length)
                {
                    
                    _loc_5 = _modelLocator.currentVideoInfo.chapters2[_loc_3] as ChapterVO;
                    if (_loc_3 < _loc_2)
                    {
                        _loc_4 = _loc_4 + _loc_5.duration;
                    }
                    else
                    {
                        break;
                    }
                    _loc_3++;
                }
            }
            else if (this.isHighRate == 2)
            {
                while (_loc_3 < _modelLocator.currentVideoInfo.lowChapters.length)
                {
                    
                    _loc_5 = _modelLocator.currentVideoInfo.lowChapters[_loc_3] as ChapterVO;
                    if (_loc_3 < _loc_2)
                    {
                        _loc_4 = _loc_4 + _loc_5.duration;
                    }
                    else
                    {
                        break;
                    }
                    _loc_3++;
                }
            }
            else
            {
                while (_loc_3 < _modelLocator.currentVideoInfo.chapters.length)
                {
                    
                    _loc_5 = _modelLocator.currentVideoInfo.chapters[_loc_3] as ChapterVO;
                    if (_loc_3 < _loc_2)
                    {
                        _loc_4 = _loc_4 + _loc_5.duration;
                    }
                    else
                    {
                        break;
                    }
                    _loc_3++;
                }
            }
            return _loc_4;
        }// end function

        private function getCurrentChapterLoad() : Number
        {
            var _loc_2:Array = null;
            var _loc_4:ChapterVO = null;
            var _loc_5:Number = NaN;
            var _loc_1:Number = 0;
            var _loc_3:Number = 0;
            if (this.isHighRate == 1)
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters2;
            }
            else if (this.isHighRate == 0)
            {
                _loc_2 = _modelLocator.currentVideoInfo.chapters;
            }
            else if (this.isHighRate == 2)
            {
                _loc_2 = _modelLocator.currentVideoInfo.lowChapters;
            }
            if (_loc_2.length != 0)
            {
                if (this.isHighRate == 1)
                {
                    _loc_4 = _loc_2[this.urlListIndex2] as ChapterVO;
                    _loc_3 = this.urlListIndex2;
                }
                else if (this.isHighRate == 0)
                {
                    _loc_4 = _loc_2[this.urlListIndex] as ChapterVO;
                    _loc_3 = this.urlListIndex;
                }
                else if (this.isHighRate == 2)
                {
                    _loc_4 = _loc_2[this.urlListIndex3] as ChapterVO;
                    _loc_3 = this.urlListIndex3;
                }
                if (_loc_4 == null)
                {
                    _loc_1 = 1;
                }
                else
                {
                    this.nowLocalData = _loc_4.localData;
                    if (this.nowLocalData != null)
                    {
                        _loc_1 = (this.global_baseTime + _loc_4.chapterStart + this.ns.bytesLoaded / this.ns.bytesTotal * this.nowLocalData.duration) / this.totalTime;
                    }
                    else
                    {
                        _loc_1 = (this.my_position + this.ns.bytesLoaded / this.ns.bytesTotal * _loc_4.duration) / this.totalTime;
                    }
                }
            }
            if (this.ns.bytesLoaded == this.ns.bytesTotal)
            {
                _loc_5 = _loc_3 + 1;
                while (_loc_5 < _loc_2.length)
                {
                    
                    if (_loc_2[_loc_5] != null && _loc_2[_loc_5].chapterStart == 0)
                    {
                        _loc_1 = _loc_1 + _loc_2[_loc_5].ns.bytesLoaded / _loc_2[_loc_5].ns.bytesTotal * _loc_2[_loc_5].duration / this.totalTime;
                        if (!_loc_2[_loc_5].isLoadComp)
                        {
                            break;
                        }
                    }
                    else
                    {
                        break;
                    }
                    _loc_5 = _loc_5 + 1;
                }
            }
            if (_loc_1 > 1)
            {
                _loc_1 = 1;
            }
            return _loc_1;
        }// end function

        public function bufferNext() : void
        {
            this.doRealBufferNext();
            return;
        }// end function

        private function doRealBufferNext() : void
        {
            var _loc_1:ChapterVO = null;
            var _loc_2:ChapterVO = null;
            var _loc_3:String = null;
            this.global_baseTime = this.getCurrentChapterBaseTime();
            this.isCanFufferNext = false;
            isCanCheckBuffer = false;
            if (this.isHighRate == 1 && (_modelLocator.currentVideoInfo.chapters2.length - 1) >= (this.urlListIndex2 + 1) || this.isHighRate == 0 && (_modelLocator.currentVideoInfo.chapters.length - 1) >= (this.urlListIndex + 1) || this.isHighRate == 2 && (_modelLocator.currentVideoInfo.lowChapters.length - 1) >= (this.urlListIndex3 + 1))
            {
                if (this.isHighRate == 1)
                {
                    _loc_1 = _modelLocator.currentVideoInfo.chapters2[(this.urlListIndex2 + 1)];
                    _loc_2 = _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2];
                }
                else if (this.isHighRate == 0)
                {
                    _loc_1 = _modelLocator.currentVideoInfo.chapters[(this.urlListIndex + 1)];
                    _loc_2 = _modelLocator.currentVideoInfo.chapters[this.urlListIndex];
                }
                else if (this.isHighRate == 2)
                {
                    _loc_1 = _modelLocator.currentVideoInfo.lowChapters[(this.urlListIndex3 + 1)];
                    _loc_2 = _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3];
                }
                if (_loc_1.video == null || _loc_1.ns == null)
                {
                    this.addNewStream(_loc_1);
                }
                _loc_3 = _loc_1.url;
                _modelLocator.currentFile = _loc_3;
                _loc_1.isLoadComp = false;
                _loc_1.chapterStart = 0;
                _loc_1.ns.play(_loc_3);
                _loc_1.ns.seek(0);
                _loc_1.ns.pause();
                _loc_2.isLoadComp = true;
                this.checkMemory();
            }
            else
            {
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_CYCLE_CHARGE_TO_HTTP));
            }
            try
            {
                System.gc();
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        override public function chargeHttp() : void
        {
            if (this.isHighRate == 1)
            {
                this.urlListIndex = 0;
                this.urlListIndex2 = -1;
                this.urlListIndex3 = -1;
            }
            else if (this.isHighRate == 0)
            {
                this.urlListIndex = -1;
                this.urlListIndex2 = 0;
                this.urlListIndex3 = 0;
            }
            else if (this.isHighRate == 2)
            {
                this.urlListIndex = -1;
                this.urlListIndex2 = -1;
                this.urlListIndex3 = 0;
            }
            _modelLocator.currentVideoClipIndex = 0;
            this.removeEventListener(Event.ENTER_FRAME, this.loop);
            this.bufferNext();
            return;
        }// end function

        public function playNext() : void
        {
            var _loc_1:ChapterVO = null;
            var _loc_2:String = null;
            if (this.timeOuter != 0)
            {
                clearTimeout(this.timeOuter);
            }
            this.timeOuter = setTimeout(this.changeToCanCheckBuffer, 10000);
            this.dealLastCVO();
            if (this.isHighRate == 1)
            {
                var _loc_3:String = this;
                var _loc_4:* = this.urlListIndex2 + 1;
                _loc_3.urlListIndex2 = _loc_4;
                _modelLocator.currentVideoClipIndex = this.urlListIndex2;
            }
            else if (this.isHighRate == 0)
            {
                var _loc_3:String = this;
                var _loc_4:* = this.urlListIndex + 1;
                _loc_3.urlListIndex = _loc_4;
                _modelLocator.currentVideoClipIndex = this.urlListIndex;
            }
            else if (this.isHighRate == 2)
            {
                var _loc_3:String = this;
                var _loc_4:* = this.urlListIndex3 + 1;
                _loc_3.urlListIndex3 = _loc_4;
                _modelLocator.currentVideoClipIndex = this.urlListIndex3;
            }
            this.checkMemory();
            if (this.isHighRate == 1 && (_modelLocator.currentVideoInfo.chapters2.length - 1) < this.urlListIndex2)
            {
                this.callPlayOver();
            }
            else if (this.isHighRate == 0 && (_modelLocator.currentVideoInfo.chapters.length - 1) < this.urlListIndex)
            {
                this.callPlayOver();
            }
            else if (this.isHighRate == 2 && (_modelLocator.currentVideoInfo.lowChapters.length - 1) < this.urlListIndex3)
            {
                this.callPlayOver();
            }
            else
            {
                if (this.isHighRate == 1)
                {
                    _loc_1 = _modelLocator.currentVideoInfo.chapters2[this.urlListIndex2];
                }
                else if (this.isHighRate == 0)
                {
                    _loc_1 = _modelLocator.currentVideoInfo.chapters[this.urlListIndex];
                }
                else if (this.isHighRate == 2)
                {
                    _loc_1 = _modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3];
                }
                this.global_baseTime = this.getCurrentChapterBaseTime();
                if (this.my_position < this.global_baseTime)
                {
                    this.my_position = this.global_baseTime;
                }
                if (this.video != null && videoBaseContainer.contains(this.video))
                {
                    videoBaseContainer.removeChild(this.video);
                }
                this.ns = null;
                if (_loc_1.video != null && _loc_1.ns != null)
                {
                    _loc_1.chapterStart = 0;
                    this.ns = _loc_1.ns;
                    if (this.bufferNextSuccess)
                    {
                        this.ns.seek(0);
                        this.ns.resume();
                    }
                    else
                    {
                        _loc_1.chapterStart = 0;
                        this.ns.close();
                        this.ns.play(_loc_1.url);
                    }
                }
                else
                {
                    if (_loc_1.video == null || _loc_1.ns == null)
                    {
                        this.addNewStream(_loc_1);
                    }
                    _loc_2 = _loc_1.url;
                    _modelLocator.currentFile = _loc_2;
                    _loc_1.chapterStart = 0;
                    _loc_1.ns.play(_loc_2);
                    this.ns = _loc_1.ns;
                }
                this.video = _loc_1.video;
                videoBaseContainer.addChild(this.video);
                this.nowLocalData = _loc_1.localData;
                if (_modelLocator.isConviva && enableConviva)
                {
                    _dispatcher.dispatchEvent(new CommonEvent(ConvivaMonitor.EVENT_UPDATE_STREAM, this.ns));
                }
                this.global_baseTime = this.getCurrentChapterBaseTime();
                this.isCanFufferNext = true;
                this.setVideoSize2();
                this.setStatus();
                switchAConvivaMonitor(this.ns, HTTP_VIDEO_SERVER_NAME);
                if (this.isSoundOn)
                {
                    this.muteOff();
                }
                else
                {
                    this.muteOn();
                }
                MemClean.run();
            }
            updateTargetUrl(_modelLocator.currentFile, this.global_baseTime);
            this.resetBufferFlag(null);
            haveAStopRequest = false;
            return;
        }// end function

        public function reset() : void
        {
            this.bufferNextSuccess = true;
            this.playConut = 0;
            this.seekTimes = 0;
            this.bufferTimes = 0;
            this.global_baseTime = 0;
            this.my_position = 0;
            this.isCanFuffer = true;
            this.isCanFufferNext = true;
            this.firstUse = true;
            this._isGetMetaData = false;
            this.nowLocalData = null;
            this.hotStarted = true;
            var _loc_1:* = _modelLocator.currentVideoInfo.chapters.length;
            if (this.isHighRate == 1 && _modelLocator.currentVideoInfo.chapters2)
            {
                _loc_1 = _modelLocator.currentVideoInfo.chapters2.length;
            }
            else if (this.isHighRate == 2 && _modelLocator.currentVideoInfo.lowChapters)
            {
                _loc_1 = _modelLocator.currentVideoInfo.lowChapters.length;
            }
            if (_modelLocator.paramVO.isHotDotNotice && this._modelLocator.paramVO.hotmapData != null && !this.hotStarted && _modelLocator.paramVO.isSlicedByHotDot)
            {
                this.currentTime = this.sliceStart;
            }
            else if (_loc_1 > 1)
            {
                this.toChapter(0);
                this.checkMemory();
            }
            else
            {
                this.seek(0);
            }
            if (this.hasEventListener(Event.ENTER_FRAME))
            {
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            this.addEventListener(Event.ENTER_FRAME, this.loop);
            if (this.ns != null)
            {
                if (!this.ns.hasEventListener(NetStatusEvent.NET_STATUS))
                {
                    this.ns.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
                }
                if (!this.ns.hasEventListener(AsyncErrorEvent.ASYNC_ERROR))
                {
                    this.ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                }
            }
            return;
        }// end function

        private function callPlayOver() : void
        {
            this.hotStarted = false;
            this.startPlayAVideo = true;
            setStatuToManager("8");
            this.removeEventListener(Event.ENTER_FRAME, this.loop);
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_SHUT_DOWN));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_MESSAGE, null));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
            stopAConvivaMonitor();
            stopHotmap();
            stopTimeTimer();
            if (ExternalInterface.available && _modelLocator.ISWEBSITE)
            {
            }
            if (_modelLocator.paramVO.isCycle)
            {
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_CYCLE_PLAY_NEXT));
            }
            else
            {
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PLAY_STOP));
            }
            return;
        }// end function

        public function get nowPlayingTime() : Number
        {
            return this.ns.time;
        }// end function

        public function get nowPlayingTotal() : Number
        {
            if (this.nowLocalData != null)
            {
                return this.nowLocalData.duration;
            }
            return 100000;
        }// end function

        override protected function adjust() : void
        {
            Tweener.removeTweens(this.video);
            super.adjust();
            if (keepOnPlayButton != null)
            {
                keepOnPlayButton.x = 25;
                keepOnPlayButton.y = stage.stageHeight - keepOnPlayButton.height - 55;
            }
            this.setVideoSize2();
            return;
        }// end function

        private function setOringinSize() : void
        {
            var _loc_3:ChapterVO = null;
            if (stage == null)
            {
                return;
            }
            var _loc_1:* = ControlBarModule.CONTROL_BAR_HEIGHT;
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                _loc_1 = 0;
            }
            var _loc_2:* = this.videoWidth / this.videoHeight;
            this.videoWidth = stage.stageWidth;
            this.videoHeight = this.videoWidth / _loc_2;
            if (this.videoHeight > stage.stageHeight - _loc_1)
            {
                this.videoHeight = stage.stageHeight - _loc_1;
                this.videoWidth = this.videoHeight * _loc_2;
            }
            this.w_videoWidth = stage.stageWidth;
            this.w_videoHeight = this.w_videoWidth * 9 / 16 - _loc_1;
            var _loc_4:Number = 0;
            if (this.isHighRate == 1)
            {
                _loc_4 = 0;
                while (_loc_4 < _modelLocator.currentVideoInfo.chapters2.length)
                {
                    
                    _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.chapters2[_loc_4]);
                    this.adjustVideoSize(_loc_3.video);
                    _loc_4 = _loc_4 + 1;
                }
            }
            else if (this.isHighRate == 0)
            {
                _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.chapters[this.urlListIndex]);
                _loc_4 = 0;
                while (_loc_4 < _modelLocator.currentVideoInfo.chapters.length)
                {
                    
                    _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.chapters[_loc_4]);
                    this.adjustVideoSize(_loc_3.video);
                    _loc_4 = _loc_4 + 1;
                }
            }
            else if (this.isHighRate == 2)
            {
                _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3]);
                _loc_4 = 0;
                while (_loc_4 < _modelLocator.currentVideoInfo.lowChapters.length)
                {
                    
                    _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.lowChapters[_loc_4]);
                    this.adjustVideoSize(_loc_3.video);
                    _loc_4 = _loc_4 + 1;
                }
            }
            updateTargetADSize(stage.stageWidth, stage.stageHeight, this.video.x, this.video.y);
            this.setLogoPos();
            if (cornerADPlayer != null)
            {
                this.addChild(cornerADPlayer);
            }
            videoContainer.x = (stage.stageWidth - videoContainer.width) / 2;
            videoContainer.y = (stage.stageHeight - _loc_1 - videoContainer.height) / 2;
            return;
        }// end function

        private function setVideoSize2() : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_1:* = ControlBarModule.CONTROL_BAR_HEIGHT;
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                _loc_1 = 0;
            }
            var _loc_2:* = OR_STAGE_WIDTH;
            var _loc_3:* = OR_STAGE_HEIGHT;
            var _loc_4:* = stage.stageWidth / _loc_2;
            if ((stage.stageHeight - _loc_1) / _loc_3 < _loc_4)
            {
                _loc_4 = (stage.stageHeight - _loc_1) / _loc_3;
            }
            var _loc_7:* = ChapterVO.vr;
            this.setAngle(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_ROTATE, 0), false);
            if (_modelLocator.videoSizeMode == 2)
            {
                _loc_5 = videoBaseContainer.width;
                _loc_6 = _loc_5 * 3 / 4;
                videoBaseContainer.width = _loc_5;
                videoBaseContainer.height = _loc_6;
                this.videoContainer.scaleX = _loc_4 * _modelLocator.videoSizeRate;
                this.videoContainer.scaleY = _loc_4 * _modelLocator.videoSizeRate;
            }
            else if (_modelLocator.videoSizeMode == 3)
            {
                _loc_5 = videoBaseContainer.width;
                _loc_6 = _loc_5 * 9 / 16;
                videoBaseContainer.width = _loc_5;
                videoBaseContainer.height = _loc_6;
                this.videoContainer.scaleX = _loc_4 * _modelLocator.videoSizeRate;
                this.videoContainer.scaleY = _loc_4 * _modelLocator.videoSizeRate;
            }
            else if (_modelLocator.videoSizeMode == 4)
            {
                videoBaseContainer.scaleX = 1;
                videoBaseContainer.scaleY = 1;
                videoContainer.width = stage.stageWidth;
                videoContainer.height = stage.stageHeight - _loc_1;
            }
            else
            {
                videoBaseContainer.scaleX = 1;
                videoBaseContainer.scaleY = 1;
                this.videoContainer.scaleX = _loc_4 * _modelLocator.videoSizeRate;
                this.videoContainer.scaleY = _loc_4 * _modelLocator.videoSizeRate;
            }
            this.setAngle(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_ROTATE, _loc_7), false);
            videoContainer.x = (stage.stageWidth - videoContainer.width) / 2;
            videoContainer.y = (stage.stageHeight - _loc_1 - videoContainer.height) / 2;
            return;
        }// end function

        private function setVideoRate() : void
        {
            return;
        }// end function

        private function setVideoSize() : void
        {
            var _loc_3:ChapterVO = null;
            if (stage == null)
            {
                return;
            }
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
            var _loc_4:Number = 0;
            if (this.isHighRate == 1)
            {
                _loc_4 = 0;
                while (_loc_4 < _modelLocator.currentVideoInfo.chapters2.length)
                {
                    
                    _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.chapters2[_loc_4]);
                    this.adjustVideoSize(_loc_3.video);
                    _loc_4 = _loc_4 + 1;
                }
            }
            else if (this.isHighRate == 0)
            {
                _loc_4 = 0;
                while (_loc_4 < _modelLocator.currentVideoInfo.chapters.length)
                {
                    
                    _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.chapters[_loc_4]);
                    this.adjustVideoSize(_loc_3.video);
                    _loc_4 = _loc_4 + 1;
                }
            }
            else if (this.isHighRate == 2)
            {
                _loc_4 = 0;
                while (_loc_4 < _modelLocator.currentVideoInfo.lowChapters.length)
                {
                    
                    _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.lowChapters[_loc_4]);
                    this.adjustVideoSize(_loc_3.video);
                    _loc_4 = _loc_4 + 1;
                }
            }
            updateTargetADSize(stage.stageWidth, stage.stageHeight, this.video.x, this.video.y);
            this.setLogoPos();
            if (cornerADPlayer != null)
            {
                this.addChild(cornerADPlayer);
            }
            videoContainer.x = (stage.stageWidth - videoContainer.width) / 2;
            videoContainer.y = (stage.stageHeight - _loc_1 - videoContainer.height) / 2;
            return;
        }// end function

        private function adjustVideoSize(param1:Video) : void
        {
            var _loc_2:Number = NaN;
            if (param1 != null)
            {
                _loc_2 = ControlBarModule.CONTROL_BAR_HEIGHT;
                if (stage.displayState == StageDisplayState.FULL_SCREEN)
                {
                    _loc_2 = 0;
                }
                if (_modelLocator.wideMode == _modelLocator.NORMAL_SCREEN)
                {
                    param1.width = this.videoWidth;
                    param1.height = this.videoHeight;
                }
                else
                {
                    param1.width = this.w_videoWidth;
                    param1.height = this.w_videoHeight;
                }
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
                adPlayOver();
                this.play();
            }
            else
            {
                addKeepOnPlayButton("http");
                if (cornerADPlayer != null)
                {
                    cornerADPlayer.visible = false;
                }
                showPauseAD();
                this.pause();
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
            this.hotStarted = false;
            bufferTimeLength = getTimer();
            if (this.ns != null)
            {
                this.reset();
            }
            else
            {
                this.initNetConnection();
            }
            return;
        }// end function

        private function switchRateHandler(event:VideoPlayEvent) : void
        {
            this.changeStreamRate(_modelLocator.currentHttpBiteRateMode);
            return;
        }// end function

        private function releaseLastRates() : void
        {
            var _loc_1:Array = null;
            var _loc_2:Array = null;
            if (this.isHighRate == 1)
            {
                _loc_1 = _modelLocator.currentVideoInfo.chapters;
                _loc_2 = _modelLocator.currentVideoInfo.lowChapters;
            }
            else if (this.isHighRate == 0)
            {
                _loc_1 = _modelLocator.currentVideoInfo.chapters2;
                _loc_2 = _modelLocator.currentVideoInfo.lowChapters;
            }
            else if (this.isHighRate == 2)
            {
                _loc_1 = _modelLocator.currentVideoInfo.chapters;
                _loc_2 = _modelLocator.currentVideoInfo.chapters2;
            }
            var _loc_3:Number = 0;
            while (_loc_3 < _loc_1.length)
            {
                
                this.releaseCharpterVO(_loc_1[_loc_3]);
                _loc_3 = _loc_3 + 1;
            }
            var _loc_4:Number = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                this.releaseCharpterVO(_loc_2[_loc_4]);
                _loc_4 = _loc_4 + 1;
            }
            MemClean.run();
            return;
        }// end function

        private function releaseAllStream() : void
        {
            var _loc_1:Array = null;
            _loc_1 = _modelLocator.currentVideoInfo.chapters;
            var _loc_2:Number = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                this.releaseCharpterVO(_loc_1[_loc_2]);
                _loc_2 = _loc_2 + 1;
            }
            _loc_1 = _modelLocator.currentVideoInfo.chapters2;
            var _loc_3:Number = 0;
            while (_loc_3 < _loc_1.length)
            {
                
                this.releaseCharpterVO(_loc_1[_loc_3]);
                _loc_3 = _loc_3 + 1;
            }
            MemClean.run();
            return;
        }// end function

        public function changeStreamRate(param1:Number) : void
        {
            var _loc_3:ChapterVO = null;
            var _loc_4:String = null;
            var _loc_5:Number = NaN;
            var _loc_6:Array = null;
            var _loc_7:ValueOBJ = null;
            this._isGetMetaData = false;
            this.firstUse = true;
            this.isCanFuffer = true;
            this.isCanFufferNext = true;
            var _loc_2:* = this.currentTime;
            this.isHighRate = param1;
            this.setIndexByPosition(_loc_2);
            this.global_baseTime = this.getCurrentChapterBaseTime();
            if (this.isHighRate == 1)
            {
                _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.chapters2[this.urlListIndex2]);
                _modelLocator.currentHttpBiteRateMode = 1;
                _modelLocator.currentBitrate = 850;
                if (_modelLocator.isConviva && enableConviva)
                {
                    _dispatcher.dispatchEvent(new CommonEvent(ConvivaMonitor.EVENT_UPDATE_CONVIVA_BIT, 850));
                }
                _modelLocator.currentVideoClipIndex = this.urlListIndex2;
            }
            else if (this.isHighRate == 2)
            {
                _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.lowChapters[this.urlListIndex3]);
                _modelLocator.currentHttpBiteRateMode = 2;
                _modelLocator.currentBitrate = 250;
                if (_modelLocator.isConviva && enableConviva)
                {
                    _dispatcher.dispatchEvent(new CommonEvent(ConvivaMonitor.EVENT_UPDATE_CONVIVA_BIT, 250));
                }
                _modelLocator.currentVideoClipIndex = this.urlListIndex3;
            }
            else
            {
                _modelLocator.currentBitrate = 450;
                if (_modelLocator.isConviva && enableConviva)
                {
                    _dispatcher.dispatchEvent(new CommonEvent(ConvivaMonitor.EVENT_UPDATE_CONVIVA_BIT, 450));
                }
                _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.chapters[this.urlListIndex]);
                _modelLocator.currentHttpBiteRateMode = 0;
                _modelLocator.currentVideoClipIndex = this.urlListIndex2;
            }
            if (_loc_3 != null)
            {
                _loc_4 = _loc_3.url;
                _loc_5 = Math.round(_loc_2 - this.global_baseTime);
                this.my_position = this.my_position + this.ns.time;
                _loc_4 = _loc_4 + ("?start=" + _loc_5);
                _loc_3.loaded = true;
                _modelLocator.currentFile = _loc_4;
                if (_loc_3.ns != null && _loc_3.chapterStart != -1 && _loc_3.chapterStart < _loc_5 && _loc_3.isLoadComp)
                {
                    this.ns = _loc_3.ns;
                    videoBaseContainer.removeChild(this.video);
                    this.video = _loc_3.video;
                    videoBaseContainer.addChild(this.video);
                    this.ns.resume();
                    this.ns.seek(_loc_5 - _loc_3.chapterStart);
                }
                else
                {
                    if (_loc_3.ns == null)
                    {
                        this.addNewStream(_loc_3);
                    }
                    this.ns = _loc_3.ns;
                    videoBaseContainer.removeChild(this.video);
                    this.video = _loc_3.video;
                    videoBaseContainer.addChild(this.video);
                    this.ns.play(_loc_4);
                    _loc_3.chapterStart = _loc_5;
                }
                this.setVideoSize2();
                if (_modelLocator.isConviva && enableConviva)
                {
                    _dispatcher.dispatchEvent(new CommonEvent(ConvivaMonitor.EVENT_UPDATE_STREAM, this.ns));
                }
                if (this.isHighRate == 1)
                {
                    _loc_6 = [];
                    _loc_7 = new ValueOBJ("t", "_switch0000");
                    _loc_6.push(_loc_7);
                    _loc_7 = new ValueOBJ("v", "1");
                    _loc_6.push(_loc_7);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_SWITCH, _loc_6));
                    isCanCheckBuffer = false;
                    if (this.timeOuter != 0)
                    {
                        clearTimeout(this.timeOuter);
                    }
                    this.timeOuter = setTimeout(this.changeToCanCheckBuffer, 10000);
                }
            }
            if (this._isPause)
            {
                this.pause();
            }
            startTargetAD(_modelLocator.currentFile, this.video.x, this.video.y);
            if (cornerADPlayer != null)
            {
                this.addChild(cornerADPlayer);
            }
            this.releaseLastRates();
            return;
        }// end function

        private function setIndexByPosition(param1:Number) : void
        {
            var _loc_3:ChapterVO = null;
            var _loc_4:int = 0;
            var _loc_2:int = 0;
            _loc_4 = 0;
            while (_loc_4 < _modelLocator.currentVideoInfo.chapters2.length)
            {
                
                _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.chapters2[_loc_4]);
                if (_loc_2 < param1)
                {
                    _loc_2 = _loc_2 + _loc_3.duration;
                    this.urlListIndex2 = _loc_4;
                    _modelLocator.currentVideoClipIndex = this.urlListIndex2;
                }
                else
                {
                    break;
                }
                _loc_4++;
            }
            _loc_2 = 0;
            _loc_4 = 0;
            while (_loc_4 < _modelLocator.currentVideoInfo.chapters.length)
            {
                
                _loc_3 = ChapterVO(_modelLocator.currentVideoInfo.chapters[_loc_4]);
                if (_loc_2 < param1)
                {
                    _loc_2 = _loc_2 + _loc_3.duration;
                    this.urlListIndex = _loc_4;
                    _modelLocator.currentVideoClipIndex = this.urlListIndex;
                }
                else
                {
                    break;
                }
                _loc_4++;
            }
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
            if (cornerADPlayer != null)
            {
                this.addChild(cornerADPlayer);
            }
            return;
        }// end function

        override public function clear() : void
        {
            this.releaseAllStream();
            if (this.hasEventListener(Event.ENTER_FRAME))
            {
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            if (this.ns != null)
            {
                this.ns.pause();
                this.removeNetStreamListen();
            }
            if (this.netCon != null)
            {
                this.removeNetConnectListen();
            }
            if (this.video != null)
            {
                this.video.clear();
                videoBaseContainer.removeChild(this.video);
            }
            if (this.video2 != null)
            {
                this.video2.clear();
                videoBaseContainer.removeChild(this.video2);
            }
            removeKeepOnPlayButton();
            this.video = null;
            this.video2 = null;
            if (_dispatcher.hasEventListener(GetVideoMatchProxy.getMatchEvent))
            {
                _dispatcher.removeEventListener(GetVideoMatchProxy.getMatchEvent, this.onGetMatch);
            }
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_HTTP_BITERATE_MODE_CHANGE, this.switchRateHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_SET_REPLAY, this.replayHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_SINGLE_CLICK, this.playOrPauseHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_DOUBLE_CLICK, this.screenChangeHandler);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_RESET_BUFFER_FLAG, this.resetBufferFlag);
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
            this.currentTime = param1;
            return;
        }// end function

        override public function getTotalTime() : Number
        {
            return _modelLocator.movieDuration;
        }// end function

        override public function getTime() : Number
        {
            return this.currentTime;
        }// end function

        private function onGetMatch(event:Event) : void
        {
            var _loc_2:Object = {};
            if (_modelLocator.paramVO.matchData.isPrecise)
            {
                this._dispatcher.addEventListener(HotDot.EVENT_SEEK_VIDEO, this.onChangeVideo);
                _loc_2.points = _modelLocator.paramVO.matchData.options;
                _modelLocator.paramVO.hotmapData = _loc_2;
                addHotDot(this.totalTime, true);
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
                addHotDot(this.totalTime, true);
                this.hotStarted = true;
            }
            return;
        }// end function

        override protected function setSizeRate(event:VideoPlayEvent) : void
        {
            this.setVideoSize2();
            return;
        }// end function

        override protected function setAngle(event:VideoPlayEvent, param2:Boolean = true) : void
        {
            if (rotationSetter == null || videoBaseContainer == null)
            {
                return;
            }
            rotationSetter.flush("rotation", Number(event.data));
            ChapterVO.vr = Number(event.data);
            if (event.data == 90)
            {
                ChapterVO.vx = videoBaseContainer.width;
                ChapterVO.vy = 0;
                this.videoBaseContainer.x = videoBaseContainer.width;
                this.videoBaseContainer.y = 0;
            }
            else if (event.data == 270)
            {
                this.videoBaseContainer.x = 0;
                this.videoBaseContainer.y = videoBaseContainer.height;
                ChapterVO.vx = 0;
                ChapterVO.vy = videoBaseContainer.height;
            }
            else if (event.data == 180)
            {
                this.videoBaseContainer.x = videoBaseContainer.width;
                this.videoBaseContainer.y = videoBaseContainer.height;
                ChapterVO.vx = videoBaseContainer.width;
                ChapterVO.vy = videoBaseContainer.height;
            }
            else if (event.data == 0)
            {
                this.videoBaseContainer.x = 0;
                this.videoBaseContainer.y = 0;
                ChapterVO.vx = 0;
                ChapterVO.vy = 0;
            }
            if (param2)
            {
                this.setVideoSize2();
            }
            return;
        }// end function

    }
}
