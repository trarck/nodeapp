package com.cntv.common.view.ui.slider
{
    import com.cntv.common.events.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.controlBar.view.progressBar.*;
    import flash.events.*;

    public class SliderView extends CommonSprite
    {
        private var sliderBG:ProgressBG;
        private var sliderButton:PlayTip;
        public var rate:Number = 0;
        private var _w:Number;

        public function SliderView(param1:Number, param2:Number, param3:Number)
        {
            this.sliderBG = new ProgressBG();
            this.sliderBG.width = param1;
            this._w = param1;
            this.sliderButton = new PlayTip();
            this.sliderButton.y = (this.sliderBG.height - this.sliderButton.height) / 2;
            this.rate = param3;
            this.addChild(this.sliderBG);
            this.addChild(this.sliderButton);
            this.sliderButton.x = this.rate * this._w;
            this.sliderButton.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            return;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.moveSlider);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveSlider);
            return;
        }// end function

        private function moveSlider(event:MouseEvent) : void
        {
            if (mouseX < this.sliderBG.width && mouseX > 0)
            {
                this.sliderButton.x = mouseX;
                this.rate = this.sliderButton.x / this.sliderBG.width;
                dispatchEvent(new SliderEvent(SliderEvent.EVENT_SLIDER_MOVE, this.rate));
            }
            return;
        }// end function

        public function setSlider(param1:Number) : void
        {
            this.rate = param1;
            this.sliderButton.x = this.rate * this.sliderBG.width;
            return;
        }// end function

        override public function get width() : Number
        {
            return this._w;
        }// end function

        override public function set width(param1:Number) : void
        {
            super.width = param1;
            return;
        }// end function

    }
}
