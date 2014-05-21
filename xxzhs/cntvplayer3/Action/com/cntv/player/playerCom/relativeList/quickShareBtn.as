package com.cntv.player.playerCom.relativeList
{
    import com.cntv.common.tools.text.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class quickShareBtn extends Sprite
    {
        private var m_name:String = "";
        private var m_ob:DisplayObject;
        private var m_copyText:TextField;
        private var m_btn:Sprite;
        private var m_btnWidth:Number = 40;
        private var m_btnHeight:Number = 20;

        public function quickShareBtn(param1:String, param2:DisplayObject)
        {
            this.m_copyText = new TextField();
            this.m_btn = new Sprite();
            this.m_name = param1;
            this.m_ob = param2;
            this.addChild(this.m_ob);
            MyToolTip.Create(this, param1);
            this.buttonMode = true;
            this.addEventListener(MouseEvent.MOUSE_OVER, this.onOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.onOut);
            return;
        }// end function

        private function onOver(event:MouseEvent) : void
        {
            this.m_ob.scaleX = 1.2;
            this.m_ob.scaleY = 1.2;
            this.m_ob.x = -2;
            this.m_ob.y = -2;
            return;
        }// end function

        private function onOut(event:MouseEvent) : void
        {
            this.m_ob.scaleX = 1;
            this.m_ob.scaleY = 1;
            this.m_ob.x = 0;
            this.m_ob.y = 0;
            return;
        }// end function

    }
}
