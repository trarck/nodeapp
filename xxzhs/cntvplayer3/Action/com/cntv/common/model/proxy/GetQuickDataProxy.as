package com.cntv.common.model.proxy
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.puremvc.model.*;

    public class GetQuickDataProxy extends HttpProxy
    {
        private var _localtor:ModelLocator;
        public static const NAME:String = "GetQuickDataProxy";

        public function GetQuickDataProxy()
        {
            super(NAME);
            this._localtor = ModelLocator.getInstance();
            return;
        }// end function

        public function load() : void
        {
            var _loc_1:* = ModelLocator.getInstance().paramVO.qkStyleServer + "?vpid=" + ModelLocator.getInstance().paramVO.videoCenterId;
            sendHttpRequest(_loc_1);
            return;
        }// end function

        override protected function loadCompleted(param1:Object) : void
        {
            var _loc_2:StatusVO = null;
            if (param1["ack"] == "yes")
            {
                ModelLocator.getInstance().paramVO.qkStartTime = param1["starttime"];
                ModelLocator.getInstance().paramVO.qkEndTime = param1["endtime"];
                ModelLocator.getInstance().paramVO.qkChannel = param1["channel"];
                if (param1["state"] == "vod")
                {
                    ModelLocator.getInstance().paramVO.videoCenterId = param1["pid"];
                    ModelLocator.getInstance().paramVO.playMode = "vod";
                }
                else if (param1["state"] == "back")
                {
                    ModelLocator.getInstance().paramVO.playMode = "back";
                }
                else if (param1["state"] == "live")
                {
                    ModelLocator.getInstance().paramVO.playMode = "live";
                }
                sendNotification(ApplicationFacade.NOTI_START_BEFORE_ADS);
            }
            else
            {
                _loc_2 = new StatusVO(this._localtor.i18n.ERROR_CAN_NOT_GET_VIDEO_DATA, StatuBoxEvent.TYPE_CENTER, true);
                GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            }
            return;
        }// end function

        override protected function throwDataException() : void
        {
            var _loc_1:* = new StatusVO(this._localtor.i18n.ERROR_CAN_NOT_GET_VIDEO_DATA, StatuBoxEvent.TYPE_CENTER, true);
            GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_1));
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            var _loc_2:* = new StatusVO(this._localtor.i18n.ERROR_CAN_NOT_GET_VIDEO_DATA, StatuBoxEvent.TYPE_CENTER, true);
            GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            return;
        }// end function

    }
}
