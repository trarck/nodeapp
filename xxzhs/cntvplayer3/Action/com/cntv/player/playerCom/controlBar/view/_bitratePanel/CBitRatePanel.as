package com.cntv.player.playerCom.controlBar.view._bitratePanel
{
    import caurina.transitions.*;
    import com.cntv.common.events.*;
    import com.cntv.common.tools.graphics.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.floatLayer.event.*;
    import com.cntv.player.playerCom.controlBar.event.*;
    import com.cntv.player.playerCom.controlBar.view.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.puremvc.view.event.*;
    import flash.display.*;
    import flash.events.*;

    public class CBitRatePanel extends CommonSprite
    {
        private var m_bg:Sprite;
        private var modLabels:Array;
        private var modBtnArr:Array;
        private var mode:CModeBtn;
        private var modelayer:Sprite;
        private var container:Sprite;
        private var triangle:Sprite;
        private var _parent:ControlBarModule;

        public function CBitRatePanel(param1:ControlBarModule)
        {
            this.modLabels = [];
            this.modBtnArr = [];
            this._parent = param1;
            _dispatcher.addEventListener(FLayerEvent.EVENT_SHOW_QUALITYPANEL, this.onShowPanel);
            _dispatcher.addEventListener(RadioButtonEvent.EVENT_STREAM_CHANGED, this.onChangeConviva);
            return;
        }// end function

        private function onChangeConviva(event:RadioButtonEvent) : void
        {
            var _loc_2:Number = NaN;
            this.pushConvivaArray();
            _dispatcher.dispatchEvent(new ControlBarEvent(ControlBarEvent.EVENT_SET_TEXT2, this.modLabels[event.data]));
            if (this.modBtnArr.length > 0)
            {
                _loc_2 = 0;
                while (_loc_2 < this.modLabels.length)
                {
                    
                    this.modBtnArr[_loc_2].setState(false);
                    _loc_2 = _loc_2 + 1;
                }
                this.modBtnArr[event.data].setState(true);
            }
            return;
        }// end function

        private function onShowPanel(event:CommonEvent) : void
        {
            if (_modelLocator.isConvivaMode && !_modelLocator.currentVideoInfo.isRtmp)
            {
                this.pushConvivaArray();
            }
            else if (_modelLocator.currentVddBitRates.length > 0)
            {
                this.pushArray(_modelLocator.currentVddBitRates);
            }
            this._parent.adjustBitratePanel(this.modLabels.length);
            this.displayPanel();
            return;
        }// end function

        override protected function adjust() : void
        {
            this._parent.adjustBitratePanel(this.modLabels.length);
            return;
        }// end function

        private function pushConvivaArray() : void
        {
            if (this.modLabels.length > 0)
            {
                return;
            }
            if (_modelLocator.currentVideoInfo.chapters.length != 0)
            {
                this.modLabels.push(_modelLocator.i18n.LOWERDEFINITION);
            }
            if (_modelLocator.currentVideoInfo.chapters2.length != 0)
            {
                this.modLabels.push(_modelLocator.i18n.STANDARDDEFINITION);
            }
            if (_modelLocator.currentVideoInfo.chapters3.length != 0)
            {
                this.modLabels.push(_modelLocator.i18n.HIGHDEFINITION);
            }
            if (_modelLocator.currentVideoInfo.chapters4.length != 0)
            {
                this.modLabels.push(_modelLocator.i18n.SUPERDIFINITION);
            }
            if (_modelLocator.currentVideoInfo.chapters5.length != 0)
            {
                this.modLabels.push(_modelLocator.i18n.SUPERHIGHDIFINITION);
            }
            return;
        }// end function

        private function pushArray(param1:Array) : void
        {
            var _loc_2:Number = 0;
            while (_loc_2 < param1.length)
            {
                
                switch(param1[_loc_2])
                {
                    case "LD":
                    {
                        this.modLabels.push(_modelLocator.i18n.LOWERDEFINITION);
                        break;
                    }
                    case "STD":
                    {
                        this.modLabels.push(_modelLocator.i18n.STANDARDDEFINITION);
                        break;
                    }
                    case "HD":
                    {
                        this.modLabels.push(_modelLocator.i18n.HIGHDEFINITION);
                        break;
                    }
                    case "SD":
                    {
                        this.modLabels.push(_modelLocator.i18n.SUPERDIFINITION);
                        break;
                    }
                    case "SHD":
                    {
                        this.modLabels.push(_modelLocator.i18n.SUPERHIGHDIFINITION);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_2 = _loc_2 + 1;
            }
            if (_modelLocator.currentVideoInfo.isRtmp)
            {
                this.modLabels.push(_modelLocator.i18n.AUTOADAPT);
            }
            return;
        }// end function

        private function displayPanel() : void
        {
            var _loc_5:Number = NaN;
            this.container = new Sprite();
            this.addChild(this.container);
            this.container.visible = false;
            this.container.scaleX = 0;
            this.container.scaleY = 0;
            this.container.x = 0;
            this.container.y = 0;
            this.modelayer = new Sprite();
            this.modelayer.graphics.beginFill(16711680, 1);
            this.modelayer.graphics.drawRect(0, 0, 85, 170);
            this.modelayer.graphics.endFill();
            this.addEventListener(MouseEvent.ROLL_OUT, this.onMouseOut);
            this.m_bg = new Sprite();
            this.container.addChild(this.m_bg);
            this.m_bg.alpha = 0.8;
            var _loc_1:Array = [3026478, 4342338];
            var _loc_2:Array = [1, 1];
            var _loc_3:Array = [0, 255];
            CPhotoProgress.gradientFill(this.m_bg, {linearFill:true, spread:1, linearRGB:true, focus:1}, {x:0, y:0, w:85, h:this.modLabels.length * 20 + 20, a:-1.5}, _loc_1, _loc_2, _loc_3);
            this.triangle = new Sprite();
            this.triangle.graphics.moveTo(38, this.modLabels.length * 20 + 20);
            this.triangle.graphics.beginFill(3026478, 1);
            this.triangle.graphics.lineStyle(1, 3026478, 1);
            this.triangle.graphics.lineTo(43, this.modLabels.length * 20 + 25);
            this.triangle.graphics.lineTo(48, this.modLabels.length * 20 + 20);
            this.triangle.graphics.lineTo(38, this.modLabels.length * 20 + 20);
            this.triangle.graphics.endFill();
            this.triangle.alpha = 0.8;
            this.container.addChild(this.triangle);
            var _loc_4:Number = 0;
            while (_loc_4 < this.modLabels.length)
            {
                
                this.mode = new CModeBtn(this.modLabels[_loc_4], _loc_4, this);
                this.modBtnArr.push(this.mode);
                this.container.addChild(this.mode);
                this.mode.y = _loc_4 * 20 + 10;
                _loc_4 = _loc_4 + 1;
            }
            if (_modelLocator.isConvivaMode)
            {
                this.modBtnArr[_modelLocator.currentHttpBiteRateMode].setState(true);
            }
            else
            {
                _loc_5 = 0;
                while (_loc_5 < this.modLabels.length)
                {
                    
                    if (this.changeRatetest(this.modLabels[_loc_5]) == _modelLocator.currentVideoInfo.vddStreamRate)
                    {
                        this.modBtnArr[_loc_5].setState(true);
                    }
                    _loc_5 = _loc_5 + 1;
                }
            }
            return;
        }// end function

        private function changeRatetest(param1:String) : String
        {
            var _loc_2:String = null;
            switch(param1)
            {
                case "流 畅":
                case "200K":
                {
                    _loc_2 = "LD";
                    break;
                }
                case "标 清":
                case "450K":
                {
                    _loc_2 = "STD";
                    break;
                }
                case "高 清":
                case "850K":
                {
                    _loc_2 = "HD";
                    break;
                }
                case "超 清":
                case "1200K":
                {
                    _loc_2 = "SD";
                    break;
                }
                case "超 高 清":
                case "2000K":
                {
                    _loc_2 = "SHD";
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        private function getindex(param1:String) : int
        {
            var _loc_2:int = 0;
            switch(param1)
            {
                case "标 清":
                case "200K":
                {
                    _loc_2 = 0;
                    break;
                }
                case "高 清":
                case "450K":
                {
                    _loc_2 = 1;
                    break;
                }
                case "流 畅":
                case "850K":
                {
                    _loc_2 = 2;
                    break;
                }
                case "超 清":
                case "1200K":
                {
                    _loc_2 = 3;
                    break;
                }
                case "超 高 清":
                case "2000K":
                {
                    _loc_2 = 4;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function updata3DModeState(param1:Number) : void
        {
            var _loc_2:Number = 0;
            while (_loc_2 < this.modBtnArr.length)
            {
                
                if (param1 != _loc_2)
                {
                    this.modBtnArr[_loc_2].setState(false);
                }
                _loc_2 = _loc_2 + 1;
            }
            var _loc_3:* = _modelLocator.currentHttpBiteRateMode;
            if (_modelLocator.currentVideoInfo.isRtmp)
            {
                _loc_3 = _modelLocator.currentRtmpBiteRateMode;
            }
            if (_loc_3 != this.getindex(this.modLabels[param1]))
            {
                if (_modelLocator.currentVideoInfo.isRtmp)
                {
                    _modelLocator.currentRtmpBiteRateMode = this.getindex(this.modLabels[param1]);
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_BITERATE_MODE_CHANGE));
                }
                else
                {
                    _modelLocator.currentHttpBiteRateMode = this.getindex(this.modLabels[param1]);
                    _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_HTTP_BITERATE_MODE_CHANGE));
                }
            }
            return;
        }// end function

        private function onMouseOut(event:MouseEvent) : void
        {
            return;
        }// end function

        public function set _visible(param1:Boolean) : void
        {
            if (param1)
            {
                this.container.visible = true;
                Tweener.removeTweens(this.container);
                Tweener.addTween(this.container, {time:0.3, x:0, y:0, scaleX:1, scaleY:1, alpha:1});
            }
            else
            {
                Tweener.removeTweens(this.container);
                Tweener.addTween(this.container, {time:0.3, x:45, y:150, scaleX:0, scaleY:0, alpha:0});
            }
            return;
        }// end function

    }
}
