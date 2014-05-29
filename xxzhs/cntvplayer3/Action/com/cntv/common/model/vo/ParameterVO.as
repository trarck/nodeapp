package com.cntv.common.model.vo
{
    import com.cntv.common.model.*;
    import com.puremvc.model.vo.*;

    public class ParameterVO extends ValueObject
    {
        public var videoId:String;
        public var isLogin:Boolean = false;
        public var userId:String;
        public var isLive:Boolean = false;
        public var isCycle:Boolean = false;
        public var articleid:String;
        public var scheduleId:String;
        public var channelId:String = "";
        private var _videoCenterId:String = "";
        public var videoCenterIdBackUp:String = "";
        public var rtmpHost:String = "";
        public var streamName:String = "";
        public var filePath:String = "/";
        public var hour24DataURL:String = "VodCycleData.xml";
        public var logoImageURL:String = "acd";
        public var logoURL:String = "http://www.cntv.cn";
        public var url:String = "";
        public var adCall:String = "";
        public var adPause:String = "";
        public var adAfter:String = "";
        public var adCorner:String = "";
        public var adCurtain:String = "";
        public var adLogo:String = "";
        public var isAutoPlay:Boolean = true;
        public var qmServerPath:String = null;
        public var qmServerPath2:String = "http://log.vdn.apps.cntv.cn/stat.html";
        public var qmServerPath3:String = "";
        public var gulouPath:String = "";
        public var qmFrequency:Number = 10;
        public var adplayerPath:String = "";
        public var pauseAdplayerPath:String = "";
        public var cornerAdplayerPath:String = "";
        public var curtainAdPlayerPath:String = "";
        public var hotmapPath:String = "http://player.cntv.cn/standard/cntvHotmap.swf";
        public var hotmapDataPath:String = "http://vdd.player.cntv.cn/hot.php";
        public var icanNBADataPath:String = "http://vdd.player.cntv.cn/ican_nba.php";
        public var icanNBAPath:String = "http://player.cntv.cn/flashplayer/players/testplayer/icanNBA.swf";
        public var matchDataPath:String = "http://vdd.player.cntv.cn/match.php";
        public var audioPlayerPath:String = "http://player.cntv.cn/standard/cntvAudioCorePlayer.swf";
        public var searchBarPath:String = "http://player.cntv.cn/standard/searchBar.swf";
        public var smallWindowUrl:String = "http://player.cntv.cn/flashplayer/players/htmls/smallwindow.html";
        public var canPopWindow:Boolean = true;
        public var sharePlugPath:String = "sharePlug.swf";
        public var isSlicedByHotDot:Boolean = false;
        public var hotmapData:Object = null;
        public var matchData:matchVO = null;
        public var icanNBAData:String = "";
        public var isFromPrecise:Boolean = false;
        public var wmode:String = "opaque";
        public var tai:String = "none";
        public var showRelative:Boolean = false;
        public var referrer:String = "none";
        public var cornerAdPX:int = 0;
        public var cornerAdPY:int = 0;
        public var ecmAdPlayerUrl:String = "http://static.acs86.com/player/RollPlayer.swf?aid=46166&hc=1&alt=25000";
        public var ecmAid:String = "";
        public var ecmHc:String = "";
        public var ecmAst:String = "";
        public var isPlay3rdAd:Boolean = false;
        public var isPlayCurtainAd:Boolean = true;
        public var relativeListUrl:String = "";
        public var relativeListTitleUrl:String = "http://js.player.cntv.cn/xml/";
        public var outsideChannelId:String = "channelBugu";
        public var dynamicDataPath:String = "http://vdn.apps.cntv.cn/api/getHttpVideoInfo.do";
        public var isUseDynamicData:Boolean = true;
        public var dynamicFrequency:Number = 1;
        public var isUseP2pK6:Boolean = false;
        public var startTime:int = 0;
        public var isP2pInstall:Boolean = false;
        public var speedUperPath:String = "http://cbox.cntv.cn/speedup/index.html";
        public var p2pTrigger:Boolean = false;
        public var floatLogoTrigger:Boolean = false;
        public var floatLogoURL:String;
        public var isSecondHand:Boolean = false;
        public var isHotmap:Boolean = false;
        public var preImage:String = "";
        public var idLength:int = -1;
        public var vidModify:Boolean = false;
        public var isTargetAD:Boolean = false;
        public var autoRePlay:Boolean = false;
        public var isHotDotNotice:Boolean = false;
        public var isNBA:Boolean = false;
        public var slice:Boolean = false;
        public var sliceStartTime:Number = -1;
        public var sliceEndTime:Number = -1;
        public var playBackMode:String = "video";
        public var language:String = "chinese";
        public var skinName:String = "default";
        public var maxMemoryUse:Number = 150;
        public var maxPageMemoryUse:Number = 250;
        public var is_abroad:Boolean = false;
        public var isUseCatche:Boolean = false;
        public var isHigh:Boolean = false;
        public var addShare:Boolean = false;
        public var isSmall:Boolean = false;
        public var showSearchBar:Boolean = true;
        public var qkChannel:String = "";
        public var qkColumn:String = "";
        public var qkDate:String = "";
        public var qkStyleServer:String = "http://vdd.player.cntv.cn/quickprogram.php";
        public var liveBackPath:String = "http://vdd.player.cntv.cn/liveback.php";
        public var qkStartTime:String = "";
        public var qkEndTime:String = "";
        public var playMode:String = "vod";
        public var isLockLimit:Boolean = false;
        public var endTime:Number = 0;
        public var useTxtPath:Boolean = true;
        public var showTitle:Boolean = true;
        public var AkamaiAnalyticsConfigUrl:String = "http://ma212-r.analytics.edgesuite.net/config/beacon-2494.xml";
        public var showGooglePauseAd:Boolean = false;
        public var googlePausePath:String = "http://player.cntv.cn/adplayer/googlePause.swf?a=1";
        public var isFlashAddress:Boolean = false;
        public var ssP2pSwf:String = "http://player.cntv.cn/standard/ss.swf";
        public var isshowProButton:Boolean = true;
        public var widgetsConfig:String = "";
        public var languageConfig:String = "";
        public var widgetsXmlPath:String = "";
        public var widgetsSwfPath:String = "";

        public function ParameterVO(param1:Object)
        {
            this.parseData(param1);
            return;
        }// end function

        public function parseData(param1:Object) : void
        {
            if (param1["widgetsXmlPath"] != null)
            {
                this.widgetsXmlPath = param1["widgetsXmlPath"];
            }
            if (param1["widgetsSwfPath"] != null)
            {
                this.widgetsSwfPath = param1["widgetsSwfPath"];
            }
            if (param1["isshowProButton"] != null && param1["isshowProButton"] == "false")
            {
                this.isshowProButton = false;
            }
            if (param1["skinName"] != null)
            {
                this.skinName = param1["skinName"];
            }
            if (param1["tai"] != null)
            {
                this.tai = param1["tai"];
            }
            if (param1["id"] != null && param1["id"] != "" && param1["id"] != undefined && this.tai != "taihai")
            {
                this._videoCenterId = param1["id"];
                this.videoCenterIdBackUp = this._videoCenterId;
                this.videoId = param1["id"];
                this.idLength = this.videoCenterId.length;
            }
            if (param1["videoCenterId"] != null && param1["videoCenterId"] != "" && param1["videoCenterId"] != undefined)
            {
                this._videoCenterId = param1["videoCenterId"];
                this.videoCenterIdBackUp = this._videoCenterId;
                this.idLength = this.videoCenterId.length;
            }
            if (param1["isFlashAddress"] == "true")
            {
                this.isFlashAddress = true;
            }
            if (param1["akmAnalyticsUrl"] != null && param1["akmAnalyticsUrl"] != "" && param1["akmAnalyticsUrl"] != undefined)
            {
                this.AkamaiAnalyticsConfigUrl = param1["akmAnalyticsUrl"];
            }
            if (param1["smallWindowUrl"] != null && param1["smallWindowUrl"] != "" && param1["smallWindowUrl"] != undefined)
            {
                this.smallWindowUrl = param1["smallWindowUrl"];
            }
            if (param1["showTitle"] == "false")
            {
                this.showTitle = false;
            }
            if (param1["useTxt"] != null && param1["useTxt"] == "true")
            {
                this.useTxtPath = true;
            }
            if (param1["isConviva"] != null && param1["isConviva"] == "false")
            {
                ModelLocator.getInstance().isConviva = false;
            }
            if (param1["isAkamaiAnility"] != null && param1["isAkamaiAnility"] == "true")
            {
                ModelLocator.getInstance().isAkamaiAnility = true;
            }
            if (param1["showSearchBar"] != null && param1["showSearchBar"] == "false")
            {
                this.showSearchBar = false;
            }
            if (param1["ssP2pSwf"] != null && param1["ssP2pSwf"] != "")
            {
                this.ssP2pSwf = param1["ssP2pSwf"];
            }
            if (param1["gulouPath"] != null)
            {
                this.gulouPath = param1["gulouPath"];
            }
            if (param1["showGooglePauseAd"] == "true" && param1["adPause"] == null)
            {
                this.showGooglePauseAd = true;
            }
            if (param1["videoId"] != null && param1["videoId"] != "" && param1["videoId"] != undefined)
            {
                this.videoId = param1["videoId"];
            }
            if (param1["isLogin"] != null && param1["isLogin"] == "y")
            {
                this.isLogin = true;
            }
            if (param1["userId"] != null)
            {
                this.userId = param1["userId"];
            }
            if (param1["isLive"] != null && param1["isLive"] == "true")
            {
                this.isLive = true;
            }
            if (param1["isSmall"] != null && param1["isSmall"] == "true")
            {
                this.isSmall = true;
            }
            if (param1["isCycle"] != null && param1["isCycle"] == "true")
            {
                this.isCycle = true;
            }
            if (param1["sliceStartTime"] != null)
            {
                this.sliceStartTime = Number(param1["sliceStartTime"]);
            }
            if (param1["sharePlugPath"] != null)
            {
                this.sharePlugPath = param1["sharePlugPath"];
            }
            if (param1["sliceEndTime"] != null)
            {
                this.sliceEndTime = Number(param1["sliceEndTime"]);
            }
            if (param1["articleId"])
            {
                this.articleid = param1["articleId"];
            }
            if (param1["scheduleId"])
            {
                this.scheduleId = param1["scheduleId"];
            }
            if (param1["canPopWindow"] != null && param1["canPopWindow"] == "false")
            {
                this.canPopWindow = false;
            }
            if (param1["icanNBAPath"] != null && param1["icanNBAPath"] != "")
            {
                this.icanNBAPath = param1["icanNBAPath"];
            }
            if (param1["icanNBADataPath"] != null && param1["icanNBADataPath"] != "")
            {
                this.icanNBADataPath = param1["icanNBADataPath"];
            }
            if (param1["rtmpHost"] != null)
            {
                this.rtmpHost = param1["rtmpHost"];
            }
            if (param1["streamName"] != null)
            {
                this.streamName = param1["streamName"];
            }
            if (param1["addShare"] == "true")
            {
                this.addShare = true;
            }
            if (param1["filePath"] != null)
            {
                this.filePath = param1["filePath"];
            }
            if (param1["hour24DataURL"] != null)
            {
                this.hour24DataURL = param1["hour24DataURL"];
            }
            if (param1["logoImageURL"] != null)
            {
                this.logoImageURL = param1["logoImageURL"];
            }
            if (param1["logoURL"] != null)
            {
                this.logoURL = param1["logoURL"];
            }
            if (param1["isHigh"] == "true")
            {
                this.isHigh = true;
            }
            if (param1["configPath"] != null)
            {
                ModelLocator.getInstance().configPath = param1["configPath"];
            }
            if (param1["widgetsConfig"] != null && param1["widgetsConfig"] != "" && param1["widgetsConfig"] != undefined)
            {
                this.widgetsConfig = param1["widgetsConfig"];
            }
            if (param1["hotmapPath"] != null)
            {
                this.hotmapPath = param1["hotmapPath"];
            }
            if (param1["isUseCatche"] == "true")
            {
                this.isUseCatche = true;
            }
            if (param1["showRelative"] == "true")
            {
                this.showRelative = true;
            }
            if (param1["autoRePlay"] == "true")
            {
                this.autoRePlay = true;
            }
            if (param1["isTargetAD"] == "true")
            {
                this.isTargetAD = true;
            }
            if (param1["url"] != null)
            {
                this.url = param1["url"];
            }
            if (param1["channelId"] != null)
            {
                this.channelId = param1["channelId"];
            }
            if (param1["languageConfig"] != null)
            {
                this.languageConfig = param1["languageConfig"];
            }
            if (param1["wideMode"] != null)
            {
                if (param1["wideMode"] == "wide")
                {
                    ModelLocator.getInstance().wideMode = ModelLocator.getInstance().WIDE_SCREEN;
                }
                else if (param1["wideMode"] == "normal")
                {
                    ModelLocator.getInstance().wideMode = ModelLocator.getInstance().NORMAL_SCREEN;
                }
            }
            if (param1["isConviva"] != null && param1["isConviva"] == "true")
            {
                ModelLocator.getInstance().isConviva = true;
            }
            if (param1["defaultRate"] != null)
            {
                if (param1["defaultRate"] == "high")
                {
                    ModelLocator.getInstance().currentHttpBiteRate = ModelLocator.getInstance().HIGH_RATE;
                    ModelLocator.getInstance().currentHttpBiteRateMode = ModelLocator.getInstance().HIGH_RATE;
                }
            }
            if (param1["hotmapDataPath"] != null)
            {
                this.hotmapDataPath = param1["hotmapDataPath"];
            }
            if (param1["slice"] != null && param1["slice"] == "true")
            {
                this.slice = true;
            }
            if (param1["adCall"] != null)
            {
                this.adCall = param1["adCall"];
            }
            if (param1["adPause"] != null)
            {
                this.adPause = param1["adPause"];
            }
            if (param1["adAfter"] != null)
            {
                this.adAfter = param1["adAfter"];
            }
            if (param1["adCorner"] != null)
            {
                this.adCorner = param1["adCorner"];
            }
            if (param1["adCurtain"] != null)
            {
                this.adCurtain = param1["adCurtain"];
            }
            if (param1["adLogo"] != null)
            {
                this.adLogo = param1["adLogo"];
            }
            if (param1["isAutoPlay"] != null && param1["isAutoPlay"] == "false")
            {
                this.isAutoPlay = false;
            }
            if (param1["qmServerPath"] != null)
            {
                this.qmServerPath = param1["qmServerPath"];
            }
            if (param1["qmServerPath2"] != null)
            {
                this.qmServerPath2 = param1["qmServerPath2"];
            }
            if (param1["qmServerPath3"] != null)
            {
                this.qmServerPath3 = param1["qmServerPath3"];
            }
            if (param1["qmFrequency"] != null && !isNaN(param1["qmFrequency"]))
            {
                this.qmFrequency = Number(param1["qmFrequency"]);
            }
            if (param1["adplayerPath"] != null)
            {
                this.adplayerPath = param1["adplayerPath"];
            }
            if (param1["pauseAdplayerPath"] != null)
            {
                this.pauseAdplayerPath = param1["pauseAdplayerPath"];
            }
            if (param1["cornerAdplayerPath"] != null)
            {
                this.cornerAdplayerPath = param1["cornerAdplayerPath"];
            }
            if (param1["curtainAdPlayerPath"] != null)
            {
                this.curtainAdPlayerPath = param1["curtainAdPlayerPath"];
            }
            if (param1["wmode"] != null)
            {
                this.wmode = param1["wmode"];
            }
            if (param1["referrer"] != null)
            {
                this.referrer = param1["referrer"];
            }
            if (param1["cornerAdPX"] != null)
            {
                this.cornerAdPX = int(param1["cornerAdPX"]);
            }
            if (param1["cornerAdPY"] != null)
            {
                this.cornerAdPY = int(param1["cornerAdPY"]);
            }
            if (param1["ecmAdPlayerUrl"] != null)
            {
                this.ecmAdPlayerUrl = unescape(param1["ecmAdPlayerUrl"]);
            }
            if (param1["ssP2pSwf"] != null && param1["ssP2pSwf"] == "")
            {
                this.ssP2pSwf = param1["ssP2pSwf"];
            }
            if (param1["isPlay3rdAd"] != null && param1["isPlay3rdAd"] == "true")
            {
                this.isPlay3rdAd = true;
            }
            else
            {
                this.isPlay3rdAd = false;
            }
            if (param1["relativeListUrl"] != null)
            {
                this.relativeListUrl = param1["relativeListUrl"];
            }
            if (param1["relativeListTitleUrl"] != null)
            {
                this.relativeListTitleUrl = param1["relativeListTitleUrl"];
            }
            if (param1["outsideChannelId"] != null)
            {
                this.outsideChannelId = param1["outsideChannelId"];
            }
            if (param1["dynamicDataPath"] != null)
            {
                this.dynamicDataPath = param1["dynamicDataPath"];
            }
            if (param1["isUseDynamicData"] != null && param1["isUseDynamicData"] == "true")
            {
                this.isUseDynamicData = true;
            }
            if (param1["dynamicFrequency"] != null)
            {
                this.dynamicFrequency = Number(param1["dynamicFrequency"]);
            }
            if (param1["isUseP2pK6"] != null && param1["isUseP2pK6"] == "true")
            {
                this.isUseP2pK6 = true;
            }
            if (param1["startTime"] != null && !isNaN(param1["startTime"]))
            {
                this.startTime = int(param1["startTime"]);
            }
            if (param1["isP2pInstall"] != null && param1["isP2pInstall"] == "true")
            {
                this.isP2pInstall = true;
            }
            if (param1["speedUperPath"] != null)
            {
                this.speedUperPath = param1["speedUperPath"];
            }
            if (param1["isHotDotNotice"] != null && param1["isHotDotNotice"] == "true")
            {
                this.isHotDotNotice = true;
            }
            if (param1["p2pTrigger"] != null && param1["p2pTrigger"] == "false")
            {
                this.p2pTrigger = false;
            }
            if (param1["useP2pMode"] != null && param1["useP2pMode"] == "true")
            {
                ModelLocator.getInstance().isP2pMode = true;
            }
            if (param1["floatLogoTrigger"] != null && param1["floatLogoTrigger"] == "true")
            {
                this.floatLogoTrigger = true;
            }
            if (param1["isSecondHand"] != null && param1["isSecondHand"] != undefined && param1["isSecondHand"] == "true")
            {
                this.isSecondHand = true;
            }
            if (param1["floatLogoURL"] != null && param1["floatLogoURL"] != undefined && param1["floatLogoURL"] != "")
            {
                this.floatLogoURL = param1["floatLogoURL"];
            }
            if (param1["isHotmap"] != null && param1["isHotmap"] != undefined && param1["isHotmap"] == "true")
            {
                this.isHotmap = true;
            }
            if (param1["preImage"] != null && param1["preImage"] != undefined && param1["preImage"] != "")
            {
                this.preImage = param1["preImage"];
            }
            if (param1["playBackMode"] != null && param1["playBackMode"] != undefined && param1["playBackMode"] != "")
            {
                this.playBackMode = param1["playBackMode"];
            }
            if (param1["language"] != null && param1["language"] != undefined && param1["language"] != "")
            {
                this.language = param1["language"];
            }
            if (param1["audioPlayerPath"] != null && param1["audioPlayerPath"] != undefined && param1["audioPlayerPath"] != "")
            {
                this.audioPlayerPath = param1["audioPlayerPath"];
            }
            return;
        }// end function

        public function set videoCenterId(param1:String) : void
        {
            this.vidModify = true;
            this._videoCenterId = param1;
            return;
        }// end function

        public function get videoCenterId() : String
        {
            return this._videoCenterId;
        }// end function

    }
}
