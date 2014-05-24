package com.cntv.player.playerCom.video.view.cycle
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.memory.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.playerCom.video.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.cntv.player.playerCom.video.view.audio.*;
    import com.cntv.player.playerCom.video.view.http.*;
    import com.cntv.player.playerCom.video.view.vod.*;
    import com.utils.net.request.*;
    import flash.external.*;
    import flash.utils.*;

    public class CyclePlayer extends VideoBase
    {
        private var player:VideoBase;
        private var startTime:Number = 0;
        private var useNowTime:Boolean = true;

        public function CyclePlayer()
        {
            _modelLocator.ntcDate = new Date();
            if (_modelLocator.cycleList.length != 0)
            {
                _modelLocator.cycleIndex = this.toNowPlayingIndex(1);
            }
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_CYCLE_PLAY_NEXT, this.playNextInCycle);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_CYCLE_CHARGE_TO_HTTP, this.chargeToHttp);
            setTimeout(this.addNewCallBack, 1000);
            return;
        }// end function

        private function addNewCallBack() : void
        {
            if (ExternalInterface.available && _modelLocator.ISWEBSITE)
            {
                ExternalInterface.addCallback("changeCycleChannel", this.changeCycleChannel);
            }
            return;
        }// end function

        override public function play() : void
        {
            var _loc_1:Array = null;
            var _loc_2:ValueOBJ = null;
            var _loc_3:StatusVO = null;
            if (_modelLocator.cycleList.length != 0 && this.useNowTime)
            {
                _modelLocator.cycleIndex = this.toNowPlayingIndex(2);
                this.useNowTime = false;
            }
            else
            {
                this.startTime = 0;
            }
            if (_modelLocator.cycleIndex != -1)
            {
                _modelLocator.currentVideoInfo = _modelLocator.cycleList[_modelLocator.cycleIndex];
                if (_modelLocator.paramVO.playBackMode == "audio" && _modelLocator.currentAudioInfo != null)
                {
                    this.player = new AudioPlayer();
                }
                else if (_modelLocator.currentVideoInfo != null)
                {
                    if (_modelLocator.currentVideoInfo.isRtmp)
                    {
                        this.player = new VodPlayer(this.startTime);
                    }
                    else
                    {
                        this.player = new HttpPlayer(this.startTime);
                    }
                    this.addChild(this.player);
                    this.player.play();
                }
                else
                {
                    _loc_1 = [];
                    _loc_2 = new ValueOBJ("t", "err");
                    _loc_1.push(_loc_2);
                    _loc_2 = new ValueOBJ("v", QualityMonitorEvent.ERROR_PLAY_LIST_EMPTY);
                    _loc_1.push(_loc_2);
                    _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_1));
                    _loc_3 = new StatusVO(_modelLocator.i18n.ERROR_PLAY_LIST_EMPTY, StatuBoxEvent.TYPE_CENTER, true);
                    _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_3));
                }
            }
            return;
        }// end function

        private function playNextInCycle(event:VideoPlayEvent) : void
        {
            if (this.player != null && this.contains(this.player))
            {
                this.removeChild(this.player);
            }
            if ((_modelLocator.cycleIndex + 1) != _modelLocator.cycleList.length)
            {
                var _loc_2:* = _modelLocator;
                var _loc_3:* = _modelLocator.cycleIndex + 1;
                _loc_2.cycleIndex = _loc_3;
                _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_LOADING, null));
                _modelLocator.recordManager.setVideoChange();
                this.play();
            }
            else
            {
                _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_CYCLE_PLAY_OVER));
            }
            return;
        }// end function

        private function changeCycleChannel(param1:String) : void
        {
            if (this.player != null)
            {
                this.player.clear();
                if (this.contains(this.player))
                {
                    this.removeChild(this.player);
                }
            }
            this.player = null;
            MemClean.run();
            _modelLocator.paramVO.hour24DataURL = param1;
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_CYCLE_PLAY_OVER));
            return;
        }// end function

        private function chargeToHttp(event:VideoPlayEvent) : void
        {
            var e:* = event;
            if ((_modelLocator.cycleIndex + 1) != _modelLocator.cycleList.length)
            {
                if (_modelLocator.cycleList[(_modelLocator.cycleIndex + 1)]["isRtmp"] == false)
                {
                    try
                    {
                        var _loc_3:* = _modelLocator;
                        var _loc_4:* = _modelLocator.cycleIndex + 1;
                        _loc_3.cycleIndex = _loc_4;
                        _modelLocator.currentVideoInfo = _modelLocator.cycleList[_modelLocator.cycleIndex];
                        this.player.chargeHttp();
                    }
                    catch (e:Error)
                    {
                    }
                }
            }
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            if (this.player != null)
            {
                this.player.seek(param1);
            }
            return;
        }// end function

        override public function pause() : void
        {
            if (this.player != null)
            {
                this.player.pause();
            }
            return;
        }// end function

        override public function resume() : void
        {
            if (this.player != null)
            {
                this.player.resume();
            }
            return;
        }// end function

        override public function muteOn() : void
        {
            if (this.player != null)
            {
                this.player.muteOn();
            }
            return;
        }// end function

        override public function muteOff() : void
        {
            if (this.player != null)
            {
                this.player.muteOff();
            }
            return;
        }// end function

        override public function setBrightness(param1:int) : void
        {
            if (this.player != null)
            {
                this.player.setBrightness(param1);
            }
            return;
        }// end function

        override public function setContrast(param1:Number) : void
        {
            if (this.player != null)
            {
                this.player.setContrast(param1);
            }
            return;
        }// end function

        override public function screenWide() : void
        {
            if (this.player != null)
            {
                this.player.screenWide();
            }
            return;
        }// end function

        override public function screenNormal() : void
        {
            if (this.player != null)
            {
                this.player.screenNormal();
            }
            return;
        }// end function

        override public function setVolume(param1:Number) : void
        {
            if (this.player != null)
            {
                this.player.setVolume(param1);
            }
            return;
        }// end function

        private function toNowPlayingIndex(param1:int) : int
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:VideoInfoVo = null;
            var _loc_2:* = _modelLocator.ntcDate.getHours() * 3600 + _modelLocator.ntcDate.getMinutes() * 60 + _modelLocator.ntcDate.getSeconds();
            _loc_3 = 0;
            _loc_4 = 0;
            while (_loc_4 < _modelLocator.cycleList.length)
            {
                
                _loc_5 = VideoInfoVo(_modelLocator.cycleList[_loc_4]);
                _loc_3 = _loc_3 + _loc_5.length;
                if (_loc_2 <= _loc_3)
                {
                    this.startTime = _loc_5.length - (_loc_3 - _loc_2);
                    break;
                }
                _loc_4++;
            }
            if (_loc_4 == _modelLocator.cycleList.length)
            {
                _loc_4 = _modelLocator.cycleList.length - 1;
            }
            return _loc_4;
        }// end function

    }
}
