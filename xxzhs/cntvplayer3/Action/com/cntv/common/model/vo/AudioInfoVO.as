package com.cntv.common.model.vo
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.string.*;

    public class AudioInfoVO extends VideoInfoVo
    {
        private var _id:String;
        private var _title:String;
        private var _isLive:Boolean;
        private var _length:int;
        private var _audioURL:String;
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
        private var _refURL:String;
        private var _rankingList:Array;
        private var _is_invalid_copyright:Boolean = false;

        public function AudioInfoVO(param1:Object)
        {
            this._rankingList = [];
            if (param1 != null)
            {
            }
            return;
        }// end function

        override public function setVMSInfo(param1:Object) : VideoInfoVo
        {
            if (param1["is_invalid_copyright"] == "1")
            {
                this._is_invalid_copyright = true;
            }
            else
            {
                this._is_invalid_copyright = false;
            }
            if (param1["videoid"] != null)
            {
                this._id = param1["videoid"];
            }
            if (param1["title"] != null)
            {
                this._title = param1["title"];
            }
            if (param1["duration"] != null)
            {
                if (param1["mp3chapters"][0]["duration"] != "NULL")
                {
                    this._length = int(param1["mp3chapters"][0]["duration"]);
                }
                else
                {
                    this._length = 0;
                }
            }
            if (param1["mp3chapters"][0])
            {
                this._audioURL = param1["mp3chapters"][0]["url"];
            }
            else if (param1["chapters"] && String(param1["chapters"][0]["url"]).indexOf(".mp3") > 0)
            {
                this._audioURL = param1["mp3chapters"][0]["url"];
            }
            this._refHtml = RefHtmlGenerator.getAudioRefHtml(ModelLocator.getInstance().paramVO);
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

        override public function get isAudio() : Boolean
        {
            return true;
        }// end function

        override public function set isAudio(param1:Boolean) : void
        {
            super.isAudio = param1;
            return;
        }// end function

        override public function get audioUrl() : String
        {
            return this._audioURL;
        }// end function

        override public function set audioUrl(param1:String) : void
        {
            this._audioURL = param1;
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

    }
}
