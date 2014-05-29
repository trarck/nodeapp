package com.utils.net.request
{
    import com.cntv.common.model.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.utils.*;

    public class HttpSortRequest extends URLLoaderEvent
    {
        private var targetFunc:Function;
        private var errorFunc:Function;
        public var overtimeTimer:uint;
        public var isOverTime:Boolean = false;
        public static const OVERTIME:int = 3;

        public function HttpSortRequest(param1:AttributeSortVo, param2:Function, param3:Function = null)
        {
            var _loc_5:URLRequest = null;
            var _loc_6:URLVariables = null;
            var _loc_7:int = 0;
            var _loc_8:ValueOBJ = null;
            var _loc_9:String = null;
            var _loc_10:Boolean = false;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:ValueOBJ = null;
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
                    _loc_7 = 0;
                    while (_loc_7 < param1.request.length)
                    {
                        
                        _loc_8 = ValueOBJ(param1.request[_loc_7]);
                        _loc_6[_loc_8.k] = _loc_8.v;
                        _loc_7++;
                    }
                    _loc_5.data = _loc_6;
                    _loc_5.method = param1.method;
                }
                else
                {
                    _loc_9 = param1.url;
                    if (_loc_9.indexOf("?") < 0)
                    {
                        _loc_9 = _loc_9 + "?";
                    }
                    _loc_10 = _loc_9.indexOf("=") < 0;
                    _loc_11 = 0;
                    _loc_12 = 0;
                    while (_loc_12 < param1.request.length)
                    {
                        
                        _loc_13 = ValueOBJ(param1.request[_loc_12]);
                        if (_loc_11 == 0 && _loc_10)
                        {
                            _loc_9 = _loc_9 + (_loc_13.k + "=" + _loc_13.v);
                        }
                        else
                        {
                            _loc_9 = _loc_9 + ("&" + _loc_13.k + "=" + _loc_13.v);
                        }
                        _loc_11++;
                        _loc_12++;
                    }
                    if (ExternalInterface.available && ModelLocator.getInstance().ISWEBSITE)
                    {
                        ExternalInterface.call("_sendTestData", _loc_9);
                    }
                    _loc_5 = new URLRequest(_loc_9);
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
            this.isOverTime = true;
            this.errorFunc();
            return;
        }// end function

        override protected function completeHandler(event:Event) : void
        {
            clearTimeout(this.overtimeTimer);
            if (this.targetFunc != null && !this.isOverTime)
            {
                this.targetFunc(event.target.data);
            }
            return;
        }// end function

        override protected function ioErrorHandler(event:IOErrorEvent) : void
        {
            clearTimeout(this.overtimeTimer);
            if (this.errorFunc != null && !this.isOverTime)
            {
                this.errorFunc();
            }
            return;
        }// end function

        override protected function httpStatusHandler(event:HTTPStatusEvent) : void
        {
            clearTimeout(this.overtimeTimer);
            if (event.status >= 400 || event.status == 300)
            {
                if (this.errorFunc != null && !this.isOverTime)
                {
                    this.errorFunc();
                }
            }
            return;
        }// end function

        override protected function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            clearTimeout(this.overtimeTimer);
            if (this.errorFunc != null && !this.isOverTime)
            {
                this.errorFunc();
            }
            return;
        }// end function

    }
}
