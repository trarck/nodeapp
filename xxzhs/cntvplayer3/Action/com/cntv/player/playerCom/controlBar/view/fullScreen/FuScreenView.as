package com.cntv.player.playerCom.controlBar.view.fullScreen
{
    import com.cntv.common.events.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.video.events.*;
    import flash.events.*;

    public class FuScreenView extends CommonSprite
    {
        private var fullButton:FullScreenButton;
        private var normalButton:NormalScreenButton;
        private var _isFullScreen:Boolean;

        public function FuScreenView()
        {
            this.fullButton = new FullScreenButton();
            this.fullButton.addEventListener(MouseEvent.CLICK, this.fullScreenHandler);
            this.addChild(this.fullButton);
            this.normalButton = new NormalScreenButton();
            this.normalButton.addEventListener(MouseEvent.CLICK, this.normalScreenHandler);
            this.addChild(this.normalButton);
            this.isFullScreen = false;
            return;
        }// end function

        override protected function init() : void
        {
            super.init();
            stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.resetButtonStatu);
            return;
        }// end function

        public function set isFullScreen(param1:Boolean) : void
        {
            this._isFullScreen = param1;
            this.fullButton.visible = !this._isFullScreen;
            this.normalButton.visible = this._isFullScreen;
            return;
        }// end function

        public function get isFullScreen() : Boolean
        {
            return this._isFullScreen;
        }// end function

        private function fullScreenHandler(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.FULLSCREEN_CLICK));
            if (_modelLocator.ISWEBSITE)
            {
                this.isFullScreen = true;
                stage.displayState = "fullScreen";
            }
            else if (_modelLocator.paramVO.url != "")
            {
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_OUTSIDE_FULLSCREEN_CLICK));
            }
            else
            {
                this.isFullScreen = true;
                stage.displayState = "fullScreen";
            }
            this.y = 5;
            return;
        }// end function

        private function normalScreenHandler(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.NORMALSCREEN_CLICK));
            this.isFullScreen = false;
            stage.displayState = "normal";
            return;
        }// end function

        private function resetButtonStatu(event:FullScreenEvent) : void
        {
            this.isFullScreen = event.fullScreen;
            return;
        }// end function

        override public function get width() : Number
        {
            return this.fullButton.width;
        }// end function

        override public function get height() : Number
        {
            return this.fullButton.height;
        }// end function

    }
}
