package com.conviva.pdl
{

    public class ChunkErrorEvent extends Object
    {
        public static const EVENT_TYPE_STREAM_NOT_FOUNT:String = "Ck.NotFound";
        public static const EVENT_TYPE_CHUNK_LOAD_ERROR:String = "Ck.Play.Failed";
        public static const EVENT_TYPE_CHUNK_MEDIA_ERROR:String = "Ck.Failed";
        public static const EVENT_TYPE_SKIP_ERROR_CHUNK:String = "Ck.Skip";
        public static const EVENT_TYPE_CHUNK_START_TIME:String = "Ck.StartTime";
        public static const EVENT_TYPE_INTEGRATION_INFO:String = "Ck.Integration";

        public function ChunkErrorEvent()
        {
            return;
        }// end function

    }
}
