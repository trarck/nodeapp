package com.conviva.pdl
{
    import com.conviva.*;
    import com.conviva.pdl.manifest.*;
    import com.conviva.pdl.utils.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class HttpChunkStream extends NetStream
    {
        private var _status:int = 1;
        private var _manifest:ChunkManifest;
        private var _nc:NetConnection;
        private var _chunkStream:StreamManager;
        private var _convivaMonitorSession:ConvivaLightSession = null;
        private var _tryStartPlayTimeMs:Number = -1;
        private var _hasJoined:Boolean = false;
        private var _convivaMetaData:ConvivaContentInfo = null;
        public static const PAUSED:int = 0;
        public static const PLAYING:int = 1;
        public static const VERSION:String = "25";

        public function HttpChunkStream(param1:NetConnection)
        {
            this._nc = param1;
            super(param1);
            Ptrace.pinfo("HttpChunkStream version=" + VERSION);
            return;
        }// end function

        public function cleanup() : void
        {
            this._chunkStream.cleanup();
            this._chunkStream = null;
            this._manifest.cleanup();
            this._manifest = null;
            if (this._convivaMonitorSession != null)
            {
                this._convivaMonitorSession.cleanup();
            }
            return;
        }// end function

        private function reportNetStatusEvent(event:NetStatusEvent) : void
        {
            var _loc_3:Number = NaN;
            var _loc_2:* = event.info.code;
            if (LivePass.ready)
            {
                Ptrace.pinfo("HttpChunkStream Event=" + _loc_2);
                return;
            }
            Ptrace.pinfo("Live Pass Not Ready. HttpChunkStream Event=" + _loc_2);
            if (_loc_2 == "NetStream.Buffer.Full" && !this._hasJoined)
            {
                _loc_3 = new Date().getTime() - this._tryStartPlayTimeMs;
                this._convivaMetaData.monitoringOptions = {passedJoinTime:_loc_3};
                this._hasJoined = true;
            }
            if (_loc_2 == "NetStream.Play.StreamNotFound" || _loc_2 == "NetStream.Play.Failed" || _loc_2 == "NetStream.Failed")
            {
                if (this._convivaMonitorSession != null)
                {
                    this._convivaMonitorSession.reportNetStatusEvent(event);
                }
            }
            return;
        }// end function

        private function getClientIpFromModule() : uint
        {
            return 222222;
        }// end function

        function set videoProxy(param1:HttpChunkVideo) : void
        {
            if (this._chunkStream)
            {
                this._chunkStream.videoProxy = param1;
            }
            return;
        }// end function

        protected function createStreamManager(param1:ChunkManifest, param2:NetConnection) : StreamManager
        {
            return new StreamManager(param1, param2);
        }// end function

        public function set manifest(param1:ChunkManifest) : void
        {
            this._manifest = param1;
            this._manifest.stoneVer = VERSION;
            this._chunkStream = this.createStreamManager(this._manifest, this._nc);
            this._chunkStream.nsProxy = this;
            return;
        }// end function

        public function adStart() : void
        {
            if (this._convivaMonitorSession != null)
            {
                this._convivaMonitorSession.adStart();
            }
            return;
        }// end function

        public function adEnd() : void
        {
            if (this._convivaMonitorSession != null)
            {
                this._convivaMonitorSession.adEnd();
            }
            return;
        }// end function

        private function createConvivaSession() : void
        {
            this._convivaMetaData = new ConvivaContentInfo("", this._manifest.candidateResources, this._manifest.tags);
            this._convivaMetaData.cdnName = this._manifest.candidateResources[0];
            this._convivaMetaData.assetName = this._manifest.assetName;
            this._convivaMetaData.isLive = false;
            this._convivaMetaData.bitrate = this._manifest.defaultBitrate;
            Ptrace.pinfo("HttpChunkStream, createConvivaSession");
            this._convivaMonitorSession = new ConvivaLightSession(this._convivaMetaData);
            this._chunkStream.session = this._convivaMonitorSession;
            Ptrace.pinfo("HttpChunkStream, startMonitor");
            this._convivaMonitorSession.startMonitor(this, this._manifest.candidateResources[0]);
            Ptrace.pinfo("HttpChunkStream, ConvivaLightSession: send SelectRequest");
            this._convivaMonitorSession.selectResource(this.changeResource);
            return;
        }// end function

        private function changeResource(param1) : void
        {
            Ptrace.pinfo("HttpChunkStream SelectResouce response: status=" + param1.GetStatusCode() + " warning=" + param1.GetWarningFlag());
            var _loc_2:* = param1.GetResources() as Array;
            if (_loc_2.length == 0)
            {
                this.cleanup();
                return;
            }
            if (param1.GetStatusCode() == 0 && _loc_2.length > 0)
            {
                Ptrace.pinfo("HttpChunkStream changeResource rccResource=" + _loc_2[0] + " Resources=" + _loc_2.toString());
                this._manifest.candidateResources = _loc_2;
                this._manifest.rccResource = _loc_2[0];
            }
            return;
        }// end function

        public function playManifest() : void
        {
            this.createConvivaSession();
            this.startPlay();
            return;
        }// end function

        private function startPlay() : void
        {
            this._manifest.curResource = this._manifest.defaultResource;
            this._tryStartPlayTimeMs = new Date().getTime();
            var _loc_1:Number = 0;
            if (this._manifest.useHistoryBw)
            {
                this._manifest.clientIp = this.getClientIpFromModule();
                if (this._manifest.clientIp != ChunkManifest.INVALID_IP)
                {
                    _loc_1 = ViewHistory.getBw(this._manifest.clientIp.toString() + this._manifest.customerId);
                    Ptrace.pinfo("History BW=" + _loc_1 + " for Ip=" + this._manifest.clientIp);
                }
            }
            if (_loc_1 != 0)
            {
                this._manifest.curBitrate = _loc_1;
            }
            else
            {
                this._manifest.curBitrate = this._manifest.defaultBitrate;
            }
            this.addEventListener(NetStatusEvent.NET_STATUS, this.reportNetStatusEvent);
            this._chunkStream.startPlay();
            this._status = PLAYING;
            return;
        }// end function

        public function switchBitrate(param1:Number) : void
        {
            this._manifest.manualBitrate = param1;
            this._manifest.autoSwitch = false;
            return;
        }// end function

        public function set autoSwitch(param1:Boolean) : void
        {
            this._manifest.autoSwitch = param1;
            return;
        }// end function

        public function get video() : Video
        {
            return this._chunkStream.activeVideo;
        }// end function

        public function get movieLength() : Number
        {
            return this._manifest.movieLength;
        }// end function

        public function get loadTime() : Number
        {
            return this._chunkStream.loadTime;
        }// end function

        public function get status() : int
        {
            return this._status;
        }// end function

        override public function set soundTransform(param1:SoundTransform) : void
        {
            this._chunkStream.soundTransform = param1;
            return;
        }// end function

        override public function pause() : void
        {
            this._status = PAUSED;
            this._chunkStream.pause();
            return;
        }// end function

        override public function resume() : void
        {
            this._status = PLAYING;
            this._chunkStream.resume();
            return;
        }// end function

        public function get bitrate() : Number
        {
            return this._chunkStream.bitrate;
        }// end function

        public function get resource() : String
        {
            return this._chunkStream.resource;
        }// end function

        public function droppedFrames() : Number
        {
            return this._chunkStream.droppedFrames;
        }// end function

        override public function get currentFPS() : Number
        {
            return this._chunkStream.currentFPS;
        }// end function

        override public function seek(param1:Number) : void
        {
            Ptrace.pinfo("HttpChunkStream.seek() " + param1);
            this._chunkStream.seek(param1);
            return;
        }// end function

        override public function get time() : Number
        {
            if (this._chunkStream != null)
            {
                return this._chunkStream.time;
            }
            return 0;
        }// end function

        override public function get bufferLength() : Number
        {
            return this._chunkStream.bufferLength;
        }// end function

        override public function get bufferTime() : Number
        {
            return this._chunkStream.bufferTime;
        }// end function

        override public function get bytesLoaded() : uint
        {
            return this._manifest.bytesLoaded;
        }// end function

        override public function get info() : NetStreamInfo
        {
            var bandwidth:Number;
            var df:Number;
            var netInfo:NetStreamInfo;
            var netStreamInfoClass:* = NetStreamInfo;
            bandwidth = this._chunkStream.bwKbps;
            df = this.droppedFrames();
            try
            {
                netInfo = new netStreamInfoClass(0, this.bytesLoaded, bandwidth * 1000 / 8, 0, 0, 0, 0, 0, 0, 0, df, 0, 0, 0, 0, 0, 0, 0, 0, 0) as NetStreamInfo;
            }
            catch (error)
            {
                netInfo = new netStreamInfoClass(0, bytesLoaded, bandwidth * 1000 / 8, 0, 0, 0, 0, 0, 0, 0, df, 0, 0, 0, 0, 0, 0, 0, 0) as NetStreamInfo;
            }
            return netInfo;
        }// end function

    }
}
