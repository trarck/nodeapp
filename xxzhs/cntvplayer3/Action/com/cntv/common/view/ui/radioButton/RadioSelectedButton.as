package com.cntv.common.view.ui.radioButton
{
    import com.puremvc.view.ui.*;

    public class RadioSelectedButton extends EmbedSprite
    {
        private var skin:Class;

        public function RadioSelectedButton()
        {
            this.skin = RadioSelectedButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
