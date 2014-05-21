package com.cntv.player.playerCom.controlBar.view.progressBar
{
    import com.cntv.common.model.*;
    import com.cntv.common.tools.text.*;
    import com.puremvc.view.ui.*;
    import flash.display.*;

    public class Backward extends EmbedSprite
    {
        private var skin:Class;
        private var backward:Sprite;

        public function Backward()
        {
            this.skin = Backward_skin;
            embed = new this.skin();
            this.backward = new Sprite();
            this.backward.addChild(embed);
            this.addChild(this.backward);
            MyToolTip.Create(this, ModelLocator.getInstance().i18n.CONTROLBAR_NOTICE_BACKWARD);
            return;
        }// end function

    }
}
