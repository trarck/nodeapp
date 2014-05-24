package org.puremvc.as3.multicore.patterns.observer
{
    import org.puremvc.as3.multicore.interfaces.*;

    public class Notification extends Object implements INotification
    {
        private var body:Object;
        private var name:String;
        private var type:String;

        public function Notification(param1:String, param2:Object = null, param3:String = null)
        {
            this.name = param1;
            this.body = param2;
            this.type = param3;
            return;
        }// end function

        public function setBody(param1:Object) : void
        {
            this.body = param1;
            return;
        }// end function

        public function getName() : String
        {
            return name;
        }// end function

        public function toString() : String
        {
            var _loc_1:* = "Notification Name: " + getName();
            _loc_1 = _loc_1 + ("\nBody:" + (body == null ? ("null") : (body.toString())));
            _loc_1 = _loc_1 + ("\nType:" + (type == null ? ("null") : (type)));
            return _loc_1;
        }// end function

        public function getType() : String
        {
            return type;
        }// end function

        public function setType(param1:String) : void
        {
            this.type = param1;
            return;
        }// end function

        public function getBody() : Object
        {
            return body;
        }// end function

    }
}
