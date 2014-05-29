package com.conviva.pdl.manifest
{

    public class ChunkResource extends Object
    {
        private var _resourceName:String;
        private var _chunkStreams:Array;

        public function ChunkResource(param1:String, param2:Array)
        {
            this._chunkStreams = [];
            this._resourceName = param1;
            var _loc_3:int = 0;
            while (_loc_3 < param2.length)
            {
                
                this._chunkStreams.push(new ChunkStream(param1, param2[_loc_3].bitrate, param2[_loc_3].mp4List));
                _loc_3++;
            }
            return;
        }// end function

        public function get resourceName() : String
        {
            return this._resourceName;
        }// end function

        public function getChunkStream(param1:Number) : ChunkStream
        {
            var _loc_2:ChunkStream = null;
            for each (_loc_2 in this._chunkStreams)
            {
                
                if (_loc_2.bitrate == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function cleanup() : void
        {
            this._chunkStreams = null;
            return;
        }// end function

    }
}
