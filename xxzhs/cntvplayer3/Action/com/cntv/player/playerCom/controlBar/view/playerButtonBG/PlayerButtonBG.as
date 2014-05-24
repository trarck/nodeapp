package com.cntv.player.playerCom.controlBar.view.playerButtonBG
{
    import com.puremvc.view.ui.*;

    public class PlayerButtonBG extends EmbedSprite
    {
        private var skin:Class;

        public function PlayerButtonBG()
        {
            this.skin = PlayerButtonBG_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
