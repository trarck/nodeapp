package com.cntv.player.playerCom.controlBar.view.bitrate
{
    import flash.utils.*;
    import mx.core.*;

    public class BitrateButton_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function BitrateButton_skin()
        {
            this.dataClass = BitrateButton_skin_dataClass;
            initialWidth = 440 / 20;
            initialHeight = 400 / 20;
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
