package com.cntv.player.playerCom.statuBox.view
{
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.video.events.*;
    import flash.text.*;

    public class FPSViewer extends CommonSprite
    {
        private var txt_fps:TextField;

        public function FPSViewer()
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.txt_fps = TextGenerator.createTxt(16777215, 12, "");
            this.addChild(this.txt_fps);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SHOW_FPS, this.showFps);
            super.init();
            return;
        }// end function

        override protected function release() : void
        {
            super.release();
            return;
        }// end function

        private function showFps(event:VideoPlayEvent) : void
        {
            this.txt_fps.text = "fps:" + event.data;
            return;
        }// end function

    }
}
