package com.cntv.player.playerCom.controlBar.view.progressBar
{
    import com.puremvc.view.ui.*;
    import flash.display.*;

    public class ProgressBG extends EmbedSprite
    {
        private var skin:Class;
        private var roundMask:Sprite;
        private var bk:Sprite;

        public function ProgressBG()
        {
            this.bk = new Sprite();
            this.bk.graphics.beginFill(1118481);
            this.bk.graphics.drawRect(0, 0, 1, 3);
            this.bk.graphics.endFill();
            this.addChild(this.bk);
            return;
        }// end function

        public function controlbarOver() : void
        {
            this.bk.graphics.clear();
            this.bk.graphics.beginFill(1118481);
            this.bk.graphics.drawRect(0, 0, 1, 5);
            this.bk.graphics.endFill();
            return;
        }// end function

        public function controlbarOut() : void
        {
            this.bk.graphics.clear();
            this.bk.graphics.beginFill(1118481);
            this.bk.graphics.drawRect(0, 0, 1, 3);
            this.bk.graphics.endFill();
            return;
        }// end function

        override public function get width() : Number
        {
            return this.bk.width;
        }// end function

        override public function set width(param1:Number) : void
        {
            this.bk.width = param1;
            return;
        }// end function

        override public function get height() : Number
        {
            return this.bk.height;
        }// end function

        override public function set height(param1:Number) : void
        {
            this.bk.height = param1;
            return;
        }// end function

    }
}
