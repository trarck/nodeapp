package com.cntv.player.playerCom.statuBox.event
{
    import com.puremvc.view.event.*;

    public class StatuBoxEvent extends CommonEvent
    {
        public static const TYPE_FLIP:int = 0;
        public static const TYPE_CENTER:int = 1;
        public static const EVENT_SHOW_RELATIVE:String = "event.show.relative";
        public static const EVENT_SHOW_MESSAGE:String = "event.show.message";
        public static const EVENT_HIDE_MESSAGE:String = "event.hide.message";
        public static const EVENT_SHOW_CENTER_MESSAGE:String = "event.show.center.message";
        public static const EVENT_HIDE_CENTER_MESSAGE:String = "event.hide.center.message";
        public static const EVENT_SHOW_LOADING:String = "event.show.loading";
        public static const EVENT_HIDE_LOADING:String = "event.hide.loading";
        public static const EVENT_SHOW_BUFFER:String = "event.show.buffer";
        public static const EVENT_HIDE_BUFFER:String = "event.hide.buffer";
        public static const EVENT_SHOW_P2P_NOTICE:String = "event.show.p2p.notice";
        public static const EVENT_HIDE_P2P_NOTICE:String = "event.hide.p2p.notice";
        public static const EVENT_SHOW_NOTICE_MESSAGE:String = "event.shoe.notice.message";
        public static const EVENT_CHANGERATE_CLICKED:String = "event.change.rate.clicked";
        public static const EVENT_BUFFER_READY:String = "event.buffer.ready";
        public static const EVENT_HIDE_TITLE_BAR:String = "event.hide.title.bar";
        public static const EVENT_SHOW_TITLE_BAR:String = "event.show.title.bar";

        public function StatuBoxEvent(param1:String, param2)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
