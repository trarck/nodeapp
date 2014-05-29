package com.cntv.common.view.ui.loadingView
{
    import flash.utils.*;
    import mx.core.*;

    public class BufferBigIcon_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function BufferBigIcon_skin()
        {
            this.dataClass = BufferBigIcon_skin_dataClass;
            initialWidth = 1400 / 20;
            initialHeight = 120 / 20;
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
