package com.puremvc.view
{
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class CommonMediator extends Notifier implements IMediator, INotifier
    {
        protected var mediatorName:String;
        protected var viewComponent:Object;
        public static const NAME:String = "Mediator";

        public function CommonMediator(param1:String = null, param2:Object = null)
        {
            this.mediatorName = param1 != null ? (param1) : (NAME);
            this.viewComponent = param2;
            return;
        }// end function

        public function getMediatorName() : String
        {
            return this.mediatorName;
        }// end function

        public function setViewComponent(param1:Object) : void
        {
            this.viewComponent = param1;
            return;
        }// end function

        public function getViewComponent() : Object
        {
            return this.viewComponent;
        }// end function

        public function listNotificationInterests() : Array
        {
            return [];
        }// end function

        public function handleNotification(param1:INotification) : void
        {
            return;
        }// end function

        public function onRegister() : void
        {
            return;
        }// end function

        public function onRemove() : void
        {
            return;
        }// end function

    }
}
