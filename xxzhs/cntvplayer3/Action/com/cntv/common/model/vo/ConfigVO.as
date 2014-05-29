package com.cntv.common.model.vo
{
    import com.cntv.common.model.*;
    import com.puremvc.model.vo.*;

    public class ConfigVO extends ValueObject
    {
        public var rtmpVODHost:String = "rtmp://localhost/vod";
        public var rtmpLiveHost:String = "rtmp://localhost/live";
        private var _videoInfoURL:String = "";
        private var _videoInfoParam1:String;
        private var _interactiveInfoURL:String;
        private var _interactiveInfoParam1:String;
        private var _interactiveInfoParam2:String;
        private var _rankingListURL:String;
        private var _digURL:String;
        private var _digParam1:String;
        private var _digParam2:String;
        private var _digParam3:String;
        private var _rateURL:String;
        private var _rateParam1:String;
        private var _rateParam2:String;
        private var _rateParam3:String;
        private var _rateParam4:String;
        private var _rateParam5:String;
        private var _rateParam6:String;
        private var _rateParam7:String;
        private var _favoriteURL:String;
        private var _favoriteParam1:String;
        private var _favoriteParam2:String;
        private var _buguListURL:String;
        private var _buguListParam1:String;
        private var _buguListParam2:String;
        private var _suggestionURL:String;
        private var _suggestionParam1:String;
        private var _suggestionParam2:String;
        private var _suggestionParam3:String;
        private var _adplayerPath:String = "";
        private var _pauseAdplayerPath:String = "";

        public function ConfigVO(param1:XML)
        {
            if (param1 != null)
            {
                if (ModelLocator.getInstance().ISWEBSITE)
                {
                    this.parseXML(param1);
                }
                else
                {
                    this.parseXML2(param1);
                }
            }
            return;
        }// end function

        public function parseXML(param1:XML) : void
        {
            this._videoInfoURL = param1.child("videoInfo").toString();
            this._videoInfoParam1 = param1.child("videoInfo").@parameter;
            this._interactiveInfoURL = param1.child("interactiveInfo").toString();
            this._interactiveInfoParam1 = param1.child("interactiveInfo").@parameter;
            this._interactiveInfoParam2 = param1.child("interactiveInfo").@parameter2;
            this._rankingListURL = param1.child("rankingList").toString();
            this._digURL = param1.child("dig").toString();
            this._digParam1 = param1.child("dig").@parameter;
            this._digParam2 = param1.child("dig").@parameter2;
            this._digParam3 = param1.child("dig").@parameter3;
            this._rateURL = param1.child("rate").toString();
            this._rateParam1 = param1.child("rate").@parameter;
            this._rateParam2 = param1.child("rate").@parameter2;
            this._rateParam3 = param1.child("rate").@parameter3;
            this._rateParam4 = param1.child("rate").@parameter4;
            this._rateParam5 = param1.child("rate").@parameter5;
            this._rateParam6 = param1.child("rate").@parameter6;
            this._rateParam7 = param1.child("rate").@parameter7;
            this._favoriteURL = param1.child("favorite").toString();
            this._favoriteParam1 = param1.child("favorite").@parameter;
            this._favoriteParam2 = param1.child("favorite").@parameter2;
            this._buguListURL = param1.child("buguList").toString();
            this._buguListParam1 = param1.child("buguList").@parameter;
            this._buguListParam2 = param1.child("buguList").@parameter2;
            this._suggestionURL = param1.child("suggestion").toString();
            this._suggestionParam1 = param1.child("suggestion").@parameter;
            this._suggestionParam2 = param1.child("suggestion").@parameter2;
            this._suggestionParam3 = param1.child("suggestion").@parameter3;
            this._adplayerPath = param1.child("adplayer").toString();
            this._pauseAdplayerPath = param1.child("pauseAdplayer").toString();
            return;
        }// end function

        private function parseXML2(param1:XML) : void
        {
            var _loc_2:* = param1.child("isConviva").toString();
            var _loc_3:* = param1.child("gulouPath").toString();
            var _loc_4:* = param1.child("relative").@show;
            var _loc_5:* = param1.child("isSsP2p").toString();
            if (_loc_2 == "true")
            {
                ModelLocator.getInstance().isConviva = true;
            }
            if (_loc_3 != null && _loc_3 != "" && _loc_3 != "undefined")
            {
                ModelLocator.getInstance().paramVO.gulouPath = _loc_3;
            }
            if (_loc_4 == "true")
            {
                ModelLocator.getInstance().paramVO.showRelative = true;
                ModelLocator.getInstance().paramVO.relativeListUrl = param1.child("relative").toString();
            }
            if (_loc_5 == "true")
            {
                ModelLocator.getInstance().isP2pMode = true;
            }
            return;
        }// end function

        public function get videoInfoURL() : String
        {
            return this._videoInfoURL;
        }// end function

        public function set videoInfoURL(param1:String) : void
        {
            this._videoInfoURL = param1;
            return;
        }// end function

        public function get videoInfoParam1() : String
        {
            return this._videoInfoParam1;
        }// end function

        public function get interactiveInfoURL() : String
        {
            return this._interactiveInfoURL;
        }// end function

        public function get interactiveInfoParam1() : String
        {
            return this._interactiveInfoParam1;
        }// end function

        public function get interactiveInfoParam2() : String
        {
            return this._interactiveInfoParam2;
        }// end function

        public function get rankingListURL() : String
        {
            return this._rankingListURL;
        }// end function

        public function get digURL() : String
        {
            return this._digURL;
        }// end function

        public function get digParam1() : String
        {
            return this._digParam1;
        }// end function

        public function get digParam2() : String
        {
            return this._digParam2;
        }// end function

        public function get digParam3() : String
        {
            return this._digParam3;
        }// end function

        public function get rateURL() : String
        {
            return this._rateURL;
        }// end function

        public function get rateParam1() : String
        {
            return this._rateParam1;
        }// end function

        public function get rateParam2() : String
        {
            return this._rateParam2;
        }// end function

        public function get rateParam3() : String
        {
            return this._rateParam3;
        }// end function

        public function get rateParam4() : String
        {
            return this._rateParam4;
        }// end function

        public function get rateParam5() : String
        {
            return this._rateParam5;
        }// end function

        public function get rateParam6() : String
        {
            return this._rateParam6;
        }// end function

        public function get rateParam7() : String
        {
            return this._rateParam7;
        }// end function

        public function get favoriteURL() : String
        {
            return this._favoriteURL;
        }// end function

        public function get favoriteParam1() : String
        {
            return this._favoriteParam1;
        }// end function

        public function get favoriteParam2() : String
        {
            return this._favoriteParam2;
        }// end function

        public function get buguListURL() : String
        {
            return this._buguListURL;
        }// end function

        public function get buguListParam1() : String
        {
            return this._buguListParam1;
        }// end function

        public function get buguListParam2() : String
        {
            return this._buguListParam2;
        }// end function

        public function get suggestionURL() : String
        {
            return this._suggestionURL;
        }// end function

        public function set suggestionURL(param1:String) : void
        {
            this._suggestionURL = param1;
            return;
        }// end function

        public function get suggestionParam1() : String
        {
            return this._suggestionParam1;
        }// end function

        public function get suggestionParam2() : String
        {
            return this._suggestionParam2;
        }// end function

        public function get suggestionParam3() : String
        {
            return this._suggestionParam3;
        }// end function

    }
}
