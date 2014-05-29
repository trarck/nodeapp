package com.cntv.player.playerCom.statuBox.view
{
    import com.puremvc.view.ui.*;

    public class FloatLogo extends EmbedSprite
    {
        private var skin:Class;

        public function FloatLogo()
        {
            this.skin = FloatLogo_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
