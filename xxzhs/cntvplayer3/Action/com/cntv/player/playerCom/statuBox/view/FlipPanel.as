package com.cntv.player.playerCom.statuBox.view
{
    import caurina.transitions.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import flash.display.*;
    import flash.text.*;

    public class FlipPanel extends CommonSprite
    {
        private var flipPanel:Sprite;
        private var textPanel:TextField;
        private var isInShow:Boolean = false;
        private var msg:String;

        public function FlipPanel()
        {
            this.flipPanel = new Sprite();
            this.flipPanel.alpha = 0;
            this.addChild(this.flipPanel);
            return;
        }// end function

        override protected function init() : void
        {
            this.adjust();
            return;
        }// end function

        override protected function adjust() : void
        {
            this.y = stage.stageHeight - 100;
            return;
        }// end function

        public function showAMsg(param1:String) : void
        {
            this.msg = param1;
            if (this.isInShow)
            {
                this.isInShow = false;
                this.hidePanel();
            }
            else
            {
                this.isInShow = true;
                this.textPanel = TextGenerator.createTxt(0, 12, this.msg);
                this.textPanel.x = 15;
                this.textPanel.y = (30 - this.textPanel.height) / 2;
                this.flipPanel.graphics.clear();
                this.flipPanel.graphics.beginFill(16777215, 0.6);
                this.flipPanel.graphics.drawRoundRect(0, 0, this.textPanel.width + 30, 30, 8, 8);
                this.flipPanel.graphics.endFill();
                this.flipPanel.addChild(this.textPanel);
                Tweener.removeTweens(this.flipPanel);
                Tweener.addTween(this.flipPanel, {time:0.5, alpha:1});
            }
            return;
        }// end function

        public function hidePanel(param1:Boolean = true) : void
        {
            if (this.textPanel != null && this.flipPanel.contains(this.textPanel))
            {
                this.flipPanel.removeChild(this.textPanel);
                this.textPanel = null;
            }
            Tweener.removeTweens(this.flipPanel);
            if (param1)
            {
                Tweener.addTween(this.flipPanel, {time:0.5, alpha:0, onComplete:this.canShowNow});
            }
            else
            {
                Tweener.addTween(this.flipPanel, {time:0.5, alpha:0});
            }
            return;
        }// end function

        private function canShowNow() : void
        {
            this.showAMsg(this.msg);
            return;
        }// end function

    }
}
