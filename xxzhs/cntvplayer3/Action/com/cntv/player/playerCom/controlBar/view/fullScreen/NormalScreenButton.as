package com.cntv.player.playerCom.controlBar.view.fullScreen
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.text.*;
    import com.puremvc.view.ui.*;

    public class NormalScreenButton extends EmbedSprite
    {
        private var skin:Class;

        public function NormalScreenButton()
        {
            this.skin = NormalScreenButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            embed.y = 2;
            MyToolTip.Create(this, ModelLocator.getInstance().i18n.CONTROLBAR_NOTICE_NORMALSCREEN);
            return;
        }// end function

    }
}
