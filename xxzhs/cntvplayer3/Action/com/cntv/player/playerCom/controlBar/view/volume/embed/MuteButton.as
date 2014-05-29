package com.cntv.player.playerCom.controlBar.view.volume.embed
{
    import com.puremvc.view.ui.*;

    public class MuteButton extends EmbedSprite
    {
        private var skin:Class;

        public function MuteButton()
        {
            this.skin = MuteButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            embed.y = 1;
            return;
        }// end function

    }
}
