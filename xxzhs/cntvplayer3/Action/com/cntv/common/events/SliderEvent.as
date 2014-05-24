package com.cntv.common.events
{
    import com.puremvc.view.event.*;

    public class SliderEvent extends CommonEvent
    {
        public static const EVENT_SLIDER_MOVE:String = "event.slider.move";

        public function SliderEvent(param1:String, param2 = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
