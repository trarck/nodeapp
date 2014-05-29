package com.cntv.common.model.vo
{
    import com.cntv.common.model.parser.*;

    public class ADVO extends Object
    {
        public var id:String;
        public var time:String;
        public var during:int = 20;
        public var type:String;
        public var url:String;
        public var adLink:String;
        public var adlink2:String;
        public var text:String;
        public var loadcount:String;
        public var overcount:String;
        public var loadcount2:String = "";
        public var overcount2:String = "";
        public var invent:String = "";
        public var invent1:String = "";
        public var pic:String;
        public var adType:String;
        public var thirdloadcount:String = "";
        public var adselectorinit:String = "";
        public var startcount:String = "";
        public var middlecount:String = "";
        public var middletime:String = "";
        public var selectortime:String = "";
        public static const TYPE_VIDEO:String = "1";
        public static const TYPE_IMAGE:String = "2";
        public static const TYPE_SWF:String = "3";

        public function ADVO(param1:XML)
        {
            if (param1 != null)
            {
                this.id = param1.@id;
                this.time = param1.@time;
                this.during = int(param1.@during);
                this.type = param1.@type;
                this.url = param1.@url;
                this.adLink = param1.@adLink;
                this.invent = param1.@invent;
                this.invent1 = param1.@invent1;
            }
            return;
        }// end function

        public function parseObject(param1:Object) : void
        {
            if (param1 != null)
            {
                this.id = param1["id"];
                this.time = param1["time"];
                if (param1["during"])
                {
                    this.during = int(param1["during"]);
                }
                this.type = param1["type"];
                this.url = param1["url"];
                this.adLink = param1["adLink"];
                this.invent = param1["invent"];
                this.invent1 = param1["invent1"];
            }
            return;
        }// end function

        public function parseNewXML(param1:XML, param2:String) : ADVO
        {
            this.id = param1.@id;
            this.type = ContentTypeParser.parseType(param1.@type);
            this.text = param1.child("text").toString();
            this.url = unescape(param1.child("url").toString());
            this.adLink = unescape(param1.child("adlink").toString());
            if (this.adLink.indexOf("Redirect=null") > 0)
            {
                this.adLink = "";
            }
            this.loadcount = unescape(param1.child("loadcount").toString());
            this.overcount = unescape(param1.child("overcount").toString());
            if (param1.@duration != null && param1.@duration != "")
            {
                this.during = int(param1.@duration);
            }
            else if (param1.@during != null && param1.@during != "")
            {
                this.during = int(param1.@during);
            }
            if (param1.child("adlink2") != null)
            {
                this.adlink2 = unescape(param1.child("adlink2"));
            }
            if (this.adlink2.indexOf("Redirect=null") > 0)
            {
                this.adlink2 = "";
            }
            if (param1.child("loadcount2") != null)
            {
                this.loadcount2 = unescape(param1.child("loadcount2").toString());
                this.overcount2 = unescape(param1.child("overcount2").toString());
            }
            if (param1.child("invent") != null)
            {
                this.invent = unescape(param1.child("invent").toString());
            }
            if (param1.child("invent1") != null)
            {
                this.invent1 = unescape(param1.child("invent1").toString());
            }
            if (param1.child("thirdloadcount") != null && param1.child("thirdloadcount") != "")
            {
                this.thirdloadcount = unescape(param1.child("thirdloadcount").toString());
            }
            if (param1.child("adselectorinit") != null && param1.child("adselectorinit") != "")
            {
                this.adselectorinit = unescape(param1.child("adselectorinit").toString());
            }
            if (param1.child("selectortime") != null && param1.child("selectortime") != "")
            {
                this.selectortime = unescape(param1.child("selectortime").toString());
            }
            if (param1.child("startcount") != null && param1.child("startcount") != "")
            {
                this.startcount = unescape(param1.child("startcount").toString());
            }
            if (param1.child("middlecount") != null && param1.child("middlecount") != "")
            {
                this.middlecount = unescape(param1.child("middlecount").toString());
                this.middletime = param1.child("middlecount").@m;
            }
            this.pic = unescape(param1.child("pic").toString());
            this.adType = param2;
            return this;
        }// end function

    }
}
