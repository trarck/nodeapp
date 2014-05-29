package com.cntv.common.model.proxy
{
    import com.cntv.common.*;
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.string.*;
    import com.puremvc.model.*;
    import com.utils.net.request.*;

    public class LoadConfigProxy extends XMLProxy
    {
        private var loadTimesCount:Number = 0;
        public static const NAME:String = "LoadConfigProxy";

        public function LoadConfigProxy()
        {
            super(NAME);
            return;
        }// end function

        public function load() : void
        {
            if (ModelLocator.getInstance().ISWEBSITE)
            {
                sendHttpRequest(ModelLocator.getInstance().configPath);
            }
            else
            {
                sendHttpRequest(ModelLocator.getInstance().outSideConfigPath);
            }
            return;
        }// end function

        override protected function loadCompleted(param1:XML) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Array = null;
            var _loc_4:ValueOBJ = null;
            ModelLocator.getInstance().configVO = new ConfigVO(param1);
            if (ModelLocator.getInstance().paramVO.isHotDotNotice)
            {
                sendNotification(ApplicationFacade.NOTI_GET_VIDEOHOTDOT);
            }
            else
            {
                sendNotification(ApplicationFacade.NOTI_START_BEFORE_ADS);
            }
            if (this.loadTimesCount >= 1)
            {
                _loc_3 = [];
                _loc_4 = new ValueOBJ("t", "lci");
                _loc_3.push(_loc_4);
                _loc_4 = new ValueOBJ("v", String(this.loadTimesCount));
                _loc_3.push(_loc_4);
                _loc_4 = new ValueOBJ("url", RefHtmlGenerator.getRefUrl());
                _loc_3.push(_loc_4);
                GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_CONFIGSUCCESS_BY_RETRY, _loc_3));
            }
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            var _loc_2:String = null;
            if (this.loadTimesCount < 2)
            {
                var _loc_3:String = this;
                var _loc_4:* = this.loadTimesCount + 1;
                _loc_3.loadTimesCount = _loc_4;
                _loc_2 = ModelLocator.getInstance().configPath + "?t=" + Math.random();
                sendHttpRequest(_loc_2);
                return;
            }
            ModelLocator.getInstance().configVO = new ConfigVO(null);
            if (ModelLocator.getInstance().paramVO.isHotDotNotice)
            {
                sendNotification(ApplicationFacade.NOTI_GET_VIDEOHOTDOT);
            }
            else
            {
                sendNotification(ApplicationFacade.NOTI_START_BEFORE_ADS);
            }
            this.sendErrorMessage();
            return;
        }// end function

        override protected function throwDataException() : void
        {
            var _loc_1:String = null;
            if (this.loadTimesCount < 2)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.loadTimesCount + 1;
                _loc_2.loadTimesCount = _loc_3;
                _loc_1 = ModelLocator.getInstance().configPath + "?t=" + Math.random();
                sendHttpRequest(_loc_1);
                return;
            }
            ModelLocator.getInstance().configVO = new ConfigVO(null);
            if (ModelLocator.getInstance().paramVO.isHotDotNotice)
            {
                sendNotification(ApplicationFacade.NOTI_GET_VIDEOHOTDOT);
            }
            else
            {
                sendNotification(ApplicationFacade.NOTI_START_BEFORE_ADS);
            }
            this.sendErrorMessage();
            return;
        }// end function

        private function sendErrorMessage() : void
        {
            var _loc_1:Array = [];
            var _loc_2:* = new ValueOBJ("t", "err");
            _loc_1.push(_loc_2);
            _loc_2 = new ValueOBJ("v", QualityMonitorEvent.ERROR_CAN_NOT_GET_CONFIG);
            _loc_1.push(_loc_2);
            _loc_2 = new ValueOBJ("url", RefHtmlGenerator.getRefUrl());
            _loc_1.push(_loc_2);
            GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_1));
            return;
        }// end function

    }
}
