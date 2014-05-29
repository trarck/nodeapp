package org.puremvc.as3.multicore.interfaces
{

    public interface IController
    {

        public function IController();

        function registerCommand(param1:String, param2:Class) : void;

        function hasCommand(param1:String) : Boolean;

        function executeCommand(param1:INotification) : void;

        function removeCommand(param1:String) : void;

    }
}
