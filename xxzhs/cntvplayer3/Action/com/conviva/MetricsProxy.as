package com.conviva
{
    import com.conviva.*;
    import com.conviva.utils.*;

    class MetricsProxy extends Object implements ICustomMetrics
    {
        private var _apiId:int;

        function MetricsProxy(param1:int)
        {
            this._apiId = param1;
            return;
        }// end function

        public function sendEvent(param1:String, param2:Object) : void
        {
            var name:* = param1;
            var filterAttrs:* = param2;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("metricsSendEvent", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Reflection.InvokeMethod("metricsSendEvent", _loc_1, _apiId, name, filterAttrs);
                    return;
                }// end function
                );
                return;
            }// end function
            , "MetricsProxy.sendEvent");
            return;
        }// end function

        public function sendEvent2(param1:String, param2:Object, param3:Object, param4:Object) : void
        {
            var name:* = param1;
            var states:* = param2;
            var attributes:* = param3;
            var measurements:* = param4;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("metricsSendEvent2", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Reflection.InvokeMethod("metricsSendEvent2", _loc_1, _apiId, name, states, attributes, measurements);
                    return;
                }// end function
                );
                return;
            }// end function
            , "MetricsProxy.sendEvent2");
            return;
        }// end function

        public function sendMeasurement(param1:String, param2:Object, param3:Number) : void
        {
            var name:* = param1;
            var filterAttrs:* = param2;
            var value:* = param3;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("sendMeasurement", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Reflection.InvokeMethod("metricsSendMeasurement", _loc_1, _apiId, name, filterAttrs, value);
                    return;
                }// end function
                );
                return;
            }// end function
            , "MetricsProxy.sendMeasurement");
            return;
        }// end function

        public function setState(param1:Object) : void
        {
            var changes:* = param1;
            Utils.RunProtected(function ()
            {
                var _loc_1:* = LivePassInit.Module;
                Utils.Assert(_loc_1 != null, "SetState and LivePass not ready");
                Reflection.InvokeMethod("metricsSetState", _loc_1, _apiId, changes);
                return;
            }// end function
            , "MetricsProxy.setState");
            return;
        }// end function

        public function numPending() : int
        {
            var module:Object;
            var resObj:Object;
            var res:int;
            try
            {
                module = LivePassInit.Module;
                Utils.Assert(module != null, "NumPending and LivePass not ready");
                resObj = Reflection.InvokeMethod("metricsNumPending", module, this._apiId);
                res = int(resObj);
            }
            catch (e:Error)
            {
                Utils.UncaughtException("NumPending", e);
            }
            return res;
        }// end function

    }
}
