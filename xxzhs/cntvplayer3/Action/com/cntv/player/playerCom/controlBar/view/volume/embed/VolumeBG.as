package com.cntv.player.playerCom.controlBar.view.volume.embed
{
    import com.cntv.common.view.ui.*;

    public class VolumeBG extends CommonSprite
    {

        public function VolumeBG()
        {
            return;
        }// end function

        override protected function init() : void
        {
            super.init();
            this.drawBG();
            return;
        }// end function

        public function drawBG() : void
        {
            graphics.clear();
            graphics.beginFill(11184810, 0.6);
            graphics.drawRect(0, 0, 50, 10);
            graphics.endFill();
            return;
        }// end function

        override public function get width() : Number
        {
            return 50;
        }// end function

        override public function set width(param1:Number) : void
        {
            super.width = param1;
            return;
        }// end function

    }
}
