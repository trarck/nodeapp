package com.cntv.player.playerCom.controlBar.view.fullScreen
{
    import flash.utils.*;
    import mx.core.*;

    public class NormalScreenButton_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function NormalScreenButton_skin()
        {
            this.dataClass = NormalScreenButton_skin_dataClass;
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
