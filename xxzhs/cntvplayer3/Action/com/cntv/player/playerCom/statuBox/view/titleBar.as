package com.cntv.player.playerCom.statuBox.view
{
    import com.cntv.common.tools.graphics.*;
    import com.cntv.common.view.ui.*;
    import com.cntv.player.playerCom.video.events.*;
    import com.cntv.player.widgets.views.ratebutton.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class titleBar extends CommonSprite
    {
        private var title:TextField;
        private var screenBtn:Sprite;
        private var screenText:TextField;
        private var formart:TextFormat;
        public var H:Number = 25;
        private var bk:Sprite;
        private var btn1:RateButton1;
        private var btn2:RateButton2;
        private var btn3:RateButton3;
        private var btn4:RateButton4;

        public function titleBar()
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.bk = new Sprite();
            this.addChild(this.bk);
            this.title = new TextField();
            this.title.defaultTextFormat = new TextFormat("", 14, 14540253, true);
            this.title.width = 400;
            this.addChild(this.title);
            this.title.x = 10;
            this.title.y = 8;
            this.btn1 = new RateButton1(this);
            this.btn2 = new RateButton2(this);
            this.btn3 = new RateButton3(this);
            this.btn4 = new RateButton4(this);
            this.btn1._visible = true;
            if (_modelLocator.paramVO.isshowProButton)
            {
                this.addChild(this.btn1);
                this.addChild(this.btn2);
                this.addChild(this.btn3);
                this.addChild(this.btn4);
            }
            var _loc_4:int = -1000;
            this.btn4.y = -1000;
            var _loc_4:* = _loc_4;
            this.btn3.y = _loc_4;
            var _loc_4:* = _loc_4;
            this.btn2.y = _loc_4;
            this.btn1.y = _loc_4;
            this.screenBtn = new Sprite();
            this.addChild(this.screenBtn);
            this.formart = new TextFormat("", 12, 16711680);
            this.screenText = new TextField();
            this.screenText.defaultTextFormat = this.formart;
            this.screenText.width = 60;
            this.screenText.height = 20;
            this.screenText.text = _modelLocator.i18n.CONTROLBAR_NOTICE_NORMALSCREEN;
            this.screenText.y = 8;
            this.screenBtn.addChild(this.screenText);
            this.screenBtn.mouseChildren = false;
            this.screenBtn.buttonMode = true;
            this.screenBtn.addEventListener(MouseEvent.ROLL_OVER, this.onScreenOver);
            this.screenBtn.addEventListener(MouseEvent.ROLL_OUT, this.onScreenOut);
            this.screenBtn.addEventListener(MouseEvent.CLICK, this.onScreenClick);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            _dispatcher.addEventListener(VideoPlayEvent.EVENT_SET_VIDEO_CHANGEBTN2, this.changeBtn);
            this.screenText.x = stage.stageWidth - 58;
            this.btn1.x = (stage.stageWidth - this.btn1.width * 4) / 2;
            this.btn2.x = this.btn1.x + this.btn1.width;
            this.btn3.x = this.btn2.x + this.btn1.width;
            this.btn4.x = this.btn3.x + this.btn1.width;
            var _loc_1:Array = [0, 0];
            var _loc_2:Array = [0, 1];
            var _loc_3:Array = [0, 250];
            CPhotoProgress.gradientFill(this.bk, {linearFill:true, spread:1, linearRGB:true, focus:0.8}, {x:0, y:0, w:stage.stageWidth, h:35, a:-1.5}, _loc_1, _loc_2, _loc_3);
            return;
        }// end function

        private function onMouseWheel(event:MouseEvent) : void
        {
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                if (event.delta > 0)
                {
                    var _loc_2:* = _modelLocator;
                    var _loc_3:* = _modelLocator.videoSizeMode + 1;
                    _loc_2.videoSizeMode = _loc_3;
                    if (_modelLocator.videoSizeMode > 4)
                    {
                        _modelLocator.videoSizeMode = 1;
                    }
                }
                else
                {
                    var _loc_2:* = _modelLocator;
                    var _loc_3:* = _modelLocator.videoSizeMode - 1;
                    _loc_2.videoSizeMode = _loc_3;
                    if (_modelLocator.videoSizeMode < 1)
                    {
                        _modelLocator.videoSizeMode = 4;
                    }
                }
                this.setbutton(_modelLocator.videoSizeMode);
            }
            return;
        }// end function

        private function changeBtn(event:VideoPlayEvent) : void
        {
            var _loc_2:Boolean = false;
            this.btn4._visible = false;
            var _loc_2:* = _loc_2;
            this.btn3._visible = _loc_2;
            var _loc_2:* = _loc_2;
            this.btn2._visible = _loc_2;
            this.btn1._visible = _loc_2;
            switch(event.data)
            {
                case 1:
                {
                    this.btn1._visible = true;
                    break;
                }
                case 2:
                {
                    this.btn2._visible = true;
                    break;
                }
                case 3:
                {
                    this.btn3._visible = true;
                    break;
                }
                case 4:
                {
                    this.btn4._visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function setbutton(param1:Number) : void
        {
            var _loc_2:Boolean = false;
            this.btn4._visible = false;
            var _loc_2:* = _loc_2;
            this.btn3._visible = _loc_2;
            var _loc_2:* = _loc_2;
            this.btn2._visible = _loc_2;
            this.btn1._visible = _loc_2;
            _modelLocator.videoSizeMode = param1;
            switch(param1)
            {
                case 1:
                {
                    this.btn1._visible = true;
                    break;
                }
                case 2:
                {
                    this.btn2._visible = true;
                    break;
                }
                case 3:
                {
                    this.btn3._visible = true;
                    break;
                }
                case 4:
                {
                    this.btn4._visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_PROPORTIONS, param1));
            _dispatcher.dispatchEvent(new VideoPlayEvent(VideoPlayEvent.EVENT_SET_VIDEO_CHANGEBTN, param1));
            return;
        }// end function

        private function onScreenOver(event:MouseEvent) : void
        {
            this.formart.underline = true;
            this.screenText.setTextFormat(this.formart);
            return;
        }// end function

        private function onScreenClick(event:MouseEvent) : void
        {
            stage.displayState = StageDisplayState.NORMAL;
            return;
        }// end function

        private function onScreenOut(event:MouseEvent) : void
        {
            this.formart.underline = false;
            this.screenText.setTextFormat(this.formart);
            return;
        }// end function

        override protected function adjust() : void
        {
            this.screenText.x = stage.stageWidth - 58;
            this.btn1.x = (stage.stageWidth - this.btn1.width * 4) / 2;
            this.btn2.x = this.btn1.x + this.btn1.width;
            this.btn3.x = this.btn2.x + this.btn1.width;
            this.btn4.x = this.btn3.x + this.btn1.width;
            var _loc_1:int = 8;
            this.btn4.y = 8;
            var _loc_1:* = _loc_1;
            this.btn3.y = _loc_1;
            var _loc_1:* = _loc_1;
            this.btn2.y = _loc_1;
            this.btn1.y = _loc_1;
            this.bk.width = stage.stageWidth;
            return;
        }// end function

        public function show(param1:Boolean) : void
        {
            this.visible = param1;
            if (_modelLocator.i18n && _modelLocator.currentVideoInfo)
            {
                this.title.text = _modelLocator.i18n.CONTROLBAR_TITLE + ":" + _modelLocator.currentVideoInfo.title;
            }
            if (stage)
            {
                this.title.width = stage.stageWidth;
            }
            return;
        }// end function

    }
}
