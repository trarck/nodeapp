package com.cntv.player.widgets.views
{
    import com.cntv.common.view.ui.*;
    import com.cntv.player.widgets.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class WidgetsButton extends CommonSprite
    {
        protected var bg:WigdetsButtonBG;
        protected var icon:Bitmap;
        protected var leftOrRight:String;
        protected var textPanel:TextField;
        protected var targetAreaAll:WigdetsButtonBG;
        protected var coverArea:CommonMask;
        protected var inProgressIcon:BufferIcon;
        protected var _inProcess:Boolean = false;
        protected var addOn:Number = 0;
        public static const LEFT:String = "l";
        public static const RIGHT:String = "r";
        public static var W:Number = 60;
        public static var H:Number = 50;
        public static const LEFT_GAP:Number = 4;
        public static const TEXT_COLOR:uint = 16777215;
        public static const TEXT_SIZE:int = 14;

        public function WidgetsButton()
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.bg = new WigdetsButtonBG(W, H);
            this.bg.alpha = 0.4;
            return;
        }// end function

        protected function addTargetArea() : void
        {
            this.targetAreaAll = new WigdetsButtonBG(W, H);
            this.targetAreaAll.alpha = 0;
            this.targetAreaAll.buttonMode = true;
            this.addEventListener(MouseEvent.ROLL_OVER, this.onMouseOver);
            this.addEventListener(MouseEvent.ROLL_OUT, this.onMouseOut);
            return;
        }// end function

        override protected function release() : void
        {
            if (this.bg != null)
            {
                this.removeChild(this.bg);
                this.bg = null;
            }
            if (this.icon != null)
            {
                this.removeChild(this.icon);
                this.icon = null;
            }
            return;
        }// end function

        override protected function adjust() : void
        {
            this.setIconPosition();
            this.setTextToCenter();
            return;
        }// end function

        protected function setIconPosition() : void
        {
            if (this.icon != null)
            {
                this.icon.y = (H - this.icon.height) / 2;
                if (this.leftOrRight == LEFT)
                {
                    this.icon.x = LEFT_GAP;
                }
                else if (this.leftOrRight == RIGHT)
                {
                    this.icon.x = W - this.icon.width - LEFT_GAP;
                }
            }
            return;
        }// end function

        protected function setTextPanelPosition() : void
        {
            if (this.textPanel != null)
            {
                this.textPanel.y = (H - this.textPanel.height) / 2;
                if (this.leftOrRight == LEFT)
                {
                    this.textPanel.x = this.icon.x + this.icon.width + 5;
                }
                else if (this.leftOrRight == RIGHT)
                {
                    this.textPanel.x = this.icon.x - this.textPanel.width;
                }
            }
            return;
        }// end function

        protected function setTextToCenter() : void
        {
            var _loc_1:Number = NaN;
            if (this.textPanel == null)
            {
                return;
            }
            this.textPanel.y = (H - this.textPanel.height) / 2;
            if (this.leftOrRight == LEFT)
            {
                _loc_1 = Math.floor((W - this.icon.width - this.icon.x - this.textPanel.textWidth) / 2);
                this.textPanel.x = this.icon.x + this.icon.width + _loc_1;
            }
            else if (this.leftOrRight == RIGHT)
            {
                _loc_1 = (this.icon.x - this.textPanel.textWidth) / 2;
                this.textPanel.x = Math.floor(_loc_1);
            }
            return;
        }// end function

        protected function setTextToLeft() : void
        {
            if (this.textPanel == null)
            {
                return;
            }
            this.textPanel.y = (H - this.textPanel.height) / 2;
            var _loc_1:* = (W - this.icon.width - this.icon.x - this.textPanel.textWidth) / 2;
            if (this.leftOrRight == LEFT)
            {
                this.textPanel.x = this.icon.x + this.icon.width;
            }
            else if (this.leftOrRight == RIGHT)
            {
                this.textPanel.x = 0;
            }
            return;
        }// end function

        protected function onMouseOver(event:MouseEvent) : void
        {
            this.bg.alpha = 0.7;
            return;
        }// end function

        protected function onMouseOut(event:MouseEvent) : void
        {
            this.bg.alpha = 0.4;
            return;
        }// end function

        public function set inProcess(param1:Boolean) : void
        {
            if (_modelLocator.isActionWidgets)
            {
                this._inProcess = param1;
                if (this._inProcess)
                {
                    this.mouseChildren = false;
                    this.mouseEnabled = false;
                    this.coverArea = new CommonMask(W, H, 0, 0.6, CommonMask.TYPE_S);
                    this.addChild(this.coverArea);
                    this.inProgressIcon = new BufferIcon();
                    this.inProgressIcon.x = (W - this.inProgressIcon.width) / 2;
                    this.inProgressIcon.y = (H - this.inProgressIcon.height) / 2;
                    this.addChild(this.inProgressIcon);
                }
                else
                {
                    if (this.coverArea != null && this.contains(this.coverArea))
                    {
                        this.removeChild(this.coverArea);
                    }
                    if (this.inProgressIcon != null && this.contains(this.inProgressIcon))
                    {
                        this.removeChild(this.inProgressIcon);
                    }
                    this.mouseChildren = true;
                    this.mouseEnabled = true;
                }
            }
            return;
        }// end function

        protected function onComplete(event:WidgetsEvent) : void
        {
            return;
        }// end function

        protected function onError(event:WidgetsEvent) : void
        {
            return;
        }// end function

    }
}
