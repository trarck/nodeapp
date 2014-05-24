package com.cntv.player.playerCom.controlBar.view.progressBar
{
    import flash.utils.*;
    import mx.core.*;

    public class LoadedBar_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function LoadedBar_skin()
        {
            this.dataClass = LoadedBar_skin_dataClass;
            initialWidth = 200 / 20;
            initialHeight = 160 / 20;
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
