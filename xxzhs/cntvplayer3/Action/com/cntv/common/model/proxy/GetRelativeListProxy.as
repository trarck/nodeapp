package com.cntv.common.model.proxy
{
    import com.cntv.common.model.*;
    import com.cntv.common.model.parser.*;
    import com.cntv.player.playerCom.relativeList.event.*;
    import com.puremvc.model.*;

    public class GetRelativeListProxy extends XMLProxy
    {

        public function GetRelativeListProxy()
        {
            sendHttpRequest(ModelLocator.getInstance().paramVO.relativeListUrl);
            return;
        }// end function

        override protected function throwDataException() : void
        {
            GlobalDispatcher.getInstance().dispatchEvent(new RelativeEvent(RelativeEvent.EVENT_GET_LIST_DATA_ERROR));
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            GlobalDispatcher.getInstance().dispatchEvent(new RelativeEvent(RelativeEvent.EVENT_GET_LIST_DATA_ERROR));
            return;
        }// end function

        override protected function loadCompleted(param1:XML) : void
        {
            RelativeListParser.parse(param1);
            GlobalDispatcher.getInstance().dispatchEvent(new RelativeEvent(RelativeEvent.EVENT_GET_LIST_DATA));
            return;
        }// end function

    }
}
