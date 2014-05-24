package com.cntv.common.view.ui.radioButton
{
    import com.puremvc.view.ui.*;

    public class RadioUnselectedButton extends EmbedSprite
    {
        private var skin:Class;

        public function RadioUnselectedButton()
        {
            this.skin = RadioUnselectedButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
