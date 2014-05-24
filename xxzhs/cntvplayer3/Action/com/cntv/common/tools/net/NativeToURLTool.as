package com.cntv.common.tools.net
{
    import com.cntv.common.model.*;
    import flash.external.*;
    import flash.net.*;

    public class NativeToURLTool extends Object
    {

        public function NativeToURLTool()
        {
            return;
        }// end function

        public static function openAURL(param1:String, param2:String = "_blank", param3:Boolean = false) : void
        {
            var _loc_6:String = null;
            param2 = param2;
            var _loc_4:String = "window.open";
            var _loc_5:* = new URLRequest(param1);
            new URLRequest(param1).method = param3 ? (URLRequestMethod.POST) : (URLRequestMethod.GET);
            if (ExternalInterface.available && ModelLocator.getInstance().ISWEBSITE)
            {
                try
                {
                    _loc_6 = getBrowserName();
                    if (getBrowserName() == "Firefox")
                    {
                        ExternalInterface.call(_loc_4, param1, param2);
                    }
                    else if (_loc_6 == "IE")
                    {
                        ExternalInterface.call(_loc_4, param1, param2);
                    }
                    else if (_loc_6 == "Safari")
                    {
                        navigateToURL(_loc_5, param2);
                    }
                    else if (_loc_6 == "Opera")
                    {
                        navigateToURL(_loc_5, param2);
                    }
                    else
                    {
                        navigateToURL(_loc_5, param2);
                    }
                }
                catch (e:Error)
                {
                }
            }
            else
            {
                navigateToURL(new URLRequest(param1), "_blank");
            }
            return;
        }// end function

        public static function openASmallWindow(param1:String = "", param2:String = "_blank", param3:Boolean = false) : void
        {
            var _loc_6:String = null;
            param2 = param2;
            var _loc_4:String = "window.open";
            var _loc_5:* = new URLRequest(param1);
            new URLRequest(param1).method = param3 ? (URLRequestMethod.POST) : (URLRequestMethod.GET);
            if (ExternalInterface.available)
            {
                try
                {
                    _loc_6 = getBrowserName();
                    if (getBrowserName() == "Firefox")
                    {
                        ExternalInterface.call(_loc_4, param1, "_blank", "channelmode=no,directories=no,fullscreen=no,height=480,left=0,location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,top=0,width=640", false);
                    }
                    else if (_loc_6 == "IE")
                    {
                        ExternalInterface.call(_loc_4, param1, "_blank", "channelmode=no,directories=no,fullscreen=no,height=480,left=0,location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,top=0,width=640", false);
                    }
                    else if (_loc_6 == "Safari")
                    {
                        navigateToURL(_loc_5, param2);
                    }
                    else if (_loc_6 == "Opera")
                    {
                        navigateToURL(_loc_5, param2);
                    }
                    else
                    {
                        navigateToURL(_loc_5, param2);
                    }
                }
                catch (e:Error)
                {
                }
                ;
            }
            return;
        }// end function

        private static function getBrowserName() : String
        {
            var _loc_1:String = null;
            var _loc_2:* = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
            if (_loc_2 != null && _loc_2.indexOf("Firefox") >= 0)
            {
                _loc_1 = "Firefox";
            }
            else if (_loc_2 != null && _loc_2.indexOf("Safari") >= 0)
            {
                _loc_1 = "Safari";
            }
            else if (_loc_2 != null && _loc_2.indexOf("MSIE") >= 0)
            {
                _loc_1 = "IE";
            }
            else if (_loc_2 != null && _loc_2.indexOf("Opera") >= 0)
            {
                _loc_1 = "Opera";
            }
            else
            {
                _loc_1 = "Undefined";
            }
            return _loc_1;
        }// end function

    }
}
