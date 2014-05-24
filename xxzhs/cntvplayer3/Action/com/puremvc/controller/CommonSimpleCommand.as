package com.puremvc.controller
{
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class CommonSimpleCommand extends Notifier implements ICommand, INotifier
    {

        public function CommonSimpleCommand()
        {
            return;
        }// end function

        public function execute(param1:INotification) : void
        {
            return;
        }// end function

    }
}
