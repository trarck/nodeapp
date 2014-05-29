package com.cntv.player.playerCom.controlBar.view.progressBar
{
    import com.puremvc.view.ui.*;
    import flash.display.*;

    public class PlayTip extends EmbedSprite
    {
        private var skin:Class;
        private var slider:Sprite;

        public function PlayTip()
        {
            this.skin = PlayTip_skin;
            embed = new this.skin();
            this.slider = new Sprite();
            this.slider.addChild(embed);
            embed.x = -6;
            embed.y = 2;
            this.addChild(this.slider);
            return;
        }// end function

    }
}
