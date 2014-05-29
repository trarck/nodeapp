package com.cntv.common.model.proxy
{
    import com.cntv.common.model.*;
    import com.cntv.common.model.parser.*;
    import com.cntv.player.playerCom.relativeList.event.*;
    import com.puremvc.model.*;

    public class GetRelativeTitleProxy extends XMLProxy
    {

        public function GetRelativeTitleProxy()
        {
            if (!ModelLocator.getInstance().ISWEBSITE)
            {
                sendHttpRequest(ModelLocator.getInstance().paramVO.relativeListTitleUrl + "outsite.xml");
            }
            else
            {
                sendHttpRequest(ModelLocator.getInstance().paramVO.relativeListTitleUrl + ModelLocator.getInstance().paramVO.tai + ".xml");
            }
            return;
        }// end function

        override protected function throwDataException() : void
        {
            GlobalDispatcher.getInstance().dispatchEvent(new RelativeEvent(RelativeEvent.EVENT_GET_LIST_TITLE_ERROR));
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            GlobalDispatcher.getInstance().dispatchEvent(new RelativeEvent(RelativeEvent.EVENT_GET_LIST_TITLE_ERROR));
            return;
        }// end function

        override protected function loadCompleted(param1:XML) : void
        {
            RelativeListParser.parse(param1, true);
            GlobalDispatcher.getInstance().dispatchEvent(new RelativeEvent(RelativeEvent.EVENT_GET_LIST_TITLE));
            return;
        }// end function

    }
}
