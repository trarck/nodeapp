package com.cntv.player.playerCom.controlBar.view.controlBarBG
{
    import com.puremvc.view.ui.*;
    import flash.events.*;

    public class ControlBarBG extends EmbedSprite
    {
        private var skin:Class;
        public static const CONTROL_BAR_HEIGHT:int = 30;

        public function ControlBarBG()
        {
            this.skin = ControlBarBG_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

        override protected function init() : void
        {
            stage.addEventListener(Event.RESIZE, this.adjust);
            this.adjust(null);
            return;
        }// end function

        private function adjust(event:Event) : void
        {
            width = stage.stageWidth;
            return;
        }// end function

    }
}
