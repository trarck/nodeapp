package com.cntv.common.controller
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.proxy.*;
    import com.puremvc.controller.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class GetVideoQuickCommand extends CommonSimpleCommand
    {
        private var _locator:ModelLocator;

        public function GetVideoQuickCommand()
        {
            this._locator = ModelLocator.getInstance();
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:* = ApplicationFacade.getInstance(Main.NAME).retrieveProxy(GetQuickDataProxy.NAME) as GetQuickDataProxy;
            _loc_2.load();
            return;
        }// end function

    }
}
