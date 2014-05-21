package com.cntv.player.playerCom.controlBar.view.progressBar
{
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import flash.text.*;

    public class TimeTip extends CommonSprite
    {
        private var bg:CommonMask;
        private var time_txt:TextField;

        public function TimeTip()
        {
            this.bg = new CommonMask(50, 20, 16777215, 0.7);
            this.addChild(this.bg);
            this.time_txt = TextGenerator.createTxt(0, 14, "");
            this.time_txt.x = 3;
            this.addChild(this.time_txt);
            return;
        }// end function

        public function setTimeText(param1:String) : void
        {
            this.time_txt.text = param1;
            this.time_txt.x = (50 - this.time_txt.width) / 2;
            return;
        }// end function

    }
}
