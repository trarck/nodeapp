package com.cntv.player.playerCom.controlBar.view
{
    import caurina.transitions.*;
    import com.cntv.common.model.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.floatLayer.event.*;
    import com.cntv.player.playerCom.*;
    import com.cntv.player.playerCom.controlBar.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view._bitratePanel.*;
    import com.cntv.player.playerCom.controlBar.view.adlogo.*;
    import com.cntv.player.playerCom.controlBar.view.biterate2.*;
    import com.cntv.player.playerCom.controlBar.view.bitrate.*;
    import com.cntv.player.playerCom.controlBar.view.cntvlogo.*;
    import com.cntv.player.playerCom.controlBar.view.controlBarBG.*;
    import com.cntv.player.playerCom.controlBar.view.fullScreen.*;
    import com.cntv.player.playerCom.controlBar.view.hotDot.*;
    import com.cntv.player.playerCom.controlBar.view.nba.*;
    import com.cntv.player.playerCom.controlBar.view.playerButtonBG.*;
    import com.cntv.player.playerCom.controlBar.view.progressBar.*;
    import com.cntv.player.playerCom.controlBar.view.search.*;
    import com.cntv.player.playerCom.controlBar.view.soundSizeTip.*;
    import com.cntv.player.playerCom.controlBar.view.spliteLine.*;
    import com.cntv.player.playerCom.controlBar.view.timePanel.*;
    import com.cntv.player.playerCom.controlBar.view.volume.*;
    import com.cntv.player.playerCom.controlBar.view.wideScreen.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class ControlBarModule extends CommonSprite
    {
        public var WIDGETS_BUTTON_BAR_WIDTH:Number = 300;
        private var hideTimer:Timer;
        private var smallContainer:Sprite;
        private var hotDotContainer:Sprite;
        private var _bg:ControlBarBG;
        private var _playButtonBG:PlayerButtonBG;
        private var _progressView:ProgressView;
        private const HIDE_TIME:Number = 5;
        private var controlButtonBarLeft:Sprite;
        private var playPauseView:PlayPauseView;
        private var controlButtonBarRight:Sprite;
        private var fuscreenView:FuScreenView;
        private var volumeView:VolumeView;
        private var brightness:WideButton;
        private var narrowbtn:NarrowButton;
        private var biterate:BitrateButton;
        private var timeView:TimerPanelView;
        private var logo:AdLogoButton;
        private var popUpView:Sprite;
        private var popUpWindow:CommonSprite;
        private var nowPopType:String = "";
        private var tempPopType:String = "";
        private var isHide:Boolean;
        private var isOnControlBar:Boolean = false;
        private var holdeBar:Boolean = false;
        private var hotDotPancel:HotDot;
        private var nbaPancel:iconNba;
        private var searchView:searchBar;
        private var soundTip:soundSizeTip;
        private var cntvlogo:CntvLogo;
        private var baseLayer:Sprite;
        private var line1:SpliteLine;
        private var line2:SpliteLine;
        private var BitRate:Sprite;
        private var BtiRateText:TextField;
        private var format:TextFormat;
        private var showAllOption:Boolean = true;
        private var glow:GlowFilter;
        private var myFilters:Array;
        private var BitratePanel:CBitRatePanel;
        private var b:Boolean = true;
        private var isfirst:Boolean = true;
        private var length:Number = 2;
        public static const EVENT_CLOSE_WINDOW:String = "event.close.window";
        public static const NAME:String = "ControlBarModule";
        public static const CONTROL_BUTTON_BAR_WIDTH:Number = 30;
        public static const CONTROL_BAR_HEIGHT:Number = 30;
        public static const AD_BAR_WIDTH:Number = 50;
        public static const LEFT_GAP:Number = 0;
        public static const NEXT_PREV_VIEW_X:Number = 95;
        public static const H_GAP:Number = 10;
        public static const TIME_GAP:Number = 50;
        public static const Line1_GAP:Number = 40;

        public function ControlBarModule(param1:Sprite)
        {
            ControlBarFacade.getInstance(NAME).startUp(this);
            this.popUpView = param1;
            this.hideTimer = new Timer(this.HIDE_TIME * 1000, 1);
            this.hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.hideControlBar);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_LOCK_CONTROLBAR, this.lockControlBar);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_UNLOCK_CONTROLBAR, this.unlockControlBar);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_SHOW_HOTDOT, this.onShowHotDot);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_SHOW_NBA, this.onShowNBA);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_ADD_HOTDOT, this.onAddHotDot);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_AUDIO_MODEL, this.onAudioModel);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_VIDEO_MODEL, this.onVideoModel);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_ADPLAY_OVER, this.onAdPlayOver);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_SEEK, this.onUserSeek);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_SHOW_CONTROLBAR, this.onShowBar);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_SET_TEXT, this.onSetText);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_SET_TEXT2, this.onSetText2);
            _dispatcher.addEventListener(FLayerEvent.EVENT_SHOW_CHANGETEXT, this.onChangeText);
            _dispatcher.addEventListener(FLayerEvent.EVENT_SHOW_HIDEPANEL, this.onHidePanle);
            this.addEventListener(MouseEvent.MOUSE_OVER, this.onThisOver);
            this.addEventListener(MouseEvent.ROLL_OUT, this.onThisOut);
            this.glow = new GlowFilter();
            this.myFilters = new Array();
            this.myFilters.push(this.glow);
            return;
        }// end function

        private function onAudioModel(event:ControlBarEvent) : void
        {
            this.brightness.isEnable = false;
            this.biterate.isEnable = false;
            this.brightness.removeEventListener(MouseEvent.CLICK, this.showBrightnessVewHandler);
            this.biterate.removeEventListener(MouseEvent.CLICK, this.showBiterateVewHandler);
            return;
        }// end function

        private function onVideoModel(event:ControlBarEvent) : void
        {
            if (this.brightness != null)
            {
                this.brightness.isEnable = true;
                this.biterate.isEnable = true;
                this.brightness.addEventListener(MouseEvent.CLICK, this.showBrightnessVewHandler);
            }
            if (this.biterate != null)
            {
                this.biterate.addEventListener(MouseEvent.CLICK, this.showBiterateVewHandler);
            }
            return;
        }// end function

        private function onThisOver(event:MouseEvent) : void
        {
            this.isOnControlBar = true;
            return;
        }// end function

        private function onThisOut(event:MouseEvent) : void
        {
            this.isOnControlBar = false;
            return;
        }// end function

        private function doRealStart(event:VideoPlayEvent = null) : void
        {
            this.hideTimer.start();
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stopHide);
            _dispatcher.removeEventListener(VideoPlayEvent.EVENT_REAL_START, this.doRealStart);
            return;
        }// end function

        private function onShowBar(event:CommonEvent) : void
        {
            this.stopHide(new MouseEvent(MouseEvent.MOUSE_OVER));
            return;
        }// end function

        private function onShowNBA(event:ControlBarEvent) : void
        {
            this.nbaPancel = new iconNba();
            this.hotDotContainer.addChild(this.nbaPancel);
            this.nbaPancel.y = -480;
            this.smallContainer.addChild(this._progressView);
            return;
        }// end function

        private function onShowHotDot(event:ControlBarEvent) : void
        {
            var _loc_2:Boolean = false;
            if (event["data"] == true)
            {
                _loc_2 = true;
            }
            this.hotDotPancel = new HotDot(_loc_2);
            this.hotDotPancel.y = -90;
            this.hotDotPancel.addEventListener("releaseDot", this.onReleaseDot);
            if (_modelLocator.paramVO.matchData != null && _modelLocator.paramVO.matchData.isPrecise)
            {
                this.holdeBar = true;
                this.hotDotPancel.addEventListener("cancelHoldeBar", this.onCancelHoldeBar);
            }
            this.hotDotContainer.addChild(this.hotDotPancel);
            this.smallContainer.addChild(this._progressView);
            return;
        }// end function

        private function onCancelHoldeBar(event:Event) : void
        {
            this.holdeBar = false;
            this.stopHide(new MouseEvent(MouseEvent.MOUSE_MOVE));
            return;
        }// end function

        private function onReleaseDot(event:Event) : void
        {
            this.holdeBar = false;
            this.hotDotContainer.removeChild(this.hotDotPancel);
            this.hotDotPancel.removeEventListener("releaseDot", this.onReleaseDot);
            this.hotDotPancel.removeEventListener("cancelHoldeBar", this.onCancelHoldeBar);
            this.hotDotPancel = null;
            return;
        }// end function

        private function onAddHotDot(event:ControlBarEvent) : void
        {
            return;
        }// end function

        private function stopHide(event:MouseEvent) : void
        {
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_TITLE_BAR, null));
            }
            if (this.isHide)
            {
                this.showControlBar(null);
            }
            else
            {
                this.hideTimer.stop();
                this.hideTimer.reset();
                this.hideTimer.start();
            }
            if (this._progressView != null)
            {
                this._progressView.width = stage.stageWidth - 40;
                this._progressView.x = 20;
                this._progressView.y = -3;
                this._progressView.oncontrolBarOver();
            }
            if (this.searchView != null && stage.displayState == StageDisplayState.NORMAL)
            {
                Tweener.removeTweens(this.searchView);
                Tweener.addTween(this.searchView, {time:0.5, y:0});
            }
            return;
        }// end function

        override protected function init() : void
        {
            var _loc_1:DisplayObject = null;
            if (_modelLocator.isReady)
            {
                this.doRealStart();
            }
            else
            {
                _dispatcher.addEventListener(VideoPlayEvent.EVENT_REAL_START, this.doRealStart);
            }
            this.smallContainer = new Sprite();
            this.hotDotContainer = new Sprite();
            this.addChild(this.smallContainer);
            if (stage.stageWidth < 400)
            {
                this.showAllOption = false;
            }
            this._bg = new ControlBarBG();
            this.smallContainer.addChild(this._bg);
            this.controlButtonBarLeft = new Sprite();
            this.smallContainer.addChild(this.controlButtonBarLeft);
            this.playPauseView = new PlayPauseView();
            this.playPauseView.x = LEFT_GAP;
            this.playPauseView.addEventListener(ControlBarEvent.EVENT_VIDEO_PLAY, this.playButtonHandler);
            this.playPauseView.addEventListener(ControlBarEvent.EVENT_VIDEO_PAUSE, this.pauseButtonHandler);
            this.controlButtonBarLeft.addChild(this.playPauseView);
            if (!_modelLocator.ISWEBSITE)
            {
                this.WIDGETS_BUTTON_BAR_WIDTH = 230;
            }
            this.smallContainer.addChild(this.hotDotContainer);
            this.soundTip = new soundSizeTip();
            this.addChild(this.soundTip);
            this.smallContainer.addChild(this.soundTip);
            this.soundTip.y = -ControlBarBG.CONTROL_BAR_HEIGHT;
            this.controlButtonBarRight = new Sprite();
            this.smallContainer.addChild(this.controlButtonBarRight);
            this.logo = new AdLogoButton();
            this.logo.x = this.WIDGETS_BUTTON_BAR_WIDTH - H_GAP - this.logo.width;
            this.fuscreenView = new FuScreenView();
            this.controlButtonBarRight.addChild(this.fuscreenView);
            this.line1 = new SpliteLine();
            this.line2 = new SpliteLine();
            this.volumeView = new VolumeView();
            if (_modelLocator.ISWEBSITE)
            {
                this.fuscreenView.x = this.logo.x + H_GAP * 4 - this.fuscreenView.width;
                this.BtiRateText = new TextField();
                this.format = new TextFormat("", 12, 10066329, true);
                this.BtiRateText.defaultTextFormat = this.format;
                this.BtiRateText.text = _modelLocator.i18n.HIGHDEFINITION;
                this.BtiRateText.height = 20;
                this.BtiRateText.x = 0;
                this.BtiRateText.filters = null;
                if (_modelLocator.currentVideoInfo)
                {
                    this.onSetText(new ControlBarEvent("", _modelLocator.currentVideoInfo.vddStreamRate));
                }
                this.BitRate = new Sprite();
                this.BitRate.addChild(this.BtiRateText);
                this.controlButtonBarRight.addChild(this.BitRate);
                this.BitRate.x = this.fuscreenView.x - H_GAP * 2 - 30;
                this.BitRate.y = 6;
                this.BitRate.buttonMode = true;
                this.BitRate.mouseChildren = false;
                this.BitRate.addEventListener(MouseEvent.CLICK, this.showBitRateHandler);
                this.BitRate.addEventListener(MouseEvent.MOUSE_OVER, this.onBitRateMouseOver);
                this.BitRate.addEventListener(MouseEvent.MOUSE_OUT, this.onBitRateMouseOut);
                this.brightness = new WideButton();
                this.brightness.x = this.fuscreenView.x - H_GAP * 3 - this.brightness.width;
                this.brightness.addEventListener(MouseEvent.CLICK, this.showBrightnessVewHandler);
                this.BitratePanel = new CBitRatePanel(this);
                this.addChild(this.BitratePanel);
                this.BitratePanel._visible = false;
                this.narrowbtn = new NarrowButton();
                this.narrowbtn.x = this.fuscreenView.x - H_GAP * 2 - this.narrowbtn.width;
                this.narrowbtn.y = 4;
                this.narrowbtn.addEventListener(MouseEvent.CLICK, this.narrowbtnHandler);
                this.narrowbtn.visible = false;
                if (!_modelLocator.paramVO.isCycle)
                {
                    this.biterate = new BitrateButton();
                    this.biterate.x = this.brightness.x - H_GAP * 2 - this.biterate.width;
                    this.biterate.addEventListener(MouseEvent.CLICK, this.showBiterateVewHandler);
                    this.biterate.visible = !_modelLocator.paramVO.isLive;
                    this.controlButtonBarRight.addChild(this.biterate);
                    this.timeView = new TimerPanelView();
                    this.timeView.x = TIME_GAP;
                    this.timeView.visible = !_modelLocator.paramVO.isLive;
                    this.line1.x = Line1_GAP;
                }
                else
                {
                    this.timeView = new TimerPanelView();
                    this.timeView.x = TIME_GAP;
                    this.timeView.visible = !_modelLocator.paramVO.isLive;
                    this.line1.x = Line1_GAP;
                }
                if (!_modelLocator.paramVO.isLive && !_modelLocator.paramVO.isCycle)
                {
                    this.smallContainer.addChild(this.timeView);
                }
                this.volumeView.x = this.biterate.x - H_GAP * 8 - this.volumeView.width;
                if (!this.showAllOption)
                {
                    this.brightness.visible = false;
                    this.narrowbtn.visible = false;
                    this.biterate.visible = false;
                    this.BitRate.visible = false;
                    this.volumeView.x = this.fuscreenView.x - H_GAP * 8 - this.volumeView.width;
                }
            }
            else
            {
                this.cntvlogo = new CntvLogo();
                this.cntvlogo.buttonMode = true;
                this.controlButtonBarRight.addChild(this.cntvlogo);
                this.cntvlogo.x = this.logo.x + H_GAP * 5 - this.cntvlogo.width;
                this.cntvlogo.y = 10;
                this.cntvlogo.addEventListener(MouseEvent.CLICK, this.cntvlogoClick);
                this.fuscreenView.x = this.cntvlogo.x - this.fuscreenView.width - H_GAP * 2;
                this.timeView = new TimerPanelView();
                this.timeView.x = TIME_GAP;
                this.timeView.visible = !_modelLocator.paramVO.isLive;
                this.line1.x = Line1_GAP;
                this.smallContainer.addChild(this.timeView);
                if (_modelLocator.paramVO.showSearchBar)
                {
                    this.searchView = new searchBar();
                    this.addChild(this.searchView);
                    this.searchView.startLoad();
                }
                this.volumeView.x = this.fuscreenView.x - H_GAP * 8 - this.volumeView.width;
            }
            this.controlButtonBarRight.addChild(this.volumeView);
            this.controlButtonBarLeft.addChild(this.line1);
            this.controlButtonBarRight.addChild(this.line2);
            this.line2.x = this.volumeView.x - H_GAP;
            if (!_modelLocator.paramVO.isLive && !_modelLocator.paramVO.isCycle)
            {
                this._progressView = new ProgressView();
                this.smallContainer.addChild(this._progressView);
            }
            this.adjust();
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_LOCK_CONTROLBAR));
            return;
        }// end function

        public function adjustBitratePanel(param1:Number) : void
        {
            this.length = param1;
            this.BitratePanel.y = stage.stageHeight - this.length * 20 - 60;
            return;
        }// end function

        override protected function adjust() : void
        {
            if (_modelLocator.ISWEBSITE)
            {
                if (stage.stageWidth < 400)
                {
                    this.brightness.visible = false;
                    this.narrowbtn.visible = false;
                    this.biterate.visible = false;
                    this.BitRate.visible = false;
                    this.volumeView.x = this.fuscreenView.x - H_GAP * 8 - this.volumeView.width;
                }
                else if (stage.stageWidth > 600)
                {
                    this.brightness.visible = true;
                    this.biterate.visible = true;
                    this.BitRate.visible = true;
                    this.volumeView.x = this.biterate.x - H_GAP * 8 - this.volumeView.width;
                }
                this.line2.x = this.volumeView.x - H_GAP;
            }
            if (this._progressView != null)
            {
                if (this._progressView.backward.visible == false)
                {
                    this._progressView.width = stage.stageWidth;
                    this._progressView.x = 0;
                    this._progressView.y = -3;
                }
                else
                {
                    this._progressView.width = stage.stageWidth - 40;
                    this._progressView.x = 20;
                    this._progressView.y = -3;
                }
            }
            if (this.playPauseView)
            {
                this.playPauseView.y = (ControlBarBG.CONTROL_BAR_HEIGHT - this.playPauseView.height) / 2;
            }
            if (this.fuscreenView)
            {
                this.fuscreenView.y = (ControlBarBG.CONTROL_BAR_HEIGHT - this.fuscreenView.height) / 2;
            }
            if (this.brightness != null)
            {
                this.brightness.y = (ControlBarBG.CONTROL_BAR_HEIGHT - this.brightness.height) / 2;
            }
            this.volumeView.y = (ControlBarBG.CONTROL_BAR_HEIGHT - this.volumeView.height) / 2;
            if (this.biterate != null)
            {
                this.biterate.y = (ControlBarBG.CONTROL_BAR_HEIGHT - this.biterate.height) / 2;
            }
            if (this.BitratePanel != null)
            {
                this.BitratePanel.x = stage.stageWidth - 120;
            }
            this.timeView.y = (ControlBarBG.CONTROL_BAR_HEIGHT - this.timeView.height) / 2;
            this.logo.y = (ControlBarBG.CONTROL_BAR_HEIGHT - this.logo.height) / 2;
            this.controlButtonBarRight.x = stage.stageWidth - this.WIDGETS_BUTTON_BAR_WIDTH;
            this.smallContainer.y = stage.stageHeight - ControlBarBG.CONTROL_BAR_HEIGHT;
            if (this.popUpWindow != null)
            {
                this.popUpWindow.x = stage.stageWidth - H_GAP - this.popUpWindow.width - 60;
                this.popUpWindow.y = stage.stageHeight - 3 * H_GAP - this.popUpWindow.height - 5;
            }
            if (this.hotDotPancel != null)
            {
                this.hotDotPancel.resize();
            }
            if (this.nbaPancel != null)
            {
                this.nbaPancel.resize();
            }
            if (this.searchView != null && stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                Tweener.removeTweens(this.searchView);
                Tweener.addTween(this.searchView, {time:0.5, y:-40});
            }
            return;
        }// end function

        private function onUserSeek(event:ControlBarEvent) : void
        {
            if (this.hotDotPancel != null)
            {
                this.hotDotPancel.userSeek(event.data);
            }
            return;
        }// end function

        public function setPlayed(param1:Number) : void
        {
            if (this.hotDotPancel != null)
            {
                this.hotDotPancel.setCurrentTime(param1);
            }
            if (this.nbaPancel != null)
            {
                this.nbaPancel.setCurrentTime(param1 * _modelLocator.movieDuration);
            }
            if (!isNaN(param1) && !_modelLocator.paramVO.isCycle)
            {
                if (_modelLocator.paramVO.isSlicedByHotDot && _modelLocator.sliceMovieDuration != 0)
                {
                    this._progressView.played = param1;
                    this.timeView.minute = TextGenerator.secondToTimeFomat(param1 * _modelLocator.sliceMovieDuration);
                    this.timeView.second = TextGenerator.secondToTimeFomat(_modelLocator.sliceMovieDuration);
                }
                else if (_modelLocator.paramVO.isLockLimit)
                {
                    this._progressView.played = param1;
                    this.timeView.minute = TextGenerator.secondToTimeFomat(param1 * _modelLocator.limitedDuring);
                    this.timeView.second = TextGenerator.secondToTimeFomat(_modelLocator.limitedDuring);
                }
                else
                {
                    this._progressView.played = param1;
                    this.timeView.minute = TextGenerator.secondToTimeFomat(param1 * _modelLocator.movieDuration);
                    this.timeView.second = TextGenerator.secondToTimeFomat(_modelLocator.movieDuration);
                }
            }
            return;
        }// end function

        private function cntvlogoClick(event:MouseEvent) : void
        {
            if (_modelLocator.paramVO.url != "")
            {
                NativeToURLTool.openAURL(_modelLocator.paramVO.url);
            }
            else
            {
                NativeToURLTool.openAURL("http://www.cntv.cn", "_blank");
            }
            return;
        }// end function

        public function setLoaded(param1:Number) : void
        {
            if (!isNaN(param1) && !_modelLocator.paramVO.isCycle)
            {
                this._progressView.loaded = param1;
            }
            return;
        }// end function

        private function playButtonHandler(event:ControlBarEvent) : void
        {
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SINGLE_CLICK));
            return;
        }// end function

        private function pauseButtonHandler(event:ControlBarEvent) : void
        {
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SINGLE_CLICK));
            return;
        }// end function

        public function set isPlaying(param1:Boolean) : void
        {
            if (this.playPauseView)
            {
                this.playPauseView.isPlaying = param1;
            }
            return;
        }// end function

        private function clearStage() : void
        {
            Tweener.removeTweens(this.popUpWindow);
            Tweener.addTween(this.popUpWindow, {time:0.5, scaleX:0.3, scaleY:0.3, alpha:0, y:stage.stageHeight, onComplete:this.callShowPopAgain});
            return;
        }// end function

        private function callShowPopAgain() : void
        {
            this.popUpWindow.removeEventListener(EVENT_CLOSE_WINDOW, this.closeBrightView);
            this.popUpView.removeChild(this.popUpWindow);
            this.popUpWindow = null;
            this.showAPopUpWindow(this.tempPopType);
            return;
        }// end function

        private function showAPopUpWindow(param1:String) : void
        {
            if (this.nowPopType == param1)
            {
                if (this.popUpWindow != null && this.popUpView.contains(this.popUpWindow))
                {
                    Tweener.removeTweens(this.popUpWindow);
                    Tweener.addTween(this.popUpWindow, {time:0.5, scaleX:0.3, scaleY:0.3, alpha:0, y:stage.stageHeight, onComplete:this.killPopView});
                }
                return;
            }
            if (this.popUpWindow != null)
            {
                this.clearStage();
                this.tempPopType = param1;
                return;
            }
            this.nowPopType = param1;
            if (this.nowPopType == "1")
            {
                this.popUpWindow = new WideView();
            }
            else if (this.nowPopType == "2")
            {
                this.popUpWindow = new BiterateView();
            }
            else if (this.nowPopType == "3")
            {
                this.popUpWindow = new Biterate2View();
            }
            this.popUpWindow.alpha = 0;
            this.popUpWindow.x = stage.stageWidth - H_GAP - this.popUpWindow.width - 60;
            this.popUpWindow.y = stage.stageHeight;
            var _loc_2:* = stage.stageHeight - 3 * H_GAP - this.popUpWindow.height - 5;
            this.popUpWindow.scaleX = 0.3;
            this.popUpWindow.scaleY = 0.3;
            this.popUpWindow.addEventListener(EVENT_CLOSE_WINDOW, this.closeBrightView);
            this.popUpView.addChild(this.popUpWindow);
            Tweener.removeTweens(this.popUpWindow);
            Tweener.addTween(this.popUpWindow, {time:0.5, scaleX:1, scaleY:1, alpha:1, y:_loc_2});
            return;
        }// end function

        private function showBrightnessVewHandler(event:MouseEvent) : void
        {
            this.narrowbtn.visible = true;
            this.brightness.visible = false;
            _modelLocator.wideMode = _modelLocator.WIDE_SCREEN;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_SCREEN_WIDE));
            return;
        }// end function

        private function showBitRateHandler(event:MouseEvent) : void
        {
            if (this.isfirst)
            {
                _dispatcher.dispatchEvent(new FLayerEvent(FLayerEvent.EVENT_SHOW_QUALITYPANEL));
            }
            this.isfirst = false;
            if (ModelLocator.getInstance().isConvivaMode)
            {
                return;
            }
            if (this.b)
            {
                this.BitratePanel._visible = true;
            }
            else
            {
                this.BitratePanel._visible = false;
            }
            this.b = !this.b;
            return;
        }// end function

        private function onHidePanle(event:FLayerEvent) : void
        {
            this.BitratePanel._visible = false;
            this.b = true;
            return;
        }// end function

        private function onChangeText(event:FLayerEvent) : void
        {
            this.BtiRateText.text = event.data;
            if (this.BtiRateText.text == "超 高 清")
            {
                this.BtiRateText.width = this.BtiRateText.textWidth + 20;
            }
            return;
        }// end function

        private function onBitRateMouseOver(event:MouseEvent) : void
        {
            this.format.color = 13421772;
            this.BtiRateText.setTextFormat(this.format);
            this.BtiRateText.filters = this.myFilters;
            return;
        }// end function

        private function onBitRateMouseOut(event:MouseEvent) : void
        {
            this.format.color = 10066329;
            this.BtiRateText.setTextFormat(this.format);
            this.BtiRateText.filters = null;
            return;
        }// end function

        private function narrowbtnHandler(event:MouseEvent) : void
        {
            this.narrowbtn.visible = false;
            this.brightness.visible = true;
            _modelLocator.wideMode = _modelLocator.NORMAL_SCREEN;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_SCREEN_NORMAL));
            return;
        }// end function

        private function showBiterateVewHandler(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new FLayerEvent(FLayerEvent.EVENT_SHOW_PANEL, "config"));
            return;
        }// end function

        private function onSetText(event:ControlBarEvent) : void
        {
            switch(event.data)
            {
                case "LD":
                {
                    this.BtiRateText.text = _modelLocator.i18n.LOWERDEFINITION;
                    break;
                }
                case "STD":
                {
                    this.BtiRateText.text = _modelLocator.i18n.STANDARDDEFINITION;
                    break;
                }
                case "HD":
                {
                    this.BtiRateText.text = _modelLocator.i18n.HIGHDEFINITION;
                    break;
                }
                case "SD":
                {
                    this.BtiRateText.text = _modelLocator.i18n.SUPERDIFINITION;
                    break;
                }
                case "SHD":
                {
                    this.BtiRateText.text = _modelLocator.i18n.SUPERHIGHDIFINITION;
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.BtiRateText.width = this.BtiRateText.textWidth + 10;
            return;
        }// end function

        private function onSetText2(event:ControlBarEvent) : void
        {
            this.BtiRateText.text = event.data;
            this.BtiRateText.width = this.BtiRateText.textWidth + 10;
            return;
        }// end function

        private function closeBrightView(event:Event) : void
        {
            if (this.popUpWindow != null && this.popUpView.contains(this.popUpWindow))
            {
                Tweener.removeTweens(this.popUpWindow);
                Tweener.addTween(this.popUpWindow, {time:0.5, scaleX:0.3, scaleY:0.3, alpha:0, y:stage.stageHeight, onComplete:this.killPopView});
            }
            return;
        }// end function

        private function killPopView() : void
        {
            this.popUpWindow.removeEventListener(EVENT_CLOSE_WINDOW, this.closeBrightView);
            this.popUpView.removeChild(this.popUpWindow);
            this.popUpWindow = null;
            this.nowPopType = "";
            return;
        }// end function

        private function showControlBar(event:ControlBarEvent) : void
        {
            this.hideTimer.reset();
            this.hideTimer.start();
            Tweener.removeTweens(this.smallContainer);
            Tweener.addTween(this.smallContainer, {time:0.5, y:stage.stageHeight - ControlBarBG.CONTROL_BAR_HEIGHT, onComplete:this.BarShowed});
            this.isHide = false;
            Mouse.show();
            if (this.searchView != null && stage.displayState == StageDisplayState.NORMAL)
            {
                Tweener.removeTweens(this.searchView);
                Tweener.addTween(this.searchView, {time:0.5, y:0});
            }
            return;
        }// end function

        private function BarHided() : void
        {
            if (this.hotDotPancel != null)
            {
                this.hotDotPancel.showOrHide(false);
            }
            if (this.nbaPancel != null)
            {
                this.nbaPancel.showOrHide(false);
            }
            if (this.soundTip)
            {
                this.soundTip.setVisit(false);
            }
            return;
        }// end function

        private function BarShowed() : void
        {
            if (this.hotDotPancel != null)
            {
                this.hotDotPancel.showOrHide(true);
            }
            if (this.nbaPancel != null)
            {
                this.nbaPancel.showOrHide(true);
            }
            return;
        }// end function

        private function onAdPlayOver(event:ControlBarEvent) : void
        {
            this.stopHide(new MouseEvent(MouseEvent.MOUSE_MOVE));
            return;
        }// end function

        private function hideControlBar(event:TimerEvent) : void
        {
            if (this._progressView != null && !this.isOnControlBar)
            {
                this._progressView.width = stage.stageWidth;
                this._progressView.x = 0;
                this._progressView.y = -3;
                this._progressView.oncontrolBarOut();
            }
            if (this.searchView != null)
            {
                Tweener.removeTweens(this.searchView);
                Tweener.addTween(this.searchView, {time:0.5, y:-40});
            }
            if (this.isOnControlBar || this.holdeBar || BeforePlayerADMoudle.isPlayingAd || stage.displayState == StageDisplayState.NORMAL)
            {
                return;
            }
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_HIDE_TITLE_BAR, null));
            Tweener.removeTweens(this.smallContainer);
            Tweener.addTween(this.smallContainer, {time:0.5, y:stage.stageHeight, onComplete:this.BarHided});
            this.isHide = true;
            Mouse.hide();
            return;
        }// end function

        private function lockControlBar(event:ControlBarEvent) : void
        {
            if (this._progressView != null)
            {
                this._progressView.mouseChildren = false;
                this._progressView.mouseEnabled = false;
            }
            if (this.playPauseView)
            {
                this.playPauseView.mouseChildren = false;
                this.playPauseView.mouseEnabled = false;
            }
            this.fuscreenView.mouseChildren = false;
            this.fuscreenView.mouseEnabled = false;
            this.volumeView.mouseChildren = false;
            this.volumeView.mouseEnabled = false;
            if (this.brightness != null)
            {
                this.brightness.mouseChildren = false;
                this.brightness.mouseEnabled = false;
            }
            if (this.biterate != null)
            {
                this.biterate.mouseChildren = false;
                this.biterate.mouseEnabled = false;
            }
            return;
        }// end function

        private function unlockControlBar(event:ControlBarEvent) : void
        {
            if (this._progressView)
            {
                this._progressView.mouseChildren = true;
                this._progressView.mouseEnabled = true;
            }
            if (this.playPauseView)
            {
                this.playPauseView.mouseChildren = true;
                this.playPauseView.mouseEnabled = true;
            }
            this.fuscreenView.mouseChildren = true;
            this.fuscreenView.mouseEnabled = true;
            this.volumeView.mouseChildren = true;
            this.volumeView.mouseEnabled = true;
            if (this.brightness != null)
            {
                this.brightness.mouseChildren = true;
                this.brightness.mouseEnabled = true;
            }
            if (this.biterate != null)
            {
                this.biterate.mouseChildren = true;
                this.biterate.mouseEnabled = true;
            }
            return;
        }// end function

    }
}
