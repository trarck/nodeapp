package deng.fzip
{
    import flash.events.*;

    public class FZipErrorEvent extends Event
    {
        public var text:String;
        public static const PARSE_ERROR:String = "parseError";

        public function FZipErrorEvent(param1:String, param2:String = "", param3:Boolean = false, param4:Boolean = false)
        {
            this.text = param2;
            super(param1, param3, param4);
            return;
        }// end function

        override public function clone() : Event
        {
            return new FZipErrorEvent(type, this.text, bubbles, cancelable);
        }// end function

    }
}
