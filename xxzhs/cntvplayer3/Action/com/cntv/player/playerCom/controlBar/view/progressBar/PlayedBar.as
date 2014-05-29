package com.cntv.player.playerCom.controlBar.view.progressBar
{
    import com.puremvc.view.ui.*;
    import flash.display.*;

    public class PlayedBar extends EmbedSprite
    {
        private var skin:Class;
        private var played:Sprite;

        public function PlayedBar()
        {
            this.played = new Sprite();
            this.played.graphics.beginFill(14483456);
            this.played.graphics.drawRect(0, 0, 1, 3);
            this.played.graphics.endFill();
            this.addChild(this.played);
            return;
        }// end function

        public function controlbarOver() : void
        {
            this.played.graphics.clear();
            this.played.graphics.beginFill(14483456);
            this.played.graphics.drawRect(0, 0, 1, 5);
            this.played.graphics.endFill();
            return;
        }// end function

        public function controlbarOut() : void
        {
            this.played.graphics.clear();
            this.played.graphics.beginFill(14483456);
            this.played.graphics.drawRect(0, 0, 1, 3);
            this.played.graphics.endFill();
            return;
        }// end function

        override public function set width(param1:Number) : void
        {
            this.played.width = param1;
            return;
        }// end function

        override public function get width() : Number
        {
            return this.played.width;
        }// end function

    }
}
