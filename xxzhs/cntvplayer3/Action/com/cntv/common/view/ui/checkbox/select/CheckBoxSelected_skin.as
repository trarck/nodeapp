package com.cntv.common.view.ui.checkbox.select
{
    import flash.utils.*;
    import mx.core.*;

    public class CheckBoxSelected_skin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function CheckBoxSelected_skin()
        {
            this.dataClass = CheckBoxSelected_skin_dataClass;
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
