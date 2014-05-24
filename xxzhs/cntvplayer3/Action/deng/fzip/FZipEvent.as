package deng.fzip
{
    import flash.events.*;

    public class FZipEvent extends Event
    {
        public var file:FZipFile;
        public static const FILE_LOADED:String = "fileLoaded";

        public function FZipEvent(param1:String, param2:FZipFile = null, param3:Boolean = false, param4:Boolean = false)
        {
            this.file = param2;
            super(param1, param3, param4);
            return;
        }// end function

        override public function clone() : Event
        {
            return new FZipEvent(type, this.file, bubbles, cancelable);
        }// end function

        override public function toString() : String
        {
            return "[FZipEvent type=\"" + type + "\" filename=\"" + this.file.filename + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
        }// end function

    }
}
