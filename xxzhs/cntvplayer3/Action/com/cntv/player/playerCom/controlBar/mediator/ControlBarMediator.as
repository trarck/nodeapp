package com.cntv.player.playerCom.controlBar.mediator
{
    import com.cntv.common.model.*;
    import com.cntv.player.playerCom.controlBar.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.puremvc.view.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class ControlBarMediator extends CommonMediator
    {
        private var _dispatcher:GlobalDispatcher;
        private var _facade:ControlBarFacade;
        public static const NAME:String = "ControlBarMediator";

        public function ControlBarMediator(param1:Object)
        {
            super(NAME);
            viewComponent = param1;
            this._dispatcher = GlobalDispatcher.getInstance();
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_VIDEO_PLAYED, this.showVideoPlayed);
            this._dispatcher.addEventListener(VideoPlayEvent.EVENT_VIDEO_LOADED, this.showVideoLoaded);
            this._dispatcher.addEventListener(ControlBarEvent.EVENT_VIDEO_PLAY, this.playHandler);
            this._dispatcher.addEventListener(ControlBarEvent.EVENT_VIDEO_PAUSE, this.pauseHandler);
            this._facade = ControlBarFacade.getInstance(ControlBarModule.NAME);
            this.initListener();
            return;
        }// end function

        public function initListener() : void
        {
            this.app.addEventListener(ControlBarEvent.EVENT_VIDEO_PLAY, this.playButtonHandler);
            this.app.addEventListener(ControlBarEvent.EVENT_VIDEO_PAUSE, this.pauseButtonHandler);
            return;
        }// end function

        public function get app() : ControlBarModule
        {
            return viewComponent as ControlBarModule;
        }// end function

        private function showVideoPlayed(event:VideoPlayEvent) : void
        {
            this.app.setPlayed(Number(event.data));
            return;
        }// end function

        private function showVideoLoaded(event:VideoPlayEvent) : void
        {
            this.app.setLoaded(Number(event.data));
            return;
        }// end function

        private function playButtonHandler(event:ControlBarEvent) : void
        {
            this._dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PLAY));
            return;
        }// end function

        private function pauseButtonHandler(event:ControlBarEvent) : void
        {
            this._dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PAUSE));
            return;
        }// end function

        private function playHandler(event:ControlBarEvent) : void
        {
            this.app.isPlaying = true;
            return;
        }// end function

        private function pauseHandler(event:ControlBarEvent) : void
        {
            this.app.isPlaying = false;
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            switch(param1.getName())
            {
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
