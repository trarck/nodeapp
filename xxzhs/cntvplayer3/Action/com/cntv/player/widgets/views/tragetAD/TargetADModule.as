package com.cntv.player.widgets.views.tragetAD
{
    import com.cntv.common.view.ui.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class TargetADModule extends CommonSprite
    {
        private var plugPath:String = "http://adhand.cn/newpart/mod/cntv/TargetAd.swf";
        private var targetAd:Object;
        private var _loader:Loader;
        private var content:Sprite;
        private var _vx:Number = 0;
        private var _vy:Number = 0;

        public function TargetADModule()
        {
            return;
        }// end function

        public function startUp(param1:String, param2:Number, param3:Number) : void
        {
            this.release();
            this._vx = param2;
            this._vy = param3;
            var _loc_4:* = new URLRequest(this.plugPath);
            this._loader = new Loader();
            var _loc_5:* = new LoaderContext();
            new LoaderContext().applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            _loc_5.securityDomain = SecurityDomain.currentDomain;
            _loc_5.checkPolicyFile = false;
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onLoadError);
            this._loader.load(_loc_4);
            return;
        }// end function

        protected function onLoadError(event:Event) : void
        {
            return;
        }// end function

        protected function onLoadComplete(event:Event) : void
        {
            this.content = event.target.content;
            this.targetAd = this.content as Object;
            this.targetAd.addEventListener("AdLoaded", this.onAdLoaded);
            this.targetAd.initAd(stage.stageWidth, stage.stageHeight, false, 0, "", this.getInitData(), this._vx, this._vy);
            this.addChild(this.content);
            return;
        }// end function

        private function onAdLoaded(param1) : void
        {
            this.targetAd.startAd();
            return;
        }// end function

        private function getInitData() : Object
        {
            var _loc_1:* = new Object();
            var _loc_2:Number = 450;
            if (_modelLocator.currentVideoInfo.isRtmp)
            {
                _loc_1.videoId = _modelLocator.paramVO.videoCenterId + "_" + _modelLocator.currentVideoClipIndex;
            }
            else if (_modelLocator.currentHttpBiteRateMode == 0)
            {
                _loc_1.videoId = _modelLocator.paramVO.videoCenterId + "SD_" + _modelLocator.currentVideoClipIndex;
                _loc_1.videoUrl = _modelLocator.currentVideoInfo.chapters[_modelLocator.currentVideoClipIndex].url;
            }
            else if (_modelLocator.currentHttpBiteRateMode == 1)
            {
                _loc_2 = 850;
                _loc_1.videoId = _modelLocator.paramVO.videoCenterId + "HD_" + _modelLocator.currentVideoClipIndex;
                _loc_1.videoUrl = _modelLocator.currentVideoInfo.chapters2[_modelLocator.currentVideoClipIndex].url;
            }
            _loc_1.videoName = _modelLocator.currentVideoInfo.title;
            _loc_1.startTime = 0;
            _loc_1.site = "cntv";
            _loc_1.bitrate = _loc_2;
            _loc_1.channel = _modelLocator.paramVO.tai;
            _loc_1.index = 0;
            _loc_1.policy = "MILD";
            return _loc_1;
        }// end function

        override protected function release() : void
        {
            if (this._loader != null)
            {
                this.content.removeEventListener("AdLoaded", this.onAdLoaded);
                this.removeChild(this.content);
                this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoadComplete);
                this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
                this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onLoadError);
                this._loader = null;
                this.targetAd = null;
            }
            return;
        }// end function

        public function updateUrl(param1:String, param2:Number) : void
        {
            if (this.targetAd)
            {
                this.targetAd.updateVideoUrl(param1, param2 * 1000);
            }
            return;
        }// end function

        public function updateTime(param1:Number) : void
        {
            if (this.targetAd)
            {
                this.targetAd.updateVideoTime(param1 * 1000);
            }
            return;
        }// end function

        public function updateSize(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean = false) : void
        {
            if (this.targetAd)
            {
                this.targetAd.resizeAd(param1, param2, param5, param3, param4);
            }
            return;
        }// end function

        public function onShowAd_handler() : void
        {
            return;
        }// end function

        public function onHideAd_handler() : void
        {
            return;
        }// end function

        public function onClickAd_handler() : void
        {
            return;
        }// end function

        public function onRollOverAd_handler() : void
        {
            return;
        }// end function

        public function onRollOutAd_handler() : void
        {
            return;
        }// end function

        public function onAdLoadStatus_handler(param1:Number) : void
        {
            if (param1 == 0)
            {
            }
            return;
        }// end function

    }
}
