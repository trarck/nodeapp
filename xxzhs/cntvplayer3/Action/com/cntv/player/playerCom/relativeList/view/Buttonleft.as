package com.cntv.player.playerCom.relativeList.view
{
    import com.puremvc.view.ui.*;
    import flash.events.*;

    public class Buttonleft extends EmbedSprite
    {
        private var skin:Class;

        public function Buttonleft()
        {
            this.skin = Buttonleft_skin;
            embed = new this.skin();
            this.addChild(embed);
            this.alpha = 0.7;
            this.addEventListener(MouseEvent.MOUSE_OVER, this.onOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.onOut);
            return;
        }// end function

        private function onOver(event:MouseEvent) : void
        {
            this.alpha = 1;
            return;
        }// end function

        private function onOut(event:MouseEvent) : void
        {
            this.alpha = 0.7;
            return;
        }// end function

    }
}
