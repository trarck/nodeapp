package com.cntv.player.playerCom.relativeList.view
{
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import flash.text.*;

    public class LinkButton extends CommonSprite
    {
        private var txtPanel:TextField;
        private var bg:CommonMask;
        public static const W:Number = 100;
        public static const H:Number = 20;

        public function LinkButton(param1:String, param2:String)
        {
            this.bg = new CommonMask(W, H, 16777215, 0.3);
            this.addChild(this.bg);
            this.txtPanel = TextGenerator.createTxt(16777215, 14, "");
            this.txtPanel.htmlText = "<a href=\'" + param2 + "\' target=\'_blank\'>" + param1 + "</a>";
            this.txtPanel.x = (W - this.txtPanel.width) / 2;
            this.txtPanel.y = (H - this.txtPanel.height) / 2;
            this.addChild(this.txtPanel);
            return;
        }// end function

        override protected function release() : void
        {
            this.removeChild(this.bg);
            this.bg = null;
            this.removeChild(this.txtPanel);
            this.txtPanel = null;
            super.release();
            return;
        }// end function

    }
}
