package com.conviva
{
    import com.conviva.utils.*;

    public class ConvivaMetricsSession extends ConvivaGenericSession
    {

        public function ConvivaMetricsSession(param1:String)
        {
            var objectId:* = param1;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("ConvivaMetricsSession", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    Utils.Assert(_loc_1 != null, "new ConvivaMetricsSession and LivePass not ready");
                    Reflection.InvokeMethod("newMetricsSession", _loc_1, _apiId, objectId);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaMetricsSession.ctor." + _apiId);
            return;
        }// end function

    }
}
