package com.conviva.pdl.utils
{
    import flash.media.*;

    public class Utils extends Object
    {

        public function Utils()
        {
            return;
        }// end function

        public static function copyVideoProperties(param1:Video, param2:Video) : void
        {
            if (param1 == null || param2 == null)
            {
                return;
            }
            param2.alpha = param1.alpha;
            param2.blendMode = param1.blendMode;
            param2.cacheAsBitmap = param1.cacheAsBitmap;
            param2.deblocking = param1.deblocking;
            param2.filters = param1.filters;
            param2.mask = param1.mask;
            param2.opaqueBackground = param1.opaqueBackground;
            param2.rotation = param1.rotation;
            param2.scaleX = param1.scaleX;
            param2.scaleY = param1.scaleY;
            param2.scrollRect = param1.scrollRect;
            param2.smoothing = param1.smoothing;
            param2.transform = param1.transform;
            param2.visible = param1.visible;
            param2.width = param1.width;
            param2.height = param1.height;
            param2.x = param1.x;
            param2.y = param1.y;
            return;
        }// end function

        public static function replaceHost(param1:String, param2:String) : String
        {
            var _loc_3:* = /^((?P<scheme>[a-zA-Z][a-zA-Z\d\+\=\.]*):)?(\/\/(?P<authority>((?P<userinfo>[\w\-\.\~\%\!\$\&\\''\(\)\*\+\,\;\=\:]*)@)?(?P<host>[\w\-\.\~\%\!\$\&\\''\(\)\*\+\,\;\=]*)(:(?P<port>\d*))?))(?P<path>[^?#]*)(\?(?P<query>[^#]*))?(#(?P<fragment>.*))?""^((?P<scheme>[a-zA-Z][a-zA-Z\d\+\=\.]*):)?(\/\/(?P<authority>((?P<userinfo>[\w\-\.\~\%\!\$\&\'\(\)\*\+\,\;\=\:]*)@)?(?P<host>[\w\-\.\~\%\!\$\&\'\(\)\*\+\,\;\=]*)(:(?P<port>\d*))?))(?P<path>[^?#]*)(\?(?P<query>[^#]*))?(#(?P<fragment>.*))?/;
            var _loc_4:* = _loc_3.exec(param1);
            var _loc_5:* = param1.replace(_loc_4.host, param2);
            var _loc_6:* = param1.replace(_loc_4.host, param2).replace("/v.cctv.com", "");
            return param1.replace(_loc_4.host, param2).replace("/v.cctv.com", "").replace("/hot.v.cntv.cn", "");
        }// end function

        public static function objectIsSame(param1:Object, param2:Object) : Boolean
        {
            if (!param1 && !param2)
            {
                return true;
            }
            if (!param1 && param2 || param1 && !param2)
            {
                return false;
            }
            var _loc_3:String = "";
            for (_loc_3 in param1)
            {
                
                if (!param2.hasOwnProperty(_loc_3) || param2[_loc_3] != param1[_loc_3])
                {
                    return false;
                }
            }
            for (_loc_3 in param2)
            {
                
                if (!param1.hasOwnProperty(_loc_3) || param1[_loc_3] != param2[_loc_3])
                {
                    return false;
                }
            }
            return true;
        }// end function

    }
}
