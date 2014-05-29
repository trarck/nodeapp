package com.cntv.player.playerCom.relativeList.view
{
    import com.puremvc.view.ui.*;

    public class ButtonNext extends EmbedSprite
    {
        private var skin:Class;

        public function ButtonNext()
        {
            this.skin = ButtonNext_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
