package com.puremvc.view.ui
{
    import flash.display.*;
    import flash.events.*;

    public class CommonSprite extends Sprite
    {
        private var eventList:Array;
        private var childList:Array;

        public function CommonSprite()
        {
            this.eventList = new Array();
            this.childList = new Array();
            this.addEventListener(Event.ADDED_TO_STAGE, this.initializeHandler);
            return;
        }// end function

        private function initializeHandler(event:Event) : void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.initializeHandler);
            this.initialize();
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.releaseHandler);
            return;
        }// end function

        protected function initialize() : void
        {
            return;
        }// end function

        private function releaseHandler(event:Event) : void
        {
            this.removeEventListener(Event.REMOVED_FROM_STAGE, this.releaseHandler);
            this.release();
            return;
        }// end function

        protected function release() : void
        {
            var _loc_1:* = this.eventList.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                super.removeEventListener(this.eventList[_loc_2].type, this.eventList[_loc_2].listener);
                _loc_2++;
            }
            this.eventList = null;
            _loc_1 = this.childList.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                super.removeChild(this.childList[_loc_2]);
                this.childList[_loc_2] = null;
                _loc_2++;
            }
            this.childList.splice(0);
            this.childList = null;
            return;
        }// end function

        override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            var _loc_6:* = new EventStruct();
            new EventStruct().type = param1;
            _loc_6.listener = param2;
            this.eventList.push(_loc_6);
            super.addEventListener(param1, param2, param3, param4, param5);
            return;
        }// end function

        override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
        {
            var _loc_6:EventStruct = null;
            var _loc_4:* = this.eventList.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = this.eventList[_loc_5];
                if (_loc_6.type == param1 && _loc_6.listener == param2)
                {
                    this.eventList.splice(_loc_5, 1);
                    _loc_6 = null;
                    break;
                }
                _loc_5++;
            }
            super.removeEventListener(param1, param2, param3);
            return;
        }// end function

        override public function addChild(param1:DisplayObject) : DisplayObject
        {
            this.childList.push(param1);
            return super.addChild(param1);
        }// end function

        override public function removeChild(param1:DisplayObject) : DisplayObject
        {
            this.childList.splice(this.childList.indexOf(param1), 1);
            return super.removeChild(param1);
        }// end function

        override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
        {
            this.childList.push(param1);
            return super.addChildAt(param1, param2);
        }// end function

        override public function removeChildAt(param1:int) : DisplayObject
        {
            var _loc_2:* = super.removeChildAt(param1);
            this.childList.splice(this.childList.indexOf(_loc_2), 1);
            return _loc_2;
        }// end function

    }
}

class EventStruct extends Object
{
    public var type:String;
    public var listener:Function;

    function EventStruct()
    {
        return;
    }// end function

}

