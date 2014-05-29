package com.cntv.player.widgets.views.replayButton
{
    import com.cntv.common.model.*;
    import com.puremvc.view.ui.*;
    import flash.text.*;

    public class ReplayButton extends EmbedSprite
    {
        private var skin:Class;
        private var text:TextField;

        public function ReplayButton()
        {
            this.skin = ReplayButton_skin;
            embed = new this.skin();
            this.addChild(embed);
            this.text = new TextField();
            this.text.defaultTextFormat = new TextFormat("", 12, 13487565);
            this.text.text = ModelLocator.getInstance().i18n.FLOATLAYER_REPLAY;
            this.text.y = 30;
            this.text.x = (-(this.text.textWidth - embed.width)) / 2;
            this.text.height = 20;
            this.text.width = this.text.textWidth + 5;
            this.mouseEnabled = false;
            this.buttonMode = true;
            this.addChild(this.text);
            return;
        }// end function

    }
}
