package com.cntv.common.controller
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.puremvc.controller.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class InitParamCommand extends CommonSimpleCommand
    {
        private var appFacade:ApplicationFacade;

        public function InitParamCommand()
        {
            this.appFacade = ApplicationFacade.getInstance(Main.NAME);
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_3:StatusVO = null;
            this.appFacade.removeCommand(ApplicationFacade.NOTI_INIT_PARAM);
            var _loc_2:* = param1.getBody() as Main;
            ModelLocator.getInstance().qm = new QualityMonitor();
            if (ModelLocator.getInstance().paramVO.videoId != null && ModelLocator.getInstance().paramVO.videoId != "")
            {
                this.appFacade.sendNotification(ApplicationFacade.NOTI_GET_CONFIG);
            }
            else
            {
                _loc_3 = new StatusVO(ModelLocator.getInstance().i18n.ERROR_CAN_NOT_GET_VIDEO_ID, StatuBoxEvent.TYPE_CENTER, false);
                GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_3));
            }
            ModelLocator.getInstance().recordManager = new RecordManager();
            return;
        }// end function

    }
}
