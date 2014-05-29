package com.conviva.pdl.manifest
{

    public class ChunkStream extends Object
    {
        private var _totalDurSec:Number;
        private var _resource:String;
        private var _bitrate:Number;
        private var _chunks:Array;

        public function ChunkStream(param1:String, param2:Number, param3:Array)
        {
            this._chunks = [];
            this._resource = param1;
            this._bitrate = param2;
            this._totalDurSec = 0;
            var _loc_4:int = 0;
            while (_loc_4 < param3.length)
            {
                
                this._totalDurSec = this._totalDurSec + param3[_loc_4].duration;
                this._chunks.push(new Chunk(this._resource, this._bitrate, param3[_loc_4].duration, param3[_loc_4].image, param3[_loc_4].url, _loc_4));
                _loc_4++;
            }
            return;
        }// end function

        public function getChunk(param1:int) : Chunk
        {
            if (param1 > this._chunks.length)
            {
                return this._chunks[(this._chunks.length - 1)];
            }
            return this._chunks[param1];
        }// end function

        public function getChunkNumberByTime(param1:Number) : int
        {
            var _loc_3:int = 0;
            var _loc_2:Number = 0;
            if (param1 >= this._totalDurSec)
            {
                return (this._chunks.length - 1);
            }
            _loc_3 = 0;
            while (_loc_3 < this._chunks.length)
            {
                
                _loc_2 = _loc_2 + this._chunks[_loc_3].durSec;
                if (_loc_2 > param1)
                {
                    return _loc_3;
                }
                _loc_3++;
            }
            return 0;
        }// end function

        public function get totalDurSec() : Number
        {
            return this._totalDurSec;
        }// end function

        public function get totalChunkNumber() : int
        {
            return this._chunks.length;
        }// end function

        public function get bitrate() : Number
        {
            return this._bitrate;
        }// end function

    }
}
