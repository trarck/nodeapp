package com.cntv.common.view.ui.checkbox.unselect
{
    import com.cntv.common.view.ui.*;

    public class CheckBoxUnselect extends CommonSprite
    {
        private var skin:Class;
        private var bg:Object;

        public function CheckBoxUnselect()
        {
            this.skin = CheckBoxUnselect_skin;
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

    }
}
