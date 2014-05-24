package com.cntv.common.controller
{
    import com.cntv.common.*;
    import com.cntv.common.model.proxy.*;
    import com.puremvc.controller.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class LoadLanguageCommand extends CommonSimpleCommand
    {
        private var appFacade:ApplicationFacade;

        public function LoadLanguageCommand()
        {
            this.appFacade = ApplicationFacade.getInstance(Main.NAME);
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            this.appFacade.registerProxy(new LoadLanguageProxy());
            return;
        }// end function

    }
}
