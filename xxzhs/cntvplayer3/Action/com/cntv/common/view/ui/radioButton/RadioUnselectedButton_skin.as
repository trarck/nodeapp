package com.cntv.common.view.ui.radioButton
{
    import flash.utils.*;
    import mx.core.*;

    public class RadioUnselectedButton_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function RadioUnselectedButton_skin()
        {
            this.dataClass = RadioUnselectedButton_skin_dataClass;
            initialWidth = 206 / 20;
            initialHeight = 206 / 20;
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
