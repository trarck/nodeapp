package com.cntv.common.model.proxy
{
    import com.cntv.common.*;
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.string.*;
    import com.cntv.player.floatLayer.event.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.puremvc.model.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.utils.*;

    public class GetVideoInfoProxy extends HttpProxy
    {
        private var _localtor:ModelLocator;
        private var castTime:int;
        private var hasStaticData:Boolean = false;
        private var isTurnOnDYData:Boolean;
        private var isDynamic:String = "1";
        private var loadTimesCount:Number = 0;
        private var staticDataUrl:String;
        public static const NAME:String = "GetVideoInfoProxy";

        public function GetVideoInfoProxy()
        {
            super(NAME);
            this._localtor = ModelLocator.getInstance();
            return;
        }// end function

        public function load() : void
        {
            var _loc_1:Object = null;
            this.isTurnOnDYData = Math.random() < 1 / this._localtor.paramVO.dynamicFrequency;
            if (!this._localtor.paramVO.isLive)
            {
                if (this._localtor.paramVO.isUseDynamicData && this.isTurnOnDYData && !this._localtor.isLocationPlayer)
                {
                    this.getDynamicData();
                }
                else if (this._localtor.paramVO.useTxtPath)
                {
                    this.getStaticData();
                }
            }
            else
            {
                _loc_1 = {videoid:this._localtor.paramVO.videoId, streamName:this._localtor.paramVO.streamName, rtmpHost:this._localtor.paramVO.rtmpHost};
                this._localtor.currentVideoInfo = new LiveVideoInfoVO(_loc_1);
                sendNotification(ApplicationFacade.NOTI_START_PLAY);
            }
            return;
        }// end function

        private function getStaticData() : void
        {
            var _loc_2:String = null;
            this.isDynamic = "0";
            this.castTime = getTimer();
            var _loc_1:* = new Object();
            if (this._localtor.paramVO.filePath == "" && this._localtor.configVO.videoInfoURL == "")
            {
                _loc_2 = this._localtor.paramVO.videoId;
            }
            else if (this._localtor.paramVO.tai == "baidu")
            {
                _loc_2 = this._localtor.dynamicHost + this._localtor.paramVO.videoCenterId.substr(0, 2) + "/" + this._localtor.paramVO.videoCenterId.substr(2, 2) + "/" + this._localtor.paramVO.videoCenterId.substr(4, 2) + "/" + this._localtor.paramVO.videoCenterId + ".txt";
            }
            else if (this._localtor.isLocationPlayer)
            {
                _loc_2 = this._localtor.paramVO.videoId;
            }
            else
            {
                _loc_2 = this._localtor.configVO.videoInfoURL + this._localtor.paramVO.filePath + this._localtor.paramVO.videoId.substr(0, 8) + "/" + this._localtor.paramVO.videoId.substr(8, (this._localtor.paramVO.videoId.length - 1)) + ".txt";
            }
            this.staticDataUrl = _loc_2;
            this.castTime = getTimer();
            sendHttpRequest(_loc_2);
            this.hasStaticData = true;
            this._localtor.useStaticData = true;
            return;
        }// end function

        private function getDynamicData() : void
        {
            var _loc_2:String = null;
            var _loc_3:Array = null;
            var _loc_4:ValueOBJ = null;
            this.isDynamic = "1";
            var _loc_1:* = new Date().getTimezoneOffset() / 60;
            _loc_2 = this._localtor.paramVO.dynamicDataPath + "?pid=" + this._localtor.paramVO.videoCenterId + "&tz=" + _loc_1 + "&from=000" + ModelLocator.getInstance().paramVO.tai + "&url=" + RefHtmlGenerator.getRefUrl() + "&idl=" + this._localtor.paramVO.idLength + "&idlr=" + this._localtor.paramVO.videoCenterId.length + "&modifyed=" + this._localtor.paramVO.vidModify;
            if (this._localtor.paramVO.videoCenterIdBackUp.length != this._localtor.paramVO.idLength && this.loadTimesCount == 0)
            {
                _loc_3 = [];
                _loc_4 = new ValueOBJ("t", "err");
                _loc_3.push(_loc_4);
                _loc_4 = new ValueOBJ("v", QualityMonitorEvent.ERROR_ID_EXCEPTION);
                _loc_3.push(_loc_4);
                _loc_4 = new ValueOBJ("idl", this._localtor.paramVO.idLength.toString());
                _loc_3.push(_loc_4);
                _loc_4 = new ValueOBJ("originalId", this._localtor.paramVO.videoCenterIdBackUp);
                _loc_3.push(_loc_4);
                _loc_4 = new ValueOBJ("url", RefHtmlGenerator.getRefUrl());
                _loc_3.push(_loc_4);
                GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_3));
            }
            this.castTime = getTimer();
            if (this.loadTimesCount > 0)
            {
                _loc_2 = _loc_2 + "&random=" + Math.random() + "&times=" + this.loadTimesCount;
            }
            sendHttpRequest(_loc_2);
            return;
        }// end function

        override protected function throwDataException() : void
        {
            if (this.loadTimesCount < 2)
            {
                var _loc_3:String = this;
                var _loc_4:* = this.loadTimesCount + 1;
                _loc_3.loadTimesCount = _loc_4;
                this.getDynamicData();
                return;
            }
            super.throwDataException();
            var _loc_1:Array = [];
            var _loc_2:* = new ValueOBJ("t", "err");
            _loc_1.push(_loc_2);
            _loc_2 = new ValueOBJ("v", QualityMonitorEvent.ERROR_VIDEO_DATA_FORMAT_ERROR);
            _loc_1.push(_loc_2);
            _loc_2 = new ValueOBJ("dynamic", this.isDynamic);
            _loc_1.push(_loc_2);
            if (this.isDynamic == "0")
            {
                _loc_2 = new ValueOBJ("dataUrl", this.staticDataUrl);
                _loc_1.push(_loc_2);
                _loc_2 = new ValueOBJ("url", RefHtmlGenerator.getRefUrl());
                _loc_1.push(_loc_2);
            }
            GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_1));
            if (!this.hasStaticData && this._localtor.paramVO.useTxtPath)
            {
                this.getStaticData();
            }
            else
            {
                this._localtor.noVideoData = true;
                GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_RELATIVE, null));
            }
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            if (this.loadTimesCount < 2)
            {
                var _loc_4:String = this;
                var _loc_5:* = this.loadTimesCount + 1;
                _loc_4.loadTimesCount = _loc_5;
                this.getDynamicData();
                return;
            }
            var _loc_2:Array = [];
            var _loc_3:* = new ValueOBJ("t", "err");
            _loc_2.push(_loc_3);
            _loc_3 = new ValueOBJ("v", QualityMonitorEvent.ERROR_CAN_NOT_GET_VIDEO_DATA);
            _loc_2.push(_loc_3);
            _loc_3 = new ValueOBJ("dynamic", this.isDynamic);
            _loc_2.push(_loc_3);
            _loc_3 = new ValueOBJ("errmsg", param1);
            _loc_2.push(_loc_3);
            if (this.isDynamic == "0")
            {
                _loc_3 = new ValueOBJ("dataUrl", this.staticDataUrl);
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("url", RefHtmlGenerator.getRefUrl());
                _loc_2.push(_loc_3);
            }
            GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_2));
            if (!this.hasStaticData && this._localtor.paramVO.useTxtPath)
            {
                this.getStaticData();
            }
            else if (!ModelLocator.getInstance().isLocationPlayer)
            {
                this._localtor.noVideoData = true;
                GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_RELATIVE, null));
            }
            return;
        }// end function

        override protected function loadCompleted(param1:Object) : void
        {
            var _loc_3:Object = null;
            var _loc_4:Array = null;
            var _loc_5:ValueOBJ = null;
            var _loc_2:Boolean = false;
            super.loadCompleted(param1);
            if (this.loadTimesCount >= 1)
            {
                _loc_4 = [];
                _loc_5 = new ValueOBJ("t", "lvi");
                _loc_4.push(_loc_5);
                _loc_5 = new ValueOBJ("v", String(this.loadTimesCount));
                _loc_4.push(_loc_5);
                _loc_5 = new ValueOBJ("url", RefHtmlGenerator.getRefUrl());
                _loc_4.push(_loc_5);
                GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_VDDSUCCESS_BY_RETRY, _loc_4));
            }
            if (param1 == null)
            {
                _loc_4 = [];
                _loc_5 = new ValueOBJ("t", "err");
                _loc_4.push(_loc_5);
                _loc_5 = new ValueOBJ("v", QualityMonitorEvent.ERROR_VIDEO_DATA_FORMAT_ERROR);
                _loc_4.push(_loc_5);
                _loc_5 = new ValueOBJ("dynamic", this.isDynamic);
                _loc_4.push(_loc_5);
                if (this.isDynamic == "0")
                {
                    _loc_5 = new ValueOBJ("dataUrl", this.staticDataUrl);
                    _loc_4.push(_loc_5);
                    _loc_5 = new ValueOBJ("url", RefHtmlGenerator.getRefUrl());
                    _loc_4.push(_loc_5);
                }
                GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_4));
                this._localtor.noVideoData = true;
                GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_RELATIVE, null));
            }
            else
            {
                _loc_4 = [];
                _loc_5 = new ValueOBJ("t", "ld");
                _loc_4.push(_loc_5);
                _loc_5 = new ValueOBJ("v", int(getTimer() - this.castTime).toString());
                _loc_4.push(_loc_5);
                _loc_5 = new ValueOBJ("dynamic", this.isDynamic);
                _loc_4.push(_loc_5);
                _loc_5 = new ValueOBJ("isHaveAD", this._localtor.paramVO.adCall != "" ? ("true") : ("false"));
                _loc_4.push(_loc_5);
                _loc_5 = new ValueOBJ("adLen", this._localtor.adVosBF.length.toString());
                _loc_4.push(_loc_5);
                GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_LOAD_DATA_TIME, _loc_4));
                _loc_3 = param1;
            }
            if (_loc_3["version"] != null)
            {
                if (_loc_3["video"]["chapters"] != null || _loc_3["video"]["chapters2"] != null || _loc_3["video"]["chapters3"] != null || _loc_3["video"]["chapters4"] != null || _loc_3["video"]["chapters5"] != null)
                {
                    ModelLocator.getInstance().currentVideoInfo = new HttpVideoInfoVO(null).setVMSInfo(_loc_3);
                    if (_loc_3["video"]["chapters"] && String(_loc_3["video"]["chapters"][0]["url"]).indexOf(".mp3") > 0)
                    {
                        ModelLocator.getInstance().currentAudioInfo = new AudioInfoVO(null).setVMSInfo(_loc_3["video"]);
                    }
                    else if (_loc_3["video"]["mp3chapters"] && _loc_3["video"]["mp3chapters"][0] != null)
                    {
                        ModelLocator.getInstance().currentAudioInfo = new AudioInfoVO(null).setVMSInfo(_loc_3["video"]);
                    }
                }
                else if (_loc_3["video"]["streams"] != null)
                {
                    ModelLocator.getInstance().currentVideoInfo = new VodVideoInfoVO(null).setVMSInfo(_loc_3);
                }
                _loc_2 = true;
            }
            else if (_loc_3["ack"] != null && (_loc_3["ack"] == "no" || _loc_3["ack"] == "offline"))
            {
                _loc_4 = [];
                _loc_5 = new ValueOBJ("t", "err");
                _loc_4.push(_loc_5);
                if (_loc_3["ack"] == "no")
                {
                    _loc_5 = new ValueOBJ("v", QualityMonitorEvent.ERROR_VIDEO_DATA_ACK_NO);
                }
                else
                {
                    _loc_5 = new ValueOBJ("v", QualityMonitorEvent.ERROR_VIDEO_DATA_ACK_OFFLINE);
                }
                _loc_4.push(_loc_5);
                _loc_5 = new ValueOBJ("dynamic", this.isDynamic);
                _loc_4.push(_loc_5);
                if (this.isDynamic == "0")
                {
                    _loc_5 = new ValueOBJ("dataUrl", this.staticDataUrl);
                    _loc_4.push(_loc_5);
                    _loc_5 = new ValueOBJ("url", RefHtmlGenerator.getRefUrl());
                    _loc_4.push(_loc_5);
                }
                GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_4));
                if ((!this._localtor.paramVO.useTxtPath || this.hasStaticData) && !_loc_2)
                {
                    this._localtor.noVideoData = true;
                    GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_RELATIVE, null));
                }
                if (_loc_3["ack"] == "offline")
                {
                }
                else if (_loc_3["public"] == "0")
                {
                }
                else if (!this.hasStaticData && this._localtor.paramVO.useTxtPath)
                {
                    this.getStaticData();
                }
                return;
            }
            else if (_loc_3["isRtmp"] == "true")
            {
                ModelLocator.getInstance().currentVideoInfo = new VodVideoInfoVO(_loc_3);
                _loc_2 = true;
            }
            else
            {
                ModelLocator.getInstance().currentVideoInfo = new HttpVideoInfoVO(_loc_3);
                _loc_2 = true;
            }
            if ((this.hasStaticData || !this._localtor.paramVO.useTxtPath) && !_loc_2)
            {
                this._localtor.useStaticData = false;
                this._localtor.noVideoData = true;
                GlobalDispatcher.getInstance().dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_RELATIVE, null));
                return;
            }
            GlobalDispatcher.getInstance().dispatchEvent(new CommonEvent(FLayerEvent.EVENT_SHOW_QUALITY_RADIAOS));
            sendNotification(ApplicationFacade.NOTI_START_PLAY);
            return;
        }// end function

    }
}
