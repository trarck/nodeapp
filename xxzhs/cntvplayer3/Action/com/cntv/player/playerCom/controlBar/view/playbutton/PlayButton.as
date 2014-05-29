package com.cntv.player.playerCom.controlBar.view.playbutton
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.text.*;
    import com.puremvc.view.ui.*;

    public class PlayButton extends EmbedSprite
    {
        private var skin:Class;

        public function PlayButton()
        {
            this.skin = PlayButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            MyToolTip.Create(this, ModelLocator.getInstance().i18n.CONTROLBAR_NOTICE_PLAY);
            return;
        }// end function

    }
}
