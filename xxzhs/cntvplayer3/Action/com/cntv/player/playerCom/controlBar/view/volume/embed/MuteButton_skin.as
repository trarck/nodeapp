package com.cntv.player.playerCom.controlBar.view.volume.embed
{
    import flash.utils.*;
    import mx.core.*;

    public class MuteButton_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function MuteButton_skin()
        {
            this.dataClass = MuteButton_skin_dataClass;
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
