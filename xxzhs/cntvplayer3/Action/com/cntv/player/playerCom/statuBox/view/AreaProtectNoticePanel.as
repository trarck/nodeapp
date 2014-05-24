package com.cntv.player.playerCom.statuBox.view
{
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import flash.text.*;

    public class AreaProtectNoticePanel extends CommonSprite
    {
        private var bg:CommonGradientMask;
        private var stringZh:String = "抱歉，您所在的地区不能观看此视频";
        private var stringEn:String = "We\'re sorry,this video can not be streamed in your region";
        private var textZh:TextField;
        private var textEn:TextField;

        public function AreaProtectNoticePanel()
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.bg = new CommonGradientMask("l", stage.stageWidth, stage.stageHeight, 1, 1, 0, 5987163, -80);
            this.addChild(this.bg);
            this.textZh = TextGenerator.createFontTxt(16777215, 18, this.stringZh, "", true);
            this.textEn = TextGenerator.createFontTxt(16777215, 18, this.stringEn, "", true);
            this.textZh.x = (stage.stageWidth - this.textZh.width) / 2;
            this.textZh.y = stage.stageHeight / 2 - this.textZh.height - 5;
            this.textEn.x = (stage.stageWidth - this.textEn.width) / 2;
            this.textEn.y = stage.stageHeight / 2 + 5;
            this.addChild(this.textZh);
            this.addChild(this.textEn);
            return;
        }// end function

    }
}
