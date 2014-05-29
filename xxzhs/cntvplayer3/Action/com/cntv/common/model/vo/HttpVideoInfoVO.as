package com.cntv.common.model.vo
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.tools.string.*;
    import com.utils.net.request.*;

    public class HttpVideoInfoVO extends VideoInfoVo
    {
        private var _id:String;
        private var _title:String;
        private var _isLive:Boolean;
        private var _url:String;
        private var _length:int;
        private var _relation:String;
        private var _imagePath:String;
        private var _chapters:Array;
        private var _chapters2:Array;
        private var _chapters3:Array;
        private var _chapters4:Array;
        private var _chapters5:Array;
        private var _lowChapters:Array;
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
        private var _isCopyOfVod:Boolean = false;
        private var _vddStreamRate:String = "!!!";
        private var _serverName:String = "";
        private var _is_fn_multi_stream:Boolean = false;
        private var _is_protected:Boolean = false;

        public function HttpVideoInfoVO(param1:Object)
        {
            this._chapters = [];
            this._chapters2 = [];
            this._chapters3 = [];
            this._chapters4 = [];
            this._chapters5 = [];
            this._lowChapters = [];
            this._rankingList = [];
            if (param1 != null)
            {
                this.setVideoInfo(param1);
            }
            return;
        }// end function

        override public function setVideoInfo(param1:Object) : void
        {
            var _loc_3:ChapterVO = null;
            var _loc_4:ChapterVO = null;
            var _loc_5:Object = null;
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
            var _loc_2:int = 0;
            if (param1["chapters"] != null)
            {
                this._length = 0;
                _loc_2 = 0;
                while (_loc_2 < param1["chapters"]["length"])
                {
                    
                    _loc_3 = new ChapterVO(param1["chapters"][_loc_2]);
                    this._length = this._length + _loc_3.duration;
                    this._chapters.push(_loc_3);
                    _loc_2++;
                }
                ModelLocator.getInstance().currentVddBitRates.push("STD");
            }
            if (param1["chapters2"] != null)
            {
                this._length = 0;
                _loc_2 = 0;
                while (_loc_2 < param1["chapters2"]["length"])
                {
                    
                    _loc_4 = new ChapterVO(param1["chapters2"][_loc_2]);
                    this._length = this._length + _loc_4.duration;
                    this._chapters2.push(_loc_4);
                    _loc_2++;
                }
                ModelLocator.getInstance().currentVddBitRates.push("HD");
            }
            if (param1["hottag"] != null)
            {
                _loc_5 = {};
                _loc_5.points = param1["hottag"];
                ModelLocator.getInstance().paramVO.hotmapData = _loc_5;
            }
            this._refHtml = RefHtmlGenerator.getRefHtml(ModelLocator.getInstance().paramVO);
            this._refIpadHtml = RefHtmlGenerator.getIpadRefHtml(ModelLocator.getInstance().paramVO);
            this._FlashURL = RefHtmlGenerator.getFlashURL(ModelLocator.getInstance().paramVO);
            this._refURL = RefHtmlGenerator.getRefUrl();
            return;
        }// end function

        override public function setVideoXMLInfo(param1:XML) : VideoInfoVo
        {
            var _loc_3:ChapterVO = null;
            var _loc_4:ChapterVO = null;
            this._length = int(param1.@totalLength);
            this._relation = "public";
            var _loc_2:int = 0;
            if (param1.child("chapters") != null && param1.child("chapters").children().length() != 0)
            {
                if (param1.child("chapters").children().length() > 1)
                {
                    this._length = 0;
                }
                _loc_2 = 0;
                while (_loc_2 < param1.child("chapters").children().length())
                {
                    
                    _loc_3 = new ChapterVO(null);
                    _loc_3.setXMLData(param1.child("chapters").children()[_loc_2]);
                    if (param1.child("chapters").children().length() > 1)
                    {
                        this._length = this._length + _loc_3.duration;
                    }
                    this._chapters.push(_loc_3);
                    _loc_2++;
                }
                ModelLocator.getInstance().currentVddBitRates.push("STD");
            }
            if (param1.child("chapters2") != null && param1.child("chapters2").children().length() != 0)
            {
                if (param1.child("chapters2").children().length() > 1)
                {
                    this._length = 0;
                }
                _loc_2 = 0;
                while (_loc_2 < param1.child("chapters2").children().length())
                {
                    
                    _loc_4 = new ChapterVO(null);
                    _loc_4.setXMLData(param1.child("chapters2").children()[_loc_2]);
                    if (param1.child("chapters2").children().length() > 1)
                    {
                        this._length = this._length + _loc_4.duration;
                    }
                    this._chapters2.push(_loc_4);
                    _loc_2++;
                }
                ModelLocator.getInstance().currentVddBitRates.push("HD");
            }
            this._refHtml = RefHtmlGenerator.getRefHtml(ModelLocator.getInstance().paramVO);
            this._refIpadHtml = RefHtmlGenerator.getIpadRefHtml(ModelLocator.getInstance().paramVO);
            this._FlashURL = RefHtmlGenerator.getFlashURL(ModelLocator.getInstance().paramVO);
            this._refURL = RefHtmlGenerator.getRefUrl();
            return this;
        }// end function

        override public function setVMSInfo(param1:Object) : VideoInfoVo
        {
            var _loc_5:ChapterVO = null;
            var _loc_6:Number = NaN;
            var _loc_7:Array = null;
            var _loc_8:ValueOBJ = null;
            var _loc_9:ChapterVO = null;
            var _loc_10:ChapterVO = null;
            var _loc_11:ChapterVO = null;
            var _loc_12:ChapterVO = null;
            var _loc_13:ChapterVO = null;
            var _loc_14:ChapterVO = null;
            var _loc_15:String = null;
            var _loc_16:Object = null;
            var _loc_2:* = param1["video"];
            this._length = 0;
            this._relation = "public";
            if (param1["is_invalid_copyright"] == "1")
            {
                this._is_invalid_copyright = true;
            }
            else
            {
                this._is_invalid_copyright = false;
            }
            if (String(param1["is_fn_multi_stream"]) == "true")
            {
                this._is_fn_multi_stream = true;
                ModelLocator.getInstance().isConvivaMode = true;
            }
            if (param1["is_protected"] == "1")
            {
                this.is_protected = true;
            }
            if (param1["title"] != null)
            {
                this._title = param1["title"];
            }
            if (!ModelLocator.getInstance().isReadedCookie && param1["version"] != null && param1["version"] != "")
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
                        if (!ModelLocator.getInstance().ISWEBSITE)
                        {
                            this._vddStreamRate = "STD";
                        }
                    }
                    else if (param1["default_stream"] == null)
                    {
                        _loc_7 = [];
                        _loc_8 = new ValueOBJ("t", "nsf");
                        _loc_7.push(_loc_8);
                        _loc_8 = new ValueOBJ("v", "nsf");
                        _loc_7.push(_loc_8);
                        GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_NOTICE_STREAM_RATE_FAILED, _loc_7));
                    }
                }
            }
            if (param1["is_abroad"] != null && param1["is_abroad"] == "true")
            {
                ModelLocator.getInstance().paramVO.is_abroad = true;
            }
            if (String(param1["is_p2p_use"]) == "false")
            {
                ModelLocator.getInstance().isP2pMode = false;
            }
            var _loc_3:* = param1["lc"];
            if (_loc_3 != null)
            {
                if (_loc_3["country_code"] != "CN" && _loc_3["country_code"] != null && _loc_3["country_code"] != "")
                {
                    ModelLocator.getInstance().isP2pMode = false;
                }
            }
            var _loc_4:int = 0;
            if (_loc_2["chapters"] != null)
            {
                this._imagePath = _loc_2["chapters"][0]["image"];
                this._length = 0;
                _loc_4 = 0;
                while (_loc_4 < _loc_2["chapters"]["length"])
                {
                    
                    _loc_9 = new ChapterVO(_loc_2["chapters"][_loc_4]);
                    this._length = this._length + _loc_9.duration;
                    this._chapters.push(_loc_9);
                    _loc_4++;
                }
                ModelLocator.getInstance().currentVddBitRates.push("STD");
            }
            if (_loc_2["chapters2"] != null)
            {
                this._length = 0;
                _loc_4 = 0;
                while (_loc_4 < _loc_2["chapters2"]["length"])
                {
                    
                    _loc_10 = new ChapterVO(_loc_2["chapters2"][_loc_4]);
                    this._length = this._length + _loc_10.duration;
                    this._chapters2.push(_loc_10);
                    _loc_4++;
                }
                ModelLocator.getInstance().currentVddBitRates.push("HD");
            }
            if (_loc_2["chapters3"] != null)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_2["chapters3"]["length"])
                {
                    
                    _loc_11 = new ChapterVO(_loc_2["chapters3"][_loc_4]);
                    this._chapters3.push(_loc_11);
                    _loc_4++;
                }
            }
            if (_loc_2["chapters4"] != null)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_2["chapters4"]["length"])
                {
                    
                    _loc_12 = new ChapterVO(_loc_2["chapters4"][_loc_4]);
                    this._chapters4.push(_loc_12);
                    _loc_4++;
                }
            }
            if (_loc_2["chapters5"] != null)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_2["chapters5"]["length"])
                {
                    
                    _loc_13 = new ChapterVO(_loc_2["chapters5"][_loc_4]);
                    this._chapters5.push(_loc_13);
                    _loc_4++;
                }
            }
            if (_loc_2["lowChapters"] != null)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_2["lowChapters"]["length"])
                {
                    
                    _loc_14 = new ChapterVO(_loc_2["lowChapters"][_loc_4]);
                    this._lowChapters.push(_loc_14);
                    _loc_4++;
                }
                ModelLocator.getInstance().currentVddBitRates.push("LD");
            }
            if (this._chapters.length > 0)
            {
                _loc_5 = this._chapters[0];
            }
            else if (this._chapters2.length > 0)
            {
                _loc_5 = this._chapters2[0];
            }
            _loc_6 = _loc_5.url.indexOf("http://");
            if (_loc_6 >= 0)
            {
                _loc_15 = _loc_5.url.slice(7);
                _loc_6 = _loc_15.indexOf("/");
                this.serverName = _loc_15.slice(0, _loc_6);
            }
            if (param1["hottag"] != null)
            {
                _loc_16 = {};
                _loc_16.points = param1["hottag"];
                ModelLocator.getInstance().paramVO.hotmapData = _loc_16;
            }
            this._refHtml = RefHtmlGenerator.getRefHtml(ModelLocator.getInstance().paramVO);
            this._refIpadHtml = RefHtmlGenerator.getIpadRefHtml(ModelLocator.getInstance().paramVO);
            this._FlashURL = RefHtmlGenerator.getFlashURL(ModelLocator.getInstance().paramVO);
            this._refURL = RefHtmlGenerator.getRefUrl();
            return this;
        }// end function

        public function updateVideoInfo(param1:Object) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_2:* = this.setVMSInfo(param1);
            var _loc_3:* = ModelLocator.getInstance().currentVideoInfo;
            if (_loc_2.chapters.length > _loc_3.chapters.length)
            {
                _loc_4 = _loc_3.chapters.length;
                while (_loc_4 < _loc_2.chapters.length)
                {
                    
                    _loc_3.chapters.push(_loc_2.chapters[_loc_4]);
                    _loc_4 = _loc_4 + 1;
                }
            }
            if (_loc_2.chapters2.length > _loc_3.chapters2.length)
            {
                _loc_5 = _loc_3.chapters2.length;
                while (_loc_5 < _loc_2.chapters2.length)
                {
                    
                    _loc_3.chapters2.push(_loc_2.chapters2[_loc_5]);
                    _loc_5 = _loc_5 + 1;
                }
            }
            _loc_2.chapters = _loc_3.chapters;
            _loc_2.chapters2 = _loc_3.chapters2;
            ModelLocator.getInstance().currentVideoInfo = _loc_2;
            return;
        }// end function

        override public function get id() : String
        {
            return this._id;
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
            return false;
        }// end function

        override public function get chapters() : Array
        {
            return this._chapters;
        }// end function

        override public function set chapters(param1:Array) : void
        {
            this._chapters = param1;
            return;
        }// end function

        override public function get chapters2() : Array
        {
            return this._chapters2;
        }// end function

        override public function set chapters2(param1:Array) : void
        {
            this._chapters2 = param1;
            return;
        }// end function

        override public function get chapters3() : Array
        {
            return this._chapters3;
        }// end function

        override public function set chapters3(param1:Array) : void
        {
            this._chapters3 = param1;
            return;
        }// end function

        override public function get chapters4() : Array
        {
            return this._chapters4;
        }// end function

        override public function set chapters4(param1:Array) : void
        {
            this._chapters4 = param1;
            return;
        }// end function

        override public function get chapters5() : Array
        {
            return this._chapters5;
        }// end function

        override public function set chapters5(param1:Array) : void
        {
            this._chapters5 = param1;
            return;
        }// end function

        override public function get lowChapters() : Array
        {
            return this._lowChapters;
        }// end function

        override public function set lowChapters(param1:Array) : void
        {
            this._lowChapters = param1;
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

        override public function set refHtml(param1:String) : void
        {
            this._refHtml = param1;
            return;
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

        override public function get isCopyOfVod() : Boolean
        {
            return this._isCopyOfVod;
        }// end function

        override public function set isCopyOfVod(param1:Boolean) : void
        {
            this._isCopyOfVod = param1;
            return;
        }// end function

        override public function get is_fn_multi_stream() : Boolean
        {
            return this._is_fn_multi_stream;
        }// end function

        override public function set is_fn_multi_stream(param1:Boolean) : void
        {
            this._is_fn_multi_stream = param1;
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

        public static function cloneFromRtmp(param1:VideoInfoVo) : HttpVideoInfoVO
        {
            var _loc_2:HttpVideoInfoVO = null;
            var _loc_6:ChapterVO = null;
            _loc_2 = new HttpVideoInfoVO(null);
            _loc_2.isCopyOfVod = true;
            _loc_2.length = param1.length;
            _loc_2.id = param1.id;
            _loc_2.title = param1.title;
            _loc_2.url = param1.url;
            _loc_2.relation = param1.relation;
            var _loc_3:Array = [];
            var _loc_4:Array = [];
            var _loc_5:int = 0;
            while (_loc_5 < param1.p2pStreams.length)
            {
                
                if (_loc_5 == 0)
                {
                    _loc_6 = new ChapterVO(null);
                    _loc_6.duration = 0;
                    _loc_6.url = param1.p2pStreams[_loc_5]["streamName"];
                    _loc_3.push(_loc_6);
                    _loc_2.chapters = _loc_3;
                }
                if (_loc_5 == 1)
                {
                    _loc_6 = new ChapterVO(null);
                    _loc_6.duration = 0;
                    _loc_6.url = param1.p2pStreams[_loc_5]["streamName"];
                    _loc_4.push(_loc_6);
                    _loc_2.chapters2 = _loc_4;
                }
                _loc_5++;
            }
            _loc_2.refHtml = RefHtmlGenerator.getRefHtml(ModelLocator.getInstance().paramVO);
            _loc_2.refURL = RefHtmlGenerator.getRefUrl();
            return _loc_2;
        }// end function

    }
}
