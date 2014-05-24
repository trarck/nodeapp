package p2pstream.events
{
    import flash.events.*;

    public class StreamingEvent extends Event
    {
        private var _info:Object;
        public static const SOCKET_ERROR:String = "ssSocketError";
        public static const SET_CONFIG:String = "setConfig";
        public static const SET_META_DATA:String = "setMetaData";
        public static const FILE_SWITCH:String = "fileSwitch";
        public static const DRAW_SNAPSHOT:String = "drawSnapshot";
        public static const STOP_SNAPSHOT:String = "stopSnapshot";
        public static const HAVE_SNAPSHOT:String = "haveSnapshot";

        public function StreamingEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
        {
            super(param1, param2, param3);
            this._info = param4;
            return;
        }// end function

        override public function clone() : Event
        {
            return new StreamingEvent(type, bubbles, cancelable, this.info);
        }// end function

        public function get info() : Object
        {
            return this._info;
        }// end function

    }
}
