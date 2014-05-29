package com.cntv.common.model.vo
{

    public class RankingVO extends Object
    {
        public var title:String;
        public var image:String;
        public var url:String;
        public var playCount:String;
        public var rate:Number;

        public function RankingVO(param1:Object)
        {
            this.parseData(param1);
            return;
        }// end function

        public function parseData(param1:Object) : void
        {
            this.title = param1["title"];
            this.image = param1["image"];
            this.url = param1["url"];
            this.playCount = param1["playCount"];
            this.rate = Number(param1["rate"]);
            return;
        }// end function

    }
}
