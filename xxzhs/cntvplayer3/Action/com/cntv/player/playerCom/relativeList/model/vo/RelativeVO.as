package com.cntv.player.playerCom.relativeList.model.vo
{

    public class RelativeVO extends Object
    {
        public var icon:String;
        public var desc:String;
        public var url:String;
        public var time:String;

        public function RelativeVO(param1:XML)
        {
            if (param1 != null)
            {
                this.icon = param1.@icon;
                this.desc = param1.@desc;
                this.url = param1.@url;
                this.time = param1.@time;
            }
            return;
        }// end function

        public function toString() : String
        {
            return this.icon + "-" + this.desc + "-" + this.url;
        }// end function

    }
}
