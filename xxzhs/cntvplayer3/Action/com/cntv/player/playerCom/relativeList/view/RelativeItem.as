package com.cntv.player.playerCom.relativeList.view
{
    import com.cntv.common.tools.net.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.relativeList.model.vo.*;
    import com.utils.net.request.*;
    import flash.events.*;
    import flash.text.*;

    public class RelativeItem extends CommonSprite
    {
        public var vo:RelativeVO;
        private var icon:RelativeIcon;
        private var textPanel:TextField;
        private var cover:CommonMask;
        private var bg:CommonGradientMask;
        private var info:TextField;
        private var time:TextField;
        private var defaultItem:Boolean = false;
        private var oraginW:Number;
        private var oraginH:Number;
        public static const H_GAP:Number = 0;

        public function RelativeItem(param1:RelativeVO, param2:Number, param3:Number, param4:Boolean = false, param5:Boolean = true)
        {
            this.oraginW = param2;
            this.oraginH = param3;
            this.vo = param1;
            this.icon = new RelativeIcon(param2 - 3, param3 - 3, this.vo.icon);
            this.icon.x = H_GAP / 2;
            this.icon.y = H_GAP / 2;
            var _loc_6:* = param2 * 2.5 + 2;
            this.info = new TextField();
            this.defaultItem = param4;
            var _loc_7:* = new TextFormat();
            new TextFormat().color = 16777215;
            _loc_7.size = 12;
            _loc_7.bold = true;
            _loc_7.leading = 5;
            if (param4)
            {
                _loc_6 = param2;
            }
            this.bg = new CommonGradientMask("", _loc_6, param3 + 4, 1, 0.6, 4276545, 5197647);
            this.addChild(this.bg);
            this.bg.x = this.icon.x - 2;
            this.bg.y = this.icon.y - 2;
            this.addChild(this.icon);
            this.info.wordWrap = true;
            this.info.multiline = true;
            if (!param4)
            {
                this.time = new TextField();
                this.time.width = param2 * 1.5;
                this.time.text = this.vo.time;
                this.time.x = param2 + 8;
                this.time.y = 50;
                this.addChild(this.time);
                this.time.setTextFormat(new TextFormat("宋体", 11, 10066329, true));
                if (param5)
                {
                    this.info.width = param2 * 1.5;
                    if (this.vo.desc.length > 22)
                    {
                        this.info.text = this.vo.desc.slice(0, 20) + "...";
                    }
                    else
                    {
                        this.info.text = this.vo.desc;
                    }
                    this.info.x = param2 + 8;
                    this.info.y = 0;
                }
                else
                {
                    this.info.width = param2 * 1.5;
                    if (this.vo.desc.length > 12)
                    {
                        this.info.text = this.vo.desc.slice(0, 11) + "...";
                    }
                    else
                    {
                        this.info.text = this.vo.desc;
                    }
                    this.info.x = param2 + 8;
                    this.info.y = 0;
                    this.time.visible = false;
                }
                this.cover = new CommonMask(param2 * 2.5 + H_GAP * 2, param3 + H_GAP, 16777215, 0, CommonMask.TYPE_S);
                this.cover.addEventListener(MouseEvent.CLICK, this.openURL);
            }
            else
            {
                this.cover = new CommonMask(param2, param3, 16777215, 0, CommonMask.TYPE_S);
                this.info.width = param2 + H_GAP;
                this.info.text = this.vo.desc;
                if (this.info.length > 14)
                {
                    this.info.text = this.info.text.slice(0, 13) + "..";
                }
                this.info.y = param3 + 10;
                this.info.x = 6;
            }
            this.info.setTextFormat(_loc_7);
            this.addChild(this.info);
            this.cover.buttonMode = true;
            this.addChild(this.cover);
            return;
        }// end function

        public function setirect(param1:Boolean) : void
        {
            var _loc_2:TextFormat = null;
            if (param1)
            {
                this.info.x = 0;
                this.info.y = this.oraginH;
                this.info.width = this.oraginW;
                if (this.info.text.length > 13)
                {
                    this.info.text = this.vo.desc.slice(0, 13) + "..";
                }
                _loc_2 = new TextFormat();
                _loc_2.color = 16777215;
                _loc_2.size = 12;
                _loc_2.bold = true;
                _loc_2.leading = 5;
                this.info.setTextFormat(_loc_2);
                this.time.x = 0;
                this.time.y = this.oraginH + 40;
                this.time.text = this.vo.time.slice(0, 10);
                this.time.setTextFormat(new TextFormat("宋体", 11, 10066329, true));
                this.bg.visible = false;
            }
            else
            {
                this.setMode(true);
            }
            return;
        }// end function

        public function setMode(param1:Boolean) : void
        {
            if (param1)
            {
                this.icon.scaleX = 1;
                this.icon.scaleY = 1;
                this.info.x = this.oraginW + 8;
                this.time.x = this.oraginW + 8;
                this.time.visible = true;
            }
            else
            {
                this.info.x = this.oraginW * 0.6 + 8;
                this.time.x = this.oraginW * 0.6 + 8;
                this.time.visible = false;
                this.icon.scaleX = 0.6;
                this.icon.scaleY = 0.6;
            }
            return;
        }// end function

        override protected function release() : void
        {
            return;
        }// end function

        private function openURL(event:MouseEvent) : void
        {
            if (_modelLocator.paramVO.gulouPath != "")
            {
                new HttpRequest(new AttributeVo(_modelLocator.paramVO.gulouPath + "?t=" + Math.random()), null);
            }
            NativeToURLTool.openAURL(this.vo.url);
            return;
        }// end function

    }
}
