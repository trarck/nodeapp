package com.cntv.common.model.proxy
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.puremvc.model.*;

    public class GetCycleDataProxy extends XMLProxy
    {
        private var _locator:ModelLocator;
        public static const NAME:String = "GetCycleDataProxy";

        public function GetCycleDataProxy()
        {
            super(NAME);
            this._locator = ModelLocator.getInstance();
            return;
        }// end function

        public function load() : void
        {
            sendHttpRequest(this._locator.paramVO.hour24DataURL);
            return;
        }// end function

        override protected function throwDataException() : void
        {
            var _loc_1:* = new StatusVO(this._locator.i18n.ERROR_VIDEO_DATA_FORMAT_ERROR, StatuBoxEvent.TYPE_CENTER, true);
            GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_1));
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            var _loc_2:* = new StatusVO(this._locator.i18n.ERROR_VIDEO_DATA_FORMAT_ERROR, StatuBoxEvent.TYPE_CENTER, true);
            GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            return;
        }// end function

        override protected function loadCompleted(param1:XML) : void
        {
            this._locator.cycleList = [];
            var _loc_2:int = 0;
            while (_loc_2 < param1.child("programs").children().length())
            {
                
                if (param1.child("programs").children()[_loc_2].@type == "http")
                {
                    this._locator.cycleList.push(new HttpVideoInfoVO(null).setVideoXMLInfo(param1.child("programs").children()[_loc_2]));
                }
                else
                {
                    this._locator.cycleList.push(new VodVideoInfoVO(null).setVideoXMLInfo(param1.child("programs").children()[_loc_2]));
                }
                _loc_2++;
            }
            sendNotification(ApplicationFacade.NOTI_START_PLAY);
            return;
        }// end function

    }
}
