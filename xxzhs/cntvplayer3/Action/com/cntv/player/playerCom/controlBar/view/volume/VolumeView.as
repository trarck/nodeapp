package com.cntv.player.playerCom.controlBar.view.volume
{
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.controlBar.view.volume.embed.*;
    import flash.display.*;
    import flash.events.*;

    public class VolumeView extends CommonSprite
    {
        private var bg:VolumeBG;
        private var buttonView:ButtonView;
        private var controlView:ControlView;
        private var controlViewMask:Sprite;
        private var _tip:VolumeTip;

        public function VolumeView()
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.controlView = new ControlView();
            this.buttonView = new ButtonView();
            this.bg = new VolumeBG();
            this.bg.x = 30;
            this.bg.y = 3;
            this.bg.alpha = 1;
            this.controlView.y = 0;
            this.controlView.x = 0;
            this.addChild(this.controlView);
            return;
        }// end function

        override public function get width() : Number
        {
            return 24;
        }// end function

        override public function set width(param1:Number) : void
        {
            super.width = param1;
            return;
        }// end function

        override public function get height() : Number
        {
            return 16;
        }// end function

        override public function set height(param1:Number) : void
        {
            super.height = param1;
            return;
        }// end function

        private function onMouseOver(event:MouseEvent) : void
        {
            this.bg.visible = true;
            this.controlView.show();
            return;
        }// end function

        private function onMouseOut(event:MouseEvent) : void
        {
            this.bg.visible = false;
            this.controlView.hide();
            return;
        }// end function

    }
}
