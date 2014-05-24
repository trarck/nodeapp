package com.cntv.player.playerCom.controlBar.view.adlogo
{
    import com.puremvc.view.ui.*;

    public class DefaultLogo extends EmbedSprite
    {
        private var skin:Class;

        public function DefaultLogo()
        {
            this.skin = DefaultLogo_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
