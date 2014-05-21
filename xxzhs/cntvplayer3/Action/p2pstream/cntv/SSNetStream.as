package p2pstream.cntv
{
    import flash.net.*;

    public class SSNetStream extends NetStream
    {
        private var _nsMain:Object = null;
        private var _useP2P:Boolean = true;
        public static var swcLoaded:Boolean = true;

        public function SSNetStream(param1:NetConnection, param2:String = "connectToFMS")
        {
            super(param1, param2);
            if (swcLoaded && this._useP2P)
            {
                this._nsMain = new SSNetStreamMain(this);
                this._nsMain.init();
            }
            return;
        }// end function

        function set useP2P(param1:Boolean) : void
        {
            this._useP2P = param1;
            return;
        }// end function

        function get useP2P() : Boolean
        {
            return this._useP2P;
        }// end function

        override public function set bufferTime(param1:Number) : void
        {
            super.bufferTime = param1;
            if (swcLoaded && this._useP2P)
            {
                this._nsMain.bufferTime = param1;
            }
            return;
        }// end function

        function get super_time() : Number
        {
            return super.time;
        }// end function

        override public function get time() : Number
        {
            return swcLoaded && this._useP2P ? (this._nsMain.time) : (this.super_time);
        }// end function

        public function get totalUniqAppendBytes() : Number
        {
            return swcLoaded && this._useP2P ? (this._nsMain.totalUniqAppendBytes) : (0);
        }// end function

        public function get totalAppendBytes() : Number
        {
            return swcLoaded && this._useP2P ? (this._nsMain.totalAppendBytes) : (0);
        }// end function

        public function get totalSourceBytes() : Number
        {
            return swcLoaded && this._useP2P ? (this._nsMain.totalSourceBytes) : (0);
        }// end function

        public function get totalPeerBytes() : Number
        {
            return swcLoaded && this._useP2P ? (this._nsMain.totalPeerBytes) : (0);
        }// end function

        function get super_bytesLoaded() : uint
        {
            return super.bytesLoaded;
        }// end function

        override public function get bytesLoaded() : uint
        {
            return swcLoaded && this._useP2P ? (this._nsMain.bytesLoaded) : (this.super_bytesLoaded);
        }// end function

        function get super_bytesTotal() : uint
        {
            return super.bytesTotal;
        }// end function

        override public function get bytesTotal() : uint
        {
            return swcLoaded && this._useP2P ? (this._nsMain.bytesTotal) : (this.super_bytesTotal);
        }// end function

        function super_seek(param1:Number) : void
        {
            super.seek(param1);
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            if (swcLoaded && this._useP2P)
            {
                this._nsMain.seek(param1);
            }
            else
            {
                this.super_seek(param1);
            }
            return;
        }// end function

        private function apply_func(param1:Function, param2:Array) : void
        {
            switch(param2.length)
            {
                case 1:
                {
                    this.param1(param2[0]);
                    break;
                }
                case 2:
                {
                    this.param1(param2[0], param2[1]);
                    break;
                }
                case 3:
                {
                    this.param1(param2[0], param2[1], param2[2]);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        function super_play(... args) : void
        {
            this.apply_func(super.play, args);
            return;
        }// end function

        override public function play(... args) : void
        {
            if (swcLoaded && this._useP2P)
            {
                this.apply_func(this._nsMain.play, args);
            }
            else
            {
                this.apply_func(super.play, args);
            }
            return;
        }// end function

        override public function close() : void
        {
            super.close();
            if (swcLoaded && this._useP2P)
            {
                this._nsMain.close();
            }
            return;
        }// end function

        function super_pause() : void
        {
            super.pause();
            return;
        }// end function

        override public function pause() : void
        {
            this.super_pause();
            if (swcLoaded && this._useP2P)
            {
                this._nsMain.pause();
            }
            return;
        }// end function

        function super_resume() : void
        {
            super.resume();
            return;
        }// end function

        override public function resume() : void
        {
            this.super_resume();
            if (swcLoaded && this._useP2P)
            {
                this._nsMain.resume();
            }
            return;
        }// end function

        override public function togglePause() : void
        {
            super.togglePause();
            if (swcLoaded && this._useP2P)
            {
                this._nsMain.togglePause();
            }
            return;
        }// end function

    }
}
