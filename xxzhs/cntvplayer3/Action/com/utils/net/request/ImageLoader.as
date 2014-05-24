package com.utils.net.request
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class ImageLoader extends Loader
    {
        protected var completeFun:Function;
        protected var errorFun:Function;
        public static const IOERROR:String = "image load ioError";
        public static const SECURITY_ERROR:String = "image load securityError";

        public function ImageLoader(param1:URLRequest, param2:Function, param3:Function)
        {
            if (param1.url == "")
            {
                this.param3(IOERROR);
            }
            else
            {
                this.completeFun = param2;
                this.errorFun = param3;
                this.contentLoaderInfo.addEventListener(Event.INIT, this.getData);
                this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
                this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
                this.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatuErrorHandler);
                this.load(param1, new LoaderContext(true));
            }
            return;
        }// end function

        protected function getData(event:Event) : void
        {
            if (this.completeFun != null)
            {
                this.completeFun(this);
            }
            return;
        }// end function

        protected function ioErrorHandler(event:Event) : void
        {
            if (this.errorFun != null)
            {
                this.errorFun(IOERROR);
            }
            return;
        }// end function

        protected function securityErrorHandler(event:Event) : void
        {
            if (this.errorFun != null)
            {
                this.errorFun(SECURITY_ERROR);
            }
            return;
        }// end function

        protected function httpStatuErrorHandler(event:HTTPStatusEvent) : void
        {
            return;
        }// end function

    }
}
