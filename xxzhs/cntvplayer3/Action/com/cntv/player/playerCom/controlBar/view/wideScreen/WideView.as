package com.cntv.player.playerCom.controlBar.view.wideScreen
{
    import com.cntv.common.events.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.common.view.ui.slider.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.cntv.player.playerCom.video.events.*;
    import flash.events.*;
    import flash.text.*;

    public class WideView extends CommonSprite
    {
        private var brightNessSlider:SliderView;
        private var contrastSlider:SliderView;
        private var bg:CommonMask;
        private var closeButton:CloseButton;
        private var resetButton:CommonButton;
        private var label_brightNess:TextField;
        private var label_contrast:TextField;
        public static const DEFAULT_BRIGHT:Number = 0.5;
        public static const DEFAULT_CONTRAST:Number = 0.1;

        public function WideView()
        {
            this.bg = new CommonMask(320, 120, 2236962);
            this.bg.alpha = 0.6;
            this.brightNessSlider = new SliderView(220, 15, _modelLocator.brightness);
            this.brightNessSlider.addEventListener(SliderEvent.EVENT_SLIDER_MOVE, this.brightNessSliderHandler);
            this.contrastSlider = new SliderView(220, 15, _modelLocator.contrast);
            this.contrastSlider.addEventListener(SliderEvent.EVENT_SLIDER_MOVE, this.contrastSliderHandler);
            this.label_brightNess = TextGenerator.createTxt(16777215, 12, _modelLocator.i18n.CONTROLBAR_NOTICE_PICTURE_ADJUST_BRIGHT);
            this.label_contrast = TextGenerator.createTxt(16777215, 12, _modelLocator.i18n.CONTROLBAR_NOTICE_PICTURE_ADJUST_CONTRAST);
            this.brightNessSlider.x = (this.bg.width - this.brightNessSlider.width) / 2 + 30;
            this.brightNessSlider.y = 30;
            this.contrastSlider.x = this.brightNessSlider.x;
            this.contrastSlider.y = 60;
            this.label_brightNess.x = 18;
            this.label_brightNess.y = 25;
            this.label_contrast.x = 18;
            this.label_contrast.y = 55;
            this.closeButton = new CloseButton();
            this.closeButton.x = 300;
            this.closeButton.y = 5;
            this.closeButton.addEventListener(MouseEvent.CLICK, this.closeHandler);
            this.resetButton = new CommonButton(_modelLocator.i18n.CONTROLBAR_NOTICE_RESET);
            this.resetButton.x = 320 - this.resetButton.width - 5;
            this.resetButton.y = 90;
            this.resetButton.addEventListener(MouseEvent.CLICK, this.resetHandler);
            return;
        }// end function

        private function brightNessSliderHandler(event:SliderEvent) : void
        {
            _modelLocator.brightness = event.data;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_BRIGHTNESS, _modelLocator.brightness * 510 - 255));
            return;
        }// end function

        private function contrastSliderHandler(event:SliderEvent) : void
        {
            _modelLocator.contrast = event.data;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CONTRAST, _modelLocator.contrast));
            return;
        }// end function

        private function closeHandler(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ControlBarModule.EVENT_CLOSE_WINDOW));
            return;
        }// end function

        private function resetHandler(event:MouseEvent) : void
        {
            _modelLocator.brightness = DEFAULT_BRIGHT;
            _modelLocator.contrast = DEFAULT_CONTRAST;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_BRIGHTNESS, _modelLocator.brightness * 510 - 255));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CONTRAST, _modelLocator.contrast));
            this.brightNessSlider.setSlider(0.5);
            this.contrastSlider.setSlider(0.1);
            return;
        }// end function

    }
}
