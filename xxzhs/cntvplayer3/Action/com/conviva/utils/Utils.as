package com.conviva.utils
{
    import com.conviva.internal_access.*;
    import flash.net.*;
    import flash.system.*;

    public class Utils extends Object
    {
        public static const GLOBAL_SESSION_ASSET_NAME:String = "c3.global";
        public static const ERROR_CONNECTION_FAILURE:String = "ERROR_CONNECTION_FAILURE";
        public static const ERROR_STREAMING_FAILURE:String = "ERROR_STREAMING_FAILURE";
        public static const HTTP_HEADER_SIZE:int = 300;
        public static const MEDIA_TYPE_RTMP_STREAM:String = "rtmp_stream";
        public static const MEDIA_TYPE_RTMP_SMIL_STREAM:String = "rtmp_smil_stream";
        public static const MEDIA_TYPE_RTMP_F4M_STREAM:String = "rtmp_f4m_stream";
        public static const MEDIA_TYPE_HTTP_ZERI_STREAM:String = "http_zeri_stream";
        public static const MEDIA_TYPE_HTTP_PROGRESSIVE:String = "http_progressive";
        public static const MEDIA_TYPE_HTTP_CHUNK_STREAM:String = "http_chunk_stream";
        public static const MEDIA_TYPE_UNKNOWN:String = "unknown";
        public static const PB_INT16_MAX:int = Math.pow(2, 15) - 1;
        private static var _breadCrumbs:Array = new Array();
        static var _interceptUncaughtExceptions:Boolean = true;
        static var reportError:Function = null;

        public function Utils()
        {
            return;
        }// end function

        public static function urlEncodeObject(param1:Object) : String
        {
            var _loc_3:String = null;
            var _loc_4:Boolean = false;
            var _loc_5:String = null;
            var _loc_2:* = new URLVariables();
            for (_loc_3 in param1)
            {
                
                _loc_2[_loc_3] = String(param1[_loc_3]);
            }
            _loc_4 = System.useCodePage;
            System.useCodePage = false;
            _loc_5 = _loc_2.toString();
            System.useCodePage = _loc_4;
            return _loc_5;
        }// end function

        public static function UrlEncodeQuery(param1:Object) : String
        {
            if (param1.hasOwnProperty("ToObject"))
            {
                return urlEncodeObject(param1.ToObject());
            }
            return urlEncodeObject(param1);
        }// end function

        public static function UrlEncodeString(param1:String) : String
        {
            param1 = urlEncodeObject({x:param1});
            return param1.substr(2);
        }// end function

        public static function dicCSToString(param1:DictionaryCS) : String
        {
            var _loc_3:Object = null;
            var _loc_2:String = "{";
            for each (_loc_3 in param1.Keys)
            {
                
                _loc_2 = _loc_2 + (_loc_3 + ":" + param1.GetValue(_loc_3) + " ");
            }
            _loc_2 = _loc_2 + "}";
            return _loc_2;
        }// end function

        public static function UrlDecodeQuery(param1:String) : DictionaryCS
        {
            var _loc_2:* = System.useCodePage;
            System.useCodePage = false;
            var _loc_3:* = new URLVariables(param1);
            System.useCodePage = _loc_2;
            return Lang.DictionaryFromRepr(_loc_3);
        }// end function

        public static function UrlDecodeString(param1:String) : String
        {
            var _loc_2:* = UrlDecodeQuery("x=" + param1);
            return _loc_2.GetValue("x");
        }// end function

        public static function getCurrentTimeMs() : Number
        {
            return new Date().getTime();
        }// end function

        public static function id(param1:String) : String
        {
            return param1;
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

        public static function genericCleanup(param1)
        {
            if (param1)
            {
                if (param1.hasOwnProperty("cleanup"))
                {
                    param1.cleanup();
                }
                else
                {
                    param1.Cleanup();
                }
            }
            return null;
        }// end function

        public static function runAfter(param1:Function, param2:Number) : Object
        {
            var f:* = param1;
            var delayMs:* = param2;
            return ProtectedTimer.DelayAction(function () : void
            {
                f();
                return;
            }// end function
            , delayMs, "runAfter");
        }// end function

        public static function Assert(param1, param2:String) : void
        {
            if (!param1)
            {
                ReportError("Assertion failure: " + param2);
            }
            return;
        }// end function

        public static function ReportErrorContinue(param1:String, param2:Boolean = true) : Boolean
        {
            if (TESTAPI::reportError != null && .TESTAPI::reportError(param1, null))
            {
                return false;
            }
            if (param2)
            {
                Ping.Send("Error:" + param1);
            }
            else
            {
                Trace.Error("Utils", param1);
            }
            return true;
        }// end function

        public static function ReportError(param1:String) : void
        {
            if (ReportErrorContinue(param1))
            {
                throw new ConvivaStatus(param1);
            }
            return;
        }// end function

        public static function NextRandom32() : uint
        {
            return uint(CommonUtils.random() * uint.MAX_VALUE);
        }// end function

        public static function NextRandom() : Number
        {
            return CommonUtils.random();
        }// end function

        public static function PushBreadCrumb(param1:String) : void
        {
            _breadCrumbs.push(param1);
            return;
        }// end function

        public static function ResetBreadCrumbs() : void
        {
            _breadCrumbs = new Array();
            return;
        }// end function

        public static function RunProtected(param1:Function, param2:String) : void
        {
            RunProtectedResult(param1, param2, null);
            return;
        }// end function

        public static function RunProtectedResult(param1:Function, param2:String, param3)
        {
            var f:* = param1;
            var msg:* = param2;
            var defaultResult:* = param3;
            var initialBreadCrumbCount:* = _breadCrumbs.length;
            var result:* = defaultResult;
            if (TESTAPI::_interceptUncaughtExceptions)
            {
                try
                {
                    result = Utils.f();
                }
                catch (e)
                {
                    UncaughtException(msg ? (msg) : ("RunProtected"), e);
                }
            }
            else
            {
                result = Utils.f();
            }
            finally
            {
                var _loc_5:* = new catch1;
                throw null;
            }
            finally
            {
                if (_breadCrumbs.length > initialBreadCrumbCount)
                {
                    _breadCrumbs = _breadCrumbs.slice(0, initialBreadCrumbCount);
                }
            }
            return result;
        }// end function

        public static function UncaughtException(param1:String, param2:Error) : void
        {
            var _loc_6:String = null;
            var _loc_3:String = "Uncaught exception ";
            var _loc_4:String = "";
            var _loc_5:* = param1.indexOf("IGNORE");
            if (param1.indexOf("IGNORE") < 0)
            {
                _loc_3 = _loc_3 + param1;
            }
            else
            {
                _loc_3 = _loc_3 + param1.substr(0, _loc_5);
                _loc_4 = param1.substr(_loc_5);
            }
            if (_breadCrumbs.length > 0)
            {
                _loc_3 = _loc_3 + ("(crumbs: " + _breadCrumbs.toString() + ")");
            }
            if (TESTAPI::reportError != null && .TESTAPI::reportError(_loc_3, param2))
            {
                return;
            }
            if (!TESTAPI::_interceptUncaughtExceptions)
            {
                throw param2;
            }
            if (param2 is ConvivaStatus)
            {
                return;
            }
            _loc_6 = param2.getStackTrace();
            if (_loc_6 != null)
            {
                _loc_3 = _loc_3 + (", stack:" + _loc_6);
            }
            else
            {
                _loc_3 = _loc_3 + (", exc:" + param2.toString());
            }
            if (_loc_4 != "")
            {
                _loc_3 = _loc_3 + (" " + _loc_4);
            }
            Ping.Send(_loc_3);
            return;
        }// end function

    }
}
