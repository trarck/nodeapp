package com.cntv.player.playerCom.controlBar.view.wideScreen
{
    import flash.utils.*;
    import mx.core.*;

    public class WideButton_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function WideButton_skin()
        {
            this.dataClass = WideButton_skin_dataClass;
            initialWidth = 440 / 20;
            initialHeight = 440 / 20;
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
