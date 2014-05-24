package com.cntv.player.playerCom.statuBox
{
    import caurina.transitions.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.memory.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.common.view.ui.loadingView.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.playerCom.statuBox.view.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.cntv.player.widgets.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class StatuBoxView extends CommonSprite
    {
        private var flip:FlipPanel;
        private var flipCenter:FLipCenterPanel;
        private var notice:NoticePanel;
        private var bufferIcon:BufferView;
        private var loadingIcon:LoadingView;
        private var fps:FPSViewer;
        private var title:titleBar;
        private var autoHideTimer:Timer;
        private var autoHideCenterTimer:Timer;
        private var bg:CommonMask;
        private var p2pNotice:P2PDownloadNoticePanel;
        private var canShowP2p:Boolean = false;
        private var closeP2PTimer:uint;
        private var p1:Number;
        private var p2:Number;
        private var t0:Number;
        private var t1:Number;
        private var t2:Number;
        private var bufferPCount:int = 0;
        private var _popView:Sprite;
        private var bufferFlag:Boolean = false;
        public static const HIDE_COUNT:int = 3;

        public function StatuBoxView()
        {
            this.autoHideTimer = new Timer(HIDE_COUNT * 1000, 1);
            this.autoHideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.hideFilp);
            this.autoHideCenterTimer = new Timer(HIDE_COUNT * 1000, 1);
            this.autoHideCenterTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.hideCenter);
            this.flip = new FlipPanel();
            this.addChild(this.flip);
            this.notice = new NoticePanel();
            this.addChild(this.notice);
            this.flipCenter = new FLipCenterPanel();
            this.flipCenter.visible = false;
            this.addChild(this.flipCenter);
            this.bufferIcon = new BufferView();
            this.bufferIcon.visible = false;
            this.bufferIcon.x = 0;
            this.bufferIcon.y = 0;
            this.addChild(this.bufferIcon);
            this.title = new titleBar();
            this.title.y = -25;
            this.addChild(this.title);
            if (_modelLocator.debugMode)
            {
                this.fps = new FPSViewer();
                this.addChild(this.fps);
            }
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_SHOW_NOTICE_MESSAGE, this.showNotice);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_SHOW_MESSAGE, this.showMesage);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_HIDE_MESSAGE, this.hideMesage);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_SHOW_LOADING, this.showLoading);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_HIDE_LOADING, this.hideLoading);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_SHOW_BUFFER, this.showBuffer);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_HIDE_BUFFER, this.hideBuffer);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_BUFFER_READY, this.bufferReady);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_SHOW_TITLE_BAR, this.onTitleShow);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_HIDE_TITLE_BAR, this.onTitleHide);
            _dispatcher.addEventListener(StatuBoxEvent.EVENT_SHOW_RELATIVE, this.onShowRelative);
            if (!_modelLocator.paramVO.isP2pInstall && _modelLocator.isP2PNotice)
            {
            }
            return;
        }// end function

        private function onTitleShow(event:StatuBoxEvent) : void
        {
            if (_modelLocator.paramVO.showTitle && this.title)
            {
                this.title.show(true);
                Tweener.addTween(this.title, {y:0, time:0.5});
            }
            return;
        }// end function

        private function onTitleHide(event:StatuBoxEvent) : void
        {
            if (_modelLocator.paramVO.showTitle && this.title)
            {
                this.title.show(false);
                Tweener.addTween(this.title, {y:-this.title.H, time:0.5});
            }
            return;
        }// end function

        private function bufferReady(event:StatuBoxEvent) : void
        {
            this.bufferPCount = 0;
            this.bufferFlag = false;
            return;
        }// end function

        private function onFullChange(event:Event) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            super.init();
            stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.onFullChange);
            return;
        }// end function

        override protected function adjust() : void
        {
            if (this.bufferIcon != null)
            {
                this.bufferIcon.x = (stage.stageWidth - this.bufferIcon.width) / 2;
                this.bufferIcon.y = (stage.stageHeight - this.bufferIcon.height) / 2;
            }
            if (this.loadingIcon != null)
            {
                this.loadingIcon.x = (stage.stageWidth - this.loadingIcon.width) / 2;
                this.loadingIcon.y = (stage.stageHeight - this.loadingIcon.height) / 2;
            }
            if (this.p2pNotice != null)
            {
                this.p2pNotice.x = stage.stageWidth - P2PDownloadNoticePanel.W - 85;
                this.p2pNotice.y = stage.stageHeight - P2PDownloadNoticePanel.H - 35;
            }
            if (this.notice != null)
            {
                this.notice.y = stage.stageHeight - this.notice.height - 35;
            }
            if (stage.displayState == StageDisplayState.NORMAL)
            {
                if (this.title)
                {
                    this.title.show(false);
                }
            }
            return;
        }// end function

        public function showMesage(event:StatuBoxEvent) : void
        {
            this.hideLoading(null);
            this.hideBuffer(null);
            var _loc_2:* = StatusVO(event.data);
            if (_loc_2.type == StatuBoxEvent.TYPE_FLIP)
            {
                this.autoHideTimer.stop();
                this.autoHideTimer.reset();
                this.flip.showAMsg(_loc_2.msg);
                if (_loc_2.isAutoHide)
                {
                    this.autoHideTimer.start();
                }
            }
            else if (_loc_2.type == StatuBoxEvent.TYPE_CENTER)
            {
                this.autoHideCenterTimer.stop();
                this.autoHideCenterTimer.reset();
                this.flipCenter.visible = true;
                this.flipCenter.showAMsg(_loc_2.msg);
                if (_loc_2.isAutoHide)
                {
                    this.autoHideCenterTimer.start();
                }
            }
            stage.addChild(this);
            return;
        }// end function

        public function showNotice(event:StatuBoxEvent) : void
        {
            var e:* = event;
            var statuVO:* = StatusVO(e.data);
            this.hideLoading(null);
            this.hideBuffer(null);
            this.autoHideTimer.stop();
            this.autoHideTimer.reset();
            this.notice.showAMsg(statuVO.msg);
            setTimeout(function () : void
            {
                notice.hidePanel(false);
                return;
            }// end function
            , 15000);
            this.notice.y = stage.stageHeight - this.notice.height - 35;
            return;
        }// end function

        private function onShowRelative(event:StatuBoxEvent) : void
        {
            if (_modelLocator.paramVO.relativeListUrl == "")
            {
                _modelLocator.paramVO.relativeListUrl = "http://js.player.cntv.cn/xml/relative/Default.xml";
                _modelLocator.paramVO.showRelative = true;
            }
            this._popView = new Sprite();
            stage.addChild(this._popView);
            var _loc_2:* = new WidgetView(this._popView);
            stage.addChild(_loc_2);
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PLAY_STOP));
            return;
        }// end function

        public function showLoading(event:StatuBoxEvent) : void
        {
            this.hideBuffer(null);
            if (this.loadingIcon == null)
            {
                this.loadingIcon = new LoadingView();
                this.addChild(this.loadingIcon);
            }
            this.adjust();
            return;
        }// end function

        public function hideLoading(event:StatuBoxEvent) : void
        {
            if (this.loadingIcon != null && this.contains(this.loadingIcon))
            {
                this.removeChild(this.loadingIcon);
                this.loadingIcon = null;
            }
            return;
        }// end function

        public function showBuffer(event:StatuBoxEvent) : void
        {
            var _loc_2:* = event.data as Array;
            var _loc_3:* = _loc_2[0];
            this.hideLoading(null);
            if (this.bufferPCount == 0)
            {
                this.t1 = getTimer();
                this.bufferPCount = 1;
                this.bufferFlag = false;
            }
            else if (this.bufferFlag)
            {
                this.bufferIcon.visible = true;
                this.adjust();
                if (_loc_3 >= 100)
                {
                    this.hideBuffer(null);
                    this.bufferPCount = 0;
                    this.bufferFlag = false;
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_RESET_BUFFER_FLAG));
                    MemClean.run();
                }
                else
                {
                    this.bufferIcon.setPercent(_loc_3);
                    this.bufferIcon.showNotice(_loc_2[1]);
                }
            }
            else
            {
                this.bufferPCount = 1;
                if (getTimer() - this.t1 > 1500)
                {
                    this.bufferFlag = true;
                }
            }
            return;
        }// end function

        public function hideBuffer(event:StatuBoxEvent) : void
        {
            if (this.bufferIcon != null && this.contains(this.bufferIcon) && this.bufferIcon.visible)
            {
                this.bufferIcon.visible = false;
                this.bufferIcon.x = 0;
                this.bufferIcon.y = 0;
                if (event == null || event != null && event["data"] == "full")
                {
                    this.bufferPCount = 0;
                    this.bufferFlag = false;
                }
            }
            return;
        }// end function

        private function hideMesage(event:StatuBoxEvent) : void
        {
            this.flip.hidePanel(false);
            return;
        }// end function

        private function hideFilp(event:TimerEvent) : void
        {
            this.flip.hidePanel(false);
            return;
        }// end function

        private function hideCenter(event:TimerEvent) : void
        {
            this.flipCenter.hidePanel(false);
            return;
        }// end function

        private function showP2PNotice(event:StatuBoxEvent) : void
        {
            this.p2pNotice = new P2PDownloadNoticePanel();
            this.addChild(this.p2pNotice);
            this.p2pNotice.x = stage.stageWidth - P2PDownloadNoticePanel.W - 85;
            this.p2pNotice.y = stage.stageHeight - P2PDownloadNoticePanel.H - 35;
            return;
        }// end function

        private function closeP2PNotice(event:StatuBoxEvent) : void
        {
            this.removeChild(this.p2pNotice);
            this.p2pNotice = null;
            return;
        }// end function

    }
}
