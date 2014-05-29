package com.cntv.player.playerCom.statuBox.view.p2pNoticeIcon
{
    import com.puremvc.view.ui.*;

    public class P2PNoticeIcon extends EmbedSprite
    {
        private var skin:Class;

        public function P2PNoticeIcon()
        {
            this.skin = P2PNoticeIcon_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
