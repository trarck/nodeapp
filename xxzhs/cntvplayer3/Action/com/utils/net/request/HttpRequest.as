package com.utils.net.request
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class HttpRequest extends URLLoaderEvent
    {
        private var targetFunc:Function;
        private var errorFunc:Function;
        private var hasSentError:Boolean = false;
        public var overtimeTimer:uint;
        public var isOverTime:Boolean = false;
        public static const OVERTIME:int = 5;

        public function HttpRequest(param1:AttributeVo, param2:Function, param3:Function = null)
        {
            var _loc_5:URLRequest = null;
            var _loc_6:URLVariables = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_9:Boolean = false;
            var _loc_10:int = 0;
            var _loc_11:String = null;
            this.targetFunc = param2;
            this.errorFunc = param3;
            var _loc_4:* = new URLLoader();
            super(_loc_4);
            if (param1.request != null)
            {
                if (param1.method == URLRequestMethod.POST)
                {
                    _loc_5 = new URLRequest(param1.url);
                    _loc_6 = new URLVariables();
                    for (_loc_7 in param1.request)
                    {
                        
                        _loc_6[_loc_7] = param1.request[_loc_7];
                    }
                    _loc_5.data = _loc_6;
                    _loc_5.method = param1.method;
                }
                else
                {
                    _loc_8 = param1.url;
                    if (_loc_8.indexOf("?") < 0)
                    {
                        _loc_8 = _loc_8 + "?";
                    }
                    _loc_8 = _loc_8 + "aa=1";
                    _loc_9 = _loc_8.indexOf("=") < 0;
                    _loc_10 = 0;
                    for (_loc_11 in param1.request)
                    {
                        
                        if (_loc_10 == 0 && _loc_9)
                        {
                            _loc_8 = _loc_8 + (_loc_11 + "=" + param1.request[_loc_11]);
                        }
                        else
                        {
                            _loc_8 = _loc_8 + ("&" + _loc_11 + "=" + param1.request[_loc_11]);
                        }
                        _loc_10++;
                    }
                    _loc_5 = new URLRequest(_loc_8);
                }
            }
            else
            {
                _loc_5 = new URLRequest(param1.url);
            }
            _loc_4.load(_loc_5);
            this.overtimeTimer = setTimeout(this.timeOut, OVERTIME * 1000);
            return;
        }// end function

        public function timeOut() : void
        {
            clearTimeout(this.overtimeTimer);
            if (this.errorFunc != null && !this.hasSentError && !this.isOverTime)
            {
                this.errorFunc("timeOut");
                this.theadOver();
            }
            return;
        }// end function

        override protected function completeHandler(event:Event) : void
        {
            clearTimeout(this.overtimeTimer);
            if (this.targetFunc != null)
            {
                this.targetFunc(event.target.data);
                this.theadOver();
            }
            return;
        }// end function

        override protected function ioErrorHandler(event:IOErrorEvent) : void
        {
            clearTimeout(this.overtimeTimer);
            if (this.errorFunc != null && !this.hasSentError && !this.isOverTime)
            {
                this.errorFunc("ioError");
                this.theadOver();
            }
            return;
        }// end function

        override protected function httpStatusHandler(event:HTTPStatusEvent) : void
        {
            clearTimeout(this.overtimeTimer);
            if (event.status >= 400 || event.status == 300 || event.status == 0)
            {
                if (this.errorFunc != null && !this.hasSentError && !this.isOverTime)
                {
                    this.errorFunc("httpStatu" + event.status);
                    this.theadOver();
                }
            }
            return;
        }// end function

        override protected function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            clearTimeout(this.overtimeTimer);
            if (this.errorFunc != null && !this.hasSentError && !this.isOverTime)
            {
                this.errorFunc("securityError");
                this.theadOver();
            }
            return;
        }// end function

        private function theadOver() : void
        {
            this.errorFunc = null;
            this.targetFunc = null;
            this.hasSentError = true;
            this.isOverTime = true;
            return;
        }// end function

    }
}
