package com.cntv.common.view.ui.progress
{
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class CHProgress extends Sprite
    {
        private var sliderSkin:Class;
        private var _w:Number;
        private var _h:Number;
        private var _rate:Number;
        private var bg:Sprite;
        private var bg_left:Sprite;
        private var bg_right:Sprite;
        private var slider:Sprite;
        private var playedBg:Sprite;
        private var clickLayer:Sprite;
        private var increaseText:TextField;
        private var increase:Sprite;
        private var decreaseText:TextField;
        private var decrease:Sprite;
        private var type:String;

        public function CHProgress(param1:Number, param2:Number, param3:Number, param4:String)
        {
            var _loc_5:DisplayObject = null;
            this.sliderSkin = CHProgress_sliderSkin;
            this._w = param1;
            this._h = param2;
            this._rate = param3;
            this.type = param4;
            this.increase = new Sprite();
            this.increase.graphics.beginFill(65280, 0);
            this.increase.graphics.drawRect(0, 0, 16, 16);
            this.increase.graphics.endFill();
            this.addChild(this.increase);
            this.increase.x = this._w + 8;
            this.increase.y = -6;
            this.increaseText = new TextField();
            this.increaseText.defaultTextFormat = new TextFormat("", 14, 13487565, true);
            this.increaseText.text = "+";
            this.increaseText.height = 20;
            this.increaseText.width = 20;
            this.increaseText.x = 2;
            this.increaseText.y = -2;
            this.increase.addChild(this.increaseText);
            this.increase.buttonMode = true;
            this.increase.mouseChildren = false;
            this.decrease = new Sprite();
            this.decrease.graphics.beginFill(65280, 0);
            this.decrease.graphics.drawRect(-5, 5, 16, 16);
            this.decrease.graphics.endFill();
            this.addChild(this.decrease);
            this.decrease.x = -20;
            this.decrease.y = -6;
            this.decreaseText = new TextField();
            this.decreaseText.defaultTextFormat = new TextFormat("", 16, 13487565, true);
            this.decreaseText.text = "-";
            this.decreaseText.height = 20;
            this.decreaseText.width = 20;
            this.decreaseText.x = 2;
            this.decreaseText.y = -5;
            this.decrease.addChild(this.decreaseText);
            this.decrease.buttonMode = true;
            this.decrease.mouseChildren = false;
            this.bg = new Sprite();
            this.bg.graphics.beginFill(2500134, 1);
            this.bg.graphics.drawRect(0, 0, this._w, this._h);
            this.bg.graphics.endFill();
            this.addChild(this.bg);
            this.bg_left = new Sprite();
            this.bg_left.graphics.beginFill(16711680, 1);
            this.bg_left.graphics.drawCircle(0, this._h / 2, this._h / 2);
            this.bg_left.graphics.endFill();
            this.addChild(this.bg_left);
            this.bg_right = new Sprite();
            this.bg_right.graphics.beginFill(2500134, 1);
            this.bg_right.graphics.drawCircle(this._w, this._h / 2, this._h / 2);
            this.bg_right.graphics.endFill();
            this.addChild(this.bg_right);
            this.playedBg = new Sprite();
            this.playedBg.graphics.beginFill(16711680, 1);
            this.playedBg.graphics.drawRect(0, 0, this._w * this._rate, this._h);
            this.playedBg.graphics.endFill();
            this.addChild(this.playedBg);
            this.clickLayer = new Sprite();
            this.clickLayer.graphics.beginFill(65280, 0);
            this.clickLayer.graphics.drawRect(0, 0, this._w, this._h);
            this.clickLayer.graphics.endFill();
            this.addChild(this.clickLayer);
            this.clickLayer.buttonMode = true;
            _loc_5 = new this.sliderSkin();
            this.slider = new Sprite();
            this.slider.addChild(_loc_5);
            this.slider.x = this._w * this._rate;
            this.slider.y = -4;
            this.addChild(this.slider);
            this.increase.addEventListener(MouseEvent.CLICK, this.onincreaseClick);
            this.decrease.addEventListener(MouseEvent.CLICK, this.ondecreaseClick);
            this.clickLayer.addEventListener(MouseEvent.CLICK, this.onclick);
            this.slider.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            return;
        }// end function

        private function onincreaseClick(event:MouseEvent) : void
        {
            if (this._rate <= 0.9)
            {
                this._rate = this._rate + 0.1;
            }
            else
            {
                this._rate = 1;
            }
            this.redrawPlayed(this._rate);
            event.updateAfterEvent();
            this.slider.x = this._w * this._rate;
            this.dispatchEvent(new CommonEvent(this.type, this._rate));
            return;
        }// end function

        public function resetRate(param1:Number) : void
        {
            this._rate = param1;
            this.redrawPlayed(this._rate);
            this.slider.x = this._w * this._rate;
            this.dispatchEvent(new CommonEvent(this.type, this._rate));
            return;
        }// end function

        private function ondecreaseClick(event:MouseEvent) : void
        {
            if (this._rate >= 0.1)
            {
                this._rate = this._rate - 0.1;
            }
            else
            {
                this._rate = 0;
            }
            this.redrawPlayed(this._rate);
            event.updateAfterEvent();
            this.slider.x = this._w * this._rate;
            this.dispatchEvent(new CommonEvent(this.type, this._rate));
            return;
        }// end function

        private function onclick(event:MouseEvent) : void
        {
            if (mouseX < this._w && mouseX > 0)
            {
                this.slider.x = mouseX;
                this._rate = this.slider.x / this._w;
                this.redrawPlayed(this._rate);
                event.updateAfterEvent();
                this.dispatchEvent(new CommonEvent(this.type, this._rate));
            }
            return;
        }// end function

        private function onMouseDown(event:MouseEvent) : void
        {
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.moveSlider);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            return;
        }// end function

        private function onMouseUp(event:MouseEvent) : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveSlider);
            return;
        }// end function

        private function moveSlider(event:MouseEvent) : void
        {
            if (mouseX < this._w && mouseX > 0)
            {
                this.slider.x = mouseX;
                this._rate = this.slider.x / this._w;
                this.redrawPlayed(this._rate);
                event.updateAfterEvent();
                this.dispatchEvent(new CommonEvent(this.type, this._rate));
            }
            return;
        }// end function

        private function redrawPlayed(param1:Number) : void
        {
            var _loc_2:* = param1;
            this.playedBg.graphics.clear();
            this.playedBg.graphics.beginFill(16711680, 1);
            this.playedBg.graphics.drawRect(0, 0, this._w * _loc_2, this._h);
            this.playedBg.graphics.endFill();
            return;
        }// end function

        public function setdefault(param1:Number) : void
        {
            var _loc_2:* = param1;
            this.playedBg.graphics.clear();
            this.playedBg.graphics.beginFill(16711680, 1);
            this.playedBg.graphics.drawRect(0, 0, this._w * _loc_2, this._h);
            this.playedBg.graphics.endFill();
            this.slider.x = this._w * _loc_2;
            return;
        }// end function

    }
}
