package com.cntv.player.playerCom.controlBar.view.nba
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

    public class iconNba extends CommonSprite
    {
        private var swf:SWFLoader;
        private var isFirstSeek:Boolean = true;
        public static const W:Number = 500;
        public static const H:Number = 170;
        public static const CONTENT_W:Number = 450;
        public static const CONTENT_H:Number = 140;
        public static const EVENT_START_SHOW:String = "icanNBA.start";
        public static const EVENT_SHOW2:String = "hotmap.show2";
        public static const EVENT_SEEK:String = "icanNBA.seek";
        public static const EVENT_RESIZE:String = "icanNBA.resize";
        public static const Event_getCurrentTime:String = "icanNBA.getTime";
        public static const Event_CurrentTime:String = "icanNBA.currentTime";
        public static const Event_CHANGE_BAR:String = "icanNBA.changeBar";
        public static const EVENT_SEEK_VIDEO:String = "hotmap.seek.video";
        public static const EVENT_REMOVE_DOTS:String = "hotmap.remove";
        public static const EVENT_DOT_MOVE_OVER:String = "dot.move.over";
        public static const Event_SuggestClicked:String = "hotmap.suggestClicked";
        public static const Event_pauseVideo:String = "hotmap.pause.video";
        public static const Event_User_Seek:String = "hotmap.user.seek";
        public static var suggested:Boolean = false;
        public static var playedTime:Number = 0;

        public function iconNba()
        {
            _modelLocator = ModelLocator.getInstance();
            this.addEventListener(Event.ADDED_TO_STAGE, this.start);
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
            new SWFLoader(new URLRequest(_modelLocator.paramVO.icanNBAPath + "?t=" + Math.random()), this.getNbaSwf, this.getNbaSwfErr);
            return;
        }// end function

        private function getNbaSwf(param1:DisplayObject) : void
        {
            this.swf = param1 as SWFLoader;
            this.swf.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadHMComplete);
            this.swf.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadHMError);
            this.swf.content.addEventListener(EVENT_SEEK, this.getSeek);
            return;
        }// end function

        private function loadHMComplete(event:Event) : void
        {
            this.addChild(this.swf);
            this.swf.content.dispatchEvent(new CommonEvent(EVENT_START_SHOW, _modelLocator.paramVO.icanNBADataPath + "?pid=" + _modelLocator.paramVO.videoCenterId));
            MemClean.run();
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

        private function seekPacage(param1:String = "", param2:String = "") : void
        {
            var _loc_3:* = param2;
            var _loc_4:Array = [];
            var _loc_5:* = new ValueOBJ("t", param1);
            _loc_4.push(_loc_5);
            _loc_5 = new ValueOBJ("v", _loc_3);
            _loc_4.push(_loc_5);
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_NBA_MAP_DATA, _loc_4));
            return;
        }// end function

        private function getSeek(event:Event) : void
        {
            if (this.isFirstSeek)
            {
                this.isFirstSeek = false;
            }
            _dispatcher.dispatchEvent(new CommonEvent(EVENT_SEEK_VIDEO, event["data"]));
            return;
        }// end function

        private function loadHMError(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function getNbaSwfErr(param1:String) : void
        {
            return;
        }// end function

        public function resize() : void
        {
            try
            {
                this.swf.content.dispatchEvent(new CommonEvent(EVENT_RESIZE, stage.stageWidth));
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function onAddHotDot(event:Event) : void
        {
            try
            {
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
