package com.cntv.common.tools.memory
{
    import flash.net.*;

    public class MemClean extends Object
    {

        public function MemClean()
        {
            return;
        }// end function

        public static function run() : void
        {
            var doclean:* = function () : void
            {
                try
                {
                    new LocalConnection().connect("null");
                    new LocalConnection().connect("null");
                }
                catch (error:Error)
                {
                }
                return;
            }// end function
            ;
            MemClean.doclean();
            MemClean.doclean();
            MemClean.doclean();
            return;
        }// end function

    }
}
