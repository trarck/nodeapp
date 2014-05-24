package com.conviva.pdl
{
    import flash.accessibility.*;
    import flash.display.*;
    import flash.media.*;
    import flash.net.*;

    public class HttpChunkVideo extends Video
    {
        private var _httpStream:HttpChunkStream = null;

        public function HttpChunkVideo(param1:int = 640, param2:int = 450)
        {
            super(param1, param2);
            this.smoothing = true;
            return;
        }// end function

        public function cleanup() : void
        {
            if (this._httpStream)
            {
                this._httpStream = null;
            }
            return;
        }// end function

        override public function attachNetStream(param1:NetStream) : void
        {
            if (param1 is HttpChunkStream)
            {
                this._httpStream = param1 as HttpChunkStream;
                this._httpStream.videoProxy = this;
            }
            super.attachNetStream(param1);
            return;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.visible = param1;
            }
            super.visible = param1;
            return;
        }// end function

        override public function set accessibilityProperties(param1:AccessibilityProperties) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.accessibilityProperties = param1;
            }
            super.accessibilityProperties = param1;
            return;
        }// end function

        override public function set alpha(param1:Number) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.alpha = param1;
            }
            super.alpha = param1;
            return;
        }// end function

        override public function set smoothing(param1:Boolean) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.smoothing = param1;
            }
            super.smoothing = param1;
            return;
        }// end function

        override public function set blendMode(param1:String) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.blendMode = param1;
            }
            super.blendMode = param1;
            return;
        }// end function

        override public function set cacheAsBitmap(param1:Boolean) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.cacheAsBitmap = param1;
            }
            super.cacheAsBitmap = param1;
            return;
        }// end function

        override public function set deblocking(param1:int) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.deblocking = param1;
            }
            super.deblocking = param1;
            return;
        }// end function

        override public function set filters(param1:Array) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.filters = param1;
            }
            super.filters = param1;
            return;
        }// end function

        override public function set height(param1:Number) : void
        {
            if (this._httpStream && this._httpStream.video)
            {
                this._httpStream.video.height = param1;
            }
            super.height = param1;
            return;
        }// end function

        override public function set mask(param1:DisplayObject) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.mask = param1;
            }
            super.mask = param1;
            return;
        }// end function

        override public function set opaqueBackground(param1:Object) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.opaqueBackground = param1;
            }
            super.opaqueBackground = param1;
            return;
        }// end function

        override public function set width(param1:Number) : void
        {
            if (this._httpStream && this._httpStream.video)
            {
                this._httpStream.video.width = param1;
            }
            super.width = param1;
            return;
        }// end function

        override public function set x(param1:Number) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.x = param1;
            }
            super.x = param1;
            return;
        }// end function

        override public function set y(param1:Number) : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.y = param1;
            }
            super.y = param1;
            return;
        }// end function

        override public function clear() : void
        {
            if (this._httpStream)
            {
                this._httpStream.video.clear();
            }
            super.clear();
            return;
        }// end function

    }
}
