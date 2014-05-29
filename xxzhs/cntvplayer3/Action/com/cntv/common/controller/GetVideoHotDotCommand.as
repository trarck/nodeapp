package com.cntv.common.controller
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.proxy.*;
    import com.puremvc.controller.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class GetVideoHotDotCommand extends CommonSimpleCommand
    {
        private var _locator:ModelLocator;

        public function GetVideoHotDotCommand()
        {
            this._locator = ModelLocator.getInstance();
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:GetVideoHotDotProxy = null;
            if (this._locator.paramVO.isHotDotNotice)
            {
                if (this._locator.paramVO.videoId != null && this._locator.paramVO.videoId.length != 0)
                {
                    _loc_2 = ApplicationFacade.getInstance(Main.NAME).retrieveProxy(GetVideoHotDotProxy.NAME) as GetVideoHotDotProxy;
                    _loc_2.load();
                }
            }
            return;
        }// end function

    }
}
