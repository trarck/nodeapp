package com.cntv.player.playerCom.controlBar.view.volume
{
    import caurina.transitions.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.volume.embed.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.events.*;

    public class ControlView extends CommonSprite
    {
        private const TOP_GAP:Number = 15;
        private const TRACK_HEIGHT:Number = 70;
        private var _bg:VolumeBG;
        private var _track:VolumeTrack;
        private var _tip:VolumeTip;
        private var moveContainer:Sprite;
        private var controlViewMask:Sprite;
        private var buttonView:ButtonView;
        private var clickLayer:Sprite;

        public function ControlView()
        {
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_TURN_ON_MUTE, this.turnOnMuteHandler);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_TURN_OFF_MUTE, this.turnOffMuteHandler);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_SHOUND_UP, this.onShoundUp);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_SHOUND_DOWN, this.onShoundDown);
            return;
        }// end function

        override protected function init() : void
        {
            this.moveContainer = new Sprite();
            this._bg = new VolumeBG();
            this._bg.x = 30;
            this._bg.y = 3;
            this._track = new VolumeTrack();
            this._track.x = 30;
            this._track.y = 3;
            this.moveContainer.addChild(this._bg);
            this.moveContainer.addChild(this._track);
            this.moveContainer.y = 0;
            this.addChild(this.moveContainer);
            this.controlViewMask = new Sprite();
            this.controlViewMask.graphics.moveTo(30, 13);
            this.controlViewMask.graphics.beginFill(16711680, 0.5);
            this.controlViewMask.graphics.lineStyle(1, 11141120, 1);
            this.controlViewMask.graphics.lineTo(80, 13);
            this.controlViewMask.graphics.lineTo(80, 3);
            this.controlViewMask.graphics.lineTo(30, 13);
            this.controlViewMask.graphics.endFill();
            this.addChild(this.controlViewMask);
            this.moveContainer.mask = this.controlViewMask;
            this.clickLayer = new Sprite();
            this.clickLayer.graphics.moveTo(30, 13);
            this.clickLayer.graphics.beginFill(65280, 0);
            this.clickLayer.graphics.lineStyle(1, 11141120, 0);
            this.clickLayer.graphics.lineTo(80, 13);
            this.clickLayer.graphics.lineTo(80, 3);
            this.clickLayer.graphics.lineTo(30, 13);
            this.clickLayer.graphics.endFill();
            this.addChild(this.clickLayer);
            this._tip = new VolumeTip();
            this._tip.x = 80;
            this._tip.y = 0;
            this._tip.buttonMode = true;
            this.addChild(this._tip);
            this._tip.addEventListener(MouseEvent.MOUSE_DOWN, this.startDragTip);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.stopDragTip);
            this.clickLayer.addEventListener(MouseEvent.CLICK, this.clickLayerHandler);
            var _loc_1:* = _modelLocator.volumeValue;
            this.buttonView = new ButtonView();
            this.addChild(this.buttonView);
            return;
        }// end function

        private function clickLayerHandler(event:MouseEvent) : void
        {
            var _loc_2:* = mouseX;
            if (_loc_2 > 80)
            {
                _loc_2 = 80;
            }
            if (_loc_2 < 30)
            {
                _loc_2 = 30;
            }
            this._tip.x = _loc_2;
            _modelLocator.volumeValue = (_loc_2 - 30) / 50;
            this.buttonView.setButtonView();
            this._track.redrawBG(_modelLocator.volumeValue);
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VOLUME, _modelLocator.volumeValue));
            _dispatcher.dispatchEvent(new CommonEvent(ControlBarEvent.EVENT_SHOW_SHOUND_SIZE));
            return;
        }// end function

        public function show() : void
        {
            Tweener.removeTweens(this.moveContainer);
            Tweener.addTween(this.moveContainer, {time:0.5, y:0});
            return;
        }// end function

        public function hide() : void
        {
            Tweener.removeTweens(this.moveContainer);
            Tweener.addTween(this.moveContainer, {time:0.5, y:100});
            return;
        }// end function

        override public function get height() : Number
        {
            return 120;
        }// end function

        override public function set height(param1:Number) : void
        {
            super.height = param1;
            return;
        }// end function

        override public function get width() : Number
        {
            return 30;
        }// end function

        override public function set width(param1:Number) : void
        {
            super.width = param1;
            return;
        }// end function

        private function startDragTip(event:MouseEvent) : void
        {
            if (_modelLocator.isMute)
            {
                _modelLocator.isMute = false;
                _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_ACTIVE_MUTE));
            }
            this.addEventListener(MouseEvent.MOUSE_MOVE, this.moveTipWithMouse);
            return;
        }// end function

        private function moveTipWithMouse(event:MouseEvent) : void
        {
            var _loc_2:* = mouseX;
            if (_loc_2 > 80)
            {
                _loc_2 = 80;
            }
            if (_loc_2 < 30)
            {
                _loc_2 = 30;
            }
            this._tip.x = _loc_2;
            _modelLocator.volumeValue = (_loc_2 - 30) / 50;
            this.buttonView.setButtonView();
            this._track.redrawBG(_modelLocator.volumeValue);
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VOLUME, _modelLocator.volumeValue));
            _dispatcher.dispatchEvent(new CommonEvent(ControlBarEvent.EVENT_SHOW_SHOUND_SIZE));
            return;
        }// end function

        private function stopDragTip(event:MouseEvent) : void
        {
            this.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveTipWithMouse);
            return;
        }// end function

        private function onShoundUp(event:ControlBarEvent) : void
        {
            if (_modelLocator.volumeValue >= 5)
            {
                return;
            }
            if (_modelLocator.volumeValue >= 0 && _modelLocator.volumeValue <= 1)
            {
                _modelLocator.volumeValue = _modelLocator.volumeValue + 0.2;
                this._tip.x = _modelLocator.volumeValue * 50 + 30;
                if (this._tip.x >= 80)
                {
                    this._tip.x = 80;
                }
                this._track.redrawBG((this._tip.x - 30) / 50);
            }
            else if (_modelLocator.volumeValue >= 1 && _modelLocator.volumeValue < 5)
            {
                this._tip.x = 80;
                _modelLocator.volumeValue = _modelLocator.volumeValue + 0.25;
                if (_modelLocator.volumeValue >= 5)
                {
                    _modelLocator.volumeValue = 5;
                }
                this._track.redrawBG(1);
            }
            this.buttonView.setButtonView();
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VOLUME, _modelLocator.volumeValue));
            _dispatcher.dispatchEvent(new CommonEvent(ControlBarEvent.EVENT_SHOW_SHOUND_SIZE));
            return;
        }// end function

        private function onShoundDown(event:ControlBarEvent) : void
        {
            if (_modelLocator.volumeValue <= 0)
            {
                return;
            }
            if (_modelLocator.volumeValue >= 1 && _modelLocator.volumeValue <= 5)
            {
                this._tip.x = 80;
                _modelLocator.volumeValue = _modelLocator.volumeValue - 0.25;
                this._track.redrawBG(1);
            }
            else if (_modelLocator.volumeValue >= 0 && _modelLocator.volumeValue <= 1)
            {
                _modelLocator.volumeValue = _modelLocator.volumeValue - 0.2;
                this._tip.x = _modelLocator.volumeValue * 50 + 30;
                if (_modelLocator.volumeValue <= 0)
                {
                    _modelLocator.volumeValue = 0;
                    this._tip.x = 30;
                }
                this._track.redrawBG((this._tip.x - 30) / 50);
            }
            this.buttonView.setButtonView();
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VOLUME, _modelLocator.volumeValue));
            _dispatcher.dispatchEvent(new CommonEvent(ControlBarEvent.EVENT_SHOW_SHOUND_SIZE));
            return;
        }// end function

        private function turnOnMuteHandler(event:VideoPlayEvent) : void
        {
            var _loc_2:Number = 0;
            this._track.redrawBG(_loc_2);
            this._tip.x = 30;
            return;
        }// end function

        private function turnOffMuteHandler(event:VideoPlayEvent) : void
        {
            var _loc_2:* = _modelLocator.volumeValue;
            this._track.redrawBG(_loc_2);
            if (_loc_2 <= 1)
            {
                this._tip.x = _loc_2 * 50 + 30;
            }
            else
            {
                this._tip.x = 80;
            }
            return;
        }// end function

    }
}
