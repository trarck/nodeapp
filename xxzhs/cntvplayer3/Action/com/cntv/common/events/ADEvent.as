package com.cntv.common.events
{
    import flash.events.*;

    public class ADEvent extends Event
    {
        public var data:Object;
        public static const EVENT_START_PLAY_AD:String = "event.start.play.ad";
        public static const EVENT_STOP_PLAY_AD:String = "event.stop.play.ad";
        public static const EVENT_START_PLAY_PAUSE_AD:String = "event.start.play.pause.ad";
        public static const EVENT_STOP_PLAY_PAUSE_AD:String = "event.stop.play.pause.ad";
        public static const EVENT_START_PLAY_CORNER_ICON_AD:String = "event.start.play.icon.ad";
        public static const EVENT_STOP_PLAY_CORNER_ICON_AD:String = "event.stop.play.icon.ad";
        public static const EVENT_GET_AF_AD_DATA:String = "event.get.af.ad.data";
        public static const EVENT_GET_PAUSE_AD_DATA:String = "event.get.pause.ad.data";
        public static const EVENT_GET_CORNER_AD_DATA:String = "event.get.corner.ad.data";
        public static const EVENT_GET_LOGO_AD_DATA:String = "event.get.logo.ad.data";

        public function ADEvent(param1:String, param2 = null)
        {
            this.data = param2;
            super(param1, false, false);
            return;
        }// end function

    }
}
