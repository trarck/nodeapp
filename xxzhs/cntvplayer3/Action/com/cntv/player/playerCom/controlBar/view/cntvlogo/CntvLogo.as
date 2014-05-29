package com.cntv.player.playerCom.controlBar.view.cntvlogo
{
    import com.puremvc.view.ui.*;

    public class CntvLogo extends EmbedSprite
    {
        private var skin:Class;

        public function CntvLogo()
        {
            this.skin = CntvLogo_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
