package com.cntv.player.playerCom.controlBar.view.progressBar
{
    import caurina.transitions.*;
    import com.cntv.common.events.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.video.events.*;
    import flash.display.*;
    import flash.events.*;

    public class ProgressView extends CommonSprite
    {
        private var progressBG:ProgressBG;
        private var playedBar:PlayedBar;
        private var loadedBar:LoadedBar;
        private var _played:Number = 0;
        private var _loaded:Number = 0;
        private var playTip:PlayTip;
        private var _targetArea:CommonMask;
        private var progressContainer:Sprite;
        private var roundRectMask:Sprite;
        private var timeTip:TimeTip;
        private var my_width:Number = 100;
        public var backward:Backward;
        private var forward:Forward;

        public function ProgressView()
        {
            this.progressContainer = new Sprite();
            this.progressBG = new ProgressBG();
            this.playedBar = new PlayedBar();
            this.loadedBar = new LoadedBar();
            this.backward = new Backward();
            this.forward = new Forward();
            this.backward.buttonMode = true;
            this.forward.buttonMode = true;
            this.backward.visible = false;
            this.forward.visible = false;
            this.playedBar.width = 1;
            this.loadedBar.width = 1;
            this.playTip = new PlayTip();
            this.playTip.x = 2;
            this.playTip.visible = false;
            this._targetArea = new CommonMask(100, 10, 16777215, 0);
            this._targetArea.y = -5;
            this._targetArea.addEventListener(MouseEvent.ROLL_OVER, this.showTimeTip);
            this._targetArea.addEventListener(MouseEvent.ROLL_OUT, this.hideTimeTip);
            this._targetArea.addEventListener(MouseEvent.CLICK, this.seekHandler);
            this._targetArea.buttonMode = true;
            this.setRoundMask();
            this.progressContainer.addChild(this.progressBG);
            this.progressContainer.addChild(this.loadedBar);
            this.progressContainer.addChild(this.playedBar);
            this.addChild(this.progressContainer);
            this.addChild(this.playTip);
            this.addChild(this._targetArea);
            this.addChild(this.backward);
            this.addChild(this.forward);
            this.timeTip = new TimeTip();
            this.timeTip.y = -40;
            this.timeTip.visible = false;
            this.addChild(this.timeTip);
            this.adjust();
            this.backward.addEventListener(MouseEvent.CLICK, this.onbackwardClick);
            this.forward.addEventListener(MouseEvent.CLICK, this.onforwardClick);
            return;
        }// end function

        private function onbackwardClick(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_PLAY_SETPROGRES, "back"));
            return;
        }// end function

        private function onforwardClick(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_PLAY_SETPROGRES, "pre"));
            return;
        }// end function

        public function oncontrolBarOver() : void
        {
            this.playTip.visible = true;
            this.backward.visible = true;
            this.forward.visible = true;
            this.backward.x = -20;
            this.forward.x = stage.stageWidth - 40;
            this.progressBG.controlbarOver();
            this.playedBar.controlbarOver();
            this.loadedBar.controlbarOver();
            return;
        }// end function

        public function oncontrolBarOut() : void
        {
            this.backward.visible = false;
            this.forward.visible = false;
            this.playTip.visible = false;
            this.progressBG.controlbarOut();
            this.playedBar.controlbarOut();
            this.loadedBar.controlbarOut();
            return;
        }// end function

        private function setRoundMask() : void
        {
            this.roundRectMask = new Sprite();
            this.addChild(this.roundRectMask);
            this.drawRoundMask();
            return;
        }// end function

        private function drawRoundMask() : void
        {
            this.roundRectMask.graphics.clear();
            this.roundRectMask.graphics.beginFill(65280, 0);
            this.roundRectMask.graphics.drawRoundRect(0, 0, this.my_width, 8, 8, 8);
            return;
        }// end function

        override protected function adjust() : void
        {
            this.playTip.y = (this.progressBG.height - this.playTip.height) / 2;
            if (stage)
            {
                this.backward.x = -20;
                this.forward.x = stage.stageWidth - 40;
            }
            return;
        }// end function

        override public function get width() : Number
        {
            return this.progressBG.width;
        }// end function

        override public function set width(param1:Number) : void
        {
            this.progressBG.width = param1;
            this._targetArea.width = param1;
            this.my_width = param1;
            this.drawRoundMask();
            return;
        }// end function

        override public function get height() : Number
        {
            return this.progressBG.height;
        }// end function

        override public function set height(param1:Number) : void
        {
            super.height = param1;
            return;
        }// end function

        public function set played(param1:Number) : void
        {
            if (param1 > 1)
            {
                this._played = 1;
            }
            else
            {
                this._played = param1;
            }
            this.playedBar.width = this.progressBG.width * this._played;
            this.playedBar.width = this.progressBG.width * this._played;
            this.playTip.x = this.playedBar.width * (this.progressBG.width - 11) / this.progressBG.width + 2;
            return;
        }// end function

        public function get played() : Number
        {
            return this._played;
        }// end function

        public function set loaded(param1:Number) : void
        {
            if (param1 > 1)
            {
                this._loaded = 1;
            }
            else
            {
                this._loaded = param1;
            }
            this.loadedBar.width = this.progressBG.width * this._loaded;
            return;
        }// end function

        public function get loaded() : Number
        {
            return this._loaded;
        }// end function

        private function showTimeTip(event:MouseEvent) : void
        {
            this.timeTip.visible = true;
            this.addEventListener(MouseEvent.MOUSE_MOVE, this.moveTipWithMouse);
            return;
        }// end function

        private function hideTimeTip(event:MouseEvent) : void
        {
            this.timeTip.visible = false;
            this.playTip.visible = false;
            this.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveTipWithMouse);
            return;
        }// end function

        private function moveTipWithMouse(event:MouseEvent) : void
        {
            var _loc_2:* = mouseX - this.timeTip.width / 2;
            Tweener.removeTweens(this.timeTip);
            Tweener.addTween(this.timeTip, {time:1, transition:"easeOutExpo", x:_loc_2});
            var _loc_3:* = mouseX / this.progressBG.width * _modelLocator.movieDuration;
            if (_modelLocator.paramVO.isSlicedByHotDot && _modelLocator.sliceMovieDuration != 0)
            {
                _loc_3 = mouseX / this.progressBG.width * _modelLocator.sliceMovieDuration;
            }
            else if (_modelLocator.paramVO.isLockLimit)
            {
                _loc_3 = mouseX / this.progressBG.width * _modelLocator.limitedDuring;
            }
            this.timeTip.setTimeText(TextGenerator.secondToTimeFomat(_loc_3));
            return;
        }// end function

        private function seekHandler(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.SEEK_CLICK));
            var _loc_2:* = mouseX / this.progressBG.width;
            if (_modelLocator.paramVO.isSlicedByHotDot && _modelLocator.sliceMovieDuration != 0)
            {
                _loc_2 = (Number(_modelLocator.paramVO.sliceStartTime) + _loc_2 * _modelLocator.sliceMovieDuration) / _modelLocator.movieDuration;
            }
            else if (_modelLocator.paramVO.isLockLimit)
            {
                _loc_2 = (Number(_modelLocator.paramVO.startTime) + _loc_2 * _modelLocator.limitedDuring) / _modelLocator.movieDuration;
            }
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_VIDEO_SEEK, _loc_2));
            return;
        }// end function

    }
}
