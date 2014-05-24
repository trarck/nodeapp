package com.cntv.common.view.ui.checkbox.select
{
    import com.cntv.common.view.ui.*;

    public class CheckBoxSelected extends CommonSprite
    {
        private var skin:Class;
        private var bg:Object;

        public function CheckBoxSelected()
        {
            this.skin = CheckBoxSelected_skin;
            this.bg = new this.skin();
            this.addChild(this.bg);
            this.buttonMode = true;
            return;
        }// end function

        override protected function release() : void
        {
            this.removeChild(this.bg);
            this.bg = null;
            return;
        }// end function

        override public function get height() : Number
        {
            return this.bg.height;
        }// end function

        override public function set height(param1:Number) : void
        {
            this.bg.height = param1;
            return;
        }// end function

        override public function get width() : Number
        {
            return this.bg.width;
        }// end function

        override public function set width(param1:Number) : void
        {
            this.bg.width = param1;
            return;
        }// end function

    }
}
