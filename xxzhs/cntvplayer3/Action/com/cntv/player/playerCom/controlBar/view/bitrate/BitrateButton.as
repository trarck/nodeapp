package com.cntv.player.playerCom.controlBar.view.bitrate
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.text.*;
    import com.puremvc.view.ui.*;

    public class BitrateButton extends EmbedSprite
    {
        private var skin:Class;

        public function BitrateButton()
        {
            this.skin = BitrateButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            embed.y = 2.5;
            MyToolTip.Create(this, ModelLocator.getInstance().i18n.CONTROLBAR_NOTICE_CONFIG);
            return;
        }// end function

        override protected function init() : void
        {
            return;
        }// end function

    }
}
