package com.cntv.common.view.ui.loadingView
{
    import com.puremvc.view.ui.*;

    public class BufferBigIcon extends EmbedSprite
    {
        private var skin:Class;

        public function BufferBigIcon()
        {
            this.skin = BufferBigIcon_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
