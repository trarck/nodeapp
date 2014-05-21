package com.cntv.player.playerCom.controlBar.view.hotDot
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.tools.memory.*;
    import com.cntv.common.view.ui.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class HotDot extends CommonSprite
    {
        private var swf:SWFLoader;
        private var isMatch:Boolean = false;
        private var addedDots:Boolean = false;
        private var isFirstSeek:Boolean = true;
        public static const W:Number = 500;
        public static const H:Number = 170;
        public static const CONTENT_W:Number = 450;
        public static const CONTENT_H:Number = 140;
        public static const EVENT_SHOW:String = "hotmap.show";
        public static const EVENT_SHOW2:String = "hotmap.show2";
        public static const EVENT_SEEK:String = "hotmap.seek";
        public static const EVENT_RESIZE:String = "hotmap.resize";
        public static const EVENT_SEEK_VIDEO:String = "hotmap.seek.video";
        public static const EVENT_ADD:String = "hotmap.add";
        public static const EVENT_CAHNGE_VIDEO:String = "change.video";
        public static const EVENT_REMOVE_DOTS:String = "hotmap.remove";
        public static const EVENT_DOT_MOVE_OVER:String = "dot.move.over";
        public static const Event_CHANGE_BAR:String = "hotmap.changeBar";
        public static const Event_getCurrentTime:String = "hotmap.getTime";
        public static const Event_CurrentTime:String = "hotmap.currentTime";
        public static const Event_SuggestClicked:String = "hotmap.suggestClicked";
        public static const Event_pauseVideo:String = "hotmap.pause.video";
        public static const Event_User_Seek:String = "hotmap.user.seek";
        public static var suggested:Boolean = false;
        public static var playedTime:Number = 0;

        public function HotDot(param1:Boolean = false)
        {
            this.isMatch = param1;
            _modelLocator = ModelLocator.getInstance();
            this.addEventListener(Event.ADDED_TO_STAGE, this.start);
            _dispatcher.addEventListener(EVENT_ADD, this.onAddHotDot);
            this.addedDots = false;
            return;
        }// end function

        private function start(event:Event) : void
        {
            this.startLoad();
            return;
        }// end function

        public function startLoad() : void
        {
            _modelLocator.hotDotPluginLoaded = false;
            MemClean.run();
            new SWFLoader(new URLRequest(_modelLocator.paramVO.hotmapPath + "?t=" + Math.random()), this.getHotmap, this.getHotmapErr);
            return;
        }// end function

        private function getHotmap(param1:DisplayObject) : void
        {
            this.swf = param1 as SWFLoader;
            this.swf.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadHMComplete);
            this.swf.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadHMError);
            _modelLocator.hotDotPluginLoaded = true;
            return;
        }// end function

        private function loadHMComplete(event:Event) : void
        {
            this.addChild(this.swf);
            MemClean.run();
            if (this.isMatch)
            {
                this.swf.content.dispatchEvent(new HotmapEvent(EVENT_SHOW, _modelLocator.paramVO.hotmapData, stage.stageWidth, 98, "", _modelLocator.paramVO.matchData.isPrecise, _modelLocator.matchStartime));
                if (_modelLocator.paramVO.matchData.isPrecise)
                {
                    this.seekPacage("loadcpid", "loadcpid");
                }
                else
                {
                    this.seekPacage("loadppid", "loadppid");
                }
                this.swf.content.addEventListener(EVENT_DOT_MOVE_OVER, this.onDotMoveOver);
            }
            else
            {
                this.seekPacage("loadppid", "loadppid");
                this.swf.content.dispatchEvent(new HotmapEvent(EVENT_SHOW, _modelLocator.paramVO.hotmapData, stage.stageWidth, 98, _modelLocator.paramVO.hotmapDataPath + "?pid=" + _modelLocator.paramVO.videoCenterId + "&t=" + Math.random()));
            }
            this.swf.content.addEventListener(EVENT_SEEK, this.getSeek);
            this.swf.content.addEventListener(EVENT_CAHNGE_VIDEO, this.changeVideo);
            this.swf.content.addEventListener(Event_getCurrentTime, this.onGetTime);
            this.swf.content.addEventListener(Event_SuggestClicked, this.onSuggestClicked);
            _modelLocator.hotDotPluginLoaded = true;
            return;
        }// end function

        private function onSuggestClicked(event:Event) : void
        {
            suggested = false;
            _dispatcher.dispatchEvent(new CommonEvent(Event_pauseVideo));
            return;
        }// end function

        public function userSeek(param1:Number) : void
        {
            if (this.swf != null)
            {
                this.swf.content.dispatchEvent(new CommonEvent(Event_User_Seek, param1));
            }
            return;
        }// end function

        public function setCurrentTime(param1:Number) : void
        {
            if (this.swf != null)
            {
                this.swf.content.dispatchEvent(new CommonEvent(Event_CurrentTime, param1));
            }
            return;
        }// end function

        private function onGetTime(event:Event) : void
        {
            return;
        }// end function

        private function onDotMoveOver(event:Event) : void
        {
            this.dispatchEvent(new Event("cancelHoldeBar"));
            return;
        }// end function

        private function changeVideo(event:Event) : void
        {
            this.seekPacage("hpjmp", "changevideo");
            if (event["time"] != null)
            {
                _modelLocator.matchStartime = Number(event["time"]);
            }
            _modelLocator.paramVO.hotmapData = null;
            _modelLocator.hotDotPluginLoaded = false;
            this.swf.content.dispatchEvent(new Event(EVENT_REMOVE_DOTS));
            this.swf.content.removeEventListener(EVENT_CAHNGE_VIDEO, this.changeVideo);
            this.swf.content.removeEventListener(EVENT_SEEK, this.getSeek);
            this.swf.content.removeEventListener(EVENT_DOT_MOVE_OVER, this.onDotMoveOver);
            this.swf.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.loadHMComplete);
            this.swf.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.loadHMError);
            this.swf.content.removeEventListener(Event_SuggestClicked, this.onSuggestClicked);
            this.removeChild(this.swf);
            this.swf = null;
            _modelLocator.paramVO.isFromPrecise = true;
            this.dispatchEvent(new Event("releaseDot"));
            _dispatcher.removeEventListener(EVENT_ADD, this.onAddHotDot);
            _dispatcher.dispatchEvent(new CommonEvent(EVENT_CAHNGE_VIDEO));
            return;
        }// end function

        private function seekPacage(param1:String = "", param2:String = "") : void
        {
            var _loc_3:* = param2;
            var _loc_4:Array = [];
            var _loc_5:* = new ValueOBJ("t", param1);
            _loc_4.push(_loc_5);
            _loc_5 = new ValueOBJ("v", _loc_3);
            _loc_4.push(_loc_5);
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_HOT_MAP_DATA, _loc_4));
            return;
        }// end function

        private function getSeek(event:Event) : void
        {
            if (this.isFirstSeek)
            {
                this.isFirstSeek = false;
                this.seekPacage("firClcik", "seekVideo");
            }
            _dispatcher.dispatchEvent(new CommonEvent(EVENT_SEEK_VIDEO, event["time"]));
            return;
        }// end function

        private function loadHMError(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function getHotmapErr(param1:String) : void
        {
            return;
        }// end function

        public function resize() : void
        {
            try
            {
                this.swf.content.dispatchEvent(new HotmapEvent(EVENT_RESIZE, _modelLocator.paramVO.hotmapData, stage.stageWidth, 70, _modelLocator.paramVO.hotmapDataPath + "?pid=" + _modelLocator.paramVO.videoCenterId + "&t=" + Math.random()));
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function onAddHotDot(event:Event) : void
        {
            if (this.addedDots)
            {
                return;
            }
            this.addedDots = true;
            try
            {
                this.swf.content.dispatchEvent(new CommonEvent(EVENT_ADD, ModelLocator.getInstance().paramVO.matchData.options));
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function showOrHide(param1:Boolean = true) : void
        {
            if (param1)
            {
                this.swf.content.dispatchEvent(new CommonEvent(Event_CHANGE_BAR, "wide"));
            }
            else
            {
                this.swf.content.dispatchEvent(new CommonEvent(Event_CHANGE_BAR, "narrow"));
            }
            return;
        }// end function

        private function hideOver() : void
        {
            this.visible = false;
            return;
        }// end function

    }
}
