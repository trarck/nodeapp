package com.cntv.common.model.vo
{
    import com.puremvc.model.vo.*;

    public class StreamVO extends ValueObject
    {
        public var rtmpHost:String;
        public var rtmptHost:String;
        public var streamName:String;
        public var bitRate:String;
        public var streamMode:String = "";
        private var p2pHost:String = "http://v.cctv.com/rtmp/";

        public function StreamVO(param1:Object)
        {
            if (param1 != null)
            {
                this.parseData(param1);
            }
            return;
        }// end function

        public function parseData(param1:Object) : void
        {
            this.rtmpHost = param1["rtmpHost"];
            this.rtmptHost = this.rtmpHost.replace("rtmp://", "rtmpt://");
            this.streamName = param1["streamName"];
            this.bitRate = param1["bitRate"];
            return;
        }// end function

        public function parseXMLData(param1:XML) : StreamVO
        {
            this.rtmpHost = param1.@host;
            this.streamName = param1.@streamName;
            this.bitRate = param1.@bitRate;
            return this;
        }// end function

        public function parseP2pData(param1:Object) : StreamVO
        {
            this.rtmpHost = null;
            this.streamName = this.p2pHost + String(param1["streamName"]).replace("mp4:v/", "");
            this.bitRate = param1["bitRate"];
            return this;
        }// end function

        public function getP2pUrl() : String
        {
            return this.p2pHost + this.streamName.replace("mp4:v/", "");
        }// end function

        public function parseP2pXMLData(param1:XML) : StreamVO
        {
            this.rtmpHost = null;
            this.streamName = this.p2pHost + param1.@streamName;
            this.bitRate = param1.@bitRate;
            return this;
        }// end function

    }
}
