package com.cntv.player.playerCom.controlBar.view.wideScreen
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.text.*;
    import com.puremvc.view.ui.*;

    public class WideButton extends EmbedSprite
    {
        private var skin:Class;

        public function WideButton()
        {
            this.skin = WideButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            embed.y = 2.5;
            MyToolTip.Create(this, ModelLocator.getInstance().i18n.WIDEGTS_SCREEN_WIDE);
            return;
        }// end function

    }
}
