package com.utils.net.request
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class SWFLoader extends ImageLoader
    {
        private const OVERTIME:int = 5;
        private var overTimer:uint;

        public function SWFLoader(param1:URLRequest, param2:Function, param3:Function)
        {
            super(param1, param2, param3);
            this.overTimer = setTimeout(this.overTimeError, this.OVERTIME * 1000);
            return;
        }// end function

        override protected function getData(event:Event) : void
        {
            clearTimeout(this.overTimer);
            if (completeFun != null)
            {
                completeFun(this);
            }
            return;
        }// end function

        override protected function ioErrorHandler(event:Event) : void
        {
            if (errorFun != null)
            {
                clearTimeout(this.overTimer);
                errorFun("load swf io error");
            }
            return;
        }// end function

        override protected function securityErrorHandler(event:Event) : void
        {
            if (errorFun != null)
            {
                clearTimeout(this.overTimer);
                errorFun("load swf security error");
            }
            return;
        }// end function

        private function overTimeError() : void
        {
            if (errorFun != null)
            {
                errorFun("load swf time out");
                errorFun = null;
                completeFun = null;
            }
            return;
        }// end function

        public function destroy() : void
        {
            clearTimeout(this.overTimer);
            completeFun = null;
            errorFun = null;
            return;
        }// end function

    }
}
