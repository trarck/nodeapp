package com.cntv.player.playerCom.controlBar.view.volume.embed
{
    import com.puremvc.view.ui.*;
    import flash.display.*;

    public class VolumeTip extends EmbedSprite
    {
        private var skin:Class;
        private var slider:Sprite;

        public function VolumeTip()
        {
            this.skin = VolumeTip_skin;
            embed = new this.skin();
            this.slider = new Sprite();
            this.slider.addChild(embed);
            embed.x = -6;
            embed.y = 1;
            this.addChild(this.slider);
            return;
        }// end function

    }
}
