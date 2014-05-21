package com.conviva.utils
{

    public class Eventer extends Object
    {
        private var _handlers:ListCS;

        public function Eventer()
        {
            this._handlers = new ListCS();
            return;
        }// end function

        public function Cleanup() : void
        {
            this._handlers = new ListCS();
            return;
        }// end function

        public function AddHandler(param1:Function) : void
        {
            this._handlers.Add(param1);
            return;
        }// end function

        public function DeleteHandler(param1:Function) : void
        {
            this._handlers.Remove(param1);
            return;
        }// end function

        public function DispatchEvent() : void
        {
            var _loc_1:Function = null;
            for each (_loc_1 in this._handlers.Values)
            {
                
                this._loc_1();
            }
            return;
        }// end function

    }
}
