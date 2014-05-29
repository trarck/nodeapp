package com.cntv.player.widgets.views.playSceneButton
{
    import com.puremvc.view.ui.*;

    public class PlaySceneButton extends EmbedSprite
    {
        private var skin:Class;

        public function PlaySceneButton()
        {
            this.skin = PlaySceneButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            return;
        }// end function

    }
}
