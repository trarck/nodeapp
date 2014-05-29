package com.cntv.player.playerCom.controlBar.view._bitratePanel
{
    import com.cntv.common.view.ui.*;
    import com.cntv.player.floatLayer.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;

    public class CModeBtn extends CommonSprite
    {
        private var label:TextField;
        public var isSelected:Boolean = false;
        private var format:TextFormat;
        private var id:Number = -1;
        private var checkbtn:Sprite;
        private var checklayer:Sprite;
        private var _parent:CBitRatePanel;
        private var glow:GlowFilter;
        private var myFilters:Array;
        private var checkSkin:Class;

        public function CModeBtn(param1:String, param2:Number, param3:CBitRatePanel)
        {
            var _loc_4:DisplayObject = null;
            this.checkSkin = CModeBtn_checkSkin;
            this._parent = param3;
            this.id = param2;
            this.glow = new GlowFilter();
            this.myFilters = new Array();
            this.myFilters.push(this.glow);
            this.mouseChildren = false;
            this.checklayer = new Sprite();
            this.addChild(this.checklayer);
            this.checklayer.graphics.beginFill(0);
            this.checklayer.graphics.drawRect(0, 0, 85, 20);
            this.checklayer.graphics.endFill();
            this.checklayer.buttonMode = true;
            this.checklayer.alpha = 0.8;
            this.checklayer.visible = false;
            this.label = new TextField();
            this.addChild(this.label);
            this.format = new TextFormat("雅黑", 12, 10066329, true);
            this.label.defaultTextFormat = this.format;
            this.label.text = param1;
            this.label.width = this.label.textWidth + 5;
            this.label.height = 20;
            this.label.x = 20;
            this.label.filters = null;
            _loc_4 = new this.checkSkin();
            this.checkbtn = new Sprite();
            this.checkbtn.addChild(_loc_4);
            this.addChild(this.checkbtn);
            this.checkbtn.x = 5;
            this.checkbtn.y = 3;
            this.checkbtn.visible = false;
            this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this.addEventListener(MouseEvent.CLICK, this.onClick);
            return;
        }// end function

        private function onClick(event:MouseEvent) : void
        {
            this.isSelected = true;
            this._parent.updata3DModeState(this.id);
            this.label.filters = this.myFilters;
            this.checkbtn.visible = true;
            _dispatcher.dispatchEvent(new FLayerEvent(FLayerEvent.EVENT_SHOW_CHANGETEXT, this.label.text));
            _dispatcher.dispatchEvent(new FLayerEvent(FLayerEvent.EVENT_SHOW_HIDEPANEL));
            return;
        }// end function

        public function onMouseOver(event:MouseEvent) : void
        {
            this.checklayer.visible = true;
            this.format.color = 13421772;
            this.label.setTextFormat(this.format);
            this.label.filters = this.myFilters;
            return;
        }// end function

        public function onMouseOut(event:MouseEvent) : void
        {
            if (!this.isSelected)
            {
                this.checkbtn.visible = false;
                this.checklayer.visible = false;
                this.format.color = 10066329;
                this.label.setTextFormat(this.format);
                this.label.filters = null;
            }
            return;
        }// end function

        public function setState(param1:Boolean) : void
        {
            if (param1)
            {
                this.format.color = 13421772;
                this.label.setTextFormat(this.format);
                this.label.filters = this.myFilters;
            }
            else
            {
                this.format.color = 10066329;
                this.label.setTextFormat(this.format);
                this.label.filters = null;
            }
            this.checkbtn.visible = param1;
            this.isSelected = param1;
            this.checklayer.visible = param1;
            return;
        }// end function

    }
}
