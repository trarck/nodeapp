package com.cntv.player.widgets.views.ratebutton
{
    import com.cntv.player.playerCom.statuBox.view.*;
    import com.cntv.player.widgets.views.*;
    import flash.display.*;
    import flash.events.*;

    public class RateButton2 extends WidgetsButton
    {
        private var rateButton1Skin:Class;
        private var rateButton2Skin:Class;
        private var rateButton1:Sprite;
        private var rateButton2:Sprite;
        private var rateButton:Sprite;
        private var isselected:Boolean = false;
        private var _parent:titleBar;

        public function RateButton2(param1:titleBar)
        {
            var _loc_2:DisplayObject = null;
            this.rateButton1Skin = RateButton2_rateButton1Skin;
            this.rateButton2Skin = RateButton2_rateButton2Skin;
            this._parent = param1;
            this.rateButton = new Sprite();
            this.addChild(this.rateButton);
            this.rateButton.buttonMode = true;
            _loc_2 = new this.rateButton1Skin();
            this.rateButton1 = new Sprite();
            this.rateButton1.addChild(_loc_2);
            this.rateButton1.alpha = 0.8;
            this.rateButton.addChild(this.rateButton1);
            _loc_2 = new this.rateButton2Skin();
            this.rateButton2 = new Sprite();
            this.rateButton2.addChild(_loc_2);
            this.rateButton.addChild(this.rateButton2);
            this.rateButton2.visible = false;
            this.rateButton.addEventListener(MouseEvent.MOUSE_OVER, this.onrateButtonOver);
            this.rateButton.addEventListener(MouseEvent.MOUSE_OUT, this.onrateButtonOut);
            this.rateButton.addEventListener(MouseEvent.CLICK, this.onClickHandler);
            return;
        }// end function

        public function set _visible(param1:Boolean) : void
        {
            if (param1)
            {
                this.isselected = true;
                this.rateButton1.visible = false;
                this.rateButton2.visible = true;
            }
            else
            {
                this.isselected = false;
                this.rateButton1.visible = true;
                this.rateButton2.visible = false;
            }
            return;
        }// end function

        private function onrateButtonOver(event:MouseEvent) : void
        {
            this.rateButton1.visible = false;
            this.rateButton2.visible = true;
            return;
        }// end function

        private function onrateButtonOut(event:MouseEvent) : void
        {
            if (this.isselected)
            {
                return;
            }
            this.rateButton1.visible = true;
            this.rateButton2.visible = false;
            return;
        }// end function

        private function onClickHandler(event:MouseEvent) : void
        {
            this._parent.setbutton(2);
            return;
        }// end function

    }
}
