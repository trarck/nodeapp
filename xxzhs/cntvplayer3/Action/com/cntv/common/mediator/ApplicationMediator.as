package com.cntv.common.mediator
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.player.playerCom.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.cntv.player.playerCom.controlBar.view.hotDot.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.cntv.player.widgets.*;
    import com.puremvc.view.*;
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.external.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class ApplicationMediator extends CommonMediator
    {
        public var playerView:PlayerModule;
        public var controlBar:ControlBarModule;
        public var widgetView:WidgetView;
        public var popUpView:Sprite;
        public var _dispatcher:GlobalDispatcher;
        public var _locator:ModelLocator;
        private var isPlayedBFAD:Boolean = false;
        private var bfADPlayer:BeforePlayerADMoudle;
        public static const NAME:String = "ApplicationMediator";

        public function ApplicationMediator(param1:Object)
        {
            super(NAME);
            viewComponent = param1;
            this.popUpView = new Sprite();
            this._dispatcher = GlobalDispatcher.getInstance();
            this._locator = ModelLocator.getInstance();
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_CYCLE_PLAY_OVER, this.loadDataAgain);
            this._dispatcher.addEventListener(ApplicationFacade.EVENT_LOAD_AD, this.loadADData);
            this._dispatcher.addEventListener(ApplicationFacade.NOTI_AFTER_BEFORE_ADS, this.getVideoInfo);
            this._dispatcher.addEventListener(HotDot.EVENT_CAHNGE_VIDEO, this.onChangeVideoByHotdot);
            if (ExternalInterface.available && ModelLocator.getInstance().ISWEBSITE)
            {
                try
                {
                    ExternalInterface.addCallback("changeVideoByID", this.changeVideoByID);
                    ExternalInterface.addCallback("changeVideoByCenterID", this.changeVideoByCenterID);
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        public function get app() : Main
        {
            return Main(viewComponent);
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.NOTI_START_PLAY, ApplicationFacade.NOTI_GET_VIDEOINFO, ApplicationFacade.NOTI_GET_VIDEOHOTDOT, ApplicationFacade.NOTI_GET_INTERACTIVEINFO_COMPLETE, ApplicationFacade.NOTI_REGET_VIDEOINFO, ApplicationFacade.NOTI_GET_LANGUAGE, ApplicationFacade.NOTI_GET_AD, ApplicationFacade.NOTI_START_BEFORE_ADS, ApplicationFacade.NOTI_GET_QUICK_DATA];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            switch(param1.getName())
            {
                case ApplicationFacade.NOTI_START_BEFORE_ADS:
                {
                    if (ModelLocator.getInstance().paramVO.playMode == "live")
                    {
                        this._dispatcher.dispatchEvent(new CommonEvent(ApplicationFacade.NOTI_AFTER_BEFORE_ADS));
                    }
                    else
                    {
                        this.addBFADPlayer();
                        sendNotification(ApplicationFacade.NOTI_LOAD_LANGUAGE);
                    }
                    break;
                }
                case ApplicationFacade.NOTI_GET_VIDEOINFO:
                {
                    break;
                }
                case ApplicationFacade.NOTI_GET_LANGUAGE:
                {
                    if (this.controlBar == null)
                    {
                        this.controlBar = new ControlBarModule(this.popUpView);
                        this.app.addChild(this.controlBar);
                        this.app.addChild(this.popUpView);
                    }
                    break;
                }
                case ApplicationFacade.NOTI_GET_AD:
                {
                    break;
                }
                case ApplicationFacade.NOTI_START_PLAY:
                {
                    if (this.widgetView == null)
                    {
                        if (ModelLocator.getInstance().paramVO.isCycle)
                        {
                            ModelLocator.getInstance().currentVideoInfo = new VideoInfoVo();
                        }
                        this.widgetView = new WidgetView(this.popUpView);
                        this.app.addChild(this.widgetView);
                    }
                    this.addPlayerCore();
                    break;
                }
                case ApplicationFacade.NOTI_GET_INTERACTIVEINFO_COMPLETE:
                {
                    this.app.addChild(this.popUpView);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function loadDataAgain(event:VideoPlayEvent) : void
        {
            sendNotification(ApplicationFacade.NOTI_GET_VIDEOINFO);
            this._locator.cycleIndex = 0;
            return;
        }// end function

        private function loadADData(event:CommonEvent) : void
        {
            sendNotification(ApplicationFacade.NOTI_LOAD_AD);
            return;
        }// end function

        private function onChangeVideoByHotdot(event:CommonEvent) : void
        {
            this._locator.paramVO.videoCenterId = this._locator.paramVO.matchData.options[0].pid;
            sendNotification(ApplicationFacade.NOTI_GET_VIDEOINFO);
            return;
        }// end function

        private function changeVideoByCenterID(param1:String) : void
        {
            this._dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_HIDE_REPLAY));
            this._locator.paramVO.videoCenterId = param1;
            sendNotification(ApplicationFacade.NOTI_GET_VIDEOINFO);
            return;
        }// end function

        private function changeVideoByID(param1:String, param2:String, param3:String) : void
        {
            this._locator.configVO.videoInfoURL = param1;
            this._locator.paramVO.videoId = param2;
            this._locator.paramVO.filePath = param3;
            sendNotification(ApplicationFacade.NOTI_GET_VIDEOINFO);
            return;
        }// end function

        private function getVideoInfo(event:CommonEvent) : void
        {
            if (ModelLocator.getInstance().paramVO.playMode == "vod")
            {
                sendNotification(ApplicationFacade.NOTI_GET_VIDEOINFO);
            }
            else if (ModelLocator.getInstance().paramVO.playMode == "live" || ModelLocator.getInstance().paramVO.playMode == "back")
            {
                sendNotification(ApplicationFacade.NOTI_GET_LIVE_BACK);
            }
            return;
        }// end function

        private function addBFADPlayer() : void
        {
            this.bfADPlayer = new BeforePlayerADMoudle();
            this.app.addChild(this.bfADPlayer);
            return;
        }// end function

        private function addPlayerCore() : void
        {
            this.isPlayedBFAD = true;
            if (this.bfADPlayer != null && this.app.contains(this.bfADPlayer))
            {
                this.app.removeChild(this.bfADPlayer);
                this.bfADPlayer = null;
            }
            if (this.playerView != null && this.app.contains(this.playerView))
            {
                this.playerView.resetPlayer();
            }
            else
            {
                this.playerView = new PlayerModule();
            }
            this.app.addChildAt(this.playerView, 0);
            this.app.addChild(this.popUpView);
            return;
        }// end function

    }
}
