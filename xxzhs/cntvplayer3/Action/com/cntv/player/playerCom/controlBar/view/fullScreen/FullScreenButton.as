package com.cntv.player.playerCom.controlBar.view.fullScreen
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.text.*;
    import com.puremvc.view.ui.*;

    public class FullScreenButton extends EmbedSprite
    {
        private var skin:Class;

        public function FullScreenButton()
        {
            this.skin = FullScreenButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            embed.y = 2;
            MyToolTip.Create(this, ModelLocator.getInstance().i18n.CONTROLBAR_NOTICE_FULLSCREEN);
            return;
        }// end function

    }
}
