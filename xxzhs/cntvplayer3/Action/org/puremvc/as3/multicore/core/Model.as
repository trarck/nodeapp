package org.puremvc.as3.multicore.core
{
    import org.puremvc.as3.multicore.interfaces.*;

    public class Model extends Object implements IModel
    {
        protected const MULTITON_MSG:String = "Model instance for this Multiton key already constructed!";
        protected var multitonKey:String;
        protected var proxyMap:Array;
        static var instanceMap:Array = new Array();

        public function Model(param1:String)
        {
            if (instanceMap[param1] != null)
            {
                throw Error(MULTITON_MSG);
            }
            multitonKey = param1;
            instanceMap[multitonKey] = this;
            proxyMap = new Array();
            initializeModel();
            return;
        }// end function

        protected function initializeModel() : void
        {
            return;
        }// end function

        public function removeProxy(param1:String) : IProxy
        {
            var _loc_2:* = proxyMap[param1] as IProxy;
            if (_loc_2)
            {
                proxyMap[param1] = null;
                _loc_2.onRemove();
            }
            return _loc_2;
        }// end function

        public function hasProxy(param1:String) : Boolean
        {
            return proxyMap[param1] != null;
        }// end function

        public function retrieveProxy(param1:String) : IProxy
        {
            return proxyMap[param1];
        }// end function

        public function registerProxy(param1:IProxy) : void
        {
            param1.initializeNotifier(multitonKey);
            proxyMap[param1.getProxyName()] = param1;
            param1.onRegister();
            return;
        }// end function

        public static function getInstance(param1:String) : IModel
        {
            if (instanceMap[param1] == null)
            {
                instanceMap[param1] = new Model(param1);
            }
            return instanceMap[param1];
        }// end function

        public static function removeModel(param1:String) : void
        {
            delete instanceMap[param1];
            return;
        }// end function

    }
}
