package com.cntv.common.model.parser
{
    import com.cntv.common.model.*;
    import com.cntv.common.model.proxy.*;
    import com.cntv.common.model.vo.*;
    import com.cntv.common.tools.array.*;
    import com.cntv.common.tools.net.*;

    public class ADParser extends Object
    {

        public function ADParser()
        {
            return;
        }// end function

        public static function parse(param1:XML, param2:int) : void
        {
            var _loc_3:* = param1.@adversion;
            var _loc_4:* = param1.@microloop;
            var _loc_5:* = param1.@adtype;
            if (_loc_3 != "")
            {
                parseNewVersion(param1, param2, _loc_5);
            }
            else
            {
                parseOldVersion(param1, param2);
            }
            if (_loc_4 == "1")
            {
                setMicroLoop();
            }
            else
            {
                removeLoop();
            }
            return;
        }// end function

        public static function setMicroLoop() : void
        {
            var _loc_2:Array = null;
            var _loc_1:* = ShareObjecter.getObject(ModelLocator.getInstance().localDataObjectName, ModelLocator.getInstance().localDataPath);
            var _loc_3:Object = {adurl:ModelLocator.getInstance().paramVO.adCall, index:ModelLocator.getInstance().microLoopIndex};
            if (_loc_1 != null)
            {
                if (_loc_1["data"]["adMicroLoop"] != null)
                {
                    _loc_2 = _loc_1["data"]["adMicroLoop"] as Array;
                    _loc_2 = ArrayUtils.setObjectByKey(_loc_2, "adurl", ModelLocator.getInstance().paramVO.adCall, _loc_3);
                    _loc_1["data"]["adMicroLoop"] = _loc_2;
                    ShareObjecter.setObject(_loc_1);
                }
                else
                {
                    _loc_1["data"]["adMicroLoop"] = [_loc_3];
                    ShareObjecter.setObject(_loc_1);
                }
            }
            return;
        }// end function

        public static function removeLoop() : void
        {
            var _loc_2:Array = null;
            var _loc_1:* = ShareObjecter.getObject(ModelLocator.getInstance().localDataObjectName, ModelLocator.getInstance().localDataPath);
            if (_loc_1 != null)
            {
                if (_loc_1["data"]["adMicroLoop"] != null)
                {
                    _loc_2 = _loc_1["data"]["adMicroLoop"] as Array;
                    _loc_2 = ArrayUtils.removeObjectByKey(_loc_2, "adurl", ModelLocator.getInstance().paramVO.adCall);
                    _loc_1["data"]["adMicroLoop"] = _loc_2;
                    ShareObjecter.setObject(_loc_1);
                }
            }
            return;
        }// end function

        public static function parseOldVersion(param1:XML, param2:int) : void
        {
            var _loc_4:ADVO = null;
            var _loc_3:int = 0;
            while (_loc_3 < param1.children().length())
            {
                
                _loc_4 = new ADVO(param1.children()[_loc_3]);
                if (_loc_4.type != "null")
                {
                    switch(param2)
                    {
                        case GetADDataProxy.TYPE_BF:
                        {
                            ModelLocator.getInstance().adVosBF.push(_loc_4);
                            break;
                        }
                        case GetADDataProxy.TYPE_AF:
                        {
                            ModelLocator.getInstance().adVosAF.push(_loc_4);
                            break;
                        }
                        case GetADDataProxy.TYPE_PAUSE:
                        {
                            ModelLocator.getInstance().adVosPause.push(_loc_4);
                            break;
                        }
                        case GetADDataProxy.TYPE_CORNER:
                        {
                            ModelLocator.getInstance().adVosCorner.push(_loc_4);
                            break;
                        }
                        case GetADDataProxy.TYPE_LOGO:
                        {
                            ModelLocator.getInstance().adVosLogo.push(_loc_4);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                _loc_3++;
            }
            return;
        }// end function

        public static function parseNewVersion(param1:XML, param2:int, param3:String) : void
        {
            var _loc_5:ADVO = null;
            var _loc_4:int = 0;
            while (_loc_4 < param1.children().length())
            {
                
                _loc_5 = new ADVO(null).parseNewXML(param1.children()[_loc_4], param3);
                if (_loc_5.type != "null")
                {
                    switch(param2)
                    {
                        case GetADDataProxy.TYPE_BF:
                        {
                            ModelLocator.getInstance().adVosBF.push(_loc_5);
                            break;
                        }
                        case GetADDataProxy.TYPE_AF:
                        {
                            ModelLocator.getInstance().adVosAF.push(_loc_5);
                            break;
                        }
                        case GetADDataProxy.TYPE_PAUSE:
                        {
                            ModelLocator.getInstance().adVosPause.push(_loc_5);
                            break;
                        }
                        case GetADDataProxy.TYPE_CORNER:
                        {
                            ModelLocator.getInstance().adVosCorner.push(_loc_5);
                            break;
                        }
                        case GetADDataProxy.TYPE_LOGO:
                        {
                            ModelLocator.getInstance().adVosLogo.push(_loc_5);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                _loc_4++;
            }
            return;
        }// end function

    }
}
