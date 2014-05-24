package com.conviva
{
    import com.conviva.*;
    import com.conviva.utils.*;
    import flash.events.*;
    import flash.utils.*;

    public class ConvivaLightSession extends ConvivaGenericSession implements IAdInterruptible
    {
        private var _contentInfo:Object;
        public static const ERROR_CONNECTION_FAILURE:String = "ERROR_CONNECTION_FAILURE";
        public static const ERROR_STREAMING_FAILURE:String = "ERROR_STREAMING_FAILURE";

        public function ConvivaLightSession(param1:Object)
        {
            var contentInfo:* = param1;
            Utils.RunProtected(function ()
            {
                _contentInfo = contentInfo;
                LivePassInit.InvokeWhenReady("ConvivaLightSession", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "new ConvivaLightSession and LivePass not ready");
                    Reflection.InvokeMethod("newLightSession", _loc_1, _apiId, _contentInfo);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.ctor IGNORE " + _apiId);
            return;
        }// end function

        public function reportError(param1:String) : void
        {
            var timeStamp:Number;
            var errorName:* = param1;
            timeStamp = ProtectedTimer.GetEpochMilliseconds();
            LivePassInit.InvokeWhenReady("reportError", function ()
            {
                var _loc_1:* = LivePassInit.Module;
                Utils.Assert(_loc_1 != null, "LivePass not ready");
                Reflection.InvokeMethod("reportSessionErrorWithTimeStamp", _loc_1, _apiId, errorName, timeStamp);
                return;
            }// end function
            );
            return;
        }// end function

        public function reportNetStatusEvent(event:NetStatusEvent) : void
        {
            var timeStamp:Number;
            var event:* = event;
            timeStamp = ProtectedTimer.GetEpochMilliseconds();
            LivePassInit.InvokeWhenReady("reportNetStatusEvent", function ()
            {
                var _loc_1:* = LivePassInit.Module;
                Utils.Assert(_loc_1 != null, "LivePass not ready");
                Reflection.InvokeMethod("reportSessionNetStatusEventWithTimeStamp", _loc_1, _apiId, event, timeStamp);
                return;
            }// end function
            );
            return;
        }// end function

        public function setCurrentResource(param1:String) : void
        {
            var resource:* = param1;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("setCurrentResource", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "setCurrentResource called when LivePass not ready");
                    Reflection.InvokeMethod("setCurrentResource", _loc_1, _apiId, resource);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.setCurrentResource IGNORE " + _apiId);
            return;
        }// end function

        public function setCurrentBitrate(param1:uint) : void
        {
            var bitrateKbps:* = param1;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("setCurrentBitrate", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "setCurrentBitrate called when LivePass not ready");
                    Reflection.InvokeMethod("setCurrentBitrate", _loc_1, _apiId, bitrateKbps);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.setCurrentBitrate IGNORE " + _apiId);
            return;
        }// end function

        public function setContentLength(param1:uint) : void
        {
            var contentLengthSec:* = param1;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("setContentLength", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "setContentLength called when LivePass not ready");
                    Reflection.InvokeMethod("setContentLength", _loc_1, _apiId, contentLengthSec);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.setContentLength IGNORE " + _apiId.toString());
            return;
        }// end function

        public function selectResource(param1:Function) : void
        {
            var callback:* = param1;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("SelectResource", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "selectResource called when LivePass not ready");
                    Reflection.InvokeMethod("selectResource", _loc_1, _apiId, _contentInfo, callback);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.selectResource IGNORE " + _apiId);
            return;
        }// end function

        public function startMonitor(param1:Object, param2:String, param3:Object = null) : void
        {
            var optDict:DictionaryCS;
            var p:String;
            var streamer:* = param1;
            var resource:* = param2;
            var optionsDeprecated:* = param3;
            optDict;
            if (optionsDeprecated != null)
            {
                optDict = new DictionaryCS();
                var _loc_5:int = 0;
                var _loc_6:* = optionsDeprecated;
                while (_loc_6 in _loc_5)
                {
                    
                    p = _loc_6[_loc_5];
                    optDict.Add(p, optionsDeprecated[p]);
                }
            }
            SetJoinStartTimeContentInfo(this._contentInfo);
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("startMonitor", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "startMonitor called before the LivePass is ready");
                    Reflection.InvokeMethod("startMonitor", _loc_1, _apiId, _contentInfo, streamer, resource, optDict);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.startMonitor IGNORE " + _apiId);
            return;
        }// end function

        public function attachStreamer(param1:Object) : void
        {
            var streamer:* = param1;
            LivePassInit.InvokeWhenReady("attachStreamer", function ()
            {
                var _loc_1:* = LivePassInit.Module;
                Utils.Assert(_loc_1 != null, "attachStreamer called before the LivePass is ready");
                var _loc_2:String = null;
                Reflection.InvokeMethod("startMonitor", _loc_1, _apiId, _contentInfo, streamer, _loc_2, null);
                return;
            }// end function
            );
            return;
        }// end function

        public function pauseMonitor() : void
        {
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("pauseMonitor", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "pauseMonitor called when LivePass not ready");
                    Reflection.InvokeMethod("pauseMonitor", _loc_1, _apiId);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.pauseMonitor IGNORE " + _apiId);
            return;
        }// end function

        public function stopMonitor() : void
        {
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("stopMonitor", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "stopMonitor called when LivePass not ready");
                    Reflection.InvokeMethod("stopMonitor", _loc_1, _apiId);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.stopMonitor IGNORE " + _apiId);
            return;
        }// end function

        public function adStart() : void
        {
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("adStart", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "adStart called when LivePass is not ready");
                    Reflection.InvokeMethod("adStart", _loc_1, _apiId);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.adStart IGNORE " + _apiId);
            return;
        }// end function

        public function adEnd() : void
        {
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("adEnd", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "adEnd called when LivePass is not ready");
                    Reflection.InvokeMethod("adEnd", _loc_1, _apiId);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.adEnd IGNORE " + _apiId);
            return;
        }// end function

        public function reportAdError() : void
        {
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("reportAdError", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "reportAdError() called when LivePass is not ready");
                    Reflection.InvokeMethod("reportAdError", _loc_1, _apiId);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaLightSession.reportAdError IGNORE " + _apiId);
            return;
        }// end function

        public static function SetJoinStartTimeContentInfo(param1:Object) : void
        {
            var _loc_3:Number = NaN;
            var _loc_2:* = Lang.DictionaryFromRepr(Reflection.GetProperty("monitoringOptions", param1));
            if (_loc_2 == null)
            {
                _loc_2 = new DictionaryCS();
            }
            if (!_loc_2.ContainsKey("joinStartTime"))
            {
                _loc_2.SetValue("joinStartTime", ProtectedTimer.GetEpochMilliseconds().toString());
            }
            else
            {
                try
                {
                    _loc_3 = Number(_loc_2.GetValue("joinStartTime"));
                    if (_loc_3 < ProtectedTimer.GetEpochMilliseconds() - 3600 * 1000)
                    {
                        _loc_3 = _loc_3 + (ProtectedTimer.GetEpochMilliseconds() - getTimer());
                        _loc_2.SetValue("joinStartTime", _loc_3.toString());
                    }
                }
                catch (e)
                {
                }
            }
            Reflection.SetProperty("monitoringOptions", param1, _loc_2);
            return;
        }// end function

    }
}
