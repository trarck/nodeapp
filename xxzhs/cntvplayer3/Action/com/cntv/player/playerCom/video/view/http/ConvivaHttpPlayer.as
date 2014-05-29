package com.cntv.player.playerCom.video.view.http
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.graphics.*;
    import com.cntv.common.tools.psFilterTool.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.player.playerCom.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.playerCom.video.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.conviva.*;
    import com.conviva.pdl.*;
    import com.conviva.pdl.manifest.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;

    public class ConvivaHttpPlayer extends VideoBase
    {
        private var _nc:NetConnection;
        private var _httpChunkStream:HttpChunkStream;
        private var _video:HttpChunkVideo;
        private var _bitrateChunksArray:Array = null;
        private var _convivaMonitorSession:ConvivaLightSession;
        private var _chunkManifest:ChunkManifest;
        private var _isPlaying:Boolean = false;
        private var videoWidth:Number = 640;
        private var videoHeight:Number = 480;
        private var w_videoWidth:Number;
        private var w_videoHeight:Number;
        private var _isPause:Boolean = false;
        public var isCanFuffer:Boolean = true;
        private var tempSound:SoundTransform;
        private var _isSoundOn:Boolean;
        private var _volume:Number;
        private var psFilter:PSFilterTools;
        private static var brightness:Number = -1;
        private static var contrast:Number = -1;

        public function ConvivaHttpPlayer(param1:Number)
        {
            this.tempSound = new SoundTransform();
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_HTTP_BITERATE_MODE_CHANGE, this.switchRateHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_REPLAY, this.replayHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SINGLE_CLICK, this.playOrPauseHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_DOUBLE_CLICK, this.screenChangeHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_RESET_BUFFER_FLAG, this.resetBufferFlag);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_CHANGERATE_CLICKED, this.onNoticeChangeRateClicked);
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_MODEL));
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

        override public function play() : void
        {
            this.doRealPlay();
            return;
        }// end function

        override public function pause() : void
        {
            if (this._httpChunkStream != null)
            {
                this._httpChunkStream.pause();
                this._isPause = true;
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PAUSE));
            }
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            isCanCheckBuffer = false;
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_LOADING, "full"));
            this._video.clear();
            this._httpChunkStream.seek(param1 * _modelLocator.movieDuration);
            return;
        }// end function

        private function doRealPlay() : void
        {
            if (!this._isPlaying)
            {
                this._nc.connect(null);
            }
            else if (this._httpChunkStream != null)
            {
                this._isPause = false;
                this._httpChunkStream.resume();
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
            }
            return;
        }// end function

        override protected function initNetConnection() : void
        {
            this._nc = new NetConnection();
            this._nc.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
            this._nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this._nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            return;
        }// end function

        private function netStatusHandler(event:NetStatusEvent) : void
        {
            var _loc_2:ValueOBJ = null;
            var _loc_3:Array = null;
            var _loc_4:Number = NaN;
            var _loc_5:Array = null;
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
                    _loc_3 = [];
                    _loc_2 = new ValueOBJ("t", "err");
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("v", QualityMonitorEvent.ERROR_CAN_NOT_GET_VIDEO_FILE);
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("file", "convivaHttpStream: " + this._httpChunkStream.time);
                    _loc_3.push(_loc_2);
                    _loc_2 = new ValueOBJ("errmsg", event.info.code);
                    _loc_3.push(_loc_2);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_3));
                    break;
                }
                case "NetStream.Play.Start":
                {
                    showCornerAD();
                    startGetFps();
                    startHotmap();
                    _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_VIDEO_PLAY));
                    _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_UNLOCK_CONTROLBAR));
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, [0, 0]));
                    if (this.hasEventListener(Event.ENTER_FRAME))
                    {
                        this.removeEventListener(Event.ENTER_FRAME, this.loop);
                    }
                    this.addEventListener(Event.ENTER_FRAME, this.loop);
                    this.setVolume(_modelLocator.volumeValue);
                    if (_modelLocator.isMute)
                    {
                        this.muteOn();
                    }
                    else
                    {
                        this.muteOff();
                    }
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    this.isCanFuffer = false;
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, "full"));
                    this.callPlayOver();
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    this.isCanFuffer = true;
                    _loc_4 = this._httpChunkStream.bufferLength / this._httpChunkStream.bufferTime;
                    _loc_5 = [];
                    _loc_5.push(_loc_4);
                    _loc_5.push(0);
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, _loc_5));
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this.isCanFuffer = false;
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, "full"));
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_LOADING, "full"));
                    break;
                }
                default:
                {
                    break;
                }
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

        private function connectStream() : void
        {
            videoContainer = new Sprite();
            videoBaseContainer = new Sprite();
            videoContainer.addChild(videoBaseContainer);
            this.addChild(videoContainer);
            this._bitrateChunksArray = new Array();
            if (_modelLocator.currentVideoInfo.chapters.length > 0)
            {
                this._bitrateChunksArray.push({bitrate:200, mp4List:_modelLocator.currentVideoInfo.chapters});
            }
            if (_modelLocator.currentVideoInfo.chapters2.length > 0)
            {
                this._bitrateChunksArray.push({bitrate:450, mp4List:_modelLocator.currentVideoInfo.chapters2});
            }
            if (_modelLocator.currentVideoInfo.chapters3.length > 0)
            {
                this._bitrateChunksArray.push({bitrate:850, mp4List:_modelLocator.currentVideoInfo.chapters3});
            }
            if (_modelLocator.currentVideoInfo.chapters4.length > 0)
            {
                this._bitrateChunksArray.push({bitrate:1200, mp4List:_modelLocator.currentVideoInfo.chapters4});
            }
            if (_modelLocator.currentVideoInfo.chapters5.length > 0)
            {
                this._bitrateChunksArray.push({bitrate:2000, mp4List:_modelLocator.currentVideoInfo.chapters5});
            }
            this._chunkManifest = new ChunkManifest(_modelLocator.CANDIDATE_RESOURCES, this._bitrateChunksArray, true);
            this._chunkManifest.defaultResource = _modelLocator.CANDIDATE_RESOURCES[0];
            this._chunkManifest.defaultBitrate = 450;
            this._chunkManifest.tags = {content:_modelLocator.paramVO.videoCenterId};
            this._chunkManifest.uniqueVid = _modelLocator.paramVO.videoCenterId;
            this._chunkManifest.useHistoryBw = false;
            this._chunkManifest.useHistoryPht = false;
            this._chunkManifest.autoSwitch = true;
            this._chunkManifest.useCache = true;
            _modelLocator.currentHttpBiteRateMode = 1;
            _modelLocator.currentRtmpBiteRate = 1;
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_SET_TEXT, "STD"));
            var _loc_1:* = new Object();
            _loc_1["serverName"] = VideoBase.HTTP_VIDEO_SERVER_NAME;
            _loc_1["from"] = "cntv";
            _loc_1["playerId"] = "cntv";
            _loc_1["cdnName"] = _modelLocator.currentVideoInfo.serverName;
            _loc_1["tai"] = _modelLocator.paramVO.tai;
            _loc_1["refer"] = _modelLocator.currentVideoInfo.refURL;
            if (ModelLocator.getInstance().useStaticData == true)
            {
                _loc_1["vdf"] = "txt";
            }
            else
            {
                _loc_1["vdf"] = "vdn";
            }
            _loc_1["version"] = ModelLocator.VERSION_SHORT;
            this._chunkManifest.assetName = _modelLocator.currentVideoInfo.title;
            this._chunkManifest.tags = _loc_1;
            this._httpChunkStream = new HttpChunkStream(this._nc);
            this._httpChunkStream.addEventListener(ChunkSwitchEvent.EVENT_TYPE_SWITCH_BITRATE, this.reportSwitchBitrate);
            this._httpChunkStream.manifest = this._chunkManifest;
            this._video = new HttpChunkVideo();
            this._video.attachNetStream(this._httpChunkStream);
            videoBaseContainer.addChild(this._video);
            this._httpChunkStream.bufferTime = BUFFER_TIME;
            var _loc_2:* = new Object();
            _loc_2.onMetaData = this.onMetaData;
            this._httpChunkStream.client = _loc_2;
            this._httpChunkStream.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
            this._httpChunkStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this._httpChunkStream.playManifest();
            this.psFilter = new PSFilterTools(this._video);
            this._isPlaying = true;
            return;
        }// end function

        private function loop(event:Event) : void
        {
            var _loc_3:Array = null;
            _modelLocator.movieDuration = _modelLocator.currentVideoInfo.length;
            var _loc_2:* = this._httpChunkStream.time / _modelLocator.currentVideoInfo.length;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_PLAYED, _loc_2));
            if (this._httpChunkStream != null && (lastTimeMark == this._httpChunkStream.time || this._httpChunkStream.time == 0) && !this.isPause)
            {
                if (this.isCanFuffer)
                {
                    _loc_3 = [];
                    _loc_3.push(this.bufferPercent);
                    _loc_3.push(0);
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_BUFFER, _loc_3));
                }
            }
            else
            {
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_LOADING, "full"));
            }
            if (this._httpChunkStream != null)
            {
                lastTimeMark = this._httpChunkStream.time;
            }
            return;
        }// end function

        private function reportSwitchBitrate(event:NetStatusEvent) : void
        {
            var _loc_2:Number = 0;
            while (_loc_2 < this._bitrateChunksArray.length)
            {
                
                if (this._bitrateChunksArray[_loc_2].bitrate == event.info.bitrate)
                {
                    _modelLocator.currentHttpBiteRateMode = _loc_2;
                    _dispatcher.dispatchEvent(new RadioButtonEvent(RadioButtonEvent.EVENT_STREAM_CHANGED, _loc_2));
                    break;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function setOringinSize() : void
        {
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
            var _loc_3:Number = 0;
            this.adjustVideoSize(this._video);
            updateTargetADSize(stage.stageWidth, stage.stageHeight, this._video.x, this._video.y);
            setLogoPos();
            if (cornerADPlayer != null)
            {
                this.addChild(cornerADPlayer);
            }
            videoContainer.x = (stage.stageWidth - videoContainer.width) / 2;
            videoContainer.y = (stage.stageHeight - _loc_1 - videoContainer.height) / 2;
            return;
        }// end function

        private function onMetaData(param1:Object) : void
        {
            this.videoWidth = param1.width;
            this.videoHeight = param1.height;
            this.setOringinSize();
            this.setStatus();
            if (BeforePlayerADMoudle.isPlayingAd)
            {
                this._httpChunkStream.adStart();
                if (!this.isPause)
                {
                    _dispatcher.addEventListener(VideoPlayEvent.EVENT_PREDOWNLOAD_OVER, this.onPreLoadOver);
                    this.pause();
                }
            }
            else
            {
                startTimeTimer();
            }
            rotationSetter = new DynamicRegistration(videoBaseContainer, new Point(this.videoWidth / 2, this.videoHeight / 2));
            return;
        }// end function

        private function onPreLoadOver(event:VideoPlayEvent) : void
        {
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_PREDOWNLOAD_OVER, this.onPreLoadOver);
            this.play();
            startTimeTimer();
            return;
        }// end function

        private function setVideoSize() : void
        {
            if (stage == null)
            {
                return;
            }
            var _loc_1:* = this.videoWidth / this.videoHeight;
            if (this.videoWidth != stage.stageWidth)
            {
                this.videoWidth = stage.stageWidth;
                this.videoHeight = this.videoWidth / _loc_1;
                if (this.videoHeight > stage.stageHeight)
                {
                    this.videoHeight = stage.stageHeight;
                    this.videoWidth = this.videoHeight * _loc_1;
                }
            }
            else if (this.videoHeight != stage.stageHeight)
            {
                this.videoHeight = stage.stageHeight;
                this.videoWidth = this.videoHeight * _loc_1;
                if (this.videoWidth > stage.stageWidth)
                {
                    this.videoWidth = stage.stageWidth;
                    this.videoHeight = this.videoWidth / _loc_1;
                }
            }
            this.w_videoWidth = stage.stageWidth;
            this.w_videoHeight = this.w_videoWidth * 9 / 16;
            this.adjustVideoSize(this._video);
            return;
        }// end function

        private function adjustVideoSize(param1:HttpChunkVideo) : void
        {
            if (param1 != null)
            {
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

        override protected function adjust() : void
        {
            super.adjust();
            if (keepOnPlayButton != null)
            {
                keepOnPlayButton.x = stage.stageWidth - keepOnPlayButton.width - 5;
                keepOnPlayButton.y = stage.stageHeight - keepOnPlayButton.height - 40;
            }
            this.setVideoSize2();
            return;
        }// end function

        private function switchRateHandler(event:VideoPlayEvent) : void
        {
            return;
        }// end function

        public function replayHandler(event:VideoPlayEvent) : void
        {
            this._video.clear();
            this._httpChunkStream.seek(0);
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

        private function resetBufferFlag(event:VideoPlayEvent) : void
        {
            this.isCanFuffer = false;
            return;
        }// end function

        private function onNoticeChangeRateClicked(event:StatuBoxEvent) : void
        {
            this.changeStreamRate();
            return;
        }// end function

        public function changeStreamRate() : void
        {
            return;
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

        override public function screenNormal() : void
        {
            return;
        }// end function

        override public function screenWide() : void
        {
            return;
        }// end function

        override public function muteOn() : void
        {
            this.tempSound.volume = 0;
            this._httpChunkStream.soundTransform = this.tempSound;
            this._isSoundOn = false;
            return;
        }// end function

        override public function muteOff() : void
        {
            this.tempSound.volume = this._volume;
            this._httpChunkStream.soundTransform = this.tempSound;
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
                this._httpChunkStream.soundTransform = _loc_2;
            }
            this._volume = param1;
            return;
        }// end function

        override public function setBrightness(param1:int) : void
        {
            brightness = param1;
            this.psFilter.brightness = param1;
            super.setBrightness(param1);
            return;
        }// end function

        override public function setContrast(param1:Number) : void
        {
            contrast = param1;
            this.psFilter.contrast = param1;
            super.setContrast(param1);
            return;
        }// end function

        private function callPlayOver() : void
        {
            stopTimeTimer();
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_MESSAGE, null));
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_BUFFER, null));
            stopHotmap();
            if (ExternalInterface.available)
            {
                ExternalInterface.call("cntv_player_review_start_time", -1);
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

        public function get bufferPercent() : int
        {
            var _loc_1:* = this._httpChunkStream.bufferLength / BUFFER_TIME * 100;
            if (_loc_1 > 100)
            {
                return 100;
            }
            return _loc_1;
        }// end function

        override public function createConvivaMonitor(param1:String, param2:String) : void
        {
            if (_modelLocator.isConviva)
            {
                LivePass.init(ConvivaMonitor.SERVER_URL, "c3.CCTV-Test", null);
            }
            return;
        }// end function

        override protected function setPropor(event:VideoPlayEvent) : void
        {
            super.setPropor(event);
            this.setVideoSize2();
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
