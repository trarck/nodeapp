package com.cntv.player.playerCom.video.model
{

    dynamic public class VideoPlayerClient extends Object
    {
        protected var _owner:Object;
        protected var gotMetadata:Boolean;

        public function VideoPlayerClient(param1:Object)
        {
            this._owner = param1;
            this.gotMetadata = false;
            return;
        }// end function

        public function get owner() : Object
        {
            return this._owner;
        }// end function

        public function onMetaData(param1:Object, ... args) : void
        {
            this._owner.onMetaData(param1);
            this.gotMetadata = true;
            return;
        }// end function

        public function onPlayStatus(param1:Object, ... args) : void
        {
            this._owner.onPlayStatus(param1);
            return;
        }// end function

        public function onCuePoint(param1:Object, ... args) : void
        {
            this._owner.onCuePoint(param1);
            return;
        }// end function

        public function get ready() : Boolean
        {
            return this.gotMetadata;
        }// end function

        public function onBWCheck(... args) : Number
        {
            return 0;
        }// end function

        public function onBWDone(... args) : void
        {
            args = 0;
            if (args.length > 0)
            {
                args = args[0];
            }
            if (isNaN(args))
            {
                args = 0;
            }
            this._owner.onBWDone(args);
            return;
        }// end function

    }
}
