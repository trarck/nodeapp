package com.cntv.common.model.proxy
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.puremvc.model.*;

    public class GetInteractiveInfoProxy extends HttpProxy
    {
        public static const NAME:String = "GetInteractiveInfoProxy";

        public function GetInteractiveInfoProxy()
        {
            super(NAME);
            return;
        }// end function

        public function load() : void
        {
            var _loc_1:* = new Object();
            _loc_1[ModelLocator.getInstance().configVO.interactiveInfoParam1] = ModelLocator.getInstance().paramVO.videoId;
            _loc_1[ModelLocator.getInstance().configVO.interactiveInfoParam2] = ModelLocator.getInstance().paramVO.scheduleId;
            sendHttpRequest(ModelLocator.getInstance().configVO.interactiveInfoURL, _loc_1);
            return;
        }// end function

        override protected function throwDataException() : void
        {
            super.throwDataException();
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            return;
        }// end function

        override protected function loadCompleted(param1:Object) : void
        {
            super.loadCompleted(param1);
            ModelLocator.getInstance().currentVideoInfo.setInteractiveData(param1);
            sendNotification(ApplicationFacade.NOTI_GET_INTERACTIVEINFO_COMPLETE);
            return;
        }// end function

    }
}
