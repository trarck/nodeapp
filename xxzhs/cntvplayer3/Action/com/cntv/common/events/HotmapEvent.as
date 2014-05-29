package com.cntv.common.events
{
    import flash.events.*;

    public class HotmapEvent extends Event
    {
        public var url:String;
        public var width:Number;
        public var height:Number;
        public var visible:String;
        public var datas:Object;
        public var addr:String = "";
        public var isSlice:Boolean = false;
        public var currentTime:Number = 0;

        public function HotmapEvent(param1:String, param2:Object, param3:Number, param4:Number, param5:String, param6:Boolean = false, param7:Number = 0)
        {
            super(param1, false, false);
            this.datas = param2;
            this.isSlice = param6;
            this.width = param3;
            this.height = param4;
            this.addr = param5;
            this.currentTime = param7;
            return;
        }// end function

    }
}
