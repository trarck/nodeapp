package com.cntv.common.tools.recorder
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.utils.net.request.*;
    import flash.system.*;

    public class QualityMonitor extends Object
    {
        private var _locator:ModelLocator;
        private var _dispatcher:GlobalDispatcher;
        private var _isOpenQM:Boolean = false;
        private var _frequency:Number = 0;
        private var hasSentLoadDataTime:Boolean = false;
        private var hasSentLoadVideoTime:Boolean = false;
        private var hasSentError:Boolean = false;
        private var hasSentBuffer:Boolean = false;
        private var hasSentFrameSkip:Boolean = false;
        private var frameSkipTime:int = 0;
        private var hasSentSeekTime:Boolean = false;
        private var hasSentMemory:Boolean = false;
        private var hasSentSwitch:int = 0;
        private var hasSentSwitchBuffer:Boolean = true;
        private var hasSentSmoothRate:Boolean = false;
        private var hasSentBestRate:Boolean = false;
        private var hasSentBandWidth:Boolean = false;
        private var hasSentAdDataLoad:Boolean = false;
        private var hasSentPlayeriInit:Boolean = false;

        public function QualityMonitor()
        {
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            this._locator = ModelLocator.getInstance();
            this._dispatcher = GlobalDispatcher.getInstance();
            this._frequency = 1 / this._locator.paramVO.qmFrequency;
            var _loc_1:* = Math.random();
            this.initListeners();
            if (this._locator.paramVO.qmServerPath != null && this._frequency >= _loc_1)
            {
                this._isOpenQM = true;
                _loc_2 = [];
                _loc_3 = new ValueOBJ("t", "init");
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("v", "0");
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("isHaveAD", this._locator.paramVO.adCall != "" ? ("true") : ("false"));
                _loc_2.push(_loc_3);
                this.qmPlayerInit(new QualityMonitorEvent(QualityMonitorEvent.EVENT_PLAYER_INIT, _loc_2));
                ;
            }
            return;
        }// end function

        private function initListeners() : void
        {
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_LOAD_DATA_TIME, this.qmLoadDataTime);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_LOAD_VIDEO_TIME, this.qmLoadVideoTime);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_LOAD_VIDEO_TIME_OUT, this.qmLoadVideoTimeOut);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_VDDSUCCESS_BY_RETRY, this.qmLoadVddAgainSuccess);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_SEEK_CODE, this.qmSeekCode);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_CONFIGSUCCESS_BY_RETRY, this.qmLoadConfigAgainSuccess);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_RECONNECT_SERVER, this.reConnectSever);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_NOTICE_STREAM_RATE_FAILED, this.tellStreamFailed);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_ERROR, this.qmError);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_AFFLUENT, this.qmBuffer);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_BUFFER_TIME_OUT, this.bufferTimeOut);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_FRAME_SKIP, this.qmFrameSkip);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_SEEK_TIME, this.qmSeekTime);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_MEMORY, this.qmMemory);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_SWITCH, this.qmSwitch);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_SWITCH_BUFFER, this.qmSwitchBuffer);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_SMOOTH_RATE, this.qmSmoothRate);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_BEST_RATE, this.qmBestRate);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_BAND_WIDTH, this.qmBandWidth);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_LOAD_AD_DATA, this.qmLoadADData);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_PLAYER_INIT, this.qmPlayerInit);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_HOT_MAP, this.qmHotmap);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_BUTTON_CLICK, this.qmButtonClick);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_HOT_CLICKED, this.hotMapClicked);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_HOT_MAP_DATA, this.hotMapEvent);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_BUFFER_LENGTH, this.buffeLength);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_PLAY_LENGTH, this.playLength);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_SEND_COMMON, this.sendCommon);
            this._dispatcher.addEventListener(QualityMonitorEvent.EVENT_RELATIVE_CLICKED, this.relativeClicked);
            return;
        }// end function

        private function qmHotmap(event:QualityMonitorEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            if (this._isOpenQM)
            {
                _loc_2 = event.data as Array;
                _loc_3 = new ValueOBJ("referrer", this._locator.paramVO.referrer);
                _loc_2.push(_loc_3);
                this.sendSortedData(this._locator.paramVO.qmServerPath, _loc_2);
            }
            return;
        }// end function

        private function hotMapClicked(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentSeekTime = true;
            }
            return;
        }// end function

        private function hotMapEvent(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            }
            return;
        }// end function

        private function nbaMapEvent(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            }
            return;
        }// end function

        private function qmButtonClick(event:QualityMonitorEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            if (this._isOpenQM)
            {
                _loc_2 = [];
                _loc_3 = new ValueOBJ("t", "bc");
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("v", event.data as String);
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("referrer", this._locator.paramVO.referrer);
                _loc_2.push(_loc_3);
                this.sendSortedData(this._locator.paramVO.qmServerPath, _loc_2);
            }
            return;
        }// end function

        private function qmLoadADData(event:QualityMonitorEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            if (this._isOpenQM && !this.hasSentAdDataLoad)
            {
                _loc_2 = event.data as Array;
                _loc_3 = new ValueOBJ("referrer", this._locator.paramVO.referrer);
                _loc_2.push(_loc_3);
                this.sendSortedData(this._locator.paramVO.qmServerPath, _loc_2);
                this.hasSentAdDataLoad = true;
            }
            return;
        }// end function

        private function qmPlayerInit(event:QualityMonitorEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            if (this._isOpenQM && !this.hasSentPlayeriInit)
            {
                _loc_2 = event.data as Array;
                _loc_3 = new ValueOBJ("referrer", this._locator.paramVO.referrer);
                _loc_2.push(_loc_3);
                this.sendSortedData(this._locator.paramVO.qmServerPath, _loc_2);
                this.hasSentPlayeriInit = true;
            }
            return;
        }// end function

        private function qmLoadDataTime(event:QualityMonitorEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            if (this._isOpenQM && !this.hasSentLoadDataTime)
            {
                _loc_2 = event.data as Array;
                _loc_3 = new ValueOBJ("referrer", this._locator.paramVO.referrer);
                _loc_2.push(_loc_3);
                this.sendSortedData(this._locator.paramVO.qmServerPath, _loc_2);
                this.hasSentLoadDataTime = true;
            }
            return;
        }// end function

        private function reConnectSever(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            }
            return;
        }// end function

        private function tellStreamFailed(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            }
            return;
        }// end function

        private function qmLoadVddAgainSuccess(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            }
            return;
        }// end function

        private function qmSeekCode(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            }
            return;
        }// end function

        private function qmLoadConfigAgainSuccess(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            }
            return;
        }// end function

        private function qmLoadVideoTimeOut(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM && !this.hasSentLoadVideoTime)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            }
            return;
        }// end function

        private function qmLoadVideoTime(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM && !this.hasSentLoadVideoTime)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentLoadVideoTime = true;
            }
            return;
        }// end function

        private function qmError(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            }
            return;
        }// end function

        private function bufferTimeOut(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM && !this.hasSentBuffer)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentBuffer = true;
            }
            return;
        }// end function

        private function sendCommon(event:QualityMonitorEvent) : void
        {
            this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            return;
        }// end function

        private function relativeClicked(event:QualityMonitorEvent) : void
        {
            this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            return;
        }// end function

        private function buffeLength(event:QualityMonitorEvent) : void
        {
            this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            return;
        }// end function

        private function playLength(event:QualityMonitorEvent) : void
        {
            this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
            return;
        }// end function

        private function qmBuffer(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM && !this.hasSentBuffer)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentBuffer = true;
            }
            return;
        }// end function

        private function qmFrameSkip(event:QualityMonitorEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            if (this._isOpenQM && !this.hasSentFrameSkip)
            {
                _loc_2 = event.data as Array;
                _loc_3 = new ValueOBJ("wmode", ModelLocator.getInstance().paramVO.wmode);
                _loc_2.push(_loc_3);
                this.sendSortedData(this._locator.paramVO.qmServerPath, _loc_2);
                var _loc_4:String = this;
                var _loc_5:* = this.frameSkipTime + 1;
                _loc_4.frameSkipTime = _loc_5;
                if (this.frameSkipTime >= 2)
                {
                    this.hasSentFrameSkip = true;
                }
            }
            return;
        }// end function

        private function qmSeekTime(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM && !this.hasSentSeekTime)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentSeekTime = true;
            }
            return;
        }// end function

        private function qmMemory(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM && !this.hasSentMemory)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentMemory = true;
            }
            return;
        }// end function

        private function qmSwitch(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentSwitchBuffer = false;
            }
            return;
        }// end function

        private function qmSwitchBuffer(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM && !this.hasSentSwitchBuffer)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentSwitchBuffer = true;
            }
            return;
        }// end function

        private function qmSmoothRate(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM && !this.hasSentSmoothRate)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentSmoothRate = true;
            }
            return;
        }// end function

        private function qmBestRate(event:QualityMonitorEvent) : void
        {
            if (this._isOpenQM && !this.hasSentBestRate)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentBestRate = true;
            }
            return;
        }// end function

        private function qmBandWidth(event:QualityMonitorEvent) : void
        {
            if (!this.hasSentBandWidth)
            {
                this.sendSortedData(this._locator.paramVO.qmServerPath, event.data as Array);
                this.hasSentBandWidth = true;
            }
            return;
        }// end function

        private function sendSortedData(param1:String, param2:Array) : void
        {
            var url:* = param1;
            var attr:* = param2;
            var vo:* = new ValueOBJ("pid", this._locator.paramVO.videoCenterId);
            attr.push(vo);
            vo = new ValueOBJ("file", this._locator.currentFile);
            attr.push(vo);
            vo = new ValueOBJ("ver", ModelLocator.VERSION_SHORT);
            attr.push(vo);
            vo = new ValueOBJ("tai", this._locator.paramVO.tai);
            attr.push(vo);
            vo = new ValueOBJ("fpv", Capabilities.version.replace(" ", "_"));
            attr.push(vo);
            vo = new ValueOBJ("guid", this._locator.guid);
            attr.push(vo);
            vo = new ValueOBJ("isp2p", this._locator.isUseP2P.toString());
            attr.push(vo);
            vo = new ValueOBJ("pf", "flash");
            attr.push(vo);
            vo = new ValueOBJ("abroad", String(this._locator.paramVO.is_abroad));
            attr.push(vo);
            var cdnLogUrl:* = this._locator.paramVO.qmServerPath2;
            var attrObj2:* = new AttributeSortVo(cdnLogUrl, attr);
            var attrObj3:* = new AttributeSortVo(this._locator.paramVO.qmServerPath3, attr);
            try
            {
                new HttpSortRequest(attrObj2, this.submitSuccess, this.submitError);
                if (this._locator.paramVO.qmServerPath3 != "" && this._locator.paramVO.qmServerPath3.length > 10)
                {
                    new HttpSortRequest(attrObj3, this.submitSuccess, this.submitError);
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function submitSuccess(param1:Object) : void
        {
            return;
        }// end function

        private function submitError() : void
        {
            return;
        }// end function

    }
}
