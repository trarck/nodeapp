package com.conviva
{
    import com.conviva.*;
    import com.conviva.stream.*;
    import com.conviva.utils.*;
    import flash.errors.*;
    import flash.media.*;
    import flash.net.*;

    public class ConvivaNetStream extends NetStream implements IAdInterruptible
    {
        private var _netConnection:NetConnection = null;
        private const MAX_WAIT_FOR_LIVEPASS_INIT_MS:int = 10000;
        private var _controlMode:String = null;
        var _video:ConvivaVideo = null;
        private var _player:Object = null;
        private var _session:Object = null;
        private var _prerollsBeforePlay:int = 0;

        public function ConvivaNetStream(param1:NetConnection)
        {
            super(param1);
            this._netConnection = param1;
            this._prerollsBeforePlay = 0;
            return;
        }// end function

        public function adStart() : void
        {
            if (this._session)
            {
                Utils.RunProtected(function ()
            {
                _session.adStart();
                return;
            }// end function
            , "ConvivaNetStream.adStart");
            }
            else
            {
                var _loc_2:String = this;
                var _loc_3:* = this._prerollsBeforePlay + 1;
                _loc_2._prerollsBeforePlay = _loc_3;
            }
            return;
        }// end function

        public function adEnd() : void
        {
            if (this._session)
            {
                Utils.RunProtected(function ()
            {
                _session.adEnd();
                return;
            }// end function
            , "ConvivaNetStream.adEnd");
            }
            else
            {
                var _loc_2:String = this;
                var _loc_3:* = this._prerollsBeforePlay - 1;
                _loc_2._prerollsBeforePlay = _loc_3;
            }
            return;
        }// end function

        public function reportAdError() : void
        {
            if (this._session)
            {
                Utils.RunProtected(function ()
            {
                _session.reportAdError();
                return;
            }// end function
            , "ConvivaNetStream.reportAdError");
            }
            return;
        }// end function

        public function cleanup() : void
        {
            Utils.RunProtected(function ()
            {
                if (_video != null)
                {
                    _video._player = null;
                    _video = null;
                }
                if (_session != null)
                {
                    _session.Cleanup();
                    _session = null;
                }
                else if (_player != null)
                {
                    _player.cleanup();
                }
                _player = null;
                return;
            }// end function
            , "ConvivaNetStream.cleanup");
            return;
        }// end function

        override public function play(... args) : void
        {
            args = new activation;
            var playArguments:Array;
            var arguments:* = args;
            playArguments = ;
            Utils.RunProtected(function ()
            {
                var cci:Object;
                cci = playArguments[0];
                if (cci is ConvivaContentInfo || cci is com.conviva.stream::ConvivaContentInfo)
                {
                    LivePassInit.InvokeWhenReadyTimeout("ConvivaNetStream.play", function () : void
                {
                    if (LivePass.ready)
                    {
                        playLivePass(cci);
                    }
                    else
                    {
                        playDowngraded(cci);
                    }
                    return;
                }// end function
                , MAX_WAIT_FOR_LIVEPASS_INIT_MS);
                }
                else
                {
                    playLegacy(playArguments);
                }
                return;
            }// end function
            , "ConvivaNetStream.play");
            return;
        }// end function

        override public function pause() : void
        {
            if (this._player)
            {
                Utils.RunProtected(function ()
            {
                _player.pause();
                return;
            }// end function
            , "ConvivaNetStream.pause");
            }
            else
            {
                super.pause();
            }
            return;
        }// end function

        override public function resume() : void
        {
            if (this._player)
            {
                Utils.RunProtected(function ()
            {
                _player.resume();
                return;
            }// end function
            , "ConvivaNetStream.resume");
            }
            else
            {
                super.resume();
            }
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            var offset:* = param1;
            if (this._player)
            {
                Utils.RunProtected(function ()
            {
                _player.seek(offset);
                return;
            }// end function
            , "ConvivaNetStream.seek");
            }
            else
            {
                super.seek(offset);
            }
            return;
        }// end function

        override public function togglePause() : void
        {
            if (this._player)
            {
                Utils.RunProtected(function ()
            {
                _player.togglePause();
                return;
            }// end function
            , "ConvivaNetStream.togglePause");
            }
            else
            {
                super.togglePause();
            }
            return;
        }// end function

        public function switchBitrate(param1:Number) : void
        {
            var rate:* = param1;
            if (this._player)
            {
                Utils.RunProtected(function ()
            {
                _player.switchBitrate(rate);
                return;
            }// end function
            , "ConvivaNetStream.switchBitrate");
            }
            return;
        }// end function

        public function get curBitrate() : Number
        {
            return Utils.RunProtectedResult(function ()
            {
                return _player ? (_player.curBitrate) : (0);
            }// end function
            , "ConvivaNetStream curBitrate", 0);
        }// end function

        public function get mbrInfo() : MbrStreamInfo
        {
            return Utils.RunProtectedResult(function ()
            {
                var _loc_1:* = undefined;
                if (_player != null && _player.playerMbr != null)
                {
                    _loc_1 = new MbrStreamInfo();
                    _loc_1.setDeep(_player.playerMbr);
                    return _loc_1;
                }
                return null;
            }// end function
            , "ConvivaNetStream mbrInfo", null);
        }// end function

        public function set autoSwitch(param1:Boolean) : void
        {
            var b:* = param1;
            if (this._session)
            {
                Utils.RunProtected(function ()
            {
                _session.autoSwitch = b;
                return;
            }// end function
            , "ConvivaNetStream set autoSwitch");
            }
            return;
        }// end function

        public function set maxBitrate(param1:Number) : void
        {
            var n:* = param1;
            if (this._session)
            {
                Utils.RunProtected(function ()
            {
                _session.maxBitrate = n;
                return;
            }// end function
            , "ConvivaNetStream set maxBitrate");
            }
            return;
        }// end function

        public function set controlMode(param1:String) : void
        {
            var mode:* = param1;
            this._controlMode = mode;
            if (this._player)
            {
                Utils.RunProtected(function ()
            {
                _player.controlMode = _controlMode;
                return;
            }// end function
            , "ConvivaNetStream set controlMode");
            }
            return;
        }// end function

        public function get liveSeekRange() : Array
        {
            return Utils.RunProtectedResult(function ()
            {
                return _player ? (_player.liveSeekRange) : (null);
            }// end function
            , "ConvivaNetStream get liveSeekRange", null);
        }// end function

        public function get playheadWallTimeOffset() : Number
        {
            return Utils.RunProtectedResult(function ()
            {
                return _player ? (_player.playheadWallTimeOffset) : (0);
            }// end function
            , "ConvivaNetStream get playheadWallTimeOffset", 0);
        }// end function

        public function get mediaType() : String
        {
            if (this._player)
            {
                return this._player.mediaType;
            }
            return Utils.MEDIA_TYPE_UNKNOWN;
        }// end function

        override public function get bufferLength() : Number
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.bufferLength;
            }// end function
            , "ConvivaNetStream get bufferLength", 0)) : (super.bufferLength);
        }// end function

        override public function get bytesLoaded() : uint
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.bytesLoaded;
            }// end function
            , "ConvivaNetStream get bytesLoaded", 0)) : (super.bytesLoaded);
        }// end function

        override public function get bytesTotal() : uint
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.bytesTotal;
            }// end function
            , "ConvivaNetStream get bytesTotal", 0)) : (super.bytesTotal);
        }// end function

        override public function get currentFPS() : Number
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.currentFPS;
            }// end function
            , "ConvivaNetStream get currentFPS", 0)) : (super.currentFPS);
        }// end function

        override public function get liveDelay() : Number
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.liveDelay;
            }// end function
            , "ConvivaNetStream get liveDelay", 0)) : (super.liveDelay);
        }// end function

        override public function get time() : Number
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.time;
            }// end function
            , "ConvivaNetStream get time", 0)) : (super.time);
        }// end function

        override public function get bufferTime() : Number
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.bufferTime;
            }// end function
            , "ConvivaNetStream get bufferTime", 0)) : (super.bufferTime);
        }// end function

        override public function set soundTransform(param1:SoundTransform) : void
        {
            var value:* = param1;
            if (this._player)
            {
                Utils.RunProtected(function ()
            {
                _player.soundTransform = value;
                return;
            }// end function
            , "ConvivaNetStream set soundTransform");
            }
            super.soundTransform = value;
            return;
        }// end function

        override public function get objectEncoding() : uint
        {
            var _loc_1:* = this.activeNetStream();
            if (_loc_1)
            {
                return _loc_1.objectEncoding;
            }
            return super.objectEncoding;
        }// end function

        override public function set bufferTime(param1:Number) : void
        {
            var value:* = param1;
            if (this._player)
            {
                Utils.RunProtected(function ()
            {
                _player.bufferTime = value;
                return;
            }// end function
            , "ConvivaNetStream set bufferTime");
            }
            super.bufferTime = value;
            return;
        }// end function

        override public function set checkPolicyFile(param1:Boolean) : void
        {
            var _loc_2:NetStream = null;
            for each (_loc_2 in this.subNetStreams())
            {
                
                _loc_2.checkPolicyFile = param1;
            }
            super.checkPolicyFile = param1;
            return;
        }// end function

        override public function close() : void
        {
            this.cleanup();
            super.close();
            return;
        }// end function

        override public function attachAudio(param1:Microphone) : void
        {
            return this.disabled("attachAudio(microphone:Microphone)");
        }// end function

        override public function attachCamera(param1:Camera, param2:int = -1) : void
        {
            this.disabled("attachCamera(theCamera:Camera, snapshotMilliseconds:int=-1):void");
            return;
        }// end function

        override public function publish(param1:String = null, param2:String = null) : void
        {
            this.disabled("publish(name:String=null, type:String=null):void");
            return;
        }// end function

        override public function send(param1:String, ... args) : void
        {
            this.disabled("send(handlerName:String, ...parameters):void");
            return;
        }// end function

        override public function receiveAudio(param1:Boolean) : void
        {
            var _loc_2:NetStream = null;
            for each (_loc_2 in this.subNetStreams())
            {
                
                _loc_2.receiveAudio(param1);
            }
            return;
        }// end function

        override public function receiveVideo(param1:Boolean) : void
        {
            var _loc_2:NetStream = null;
            for each (_loc_2 in this.subNetStreams())
            {
                
                _loc_2.receiveVideo(param1);
            }
            if (this._player)
            {
                this._player.receiveVideo(param1);
            }
            return;
        }// end function

        override public function receiveVideoFPS(param1:Number) : void
        {
            var _loc_2:NetStream = null;
            for each (_loc_2 in this.subNetStreams())
            {
                
                _loc_2.receiveVideoFPS(param1);
            }
            return;
        }// end function

        function set video(param1:ConvivaVideo) : void
        {
            this._video = param1;
            this._video._player = this._player;
            if (this._player)
            {
                this._player.videoProxy = param1;
            }
            return;
        }// end function

        private function activeNetStream() : NetStream
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.activeNetStream;
            }// end function
            , "ConvivaNetStream activeNetStream", null)) : (null);
        }// end function

        private function subNetStreams() : Array
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.allNetStreams;
            }// end function
            , "ConvivaNetStream subNetStreams", [])) : ([]);
        }// end function

        private function disabled(param1:String) : void
        {
            throw new IllegalOperationError("The method \"" + param1 + "\" is not supported in ConvivaNetStream.");
        }// end function

        private function playDowngraded(param1:Object) : void
        {
            var objectId:String;
            var bitrate:Number;
            var cci:ConvivaContentInfo;
            var dfltItem:MbrStreamItem;
            var cciObj:* = param1;
            var url:String;
            var isAsync:Boolean;
            var retrievedFromMbrInfo:Boolean;
            cci = ConvivaContentInfo.clone(cciObj);
            if (cci.mbrInfo != null)
            {
                dfltItem = cci.mbrInfo.defaultStream;
                if (dfltItem != null)
                {
                    bitrate = dfltItem.bitrate;
                    objectId = dfltItem.url;
                    retrievedFromMbrInfo;
                }
            }
            if (!retrievedFromMbrInfo)
            {
                objectId = cci.assetName;
                bitrate = cci.bitrate;
            }
            var resource:* = cci.candidateResources && cci.candidateResources.length > 0 ? (cci.candidateResources[0]) : (null);
            var streamObj:Object;
            var urlManager:* = new UrlManager(function (param1:Boolean, param2:ConvivaNotification) : void
            {
                if (param2)
                {
                    Trace.Error(param2.message);
                }
                return;
            }// end function
            );
            var urlList:* = urlManager.generateList([streamObj], cci.urlGenerator, function (param1:Array) : void
            {
                playGeneratedUrl(cci, param1[0].url);
                return;
            }// end function
            );
            if (urlList != null)
            {
                this.playGeneratedUrl(cci, urlList[0].url);
            }
            return;
        }// end function

        private function playGeneratedUrl(param1:ConvivaContentInfo, param2:String) : void
        {
            var _loc_3:* = CommonUtils.splitUrlForNetConnection(param2);
            this.playLegacy([_loc_3[1], param1.start, param1.len, param1.reset]);
            return;
        }// end function

        private function playLegacy(param1:Array) : void
        {
            trace("status: ConvivaNetStream.playLegacy()");
            if (param1[0].match(/_index.flv(\?.*)?""_index.flv(\?.*)?/) != null)
            {
                Utils.ReportError("CIF files cannot be played unless LivePass is initialized");
            }
            super.play.apply(this, param1);
            return;
        }// end function

        private function playLivePass(param1:Object) : void
        {
            Utils.Assert(LivePass.ready, "LivePass is initialized");
            var _loc_2:* = LivePassInit.Module;
            Utils.Assert(_loc_2 != null, "ConvivaNetStream.play called before the LivePass is ready");
            trace("status: ConvivaNetStream.playLivePass(): Playing in normal mode.");
            this._session = _loc_2.playConvivaNetStream(param1, this as NetStream, this._video as Video);
            Utils.Assert(this._session, "Session cannot be null");
            this._player = this._session.player;
            if (this._player != null && this._controlMode != null)
            {
                this._player.controlMode = this._controlMode;
            }
            if (this._video)
            {
                this._video._player = this._player;
            }
            while (this._prerollsBeforePlay > 0)
            {
                
                this._session.adStart();
                var _loc_3:String = this;
                var _loc_4:* = this._prerollsBeforePlay - 1;
                _loc_3._prerollsBeforePlay = _loc_4;
            }
            return;
        }// end function

        function get __session() : Object
        {
            return this._session;
        }// end function

        function get __debugString() : String
        {
            return this._player ? (this._player.__debugString) : ("");
        }// end function

        function get player() : Object
        {
            return this._player;
        }// end function

        function set player(param1:Object) : void
        {
            this._player = param1;
            return;
        }// end function

        function X_T_L(param1:Number) : void
        {
            var bandwidthKbps:* = param1;
            if (this._player != null && Reflection.HasMethod("X_T_L", this._player))
            {
                Utils.RunProtected(function () : void
            {
                _player.X_T_L(bandwidthKbps);
                return;
            }// end function
            , "ConvivaNetStream.__throttle");
            }
            return;
        }// end function

    }
}
