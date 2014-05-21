package com.cntv.player.widgets
{
    import caurina.transitions.*;
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.proxy.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.common.tools.string.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.floatLayer.event.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.relativeList.*;
    import com.cntv.player.playerCom.relativeList.event.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.playerCom.video.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.cntv.player.widgets.events.*;
    import com.cntv.player.widgets.views.replayButton.*;
    import com.cntv.player.widgets.views.share.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class WidgetView extends CommonSprite
    {
        private const HIDE_TIME:Number = 5;
        private const POPUP_TYPE_HOTMAP:String = "pop.hotmap";
        private const POPUP_TYPE_SHARE:String = "pop.share";
        private var nowPopType:String = "";
        private var popWindow:PopUpWindowBG;
        private var tempMode:Boolean = false;
        private var tempType:String = "";
        private var swf:SWFLoader;
        private var hasAFADOver:Boolean = false;
        private const VIDEO_PLAY_OVER_JS_FUNC:String = "video_play_over";
        private var lc:LocalConnection;
        private var adPlayer:DisplayObject;
        private var replayButton:ReplayButton;
        private var modeWindowCover:CommonMask;
        private var popUpView:Sprite;
        private var relativeModule:RelativeModule;
        private var hideTimer:Timer;

        public function WidgetView(param1:Sprite)
        {
            this.popUpView = param1;
            this.initListener();
            return;
        }// end function

        override protected function init() : void
        {
            super.init();
            if (ModelLocator.getInstance().paramVO.widgetsSwfPath != "" && ModelLocator.getInstance().paramVO.widgetsXmlPath != "")
            {
                new SWFLoader(new URLRequest(ModelLocator.getInstance().paramVO.widgetsSwfPath + "?t=" + Math.random()), this.getSwf, this.getSwfErr);
            }
            return;
        }// end function

        private function getSwf(param1:DisplayObject) : void
        {
            this.swf = param1 as SWFLoader;
            this.swf.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadComplete);
            this.swf.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);
            return;
        }// end function

        private function getSwfErr(param1:String) : void
        {
            return;
        }// end function

        private function loadComplete(event:Event) : void
        {
            this.addChild(this.swf);
            this.swf.content.addEventListener("WidgetShareClick", this.onShareClick);
            this.swf.content.addEventListener("WidgetSmallWindowClick", this.onWindowClick);
            this.swf.content.dispatchEvent(new CommonEvent("showWidget", ModelLocator.getInstance().paramVO.widgetsXmlPath));
            return;
        }// end function

        private function loadError(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function onShareClick(event:Event) : void
        {
            _dispatcher.dispatchEvent(new FLayerEvent(FLayerEvent.EVENT_SHOW_PANEL, "share"));
            return;
        }// end function

        private function onWindowClick(event:Event) : void
        {
            this.onSmallWindow();
            return;
        }// end function

        private function onSmallWindow(event:WidgetsEvent = null) : void
        {
            var _loc_2:String = null;
            var _loc_3:StatusVO = null;
            if (ExternalInterface.available && !VideoBase.isMiniWindowLive)
            {
                if (!_modelLocator.paramVO.canPopWindow)
                {
                    _loc_3 = new StatusVO("您使用的浏览器弹窗功能。", StatuBoxEvent.TYPE_CENTER, true);
                    return;
                }
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SMALL_WINDOW_CLICK));
                _loc_2 = _modelLocator.paramVO.smallWindowUrl + "?pid=" + _modelLocator.paramVO.videoCenterId + "&time=" + _modelLocator.currentTime;
                NativeToURLTool.openASmallWindow(_loc_2);
            }
            return;
        }// end function

        private function addPlayOverStage(param1:int) : void
        {
            this.addOverStageComs(2);
            if (ExternalInterface.available && _modelLocator.ISWEBSITE)
            {
                ExternalInterface.call(this.VIDEO_PLAY_OVER_JS_FUNC);
            }
            return;
        }// end function

        private function initListener() : void
        {
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_PLAY_STOP, this.playOver);
            _dispatcher.addEventListener(CRiPanel.EVENT_REPLAY, this.onRiPanelClick);
            _dispatcher.addEventListener(ControlBarEvent.EVENT_HIDE_REPLAY, this.hideReplay);
            return;
        }// end function

        private function playOver(event:VideoPlayEvent) : void
        {
            if (_modelLocator.adVosAF == null && _modelLocator.paramVO.adAfter != "")
            {
                _dispatcher.addEventListener(ADEvent.EVENT_GET_AF_AD_DATA, this.getAFAdData);
                new GetADDataProxy(GetADDataProxy.TYPE_AF);
            }
            else
            {
                this.doAfterPlay(1);
            }
            return;
        }// end function

        private function getAFAdData(event:ADEvent) : void
        {
            _dispatcher.removeEventListener(ADEvent.EVENT_GET_AF_AD_DATA, this.getAFAdData);
            this.doAfterPlay(2);
            return;
        }// end function

        private function doAfterPlay(param1:int) : void
        {
            var statu:* = param1;
            try
            {
                if (_modelLocator.adVosAF.length > 0 && _modelLocator.adVosAF[0]["url"] != "null")
                {
                    this.hasAFADOver = false;
                    this.lc = new LocalConnection();
                    this.lc.allowDomain("*");
                    this.lc.client = this;
                    try
                    {
                        this.lc.connect("_cntvPlayer");
                    }
                    catch (e:AsyncErrorEvent)
                    {
                        ;
                    }
                    catch (e:ArgumentError)
                    {
                    }
                    new SWFLoader(new URLRequest(_modelLocator.paramVO.adplayerPath), this.getADPlayer, this.getADPlayerError);
                }
                else
                {
                    this.addPlayOverStage(1);
                }
            }
            catch (e:Error)
            {
                addPlayOverStage(2);
            }
            return;
        }// end function

        private function getADPlayer(param1:DisplayObject) : void
        {
            this.adPlayer = param1;
            stage.addChild(this.adPlayer);
            this.lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.lcAsynError);
            this.lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.lcSecurityError);
            this.lc.addEventListener(StatusEvent.STATUS, this.lcStatu);
            this.lc.send("_adPlayer", "playADArr", _modelLocator.adVosAF);
            return;
        }// end function

        private function getADPlayerError(param1:String) : void
        {
            this.addPlayOverStage(3);
            return;
        }// end function

        private function lcAsynError(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function lcSecurityError(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

        private function lcStatu(event:StatusEvent) : void
        {
            return;
        }// end function

        private function addOverStageComs(param1:int) : void
        {
            if (_modelLocator.paramVO.autoRePlay)
            {
                this.closePopupWindow(null);
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_REPLAY));
                return;
            }
            this.modeWindowCover = new CommonMask(stage.stageWidth, stage.stageHeight, 0, 0.8, CommonMask.TYPE_S);
            this.popUpView.addChild(this.modeWindowCover);
            if (_modelLocator.ISWEBSITE && !_modelLocator.paramVO.showRelative || _modelLocator.paramVO.relativeListUrl == "")
            {
                this.replayButton = new ReplayButton();
                this.replayButton.x = (stage.stageWidth - this.replayButton.width) / 2;
                this.replayButton.y = (stage.stageHeight - this.replayButton.height) / 2;
                this.replayButton.addEventListener(MouseEvent.CLICK, this.doReplayHandler);
                this.popUpView.addChild(this.replayButton);
            }
            else if (this.relativeModule == null)
            {
                this.relativeModule = new RelativeModule();
                this.relativeModule.addEventListener(RelativeEvent.EVENT_DO_REPLAY, this.outSideReplayHandler);
                this.relativeModule.addEventListener(RelativeEvent.EVENT_GET_DATA_FAIL, this.changeEndStage);
                this.popUpView.addChild(this.relativeModule);
            }
            else
            {
                this.popUpView.addChild(this.relativeModule);
                this.relativeModule.doAdjust();
            }
            return;
        }// end function

        private function closePopupWindow(event:CommonEvent) : void
        {
            this.tempType = "";
            this.tempMode = false;
            if (this.modeWindowCover != null && this.popUpView.contains(this.modeWindowCover))
            {
                this.popUpView.removeChild(this.modeWindowCover);
                this.modeWindowCover = null;
            }
            this.hideAPopupWindow();
            return;
        }// end function

        private function hideAPopupWindow() : void
        {
            Tweener.removeTweens(this.popWindow);
            Tweener.addTween(this.popWindow, {time:0.5, x:stage.stageWidth / 2, y:stage.stageHeight, scaleX:0.3, scaleY:0.3, alpha:0, onComplete:this.afterHidePop});
            return;
        }// end function

        private function doReplayHandler(event:MouseEvent) : void
        {
            this.hideReplay();
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.REPLAY_CLICK));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_REPLAY));
            return;
        }// end function

        private function outSideReplayHandler(event:RelativeEvent) : void
        {
            if (this.relativeModule)
            {
                this.popUpView.removeChild(this.relativeModule);
            }
            this.closePopupWindow(null);
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_REPLAY));
            return;
        }// end function

        private function changeEndStage(event:RelativeEvent) : void
        {
            this.popUpView.removeChild(this.relativeModule);
            this.replayButton = new ReplayButton();
            this.replayButton.x = (stage.stageWidth - this.replayButton.width) / 2;
            this.replayButton.y = (stage.stageHeight - this.replayButton.height) / 2;
            this.replayButton.addEventListener(MouseEvent.CLICK, this.doReplayHandler);
            this.popUpView.addChild(this.replayButton);
            return;
        }// end function

        private function afterHidePop() : void
        {
            this.popUpView.removeChild(this.popWindow);
            this.popWindow = null;
            if (this.modeWindowCover != null)
            {
                this.popUpView.removeChild(this.modeWindowCover);
                this.modeWindowCover = null;
            }
            if (this.replayButton != null)
            {
                this.popUpView.removeChild(this.replayButton);
                this.replayButton = null;
            }
            this.showAPopupWindow(this.tempType, this.tempMode);
            return;
        }// end function

        private function hideReplay(event:ControlBarEvent = null) : void
        {
            if (this.replayButton)
            {
                this.popUpView.removeChild(this.replayButton);
                this.replayButton.removeEventListener(MouseEvent.CLICK, this.doReplayHandler);
                this.replayButton = null;
                this.closePopupWindow(null);
            }
            return;
        }// end function

        private function showAPopupWindow(param1:String, param2:Boolean = false) : void
        {
            if (this.popWindow != null && this.nowPopType != param1)
            {
                this.hideAPopupWindow();
                this.tempType = param1;
                this.tempMode = param2;
            }
            else
            {
                if (this.nowPopType == param1)
                {
                    return;
                }
                this.nowPopType = param1;
                switch(this.nowPopType)
                {
                    case this.POPUP_TYPE_SHARE:
                    {
                        this.popWindow = new SharePanel();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (param2)
                {
                    this.addOverStageComs(1);
                }
                else if (this.popWindow != null)
                {
                    this.popWindow.x = stage.stageWidth / 2;
                    this.popWindow.y = stage.stageHeight;
                    this.popUpView.addChild(this.popWindow);
                    this.popUpView.addEventListener(PopUpWindowBG.EVENT_POPUP_CLOSE, this.closePopupWindow);
                    Tweener.removeTweens(this.popWindow);
                    if (this.nowPopType == this.POPUP_TYPE_HOTMAP)
                    {
                        Tweener.addTween(this.popWindow, {time:0.5, x:(stage.stageWidth - this.popWindow.width) / 2, y:stage.stageHeight - this.popWindow.height - 30, scaleX:1, scaleY:1, alpha:1});
                    }
                    else
                    {
                        Tweener.addTween(this.popWindow, {time:0.5, x:(stage.stageWidth - this.popWindow.width) / 2, y:(stage.stageHeight - this.popWindow.height) / 2, scaleX:1, scaleY:1, alpha:1});
                    }
                }
            }
            return;
        }// end function

        override protected function adjust() : void
        {
            if (this.popWindow != null)
            {
                if (this.nowPopType != this.POPUP_TYPE_HOTMAP)
                {
                    this.popWindow.x = (stage.stageWidth - this.popWindow.width) / 2;
                    this.popWindow.y = (stage.stageHeight - this.popWindow.height) / 2;
                }
                else
                {
                    this.popWindow.x = (stage.stageWidth - this.popWindow.width) / 2;
                    this.popWindow.y = stage.stageHeight - this.popWindow.height - 30;
                }
            }
            if (this.replayButton != null)
            {
                this.replayButton.x = (stage.stageWidth - this.replayButton.width) / 2;
                this.replayButton.y = (stage.stageHeight - this.replayButton.height) / 2;
            }
            if (this.relativeModule != null)
            {
                this.relativeModule.x = (stage.stageWidth - this.relativeModule.width) / 2;
                this.relativeModule.y = (stage.stageHeight - this.relativeModule.height) / 2;
            }
            if (this.modeWindowCover != null)
            {
                this.modeWindowCover.width = stage.stageWidth;
                this.modeWindowCover.height = stage.stageHeight;
            }
            return;
        }// end function

        private function jsToFlashWideScreen(param1:Boolean) : void
        {
            if (param1)
            {
                _modelLocator.isInScreenSwitch = true;
                _modelLocator.wideMode = _modelLocator.WIDE_SCREEN;
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_SCREEN_WIDE));
            }
            else
            {
                _modelLocator.isInScreenSwitch = true;
                _modelLocator.wideMode = _modelLocator.NORMAL_SCREEN;
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_SCREEN_NORMAL));
            }
            return;
        }// end function

        private function showRankingPanel(event:WidgetsEvent) : void
        {
            if (_modelLocator.isActionWidgets)
            {
                NativeToURLTool.openAURL(_modelLocator.configVO.rankingListURL);
            }
            return;
        }// end function

        private function collectHandler(event:WidgetsEvent) : void
        {
            var _loc_2:StatusVO = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            if (ExternalInterface.available && _modelLocator.ISWEBSITE && _modelLocator.isActionWidgets)
            {
                _loc_3 = "cntv视频";
                _loc_4 = "http://www.cntv.cn/";
                if (_modelLocator.currentVideoInfo.title != null)
                {
                    _loc_3 = _modelLocator.currentVideoInfo.title;
                }
                if (_modelLocator.currentVideoInfo.refURL != null)
                {
                    _loc_4 = StringUtils.trim(_modelLocator.currentVideoInfo.refURL);
                }
                _loc_5 = ExternalInterface.call("addBookmark", _loc_3, _loc_4);
                if (_loc_5 == "false")
                {
                    _loc_2 = new StatusVO("您使用的浏览器不支持加入收藏夹功能。", StatuBoxEvent.TYPE_CENTER, true);
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
                }
            }
            return;
        }// end function

        private function suggestionHandler(event:WidgetsEvent) : void
        {
            if (_modelLocator.isActionWidgets)
            {
                NativeToURLTool.openAURL(_modelLocator.configVO.suggestionURL);
            }
            return;
        }// end function

        private function speedUpHandler(event:WidgetsEvent) : void
        {
            if (_modelLocator.isActionWidgets)
            {
                NativeToURLTool.openAURL(_modelLocator.paramVO.speedUperPath, "_blank", true);
            }
            return;
        }// end function

        private function shareHandler(event:WidgetsEvent) : void
        {
            if (_modelLocator.isActionWidgets)
            {
                this.showAPopupWindow(this.POPUP_TYPE_SHARE);
            }
            return;
        }// end function

        public function adPlayOver(param1:String) : void
        {
            if (!this.hasAFADOver)
            {
                this.hasAFADOver = true;
                Tweener.addTween(this.adPlayer, {time:1, y:-stage.stageHeight, onComplete:this.afterADClose});
                this.addPlayOverStage(4);
            }
            return;
        }// end function

        public function afterADClose() : void
        {
            stage.removeChild(this.adPlayer);
            this.lc.close();
            this.lc = null;
            this.adPlayer = null;
            System.gc();
            return;
        }// end function

        public function setDiggAnimation(param1:String) : void
        {
            return;
        }// end function

        private function onRiPanelClick(event:CommonEvent) : void
        {
            if (this.relativeModule && this.popUpView.contains(this.relativeModule))
            {
                this.popUpView.removeChild(this.relativeModule);
            }
            this.closePopupWindow(null);
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_REPLAY));
            return;
        }// end function

    }
}
