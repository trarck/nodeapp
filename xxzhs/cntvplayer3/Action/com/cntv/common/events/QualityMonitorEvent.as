package com.cntv.common.events
{
    import flash.events.*;

    public class QualityMonitorEvent extends Event
    {
        public var data:Object;
        public static const EVENT_LOAD_DATA_TIME:String = "event.load.data.time";
        public static const EVENT_LOAD_VIDEO_TIME:String = "event.load.video.time";
        public static const EVENT_LOAD_VIDEO_TIME_OUT:String = "event.load.video.time.out";
        public static const EVENT_BUFFER_TIME_OUT:String = "event.buffer.time.out";
        public static const EVENT_ERROR:String = "event.error";
        public static const EVENT_AFFLUENT:String = "event.affluent";
        public static const EVENT_FRAME_SKIP:String = "event.frame.skip";
        public static const EVENT_SEEK_TIME:String = "event.seek.time";
        public static const EVENT_MEMORY:String = "event.memory";
        public static const EVENT_SWITCH:String = "event.switch";
        public static const EVENT_SWITCH_BUFFER:String = "event.switch.buffer";
        public static const EVENT_SMOOTH_RATE:String = "event.smooth.rate";
        public static const EVENT_BEST_RATE:String = "event.best.rate";
        public static const EVENT_BAND_WIDTH:String = "event.band.width";
        public static const EVENT_LOAD_AD_DATA:String = "event.load.ad.data";
        public static const EVENT_PLAYER_INIT:String = "event.player.init";
        public static const EVENT_HOT_MAP:String = "event.hot.map";
        public static const EVENT_BUTTON_CLICK:String = "event.button.click";
        public static const EVENT_SHUT_DOWN:String = "event.shut.down";
        public static const EVENT_HOT_CLICKED:String = "event.hot.clicked";
        public static const EVENT_HOT_MAP_DATA:String = "event.hot.event";
        public static const EVENT_NBA_MAP_DATA:String = "event.nba.event";
        public static const EVENT_MEMORY_FULL:String = "memory.full";
        public static const EVENT_VDDSUCCESS_BY_RETRY:String = "vdd.success.retry";
        public static const EVENT_CONFIGSUCCESS_BY_RETRY:String = "config.success.retry";
        public static const EVENT_RECONNECT_SERVER:String = "reconnect.server";
        public static const EVENT_NOTICE_STREAM_RATE_FAILED:String = "notice.stream.rate.failed";
        public static const EVENT_SEEK_CODE:String = "event.seek.code";
        public static const EVENT_BUFFER_LENGTH:String = "event.buffer.length";
        public static const EVENT_PLAY_LENGTH:String = "event.play.length";
        public static const EVENT_SEND_COMMON:String = "event.send.common";
        public static const EVENT_RELATIVE_CLICKED:String = "event.relative.clicked";
        public static const ERROR_CAN_NOT_GET_VIDEO_DATA:String = "001";
        public static const ERROR_VIDEO_DATA_FORMAT_ERROR:String = "002";
        public static const ERROR_CAN_NOT_GET_CONFIG:String = "009";
        public static const ERROR_PLAY_LIST_EMPTY:String = "003";
        public static const ERROR_CAN_NOT_GET_VIDEO_FILE:String = "004";
        public static const ERROR_HZ0:String = "005";
        public static const ERROR_HZ1:String = "006";
        public static const ERROR_HZ2:String = "007";
        public static const ERROR_HZ3:String = "008";
        public static const ERROR_CAN_NOT_GET_AD_DATA:String = "101";
        public static const ERROR_AD_DATA_FORMAT_ERROR:String = "102";
        public static const ERROR_VIDEO_DATA_ACK_NO:String = "201";
        public static const ERROR_VIDEO_HALT:String = "202";
        public static const ERROR_ID_EXCEPTION:String = "203";
        public static const ERROR_VIDEO_DATA_ACK_OFFLINE:String = "204";

        public function QualityMonitorEvent(param1:String, param2 = null)
        {
            this.data = param2;
            super(param1, false, false);
            return;
        }// end function

    }
}
