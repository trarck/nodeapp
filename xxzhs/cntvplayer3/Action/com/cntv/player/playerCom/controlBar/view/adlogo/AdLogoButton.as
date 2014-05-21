package com.cntv.player.playerCom.controlBar.view.adlogo
{
    import com.cntv.common.events.*;
    import com.cntv.common.model.proxy.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.common.view.ui.*;
    import com.utils.net.request.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class AdLogoButton extends CommonSprite
    {
        private var image:DisplayObject;
        private var defaultIcon:DefaultLogo;
        public static const W:Number = 53;
        public static const H:Number = 22;

        public function AdLogoButton()
        {
            if (_modelLocator.paramVO.adLogo != "")
            {
                _dispatcher.addEventListener(ADEvent.EVENT_GET_LOGO_AD_DATA, this.getLogoADData);
                new GetADDataProxy(GetADDataProxy.TYPE_LOGO);
            }
            else
            {
                _modelLocator.adIconVO = new ADLogoVO();
                _modelLocator.adIconVO.image = _modelLocator.paramVO.logoImageURL;
                _modelLocator.adIconVO.url = _modelLocator.paramVO.logoURL;
                if (_modelLocator.adIconVO != null)
                {
                    new ImageLoader(new URLRequest(_modelLocator.adIconVO.image), this.getImage, this.getImageError);
                }
                else
                {
                    this.addDefaultLogo();
                }
            }
            return;
        }// end function

        private function getLogoADData(event:Event) : void
        {
            if (_modelLocator.adVosLogo != null && _modelLocator.adVosLogo.length > 0)
            {
                new ImageLoader(new URLRequest(_modelLocator.adVosLogo[0]["url"]), this.getImage, this.getImageError);
            }
            else
            {
                this.addDefaultLogo();
            }
            return;
        }// end function

        private function getImage(param1:DisplayObject) : void
        {
            this.image = param1;
            this.image.width = W;
            this.image.height = H;
            this.addChild(this.image);
            this.addTargetOpen();
            return;
        }// end function

        private function getImageError(param1:String) : void
        {
            this.addDefaultLogo();
            return;
        }// end function

        private function addDefaultLogo() : void
        {
            this.defaultIcon = new DefaultLogo();
            this.defaultIcon.width = W;
            this.addChild(this.defaultIcon);
            this.addTargetOpen();
            return;
        }// end function

        private function addTargetOpen() : void
        {
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK, this.openURL);
            return;
        }// end function

        private function openURL(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.LOGO_CLICK));
            if (_modelLocator.adIconVO != null)
            {
                NativeToURLTool.openAURL(_modelLocator.adIconVO.url);
            }
            else if (_modelLocator.adVosLogo != null && _modelLocator.adVosLogo.length > 0)
            {
                NativeToURLTool.openAURL(_modelLocator.adVosLogo[0]["adLink"]);
            }
            return;
        }// end function

        override public function get width() : Number
        {
            return W;
        }// end function

        override public function get height() : Number
        {
            return H;
        }// end function

    }
}
