package org.puremvc.as3.multicore.patterns.observer
{
    import org.puremvc.as3.multicore.interfaces.*;

    public class Observer extends Object implements IObserver
    {
        private var notify:Function;
        private var context:Object;

        public function Observer(param1:Function, param2:Object)
        {
            setNotifyMethod(param1);
            setNotifyContext(param2);
            return;
        }// end function

        private function getNotifyMethod() : Function
        {
            return notify;
        }// end function

        public function compareNotifyContext(param1:Object) : Boolean
        {
            return param1 === this.context;
        }// end function

        public function setNotifyContext(param1:Object) : void
        {
            context = param1;
            return;
        }// end function

        private function getNotifyContext() : Object
        {
            return context;
        }// end function

        public function setNotifyMethod(param1:Function) : void
        {
            notify = param1;
            return;
        }// end function

        public function notifyObserver(param1:INotification) : void
        {
            this.getNotifyMethod().apply(this.getNotifyContext(), [param1]);
            return;
        }// end function

    }
}
