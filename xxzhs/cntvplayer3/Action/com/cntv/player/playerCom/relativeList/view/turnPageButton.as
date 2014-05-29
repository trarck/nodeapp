package com.cntv.player.playerCom.relativeList.view
{
    import com.cntv.common.view.ui.*;
    import com.puremvc.view.event.*;
    import flash.events.*;

    public class turnPageButton extends CommonSprite
    {
        private var buttonPrev:ButtonPrev;
        private var buttonNext:ButtonNext;
        public static const EVENT_CLICK:String = "CLICK";
        public static var Hei:Number = 30;

        public function turnPageButton(param1:Boolean)
        {
            this.buttonPrev = new ButtonPrev();
            this.buttonPrev.buttonMode = true;
            this.buttonNext = new ButtonNext();
            this.buttonNext.buttonMode = true;
            this.buttonPrev.addEventListener(MouseEvent.CLICK, this.onPre);
            this.buttonNext.addEventListener(MouseEvent.CLICK, this.onNext);
            this.addChild(this.buttonPrev);
            this.addChild(this.buttonNext);
            this.buttonNext.x = this.buttonPrev.width;
            this.adJustPos(param1);
            return;
        }// end function

        private function onPre(event:MouseEvent) : void
        {
            this.dispatchEvent(new CommonEvent("CLICK", "pre"));
            return;
        }// end function

        private function onNext(event:MouseEvent) : void
        {
            this.dispatchEvent(new CommonEvent("CLICK", "next"));
            return;
        }// end function

        public function adJustPos(param1:Boolean = true) : void
        {
            if (_modelLocator.noVideoData)
            {
                this.buttonPrev.visible = false;
                this.buttonNext.visible = false;
            }
            else if (param1)
            {
                this.buttonPrev.scaleX = 1;
                this.buttonPrev.scaleY = 1;
                this.buttonNext.scaleY = 1;
                this.buttonNext.scaleX = 1;
                this.buttonNext.x = this.buttonPrev.width;
            }
            else
            {
                this.buttonPrev.scaleX = 0.8;
                this.buttonPrev.scaleY = 0.8;
                this.buttonNext.scaleY = 0.8;
                this.buttonNext.scaleX = 0.8;
                this.buttonNext.x = this.buttonPrev.width * 0.8;
            }
            return;
        }// end function

    }
}
