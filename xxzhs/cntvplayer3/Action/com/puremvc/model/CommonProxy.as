package com.puremvc.model
{
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class CommonProxy extends Notifier implements IProxy, INotifier
    {
        protected var proxyName:String;
        protected var data:Object;
        public static var NAME:String = "CommonProxy";

        public function CommonProxy(param1:String = null, param2:Object = null)
        {
            initializeNotifier(param1);
            this.proxyName = param1 != null ? (param1) : (NAME);
            if (param2 != null)
            {
                this.setData(param2);
            }
            return;
        }// end function

        public function getProxyName() : String
        {
            return this.proxyName;
        }// end function

        public function setData(param1:Object) : void
        {
            this.data = param1;
            return;
        }// end function

        public function getData() : Object
        {
            return this.data;
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
