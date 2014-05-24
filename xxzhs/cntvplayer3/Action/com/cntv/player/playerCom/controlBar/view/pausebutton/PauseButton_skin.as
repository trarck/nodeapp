package com.cntv.player.playerCom.controlBar.view.pausebutton
{
    import flash.utils.*;
    import mx.core.*;

    public class PauseButton_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function PauseButton_skin()
        {
            this.dataClass = PauseButton_skin_dataClass;
            initialWidth = 800 / 20;
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
