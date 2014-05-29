package com.cntv.common.model.vo
{
    import com.cntv.common.tools.graphics.*;
    import com.cntv.common.tools.memory.*;
    import com.cntv.common.tools.psFilterTool.*;
    import com.puremvc.model.vo.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class ChapterVO extends ValueObject
    {
        public var id:Number;
        public var url:String;
        public var duration:int;
        public var image:String = "";
        public var loaded:Boolean = false;
        public var chapterStart:Number = -1;
        public var cacheStart:Number = -1;
        public var video:Video;
        public var ns:NetStream;
        public var isLoadComp:Boolean = false;
        public var isCacheComp:Boolean;
        public var localData:Object;
        public var onMetaData2:Function;
        public var isUseingCatch:Boolean = false;
        public var seekingTime:Number = 0;
        public var psFilter:PSFilterTools;
        public var rotationSetter:DynamicRegistration;
        public static var brightness:Number = -1;
        public static var contrast:Number = -1;
        public static var vx:Number = 0;
        public static var vy:Number = 0;
        public static var vr:Number = 0;

        public function ChapterVO(param1:Object)
        {
            if (param1 != null)
            {
                this.url = param1["url"];
                this.duration = param1["duration"];
            }
            return;
        }// end function

        public function setXMLData(param1:XML) : void
        {
            this.url = param1.@url;
            this.duration = param1.@duration;
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            this.localData = param1;
            if (this.isUseingCatch)
            {
                this.ns.pause();
                setTimeout(this.checkCache, 500);
            }
            else
            {
                this.onMetaData2(param1);
            }
            return;
        }// end function

        private function checkCache() : void
        {
            var _loc_1:* = this.seekingTime - this.cacheStart;
            this.isUseingCatch = false;
            if (this.ns.bytesLoaded >= this.ns.bytesTotal && this.ns.bytesLoaded > 0 && this.localData.duration > _loc_1)
            {
                this.ns.resume();
                this.ns.seek(_loc_1);
                this.onMetaData2(this.localData);
            }
            else
            {
                if (this.chapterStart == -1)
                {
                    this.chapterStart = this.seekingTime;
                }
                this.ns.close();
                this.ns.play(this.url + "?start=" + this.seekingTime);
                MemClean.run();
            }
            return;
        }// end function

    }
}
