package com.conviva.pdl.manifest
{
    import com.conviva.pdl.*;
    import com.conviva.pdl.utils.*;

    public class ChunkManifest extends Object
    {
        public var enableLock:Boolean = true;
        private var _useHistoryBw:Boolean = false;
        private var _historyBw:Number = 0;
        private var _useHistoryPht:Boolean = false;
        private var _historyPht:Number = 0;
        private var _useCache:Boolean = false;
        private var _stoneVer:String = "";
        private var _customerId:String = "c3_test";
        private var _uniqueVid:String = "";
        private var _assetName:String = "";
        private var _clientIp:uint = 0;
        private var _defaultBitrate:Number;
        private var _defaultResource:String;
        private var _chunkTotal:int = 0;
        private var _resources:Array;
        private var _bitrates:Array;
        private var _streamStartDelay:Array;
        private var _tags:Object;
        public const INVALID_BITRATE:Number = -1;
        public const INVALID_RESOURCE:String = "invalid_resource";
        private var _playedChunkResBit:Array;
        private var _autoSwitch:Boolean = true;
        private var _curBitrate:Number = 0;
        private var _manualBitrate:Number = -1;
        private var _curResource:String = null;
        private var _rccResource:String = null;
        private var _switchLock:SwitchLock;
        private var _chunkResources:Array = null;
        public static const INVALID_IP:uint = 0;
        public static const CHUNK_SIZE_MS:Number = 28000;
        public static var ifReplaceHost:Boolean = false;

        public function ChunkManifest(param1:Array, param2:Array, param3:Boolean)
        {
            this._playedChunkResBit = [];
            this._chunkResources = new Array();
            this._resources = new Array();
            this._bitrates = new Array();
            ifReplaceHost = param3;
            this._chunkTotal = param2[0].mp4List.length;
            var _loc_4:String = "";
            var _loc_5:int = 0;
            while (_loc_5 < param2.length)
            {
                
                _loc_4 = _loc_4 + ("(" + param2[_loc_5].bitrate + ":" + param2[_loc_5].mp4List.length + ")");
                _loc_5++;
            }
            _loc_4 = _loc_4 + "|";
            var _loc_6:int = 0;
            while (_loc_6 < param1.length)
            {
                
                this._chunkResources.push(new ChunkResource(param1[_loc_6], param2));
                this._resources.push(param1[_loc_6]);
                _loc_4 = _loc_4 + (" " + param1[_loc_6]);
                _loc_6++;
            }
            Ptrace.pinfo("VDN=" + _loc_4);
            var _loc_7:int = 0;
            while (_loc_7 < param2.length)
            {
                
                if (param2[_loc_7].mp4List.length == this._chunkTotal)
                {
                    this._bitrates.push(param2[_loc_7].bitrate);
                }
                _loc_7++;
            }
            var _loc_8:int = 0;
            while (_loc_8 < this._chunkTotal)
            {
                
                this._playedChunkResBit.push({res:this.INVALID_RESOURCE, bit:this.INVALID_BITRATE});
                _loc_8++;
            }
            this._switchLock = new SwitchLock(this._resources, this._bitrates);
            return;
        }// end function

        private function getChunkResource(param1:String) : ChunkResource
        {
            var _loc_2:ChunkResource = null;
            for each (_loc_2 in this._chunkResources)
            {
                
                if (_loc_2.resourceName == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function get lock() : SwitchLock
        {
            return this._switchLock;
        }// end function

        private function getStream(param1:String, param2:Number) : ChunkStream
        {
            var _loc_4:ChunkStream = null;
            var _loc_3:* = this.getChunkResource(param1);
            if (_loc_3 != null)
            {
                _loc_4 = _loc_3.getChunkStream(param2);
                if (_loc_4 != null)
                {
                    return _loc_4;
                }
            }
            return null;
        }// end function

        public function get lowestBitrate() : Number
        {
            return this._bitrates[0];
        }// end function

        public function get lowestPlayableBitrate() : Number
        {
            var _loc_2:int = 0;
            var _loc_1:int = 0;
            while (_loc_1 < this._bitrates.length)
            {
                
                _loc_2 = 0;
                while (_loc_2 < this._resources.length)
                {
                    
                    if (!this.isLocked(this._resources[_loc_2], this._bitrates[_loc_1]))
                    {
                        return this._bitrates[_loc_1];
                    }
                    _loc_2++;
                }
                _loc_1++;
            }
            return this._bitrates[0];
        }// end function

        private function getChunk(param1:String, param2:Number, param3:int) : Chunk
        {
            return this.getStream(param1, param2).getChunk(param3);
        }// end function

        private function isLocked(param1:String, param2:Number) : Boolean
        {
            var _loc_3:Number = NaN;
            if (this.enableLock)
            {
                _loc_3 = new Date().getTime();
                return this._switchLock.isLocked(param1, param2, _loc_3);
            }
            return false;
        }// end function

        public function getChunkNumberByTime(param1:Number) : int
        {
            return this.getStream(this._curResource, this._curBitrate).getChunkNumberByTime(param1);
        }// end function

        public function getChunkByTime(param1:Number) : Chunk
        {
            return this.getChunk(this._curResource, this._curBitrate, this.getChunkNumberByTime(param1));
        }// end function

        public function set curBitrate(param1:Number) : void
        {
            this._curBitrate = this.adjust(param1);
            return;
        }// end function

        public function get curBitrate() : Number
        {
            return this._curBitrate;
        }// end function

        public function get manualBitrate() : Number
        {
            return this._manualBitrate;
        }// end function

        public function set manualBitrate(param1:Number) : void
        {
            this._manualBitrate = this.adjust(param1);
            return;
        }// end function

        public function set autoSwitch(param1:Boolean) : void
        {
            this._autoSwitch = param1;
            if (!this._autoSwitch)
            {
                if (this._manualBitrate == -1)
                {
                    this._manualBitrate = this._defaultBitrate;
                }
            }
            return;
        }// end function

        public function get autoSwitch() : Boolean
        {
            return this._autoSwitch;
        }// end function

        public function get rccResource() : String
        {
            return this._rccResource;
        }// end function

        public function set rccResource(param1:String) : void
        {
            this._rccResource = param1;
            return;
        }// end function

        public function get useCache() : Boolean
        {
            return this._useCache;
        }// end function

        public function set useCache(param1:Boolean) : void
        {
            this._useCache = param1;
            return;
        }// end function

        public function set curResource(param1:String) : void
        {
            this._curResource = param1;
            return;
        }// end function

        public function get curResource() : String
        {
            return this._curResource;
        }// end function

        private function adjust(param1:Number) : Number
        {
            var _loc_2:* = this._bitrates.length - 1;
            while (_loc_2 >= 0)
            {
                
                if (param1 >= this._bitrates[_loc_2])
                {
                    return this._bitrates[_loc_2];
                }
                _loc_2 = _loc_2 - 1;
            }
            return this._bitrates[0];
        }// end function

        public function set defaultBitrate(param1:Number) : void
        {
            this._defaultBitrate = this.adjust(param1);
            return;
        }// end function

        public function get defaultBitrate() : Number
        {
            return this._defaultBitrate;
        }// end function

        public function set defaultResource(param1:String) : void
        {
            this._defaultResource = param1;
            return;
        }// end function

        public function get defaultResource() : String
        {
            return this._defaultResource;
        }// end function

        public function get defaultStream() : ChunkStream
        {
            return this.getStream(this._defaultResource, this._defaultBitrate);
        }// end function

        public function get chunkTotal() : int
        {
            return this._chunkTotal;
        }// end function

        public function get useHistoryBw() : Boolean
        {
            return this._useHistoryBw;
        }// end function

        public function get useHistoryPht() : Boolean
        {
            return this._useHistoryPht;
        }// end function

        public function set useHistoryBw(param1:Boolean) : void
        {
            this._useHistoryBw = param1;
            return;
        }// end function

        public function set useHistoryPht(param1:Boolean) : void
        {
            this._useHistoryPht = param1;
            return;
        }// end function

        public function get historyBw() : Number
        {
            return this._historyBw;
        }// end function

        public function set historyBw(param1:Number) : void
        {
            this._historyBw = param1;
            return;
        }// end function

        public function get historyPht() : Number
        {
            return this._historyPht;
        }// end function

        public function set historyPht(param1:Number) : void
        {
            this._historyPht = param1;
            return;
        }// end function

        public function get customerId() : String
        {
            return this._customerId;
        }// end function

        public function set customerId(param1:String) : void
        {
            this._customerId = param1;
            return;
        }// end function

        public function get uniqueVid() : String
        {
            return this._uniqueVid;
        }// end function

        public function set uniqueVid(param1:String) : void
        {
            this._uniqueVid = param1;
            return;
        }// end function

        public function get stoneVer() : String
        {
            return this._stoneVer;
        }// end function

        public function set stoneVer(param1:String) : void
        {
            this._stoneVer = param1;
            return;
        }// end function

        public function get assetName() : String
        {
            return this._assetName;
        }// end function

        public function set assetName(param1:String) : void
        {
            this._assetName = param1;
            return;
        }// end function

        public function get clientIp() : uint
        {
            return this._clientIp;
        }// end function

        public function set clientIp(param1:uint) : void
        {
            this._clientIp = param1;
            return;
        }// end function

        public function getChunkStartTime(param1:int) : Number
        {
            var _loc_4:int = 0;
            var _loc_2:Number = 0;
            var _loc_3:* = this.getStream(this._curResource, this._curBitrate);
            if (_loc_3 != null)
            {
                _loc_4 = 0;
                while (_loc_4 < param1)
                {
                    
                    _loc_2 = _loc_2 + _loc_3.getChunk(_loc_4).durSec;
                    _loc_4++;
                }
            }
            return _loc_2;
        }// end function

        private function getTimeoutCountOnResource(param1:String, param2:int) : int
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < this._bitrates.length)
            {
                
                if (this.getChunk(param1, this._bitrates[_loc_4], param2).status == Chunk.LOAD_TIMEOUT)
                {
                    _loc_3++;
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public function replaceLoadingChunk(param1:Number, param2:int, param3:Chunk) : Chunk
        {
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:Number = NaN;
            var _loc_16:String = null;
            var _loc_17:Number = NaN;
            var _loc_4:Chunk = null;
            var _loc_5:Boolean = false;
            var _loc_6:* = param3.status == Chunk.OBJ_ERROR || param3.status == Chunk.OBJ_MISSING;
            var _loc_7:* = this.getTimeoutCountOnResource(param3.resource, param2);
            var _loc_8:* = param3.status == Chunk.OBJ_MISSING || _loc_7 > 1;
            var _loc_9:* = _loc_6;
            var _loc_10:Array = [];
            if (_loc_9)
            {
                _loc_13 = this.bitrateIndex(this._curBitrate);
                _loc_14 = 0;
                while (_loc_14 < this._bitrates.length)
                {
                    
                    _loc_10.push(this._bitrates[_loc_13]);
                    if (_loc_13 == 0)
                    {
                        _loc_13 = this._bitrates.length - 1;
                    }
                    else
                    {
                        _loc_13 = _loc_13 - 1;
                    }
                    _loc_14++;
                }
            }
            else
            {
                _loc_14 = this._bitrates.length - 1;
                while (_loc_14 >= 0)
                {
                    
                    if (this._bitrates[_loc_14] <= param1)
                    {
                        _loc_10.push(this._bitrates[_loc_14]);
                    }
                    _loc_14 = _loc_14 - 1;
                }
                if (_loc_10.length == 0)
                {
                    if (this.lowestPlayableBitrate > param3.bitrate)
                    {
                        Ptrace.pinfo("ChunkManifest.replaceLoadingChunk(). return null. Empty bit array. Not try higher. lowestPlayableBitrate=" + this.lowestPlayableBitrate + " lb=" + param3.bitrate);
                        return null;
                    }
                    _loc_10.push(this.lowestPlayableBitrate);
                    Ptrace.pinfo("ChunkManifest.replaceLoadingChunk(). Empty bit array. bw=" + param1 + " Try lowestPlayable=" + this.lowestPlayableBitrate);
                }
            }
            var _loc_11:String = "";
            if (_loc_8)
            {
                _loc_11 = this._resources[(this.resourceIndex(_loc_11) + 1) % this._resources.length];
            }
            else
            {
                _loc_11 = this._curResource;
            }
            Ptrace.pinfo("ChunkManifest.replaceLoadingChunk()." + " bw=" + param1 + " lr=" + param3.resource + " lb=" + param3.bitrate + " cn=" + param2 + " curRes=" + this._curResource + " bitrates=" + _loc_10.toString());
            var _loc_12:int = 0;
            while (_loc_12 < this._resources.length)
            {
                
                for each (_loc_15 in _loc_10)
                {
                    
                    if (!this.isLocked(_loc_11, _loc_15) && (_loc_11 != param3.resource || _loc_15 != param3.bitrate))
                    {
                        _loc_4 = this.getChunk(_loc_11, _loc_15, param2);
                        if (_loc_4.status == Chunk.OK)
                        {
                            _loc_5 = true;
                            Ptrace.pinfo("ChunkManifest.replaceLoadingChunk() found chunk. res=" + _loc_11 + " bit=" + _loc_15 + " loading res=" + param3.resource + " bit=" + param3.bitrate);
                            break;
                        }
                    }
                }
                if (_loc_5)
                {
                    break;
                }
                else
                {
                    _loc_11 = this._resources[(this.resourceIndex(_loc_11) + 1) % this._resources.length];
                }
                _loc_12++;
            }
            if (!_loc_5 && _loc_6)
            {
                Ptrace.pinfo("ChunkManifest.replaceLoadingChunk() Not Found. must Replace");
                for (_loc_16 in this._resources.length)
                {
                    
                    for each (_loc_17 in _loc_10)
                    {
                        
                        _loc_4 = this.getChunk(_loc_16, _loc_17, param2);
                        if (_loc_4.status == Chunk.OK && (_loc_16 != param3.resource || _loc_15 != param3.bitrate))
                        {
                            _loc_5 = true;
                            break;
                        }
                    }
                    if (_loc_5)
                    {
                        break;
                    }
                }
            }
            return _loc_4;
        }// end function

        public function getNextLoadingChunk(param1:Number, param2:int) : Chunk
        {
            var _loc_10:Number = NaN;
            var _loc_3:Chunk = null;
            var _loc_4:Boolean = false;
            var _loc_5:* = param1 < 0 ? (this.curBitrate) : (param1);
            var _loc_6:Array = [];
            if (!this.autoSwitch)
            {
                Ptrace.pinfo("ChunkManifest.getNextLoadingChunk(). AutoSwitch is off. Return the current");
                _loc_3 = this.getChunk(this._curResource, this._manualBitrate, param2);
                return _loc_3;
            }
            if (this.useCache)
            {
                if (this._playedChunkResBit[param2].res != this.INVALID_RESOURCE && this._playedChunkResBit[param2].bit != this.INVALID_BITRATE && this._playedChunkResBit[param2].bit >= this.adjust(_loc_5))
                {
                    Ptrace.pinfo("ChunkManifest.getNextLoadingChunk(). already played chunk = " + param2 + " with higher bitrate =" + this._playedChunkResBit[param2].bit);
                    _loc_3 = this.getChunk(this._playedChunkResBit[param2].res, this._playedChunkResBit[param2].bit, param2);
                    _loc_3.isCached = true;
                    return _loc_3;
                }
            }
            var _loc_7:* = this._bitrates.length - 1;
            while (_loc_7 >= 0)
            {
                
                if (this._bitrates[_loc_7] <= _loc_5)
                {
                    _loc_6.push(this._bitrates[_loc_7]);
                }
                _loc_7 = _loc_7 - 1;
            }
            if (_loc_6.length == 0)
            {
                _loc_6.push(this.lowestPlayableBitrate);
            }
            var _loc_8:String = "";
            if (param1 > 0 && param1 < this.lowestBitrate / 2)
            {
                _loc_8 = this._resources[(this.resourceIndex(_loc_8) + 1) % this._resources.length];
            }
            else
            {
                _loc_8 = this._curResource;
            }
            Ptrace.pinfo("ChunkManifest.getNextLoadingChunk()." + " bw=" + param1 + " cn=" + param2 + " res=" + this._curResource + " bitrates=" + _loc_6.toString());
            var _loc_9:int = 0;
            while (_loc_9 < this._resources.length)
            {
                
                for each (_loc_10 in _loc_6)
                {
                    
                    if (!this.isLocked(_loc_8, _loc_10))
                    {
                        _loc_3 = this.getChunk(_loc_8, _loc_10, param2);
                        _loc_4 = true;
                        break;
                    }
                }
                if (_loc_4)
                {
                    break;
                }
                _loc_8 = this._resources[(this.resourceIndex(_loc_8) + 1) % this._resources.length];
                _loc_9++;
            }
            if (_loc_4)
            {
                if (_loc_3.bitrate >= this._curBitrate && _loc_3.resource == this._curResource)
                {
                    if (this._rccResource != null && this._rccResource != this._curResource)
                    {
                        Ptrace.pinfo("ChunkManifest.getNextLoadingChunk(). Try to play RCC resource=" + this._rccResource);
                        _loc_3.newResource(this._rccResource);
                        this._rccResource = null;
                    }
                }
            }
            else
            {
                _loc_3 = this.getChunk(this._curResource, this._curBitrate, param2);
            }
            return _loc_3;
        }// end function

        private function bitrateIndex(param1:Number) : int
        {
            var _loc_2:int = 0;
            while (_loc_2 < this._bitrates.length)
            {
                
                if (this._bitrates[_loc_2] == param1)
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return 0;
        }// end function

        private function resourceIndex(param1:String) : int
        {
            var _loc_2:int = 0;
            while (_loc_2 < this._resources.length)
            {
                
                if (this._resources[_loc_2] == param1)
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return 0;
        }// end function

        public function removeCachedChunk(param1:Number) : void
        {
            this._playedChunkResBit[param1].res = this.INVALID_RESOURCE;
            this._playedChunkResBit[param1].bit = this.INVALID_BITRATE;
            return;
        }// end function

        public function get bytesLoaded() : Number
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:Chunk = null;
            var _loc_1:Number = 0;
            var _loc_2:int = 0;
            while (_loc_2 < this._resources.length)
            {
                
                _loc_3 = 0;
                while (_loc_3 < this._bitrates.length)
                {
                    
                    _loc_4 = 0;
                    while (_loc_4 < this.chunkTotal)
                    {
                        
                        _loc_5 = this.getChunk(this._resources[_loc_2], this._bitrates[_loc_3], _loc_4);
                        if (_loc_5 != null)
                        {
                            _loc_1 = _loc_1 + _loc_5.bytesLoaded;
                        }
                        _loc_4++;
                    }
                    _loc_3++;
                }
                _loc_2++;
            }
            return _loc_1;
        }// end function

        public function get tags() : Object
        {
            return this._tags;
        }// end function

        public function set tags(param1:Object) : void
        {
            this._tags = param1;
            return;
        }// end function

        public function get candidateResources() : Array
        {
            return this._resources;
        }// end function

        public function set candidateResources(param1:Array) : void
        {
            this._resources = param1;
            return;
        }// end function

        public function lockWeight(param1:String) : int
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < this._resources.length)
            {
                
                _loc_5 = 0;
                _loc_6 = 0;
                while (_loc_6 < this._playedChunkResBit.length)
                {
                    
                    if (this._playedChunkResBit[_loc_6].res == this._resources[_loc_4])
                    {
                        _loc_5++;
                    }
                    _loc_6++;
                }
                if (this._resources[_loc_4] == param1)
                {
                    _loc_2 = _loc_5;
                }
                if (_loc_5 > _loc_3)
                {
                    _loc_3 = _loc_5;
                }
                _loc_4++;
            }
            return _loc_3 - _loc_2;
        }// end function

        public function get playedChunkResBit() : Array
        {
            return this._playedChunkResBit;
        }// end function

        public function get bitrates() : Array
        {
            return this._bitrates;
        }// end function

        public function get movieLength() : Number
        {
            return this.defaultStream.totalDurSec;
        }// end function

        public function cleanup() : void
        {
            var _loc_1:ChunkResource = null;
            this._switchLock.cleanup();
            this._playedChunkResBit = null;
            for each (_loc_1 in this._chunkResources)
            {
                
                _loc_1.cleanup();
            }
            this._chunkResources = null;
            this._resources = null;
            this._bitrates = null;
            return;
        }// end function

        public static function getChunkManifest(param1:Array, param2:Array, param3:int, param4:Number) : ChunkManifest
        {
            return null;
        }// end function

    }
}
