package 
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.tools.string.*;
    import com.cntv.player.floatLayer.*;
    import com.cntv.player.playerCom.statuBox.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.ui.*;
    import flash.utils.*;

    public class Main extends Sprite
    {
        public var param:Object;
        public var statuBox:StatuBoxView;
        public var floatLayer:FloatLayer;
        private var lc2:LocalConnection;
        private var miniStartTimer:Timer;
        private var _dispatcher:GlobalDispatcher;
        private var _locator:ModelLocator;
        public static const NAME:String = "Main";

        public function Main() : void
        {
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        private function init(event:Event = null) : void
        {
            var _loc_5:String = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            Security.allowDomain("*");
            stage.scaleMode = "noScale";
            stage.align = "TL";
            this._dispatcher = GlobalDispatcher.getInstance();
            this._locator = ModelLocator.getInstance();
            this._locator.guid = GUID.create();
            this._locator.i18n = new I18nLanguageVO();
            this.param = LoaderInfo(root.loaderInfo).parameters;
            ModelLocator.getInstance().paramVO = new ParameterVO(this.param);
            if (!this._locator.ISWEBSITE)
            {
                _loc_5 = this._locator.paramVO.tai;
                if (_loc_5 == "arabic" || _loc_5 == "english" || _loc_5 == "russian" || _loc_5 == "spanish" || _loc_5 == "france")
                {
                    this._locator.paramVO.showRelative = false;
                    this._locator.paramVO.relativeListUrl = "";
                }
            }
            var _loc_2:Boolean = false;
            var _loc_3:Number = 0;
            var _loc_4:* = RefHtmlGenerator.getRefUrl();
            if (RefHtmlGenerator.getRefUrl() != null && _loc_4.indexOf("?pid=") > 0)
            {
                _loc_6 = _loc_4.split("?pid=");
                if (_loc_6[1] != "" && _loc_6[1].indexOf("=") > 0)
                {
                    _loc_7 = _loc_6[1].split("=");
                    if (_loc_7[0] == ModelLocator.getInstance().paramVO.videoCenterId)
                    {
                        _loc_2 = true;
                        if (_loc_7[1].indexOf("%3f") > 0)
                        {
                            _loc_7[1] = String(_loc_7[1]).replace("%3f", "");
                        }
                        _loc_3 = Number(_loc_7[1]);
                    }
                }
            }
            if (_loc_2)
            {
                ModelLocator.getInstance().paramVO.adCall = "";
                ModelLocator.getInstance().paramVO.isPlay3rdAd = false;
                ModelLocator.getInstance().paramVO.startTime = _loc_3;
            }
            this.setMenu();
            this.setScreenSize();
            if (_loc_4 != null && _loc_4.indexOf("smallwindow") > 0)
            {
                this.lc2 = new LocalConnection();
                this.lc2.allowDomain("*");
                this.lc2.client = this;
                try
                {
                    this.lc2.connect("_cntvMiniPlayer");
                }
                catch (e:Error)
                {
                }
                this.lc2.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.lcAsynError);
                this.lc2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.lcSecurityError);
                this.lc2.addEventListener(StatusEvent.STATUS, this.lcStatu);
                this.updataMiniStatus(null);
                this.miniStartTimer = new Timer(3000);
                this.miniStartTimer.addEventListener(TimerEvent.TIMER, this.updataMiniStatus);
                this.miniStartTimer.start();
            }
            else
            {
                this.setLocalData();
            }
            this.floatLayer = new FloatLayer();
            stage.addChild(this.floatLayer);
            this.statuBox = new StatuBoxView();
            stage.addChild(this.statuBox);
            ApplicationFacade.getInstance(NAME).startUp(this);
            return;
        }// end function

        private function setMenu() : void
        {
            var _loc_2:ContextMenuItem = null;
            var _loc_1:* = new ContextMenu();
            if (ModelLocator.getInstance().ISWEBSITE)
            {
                _loc_2 = new ContextMenuItem("cntv player " + ModelLocator.VERSION_SHORT, true);
            }
            else
            {
                _loc_2 = new ContextMenuItem("cntv outside player  " + ModelLocator.VERSION_SHORT, true);
            }
            _loc_1.customItems.push(_loc_2);
            _loc_1.hideBuiltInItems();
            _loc_1.builtInItems.forwardAndBack = false;
            _loc_1.builtInItems.loop = false;
            _loc_1.builtInItems.play = false;
            _loc_1.builtInItems.print = false;
            _loc_1.builtInItems.quality = false;
            _loc_1.builtInItems.rewind = false;
            _loc_1.builtInItems.save = false;
            _loc_1.builtInItems.zoom = false;
            this.contextMenu = _loc_1;
            return;
        }// end function

        private function setLocalData() : void
        {
            var _loc_1:* = ShareObjecter.getObject("cntvPlayerOptions", "/");
            if (_loc_1 != null)
            {
                if (_loc_1["data"]["isRemenberLastTime"] != null)
                {
                    this._locator.isRemenberLastTime = _loc_1["data"]["isRemenberLastTime"];
                }
                if (this._locator.isRemenberLastTime && _loc_1["data"]["lastVideoCenterId"] == this._locator.paramVO.videoCenterId)
                {
                    if (_loc_1["data"]["lastWatchedTime"] != null)
                    {
                        this._locator.paramVO.startTime = _loc_1["data"]["lastWatchedTime"];
                    }
                }
                if (_loc_1["data"]["currentHttpBiteRate2"] != undefined)
                {
                    this._locator.currentHttpBiteRate = int(_loc_1["data"]["currentHttpBiteRate2"]);
                }
                if (_loc_1["data"]["currentHttpBiteRateMode2"] != undefined)
                {
                    this._locator.isReadedCookie = true;
                    this._locator.currentHttpBiteRateMode = int(_loc_1["data"]["currentHttpBiteRateMode2"]);
                }
            }
            ShareObjecter.setObject(_loc_1);
            return;
        }// end function

        private function onMiniClose() : void
        {
            this.lc2.send("_cntvBasePlayer", "miniClose", "a");
            return;
        }// end function

        public function isLive(param1:String) : void
        {
            return;
        }// end function

        private function updataMiniStatus(event:TimerEvent) : void
        {
            var _loc_2:* = ShareObjecter.getObject(this._locator.localDataObjectName, this._locator.localDataPath);
            var _loc_3:* = Date.parse(new Date().toString());
            var _loc_4:Object = {time:_loc_3, pos:this._locator.currentTime};
            if (_loc_2 != null)
            {
                if (_loc_2["data"]["miniWindow"] != null)
                {
                    _loc_2["data"]["miniWindow"] = _loc_4;
                    ShareObjecter.setObject(_loc_2);
                }
                else
                {
                    _loc_2["data"]["miniWindow"] = [_loc_4];
                    ShareObjecter.setObject(_loc_2);
                }
            }
            return;
        }// end function

        private function setScreenSize() : void
        {
            this.addEventListener(Event.ENTER_FRAME, this.checkScreenSize);
            return;
        }// end function

        private function checkScreenSize(event:Event) : void
        {
            if (stage.stageWidth != 0)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.checkScreenSize);
                ModelLocator.getInstance().screenW = stage.stageWidth;
                ModelLocator.getInstance().screenH = stage.stageHeight;
            }
            return;
        }// end function

        private function lcAsynError(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function lcSecurityError(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

        private function lcStatu(event:StatusEvent) : void
        {
            return;
        }// end function

    }
}
