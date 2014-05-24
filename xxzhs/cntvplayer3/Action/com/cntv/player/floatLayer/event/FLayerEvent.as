package com.cntv.player.floatLayer.event
{
    import com.puremvc.view.event.*;

    public class FLayerEvent extends CommonEvent
    {
        public static const EVENT_SHOW_PANEL:String = "event.show.panel";
        public static const EVENT_SHOW_QUALITY_RADIAOS:String = "event.show.quality.radios";
        public static const EVENT_SHOW_QUALITYPANEL:String = "event.show.qualitypanel";
        public static const EVENT_SHOW_CHANGETEXT:String = "event.show.changetext";
        public static const EVENT_SHOW_HIDEPANEL:String = "event.show.hidepanel";

        public function FLayerEvent(param1:String, param2 = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
