package com.cntv.player.playerCom.controlBar.view.progressBar
{
    import com.puremvc.view.ui.*;
    import flash.display.*;

    public class LoadedBar extends EmbedSprite
    {
        private var skin:Class;
        private var loaded:Sprite;

        public function LoadedBar()
        {
            this.skin = LoadedBar_skin;
            this.loaded = new Sprite();
            this.loaded.graphics.beginFill(11184810, 0.6);
            this.loaded.graphics.drawRect(0, 0, 1, 3);
            this.loaded.graphics.endFill();
            this.addChild(this.loaded);
            return;
        }// end function

        public function controlbarOver() : void
        {
            this.loaded.graphics.clear();
            this.loaded.graphics.beginFill(11184810, 0.6);
            this.loaded.graphics.drawRect(0, 0, 1, 5);
            this.loaded.graphics.endFill();
            return;
        }// end function

        public function controlbarOut() : void
        {
            this.loaded.graphics.clear();
            this.loaded.graphics.beginFill(11184810, 0.6);
            this.loaded.graphics.drawRect(0, 0, 1, 3);
            this.loaded.graphics.endFill();
            return;
        }// end function

        override public function set width(param1:Number) : void
        {
            this.loaded.width = param1;
            return;
        }// end function

        override public function get width() : Number
        {
            return this.loaded.width;
        }// end function

    }
}
