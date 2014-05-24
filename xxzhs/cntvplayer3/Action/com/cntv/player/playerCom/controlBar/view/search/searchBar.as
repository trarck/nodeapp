package com.cntv.player.playerCom.controlBar.view.search
{
    import com.cntv.common.model.*;
    import com.cntv.common.view.ui.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class searchBar extends CommonSprite
    {
        private var swf:SWFLoader;

        public function searchBar(param1:Boolean = false)
        {
            _modelLocator = ModelLocator.getInstance();
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
            new SWFLoader(new URLRequest(_modelLocator.paramVO.searchBarPath + "?t=" + Math.random()), this.getBar, this.getBarErr);
            return;
        }// end function

        private function getBar(param1:DisplayObject) : void
        {
            this.swf = param1 as SWFLoader;
            this.swf.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadHMComplete);
            this.swf.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadHMError);
            return;
        }// end function

        private function loadHMComplete(event:Event) : void
        {
            this.addChild(this.swf);
            this.swf.content.dispatchEvent(new CommonEvent("showBar", stage.stageWidth));
            return;
        }// end function

        private function seekPacage(param1:String = "", param2:String = "") : void
        {
            return;
        }// end function

        private function getSeek(event:Event) : void
        {
            return;
        }// end function

        private function loadHMError(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function getBarErr(param1:String) : void
        {
            return;
        }// end function

        public function resize() : void
        {
            try
            {
                this.swf.content.dispatchEvent(new CommonEvent("reSize", stage.stageWidth));
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
