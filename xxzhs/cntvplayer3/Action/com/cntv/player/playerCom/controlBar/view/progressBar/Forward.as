package com.cntv.player.playerCom.controlBar.view.progressBar
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.text.*;
    import com.puremvc.view.ui.*;
    import flash.display.*;

    public class Forward extends EmbedSprite
    {
        private var skin:Class;
        private var forward:Sprite;

        public function Forward()
        {
            this.skin = Forward_skin;
            embed = new this.skin();
            this.forward = new Sprite();
            this.forward.addChild(embed);
            this.addChild(this.forward);
            MyToolTip.Create(this, ModelLocator.getInstance().i18n.CONTROLBAR_NOTICE_FORWARD);
            return;
        }// end function

    }
}
