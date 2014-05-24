package com.conviva
{

    public interface IAdInterruptible
    {

        public function IAdInterruptible();

        function adStart() : void;

        function adEnd() : void;

        function reportAdError() : void;

    }
}
