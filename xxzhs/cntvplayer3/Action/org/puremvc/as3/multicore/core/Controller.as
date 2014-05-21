package org.puremvc.as3.multicore.core
{
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class Controller extends Object implements IController
    {
        protected var commandMap:Array;
        protected var view:IView;
        protected var multitonKey:String;
        protected const MULTITON_MSG:String = "Controller instance for this Multiton key already constructed!";
        static var instanceMap:Array = new Array();

        public function Controller(param1:String)
        {
            if (instanceMap[param1] != null)
            {
                throw Error(MULTITON_MSG);
            }
            multitonKey = param1;
            instanceMap[multitonKey] = this;
            commandMap = new Array();
            initializeController();
            return;
        }// end function

        public function removeCommand(param1:String) : void
        {
            if (hasCommand(param1))
            {
                view.removeObserver(param1, this);
                commandMap[param1] = null;
            }
            return;
        }// end function

        public function registerCommand(param1:String, param2:Class) : void
        {
            if (commandMap[param1] == null)
            {
                view.registerObserver(param1, new Observer(executeCommand, this));
            }
            commandMap[param1] = param2;
            return;
        }// end function

        protected function initializeController() : void
        {
            view = View.getInstance(multitonKey);
            return;
        }// end function

        public function hasCommand(param1:String) : Boolean
        {
            return commandMap[param1] != null;
        }// end function

        public function executeCommand(param1:INotification) : void
        {
            var _loc_2:* = commandMap[param1.getName()];
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = new _loc_2;
            _loc_3.initializeNotifier(multitonKey);
            _loc_3.execute(param1);
            return;
        }// end function

        public static function removeController(param1:String) : void
        {
            delete instanceMap[param1];
            return;
        }// end function

        public static function getInstance(param1:String) : IController
        {
            if (instanceMap[param1] == null)
            {
                instanceMap[param1] = new Controller(param1);
            }
            return instanceMap[param1];
        }// end function

    }
}
