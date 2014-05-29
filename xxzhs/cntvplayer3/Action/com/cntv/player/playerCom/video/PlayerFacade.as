package com.cntv.player.playerCom.video
{
    import com.cntv.player.playerCom.*;
    import com.cntv.player.playerCom.video.mediator.*;
    import com.puremvc.*;

    public class PlayerFacade extends CommonFacade
    {
        public static const STARTUP:String = "startup";

        public function PlayerFacade(param1:String)
        {
            super(param1);
            return;
        }// end function

        override protected function initializeController() : void
        {
            return;
        }// end function

        public function startUp(param1:PlayerModule) : void
        {
            registerMediator(new PlayerMediator(param1));
            return;
        }// end function

        public static function getInstance(param1:String) : PlayerFacade
        {
            if (instanceMap[param1] == null)
            {
                instanceMap[param1] = new PlayerFacade(param1);
            }
            return instanceMap[param1] as PlayerFacade;
        }// end function

    }
}
