package com.conviva
{

    public interface ICustomMetrics
    {

        public function ICustomMetrics();

        function sendEvent(param1:String, param2:Object) : void;

        function sendEvent2(param1:String, param2:Object, param3:Object, param4:Object) : void;

        function sendMeasurement(param1:String, param2:Object, param3:Number) : void;

        function setState(param1:Object) : void;

    }
}
