package com.cntv.common.view.ui.checkbox.unselect
{
    import flash.utils.*;
    import mx.core.*;

    public class CheckBoxUnselect_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function CheckBoxUnselect_skin()
        {
            this.dataClass = CheckBoxUnselect_skin_dataClass;
            initialWidth = 240 / 20;
            initialHeight = 240 / 20;
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
