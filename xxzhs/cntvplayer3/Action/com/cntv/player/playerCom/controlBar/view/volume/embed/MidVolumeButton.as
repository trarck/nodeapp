package com.cntv.player.playerCom.controlBar.view.volume.embed
{
    import com.puremvc.view.ui.*;

    public class MidVolumeButton extends EmbedSprite
    {
        private var skin:Class;

        public function MidVolumeButton()
        {
            this.skin = MidVolumeButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            embed.y = 1;
            return;
        }// end function

    }
}
