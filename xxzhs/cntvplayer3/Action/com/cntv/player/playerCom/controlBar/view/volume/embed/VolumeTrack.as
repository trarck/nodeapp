package com.cntv.player.playerCom.controlBar.view.volume.embed
{
    import com.puremvc.view.ui.*;
    import flash.display.*;

    public class VolumeTrack extends EmbedSprite
    {
        private var skin:Class;
        private var track:Sprite;

        public function VolumeTrack()
        {
            this.drawBG();
            return;
        }// end function

        override protected function init() : void
        {
            super.init();
            return;
        }// end function

        public function drawBG() : void
        {
            this.track = new Sprite();
            this.track.graphics.beginFill(14483456);
            this.track.graphics.drawRect(0, 0, 50, 10);
            this.track.graphics.endFill();
            this.addChild(this.track);
            return;
        }// end function

        public function redrawBG(param1:Number) : void
        {
            var _loc_2:* = param1 * 50;
            this.track.graphics.clear();
            this.track.graphics.beginFill(14483456);
            this.track.graphics.drawRect(0, 0, _loc_2, 10);
            this.track.graphics.endFill();
            return;
        }// end function

        override public function get width() : Number
        {
            return 50;
        }// end function

        override public function set width(param1:Number) : void
        {
            this.track.width = param1;
            return;
        }// end function

        override public function get height() : Number
        {
            return 10;
        }// end function

        override public function set height(param1:Number) : void
        {
            this.track.height = param1;
            return;
        }// end function

    }
}
