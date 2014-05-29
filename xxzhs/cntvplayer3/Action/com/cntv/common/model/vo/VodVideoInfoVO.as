package com.cntv.common.model.vo
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.tools.string.*;
    import com.utils.net.request.*;

    public class VodVideoInfoVO extends VideoInfoVo
    {
        private var _id:String;
        private var _title:String;
        private var _isLive:Boolean;
        private var _url:String;
        private var _length:int;
        private var _relation:String;
        private var _imagePath:String;
        private var _streams:Array;
        private var _p2pStreams:Array;
        private var _upCount:int;
        private var _downCount:int;
        private var _isRate:Boolean;
        private var _isCollect:Boolean = false;
        private var _digOper:String = "null";
        private var _userName:String;
        private var _playCount:int;
        private var _rateCount:int;
        private var _rate:Number;
        private var _userIP:String;
        private var _refHtml:String;
        private var _refIpadHtml:String;
        private var _FlashURL:String;
        private var _refURL:String;
        private var _rankingList:Array;
        private var _is_invalid_copyright:Boolean = false;
        private var _vddStreamRate:String = "";
        private var _serverName:String = "";
        private var _is_protected:Boolean = false;

        public function VodVideoInfoVO(param1:Object)
        {
            this._streams = [];
            this._p2pStreams = [];
            this._rankingList = [];
            if (param1 != null)
            {
                this.setVideoInfo(param1);
            }
            return;
        }// end function

        override public function setVideoInfo(param1:Object) : void
        {
            var _loc_2:int = 0;
            var _loc_3:StreamVO = null;
            var _loc_4:StreamVO = null;
            var _loc_5:Array = null;
            var _loc_6:Object = null;
            if (param1["videoid"] != null)
            {
                this._id = param1["videoid"];
            }
            if (param1["title"] != null)
            {
                this._title = param1["title"];
            }
            if (param1["url"] != null)
            {
                this._url = param1["url"];
            }
            if (param1["duration"] != null)
            {
                this._length = int(param1["duration"]);
            }
            if (param1["relation"] != null)
            {
                this._relation = param1["relation"];
            }
            if (param1["imagePath"] != null)
            {
                this._imagePath = param1["imagePath"];
            }
            if (param1["streams"] != null)
            {
                _loc_2 = 0;
                while (_loc_2 < param1["streams"]["length"])
                {
                    
                    _loc_3 = new StreamVO(param1["streams"][_loc_2]);
                    _loc_4 = new StreamVO(null).parseP2pData(param1["streams"][_loc_2]);
                    _loc_5 = ModelLocator.getInstance().vddBitRates;
                    if (Number(_loc_3.bitRate) <= 300)
                    {
                        _loc_3.streamMode = _loc_5[0];
                    }
                    else if (Number(_loc_3.bitRate) <= 500)
                    {
                        _loc_3.streamMode = _loc_5[1];
                    }
                    else if (Number(_loc_3.bitRate) <= 900)
                    {
                        _loc_3.streamMode = _loc_5[2];
                    }
                    else if (Number(_loc_3.bitRate) <= 1500)
                    {
                        _loc_3.streamMode = _loc_5[3];
                    }
                    ModelLocator.getInstance().currentVddBitRates.push(_loc_3.streamMode);
                    this._streams.push(_loc_3);
                    this._p2pStreams.push(_loc_4);
                    _loc_2++;
                }
            }
            if (param1["hottag"] != null)
            {
                _loc_6 = {};
                _loc_6.points = param1["hottag"];
                ModelLocator.getInstance().paramVO.hotmapData = _loc_6;
            }
            this._refHtml = RefHtmlGenerator.getRefHtml(ModelLocator.getInstance().paramVO);
            this._refIpadHtml = RefHtmlGenerator.getIpadRefHtml(ModelLocator.getInstance().paramVO);
            this._FlashURL = RefHtmlGenerator.getFlashURL(ModelLocator.getInstance().paramVO);
            this._refURL = RefHtmlGenerator.getRefUrl();
            return;
        }// end function

        override public function setVideoXMLInfo(param1:XML) : VideoInfoVo
        {
            var _loc_2:int = 0;
            var _loc_3:StreamVO = null;
            var _loc_4:StreamVO = null;
            this._relation = "public";
            this._length = param1.@totalLength;
            if (param1.child("streams") != null)
            {
                _loc_2 = 0;
                while (_loc_2 < param1.child("streams").children().length())
                {
                    
                    _loc_3 = new StreamVO(null).parseXMLData(param1.child("streams").children()[_loc_2]);
                    _loc_4 = new StreamVO(null).parseP2pXMLData(param1.child("streams").children()[_loc_2]);
                    this._streams.push(_loc_3);
                    this._p2pStreams.push(_loc_4);
                    _loc_2++;
                }
            }
            this._refHtml = RefHtmlGenerator.getRefHtml(ModelLocator.getInstance().paramVO);
            this._refIpadHtml = RefHtmlGenerator.getIpadRefHtml(ModelLocator.getInstance().paramVO);
            this._FlashURL = RefHtmlGenerator.getFlashURL(ModelLocator.getInstance().paramVO);
            this._refURL = RefHtmlGenerator.getRefUrl();
            return this;
        }// end function

        override public function setVMSInfo(param1:Object) : VideoInfoVo
        {
            var _loc_3:Array = null;
            var _loc_4:ValueOBJ = null;
            var _loc_5:int = 0;
            var _loc_6:StreamVO = null;
            var _loc_7:StreamVO = null;
            var _loc_8:Array = null;
            var _loc_9:Number = NaN;
            var _loc_10:String = null;
            var _loc_11:Object = null;
            var _loc_2:* = param1["video"];
            this._relation = "public";
            this._length = 0;
            if (param1["is_invalid_copyright"] == "1")
            {
                this._is_invalid_copyright = true;
            }
            else
            {
                this._is_invalid_copyright = false;
            }
            if (param1["title"] != null)
            {
                this._title = param1["title"];
            }
            if (param1["is_protected"] == "1")
            {
                this.is_protected = true;
            }
            if (param1["version"] != null && param1["version"] != "")
            {
                if (Number(param1["version"]) == 0.1)
                {
                    this._vddStreamRate = ModelLocator.getInstance().vddBitRates[2];
                }
                else if (Number(param1["version"]) >= 0.2)
                {
                    if (param1["default_stream"] != null)
                    {
                        this._vddStreamRate = param1["default_stream"];
                    }
                    else if (param1["default_stream"] == null)
                    {
                        _loc_3 = [];
                        _loc_4 = new ValueOBJ("t", "nsf");
                        _loc_3.push(_loc_4);
                        _loc_4 = new ValueOBJ("v", "nsf");
                        _loc_3.push(_loc_4);
                        GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_NOTICE_STREAM_RATE_FAILED, _loc_3));
                    }
                }
            }
            if (param1["is_abroad"] != null && param1["is_abroad"] == "true")
            {
                ModelLocator.getInstance().paramVO.is_abroad = true;
            }
            if (_loc_2["streams"] != null)
            {
                _loc_5 = 0;
                while (_loc_5 < _loc_2["streams"]["length"])
                {
                    
                    _loc_6 = new StreamVO(_loc_2["streams"][_loc_5]);
                    _loc_7 = new StreamVO(null).parseP2pData(_loc_2["streams"][_loc_5]);
                    _loc_8 = ModelLocator.getInstance().vddBitRates;
                    if (Number(_loc_6.bitRate) <= 300)
                    {
                        _loc_6.streamMode = _loc_8[0];
                    }
                    else if (Number(_loc_6.bitRate) <= 500)
                    {
                        _loc_6.streamMode = _loc_8[1];
                    }
                    else if (Number(_loc_6.bitRate) <= 900)
                    {
                        _loc_6.streamMode = _loc_8[2];
                    }
                    else if (Number(_loc_6.bitRate) <= 1500)
                    {
                        _loc_6.streamMode = _loc_8[3];
                    }
                    ModelLocator.getInstance().currentVddBitRates.push(_loc_6.streamMode);
                    this._streams.push(_loc_6);
                    this._p2pStreams.push(_loc_7);
                    _loc_5++;
                }
                if (_loc_2["streams"].length > 0)
                {
                    _loc_9 = _loc_2["streams"][0]["rtmpHost"].indexOf("rtmp://");
                    if (_loc_9 >= 0)
                    {
                        _loc_10 = _loc_2["streams"][0]["rtmpHost"].slice(7);
                        _loc_9 = _loc_10.indexOf("/");
                        this.serverName = _loc_10.slice(0, _loc_9);
                    }
                }
            }
            if (param1["hottag"] != null)
            {
                _loc_11 = {};
                _loc_11.points = param1["hottag"];
                ModelLocator.getInstance().paramVO.hotmapData = _loc_11;
            }
            this._refHtml = RefHtmlGenerator.getRefHtml(ModelLocator.getInstance().paramVO);
            this._refIpadHtml = RefHtmlGenerator.getIpadRefHtml(ModelLocator.getInstance().paramVO);
            this._FlashURL = RefHtmlGenerator.getFlashURL(ModelLocator.getInstance().paramVO);
            this._refURL = RefHtmlGenerator.getRefUrl();
            return this;
        }// end function

        override public function get id() : String
        {
            return this._id;
        }// end function

        override public function set id(param1:String) : void
        {
            this._id = param1;
            return;
        }// end function

        override public function get title() : String
        {
            return this._title;
        }// end function

        override public function set title(param1:String) : void
        {
            this._title = param1;
            return;
        }// end function

        override public function get url() : String
        {
            return this._url;
        }// end function

        override public function set url(param1:String) : void
        {
            this._url = param1;
            return;
        }// end function

        override public function get length() : int
        {
            return this._length;
        }// end function

        override public function set length(param1:int) : void
        {
            this._length = param1;
            return;
        }// end function

        override public function get isLive() : Boolean
        {
            return false;
        }// end function

        override public function set isLive(param1:Boolean) : void
        {
            this._isLive = param1;
            return;
        }// end function

        override public function get isRtmp() : Boolean
        {
            return true;
        }// end function

        override public function get streams() : Array
        {
            return this._streams;
        }// end function

        override public function set streams(param1:Array) : void
        {
            this._streams = param1;
            return;
        }// end function

        override public function get vddStreamRate() : String
        {
            return this._vddStreamRate;
        }// end function

        override public function set vddStreamRate(param1:String) : void
        {
            this._vddStreamRate = param1;
            return;
        }// end function

        override public function get imagePath() : String
        {
            return this._imagePath;
        }// end function

        override public function set imagePath(param1:String) : void
        {
            this._imagePath = param1;
            return;
        }// end function

        override public function get relation() : String
        {
            return this._relation;
        }// end function

        override public function set relation(param1:String) : void
        {
            this._relation = param1;
            return;
        }// end function

        override public function setInteractiveData(param1:Object) : void
        {
            var _loc_2:int = 0;
            this._upCount = param1["upCount"];
            this._downCount = param1["downCount"];
            this._digOper = param1["digOper"];
            this._isRate = param1["isRate"] == "true";
            this._userName = param1["userName"];
            this._playCount = param1["playCount"];
            this._rateCount = param1["rateCount"];
            this._rate = param1["rate"];
            this._userIP = param1["userIP"];
            if (param1["rankingList"] != null)
            {
                _loc_2 = 0;
                while (_loc_2 < param1["rankingList"]["length"])
                {
                    
                    this._rankingList.push(new RankingVO(param1["rankingList"][_loc_2]));
                    _loc_2++;
                }
            }
            return;
        }// end function

        override public function get upCount() : int
        {
            return this._upCount;
        }// end function

        override public function set upCount(param1:int) : void
        {
            this._upCount = param1;
            return;
        }// end function

        override public function get downCount() : int
        {
            return this._downCount;
        }// end function

        override public function set downCount(param1:int) : void
        {
            this._downCount = param1;
            return;
        }// end function

        override public function get digOper() : String
        {
            return this._digOper;
        }// end function

        override public function set digOper(param1:String) : void
        {
            this._digOper = param1;
            return;
        }// end function

        override public function get isRate() : Boolean
        {
            return this._isRate;
        }// end function

        override public function set isRate(param1:Boolean) : void
        {
            this._isRate = param1;
            return;
        }// end function

        override public function get userName() : String
        {
            return this._userName;
        }// end function

        override public function set userName(param1:String) : void
        {
            this._userName = param1;
            return;
        }// end function

        override public function get playCount() : int
        {
            return this._playCount;
        }// end function

        override public function set playCount(param1:int) : void
        {
            this._playCount = param1;
            return;
        }// end function

        override public function get rateCount() : int
        {
            return this._rateCount;
        }// end function

        override public function set rateCount(param1:int) : void
        {
            this._rateCount = param1;
            return;
        }// end function

        override public function get rate() : Number
        {
            return this._rate;
        }// end function

        override public function set rate(param1:Number) : void
        {
            this._rate = param1;
            return;
        }// end function

        override public function get userIP() : String
        {
            return this._userIP;
        }// end function

        override public function set userIP(param1:String) : void
        {
            this._userIP = param1;
            return;
        }// end function

        override public function get refHtml() : String
        {
            return this._refHtml == null ? ("") : (this._refHtml);
        }// end function

        override public function get refIpadHtml() : String
        {
            return this._refIpadHtml == null ? ("") : (this._refIpadHtml);
        }// end function

        override public function get FlashURL() : String
        {
            return this._FlashURL == null ? ("") : (this._FlashURL);
        }// end function

        override public function set FlashURL(param1:String) : void
        {
            this._FlashURL = param1;
            return;
        }// end function

        override public function set refHtml(param1:String) : void
        {
            this._refHtml = param1;
            return;
        }// end function

        override public function get refURL() : String
        {
            return this._refURL == null ? ("") : (this._refURL);
        }// end function

        override public function set refURL(param1:String) : void
        {
            this._refURL = param1;
            return;
        }// end function

        override public function get rankingList() : Array
        {
            return this._rankingList;
        }// end function

        override public function set rankingList(param1:Array) : void
        {
            this._rankingList = param1;
            return;
        }// end function

        override public function get isCollect() : Boolean
        {
            return this._isCollect;
        }// end function

        override public function set isCollect(param1:Boolean) : void
        {
            this._isCollect = param1;
            return;
        }// end function

        override public function get is_invalid_copyright() : Boolean
        {
            return this._is_invalid_copyright;
        }// end function

        override public function get p2pStreams() : Array
        {
            return this._p2pStreams;
        }// end function

        override public function set p2pStreams(param1:Array) : void
        {
            this._p2pStreams = param1;
            return;
        }// end function

        override public function get serverName() : String
        {
            return this._serverName;
        }// end function

        override public function set serverName(param1:String) : void
        {
            this._serverName = param1;
            return;
        }// end function

        override public function get is_protected() : Boolean
        {
            return this._is_protected;
        }// end function

        override public function set is_protected(param1:Boolean) : void
        {
            this._is_protected = param1;
            return;
        }// end function

    }
}
