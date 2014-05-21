package com.cntv.common.model
{
    import flash.events.*;

    public class GlobalDispatcher extends EventDispatcher
    {
        public static var instant:GlobalDispatcher;

        public function GlobalDispatcher()
        {
            if (instant == null)
            {
                instant = this;
            }
            return;
        }// end function

        public static function getInstance() : GlobalDispatcher
        {
            if (instant == null)
            {
                instant = new GlobalDispatcher;
            }
            return instant;
        }// end function

    }
}
