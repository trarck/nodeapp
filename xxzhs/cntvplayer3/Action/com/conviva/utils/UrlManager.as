package com.conviva.utils
{
    import com.conviva.*;

    public class UrlManager extends Object
    {
        private var _apiNotifier:Function = null;
        private var _urlList:Array;
        private var _busy:Boolean = false;
        private var _callbackCount:int = 0;
        private var _isTimeout:Boolean = false;
        private var _urlTimeoutMs:Number = 0;
        private var _urlTimer:ProtectedTimer = null;
        private var _sendSDMFunc:Function = null;
        private var _urlTraces:DictionaryCS = null;
        private var _startTimeMs:Number = 0;
        private var _resourceStr:String = "";
        private var _logPrefix:String = "";
        private static const EXCEPTION_URL_GENERATOR:int = -1;
        private static const NORMAL_URL_GENERATOR:int = 0;
        private static const EVENT_URL_GENERATOR_TRACE:String = "eUrlTrace";
        private static const ATTR_URL_GENERATOR_TYPE:String = "type";
        private static const ATTR_URL_GENERATOR_RESULT:String = "result";
        private static const ATTR_URL_GENERATOR_TIME:String = "time";
        private static const ATTR_URL_GENERATOR_THRESHOLD:String = "threshold";
        private static const ATTR_URL_GENERATOR_TOTAL_NUMBER:String = "totalnumber";
        private static const ATTR_URL_GENERATOR_FALLBACK:String = "fallback";
        private static const COMPONENT_PREFIX:String = "URL";

        public function UrlManager(param1:Function, param2:int = 0, param3:Function = null, param4:Number = -1)
        {
            this._urlList = [];
            this._urlList = [];
            this._sendSDMFunc = param3;
            this._busy = false;
            this._isTimeout = false;
            this._apiNotifier = param1;
            this._urlTraces = new DictionaryCS();
            this._urlTimeoutMs = param4 * 1000;
            this._logPrefix = COMPONENT_PREFIX + "[" + param2 + "]";
            return;
        }// end function

        public function cleanup() : void
        {
            this._urlList = [];
            this._busy = false;
            this._isTimeout = false;
            this._apiNotifier = null;
            this._urlTimer = Utils.genericCleanup(this._urlTimer);
            this._sendSDMFunc = null;
            this._urlTraces = null;
            return;
        }// end function

        public function generateList(param1:Array, param2:Function, param3:Function) : Array
        {
            var _loc_6:Object = null;
            Utils.Assert(this._busy == false, "UrlManager Last tokenization has not ended");
            Utils.Assert(param1 != null, "UrlManager receive 0 request");
            Utils.Assert(param2 != null, "Generator should not be null");
            var _loc_4:Array = null;
            this.notifyStart();
            this._urlTraces.SetValue(ATTR_URL_GENERATOR_TOTAL_NUMBER, param1.length.toString());
            this._urlTraces.SetValue(ATTR_URL_GENERATOR_THRESHOLD, this._urlTimeoutMs.toString());
            this._urlTraces.SetValue(ATTR_URL_GENERATOR_RESULT, "Success");
            this._resourceStr = param1[0].resource;
            this._startTimeMs = ProtectedTimer.GetTickCountMs();
            if (this._urlTimeoutMs > 0)
            {
                this._urlTimer = new ProtectedTimer(this._urlTimeoutMs, this.tokenCreateTimeout, "UrlManager.generateList");
            }
            var _loc_5:Boolean = false;
            this.notifyBegin();
            for each (_loc_6 in param1)
            {
                
                if (this.generateUrl(param2, _loc_6, param3, param1.length) == EXCEPTION_URL_GENERATOR)
                {
                    _loc_5 = true;
                    break;
                }
            }
            if (_loc_5)
            {
                this._urlTraces.SetValue(ATTR_URL_GENERATOR_FALLBACK, "GeneratorFallback");
                if (this.generateUrls(param2, param1, param3) == EXCEPTION_URL_GENERATOR)
                {
                    this._urlTraces.SetValue(ATTR_URL_GENERATOR_RESULT, "Exception");
                    this.notifyEnd();
                    return _loc_4;
                }
            }
            if (this._urlList.length > 0)
            {
                if (this._urlList.length != param1.length)
                {
                    this._urlTraces.SetValue(ATTR_URL_GENERATOR_RESULT, "Size Mismatch");
                }
                _loc_4 = this._urlList;
                this._urlList = [];
                this.notifyEnd();
            }
            return _loc_4;
        }// end function

        private function generateUrl(param1:Function, param2:Object, param3:Function, param4:int) : int
        {
            var generator:* = param1;
            var item:* = param2;
            var callback:* = param3;
            var numRequests:* = param4;
            var callbackSingleStream:* = function (param1:String) : void
            {
                var returnUrl:* = param1;
                Utils.RunProtected(function () : void
                {
                    if (!hasUrlForItem(item))
                    {
                        _urlList.push({id:item, url:returnUrl});
                        notifyOutput((_urlList.length - 1), item.resource, returnUrl);
                    }
                    if (_urlList.length == numRequests && _busy && !_isTimeout)
                    {
                        notifyEnd();
                        callback(_urlList);
                        _urlList = [];
                    }
                    return;
                }// end function
                , "callbackSingleStream");
                return;
            }// end function
            ;
            var ret:String;
            try
            {
                ret = this.generator(item.resource, item.objectId, item.bitrate, callbackSingleStream);
            }
            catch (e:ArgumentError)
            {
                try
                {
                    ret = this.generator(item.resource, item.objectId, item.bitrate);
                }
                catch (e)
                {
                    return EXCEPTION_URL_GENERATOR;
                }
                ;
            }
            catch (e:)
            {
                return EXCEPTION_URL_GENERATOR;
                if (ret != null)
                {
                    this._urlTraces.SetValue(ATTR_URL_GENERATOR_TYPE, "Sync");
                    this._urlList.push({id:item, url:ret});
                    this.notifyOutput((this._urlList.length - 1), item.resource, ret);
                }
                else
                {
                    this._urlTraces.SetValue(ATTR_URL_GENERATOR_TYPE, "Async");
                }
                return NORMAL_URL_GENERATOR;
        }// end function

        private function generateUrls(param1:Function, param2:Array, param3:Function) : int
        {
            var ix:int;
            var generator:* = param1;
            var reqList:* = param2;
            var callback:* = param3;
            var callbackMultipleStreams:* = function (param1:Array) : void
            {
                var returnUrls:* = param1;
                Utils.RunProtected(function () : void
                {
                    if (reqList.length != returnUrls.length)
                    {
                        _urlTraces.SetValue(ATTR_URL_GENERATOR_RESULT, "Failure");
                        notifyEnd();
                        return;
                    }
                    if (_isTimeout || !_busy)
                    {
                        return;
                    }
                    ix = 0;
                    while (ix < returnUrls.length)
                    {
                        
                        _urlList.push({id:reqList[ix], url:returnUrls[ix]});
                        notifyOutput(ix, reqList[ix].resource, returnUrls[ix]);
                        var _loc_2:* = ix + 1;
                        ix = _loc_2;
                    }
                    notifyEnd();
                    callback(_urlList);
                    _urlList = [];
                    return;
                }// end function
                , "callbackMultipleStreams");
                return;
            }// end function
            ;
            ix;
            var streamArray:Array;
            ix;
            while (ix < reqList.length)
            {
                
                streamArray.push({objectId:reqList[ix].objectId, bitrate:reqList[ix].bitrate});
                ix = (ix + 1);
            }
            var retArray:Array;
            try
            {
                retArray = this.generator(this._resourceStr, streamArray, callbackMultipleStreams);
            }
            catch (e:Error)
            {
                return EXCEPTION_URL_GENERATOR;
            }
            if (retArray)
            {
                this._urlTraces.SetValue(ATTR_URL_GENERATOR_TYPE, "Sync");
                this._urlList = [];
                ix;
                while (ix < retArray.length)
                {
                    
                    this._urlList.push({id:reqList[ix], url:retArray[ix]});
                    this.notifyOutput(ix, reqList[ix].resource, retArray[ix]);
                    ix = (ix + 1);
                }
            }
            else
            {
                this._urlTraces.SetValue(ATTR_URL_GENERATOR_TYPE, "Async");
            }
            return NORMAL_URL_GENERATOR;
        }// end function

        private function sendTrace(param1:DictionaryCS) : void
        {
            if (this._urlTimeoutMs < 0)
            {
                return;
            }
            if (this._sendSDMFunc != null)
            {
                this._sendSDMFunc(EVENT_URL_GENERATOR_TRACE, param1);
            }
            return;
        }// end function

        private function tokenCreateTimeout() : void
        {
            this._isTimeout = true;
            this._urlTraces.SetValue(ATTR_URL_GENERATOR_RESULT, "Timeout");
            this.notifyEnd();
            return;
        }// end function

        private function notifyStart() : void
        {
            this._apiNotifier(true, null);
            return;
        }// end function

        private function notifyBegin() : void
        {
            this._busy = true;
            var _loc_1:* = Utils.dicCSToString(this._urlTraces);
            Trace.Info(this._logPrefix + "[URL_GEN_BEGIN]", _loc_1);
            return;
        }// end function

        private function notifyOutput(param1:int, param2:String, param3:String) : void
        {
            var _loc_4:* = "{num: " + param1 + " input: " + param2 + " output: " + param3 + "}";
            Trace.Info(this._logPrefix + "[URL_GEN_ITEM]", _loc_4);
            return;
        }// end function

        private function notifyEnd() : void
        {
            this._urlTimer = Utils.genericCleanup(this._urlTimer);
            this._urlTraces.SetValue(ATTR_URL_GENERATOR_TIME, (ProtectedTimer.GetTickCountMs() - this._startTimeMs).toString());
            this._busy = false;
            var _loc_1:* = Utils.dicCSToString(this._urlTraces);
            Trace.Info(this._logPrefix + "[URL_GEN_END]", _loc_1);
            if (this._urlTraces.GetValue(ATTR_URL_GENERATOR_RESULT) != "Success")
            {
                this._apiNotifier(false, new ConvivaNotification(ConvivaNotification.ERROR_ARGUMENT, "Executing url generator failed: " + _loc_1, this._resourceStr));
            }
            else
            {
                this._apiNotifier(false, null);
            }
            this.sendTrace(this._urlTraces);
            return;
        }// end function

        private function hasUrlForItem(param1:Object) : Boolean
        {
            var _loc_2:Object = null;
            for each (_loc_2 in this._urlList)
            {
                
                if (Utils.objectIsSame(_loc_2.id, param1))
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function get urlTrace() : DictionaryCS
        {
            return this._urlTraces;
        }// end function

    }
}
