package com.conviva.utils
{

    public interface IProtectedTimer
    {

        public function IProtectedTimer();

        function Start() : void;

        function Stop() : void;

        function IsRunning() : Boolean;

        function ChangeInterval(param1:int) : void;

        function Reset() : void;

        function Cleanup() : void;

    }
}
