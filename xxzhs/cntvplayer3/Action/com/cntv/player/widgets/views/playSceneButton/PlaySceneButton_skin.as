package com.cntv.player.widgets.views.playSceneButton
{
    import flash.utils.*;
    import mx.core.*;

    public class PlaySceneButton_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function PlaySceneButton_skin()
        {
            this.dataClass = PlaySceneButton_skin_dataClass;
            initialWidth = 1400 / 20;
            initialHeight = 1200 / 20;
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
