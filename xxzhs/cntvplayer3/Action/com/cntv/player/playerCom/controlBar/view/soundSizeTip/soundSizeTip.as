package com.cntv.player.playerCom.controlBar.view.soundSizeTip
{
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class soundSizeTip extends CommonSprite
    {
        private var tipBG:Sprite;
        private var tipText:TextField;
        private var _width:Number;
        private var closeBtn:Sprite;
        private var haveDisplayed:Boolean = false;

        public function soundSizeTip()
        {
            this.visible = false;
            return;
        }// end function

        override protected function init() : void
        {
            var _loc_1:* = stage.stageWidth;
            this._width = _loc_1;
            this.tipBG = new Sprite();
            this.tipBG.graphics.beginFill(16777215, 0.1);
            this.tipBG.graphics.drawRect(0, 0, this._width, 30);
            this.tipBG.graphics.endFill();
            this.addChild(this.tipBG);
            this.tipText = new TextField();
            this.tipText.defaultTextFormat = new TextFormat("", 12, 16777215, false);
            this.tipText.height = 28;
            this.tipText.width = 500;
            this.tipText.y = 4;
            this.tipText.x = 8;
            this.addChild(this.tipText);
            this.closeBtn = new Sprite();
            this.closeBtn.y = 15;
            this.closeBtn.x = this._width - 10;
            this.closeBtn.buttonMode = true;
            this.closeBtn.graphics.beginFill(16711680, 0);
            this.closeBtn.graphics.drawCircle(0, 0, 10);
            this.closeBtn.graphics.lineStyle(1, 16777215, 1, false);
            this.closeBtn.graphics.moveTo(-5, 5);
            this.closeBtn.graphics.lineTo(5, -5);
            this.closeBtn.graphics.moveTo(-5, -5);
            this.closeBtn.graphics.lineTo(5, 5);
            this.closeBtn.graphics.endFill();
            this.addChild(this.closeBtn);
            this.closeBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseover);
            this.closeBtn.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseout);
            this.closeBtn.addEventListener(MouseEvent.CLICK, this.onClick);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_SHOW_SHOUND_SIZE, this.onShow);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_HIDE_SHOUND_SIZE, this.onHide);
            return;
        }// end function

        public function onShow(event:CommonEvent) : void
        {
            if (!this.haveDisplayed)
            {
                this.setVisit(true);
                if (_modelLocator.volumeValue >= 5)
                {
                    this.tipText.text = this._modelLocator.i18n.CONTROLBAR_SOUNDTIP1 + Math.floor(_modelLocator.volumeValue * 100) + "%";
                }
                else if (_modelLocator.volumeValue >= 1)
                {
                    this.tipText.text = this._modelLocator.i18n.CONTROLBAR_SOUNDTIP1 + Math.floor(_modelLocator.volumeValue * 100) + "%" + _modelLocator.i18n.CONTROLBAR_SOUNDTIP3;
                }
                else
                {
                    this.tipText.text = this._modelLocator.i18n.CONTROLBAR_SOUNDTIP1 + Math.floor(_modelLocator.volumeValue * 100) + "%" + _modelLocator.i18n.CONTROLBAR_SOUNDTIP2;
                }
            }
            return;
        }// end function

        public function onHide(event:CommonEvent) : void
        {
            this.setVisit(false);
            return;
        }// end function

        public function onClick(event:MouseEvent) : void
        {
            this.setVisit(false);
            this.haveDisplayed = true;
            return;
        }// end function

        public function setVisit(param1:Boolean) : void
        {
            this.visible = param1;
            return;
        }// end function

        public function onMouseover(event:MouseEvent) : void
        {
            this.closeBtn.graphics.clear();
            this.closeBtn.graphics.beginFill(16711680, 0);
            this.closeBtn.graphics.drawCircle(0, 0, 10);
            this.closeBtn.graphics.lineStyle(1, 16711680, 1, false);
            this.closeBtn.graphics.moveTo(-5, 5);
            this.closeBtn.graphics.lineTo(5, -5);
            this.closeBtn.graphics.moveTo(-5, -5);
            this.closeBtn.graphics.lineTo(5, 5);
            this.closeBtn.graphics.endFill();
            return;
        }// end function

        public function onMouseout(event:MouseEvent) : void
        {
            this.closeBtn.graphics.clear();
            this.closeBtn.graphics.beginFill(16711680, 0);
            this.closeBtn.graphics.drawCircle(0, 0, 10);
            this.closeBtn.graphics.lineStyle(1, 16777215, 1, false);
            this.closeBtn.graphics.moveTo(-5, 5);
            this.closeBtn.graphics.lineTo(5, -5);
            this.closeBtn.graphics.moveTo(-5, -5);
            this.closeBtn.graphics.lineTo(5, 5);
            this.closeBtn.graphics.endFill();
            return;
        }// end function

        override protected function adjust() : void
        {
            this._width = stage.stageWidth;
            this.tipBG.graphics.clear();
            this.tipBG.graphics.beginFill(16777215, 0.1);
            this.tipBG.graphics.drawRect(0, 0, this._width, 30);
            this.tipBG.graphics.endFill();
            this.closeBtn.x = this._width - 10;
            return;
        }// end function

    }
}
