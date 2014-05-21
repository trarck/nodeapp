package com.conviva.utils
{

    public class Trace extends Object
    {
        public static var traceToConsole:Boolean = true;
        public static var traceToTraceViewer:Boolean = true;
        private static var defaultTraceSender:TraceSender = new TraceSender();
        static var extraTracers:Array = new Array();

        public function Trace()
        {
            return;
        }// end function

        public static function addTracer(param1:Function) : void
        {
            extraTracers = extraTracers.concat(param1);
            return;
        }// end function

        public static function AddTracer(param1:Function) : void
        {
            addTracer(param1);
            return;
        }// end function

        public static function removeTracer(param1:Function) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < extraTracers.length)
            {
                
                if (param1 == extraTracers[_loc_2])
                {
                    extraTracers.splice(_loc_2, 1);
                }
                _loc_2++;
            }
            return;
        }// end function

        public static function RemoveTracer(param1:Function) : void
        {
            removeTracer(param1);
            return;
        }// end function

        public static function clearTracers() : void
        {
            extraTracers = new Array();
            return;
        }// end function

        public static function Info(param1:String, ... args) : void
        {
            defaultTraceSender.Info(param1, args);
            return;
        }// end function

        public static function Warning(param1:String, ... args) : void
        {
            defaultTraceSender.Warning(param1, args);
            return;
        }// end function

        public static function Error(param1:String, ... args) : void
        {
            defaultTraceSender.Error(param1, args);
            return;
        }// end function

        public static function Stats(param1:Object) : void
        {
            defaultTraceSender.Stats(param1);
            return;
        }// end function

        public static function stats(param1:Object) : void
        {
            Stats(param1);
            return;
        }// end function

        public static function Init() : void
        {
            defaultTraceSender.ReadConfig();
            return;
        }// end function

        public static function set channelName(param1:String) : void
        {
            defaultTraceSender.ChannelName = param1;
            return;
        }// end function

        public static function set senderId(param1:String) : void
        {
            defaultTraceSender.SenderId = param1;
            return;
        }// end function

        public static function get senderId() : String
        {
            return defaultTraceSender.SenderId;
        }// end function

        public static function set senderName(param1:String) : void
        {
            defaultTraceSender.SenderName = param1;
            return;
        }// end function

    }
}
