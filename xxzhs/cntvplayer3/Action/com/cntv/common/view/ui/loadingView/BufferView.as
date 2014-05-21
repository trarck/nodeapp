package com.cntv.common.view.ui.loadingView
{
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.statuBox.view.*;
    import flash.text.*;

    public class BufferView extends CommonSprite
    {
        private var icon:BufferBigIcon;
        private var txt:TextField;
        private var p_txt:TextField;
        private var p2pDownloadNotice:P2PDownloadNoticePanel;
        private var changeRateNotice:ChangeRateNotice;
        public static var instance:BufferView;

        public function BufferView()
        {
            this.icon = new BufferBigIcon();
            this.addChild(this.icon);
            this.txt = TextGenerator.createTxt(16777215, 14, _modelLocator.i18n.STATU_BUFFERING);
            this.p_txt = TextGenerator.createTxt(16777215, 14, "0%");
            this.txt.y = this.icon.height + 10;
            this.addChild(this.txt);
            this.p_txt.y = this.icon.height;
            if (!_modelLocator.paramVO.isP2pInstall && _modelLocator.isP2PNotice && _modelLocator.paramVO.p2pTrigger)
            {
                this.p2pDownloadNotice = new P2PDownloadNoticePanel();
                this.p2pDownloadNotice.x = (this.width - P2PDownloadNoticePanel.W) / 2;
                this.p2pDownloadNotice.y = this.height + 3;
                this.addChild(this.p2pDownloadNotice);
            }
            this.changeRateNotice = new ChangeRateNotice();
            this.changeRateNotice.y = this.height + 3;
            this.addChild(this.changeRateNotice);
            instance = this;
            return;
        }// end function

        override protected function init() : void
        {
            return;
        }// end function

        public function showNotice(param1:Number) : void
        {
            if (param1 == 2 || _modelLocator.currentVideoInfo.lowChapters != null && _modelLocator.currentVideoInfo.lowChapters.length == 0 && param1 == 0)
            {
                this.changeRateNotice.Visible = false;
            }
            else
            {
                this.changeRateNotice.x = this.icon.x - (this.changeRateNotice.getWidth() - this.icon.width) / 2;
                this.changeRateNotice.Visible = true;
            }
            return;
        }// end function

        public function setPercent(param1:int) : void
        {
            this.txt.text = _modelLocator.i18n.STATU_BUFFERING + " " + param1 + "%";
            this.icon.x = (this.txt.textWidth + this.p_txt.textWidth - this.icon.width - 10) / 2;
            this.txt.x = this.icon.x - (this.txt.textWidth - this.icon.width) / 2;
            this.p_txt.x = this.txt.textWidth + this.txt.x + 5;
            return;
        }// end function

        override public function get width() : Number
        {
            return this.txt.width + this.p_txt.width + 5;
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
