package com.cntv.common.controller
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.proxy.*;
    import com.puremvc.controller.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class GetVideoInfoCommand extends CommonSimpleCommand
    {
        private var _locator:ModelLocator;

        public function GetVideoInfoCommand()
        {
            this._locator = ModelLocator.getInstance();
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:GetVideoInfoProxy = null;
            var _loc_3:GetCycleDataProxy = null;
            if (!this._locator.paramVO.isCycle)
            {
                if (this._locator.paramVO.videoId != null && this._locator.paramVO.videoId.length != 0)
                {
                    _loc_2 = ApplicationFacade.getInstance(Main.NAME).retrieveProxy(GetVideoInfoProxy.NAME) as GetVideoInfoProxy;
                    _loc_2.load();
                }
            }
            else
            {
                _loc_3 = ApplicationFacade.getInstance(Main.NAME).retrieveProxy(GetCycleDataProxy.NAME) as GetCycleDataProxy;
                _loc_3.load();
            }
            return;
        }// end function

    }
}
