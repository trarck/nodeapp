package com.cntv.common.model.proxy
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.string.*;
    import com.puremvc.model.*;
    import flash.utils.*;

    public class GetLiveBackProxy extends HttpProxy
    {
        private var _localtor:ModelLocator;
        private var castTime:Number;
        private var during:Number = 300;
        public static const NAME:String = "GetLiveBackProxy";

        public function GetLiveBackProxy()
        {
            super(NAME);
            this._localtor = ModelLocator.getInstance();
            return;
        }// end function

        public function load() : void
        {
            var _loc_1:* = ModelLocator.getInstance().paramVO.qkChannel;
            var _loc_2:* = ModelLocator.getInstance().paramVO.qkStartTime.slice(0, 10) + "0000";
            var _loc_3:* = ModelLocator.getInstance().paramVO.qkEndTime;
            var _loc_4:* = ModelLocator.getInstance().paramVO.liveBackPath + "?channel=" + _loc_1 + "&starttime=" + _loc_2 + "&endtime=" + _loc_3 + "&t=" + Math.random();
            sendHttpRequest(_loc_4);
            this.castTime = getTimer();
            return;
        }// end function

        private function dealData(param1:Object) : Object
        {
            var _loc_16:Boolean = false;
            var _loc_17:Number = NaN;
            var _loc_2:Array = [];
            var _loc_3:* = ModelLocator.getInstance().paramVO.qkStartTime.slice(10, 12);
            var _loc_4:* = ModelLocator.getInstance().paramVO.qkStartTime.slice(12);
            var _loc_5:* = ModelLocator.getInstance().paramVO.qkEndTime.slice(10, 12);
            var _loc_6:* = ModelLocator.getInstance().paramVO.qkEndTime.slice(12);
            var _loc_7:* = ModelLocator.getInstance().paramVO.qkStartTime.slice(8, 10);
            var _loc_8:* = ModelLocator.getInstance().paramVO.qkEndTime.slice(8, 10);
            var _loc_9:* = StringUtils.stringToNumber(_loc_3) * 60 + StringUtils.stringToNumber(_loc_4);
            var _loc_10:* = StringUtils.stringToNumber(_loc_5) * 60 + StringUtils.stringToNumber(_loc_6);
            _loc_10 = StringUtils.stringToNumber(_loc_5) * 60 + StringUtils.stringToNumber(_loc_6) + (StringUtils.stringToNumber(_loc_8) - StringUtils.stringToNumber(_loc_7)) * 3600;
            ModelLocator.getInstance().paramVO.isLockLimit = true;
            var _loc_11:Number = 0;
            var _loc_12:String = "";
            this.during = param1["video"]["chapters"][0].duration;
            var _loc_13:* = Math.ceil(_loc_9 / this.during);
            if (param1["video"]["chapters"] != null)
            {
                _loc_2 = param1["video"]["chapters"];
            }
            var _loc_14:* = _loc_9 - _loc_9 % this.during;
            _loc_10 = _loc_10 - _loc_14;
            _loc_9 = _loc_9 % this.during;
            ModelLocator.getInstance().paramVO.startTime = _loc_9;
            ModelLocator.getInstance().paramVO.endTime = _loc_10;
            var _loc_15:Array = [];
            if (_loc_11 >= 0)
            {
                _loc_16 = false;
                _loc_17 = 0;
                while (_loc_17 < _loc_2.length)
                {
                    
                    _loc_12 = String(_loc_2[_loc_17]["url"]).slice(-7, -4);
                    if (StringUtils.stringToNumber(_loc_12) >= _loc_13 || _loc_16 == true)
                    {
                        _loc_16 = true;
                        _loc_15.push(_loc_2[_loc_17]);
                    }
                    _loc_17 = _loc_17 + 1;
                }
            }
            param1["video"]["chapters"] = _loc_15;
            return param1;
        }// end function

        override protected function loadCompleted(param1:Object) : void
        {
            try
            {
                if (param1 == null)
                {
                }
                else
                {
                    data = this.dealData(param1);
                }
                if (data["video"] != null)
                {
                    if (data["video"]["chapters"] != null)
                    {
                        ModelLocator.getInstance().currentVideoInfo = new HttpVideoInfoVO(null).setVMSInfo(data);
                    }
                }
                else if (data["ack"] != null && (data["ack"] == "no" || data["ack"] == "offline"))
                {
                }
                sendNotification(ApplicationFacade.NOTI_START_PLAY);
            }
            catch (e)
            {
            }
            return;
        }// end function

        override protected function throwDataException() : void
        {
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            return;
        }// end function

    }
}
