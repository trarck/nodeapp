package com.cntv.player.playerCom.relativeList.view
{
    import com.puremvc.view.ui.*;

    public class ButtonPrev extends EmbedSprite
    {
        private var skin:Class;

        public function ButtonPrev()
        {
            this.skin = ButtonPrev_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
