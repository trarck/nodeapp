package com.cntv.player.playerCom.relativeList.view
{
    import caurina.transitions.*;
    import com.cntv.common.view.ui.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.net.*;

    public class RelativeIcon extends CommonSprite
    {
        private var bg:CommonMask;
        private var image:DisplayObject;
        private var _iconW:Number;
        private var _iconH:Number;

        public function RelativeIcon(param1:Number, param2:Number, param3:String)
        {
            this.alpha = 0;
            this._iconW = param1;
            this._iconH = param2;
            new ImageLoader(new URLRequest(param3), this.getImage, this.getImageError);
            Tweener.addTween(this, {time:2, alpha:1});
            return;
        }// end function

        private function getImage(param1:DisplayObject) : void
        {
            this.image = param1;
            this.image.width = this._iconW;
            this.image.height = this._iconH;
            this.addChild(this.image);
            return;
        }// end function

        private function getImageError(param1:String) : void
        {
            return;
        }// end function

        override protected function release() : void
        {
            return;
        }// end function

    }
}
