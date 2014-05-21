package com.puremvc.view.event
{
    import flash.events.*;

    public class CommonEvent extends Event
    {
        private var _data:Object;

        public function CommonEvent(param1:String, param2 = null, param3:Boolean = false, param4:Boolean = false)
        {
            this._data = param2;
            super(param1, param3, param4);
            return;
        }// end function

        public function get data()
        {
            return this._data;
        }// end function

    }
}
