package com.cntv.player.widgets.views.replayButton
{
    import flash.utils.*;
    import mx.core.*;

    public class ReplayButton_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function ReplayButton_skin()
        {
            this.dataClass = ReplayButton_skin_dataClass;
            initialWidth = 600 / 20;
            initialHeight = 600 / 20;
            return;
        }// end function

        override public function get movieClipData() : ByteArray
        {
            if (bytes == null)
            {
                bytes = ByteArray(new this.dataClass());
            }
            return bytes;
        }// end function

    }
}
