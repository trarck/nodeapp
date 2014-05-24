package com.cntv.common.view.ui
{
    import flash.utils.*;
    import mx.core.*;

    public class CloseButton_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function CloseButton_skin()
        {
            this.dataClass = CloseButton_skin_dataClass;
            initialWidth = 180 / 20;
            initialHeight = 180 / 20;
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
