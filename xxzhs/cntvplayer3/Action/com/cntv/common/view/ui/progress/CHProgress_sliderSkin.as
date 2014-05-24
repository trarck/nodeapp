package com.cntv.common.view.ui.progress
{
    import flash.utils.*;
    import mx.core.*;

    public class CHProgress_sliderSkin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function CHProgress_sliderSkin()
        {
            this.dataClass = CHProgress_sliderSkin_dataClass;
            initialWidth = 320 / 20;
            initialHeight = 300 / 20;
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
