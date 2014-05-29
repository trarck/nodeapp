package com.cntv.common.model.proxy
{
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.puremvc.model.*;
    import flash.events.*;
    import flash.utils.*;

    public class GetVideoMatchProxy extends HttpProxy
    {
        private var _localtor:ModelLocator;
        private var isLoaded:Boolean = false;
        public var _dispatcher:GlobalDispatcher;
        private var interval:Number;
        private var time:Number = 0;
        public static const getMatchEvent:String = "get.match.event";

        public function GetVideoMatchProxy()
        {
            super(NAME);
            this._localtor = ModelLocator.getInstance();
            this._dispatcher = GlobalDispatcher.getInstance();
            return;
        }// end function

        public function load() : void
        {
            if (!this._localtor.paramVO.isSlicedByHotDot && this._localtor.paramVO.isHotDotNotice && this._localtor.paramVO.hotmapData != null)
            {
                this.interval = setInterval(this.checkPlugin, 500);
            }
            else
            {
                this.startLoad();
            }
            return;
        }// end function

        private function checkPlugin() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this.time + 1;
            _loc_1.time = _loc_2;
            if (this.time > 12)
            {
                clearInterval(this.interval);
                return;
            }
            if (this._localtor.hotDotPluginLoaded)
            {
                clearInterval(this.interval);
                this.startLoad();
            }
            return;
        }// end function

        private function startLoad() : void
        {
            var _loc_1:* = ModelLocator.getInstance().paramVO.matchDataPath + "?pid=" + ModelLocator.getInstance().paramVO.videoCenterId + "&t=" + Math.random();
            sendHttpRequest(_loc_1);
            setTimeout(this.check, 3000);
            return;
        }// end function

        override protected function loadCompleted(param1:Object) : void
        {
            if (this.isLoaded)
            {
                return;
            }
            this.dealMatchData(param1);
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            if (this.isLoaded)
            {
                return;
            }
            this.dealMatchData(null);
            return;
        }// end function

        override protected function throwDataException() : void
        {
            if (this.isLoaded)
            {
                return;
            }
            this.dealMatchData(null);
            return;
        }// end function

        private function check() : void
        {
            if (this.isLoaded)
            {
                return;
            }
            this.dealMatchData(null);
            return;
        }// end function

        private function dealMatchData(param1:Object = null) : void
        {
            var _loc_2:matchVO = null;
            this.isLoaded = true;
            if (param1 != null)
            {
                if (param1["ack"] == "yes")
                {
                    _loc_2 = new matchVO(param1);
                    ModelLocator.getInstance().paramVO.matchData = _loc_2;
                    this._dispatcher.dispatchEvent(new Event(getMatchEvent));
                }
            }
            return;
        }// end function

    }
}
