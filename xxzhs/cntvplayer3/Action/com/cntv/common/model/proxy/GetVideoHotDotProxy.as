package com.cntv.common.model.proxy
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.puremvc.model.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class GetVideoHotDotProxy extends HttpProxy
    {
        private var _localtor:ModelLocator;
        private var castTime:int;
        private var hasStaticData:Boolean = false;
        private var isTurnOnDYData:Boolean;
        private var isDynamic:String = "1";
        private var isLoaded:Boolean = false;
        private var nbaLoaded:Boolean = false;
        public static const NAME:String = "GetVideoHotDotProxy";

        public function GetVideoHotDotProxy()
        {
            super(NAME);
            this._localtor = ModelLocator.getInstance();
            return;
        }// end function

        public function load() : void
        {
            var _loc_1:String = null;
            if (!this.nbaLoaded)
            {
                this.LoadNbaData();
            }
            else
            {
                _loc_1 = "";
                _loc_1 = ModelLocator.getInstance().paramVO.hotmapDataPath + "?pid=" + ModelLocator.getInstance().paramVO.videoCenterId + "&t=" + Math.random();
                sendHttpRequest(_loc_1);
                setTimeout(this.check, 3000);
            }
            return;
        }// end function

        private function LoadNbaData() : void
        {
            var _loc_1:* = ModelLocator.getInstance().paramVO.icanNBADataPath + "?pid=" + ModelLocator.getInstance().paramVO.videoCenterId + "&t=" + Math.random();
            var _loc_2:* = new URLLoader();
            var _loc_3:* = new URLRequest(_loc_1);
            _loc_2.addEventListener(Event.COMPLETE, this.onNbaComp);
            _loc_2.addEventListener(IOErrorEvent.IO_ERROR, this.onNbaIoError);
            _loc_2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            _loc_2.load(_loc_3);
            setTimeout(this.checkNBA, 3000);
            return;
        }// end function

        private function checkNBA() : void
        {
            if (this.nbaLoaded)
            {
                return;
            }
            this.nbaLoaded = true;
            this.load();
            return;
        }// end function

        private function onNbaComp(event:Event) : void
        {
            var xml:XML;
            var type:String;
            var e:* = event;
            if (this.nbaLoaded)
            {
                return;
            }
            this.nbaLoaded = true;
            var data:* = e.target.data;
            if (data.indexOf("{\"ack\":\"no\"}") >= 0)
            {
                this.load();
                return;
            }
            try
            {
                xml = XML(data);
                type = xml.@type;
                if (type == "NBA")
                {
                    ModelLocator.getInstance().paramVO.icanNBAData = data;
                    ModelLocator.getInstance().paramVO.isNBA = true;
                    sendNotification(ApplicationFacade.NOTI_START_BEFORE_ADS);
                }
                else
                {
                    this.load();
                }
            }
            catch (e:Error)
            {
                load();
            }
            return;
        }// end function

        private function onNbaIoError(event:IOErrorEvent) : void
        {
            if (this.nbaLoaded)
            {
                return;
            }
            this.nbaLoaded = true;
            this.load();
            return;
        }// end function

        private function onSecurityError(event:SecurityErrorEvent) : void
        {
            if (this.nbaLoaded)
            {
                return;
            }
            this.nbaLoaded = true;
            this.load();
            return;
        }// end function

        override protected function loadCompleted(param1:Object) : void
        {
            if (this.isLoaded)
            {
                return;
            }
            this.dealHotData(param1);
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            if (this.isLoaded)
            {
                return;
            }
            this.dealHotData(null);
            return;
        }// end function

        override protected function throwDataException() : void
        {
            if (this.isLoaded)
            {
                return;
            }
            this.dealHotData(null);
            return;
        }// end function

        private function check() : void
        {
            if (this.isLoaded)
            {
                return;
            }
            this.dealHotData(null);
            return;
        }// end function

        private function dealHotData(param1:Object = null) : void
        {
            var _loc_2:Object = null;
            this.isLoaded = true;
            if (ModelLocator.getInstance().paramVO.sliceStartTime != -1)
            {
                ModelLocator.getInstance().paramVO.hotmapData = {};
                ModelLocator.getInstance().paramVO.hotmapData.satrt = ModelLocator.getInstance().paramVO.sliceStartTime;
                ModelLocator.getInstance().paramVO.hotmapData.end = ModelLocator.getInstance().paramVO.sliceEndTime;
                ModelLocator.getInstance().paramVO.isSlicedByHotDot = true;
            }
            else if (param1 != null)
            {
                if (param1["ack"] == "yes")
                {
                    _loc_2 = {};
                    if (param1["is_hotmap"] == "no")
                    {
                        if (ModelLocator.getInstance().paramVO.slice)
                        {
                            if (param1["hottag"] is Array && param1["hottag"].length >= 2)
                            {
                                _loc_2.satrt = Number(param1["hottag"][0].time);
                                _loc_2.end = Number(param1["hottag"][1].time);
                                ModelLocator.getInstance().paramVO.sliceStartTime = Number(param1["hottag"][0].time);
                                ModelLocator.getInstance().paramVO.sliceEndTime = Number(param1["hottag"][1].time);
                                ModelLocator.getInstance().paramVO.isSlicedByHotDot = true;
                            }
                        }
                        else
                        {
                            _loc_2 = null;
                        }
                    }
                    else if (param1["is_hotmap"] == "yes")
                    {
                        _loc_2.points = param1["hottag"];
                    }
                    ModelLocator.getInstance().paramVO.hotmapData = _loc_2;
                }
            }
            sendNotification(ApplicationFacade.NOTI_START_BEFORE_ADS);
            return;
        }// end function

    }
}
