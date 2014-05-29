package com.puremvc.controller
{
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class CommonMacroCommand extends Notifier implements ICommand, INotifier
    {
        private var subCommands:Array;

        public function CommonMacroCommand()
        {
            this.subCommands = new Array();
            this.initializeMacroCommand();
            return;
        }// end function

        protected function initializeMacroCommand() : void
        {
            return;
        }// end function

        protected function addSubCommand(param1:Class) : void
        {
            this.subCommands.push(param1);
            return;
        }// end function

        final public function execute(param1:INotification) : void
        {
            var _loc_2:Class = null;
            var _loc_3:ICommand = null;
            while (this.subCommands.length > 0)
            {
                
                _loc_2 = this.subCommands.shift();
                _loc_3 = new _loc_2;
                _loc_3.execute(param1);
            }
            return;
        }// end function

    }
}
