package com.cntv.player.playerCom.statuBox.view
{
    import caurina.transitions.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import flash.display.*;
    import flash.text.*;

    public class FLipCenterPanel extends CommonSprite
    {
        private var flipPanel:CommonMask;
        private var textPanel:TextField;
        private var isInShow:Boolean = false;
        private var msg:String;
        private var rotationSprite:Sprite;

        public function FLipCenterPanel()
        {
            this.rotationSprite = new Sprite();
            this.flipPanel = new CommonMask(200, 40, 6710886, 1);
            this.flipPanel.y = -20;
            this.rotationSprite.addChild(this.flipPanel);
            this.rotationSprite.alpha = 0;
            this.addChild(this.rotationSprite);
            return;
        }// end function

        override protected function init() : void
        {
            this.adjust();
            return;
        }// end function

        override protected function adjust() : void
        {
            this.x = (stage.stageWidth - this.flipPanel.width) / 2;
            this.y = (stage.stageHeight - this.flipPanel.height) / 2;
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
                this.textPanel = TextGenerator.createFontTxt(16777215, 15, this.msg, "", true);
                this.textPanel.x = 30;
                this.textPanel.y = (40 - this.textPanel.height) / 2;
                this.flipPanel.width = this.textPanel.width + 60;
                this.flipPanel.addChild(this.textPanel);
                this.adjust();
                Tweener.removeTweens(this.rotationSprite);
                Tweener.addTween(this.rotationSprite, {time:0.5, alpha:1});
            }
            return;
        }// end function

        public function hidePanel(param1:Boolean = true) : void
        {
            if (this.textPanel != null && this.flipPanel.contains(this.textPanel))
            {
                this.flipPanel.removeChild(this.textPanel);
            }
            this.textPanel = null;
            Tweener.removeTweens(this.rotationSprite);
            if (param1)
            {
                Tweener.addTween(this.rotationSprite, {time:0.5, alpha:0, onComplete:this.canShowNow});
            }
            else
            {
                Tweener.addTween(this.rotationSprite, {time:0.5, alpha:0, onComplete:this.afterHide});
            }
            return;
        }// end function

        private function afterHide() : void
        {
            this.visible = false;
            return;
        }// end function

        private function canShowNow() : void
        {
            this.showAMsg(this.msg);
            return;
        }// end function

    }
}
