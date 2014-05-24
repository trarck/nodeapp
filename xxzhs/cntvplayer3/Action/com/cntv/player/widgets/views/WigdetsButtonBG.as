package com.cntv.player.widgets.views
{
    import com.cntv.common.view.ui.*;

    public class WigdetsButtonBG extends CommonSprite
    {
        private var _w:Number;
        private var _h:Number;

        public function WigdetsButtonBG(param1:Number, param2:Number)
        {
            this._w = param1;
            this._h = param2;
            return;
        }// end function

        override protected function init() : void
        {
            this.drawBG();
            return;
        }// end function

        public function drawBG() : void
        {
            graphics.beginFill(13421772, 1);
            graphics.drawRect(0, 0, this._w, this._h);
            graphics.endFill();
            return;
        }// end function

    }
}
