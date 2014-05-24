package com.cntv.common.tools.text
{
    import flash.display.*;
    import flash.events.*;

    public class MyToolTip extends MovieClip
    {
        public static var tips:Array = new Array();

        public function MyToolTip()
        {
            return;
        }// end function

        public function create(param1:InteractiveObject, param2:String) : void
        {
            Create(param1, param2);
            return;
        }// end function

        public static function Create(param1:InteractiveObject, param2:String, param3:Boolean = false) : void
        {
            var a:*;
            var toolTip:MyTip;
            var showToolFunction:Function;
            var hideToolFunction:Function;
            var owner:* = param1;
            var text:* = param2;
            var show:* = param3;
            var _loc_5:int = 0;
            var _loc_6:* = tips;
            while (_loc_6 in _loc_5)
            {
                
                a = _loc_6[_loc_5];
                if (tips[a].owner == owner)
                {
                    tips[a].text = text;
                    return;
                }
            }
            toolTip = new MyTip(owner, text);
            tips.push(toolTip);
            showToolFunction = function (event:MouseEvent) : void
            {
                if (owner.stage == null)
                {
                    return;
                }
                owner.stage.addChild(toolTip);
                owner.addEventListener(MouseEvent.MOUSE_OUT, hideToolFunction);
                owner.removeEventListener(MouseEvent.MOUSE_OVER, showToolFunction);
                return;
            }// end function
            ;
            hideToolFunction = function () : void
            {
                if (owner.stage == null)
                {
                    toolTip = null;
                    return;
                }
                owner.stage.removeChild(toolTip);
                owner.addEventListener(MouseEvent.MOUSE_OVER, showToolFunction);
                owner.removeEventListener(MouseEvent.MOUSE_OUT, hideToolFunction);
                return;
            }// end function
            ;
            owner.addEventListener(MouseEvent.MOUSE_OVER, showToolFunction);
            if (show)
            {
                owner.stage.addChild(toolTip);
                owner.addEventListener(MouseEvent.MOUSE_OUT, hideToolFunction);
            }
            else
            {
                owner.addEventListener(MouseEvent.MOUSE_OVER, showToolFunction);
            }
            return;
        }// end function

    }
}

class MyTip extends Sprite
{
    public var owner:InteractiveObject;
    private var toolTip:TextField;
    private var _text:String;

    function MyTip(param1:InteractiveObject, param2:String) : void
    {
        this.owner = param1;
        this._text = param2;
        this.addEventListener(Event.ADDED_TO_STAGE, this.listener);
        this.addEventListener(Event.REMOVED_FROM_STAGE, this.relistener);
        this.toolTip = new TextField();
        this.toolTip.visible = true;
        this.toolTip.text = param2;
        this.toolTip.background = true;
        this.toolTip.backgroundColor = 16777215;
        this.toolTip.border = true;
        this.toolTip.borderColor = 0;
        this.toolTip.multiline = false;
        this.toolTip.wordWrap = false;
        this.toolTip.autoSize = TextFieldAutoSize.LEFT;
        this.toolTip.selectable = false;
        this.toolTip.mouseEnabled = false;
        var _loc_3:* = new TextFormat();
        _loc_3.font = "_sans";
        _loc_3.leftMargin = 4;
        _loc_3.rightMargin = 4;
        _loc_3.size = 12;
        this.toolTip.setTextFormat(_loc_3);
        this.addChild(this.toolTip);
        this.alpha = 0.8;
        return;
    }// end function

    public function get text() : String
    {
        return this._text;
    }// end function

    public function set text(param1:String) : void
    {
        this._text = param1;
        this.toolTip.text = param1;
        return;
    }// end function

    private function relistener(event:Event) : void
    {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler);
        return;
    }// end function

    private function listener(event:Event) : void
    {
        if (stage.mouseX >= stage.stageWidth - 50)
        {
            this.x = this.parent.mouseX - this.toolTip.textWidth - 25;
        }
        else
        {
            this.x = this.parent.mouseX + 12;
        }
        this.y = this.parent.mouseY - 12;
        stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMoveHandler);
        return;
    }// end function

    private function onMouseMoveHandler(event:MouseEvent) : void
    {
        if (this.owner.stage != null)
        {
            if (stage.mouseX >= stage.stageWidth - 50)
            {
                this.x = this.parent.mouseX - this.toolTip.textWidth - 25;
            }
            else
            {
                this.x = this.parent.mouseX + 12;
            }
            this.y = this.parent.mouseY - 12;
        }
        else
        {
            this.parent.removeChild(this);
        }
        return;
    }// end function

}

