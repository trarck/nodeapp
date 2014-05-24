package org.puremvc.as3.multicore.interfaces
{
    import org.puremvc.as3.multicore.interfaces.*;

    public interface ICommand extends INotifier
    {

        public function ICommand();

        function execute(param1:INotification) : void;

    }
}
