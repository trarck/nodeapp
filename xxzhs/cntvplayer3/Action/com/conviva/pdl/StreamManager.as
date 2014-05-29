package com.conviva.pdl
{
    import com.conviva.*;
    import com.conviva.pdl.manifest.*;
    import com.conviva.pdl.utils.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class StreamManager extends Object
    {
        private const MAX_CHUNK_BUFFERING_DURATION_MS:Number = 5000;
        private const MAX_CHUNK_BUFFERING_NUMBER:int = 4;
        private const INVALID_BW:int = -1;
        private const MIN_REPLACE_SLOW_MS:int = 1000;
        private const MAX_REPLACE_SLOW_MS:int = 9000;
        private const NONE_REPLACEMENT_BYTES_THRESHOLD:Number = 0.9;
        private const MAIN_TIMER_MS:int = 20;
        private var _mainTimer:Timer = null;
        private var _metaData:Object = null;
        private const MIN_VALID_BUFFERING_TIME_TO_STOP_SEC:Number = 0.5;
        private const INVALID_META_DURATION:Number = -1;
        private const ACTIVE_CHUNK_POSITION_TO_LOAD_NEXT:Number = 0.05;
        private var _bwFactor:Number = 0.95;
        private var _conservativeBwFactor:Number = 0.5;
        private const CONSERVATIVE_BW_THRESHOLD_MS:int = 3000;
        private const START_BUFFER_TIME_SEC:Number = 0.1;
        private const MAX_BUFFER_TIME_SEC:Number = 31;
        private const BUFFER_TIME_INCREASE_STEP_SEC:Number = 0.1;
        private const CHUNK_OVERLAP_SEC:Number = 0.0218;
        private const SEEK_PRECISION_SEC:Number = 4;
        private const BW_SAMPLE_NUM:int = 80;
        private var _bwSlideWindow:Array;
        private var _bwCalculator:BwCalculator = null;
        private var _baseDroppedFrames:Number = 0;
        private var _nc:NetConnection = null;
        private var _displayVideo:Video = null;
        private var _loadingVideo:Video = null;
        private var _activeNs:NetStream = null;
        private var _activeChunk:Chunk = null;
        private var _loadingNs:NetStream = null;
        private var _loadingChunk:Chunk = null;
        private var _startingPhtVideo:Number;
        private var _loadOffset:Number = 0;
        private var _activeOffset:Number = 0;
        private var _videoProxy:Video;
        private var _videoWidth:Number;
        private var _videoHeight:Number;
        private var _activeMetaDuration:Number = -1;
        private var _loadingMetaDuration:Number = -1;
        private var _nsProxy:NetStream;
        private var _preLoadedBytes:Number;
        private const BUFFER_TIME_UPDATE_TIMER_MS:int = 100;
        private var _bufferTimeUpdateTimer:Timer;
        private const MIN_PLAY_START_TIME_OUT_MS:int = 9000;
        private const MAX_PLAY_START_TIME_OUT_MS:int = 12000;
        private var _playStartTimer:Timer;
        private var _selectResourceTimer:Timer = null;
        private var _manifest:ChunkManifest;
        private var _isSeeking:Boolean = false;
        private var _isBuffering:Boolean = false;
        private var _isActiveStoppDelivered:Boolean = false;
        private var _session:ConvivaLightSession = null;
        private var _soundLevel:Number = 0;
        private var _trackSoundLevel:Number = 1;
        private var _isPlayStartDelivered:Boolean = false;
        private var _isPaused:Boolean = false;
        private var _lastBufferingTimeMs:Number = 0;
        private var _activeChunkBufferingDurationMs:Number = 0;
        private var _activeChunkBufferingNumber:int = 0;
        private var _isLoadingResumed:Boolean = false;
        private var _hasLoadingStream:Boolean = false;
        private var _isActiveStopped:Boolean = false;
        private var _isLoadingReady:Boolean = false;
        private var _isLoadingStarted:Boolean = false;
        private var _isSendStartTime:Boolean = true;
        private var _startLoadTimeMs:Number = 0;
        private var _playStartTimeMs:Number = 0;
        private static const SELECT_RESOURCE_INTERVAL_SEC:int = 45;

        public function StreamManager(param1:ChunkManifest, param2:NetConnection)
        {
            this._bwSlideWindow = [];
            this._manifest = param1;
            this._nc = param2;
            this._mainTimer = new Timer(this.MAIN_TIMER_MS);
            this._mainTimer.addEventListener(TimerEvent.TIMER, this.check);
            this._bufferTimeUpdateTimer = new Timer(this.BUFFER_TIME_UPDATE_TIMER_MS);
            this._bufferTimeUpdateTimer.addEventListener(TimerEvent.TIMER, this.updateBufferTime);
            this._selectResourceTimer = new Timer(SELECT_RESOURCE_INTERVAL_SEC * 1000);
            this._selectResourceTimer.addEventListener(TimerEvent.TIMER, this.resourceSelect);
            this._playStartTimer = new Timer(this.MIN_PLAY_START_TIME_OUT_MS, 1);
            this._playStartTimer.addEventListener(TimerEvent.TIMER, this.playStartTimeout);
            ViewHistory.init();
            return;
        }// end function

        private function resourceSelect(event:TimerEvent) : void
        {
            if (this._session != null)
            {
                if (this._activeChunk.resource != this._loadingChunk.resource)
                {
                    return;
                }
                Ptrace.pinfo("HttpChunkStream, ConvivaLightSession: send SelectRequest");
                this._session.selectResource(this.changeResource);
            }
            return;
        }// end function

        private function playStartTimeout(event:TimerEvent) : void
        {
            Ptrace.pinfo("playStartTimeout(). Play Start Timeout. delay=" + this._playStartTimer.delay + " res=" + this._loadingChunk.resource + " bit=" + this._loadingChunk.bitrate + " chunkNum=" + this._loadingChunk.num);
            this._playStartTimer.stop();
            var _loc_2:Object = {code:ChunkErrorEvent.EVENT_TYPE_CHUNK_LOAD_ERROR, url:this._loadingChunk.url + "|" + this._playStartTimer.delay};
            LivePass.metrics.sendEvent(ChunkErrorEvent.EVENT_TYPE_CHUNK_LOAD_ERROR, _loc_2);
            this._loadingChunk.status = Chunk.LOAD_TIMEOUT;
            return;
        }// end function

        private function changeResource(param1) : void
        {
            Ptrace.pinfo("StreamManager.changeResource().response: status=" + param1.GetStatusCode() + " warning=" + param1.GetWarningFlag());
            var _loc_2:* = param1.GetResources() as Array;
            if (_loc_2.length == 0)
            {
                this.cleanup();
                return;
            }
            if (param1.GetStatusCode() == 0 && _loc_2.length > 0)
            {
                this._manifest.candidateResources = _loc_2;
                if (_loc_2[0] != this._manifest.curResource)
                {
                    Ptrace.pinfo("StreamManager.changeResource().response: RccResource=" + _loc_2[0] + " curResource=" + this._manifest.curResource + " resources=" + _loc_2.toString());
                    this._manifest.rccResource = _loc_2[0];
                }
            }
            return;
        }// end function

        private function updateBufferTime(event:TimerEvent) : void
        {
            if (this._activeNs && !this._isBuffering && this._activeNs.bufferLength < this.MAX_BUFFER_TIME_SEC && this._activeNs.bufferLength > this._activeNs.bufferTime)
            {
                this._activeNs.bufferTime = this._activeNs.bufferTime + this.BUFFER_TIME_INCREASE_STEP_SEC;
            }
            return;
        }// end function

        public function set videoProxy(param1:Video) : void
        {
            this._videoProxy = param1;
            return;
        }// end function

        public function set session(param1:ConvivaLightSession) : void
        {
            this._session = param1;
            return;
        }// end function

        public function addChild(param1:Video) : void
        {
            Utils.copyVideoProperties(this._videoProxy, param1);
            this._videoProxy.parent.addChild(param1);
            return;
        }// end function

        public function removeChild(param1:Video) : void
        {
            this._videoProxy.parent.removeChild(param1);
            return;
        }// end function

        public function startPlay() : void
        {
            if (this._manifest.useHistoryPht)
            {
                this._startingPhtVideo = ViewHistory.getPht(this._manifest.uniqueVid);
            }
            else
            {
                this._startingPhtVideo = 0;
            }
            Ptrace.pinfo("StreamManager.startPlay() start=" + this._startingPhtVideo);
            var _loc_1:* = this._manifest.getChunkNumberByTime(this._startingPhtVideo);
            this._loadOffset = this._startingPhtVideo - this._manifest.getChunkStartTime(_loc_1);
            this._bwSlideWindow = [];
            this._loadingChunk = this._manifest.getNextLoadingChunk(this._manifest.curBitrate, _loc_1);
            this.loadChunk(this._loadingChunk);
            this.activeChunk = this._loadingChunk;
            this._mainTimer.start();
            this._bufferTimeUpdateTimer.start();
            this._selectResourceTimer.start();
            this.displayLoadingStream();
            var _loc_2:Object = {code:ChunkErrorEvent.EVENT_TYPE_INTEGRATION_INFO, uvid:this._manifest.uniqueVid, vers:this._manifest.stoneVer, bits:this._manifest.bitrates.length};
            LivePass.metrics.sendEvent(ChunkErrorEvent.EVENT_TYPE_INTEGRATION_INFO, _loc_2);
            return;
        }// end function

        private function loadChunk(param1:Chunk) : void
        {
            var _loc_4:Number = NaN;
            if (param1 == null)
            {
                Ptrace.pinfo("Null Chunk to load");
                return;
            }
            param1.status = Chunk.OK;
            if (param1.resource != this._manifest.curResource)
            {
                this._manifest.rccResource = null;
            }
            if (this._loadingNs != null && this._loadingNs != this._activeNs)
            {
                this._loadingNs.removeEventListener(NetStatusEvent.NET_STATUS, this.onPendingNetStatus);
                this._loadingNs.close();
                this._loadingNs = null;
            }
            if (this._isBuffering)
            {
                this._activeChunkBufferingDurationMs = 0;
            }
            this._loadingNs = this.createNewNetStream(this._nc);
            this._loadingNs.bufferTime = this.START_BUFFER_TIME_SEC;
            var _loc_2:* = new Object();
            _loc_2.onMetaData = this.onLoadingMetaDataFunc;
            this._loadingNs.client = _loc_2;
            this._loadingNs.addEventListener(NetStatusEvent.NET_STATUS, this.onPendingNetStatus);
            this._preLoadedBytes = 0;
            if (this._bwCalculator != null)
            {
                this._bwCalculator.cleanup();
                this._bwCalculator = null;
            }
            this._bwCalculator = new BwCalculator();
            this._bwSlideWindow = [];
            var _loc_3:* = param1.url;
            if (this._loadOffset > 0 && !param1.isCached)
            {
                _loc_3 = _loc_3 + "?start=" + this._loadOffset;
            }
            if (this._loadOffset > 0 && param1.isCached)
            {
                this._loadOffset = 0;
            }
            this._loadingVideo = new Video();
            this._loadingVideo.visible = false;
            this._loadingVideo.smoothing = true;
            this._loadingVideo.attachNetStream(this._loadingNs);
            this._startLoadTimeMs = new Date().getTime();
            this._playStartTimer.delay = (this.MIN_PLAY_START_TIME_OUT_MS + this.MAX_PLAY_START_TIME_OUT_MS) / 2;
            if (this._activeMetaDuration != this.INVALID_META_DURATION && this._activeNs != null)
            {
                _loc_4 = (this._activeMetaDuration - this._activeNs.time) * 1000;
                if (_loc_4 < this.MIN_PLAY_START_TIME_OUT_MS)
                {
                    this._playStartTimer.delay = this.MIN_PLAY_START_TIME_OUT_MS;
                }
                else if (_loc_4 > this.MAX_PLAY_START_TIME_OUT_MS)
                {
                    this._playStartTimer.delay = this.MAX_PLAY_START_TIME_OUT_MS;
                }
                else
                {
                    this._playStartTimer.delay = _loc_4;
                }
            }
            Ptrace.pinfo("loadChunk() url=" + param1.url + " timeout=" + this._playStartTimer.delay);
            this._playStartTimer.start();
            this._loadingNs.play(_loc_3);
            this._hasLoadingStream = true;
            this._loadingMetaDuration = this.INVALID_META_DURATION;
            this._loadingNs.pause();
            this._isLoadingResumed = false;
            return;
        }// end function

        public function get bitrate() : Number
        {
            return this._activeChunk.bitrate;
        }// end function

        public function get resource() : String
        {
            return this._activeChunk.resource;
        }// end function

        public function get time() : Number
        {
            if (this._activeNs != null)
            {
                return this._manifest.getChunkStartTime(this._activeChunk.num) + this._activeOffset + this._activeNs.time;
            }
            return 0;
        }// end function

        public function get loadTime() : Number
        {
            if (this._loadingNs != null)
            {
                return this._loadingChunk.durSec * (this._loadingNs.bytesLoaded / this._loadingNs.bytesTotal) + this._manifest.getChunkStartTime(this._loadingChunk.num) + this._loadOffset;
            }
            return 0;
        }// end function

        public function get bufferTime() : Number
        {
            return this._activeNs != null ? (this._activeNs.bufferTime) : (-1);
        }// end function

        public function get bufferLength() : Number
        {
            return this._activeNs != null ? (this._activeNs.bufferLength) : (-1);
        }// end function

        public function get currentFPS() : Number
        {
            return this._activeNs != null ? (this._activeNs.currentFPS) : (0);
        }// end function

        public function get activeVideo() : Video
        {
            return this._displayVideo;
        }// end function

        public function set soundTransform(param1:SoundTransform) : void
        {
            if (this._activeNs != null)
            {
                this._activeNs.soundTransform = param1;
            }
            this._trackSoundLevel = param1.volume;
            return;
        }// end function

        private function getAvgBwKbps() : Number
        {
            var _loc_1:Number = 0;
            var _loc_2:* = this._bwSlideWindow.length;
            if (_loc_2 == 0)
            {
                return this.INVALID_BW;
            }
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = _loc_1 + this._bwSlideWindow[_loc_3];
                _loc_3++;
            }
            return _loc_1 / _loc_2;
        }// end function

        private function bufferingDurationUpdate() : void
        {
            var _loc_1:Number = NaN;
            if (this._isBuffering && !this._isPaused)
            {
                _loc_1 = new Date().getTime();
                if (this._lastBufferingTimeMs != 0)
                {
                    this._activeChunkBufferingDurationMs = this._activeChunkBufferingDurationMs + (_loc_1 - this._lastBufferingTimeMs);
                }
                this._lastBufferingTimeMs = _loc_1;
            }
            else
            {
                this._lastBufferingTimeMs = 0;
            }
            return;
        }// end function

        private function bwUpdate() : void
        {
            if (this._loadingNs == null)
            {
                return;
            }
            var _loc_1:* = new Date().getTime();
            var _loc_2:* = this._loadingNs.bytesLoaded;
            this._loadingChunk.bytesLoaded = this._loadingChunk.bytesLoaded + (_loc_2 - this._preLoadedBytes);
            this._preLoadedBytes = _loc_2;
            if (this._loadingNs.bytesLoaded != this._loadingNs.bytesTotal && this._loadingNs.bytesTotal != 0)
            {
                this._bwCalculator.addData(_loc_2, BwCalculator.LOADING, _loc_1);
            }
            else
            {
                this._bwCalculator.addData(_loc_2, BwCalculator.NOT_LOADING, _loc_1);
            }
            var _loc_3:* = this.bwKbps;
            if (_loc_3 != BwCalculator.INVALID_BW)
            {
                this._bwSlideWindow.push(_loc_3);
                if (this._bwSlideWindow.length > this.BW_SAMPLE_NUM)
                {
                    this._bwSlideWindow.shift();
                }
            }
            return;
        }// end function

        private function displayLoadingStream() : void
        {
            this._hasLoadingStream = false;
            this._isActiveStopped = false;
            if (this._loadingNs == null)
            {
                Ptrace.pinfo("displayLoadingStream(). Loading is Null");
                return;
            }
            Ptrace.pinfo("displayLoadingStream(). loaded: " + this._loadingNs.bytesLoaded + "|" + this._loadingNs.bytesTotal + " buf: " + this._loadingNs.bufferLength + "|" + this._loadingNs.bufferTime);
            if (this._activeNs != null)
            {
                this._baseDroppedFrames = this._baseDroppedFrames + this._activeNs.info.droppedFrames;
                if (this._activeOffset == 0 && this._activeNs.bytesLoaded == this._activeNs.bytesTotal && this._activeChunk.num != this._loadingChunk.num && this._activeMetaDuration != this.INVALID_META_DURATION)
                {
                    Ptrace.pinfo("displayLoadingStream(). Remember Good Chunk. res=" + this._activeChunk.resource + " bit=" + this._activeChunk.bitrate + " num=" + this._activeChunk.num);
                    this._manifest.playedChunkResBit[this._activeChunk.num] = {res:this._activeChunk.resource, bit:this._activeChunk.bitrate};
                }
                this._activeNs.removeEventListener(NetStatusEvent.NET_STATUS, this.onActiveNetStatus);
                this._activeNs.close();
                this._activeNs = null;
            }
            if (this._displayVideo != null)
            {
                this._displayVideo.visible = false;
                this.removeChild(this._displayVideo);
                this._displayVideo.clear();
            }
            this._loadingNs.soundTransform = new SoundTransform(this._trackSoundLevel);
            this._activeNs = this._loadingNs;
            this._isLoadingReady = false;
            this._isLoadingStarted = false;
            this._activeNs.removeEventListener(NetStatusEvent.NET_STATUS, this.onPendingNetStatus);
            if (!this._isLoadingResumed)
            {
                this._activeNs.resume();
                this._isLoadingResumed = true;
            }
            this.registerEventsListeners(this._activeNs);
            this._loadingVideo.visible = true;
            this.addChild(this._loadingVideo);
            this._displayVideo = this._loadingVideo;
            this._activeMetaDuration = this._loadingMetaDuration;
            this._activeOffset = this._loadOffset;
            this.activeChunk = this._loadingChunk;
            this._activeChunkBufferingDurationMs = 0;
            this._activeChunkBufferingNumber = 0;
            if (this._activeChunk.isCached && this._activeOffset > 1)
            {
                Ptrace.pinfo("displayLoadingStream(), a cached chunk. seek() offset=" + this._activeOffset);
                this._activeNs.seek(this._activeOffset);
            }
            if (this._manifest.useHistoryPht)
            {
                ViewHistory.updatePht(this._manifest.uniqueVid, this.time);
            }
            return;
        }// end function

        private function sendStartTime() : void
        {
            var _loc_1:Object = null;
            if (this._isSendStartTime)
            {
                _loc_1 = {code:ChunkErrorEvent.EVENT_TYPE_CHUNK_START_TIME, url:this._loadingChunk.url, stime:this._playStartTimeMs};
                LivePass.metrics.sendEvent(ChunkErrorEvent.EVENT_TYPE_CHUNK_START_TIME, _loc_1);
            }
            return;
        }// end function

        private function checkIfResumeLoadingStream() : void
        {
            if (this._activeMetaDuration != this.INVALID_META_DURATION && this._activeMetaDuration - this._activeNs.time < this.CHUNK_OVERLAP_SEC && this._activeNs.time != 0 && !this._isLoadingResumed && this._activeChunk.num < (this._manifest.chunkTotal - 1))
            {
                Ptrace.pinfo("checkIfResumeLoadingStream() active is close to boundary, resume loading. " + " activeDur=" + this._activeMetaDuration + " activeNs.time=" + this._activeNs.time);
                this._loadingNs.resume();
                this._isLoadingResumed = true;
            }
            return;
        }// end function

        private function checkIfLoadNextStream() : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Chunk = null;
            var _loc_1:* = this.getAvgBwKbps();
            if (this._loadingChunk.num < (this._manifest.chunkTotal - 1) && !this._hasLoadingStream && this._activeNs.bytesLoaded == this._activeNs.bytesTotal && this._activeMetaDuration != this.INVALID_META_DURATION && this._activeNs.time > this._activeMetaDuration * this.ACTIVE_CHUNK_POSITION_TO_LOAD_NEXT)
            {
                if (this._manifest.useHistoryBw && this._manifest.clientIp != ChunkManifest.INVALID_IP)
                {
                    ViewHistory.updateBw(this._manifest.clientIp.toString() + this._manifest.customerId, _loc_1);
                }
                _loc_2 = this._bwFactor;
                if ((this._activeMetaDuration - this._activeNs.time) * 1000 < this.CONSERVATIVE_BW_THRESHOLD_MS)
                {
                    _loc_2 = this._conservativeBwFactor;
                }
                this._loadOffset = 0;
                Ptrace.pinfo("StreamManager.checkIfLoadNextStream()" + " bw=" + _loc_1 + " fa=" + _loc_2 + " ToEnd=" + (this._activeMetaDuration - this._activeNs.time).toString());
                _loc_3 = this._manifest.getNextLoadingChunk(_loc_1 * _loc_2, (this._activeChunk.num + 1));
                if (_loc_3 != null)
                {
                    this._loadingChunk = _loc_3;
                    this.loadChunk(this._loadingChunk);
                }
            }
            return;
        }// end function

        private function checkIfReplaceErrorLoadingStream() : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Chunk = null;
            var _loc_5:Object = null;
            if (!this._manifest.autoSwitch || !this._hasLoadingStream)
            {
                return;
            }
            var _loc_1:* = this.getAvgBwKbps();
            var _loc_2:* = this._activeMetaDuration != this.INVALID_META_DURATION ? ((this._activeMetaDuration - this._activeNs.time) * 1000) : (ChunkManifest.CHUNK_SIZE_MS);
            if (this._loadingChunk.status != Chunk.OK)
            {
                _loc_3 = _loc_2 < this.CONSERVATIVE_BW_THRESHOLD_MS ? (this._conservativeBwFactor) : (this._bwFactor);
                _loc_4 = this._manifest.replaceLoadingChunk((this._loadingChunk.bitrate - 1), this._loadingChunk.num, this._loadingChunk);
                if (_loc_4 != null)
                {
                    this._manifest.lock.lockResourceBitrate(this._loadingChunk.resource, this._loadingChunk.bitrate, this._manifest.lockWeight(this._loadingChunk.resource));
                    Ptrace.pinfo("checkIfReplaceErrorLoadingStream(). Replace Error Stream." + " [" + this._loadingChunk.resource + " " + this._loadingChunk.bitrate + "]>>>[" + _loc_4.resource + " " + _loc_4.bitrate + "] fa=" + _loc_3 + " bys=" + this._loadingNs.bytesLoaded + "|" + this._loadingNs.bytesTotal + " bw=" + _loc_1 + " cnum=" + this._loadingChunk.num + " err=" + this._loadingChunk.status + " ToEnd=" + _loc_2);
                    this._loadingChunk = _loc_4;
                    this._hasLoadingStream = false;
                    this.loadChunk(this._loadingChunk);
                }
                else
                {
                    if (this._loadingChunk.num == this._manifest.chunkTotal)
                    {
                        return;
                    }
                    _loc_5 = {code:ChunkErrorEvent.EVENT_TYPE_SKIP_ERROR_CHUNK, uniqueVid:this._manifest.uniqueVid + "|" + this._loadingChunk.num + "|" + _loc_1, url:this._loadingChunk.url};
                    this._manifest.lock.lockResourceBitrate(this._loadingChunk.resource, this._loadingChunk.bitrate, this._manifest.lockWeight(this._loadingChunk.resource));
                    _loc_4 = this._manifest.getNextLoadingChunk(_loc_1 * this._bwFactor, (this._loadingChunk.num + 1));
                    Ptrace.pinfo("checkIfReplaceErrorLoadingStream(). Empty. Skip to Chunk=" + _loc_4.num);
                    this._loadingChunk = _loc_4;
                    this._hasLoadingStream = false;
                    this.loadChunk(this._loadingChunk);
                    LivePass.metrics.sendEvent(ChunkErrorEvent.EVENT_TYPE_SKIP_ERROR_CHUNK, _loc_5);
                }
            }
            return;
        }// end function

        private function checkIfReplaceSlowLoadingStream() : void
        {
            var _loc_1:* = this.getAvgBwKbps();
            var _loc_2:* = this._activeMetaDuration != this.INVALID_META_DURATION ? ((this._activeMetaDuration - this._activeNs.time) * 1000) : (ChunkManifest.CHUNK_SIZE_MS);
            if (!this._manifest.autoSwitch || !this._hasLoadingStream || this._loadingMetaDuration == this.INVALID_META_DURATION || _loc_1 < 0)
            {
                return;
            }
            var _loc_3:* = new Date().getTime();
            if (_loc_2 > this.MAX_REPLACE_SLOW_MS || _loc_2 < this.MIN_REPLACE_SLOW_MS || this._loadingNs.bytesLoaded > this._loadingNs.bytesTotal * this.NONE_REPLACEMENT_BYTES_THRESHOLD || this._loadingNs.bytesLoaded < this._loadingNs.bytesTotal / 2 && _loc_1 * this._bwFactor >= this._loadingChunk.bitrate || this._loadingNs.bytesLoaded >= this._loadingNs.bytesTotal / 2 && _loc_1 * this._bwFactor >= this._loadingChunk.bitrate / 2)
            {
                return;
            }
            var _loc_4:* = this._bwFactor;
            if (_loc_2 < this.CONSERVATIVE_BW_THRESHOLD_MS)
            {
                _loc_4 = this._conservativeBwFactor;
            }
            var _loc_5:* = this._manifest.replaceLoadingChunk(_loc_1 * _loc_4, this._loadingChunk.num, this._loadingChunk);
            if (this._manifest.replaceLoadingChunk(_loc_1 * _loc_4, this._loadingChunk.num, this._loadingChunk) != null)
            {
                this._manifest.lock.lockResourceBitrate(this._loadingChunk.resource, this._loadingChunk.bitrate, this._manifest.lockWeight(this._loadingChunk.resource));
                Ptrace.pinfo("Replace Slow Stream." + " [" + this._loadingChunk.resource + " " + this._loadingChunk.bitrate + "]>>>>[" + _loc_5.resource + " " + _loc_5.bitrate + "]" + " bys=" + this._loadingNs.bytesLoaded + "|" + this._loadingNs.bytesTotal + " bw=" + _loc_1 + " cnum=" + this._loadingChunk.num + " bf=" + _loc_4 + " ToEnd=" + _loc_2);
                this._loadingChunk = _loc_5;
                this._hasLoadingStream = false;
                this.loadChunk(this._loadingChunk);
            }
            return;
        }// end function

        private function checkIfReplaceBufferingActiveStream() : void
        {
            var _loc_2:Chunk = null;
            if (!this._manifest.autoSwitch)
            {
                return;
            }
            var _loc_1:* = this.getAvgBwKbps();
            if ((this._activeChunkBufferingDurationMs > this.MAX_CHUNK_BUFFERING_DURATION_MS || this._activeChunkBufferingNumber > this.MAX_CHUNK_BUFFERING_NUMBER) && this._isBuffering && !this._hasLoadingStream && this._activeChunk.num < (this._manifest.chunkTotal - 1))
            {
                this._loadOffset = this.time - this._manifest.getChunkStartTime(this._activeChunk.num);
                Ptrace.pinfo("checkIfReplaceBufferingActiveStream(). Buffering=" + this._activeChunkBufferingDurationMs + "|" + this._activeChunkBufferingNumber + " loadOffset=" + this._loadOffset);
                if (this._activeNs != null)
                {
                    this._activeNs.removeEventListener(NetStatusEvent.NET_STATUS, this.onActiveNetStatus);
                    this._activeNs.close();
                }
                this._isActiveStopped = true;
                _loc_2 = null;
                _loc_2 = this._manifest.replaceLoadingChunk(_loc_1 * this._bwFactor, this._activeChunk.num, this._activeChunk);
                this._activeChunkBufferingDurationMs = 0;
                this._activeChunkBufferingNumber = 0;
                if (_loc_2 != null)
                {
                    this._manifest.lock.lockResourceBitrate(this._activeChunk.resource, this._activeChunk.bitrate, this._manifest.lockWeight(this._activeChunk.resource));
                    Ptrace.pinfo("checkIfReplaceBufferingActiveStream(). Replace Active ." + " [" + this._activeChunk.resource + " " + this._activeChunk.bitrate + "]>>>>[" + _loc_2.resource + " " + _loc_2.bitrate + "]" + " bw=" + _loc_1 + " hasLoading=" + this._hasLoadingStream);
                    this._loadingChunk = _loc_2;
                    this._hasLoadingStream = false;
                    this.loadChunk(this._loadingChunk);
                }
            }
            return;
        }// end function

        private function check(event:TimerEvent) : void
        {
            this.bufferingDurationUpdate();
            this.bwUpdate();
            this.checkIfReplaceBufferingActiveStream();
            this.checkIfLoadNextStream();
            this.checkIfReplaceErrorLoadingStream();
            this.checkIfReplaceSlowLoadingStream();
            this.checkIfResumeLoadingStream();
            return;
        }// end function

        private function onPendingNetStatus(event:NetStatusEvent) : void
        {
            var _loc_3:Object = null;
            var _loc_2:* = event.info.code;
            Ptrace.pinfo("PeningStream Event=" + _loc_2);
            switch(_loc_2)
            {
                case "NetStream.Play.Start":
                {
                    this._isLoadingStarted = true;
                    this._playStartTimeMs = new Date().getTime() - this._startLoadTimeMs;
                    if (this._isBuffering)
                    {
                        this._activeChunkBufferingDurationMs = 0;
                    }
                    if (this._playStartTimer.running)
                    {
                        this._playStartTimer.stop();
                    }
                    if (this._isActiveStopped)
                    {
                        this._loadingNs.resume();
                        this._isLoadingResumed = true;
                    }
                    if (!this._isPlayStartDelivered)
                    {
                        this._isBuffering = true;
                        this._isPlayStartDelivered = true;
                        if (this._nsProxy != null)
                        {
                            this._nsProxy.dispatchEvent(event);
                        }
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this._isLoadingReady = true;
                    if (this._isLoadingResumed || this._isActiveStopped)
                    {
                        if (this._isSeeking)
                        {
                            this._isSeeking = false;
                        }
                        this.displayLoadingStream();
                        if (this._nsProxy != null)
                        {
                            this._isBuffering = false;
                            this._nsProxy.dispatchEvent(event);
                        }
                    }
                    break;
                }
                case "NetStream.Buffer.Flush":
                case "NetStream.Play.Stop":
                {
                    _loc_3 = {code:ChunkErrorEvent.EVENT_TYPE_CHUNK_MEDIA_ERROR, url:this._loadingChunk.url};
                    LivePass.metrics.sendEvent(ChunkErrorEvent.EVENT_TYPE_CHUNK_MEDIA_ERROR, _loc_3);
                    this._loadingChunk.status = Chunk.OBJ_ERROR;
                    this._manifest.lock.lockBirate(this._loadingChunk.bitrate, this._manifest.lockWeight(this._loadingChunk.resource));
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    _loc_3 = {code:ChunkErrorEvent.EVENT_TYPE_STREAM_NOT_FOUNT, url:this._loadingChunk.url};
                    LivePass.metrics.sendEvent(ChunkErrorEvent.EVENT_TYPE_STREAM_NOT_FOUNT, _loc_3);
                    this._loadingChunk.status = Chunk.OBJ_MISSING;
                    this._manifest.lock.lockResourceBitrate(this._loadingChunk.resource, this._loadingChunk.bitrate, this._manifest.lockWeight(this._loadingChunk.resource));
                    if (this._nsProxy != null)
                    {
                        this._nsProxy.dispatchEvent(event);
                    }
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onActiveNetStatus(event:NetStatusEvent) : void
        {
            var _loc_5:NetStatusEvent = null;
            var _loc_2:Boolean = true;
            var _loc_3:* = event.info.code;
            var _loc_4:Object = null;
            if (this._isActiveStoppDelivered)
            {
                Ptrace.pinfo("ActiveStream Already Stoppend, Skip Event: " + _loc_3);
                return;
            }
            if (_loc_3 != "NetStream.Buffer.Flush")
            {
                Ptrace.pinfo("ActiveStream Event=" + _loc_3 + " bufL=" + this._activeNs.bufferLength + " bufT=" + this._activeNs.bufferTime + " bufferingT=" + this._activeChunkBufferingDurationMs / 1000);
            }
            switch(_loc_3)
            {
                case "NetStream.Seek.Notify":
                {
                    this._isSeeking = false;
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    Ptrace.pinfo("Active: StreamNotFound loading num = " + this._loadingChunk.num + " loading resource = " + this._loadingChunk.resource + " loading bitrate = " + this._loadingChunk.bitrate);
                    _loc_4 = {code:ChunkErrorEvent.EVENT_TYPE_STREAM_NOT_FOUNT, url:this._activeChunk.url};
                    LivePass.metrics.sendEvent(ChunkErrorEvent.EVENT_TYPE_STREAM_NOT_FOUNT, _loc_4);
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this._isBuffering = false;
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    this._isActiveStopped = true;
                    if (this._activeChunk.num < (this._manifest.chunkTotal - 1))
                    {
                        _loc_2 = false;
                        if (this._isLoadingReady)
                        {
                            this._isBuffering = false;
                            this.displayLoadingStream();
                            _loc_4 = {code:"NetStream.Buffer.Full"};
                            _loc_5 = new NetStatusEvent(NetStatusEvent.NET_STATUS);
                            _loc_5.info = _loc_4;
                            if (this._nsProxy != null)
                            {
                                this._nsProxy.dispatchEvent(_loc_5);
                            }
                        }
                        else if (this._loadingNs != null)
                        {
                            this._loadingNs.resume();
                            this._isLoadingResumed = true;
                        }
                    }
                    else
                    {
                        _loc_2 = true;
                        this._isActiveStoppDelivered = true;
                    }
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    if (this._activeMetaDuration - this._activeNs.time < this.MIN_VALID_BUFFERING_TIME_TO_STOP_SEC && this._isLoadingStarted && !this._isActiveStopped)
                    {
                        _loc_2 = false;
                    }
                    this._isBuffering = true;
                    var _loc_6:String = this;
                    var _loc_7:* = this._activeChunkBufferingNumber + 1;
                    _loc_6._activeChunkBufferingNumber = _loc_7;
                    break;
                }
                case "NetStream.Buffer.Flush":
                {
                    _loc_2 = false;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_2 && this._nsProxy != null)
            {
                this._nsProxy.dispatchEvent(event);
            }
            return;
        }// end function

        private function set activeChunk(param1:Chunk) : void
        {
            var _loc_2:NetStatusEvent = null;
            var _loc_3:NetStatusEvent = null;
            if (this._manifest.enableLock)
            {
                this._manifest.lock.unlockResourceBitrate(param1.resource, param1.bitrate);
            }
            if (this._manifest.curResource != param1.resource || this._activeChunk == null)
            {
                this._manifest.curResource = param1.resource;
                if (this._session != null)
                {
                    this._session.setCurrentResource(this._manifest.curResource);
                }
                _loc_2 = new NetStatusEvent(ChunkSwitchEvent.EVENT_TYPE_SWITCH_RESOURCE);
                _loc_2.info = new Object();
                _loc_2.info.resource = param1.resource;
                if (this._nsProxy != null)
                {
                    this._nsProxy.dispatchEvent(_loc_2);
                }
            }
            if (this._manifest.curBitrate != param1.bitrate || this._activeChunk == null)
            {
                this._manifest.curBitrate = param1.bitrate;
                if (this._session != null)
                {
                    this._session.setCurrentBitrate(this._manifest.curBitrate);
                }
                _loc_3 = new NetStatusEvent(ChunkSwitchEvent.EVENT_TYPE_SWITCH_BITRATE);
                _loc_3.info = new Object();
                _loc_3.info.bitrate = param1.bitrate;
                if (this._nsProxy != null)
                {
                    this._nsProxy.dispatchEvent(_loc_3);
                }
            }
            this._activeChunk = param1;
            return;
        }// end function

        private function set loadingChunk(param1:Chunk) : void
        {
            if (this._loadingChunk == null)
            {
                this._loadingChunk = param1;
                return;
            }
            Ptrace.pinfo("set loadingChunk. [" + this._loadingChunk.resource + " " + this._loadingChunk.bitrate + "]>>[" + param1.resource + " " + param1.bitrate + "]");
            this._manifest.removeCachedChunk(this._loadingChunk.num);
            this._loadingChunk = param1;
            return;
        }// end function

        public function get droppedFrames() : Number
        {
            return this._activeNs ? (this._baseDroppedFrames + this._activeNs.info.droppedFrames) : (this._baseDroppedFrames);
        }// end function

        public function set nsProxy(param1:NetStream) : void
        {
            this._nsProxy = param1;
            return;
        }// end function

        public function get bwKbps() : Number
        {
            return this._bwCalculator.bwKbps;
        }// end function

        public function pause() : void
        {
            if (this._activeNs)
            {
                this._activeNs.pause();
                this._isPaused = true;
            }
            return;
        }// end function

        public function resume() : void
        {
            if (this._activeNs)
            {
                this._activeNs.resume();
                this._isPaused = false;
            }
            return;
        }// end function

        public function seek(param1:Number) : void
        {
            var _loc_7:Chunk = null;
            if (this._isSeeking)
            {
                return;
            }
            this._isSeeking = true;
            var _loc_2:* = this._manifest.getChunkNumberByTime(param1);
            var _loc_3:* = this._manifest.getChunkStartTime(_loc_2);
            var _loc_4:* = param1 - _loc_3;
            var _loc_5:* = this._activeChunk.durSec - this._activeMetaDuration;
            if (this._activeChunk.durSec - this._activeMetaDuration < 0)
            {
                _loc_5 = 0;
            }
            var _loc_6:* = this._activeNs.bytesLoaded / this._activeNs.bytesTotal * this._activeMetaDuration;
            if (_loc_2 == this._activeChunk.num && _loc_4 > _loc_5 && _loc_4 < _loc_5 + _loc_6)
            {
                this._activeNs.seek(_loc_4 - _loc_5);
                this._activeOffset = _loc_5;
                Ptrace.pinfo("seek() to active chunk, chunk time  = " + _loc_4);
                this._isSeeking = false;
            }
            else
            {
                Ptrace.pinfo("seek() to new chunk time=" + _loc_4);
                this._activeNs.removeEventListener(NetStatusEvent.NET_STATUS, this.onActiveNetStatus);
                this._activeNs.close();
                this._loadOffset = _loc_4;
                _loc_7 = this._manifest.getNextLoadingChunk(this._loadingChunk.bitrate, _loc_2);
                if (_loc_7 != null)
                {
                    this._loadingChunk = _loc_7;
                    this.loadChunk(this._loadingChunk);
                    this.activeChunk = this._loadingChunk;
                }
                this._isActiveStopped = true;
            }
            return;
        }// end function

        private function onLoadingMetaDataFunc(param1:Object) : void
        {
            var info:* = param1;
            this._loadingMetaDuration = info.duration;
            if (this._loadOffset == 0)
            {
                this._loadingChunk.durSec = info.duration;
            }
            else
            {
                this._loadOffset = this._loadingChunk.durSec - this._loadingMetaDuration;
                if (this._loadOffset < 0)
                {
                    this._loadOffset = 0;
                }
            }
            if (this._loadingNs == this._activeNs)
            {
                this._activeMetaDuration = this._loadingMetaDuration;
                this._activeOffset = this._loadOffset;
            }
            Ptrace.pinfo("onLoadingMetaDateFunc" + " width=" + info.width + " height=" + info.height + " duration=" + info.duration + " moov=" + info.moovposition);
            this._videoWidth = info.width;
            this._videoHeight = info.height;
            if (!Utils.objectIsSame(this._metaData, info))
            {
                try
                {
                    this._nsProxy.client.onMetaData(info);
                }
                catch (e)
                {
                }
                this._metaData = info;
            }
            return;
        }// end function

        private function registerEventsListeners(param1:EventDispatcher) : void
        {
            param1.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.relayHandler);
            param1.addEventListener(IOErrorEvent.IO_ERROR, this.relayHandler);
            param1.addEventListener(NetStatusEvent.NET_STATUS, this.onActiveNetStatus);
            param1.addEventListener(StatusEvent.STATUS, this.relayHandler);
            return;
        }// end function

        private function removeEventsListeners(param1:EventDispatcher) : void
        {
            param1.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.relayHandler);
            param1.removeEventListener(IOErrorEvent.IO_ERROR, this.relayHandler);
            param1.removeEventListener(NetStatusEvent.NET_STATUS, this.onActiveNetStatus);
            param1.removeEventListener(StatusEvent.STATUS, this.relayHandler);
            return;
        }// end function

        private function relayHandler(event:Event) : void
        {
            if (this._nsProxy != null)
            {
                this._nsProxy.dispatchEvent(event);
            }
            return;
        }// end function

        protected function createNewNetStream(param1:NetConnection) : NetStream
        {
            return new NetStream(param1);
        }// end function

        public function cleanup() : void
        {
            this.removeEventsListeners(this._activeNs);
            this._activeNs.close();
            this._bwCalculator.cleanup();
            this._bwCalculator = null;
            this._bwSlideWindow = null;
            this._bufferTimeUpdateTimer.stop();
            this._bufferTimeUpdateTimer.removeEventListener(TimerEvent.TIMER, this.updateBufferTime);
            this._bufferTimeUpdateTimer = null;
            this._playStartTimer.stop();
            this._playStartTimer.removeEventListener(TimerEvent.TIMER, this.playStartTimeout);
            this._playStartTimer = null;
            this._mainTimer.stop();
            this._mainTimer.removeEventListener(TimerEvent.TIMER, this.check);
            this._mainTimer = null;
            this._selectResourceTimer.stop();
            this._selectResourceTimer.removeEventListener(TimerEvent.TIMER, this.resourceSelect);
            this._selectResourceTimer = null;
            return;
        }// end function

    }
}
