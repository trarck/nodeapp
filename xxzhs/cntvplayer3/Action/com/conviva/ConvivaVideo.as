package com.conviva
{
    import com.conviva.utils.*;
    import flash.accessibility.*;
    import flash.display.*;
    import flash.media.*;
    import flash.net.*;

    public class ConvivaVideo extends Video
    {
        private var _stream:ConvivaNetStream = null;
        var _player:Object = null;

        public function ConvivaVideo(param1:int = 320, param2:int = 240)
        {
            super(param1, param2);
            return;
        }// end function

        public function cleanup() : void
        {
            if (this._stream)
            {
                this._stream = null;
            }
            if (this._player)
            {
                this._player = null;
            }
            return;
        }// end function

        override public function attachNetStream(param1:NetStream) : void
        {
            if (param1 is ConvivaNetStream)
            {
                this._stream = param1 as ConvivaNetStream;
                this._stream.video = this;
            }
            super.attachNetStream(param1);
            return;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            if (this._player)
            {
                this._player.visible = param1;
            }
            super.visible = param1;
            return;
        }// end function

        override public function get videoHeight() : int
        {
            var _loc_1:* = this.activeVideo();
            return _loc_1 ? (_loc_1.videoHeight) : (super.videoHeight);
        }// end function

        override public function get videoWidth() : int
        {
            var _loc_1:* = this.activeVideo();
            return _loc_1 ? (_loc_1.videoWidth) : (super.videoWidth);
        }// end function

        override public function set accessibilityProperties(param1:AccessibilityProperties) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.accessibilityProperties = param1;
            }
            super.accessibilityProperties = param1;
            return;
        }// end function

        override public function set alpha(param1:Number) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.alpha = param1;
            }
            super.alpha = param1;
            return;
        }// end function

        override public function set blendMode(param1:String) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.blendMode = param1;
            }
            return;
        }// end function

        override public function set cacheAsBitmap(param1:Boolean) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.cacheAsBitmap = param1;
            }
            super.cacheAsBitmap = param1;
            return;
        }// end function

        override public function set deblocking(param1:int) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.deblocking = param1;
            }
            super.deblocking = param1;
            return;
        }// end function

        override public function set filters(param1:Array) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.filters = param1;
            }
            super.filters = param1;
            return;
        }// end function

        override public function set height(param1:Number) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.height = param1;
            }
            super.height = param1;
            return;
        }// end function

        override public function set mask(param1:DisplayObject) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.mask = param1;
            }
            super.mask = param1;
            return;
        }// end function

        override public function set opaqueBackground(param1:Object) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.opaqueBackground = param1;
            }
            super.opaqueBackground = param1;
            return;
        }// end function

        override public function set smoothing(param1:Boolean) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.smoothing = param1;
            }
            super.smoothing = param1;
            return;
        }// end function

        override public function set width(param1:Number) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.width = param1;
            }
            super.width = param1;
            return;
        }// end function

        override public function set x(param1:Number) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.x = param1;
            }
            super.x = param1;
            return;
        }// end function

        override public function set y(param1:Number) : void
        {
            var _loc_2:Video = null;
            for each (_loc_2 in this.subVideos())
            {
                
                _loc_2.y = param1;
            }
            super.y = param1;
            return;
        }// end function

        override public function clear() : void
        {
            var _loc_1:* = this.activeVideo();
            if (_loc_1)
            {
                _loc_1.clear();
            }
            else
            {
                super.clear();
            }
            return;
        }// end function

        function set player(param1:Object) : void
        {
            this._player = param1;
            return;
        }// end function

        function get player() : Object
        {
            return this._player;
        }// end function

        private function activeVideo() : Video
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.activeVideo;
            }// end function
            , "ConvivaVideo.activeVideo", null)) : (null);
        }// end function

        private function subVideos() : Array
        {
            return this._player ? (Utils.RunProtectedResult(function ()
            {
                return _player.allVideos;
            }// end function
            , "ConvivaVideo.subVideos", [])) : ([]);
        }// end function

    }
}
