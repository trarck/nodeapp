package com.cntv.player.playerCom.statuBox.view
{
    import com.cntv.common.events.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.tools.recorder.*;
    import com.cntv.common.view.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.statuBox.view.p2pNoticeIcon.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;

    public class P2PDownloadNoticePanel extends CommonSprite
    {
        private var bg:CommonMask;
        private var icon:P2PNoticeIcon;
        private var txtTitle:TextField;
        private var gFilter:GlowFilter;
        private var cover:CommonMask;
        public static const EVENT_CLOSE:String = "event.close";
        public static const W:Number = 355;
        public static const H:Number = 50;

        public function P2PDownloadNoticePanel()
        {
            this.graphics.lineStyle(1, 6710886, 1);
            this.graphics.drawRoundRect(0, 0, W, H, 20, 20);
            this.bg = new CommonMask(W, H, 16777215, 0.25, CommonMask.TYPE_R, 20, 20);
            this.addChild(this.bg);
            this.icon = new P2PNoticeIcon();
            this.icon.x = 10;
            this.icon.y = (H - this.icon.height) / 2;
            this.addChild(this.icon);
            this.txtTitle = TextGenerator.createFontHtmlTxt(0, 16, _modelLocator.i18n.WIDEGTS_DOWNLOAD_ACCELERATOR_NOTICE, "", false, 315);
            this.txtTitle.x = (315 - this.txtTitle.textWidth) / 2 + this.icon.x + this.icon.width - 5;
            this.txtTitle.y = (H - this.txtTitle.height) / 2;
            this.gFilter = new GlowFilter(16777215, 0.5, 1.5, 1.5, 50, 2);
            this.txtTitle.filters = [this.gFilter];
            this.addChild(this.txtTitle);
            this.cover = new CommonMask(W, H, 0, 0, CommonMask.TYPE_S);
            this.cover.buttonMode = true;
            this.cover.addEventListener(MouseEvent.CLICK, this.openP2PPage);
            this.addChild(this.cover);
            return;
        }// end function

        private function openP2PPage(event:MouseEvent) : void
        {
            _dispatcher.dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_BUTTON_CLICK, ButtonClickHotMap.P2PNOTICE_CLICK));
            NativeToURLTool.openAURL(_modelLocator.paramVO.speedUperPath, "_blank", true);
            return;
        }// end function

        override protected function release() : void
        {
            super.release();
            this.cover.removeEventListener(MouseEvent.CLICK, this.openP2PPage);
            return;
        }// end function

    }
}
