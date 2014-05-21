package com.cntv.common.model
{
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.recorder.*;
    import flash.display.*;

    public class ModelLocator extends Object
    {
        public var guid:String = "";
        public var isLocationPlayer:Boolean = false;
        public var isP2PNotice:Boolean = false;
        public var ISWEBSITE:Boolean = true;
        public var isActionWidgets:Boolean = true;
        public var paramVO:ParameterVO;
        public var isDebug:Boolean = false;
        public const WIDE_SCREEN:String = "wide.screen";
        public const NORMAL_SCREEN:String = "normal.screen";
        public const LOW_RATE:int = 0;
        public const HIGH_RATE:int = 1;
        public var screenW:Number = 0;
        public var screenH:Number = 0;
        public var configVO:ConfigVO;
        public var isLive:Boolean = false;
        public var currentVideoInfo:VideoInfoVo;
        public var currentAudioInfo:VideoInfoVo;
        public var cycleList:Array;
        public var cycleIndex:int = -1;
        public var ntcDate:Date;
        public var currentTime:Number = 0;
        public var brightness:Number = 0.5;
        public var contrast:Number = 0.1;
        public var size:Number = 1;
        public var angle:Number = 0;
        public var movieDuration:Number = 0;
        public var sliceMovieDuration:Number = 0;
        public var volumeValue:Number = 1;
        public var isMute:Boolean = false;
        public var wideMode:String = "normal.screen";
        public var Buffer_next_distance:int = 30;
        public var buffer_next_time:int = 60;
        public var currentRtmpBiteRateMode:int = 4;
        public var currentRtmpBiteRate:int = 0;
        public var currentHttpBiteRateMode:int = 0;
        public var currentHttpBiteRate:int = 0;
        public var currentBitrate:Number = 450;
        public var isReadedCookie:Boolean = false;
        public var vddBitRates:Array;
        public var currentVddBitRates:Array;
        public var isConviva:Boolean = false;
        public var isAkamaiAnility:Boolean = false;
        public var isInSwitch:Boolean = false;
        public var adIconVO:ADLogoVO;
        public var configPath:String = "player/config.xml";
        public var outSideConfigPath:String = "http://js.player.cntv.cn/xml/config/outside.xml";
        public var widgetsList:Array;
        public var recordManager:RecordManager;
        public var qm:QualityMonitor;
        public var i18n:I18nLanguageVO;
        public var isInScreenSwitch:Boolean = false;
        public var adVosBF:Array;
        public var adVosAF:Array;
        public var adVosPause:Array;
        public var adVosCorner:Array;
        public var adVosLogo:Array;
        public var localDataObjectName:String = "cntvPlayerOptions";
        public var localDataPath:String = "/";
        public var adMicroLoop:String = "adMicroLoop";
        public var currentFile:String = "";
        public var debugMode:Boolean = false;
        public var isReady:Boolean = false;
        public var relativeList:Array;
        public var relativeListTitle:Array;
        public var microLoopIndex:int = 0;
        public var p2pPath:String = "127.0.0.1:4092";
        public var p2pJsPath:String = "http://127.0.0.1:4092/js/clientinstall.js";
        public var dynamicHost:String = "http://v.vms.cctv.com/data/pinfo/";
        public var isUseP2P:Boolean = false;
        public var currentVideoClipIndex:int = 0;
        public var hotDotPluginLoaded:Boolean = false;
        public var matchStartime:Number = -1;
        public var defaultSkinPath:String = "http://player.cntv.cn/skin/default.swf";
        public var skinPath:String = "http://player.cntv.cn/skin/";
        public var skinFile:DisplayObject;
        public var debugerPath:String = "playerDebugr.swf";
        public var limitedDuring:Number = 0;
        public var isRemenberLastTime:Boolean = true;
        public var CANDIDATE_RESOURCES:Array;
        public var isConvivaMode:Boolean = false;
        public var useStaticData:Boolean = false;
        public var noVideoData:Boolean = false;
        public var isP2pMode:Boolean = false;
        public var videoSizeRate:Number = 1;
        public var videoSizeMode:Number = 1;
        public var rate:Number = 1;
        public static const VERSION_SHORT:String = "2.0.2013.3.18.6.";
        public static var instance:ModelLocator;

        public function ModelLocator()
        {
            this.vddBitRates = ["LD", "STD", "HD", "SD", "SHD", "AUTO"];
            this.currentVddBitRates = [];
            this.widgetsList = [];
            this.adVosBF = [];
            this.CANDIDATE_RESOURCES = ["ak.v.cntv.cn", "l3.v.cntv.cn"];
            if (instance == null)
            {
                instance = this;
            }
            return;
        }// end function

        public static function getInstance() : ModelLocator
        {
            if (instance == null)
            {
                instance = new ModelLocator;
            }
            return instance;
        }// end function

    }
}
