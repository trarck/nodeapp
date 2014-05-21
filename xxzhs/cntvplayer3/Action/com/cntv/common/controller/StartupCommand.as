package com.cntv.common.controller
{
    import com.puremvc.controller.*;

    public class StartupCommand extends CommonMacroCommand
    {

        public function StartupCommand()
        {
            return;
        }// end function

        override protected function initializeMacroCommand() : void
        {
            addSubCommand(ModelPrepCommand);
            addSubCommand(ViewPrepCommand);
            return;
        }// end function

    }
}
