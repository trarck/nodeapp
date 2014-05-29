package com.cntv.player.playerCom.controlBar.view.pausebutton
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.text.*;
    import com.puremvc.view.ui.*;

    public class PauseButton extends EmbedSprite
    {
        private var skin:Class;

        public function PauseButton()
        {
            this.skin = PauseButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            MyToolTip.Create(this, ModelLocator.getInstance().i18n.CONTROLBAR_NOTICE_PAUSE);
            return;
        }// end function

    }
}
