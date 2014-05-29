package com.cntv.common
{
    import com.cntv.common.controller.*;
    import com.puremvc.*;

    public class ApplicationFacade extends CommonFacade
    {
        public static const STARTUP:String = "startUp";
        public static const NOTI_INIT_PARAM:String = "noti.init.param";
        public static const NOTI_GET_CONFIG:String = "noti.get.config";
        public static const NOTI_GET_VIDEOINFO:String = "noti.get.videoinfo";
        public static const NOTI_GET_VIDEOHOTDOT:String = "noti.get.videohotdot";
        public static const NOTI_REGET_VIDEOINFO:String = "noti.reget.videoinfo";
        public static const NOTI_GET_INTERACTIVEINFO:String = "noti.get.interactiveinfo";
        public static const NOTI_GET_INTERACTIVEINFO_COMPLETE:String = "noti.get.interactiveinfo.complete";
        public static const NOTI_START_PLAY:String = "noti.start.play";
        public static const NOTI_GET_LANGUAGE:String = "noti.get.language";
        public static const NOTI_LOAD_LANGUAGE:String = "noti.load.language";
        public static const NOTI_GET_QUICK_DATA:String = "noti.get.quick.data";
        public static const NOTI_GET_LIVE_BACK:String = "noti.get.live.back.data";
        public static const NOTI_GET_AD:String = "noti.get.ad";
        public static const NOTI_LOAD_AD:String = "noti.load.ad";
        public static const NOTI_PLAY_AD:String = "noti.play.ad";
        public static const NOTI_START_BEFORE_ADS:String = "noti.start.before.ads";
        public static const NOTI_AFTER_BEFORE_ADS:String = "noti.after.before.ads";
        public static const EVENT_LOAD_AD:String = "event.load.ad";

        public function ApplicationFacade(param1:String)
        {
            super(param1);
            return;
        }// end function

        override protected function initializeController() : void
        {
            super.initializeController();
            registerCommand(STARTUP, StartupCommand);
            registerCommand(NOTI_INIT_PARAM, InitParamCommand);
            registerCommand(NOTI_GET_VIDEOHOTDOT, GetVideoHotDotCommand);
            registerCommand(NOTI_GET_CONFIG, LoadConfigCommand);
            registerCommand(NOTI_GET_VIDEOINFO, GetVideoInfoCommand);
            registerCommand(NOTI_GET_INTERACTIVEINFO, GetInteractiveInfoCommand);
            registerCommand(NOTI_LOAD_LANGUAGE, LoadLanguageCommand);
            registerCommand(NOTI_LOAD_AD, GetADDataCommand);
            registerCommand(NOTI_GET_QUICK_DATA, GetVideoQuickCommand);
            registerCommand(NOTI_GET_LIVE_BACK, GetLiveBackCommand);
            return;
        }// end function

        public function startUp(param1:Main) : void
        {
            sendNotification(STARTUP, param1);
            sendNotification(NOTI_INIT_PARAM, param1);
            return;
        }// end function

        public static function getInstance(param1:String) : ApplicationFacade
        {
            if (instanceMap[param1] == null)
            {
                instanceMap[param1] = new ApplicationFacade(param1);
            }
            return instanceMap[param1] as ApplicationFacade;
        }// end function

    }
}
