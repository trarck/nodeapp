package com.conviva
{
    import com.conviva.utils.*;

    public class ConvivaGenericSession extends Object
    {
        protected var _apiId:int;
        var _metrics:MetricsProxy = null;
        static var _nextSessionId:int = 0;

        public function ConvivaGenericSession()
        {
            this._apiId = _nextSessionId;
            var _loc_2:* = _nextSessionId + 1;
            _nextSessionId = _loc_2;
            this._metrics = new MetricsProxy(this._apiId);
            return;
        }// end function

        public function get id() : int
        {
            return this._apiId;
        }// end function

        public function get metrics() : ICustomMetrics
        {
            return this._metrics;
        }// end function

        public function cleanup() : void
        {
            this._metrics = null;
            Utils.RunProtected(function ()
            {
                LivePassInit.InvokeWhenReady("Cleanup", function ()
                {
                    var _loc_1:* = LivePassInit.Module;
                    if (_loc_1 == null)
                    {
                        return;
                    }
                    Reflection.InvokeMethod("cleanupSession", _loc_1, _apiId);
                    return;
                }// end function
                );
                return;
            }// end function
            , "ConvivaGenericSession.cleanup IGNORE " + this._apiId);
            return;
        }// end function

    }
}
