package com.cntv.player.playerCom.relativeList.event
{
    import com.puremvc.view.event.*;

    public class RelativeEvent extends CommonEvent
    {
        public static const EVENT_DO_REPLAY:String = "event.do.replay";
        public static const EVENT_GET_LIST_DATA:String = "event.get.list.data";
        public static const EVENT_GET_LIST_DATA_ERROR:String = "event.get.list.data.error";
        public static const EVENT_GET_DATA_FAIL:String = "event.get.data.fail";
        public static const EVENT_GET_LIST_TITLE:String = "event.get.list.title";
        public static const EVENT_GET_LIST_TITLE_ERROR:String = "event.get.list.title.error";

        public function RelativeEvent(param1:String)
        {
            super(param1);
            return;
        }// end function

    }
}
