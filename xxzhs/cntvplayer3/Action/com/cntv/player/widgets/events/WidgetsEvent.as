package com.cntv.player.widgets.events
{
    import com.puremvc.view.event.*;

    public class WidgetsEvent extends CommonEvent
    {
        public static const EVENT_SEND_SUGGESTION:String = "event.send.suggestion";
        public static const EVENT_CLICK_DIGG_UP:String = "event.click.digg.up";
        public static const EVENT_CLICK_DIGG_DOWN:String = "event.click.digg.down";
        public static const EVENT_SEND_RATE:String = "event.send.rate";
        public static const EVENT_SEND_COLLECT:String = "event.send.collect";
        public static const EVENT_SEND_LIGHT:String = "event.send.light";
        public static const EVENT_ON_RANKING:String = "event.on.ranking";
        public static const EVENT_ON_COLLECT:String = "event.on.collect";
        public static const EVENT_ON_SUGGESTION:String = "event.on.suggestion";
        public static const EVENT_ON_SHARE:String = "event.on.share";
        public static const EVENT_ON_DIGG:String = "event.on.digg";
        public static const EVENT_ON_RATE:String = "event.on.rate";
        public static const EVENT_ON_SCREEN:String = "event.on.screen";
        public static const EVENT_ON_LIGHT:String = "event.on.light";
        public static const EVENT_ON_SPEEDUP:String = "event.on.speedup";
        public static const EVENT_ON_HOTMAP:String = "event.on.hotmap";
        public static const EVENT_ON_SMALLWINDOW:String = "event.on.smallwidow";
        public static const EVENT_ON_QUALITY:String = "event.on.quality";

        public function WidgetsEvent(param1:String, param2 = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
