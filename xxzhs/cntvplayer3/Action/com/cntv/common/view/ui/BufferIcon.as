package com.cntv.common.view.ui
{
    import com.puremvc.view.ui.*;

    public class BufferIcon extends EmbedSprite
    {
        private var skin:Class;

        public function BufferIcon()
        {
            this.skin = BufferIcon_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
