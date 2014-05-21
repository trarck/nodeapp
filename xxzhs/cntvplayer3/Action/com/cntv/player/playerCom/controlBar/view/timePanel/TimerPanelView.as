package com.cntv.player.playerCom.controlBar.view.timePanel
{
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import flash.text.*;

    public class TimerPanelView extends CommonSprite
    {
        private var txt_min:TextField;
        private var txt_sec:TextField;
        private var _sharp:TextField;
        public static const H_GAP:int = 5;

        public function TimerPanelView()
        {
            this.txt_min = TextGenerator.createTxt(10066329, 10, "00:00", false, 0, false, "Arial");
            this.txt_sec = TextGenerator.createTxt(6710886, 10, "00:00", false, 0, false, "Arial");
            this._sharp = TextGenerator.createTxt(6710886, 10, "/");
            this.resetTxt();
            this.addChild(this.txt_min);
            this.addChild(this._sharp);
            this.addChild(this.txt_sec);
            return;
        }// end function

        public function set minute(param1:String) : void
        {
            this.txt_min.text = param1;
            this.resetTxt();
            return;
        }// end function

        public function set second(param1:String) : void
        {
            this.txt_sec.text = param1;
            this.resetTxt();
            return;
        }// end function

        public function resetTxt() : void
        {
            this._sharp.x = this.txt_min.width + H_GAP;
            this.txt_sec.x = this._sharp.x + this._sharp.width + H_GAP;
            return;
        }// end function

        override public function get width() : Number
        {
            return 75;
        }// end function

    }
}
