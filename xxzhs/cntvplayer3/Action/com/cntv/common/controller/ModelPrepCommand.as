package com.cntv.common.controller
{
    import com.cntv.common.*;
    import com.cntv.common.model.proxy.*;
    import com.puremvc.controller.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class ModelPrepCommand extends CommonSimpleCommand
    {

        public function ModelPrepCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:* = ApplicationFacade.getInstance(Main.NAME);
            _loc_2.registerProxy(new GetVideoInfoProxy());
            _loc_2.registerProxy(new GetCycleDataProxy());
            _loc_2.registerProxy(new LoadConfigProxy());
            _loc_2.registerProxy(new GetVideoHotDotProxy());
            _loc_2.registerProxy(new GetInteractiveInfoProxy());
            _loc_2.registerProxy(new GetQuickDataProxy());
            _loc_2.registerProxy(new GetLiveBackProxy());
            return;
        }// end function

    }
}
