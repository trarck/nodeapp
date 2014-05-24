package com.cntv.common.view.ui
{
    import flash.utils.*;
    import mx.core.*;

    public class BufferIcon_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function BufferIcon_skin()
        {
            this.dataClass = BufferIcon_skin_dataClass;
            initialWidth = 260 / 20;
            initialHeight = 260 / 20;
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
