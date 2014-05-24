package com.cntv.common.events
{
    import com.puremvc.view.event.*;

    public class RadioButtonEvent extends CommonEvent
    {
        public static const EVENT_SELECTED:String = "event.selected";
        public static const EVENT_STREAM_CHANGED:String = "event.stream.change";

        public function RadioButtonEvent(param1:String, param2 = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
