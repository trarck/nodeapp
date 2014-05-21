package com.cntv.player.playerCom.controlBar
{
    import com.cntv.player.playerCom.controlBar.mediator.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.puremvc.*;

    public class ControlBarFacade extends CommonFacade
    {
        public static const STARTUP:String = "startup";
        public static const NOTI_SEND_VIDEO_PLAY:String = "noti.send.video.play";
        public static const NOTI_SEND_VIDEO_PAUSE:String = "noti.send.video.pause";
        public static const NOTI_SET_VIDEO_PLAY:String = "noti.set.video.play";
        public static const NOTI_SET_VIDEO_PAUSE:String = "noti.set.video.pause";

        public function ControlBarFacade(param1:String)
        {
            super(param1);
            return;
        }// end function

        override protected function initializeController() : void
        {
            return;
        }// end function

        public function startUp(param1:ControlBarModule) : void
        {
            registerMediator(new ControlBarMediator(param1));
            return;
        }// end function

        public static function getInstance(param1:String) : ControlBarFacade
        {
            if (instanceMap[param1] == null)
            {
                instanceMap[param1] = new ControlBarFacade(param1);
            }
            return instanceMap[param1] as ControlBarFacade;
        }// end function

    }
}
