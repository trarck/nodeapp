package com.cntv.player.playerCom.controlBar.view.wideScreen
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.text.*;
    import com.puremvc.view.ui.*;

    public class NarrowButton extends EmbedSprite
    {
        private var skin:Class;

        public function NarrowButton()
        {
            this.skin = NarrowButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            embed.y = 2.5;
            MyToolTip.Create(this, ModelLocator.getInstance().i18n.WIDEGTS_SCREEN_NORMAL);
            return;
        }// end function

    }
}
