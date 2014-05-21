package com.cntv.player.playerCom.relativeList
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.relativeList.view.*;
    import com.cntv.player.playerCom.statuBox.event.*;
    import com.cntv.player.widgets.views.replayButton.*;
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.text.*;

    public class CRiPanel extends CommonSprite
    {
        private var bg:Sprite;
        private var bg1:Sprite;
        private var replayBtn:ReplayButton;
        private var title:TextField;
        private var coaddress:TextField;
        private var share:TextField;
        private var copyButton1:Sprite;
        private var copyButton2:Sprite;
        private var photo:RelativeIcon;
        private var icons:Array;
        private var bgSkin:Class;
        private var bg1Skin:Class;
        private var copy1Skin:Class;
        private var copy2Skin:Class;
        private var photoSkin:Class;
        private var share_sina1:Class;
        public var ob_sina:DisplayObject;
        private var share_qq1:Class;
        public var ob_qq:DisplayObject;
        private var share_sohu1:Class;
        public var ob_sohu:DisplayObject;
        private var share_qzone1:Class;
        public var ob_qzone:DisplayObject;
        private var share_renren1:Class;
        public var ob_renren:DisplayObject;
        private var share_kaixin1:Class;
        public var ob_kaixin:DisplayObject;
        private var icon:Sprite;
        private var iconW:Number = 160;
        private var iconH:Number = 120;
        private var iconW1:Number = 100;
        private var iconH1:Number = 180;
        private var index:int;
        private var reindex:int;
        public var txt_refHTML:TextField;
        public var txt_refURL:TextField;
        public static const EVENT_REPLAY:String = "event.replay";

        public function CRiPanel(param1:int = 3)
        {
            var _loc_2:DisplayObject = null;
            var _loc_10:String = null;
            this.icons = [];
            this.bgSkin = CRiPanel_bgSkin;
            this.bg1Skin = CRiPanel_bg1Skin;
            this.copy1Skin = CRiPanel_copy1Skin;
            this.copy2Skin = CRiPanel_copy2Skin;
            this.photoSkin = CRiPanel_photoSkin;
            this.share_sina1 = CRiPanel_share_sina1;
            this.ob_sina = new this.share_sina1();
            this.share_qq1 = CRiPanel_share_qq1;
            this.ob_qq = new this.share_qq1();
            this.share_sohu1 = CRiPanel_share_sohu1;
            this.ob_sohu = new this.share_sohu1();
            this.share_qzone1 = CRiPanel_share_qzone1;
            this.ob_qzone = new this.share_qzone1();
            this.share_renren1 = CRiPanel_share_renren1;
            this.ob_renren = new this.share_renren1();
            this.share_kaixin1 = CRiPanel_share_kaixin1;
            this.ob_kaixin = new this.share_kaixin1();
            this.index = param1;
            _loc_2 = new this.bgSkin();
            this.bg = new Sprite();
            this.bg.addChild(_loc_2);
            this.bg.width = 230;
            if (this.index == 1)
            {
                this.addChild(this.bg);
            }
            _loc_2 = new this.bg1Skin();
            this.bg1 = new Sprite();
            this.bg1.addChild(_loc_2);
            this.bg1.width = 180;
            if (this.index == 2)
            {
                this.addChild(this.bg1);
            }
            this.txt_refHTML = new TextField();
            this.txt_refURL = new TextField();
            this.title = new TextField();
            if (this.index == 1 || this.index == 2)
            {
                this.addChild(this.title);
            }
            this.title.defaultTextFormat = new TextFormat("宋体", 18, 16777215, true);
            if (this.index == 2)
            {
                this.title.defaultTextFormat = new TextFormat("宋体", 16, 16777215, true);
            }
            this.title.height = 20;
            this.title.text = _modelLocator.currentVideoInfo.title;
            if (this.title.text.length > 8)
            {
                _loc_10 = this.title.text;
                _loc_10 = _loc_10.slice(0, 8) + "...";
                this.title.text = _loc_10;
            }
            if (this.index == 1)
            {
                this.title.x = 20;
                this.title.y = 20;
            }
            else if (this.index == 2)
            {
                this.title.x = 10;
                this.title.y = 10;
            }
            this.title.width = 160;
            this.photo = new RelativeIcon(this.iconW - 3, this.iconH - 3, _modelLocator.currentVideoInfo.imagePath);
            this.photo.x = 20;
            this.photo.y = 50;
            if (this.index == 1 || this.index == 2)
            {
                this.addChild(this.photo);
            }
            this.photo.buttonMode = true;
            if (this.index == 2)
            {
                this.photo.scaleX = 0.8;
                this.photo.scaleY = 0.8;
                this.photo.x = 10;
                this.photo.y = 35;
                this.iconW = 128;
                this.iconH = 96;
            }
            this.replayBtn = new ReplayButton();
            this.addChild(this.replayBtn);
            this.replayBtn.x = this.photo.x + this.iconW / 2 - this.replayBtn.width / 2;
            this.replayBtn.y = this.photo.y + this.iconH / 2 - this.replayBtn.height / 2;
            this.share = new TextField();
            if (this.index == 1 || this.index == 2)
            {
                this.addChild(this.share);
            }
            this.share.defaultTextFormat = new TextFormat("宋体", 14, 16777215, true);
            this.share.height = 20;
            this.share.text = _modelLocator.i18n.RELATIVA_SHARE;
            this.share.x = 20;
            this.share.y = 200;
            if (this.index == 2)
            {
                this.share.x = 10;
                this.share.y = 145;
            }
            this.share.width = 150;
            var _loc_3:* = new quickShareBtn("新浪微博", this.ob_sina);
            if (this.index == 1 || this.index == 2)
            {
                this.addChild(_loc_3);
            }
            this.icons.push(_loc_3);
            _loc_3.addEventListener(MouseEvent.CLICK, this.onSinaClick);
            var _loc_4:* = new quickShareBtn("腾讯微博", this.ob_qq);
            if (this.index == 1 || this.index == 2)
            {
                this.addChild(_loc_4);
            }
            this.icons.push(_loc_4);
            _loc_4.addEventListener(MouseEvent.CLICK, this.onQQWeiboClick);
            var _loc_5:* = new quickShareBtn("搜狐微博", this.ob_sohu);
            if (this.index == 1 || this.index == 2)
            {
                this.addChild(_loc_5);
            }
            this.icons.push(_loc_5);
            _loc_5.addEventListener(MouseEvent.CLICK, this.onSohuClick);
            var _loc_6:* = new quickShareBtn("QQ空间", this.ob_qzone);
            if (this.index == 1 || this.index == 2)
            {
                this.addChild(_loc_6);
            }
            this.icons.push(_loc_6);
            _loc_6.addEventListener(MouseEvent.CLICK, this.onQQClick);
            var _loc_7:* = new quickShareBtn("人人网", this.ob_renren);
            if (this.index == 1 || this.index == 2)
            {
                this.addChild(_loc_7);
            }
            this.icons.push(_loc_7);
            _loc_7.addEventListener(MouseEvent.CLICK, this.onRenrenClick);
            var _loc_8:* = new quickShareBtn("开心网", this.ob_kaixin);
            if (this.index == 1 || this.index == 2)
            {
                this.addChild(_loc_8);
            }
            this.icons.push(_loc_8);
            _loc_8.addEventListener(MouseEvent.CLICK, this.onKaixinClick);
            var _loc_9:int = 0;
            while (_loc_9 < this.icons.length)
            {
                
                if (this.index == 1)
                {
                    this.icons[_loc_9].x = 20 + _loc_9 * 25;
                    this.icons[_loc_9].y = 220;
                }
                if (this.index == 2)
                {
                    this.icons[_loc_9].x = 10 + _loc_9 * 25;
                    this.icons[_loc_9].y = 165;
                }
                _loc_9++;
            }
            this.coaddress = new TextField();
            this.coaddress.defaultTextFormat = new TextFormat("宋体", 14, 16777215, true);
            this.coaddress.height = 20;
            this.coaddress.text = "复制视频地址给好友";
            this.coaddress.x = 20;
            this.coaddress.y = 250;
            this.coaddress.width = 150;
            if (this.index == 1)
            {
                this.addChild(this.coaddress);
            }
            _loc_2 = new this.copy1Skin();
            this.copyButton1 = new Sprite();
            this.copyButton1.addChild(_loc_2);
            this.copyButton1.x = 20;
            this.copyButton1.y = 280;
            this.copyButton1.addEventListener(MouseEvent.CLICK, this.copyRefURL);
            this.copyButton1.buttonMode = true;
            if (this.index == 1)
            {
                this.addChild(this.copyButton1);
            }
            _loc_2 = new this.copy2Skin();
            this.copyButton2 = new Sprite();
            this.copyButton2.addChild(_loc_2);
            this.copyButton2.x = 20;
            this.copyButton2.y = 320;
            this.copyButton2.addEventListener(MouseEvent.CLICK, this.copyRefHTML);
            this.copyButton2.buttonMode = true;
            if (this.index == 1)
            {
                this.addChild(this.copyButton2);
            }
            if (_modelLocator.currentVideoInfo.is_protected)
            {
                this.copyButton1.visible = false;
                this.copyButton2.visible = false;
            }
            this.replayBtn.addEventListener(MouseEvent.CLICK, this.onReplayClick);
            this.photo.addEventListener(MouseEvent.CLICK, this.onReplayClick);
            return;
        }// end function

        override public function get width() : Number
        {
            var _loc_1:* = this.bg1.width;
            if (this.index == 1)
            {
                _loc_1 = this.bg.width;
            }
            return _loc_1;
        }// end function

        override public function get height() : Number
        {
            var _loc_1:* = this.bg1.height;
            if (this.index == 1)
            {
                _loc_1 = this.bg.height;
            }
            return _loc_1;
        }// end function

        private function onSinaClick(event:MouseEvent) : void
        {
            if (this._modelLocator.paramVO.url != "")
            {
                NativeToURLTool.openAURL("http://v.t.sina.com.cn/share/share.php?appkey=2078561600&url=" + escape(_modelLocator.paramVO.url));
            }
            return;
        }// end function

        private function onQQClick(event:MouseEvent) : void
        {
            if (this._modelLocator.paramVO.url != "")
            {
                NativeToURLTool.openAURL("http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=ce5e42dabdeb46069382c3554333f281&url=" + escape(_modelLocator.paramVO.url));
            }
            return;
        }// end function

        private function onQQWeiboClick(event:MouseEvent) : void
        {
            if (this._modelLocator.paramVO.url != "")
            {
                NativeToURLTool.openAURL("http://v.t.qq.com/share/share.php?appkey=ce5e42dabdeb46069382c3554333f281&url=" + escape(_modelLocator.paramVO.url));
            }
            return;
        }// end function

        private function onSohuClick(event:MouseEvent) : void
        {
            if (this._modelLocator.paramVO.url != "")
            {
                NativeToURLTool.openAURL("http://t.sohu.com/third/post.jsp?url=" + escape(_modelLocator.paramVO.url));
            }
            return;
        }// end function

        private function onRenrenClick(event:MouseEvent) : void
        {
            if (this._modelLocator.paramVO.url != "")
            {
                NativeToURLTool.openAURL("http://share.renren.com/share/buttonshare.do?link=" + escape(_modelLocator.paramVO.url));
            }
            return;
        }// end function

        private function onKaixinClick(event:MouseEvent) : void
        {
            if (this._modelLocator.paramVO.url != "")
            {
                NativeToURLTool.openAURL("http://www.kaixin001.com/repaste/share.php?type=video&rurl=" + escape(_modelLocator.paramVO.url));
            }
            return;
        }// end function

        public function doAdjust() : void
        {
            this.adjust();
            return;
        }// end function

        public function setPos() : void
        {
            this.adjust();
            return;
        }// end function

        override protected function adjust() : void
        {
            var _loc_1:Point = null;
            if (!stage)
            {
                return;
            }
            if (stage.stageHeight >= 480)
            {
                this.reindex = 1;
            }
            else if (stage.stageHeight >= 300 && stage.stageHeight < 480)
            {
                this.reindex = 2;
            }
            else
            {
                this.reindex = 3;
            }
            if (this.reindex == 3)
            {
                _loc_1 = new Point((stage.stageWidth - this.replayBtn.width) / 2, (stage.stageHeight - this.replayBtn.height - 30) / 2);
                _loc_1 = this.globalToLocal(_loc_1);
                this.replayBtn.x = _loc_1.x;
                this.replayBtn.y = _loc_1.y;
            }
            if (this.reindex == this.index)
            {
                return;
            }
            this.index = this.reindex;
            this.reorder();
            return;
        }// end function

        private function reorder() : void
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (this.index == 1)
            {
                this.addChild(this.bg);
                if (this.contains(this.bg1))
                {
                    this.removeChild(this.bg1);
                }
                this.addChild(this.title);
                this.addChild(this.photo);
                this.addChild(this.replayBtn);
                this.title.x = 20;
                this.title.y = 20;
                this.photo.x = 20;
                this.photo.y = 50;
                this.iconW = 160;
                this.iconH = 120;
                this.photo.scaleX = 1;
                this.photo.scaleY = 1;
                this.addChild(this.share);
                this.share.x = 20;
                this.share.y = 200;
                this.addChild(this.coaddress);
                this.addChild(this.copyButton1);
                this.addChild(this.copyButton2);
                if (!_modelLocator.currentVideoInfo.is_protected)
                {
                }
                _loc_1 = 0;
                while (_loc_1 <= (this.icons.length - 1))
                {
                    
                    this.addChild(this.icons[_loc_1]);
                    this.icons[_loc_1].x = 20 + _loc_1 * 23;
                    this.icons[_loc_1].y = 220;
                    _loc_1++;
                }
            }
            if (this.index == 2)
            {
                this.photo.visible = true;
                if (this.bg != null && this.contains(this.bg))
                {
                    this.removeChild(this.bg);
                }
                this.addChild(this.bg1);
                this.addChild(this.title);
                this.addChild(this.photo);
                this.addChild(this.replayBtn);
                this.title.x = 10;
                this.title.y = 10;
                this.iconW = 128;
                this.iconH = 96;
                this.photo.scaleX = 0.8;
                this.photo.scaleY = 0.8;
                this.photo.x = 10;
                this.photo.y = 35;
                this.addChild(this.share);
                this.share.x = 10;
                this.share.y = 145;
                if (this.coaddress !== null && this.contains(this.coaddress))
                {
                    this.removeChild(this.coaddress);
                    this.removeChild(this.copyButton1);
                    this.removeChild(this.copyButton2);
                }
                _loc_2 = 0;
                while (_loc_2 <= (this.icons.length - 1))
                {
                    
                    this.addChild(this.icons[_loc_2]);
                    this.icons[_loc_2].x = 10 + _loc_2 * 23;
                    this.icons[_loc_2].y = 165;
                    _loc_2++;
                }
            }
            this.replayBtn.x = this.photo.x + this.iconW / 2 - this.replayBtn.width / 2;
            this.replayBtn.y = this.photo.y + this.iconH / 2 - this.replayBtn.height / 2;
            if (this.index == 3)
            {
                this.removeChild(this.bg1);
                this.removeChild(this.title);
                this.photo.visible = false;
                this.addChild(this.replayBtn);
                this.replayBtn.x = stage.stageWidth / 2 - this.replayBtn.width / 2;
                this.replayBtn.y = stage.stageHeight / 2 - this.replayBtn.height / 2;
                this.removeChild(this.share);
                _loc_3 = 0;
                while (_loc_3 <= (this.icons.length - 1))
                {
                    
                    this.removeChild(this.icons[_loc_3]);
                    _loc_3++;
                }
            }
            return;
        }// end function

        private function onReplayClick(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new CommonEvent(CRiPanel.EVENT_REPLAY));
            return;
        }// end function

        private function onAppleUnSelect(event:RadioButtonEvent) : void
        {
            if (_modelLocator.paramVO.playBackMode == "audio" && _modelLocator.currentAudioInfo)
            {
                this.txt_refHTML.text = _modelLocator.currentAudioInfo.refHtml;
            }
            else
            {
                this.txt_refHTML.text = _modelLocator.currentVideoInfo.refHtml;
            }
            return;
        }// end function

        private function onAppleSelect(event:RadioButtonEvent) : void
        {
            if (_modelLocator.paramVO.playBackMode == "audio" && _modelLocator.currentAudioInfo)
            {
                this.txt_refHTML.text = _modelLocator.currentAudioInfo.refIpadHtml;
            }
            else
            {
                this.txt_refHTML.text = _modelLocator.currentVideoInfo.refIpadHtml;
            }
            return;
        }// end function

        private function copyRefURL(event:MouseEvent) : void
        {
            var _loc_2:* = new StatusVO(_modelLocator.i18n.WIDEGTS_AFTER_COPY_SHARE_URL, StatuBoxEvent.TYPE_CENTER, true);
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            System.setClipboard(_modelLocator.currentVideoInfo.refURL);
            return;
        }// end function

        private function copyRefHTML(event:MouseEvent) : void
        {
            var _loc_2:* = new StatusVO(_modelLocator.i18n.WIDEGTS_AFTER_COPY_SHARE_EMBED, StatuBoxEvent.TYPE_CENTER, true);
            _dispatcher.dispatchEvent(new StatuBoxEvent(StatuBoxEvent.EVENT_SHOW_MESSAGE, _loc_2));
            System.setClipboard(_modelLocator.currentVideoInfo.refHtml);
            return;
        }// end function

    }
}
