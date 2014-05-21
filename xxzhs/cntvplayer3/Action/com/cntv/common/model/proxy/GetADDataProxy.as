package com.cntv.common.model.proxy
{
    import com.cntv.common.*;
    import com.cntv.common.events.*;
    import com.cntv.common.model.*;
    import com.cntv.common.model.parser.*;
    import com.cntv.common.tools.array.*;
    import com.cntv.common.tools.math.*;
    import com.cntv.common.tools.net.*;
    import com.cntv.common.tools.string.*;
    import com.puremvc.model.*;
    import com.puremvc.view.event.*;
    import com.utils.net.request.*;
    import flash.utils.*;

    public class GetADDataProxy extends XMLProxy
    {
        private var _locator:ModelLocator;
        private var _dispatcher:GlobalDispatcher;
        private var type:int = -1;
        private var startTime:uint;
        private var adCall:String;
        private var adCallResultXML:XML;
        private var subAdCount:Number = 0;
        public static const TYPE_BF:int = 0;
        public static const TYPE_AF:int = 1;
        public static const TYPE_PAUSE:int = 2;
        public static const TYPE_CORNER:int = 3;
        public static const TYPE_LOGO:int = 4;

        public function GetADDataProxy(param1:int)
        {
            this._locator = ModelLocator.getInstance();
            this._dispatcher = GlobalDispatcher.getInstance();
            this.type = param1;
            this.startTime = getTimer();
            switch(this.type)
            {
                case TYPE_BF:
                {
                    this._locator.microLoopIndex = this.getMicroLoopIndex();
                    if (this._locator.paramVO.adCall.indexOf("http:") == -1)
                    {
                        this.adCall = this._locator.paramVO.adCall;
                    }
                    else
                    {
                        this.adCall = this._locator.paramVO.adCall + "&unumber=" + StringUtils.fillTo2Byte(this._locator.microLoopIndex);
                    }
                    if ((this._locator.microLoopIndex + 1) <= 12)
                    {
                        (this._locator.microLoopIndex + 1);
                    }
                    else
                    {
                        this._locator.microLoopIndex = 1;
                    }
                    break;
                }
                case TYPE_AF:
                {
                    this.adCall = this._locator.paramVO.adAfter;
                    break;
                }
                case TYPE_PAUSE:
                {
                    this.adCall = this._locator.paramVO.adPause;
                    break;
                }
                case TYPE_CORNER:
                {
                    this.adCall = this._locator.paramVO.adCorner;
                    break;
                }
                case TYPE_LOGO:
                {
                    this.adCall = this._locator.paramVO.adLogo;
                    break;
                }
                default:
                {
                    break;
                }
            }
            sendHttpRequest(this.adCall);
            return;
        }// end function

        override protected function throwDataException() : void
        {
            super.throwDataException();
            var _loc_1:Array = [];
            var _loc_2:* = new ValueOBJ("t", "err");
            _loc_1.push(_loc_2);
            _loc_2 = new ValueOBJ("v", QualityMonitorEvent.ERROR_AD_DATA_FORMAT_ERROR);
            _loc_1.push(_loc_2);
            _loc_2 = new ValueOBJ("adurl", this.adCall);
            _loc_1.push(_loc_2);
            GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_1));
            switch(this.type)
            {
                case TYPE_BF:
                {
                    this._dispatcher.dispatchEvent(new CommonEvent(ApplicationFacade.NOTI_PLAY_AD));
                    break;
                }
                case TYPE_AF:
                {
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_AF_AD_DATA));
                    break;
                }
                case TYPE_PAUSE:
                {
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_PAUSE_AD_DATA));
                    break;
                }
                case TYPE_CORNER:
                {
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_CORNER_AD_DATA));
                    break;
                }
                case TYPE_LOGO:
                {
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_LOGO_AD_DATA));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            var _loc_2:Array = [];
            var _loc_3:* = new ValueOBJ("t", "err");
            _loc_2.push(_loc_3);
            _loc_3 = new ValueOBJ("v", QualityMonitorEvent.ERROR_CAN_NOT_GET_AD_DATA);
            _loc_2.push(_loc_3);
            _loc_3 = new ValueOBJ("adurl", this.adCall);
            _loc_2.push(_loc_3);
            _loc_3 = new ValueOBJ("errmsg", param1);
            _loc_2.push(_loc_3);
            GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_ERROR, _loc_2));
            switch(this.type)
            {
                case TYPE_BF:
                {
                    this._dispatcher.dispatchEvent(new CommonEvent(ApplicationFacade.NOTI_PLAY_AD));
                    break;
                }
                case TYPE_AF:
                {
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_AF_AD_DATA));
                    break;
                }
                case TYPE_PAUSE:
                {
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_PAUSE_AD_DATA));
                    break;
                }
                case TYPE_CORNER:
                {
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_CORNER_AD_DATA));
                    break;
                }
                case TYPE_LOGO:
                {
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_LOGO_AD_DATA));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override protected function loadCompleted(param1:XML) : void
        {
            var _loc_6:String = null;
            this.adCallResultXML = param1;
            var _loc_2:Boolean = false;
            var _loc_3:String = "";
            var _loc_4:* = XMLList(param1.children());
            var _loc_5:Number = 0;
            while (_loc_5 < _loc_4.length())
            {
                
                if (_loc_4[_loc_5].@type == "adcall")
                {
                    _loc_4[_loc_5].@mark = _loc_5;
                    _loc_6 = _loc_4[_loc_5].url;
                    if (_loc_4[_loc_5].@aop != null && _loc_4[_loc_5].@aop == "1")
                    {
                        if (_loc_3 == "")
                        {
                            _loc_3 = RefHtmlGenerator.getRefUrl();
                            if (_loc_3.indexOf("adsit_aop=") > 0)
                            {
                                _loc_3 = _loc_3.split("adsit_aop=")[1];
                            }
                            else
                            {
                                _loc_3 = "null";
                            }
                        }
                        _loc_6 = _loc_6 + "?adsit_aop=" + _loc_3;
                    }
                    this.loadChildAdcall(_loc_5, _loc_6);
                    var _loc_7:String = this;
                    var _loc_8:* = this.subAdCount + 1;
                    _loc_7.subAdCount = _loc_8;
                    _loc_2 = true;
                }
                _loc_5 = _loc_5 + 1;
            }
            if (!_loc_2)
            {
                this.dealXML();
            }
            return;
        }// end function

        private function loadChildAdcall(param1:Number, param2:String) : void
        {
            new GetSubAddProxy(this, param1, param2);
            return;
        }// end function

        private function dealXML() : void
        {
            var _loc_2:Array = null;
            var _loc_3:ValueOBJ = null;
            super.loadCompleted(this.adCallResultXML);
            var _loc_1:* = this.adCallResultXML;
            switch(this.type)
            {
                case TYPE_BF:
                {
                    this._locator.adVosBF = new Array();
                    ADParser.parse(_loc_1, TYPE_BF);
                    this._dispatcher.dispatchEvent(new CommonEvent(ApplicationFacade.NOTI_PLAY_AD));
                    break;
                }
                case TYPE_AF:
                {
                    this._locator.adVosAF = new Array();
                    ADParser.parse(_loc_1, TYPE_AF);
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_AF_AD_DATA));
                    break;
                }
                case TYPE_PAUSE:
                {
                    this._locator.adVosPause = new Array();
                    ADParser.parse(_loc_1, TYPE_PAUSE);
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_PAUSE_AD_DATA));
                    break;
                }
                case TYPE_CORNER:
                {
                    this._locator.adVosCorner = new Array();
                    ADParser.parse(_loc_1, TYPE_CORNER);
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_CORNER_AD_DATA));
                    break;
                }
                case TYPE_LOGO:
                {
                    this._locator.adVosLogo = new Array();
                    ADParser.parse(_loc_1, TYPE_LOGO);
                    this._dispatcher.dispatchEvent(new ADEvent(ADEvent.EVENT_GET_LOGO_AD_DATA));
                }
                default:
                {
                    break;
                }
            }
            if (this.type == TYPE_BF)
            {
                _loc_2 = [];
                _loc_3 = new ValueOBJ("t", "adld");
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("v", String(getTimer() - this.startTime));
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("isHaveAD", this._locator.paramVO.adCall != "" ? ("true") : ("false"));
                _loc_2.push(_loc_3);
                _loc_3 = new ValueOBJ("adLen", this._locator.adVosBF.length.toString());
                _loc_2.push(_loc_3);
                GlobalDispatcher.getInstance().dispatchEvent(new QualityMonitorEvent(QualityMonitorEvent.EVENT_LOAD_AD_DATA, _loc_2));
            }
            return;
        }// end function

        public function getSubAdComp(param1:Number, param2:XML) : void
        {
            if (param2 != null)
            {
                param2.loadcount2 = String(this.adCallResultXML.ad[param1].loadcount[0]);
                param2.overcount2 = String(this.adCallResultXML.ad[param1].overcount[0]);
                param2.adlink2 = String(this.adCallResultXML.ad[param1].adlink);
                param2.pic = "";
                param2.md5 = "";
                this.adCallResultXML.ad[param1] = param2;
            }
            else
            {
                this.adCallResultXML.ad[param1].@type = "null";
            }
            var _loc_3:String = this;
            var _loc_4:* = this.subAdCount - 1;
            _loc_3.subAdCount = _loc_4;
            if (this.subAdCount <= 0)
            {
                this.dealXML();
            }
            return;
        }// end function

        private function getMicroLoopIndex() : int
        {
            var _loc_2:Array = null;
            var _loc_3:Object = null;
            var _loc_1:* = ShareObjecter.getObject(this._locator.localDataObjectName, this._locator.localDataPath);
            if (_loc_1 != null)
            {
                if (_loc_1["data"][this._locator.adMicroLoop] != null)
                {
                    _loc_2 = _loc_1["data"][this._locator.adMicroLoop];
                    _loc_3 = ArrayUtils.getObjectByKey(_loc_2, "adurl", this._locator.paramVO.adCall);
                    if (_loc_3 == null)
                    {
                        return MathUtil.getRangeRandomInt(1, 12);
                    }
                    return int(_loc_3["index"]);
                }
                else
                {
                    return MathUtil.getRangeRandomInt(1, 12);
                }
            }
            else
            {
                return MathUtil.getRangeRandomInt(1, 12);
            }
        }// end function

    }
}
