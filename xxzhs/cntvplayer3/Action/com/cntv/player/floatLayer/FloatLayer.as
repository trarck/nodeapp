package com.cntv.player.floatLayer
{
    import com.cntv.common.view.ui.*;
    import com.cntv.player.floatLayer.config.*;
    import com.cntv.player.floatLayer.event.*;
    import com.cntv.player.floatLayer.quality.*;
    import com.cntv.player.floatLayer.share.*;
    import flash.display.*;

    public class FloatLayer extends CommonSprite
    {
        private var m_qualityPanel:CQualityPanel;
        private var m_configPanel:CConfigPanel;
        private var m_sharePanel:CSharePanel;

        public function FloatLayer()
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.m_qualityPanel = new CQualityPanel();
            this.addChild(this.m_qualityPanel);
            this.m_qualityPanel.visible = false;
            this.m_configPanel = new CConfigPanel();
            this.addChild(this.m_configPanel);
            this.m_configPanel.visible = false;
            this.m_sharePanel = new CSharePanel();
            this.addChild(this.m_sharePanel);
            this.m_sharePanel.visible = false;
            _dispatcher.addEventListener(FLayerEvent.EVENT_SHOW_PANEL, this.onShowPanel);
            return;
        }// end function

        override protected function adjust() : void
        {
            this.m_qualityPanel.x = (stage.stageWidth - this.m_qualityPanel.width) / 2;
            this.m_qualityPanel.y = (stage.stageHeight - this.m_qualityPanel.height) / 2;
            this.m_configPanel.x = (stage.stageWidth - this.m_configPanel.width) / 2;
            this.m_configPanel.y = (stage.stageHeight - this.m_configPanel.height) / 2;
            this.m_sharePanel.x = (stage.stageWidth - this.m_sharePanel.width) / 2;
            this.m_sharePanel.y = (stage.stageHeight - this.m_sharePanel.height) / 2;
            return;
        }// end function

        private function hideAll() : void
        {
            this.m_qualityPanel.visible = false;
            this.m_configPanel.visible = false;
            this.m_sharePanel.visible = false;
            return;
        }// end function

        private function onShowPanel(event:FLayerEvent) : void
        {
            var _loc_2:DisplayObject = null;
            switch(event.data)
            {
                case "quality":
                {
                    _loc_2 = this.m_qualityPanel;
                    this.m_qualityPanel.setCurrentStatus();
                    break;
                }
                case "config":
                {
                    _loc_2 = this.m_configPanel;
                    this.m_configPanel.setStatus();
                    break;
                }
                case "share":
                {
                    _loc_2 = this.m_sharePanel;
                    this.m_sharePanel.initView();
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_2 !== this.m_configPanel)
            {
                this.m_configPanel.oncancelBtnClick();
            }
            if (_loc_2.visible == true)
            {
                _loc_2.visible = false;
                this.m_configPanel.oncancelBtnClick();
                return;
            }
            this.hideAll();
            if (_loc_2)
            {
                _loc_2.x = (stage.stageWidth - _loc_2.width) / 2;
                _loc_2.y = (stage.stageHeight - _loc_2.height) / 2;
                _loc_2.visible = true;
            }
            stage.addChild(this);
            return;
        }// end function

    }
}
