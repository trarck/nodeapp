package com.cntv.common.controller
{
    import com.cntv.common.*;
    import com.cntv.common.mediator.*;
    import com.puremvc.controller.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class ViewPrepCommand extends CommonSimpleCommand
    {

        public function ViewPrepCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:* = ApplicationFacade.getInstance(Main.NAME);
            _loc_2.registerMediator(new ApplicationMediator(param1.getBody()));
            return;
        }// end function

    }
}
