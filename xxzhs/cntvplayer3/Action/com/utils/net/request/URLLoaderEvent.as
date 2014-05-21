package com.utils.net.request
{
    import flash.events.*;
    import flash.net.*;

    public class URLLoaderEvent extends Object
    {
        private var loader:URLLoader;

        public function URLLoaderEvent(param1:URLLoader)
        {
            this.loader = param1;
            this.configureListeners();
            return;
        }// end function

        protected function completeHandler(event:Event) : void
        {
            return;
        }// end function

        protected function openHandler(event:Event) : void
        {
            return;
        }// end function

        protected function progressHandler(event:ProgressEvent) : void
        {
            return;
        }// end function

        protected function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

        protected function httpStatusHandler(event:HTTPStatusEvent) : void
        {
            return;
        }// end function

        protected function ioErrorHandler(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function configureListeners() : void
        {
            this.loader.addEventListener(Event.COMPLETE, this.completeHandler);
            this.loader.addEventListener(Event.OPEN, this.openHandler);
            this.loader.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            return;
        }// end function

        protected function removeListeners() : void
        {
            this.loader.removeEventListener(Event.COMPLETE, this.completeHandler);
            this.loader.removeEventListener(Event.OPEN, this.openHandler);
            this.loader.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this.loader = null;
            return;
        }// end function

    }
}
