package com.cntv.common.model.proxy
{
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.string.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.puremvc.model.*;
    import flash.external.*;
    import flash.utils.*;

    public class GetNewLiveBackDataProxy extends HttpProxy
    {
        private var _localtor:ModelLocator;
        private var castTime:Number;
        private var _dispatcher:GlobalDispatcher;
        public static const NAME:String = "GetLiveBackProxy";
        public static var count:Number = 0;

        public function GetNewLiveBackDataProxy()
        {
            super(NAME);
            this._localtor = ModelLocator.getInstance();
            this._dispatcher = GlobalDispatcher.getInstance();
            return;
        }// end function

        public function load() : void
        {
            var _loc_1:* = ModelLocator.getInstance().paramVO.qkChannel;
            var _loc_2:* = ModelLocator.getInstance().paramVO.qkStartTime.slice(0, 10) + "0000";
            var _loc_3:* = ModelLocator.getInstance().paramVO.qkEndTime;
            var _loc_4:* = ModelLocator.getInstance().paramVO.liveBackPath + "?channel=" + _loc_1 + "&starttime=" + _loc_2 + "&endtime=" + _loc_3 + "&t=" + Math.random();
            sendHttpRequest(_loc_4);
            var _loc_6:* = count + 1;
            count = _loc_6;
            this.castTime = getTimer();
            return;
        }// end function

        private function dealData(param1:Object) : Object
        {
            var _loc_14:Boolean = false;
            var _loc_15:Number = NaN;
            var _loc_2:Array = [];
            var _loc_3:* = ModelLocator.getInstance().paramVO.qkStartTime.slice(10, 12);
            var _loc_4:* = ModelLocator.getInstance().paramVO.qkStartTime.slice(12);
            var _loc_5:* = ModelLocator.getInstance().paramVO.qkEndTime.slice(10, 12);
            var _loc_6:* = ModelLocator.getInstance().paramVO.qkEndTime.slice(12);
            var _loc_7:* = StringUtils.stringToNumber(_loc_3) * 60 + StringUtils.stringToNumber(_loc_4);
            var _loc_8:* = StringUtils.stringToNumber(_loc_5) * 60 + StringUtils.stringToNumber(_loc_6);
            ModelLocator.getInstance().paramVO.isLockLimit = true;
            var _loc_9:Number = 0;
            var _loc_10:String = "";
            var _loc_11:* = Math.ceil(_loc_7 / 300);
            if (param1["video"]["chapters"] != null)
            {
                _loc_2 = param1["video"]["chapters"];
            }
            var _loc_12:* = _loc_7 - _loc_7 % 300;
            _loc_8 = _loc_8 - _loc_12;
            _loc_7 = _loc_7 % 300;
            var _loc_13:Array = [];
            if (_loc_9 >= 0)
            {
                _loc_14 = false;
                _loc_15 = 0;
                while (_loc_15 < _loc_2.length)
                {
                    
                    _loc_10 = String(_loc_2[_loc_15]["url"]).slice(-7, -4);
                    if (StringUtils.stringToNumber(_loc_10) >= _loc_11 || _loc_14 == true)
                    {
                        _loc_14 = true;
                        _loc_13.push(_loc_2[_loc_15]);
                    }
                    _loc_15 = _loc_15 + 1;
                }
            }
            param1["video"]["chapters"] = _loc_13;
            return param1;
        }// end function

        override protected function loadCompleted(param1:Object) : void
        {
            if (param1 == null)
            {
                return;
            }
            data = this.dealData(param1);
            if (data["video"] != null)
            {
                if (data["video"]["chapters"] != null)
                {
                    new HttpVideoInfoVO(null).updateVideoInfo(data);
                    this._dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_UPDATA_LIVE_DATA));
                }
            }
            else if (data["ack"] != null && (data["ack"] == "no" || data["ack"] == "offline"))
            {
            }
            return;
        }// end function

        override protected function throwDataException() : void
        {
            if (ExternalInterface.available)
            {
            }
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            if (ExternalInterface.available)
            {
            }
            return;
        }// end function

    }
}
