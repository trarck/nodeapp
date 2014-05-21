package com.puremvc.view.ui
{
    import flash.display.*;
    import flash.events.*;

    public class EmbedSprite extends Sprite
    {
        protected var embed:DisplayObject;
        private var _isEnable:Boolean = true;

        public function EmbedSprite()
        {
            this.initialize();
            this.addEventListener(Event.ADDED_TO_STAGE, this.addtoStage);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.releaseHandler);
            return;
        }// end function

        public function set isEnable(param1:Boolean) : void
        {
            this._isEnable = param1;
            this.mouseEnabled = this._isEnable;
            this.mouseChildren = this._isEnable;
            if (this._isEnable)
            {
                this.alpha = 1;
            }
            else
            {
                this.alpha = 0.4;
            }
            return;
        }// end function

        public function get isEnable() : Boolean
        {
            return this._isEnable;
        }// end function

        protected function addtoStage(event:Event) : void
        {
            this.init();
            return;
        }// end function

        protected function init() : void
        {
            return;
        }// end function

        protected function initialize() : void
        {
            this.initMouseListener();
            return;
        }// end function

        protected function initMouseListener() : void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverHandler);
            return;
        }// end function

        private function onMouseOutHandler(event:MouseEvent) : void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOutHandler);
            return;
        }// end function

        private function onMouseOverHandler(event:MouseEvent) : void
        {
            var _loc_2:String = null;
            var _loc_3:InteractiveObject = null;
            try
            {
                _loc_2 = event.currentTarget.NAME_TOOLTIP;
                _loc_3 = event.currentTarget as InteractiveObject;
            }
            catch (e:Error)
            {
            }
            if (_loc_2 == null)
            {
                return;
            }
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOutHandler);
            removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverHandler);
            return;
        }// end function

        override public function get width() : Number
        {
            return this.embed.width;
        }// end function

        override public function set width(param1:Number) : void
        {
            this.embed.width = param1;
            return;
        }// end function

        override public function get height() : Number
        {
            return this.embed.height;
        }// end function

        override public function set height(param1:Number) : void
        {
            this.embed.height = param1;
            return;
        }// end function

        private function releaseHandler(event:Event) : void
        {
            this.removeEventListener(Event.REMOVED_FROM_STAGE, this.releaseHandler);
            return;
        }// end function

    }
}
