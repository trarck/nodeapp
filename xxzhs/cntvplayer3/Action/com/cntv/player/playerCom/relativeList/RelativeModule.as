package com.cntv.player.playerCom.relativeList
{
    import com.cntv.common.model.proxy.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.relativeList.event.*;
    import com.cntv.player.playerCom.relativeList.model.vo.*;
    import com.cntv.player.playerCom.relativeList.view.*;
    import com.cntv.player.widgets.views.replayButton.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class RelativeModule extends CommonSprite
    {
        public var ORIGINAL_W:Number = 640;
        public var ORIGINAL_H:Number = 480;
        public var H_GAP:Number = 20;
        public var V_GAP:Number = 20;
        public var T_GAP:Number = 20;
        public var M_GAP:Number = 140;
        public var S_GAP:Number = 110;
        public var G_GAP:Number = 5;
        private var _rWidth:Number;
        private var _rHeight:Number;
        private var iconWidth:Number;
        private var iconHeight:Number;
        private var itemVos:Array;
        private var defaultItemVos:RelativeVO;
        private var defaultItem:RelativeItem;
        private var items:Array;
        private var container:Sprite;
        private var itemPerPage:int = 4;
        private var pages:int = 0;
        private var sharePlug:DisplayObject;
        private var startIndex:int;
        private var endIndex:int;
        private var nowPage:int;
        private var turnPageBtn:turnPageButton;
        private var replayButton:ReplayButton;
        private var outLinkPanel:Sprite;
        private var outLinkTitles:Array;
        private var outLinks:Array;
        private var rPanel:CRiPanel;
        public var isBigMode:Boolean = true;
        private var buttonLeft:Buttonleft;
        private var buttonRight:ButtonRight;
        private var sorryText:TextField;
        private var otherVideoText:TextField;
        private var currentpage:TextField;
        private var totalpage:TextField;
        private var _sharp:TextField;
        private var failCount:Number = 3;
        private var isNodata:Boolean = false;
        private var inited:Boolean = false;
        public static const BAR_H:Number = 60;
        public static const iconSmallHei:Number = 45;
        public static const iconBighei:Number = 75;
        public static const BUTTON_W:Number = 150;

        public function RelativeModule()
        {
            this.outLinkTitles = [];
            this.outLinks = [];
            this.container = new Sprite();
            this.addChild(this.container);
            this.currentpage = TextGenerator.createTxt(13487565, 12, "", false, 0, false, "Arial");
            this.totalpage = TextGenerator.createTxt(6710886, 12, "", false, 0, false, "Arial");
            this._sharp = TextGenerator.createTxt(6710886, 12, "/");
            return;
        }// end function

        override protected function init() : void
        {
            if (this.inited)
            {
                return;
            }
            this.inited = true;
            _dispatcher.addEventListener(RelativeEvent.EVENT_GET_LIST_TITLE, this.onTitleComp);
            _dispatcher.addEventListener(RelativeEvent.EVENT_GET_LIST_TITLE_ERROR, this.onTitleFail);
            new GetRelativeTitleProxy();
            return;
        }// end function

        private function onTitleFail(event:RelativeEvent) : void
        {
            _dispatcher.removeEventListener(RelativeEvent.EVENT_GET_LIST_TITLE_ERROR, this.onTitleFail);
            this.realInit();
            return;
        }// end function

        private function onTitleComp(event:RelativeEvent) : void
        {
            return;
        }// end function

        private function noRelativeData(event:RelativeEvent) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this.failCount - 1;
            _loc_2.failCount = _loc_3;
            if (this.failCount >= 0)
            {
                this.realInit();
            }
            else
            {
                this.isNodata = true;
                if (!_modelLocator.noVideoData)
                {
                    this.hideMode();
                }
                else
                {
                    this.hideVerticlMode();
                }
            }
            return;
        }// end function

        private function realInit() : void
        {
            this.setSizeAdapter();
            this.initViews();
            _dispatcher.addEventListener(RelativeEvent.EVENT_GET_LIST_DATA_ERROR, this.noRelativeData);
            _dispatcher.addEventListener(RelativeEvent.EVENT_GET_LIST_DATA, this.getRelativeData);
            new GetRelativeListProxy();
            return;
        }// end function

        private function getRelativeData(event:RelativeEvent) : void
        {
            var e:* = event;
            try
            {
                if (_modelLocator.relativeList.length > 0)
                {
                    this.initData(_modelLocator.relativeList);
                }
                else
                {
                    this.isNodata = true;
                    dispatchEvent(new RelativeEvent(RelativeEvent.EVENT_GET_DATA_FAIL));
                }
            }
            catch (e)
            {
                isNodata = true;
                dispatchEvent(new RelativeEvent(RelativeEvent.EVENT_GET_DATA_FAIL));
            }
            return;
        }// end function

        public function setSizeAdapter() : void
        {
            var _loc_1:Number = NaN;
            if (stage.stageHeight < this.ORIGINAL_H)
            {
                this.iconHeight = iconSmallHei;
                this.isBigMode = false;
                CRightPanel.Wid = 180;
                this.itemPerPage = 3;
            }
            else
            {
                CRightPanel.Wid = 300;
                this.iconHeight = iconBighei;
                this.isBigMode = true;
                this.itemPerPage = 4;
            }
            if (_modelLocator.noVideoData)
            {
                this.isBigMode = true;
                this.iconHeight = iconBighei;
            }
            this.iconWidth = this.iconHeight / 3 * 4;
            if (this.isBigMode)
            {
                this.M_GAP = 140;
                this.S_GAP = 110;
                this.G_GAP = 5;
            }
            else
            {
                this.M_GAP = 120;
                this.S_GAP = 80;
                this.G_GAP = 0;
            }
            this.T_GAP = (stage.stageHeight - (this.itemPerPage * (this.iconHeight + this.V_GAP) + turnPageButton.Hei)) / 2;
            this.H_GAP = (stage.stageWidth - (this.iconWidth + this.M_GAP + CRightPanel.Wid)) / 2;
            if (_modelLocator.noVideoData)
            {
                _loc_1 = stage.stageWidth - (30 + 20) * 2;
                this.itemPerPage = Math.floor((_loc_1 + 10) / 110);
                this.T_GAP = (stage.stageHeight - 120) / 2;
                this.H_GAP = (stage.stageWidth - this.itemPerPage * 110 + 10) / 2;
                if (this.sorryText == null)
                {
                    this.sorryText = new TextField();
                    this.sorryText.defaultTextFormat = new TextFormat("", 12, 13421772);
                    this.addChild(this.sorryText);
                }
                this.sorryText.text = _modelLocator.i18n.RELATIVA_SORRY;
                this.sorryText.height = 17;
                this.sorryText.width = this.sorryText.textWidth + 10;
                this.sorryText.y = this.T_GAP / 2 - 15;
                this.sorryText.x = (stage.stageWidth - this.sorryText.textWidth) / 2;
                if (this.otherVideoText == null)
                {
                    this.otherVideoText = new TextField();
                    this.otherVideoText.defaultTextFormat = new TextFormat("", 12, 13421772);
                    this.addChild(this.otherVideoText);
                }
                this.otherVideoText.text = _modelLocator.i18n.RELATIVE_OTHER;
                this.otherVideoText.width = this.otherVideoText.textWidth + 10;
                this.otherVideoText.y = this.T_GAP / 2 + 15;
                this.otherVideoText.x = (stage.stageWidth - this.otherVideoText.textWidth) / 2;
                this.otherVideoText.height = 17;
            }
            else
            {
                if (this.rPanel == null)
                {
                    this.rPanel = new CRiPanel();
                    this.addChild(this.rPanel);
                }
                this.rPanel.doAdjust();
                this.rPanel.y = this.T_GAP;
                this.rPanel.x = stage.stageWidth - this.H_GAP - this.rPanel.width;
            }
            return;
        }// end function

        public function doAdjust() : void
        {
            this.adjust();
            return;
        }// end function

        override protected function adjust() : void
        {
            if (!stage)
            {
                return;
            }
            this.setSizeAdapter();
            if (this.pages)
            {
                this.pages = Math.ceil(this.itemVos.length / this.itemPerPage);
                this.totalpage.text = this.pages + "";
            }
            if ((stage.stageHeight < 300 || this.isNodata) && !_modelLocator.noVideoData)
            {
                this.hideMode();
            }
            else
            {
                if (_modelLocator.noVideoData)
                {
                    this.horizotalMode();
                }
                else if (_modelLocator.ISWEBSITE)
                {
                    this.verticalMode();
                }
                else
                {
                    this.outSideMode();
                }
                this.pagePrev();
            }
            if (_modelLocator.noVideoData)
            {
                this.buttonLeft.visible = true;
                this.buttonRight.visible = true;
            }
            this.container.visible = true;
            this.currentpage.visible = true;
            this._sharp.visible = true;
            this.totalpage.visible = true;
            if ((stage.stageHeight < 300 || this.isNodata) && _modelLocator.noVideoData)
            {
                this.hideVerticlMode();
            }
            return;
        }// end function

        private function initViews() : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:LinkButton = null;
            if (_modelLocator.currentVideoInfo is HttpVideoInfoVO)
            {
                this.defaultItemVos = new RelativeVO(null);
                this.defaultItemVos.icon = _modelLocator.currentVideoInfo.imagePath;
                this.defaultItemVos.desc = _modelLocator.currentVideoInfo.title;
                _loc_2 = this.iconWidth;
                _loc_3 = this.iconHeight;
                if (_loc_2 > 150)
                {
                    _loc_2 = 150;
                    _loc_3 = 150 * 3 / 4;
                }
                this.defaultItem = new RelativeItem(this.defaultItemVos, _loc_2, _loc_3, true);
                this.addChild(this.defaultItem);
                this.defaultItem.addEventListener(MouseEvent.CLICK, this.doReplay);
                this.defaultItem.x = (BUTTON_W - _loc_2) / 2;
                this.defaultItem.y = this.H_GAP;
            }
            this.addChild(this.currentpage);
            this.addChild(this._sharp);
            this.addChild(this.totalpage);
            if (_modelLocator.noVideoData)
            {
                this.buttonLeft = new Buttonleft();
                this.buttonRight = new ButtonRight();
                this.buttonLeft.addEventListener(MouseEvent.CLICK, this.pagePrev);
                this.buttonRight.addEventListener(MouseEvent.CLICK, this.pageNext);
                this.buttonLeft.buttonMode = true;
                this.buttonRight.buttonMode = true;
                this.addChild(this.buttonLeft);
                this.addChild(this.buttonRight);
                this.buttonLeft.y = (stage.stageHeight - 150) / 2;
                this.buttonRight.y = this.buttonLeft.y;
                this.buttonRight.x = stage.stageWidth - 35;
            }
            else
            {
                if (this.turnPageBtn == null)
                {
                    this.turnPageBtn = new turnPageButton(this.isBigMode);
                }
                if (!this.isNodata)
                {
                    this.container.addChild(this.turnPageBtn);
                }
                this.turnPageBtn.addEventListener(turnPageButton.EVENT_CLICK, this.turnPage);
            }
            this.replayButton = new ReplayButton();
            this.replayButton.addEventListener(MouseEvent.CLICK, this.doReplay);
            this.addChild(this.replayButton);
            if (_modelLocator.paramVO.addShare)
            {
                new SWFLoader(new URLRequest(_modelLocator.paramVO.sharePlugPath), this.getSharePlug, this.getSharePlugError);
            }
            this.outLinkPanel = new Sprite();
            this.addChild(this.outLinkPanel);
            var _loc_1:int = 0;
            while (_loc_1 < this.outLinkTitles.length)
            {
                
                _loc_4 = new LinkButton(this.outLinkTitles[_loc_1], this.outLinks[_loc_1]);
                _loc_4.y = (LinkButton.H + 5) * _loc_1;
                this.outLinkPanel.addChild(_loc_4);
                _loc_1++;
            }
            this.doLayOut();
            if (stage.stageHeight < 300 && !_modelLocator.noVideoData)
            {
                this.hideMode();
            }
            if (stage.stageHeight < 300 && _modelLocator.noVideoData)
            {
                this.hideVerticlMode();
            }
            return;
        }// end function

        private function getSharePlug(param1:DisplayObject) : void
        {
            this.sharePlug = param1;
            this.addChild(this.sharePlug);
            if (this.sharePlug != null && this.outLinkPanel != null)
            {
                this.sharePlug.x = 30;
                this.sharePlug.y = this.outLinkPanel.y + this.outLinkPanel.height;
            }
            return;
        }// end function

        private function getSharePlugError(param1:String) : void
        {
            return;
        }// end function

        public function doLayOut() : void
        {
            if (this.turnPageBtn)
            {
                this.turnPageBtn.x = (this.iconWidth * 2.5 - (this.turnPageBtn.width * 2 - this.H_GAP)) / 2;
                this.turnPageBtn.y = this.iconHeight * 3 + 4 * this.V_GAP;
            }
            this.x = (stage.stageWidth - this.width) / 2;
            this.y = (stage.stageHeight - this.height) / 2;
            this.replayButton.x = (BUTTON_W - this.replayButton.width) / 2;
            this.replayButton.y = (this.height - this.replayButton.height) / 2;
            if (this.defaultItemVos == null)
            {
                this.replayButton.y = (this.height - this.replayButton.height) / 2 - this.replayButton.height - 20;
            }
            else
            {
                this.replayButton.y = this.defaultItem.y + this.defaultItem.height;
            }
            this.replayButton.y = 10000;
            if (this.defaultItem)
            {
                this.defaultItem.y = 10000;
            }
            this.outLinkPanel.x = 20;
            this.outLinkPanel.y = (this.height - this.replayButton.y - 20 - this.outLinkPanel.height) / 2 + this.replayButton.y;
            return;
        }// end function

        public function initData(param1:Array) : void
        {
            this.itemVos = param1;
            this.items = [];
            this.pages = Math.ceil(this.itemVos.length / this.itemPerPage);
            this.totalpage.text = this.pages + "";
            if (this.pages <= 1)
            {
                if (_modelLocator.noVideoData)
                {
                    this.buttonLeft.visible = false;
                    this.buttonRight.visible = false;
                }
                else
                {
                    this.turnPageBtn.visible = false;
                }
            }
            this.selectPage();
            return;
        }// end function

        public function selectPage() : void
        {
            if (!this.isNodata)
            {
                this.startIndex = this.nowPage * this.itemPerPage;
                this.currentpage.text = (this.nowPage + 1) + "";
                if ((this.nowPage + 1) * this.itemPerPage > (this.itemVos.length - 1))
                {
                    this.endIndex = this.itemVos.length - 1;
                }
                else
                {
                    this.endIndex = (this.nowPage + 1) * this.itemPerPage - 1;
                }
                this.renderItems();
            }
            return;
        }// end function

        public function renderItems() : void
        {
            var _loc_4:RelativeItem = null;
            this.removeItems();
            var _loc_1:int = 0;
            var _loc_2:Number = 0;
            if (this.itemPerPage > this.endIndex - this.startIndex + 1)
            {
                _loc_2 = (this.itemPerPage - (this.endIndex - this.startIndex + 1)) * 110 / 2;
            }
            var _loc_3:* = this.startIndex;
            while (_loc_3 <= this.endIndex)
            {
                
                _loc_4 = new RelativeItem(this.itemVos[_loc_3], this.iconWidth, this.iconHeight, false, this.isBigMode);
                _loc_4.x = this.H_GAP;
                _loc_4.y = this.T_GAP + _loc_1 * (this.iconHeight + this.V_GAP);
                if (_modelLocator.noVideoData)
                {
                    _loc_4.y = this.T_GAP;
                    _loc_4.x = this.H_GAP + (_loc_3 - this.startIndex) * 110 + _loc_2;
                    _loc_4.setirect(true);
                }
                this.container.addChild(_loc_4);
                this.items.push(_loc_4);
                _loc_1++;
                _loc_3++;
            }
            if (_modelLocator.noVideoData)
            {
                this.buttonLeft.y = (stage.stageHeight - 150) / 2;
                this.buttonRight.y = this.buttonLeft.y;
                this.buttonRight.x = stage.stageWidth - 35;
                var _loc_5:* = this.buttonLeft.y + 150;
                this.totalpage.y = this.buttonLeft.y + 150;
                var _loc_5:* = _loc_5;
                this._sharp.y = _loc_5;
                this.currentpage.y = _loc_5;
                this.currentpage.x = (stage.stageWidth - this.currentpage.width - this._sharp.width - this.totalpage.width - 10) / 2;
                this._sharp.x = this.currentpage.x + this.currentpage.width + 5;
                this.totalpage.x = this._sharp.x + this._sharp.width + 5;
            }
            else
            {
                this.turnPageBtn.y = (this.iconHeight + this.V_GAP) * this.itemPerPage + this.T_GAP;
                this.turnPageBtn.x = this.H_GAP;
                var _loc_5:* = this.turnPageBtn.y + this.G_GAP;
                this.totalpage.y = this.turnPageBtn.y + this.G_GAP;
                var _loc_5:* = _loc_5;
                this._sharp.y = _loc_5;
                this.currentpage.y = _loc_5;
                this.currentpage.x = this.turnPageBtn.x + this.S_GAP;
                this._sharp.x = this.currentpage.x + this.currentpage.width + 5;
                this.totalpage.x = this._sharp.x + this._sharp.width + 5;
            }
            return;
        }// end function

        private function orderVertical() : void
        {
            return;
        }// end function

        private function verticalMode() : void
        {
            this.selectPage();
            this.turnPageBtn.adJustPos(this.isBigMode);
            this.turnPageBtn.y = (this.iconHeight + this.V_GAP) * this.itemPerPage + this.T_GAP;
            this.turnPageBtn.x = this.H_GAP;
            return;
        }// end function

        private function hideMode() : void
        {
            this.container.visible = false;
            this.currentpage.visible = false;
            this._sharp.visible = false;
            this.totalpage.visible = false;
            if (this.rPanel)
            {
                this.rPanel.y = (stage.stageHeight - this.rPanel.height) / 2;
                this.rPanel.x = (stage.stageWidth - this.rPanel.width) / 2;
                this.rPanel.setPos();
            }
            if (this.turnPageBtn)
            {
                this.turnPageBtn.visible = false;
            }
            return;
        }// end function

        private function hideVerticlMode() : void
        {
            this.buttonLeft.visible = false;
            this.buttonRight.visible = false;
            this.container.visible = false;
            this.currentpage.visible = false;
            this._sharp.visible = false;
            this.totalpage.visible = false;
            this.sorryText.y = stage.stageHeight / 2 - 15 - this.sorryText.textHeight;
            this.sorryText.x = (stage.stageWidth - this.sorryText.textWidth) / 2;
            this.otherVideoText.y = stage.stageHeight / 2 + 15 - this.otherVideoText.textHeight;
            this.otherVideoText.x = (stage.stageWidth - this.otherVideoText.textWidth) / 2;
            return;
        }// end function

        private function horizotalMode() : void
        {
            var _loc_1:Number = NaN;
            if (stage.stageWidth < 300)
            {
                this.container.visible = false;
                this.currentpage.visible = false;
                this._sharp.visible = false;
                this.totalpage.visible = false;
            }
            else
            {
                _loc_1 = stage.stageWidth - (30 + 20) * 2;
                this.itemPerPage = Math.floor((_loc_1 + 10) / 110);
                this.selectPage();
            }
            return;
        }// end function

        private function outSideMode() : void
        {
            return;
        }// end function

        private function removeItems() : void
        {
            var _loc_1:RelativeItem = null;
            if (this.items != null)
            {
                while (this.items.length != 0)
                {
                    
                    _loc_1 = this.items.pop() as RelativeItem;
                    this.container.removeChild(_loc_1);
                }
            }
            return;
        }// end function

        private function turnPage(event:CommonEvent) : void
        {
            if (event.data == "pre")
            {
                this.pagePrev();
            }
            else
            {
                this.pageNext();
            }
            return;
        }// end function

        private function pagePrev(event:MouseEvent = null) : void
        {
            if ((this.nowPage - 1) >= 0)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.nowPage - 1;
                _loc_2.nowPage = _loc_3;
                this.selectPage();
            }
            return;
        }// end function

        private function pageNext(event:MouseEvent = null) : void
        {
            if ((this.nowPage + 1) < this.pages)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.nowPage + 1;
                _loc_2.nowPage = _loc_3;
                this.selectPage();
            }
            return;
        }// end function

        private function doReplay(event:MouseEvent) : void
        {
            dispatchEvent(new RelativeEvent(RelativeEvent.EVENT_DO_REPLAY));
            return;
        }// end function

        override public function get width() : Number
        {
            return this._rWidth;
        }// end function

        override public function get height() : Number
        {
            return this._rHeight;
        }// end function

        override protected function release() : void
        {
            return;
        }// end function

    }
}
