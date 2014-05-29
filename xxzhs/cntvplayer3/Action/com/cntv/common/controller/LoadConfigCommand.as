package com.cntv.common.controller
{
    import com.cntv.common.*;
    import com.cntv.common.model.proxy.*;
    import com.puremvc.controller.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class LoadConfigCommand extends CommonSimpleCommand
    {

        public function LoadConfigCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:* = ApplicationFacade.getInstance(Main.NAME).retrieveProxy(LoadConfigProxy.NAME) as LoadConfigProxy;
            _loc_2.load();
            return;
        }// end function

    }
}
