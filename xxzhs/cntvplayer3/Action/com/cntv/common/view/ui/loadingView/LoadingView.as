package com.cntv.common.view.ui.loadingView
{
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.statuBox.view.*;
    import flash.text.*;

    public class LoadingView extends CommonSprite
    {
        private var icon:BufferBigIcon;
        private var txt:TextField;
        private var p2pDownloadNotice:P2PDownloadNoticePanel;

        public function LoadingView()
        {
            this.icon = new BufferBigIcon();
            this.addChild(this.icon);
            this.txt = TextGenerator.createTxt(16777215, 14, _modelLocator.i18n.STATU_LOADING);
            this.txt.y = this.icon.height;
            this.icon.x = (this.txt.textWidth - this.icon.width) / 2;
            this.addChild(this.txt);
            this.txt.x = this.icon.x - (this.txt.textWidth - this.icon.width) / 2;
            if (!_modelLocator.paramVO.isP2pInstall && _modelLocator.isP2PNotice && _modelLocator.paramVO.p2pTrigger)
            {
                this.p2pDownloadNotice = new P2PDownloadNoticePanel();
                this.p2pDownloadNotice.x = (this.width - P2PDownloadNoticePanel.W) / 2;
                this.p2pDownloadNotice.y = this.height + 3;
                this.addChild(this.p2pDownloadNotice);
            }
            return;
        }// end function

        override public function get width() : Number
        {
            return this.txt.width;
        }// end function

        override public function set width(param1:Number) : void
        {
            super.width = param1;
            return;
        }// end function

        override public function get height() : Number
        {
            return this.icon.height + this.txt.height;
        }// end function

        override public function set height(param1:Number) : void
        {
            super.height = param1;
            return;
        }// end function

    }
}
