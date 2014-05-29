package org.puremvc.as3.multicore.interfaces
{
    import org.puremvc.as3.multicore.interfaces.*;

    public interface IProxy extends INotifier
    {

        public function IProxy();

        function getData() : Object;

        function onRegister() : void;

        function getProxyName() : String;

        function onRemove() : void;

        function setData(param1:Object) : void;

    }
}
