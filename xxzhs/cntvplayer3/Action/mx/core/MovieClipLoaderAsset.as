package mx.core
{
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    import mx.core.*;

    public class MovieClipLoaderAsset extends MovieClipAsset implements IFlexAsset, IFlexDisplayObject
    {
        private var loader:Loader = null;
        private var initialized:Boolean = false;
        private var requestedWidth:Number;
        private var requestedHeight:Number;
        protected var initialWidth:Number = 0;
        protected var initialHeight:Number = 0;
        static const VERSION:String = "4.5.1.21328";

        public function MovieClipLoaderAsset()
        {
            var _loc_1:* = new LoaderContext();
            _loc_1.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            if ("allowLoadBytesCodeExecution" in _loc_1)
            {
                _loc_1["allowLoadBytesCodeExecution"] = true;
            }
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
            this.loader.loadBytes(this.movieClipData, _loc_1);
            addChild(this.loader);
            return;
        }// end function

        override public function get height() : Number
        {
            if (!this.initialized)
            {
                return this.initialHeight;
            }
            return super.height;
        }// end function

        override public function set height(param1:Number) : void
        {
            if (!this.initialized)
            {
                this.requestedHeight = param1;
            }
            else
            {
                this.loader.height = param1;
            }
            return;
        }// end function

        override public function get measuredHeight() : Number
        {
            return this.initialHeight;
        }// end function

        override public function get measuredWidth() : Number
        {
            return this.initialWidth;
        }// end function

        override public function get width() : Number
        {
            if (!this.initialized)
            {
                return this.initialWidth;
            }
            return super.width;
        }// end function

        override public function set width(param1:Number) : void
        {
            if (!this.initialized)
            {
                this.requestedWidth = param1;
            }
            else
            {
                this.loader.width = param1;
            }
            return;
        }// end function

        public function get movieClipData() : ByteArray
        {
            return null;
        }// end function

        private function completeHandler(event:Event) : void
        {
            this.initialized = true;
            this.initialWidth = this.loader.contentLoaderInfo.width;
            this.initialHeight = this.loader.contentLoaderInfo.height;
            if (!isNaN(this.requestedWidth))
            {
                this.loader.width = this.requestedWidth;
            }
            if (!isNaN(this.requestedHeight))
            {
                this.loader.height = this.requestedHeight;
            }
            dispatchEvent(event);
            return;
        }// end function

    }
}
