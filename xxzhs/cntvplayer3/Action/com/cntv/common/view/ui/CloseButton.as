package com.cntv.common.view.ui
{
    import com.puremvc.view.ui.*;

    public class CloseButton extends EmbedSprite
    {
        private var skin:Class;

        public function CloseButton()
        {
            this.skin = CloseButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
