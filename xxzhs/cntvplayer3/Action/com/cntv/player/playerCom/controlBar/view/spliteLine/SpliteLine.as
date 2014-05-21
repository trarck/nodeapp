package com.cntv.player.playerCom.controlBar.view.spliteLine
{
    import com.puremvc.view.ui.*;

    public class SpliteLine extends EmbedSprite
    {
        private var skin:Class;

        public function SpliteLine()
        {
            this.skin = SpliteLine_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
