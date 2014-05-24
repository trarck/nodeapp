package com.cntv.common.view.ui
{
    import com.cntv.common.model.*;
    import flash.display.*;
    import flash.events.*;

    public class CommonSprite extends Sprite
    {
        public var _dispatcher:GlobalDispatcher;
        public var _modelLocator:ModelLocator;
        private var _isEnable:Boolean = true;

        public function CommonSprite()
        {
            this._dispatcher = GlobalDispatcher.getInstance();
            this._modelLocator = ModelLocator.getInstance();
            this.addEventListener(Event.ADDED_TO_STAGE, this.addToStageHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removeToStageHandler);
            return;
        }// end function

        private function addToStageHandler(event:Event) : void
        {
            this.init();
            this.removeEventListener(Event.ADDED_TO_STAGE, this.addToStageHandler);
            stage.addEventListener(Event.RESIZE, this.resizeHandler);
            return;
        }// end function

        private function removeToStageHandler(event:Event) : void
        {
            this.release();
            return;
        }// end function

        private function resizeHandler(event:Event) : void
        {
            this.adjust();
            return;
        }// end function

        protected function init() : void
        {
            return;
        }// end function

        protected function adjust() : void
        {
            return;
        }// end function

        protected function release() : void
        {
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
                this.alpha = 0.7;
            }
            return;
        }// end function

        public function get isEnable() : Boolean
        {
            return this._isEnable;
        }// end function

    }
}
