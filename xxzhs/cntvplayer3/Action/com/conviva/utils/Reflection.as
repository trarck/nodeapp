package com.conviva.utils
{
    import com.conviva.internal_access.*;
    import flash.utils.*;

    public class Reflection extends Object
    {

        public function Reflection()
        {
            return;
        }// end function

        public static function CreateInstance(param1:Class, ... args) : Object
        {
            if (args.length == 0)
            {
                return new param1;
            }
            if (args.length == 1)
            {
                return new param1(args[0]);
            }
            if (args.length == 2)
            {
                return new param1(args[0], args[1]);
            }
            if (args.length == 3)
            {
                return new param1(args[0], args[1], args[2]);
            }
            if (args.length == 4)
            {
                return new param1(args[0], args[1], args[2], args[3]);
            }
            if (args.length == 5)
            {
                return new param1(args[0], args[1], args[2], args[3], args[4]);
            }
            if (args.length == 6)
            {
                return new param1(args[0], args[1], args[2], args[3], args[4], args[5]);
            }
            Ping.Send("Error:CreateInstance too many args: " + (param1 as Object).toString());
            return null;
        }// end function

        public static function GetType(param1:Object) : Class
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = getDefinitionByName(GetClassName(param1)) as Class;
            return _loc_2;
        }// end function

        public static function GetTypeByName(param1:String) : Class
        {
            return getDefinitionByName(param1) as Class;
        }// end function

        public static function GetClassName(param1:Object) : String
        {
            if (param1 == null)
            {
                return null;
            }
            return getQualifiedClassName(param1);
        }// end function

        public static function HasMethod(param1:String, param2:Object) : Boolean
        {
            return HasProperty(param1, param2);
        }// end function

        private static function InvokeMethodWorker(param1:Object, param2:String, param3:Array) : Object
        {
            var fld:Object;
            var e2:Error;
            var e1:Error;
            var strace:String;
            var objInfo:XML;
            var methodInfo:XMLList;
            var nrFormalParams:int;
            var nrActualParams:int;
            var newArgs:Array;
            var i:int;
            var obj:* = param1;
            var methodName:* = param2;
            var args:* = param3;
            try
            {
                fld = getField(obj, methodName);
                if (fld == null || !fld is Function)
                {
                    e2 = new Error("Missing property " + methodName, 1069);
                    Utils.UncaughtException("InvokeMethod: " + methodName, e2);
                    return null;
                }
                return fld.apply(obj, args);
            }
            catch (e:Error)
            {
                e1 = e;
                strace = e1.getStackTrace();
                if (e.errorID == 1069)
                {
                    Utils.UncaughtException("InvokeMethod: " + methodName, e);
                    return null;
                }
                if (e.errorID == 1063)
                {
                    objInfo = describeType(obj);
                    var _loc_7:int = 0;
                    var _loc_8:* = objInfo.method;
                    var _loc_6:* = new XMLList("");
                    for each (_loc_9 in _loc_8)
                    {
                        
                        var _loc_10:* = _loc_8[_loc_7];
                        with (_loc_8[_loc_7])
                        {
                            if (@name == methodName)
                            {
                                _loc_6[_loc_7] = _loc_9;
                            }
                        }
                    }
                    methodInfo = _loc_6;
                    if (methodInfo.length() == 1)
                    {
                        nrFormalParams = methodInfo..parameter.length();
                        nrActualParams = args.length;
                        if (nrFormalParams != nrActualParams)
                        {
                            newArgs;
                            i;
                            while (i < nrFormalParams)
                            {
                                
                                if (i >= nrActualParams)
                                {
                                    newArgs.push(null);
                                }
                                else
                                {
                                    newArgs.push(args[i]);
                                }
                                i = (i + 1);
                            }
                            return InvokeMethodWorker(obj, methodName, newArgs);
                        }
                    }
                }
                Utils.UncaughtException("InvokeMethod:" + methodName, e);
            }
            return null;
        }// end function

        public static function InvokeMethod(param1:String, param2:Object, ... args) : Object
        {
            return InvokeMethodWorker(param2, param1, args);
        }// end function

        public static function InvokeStaticMethod(param1:String, param2:Class, ... args) : Object
        {
            return InvokeMethodWorker(param2, param1, args);
        }// end function

        public static function HasProperty(param1:String, param2:Object) : Boolean
        {
            var propNameStripped:String;
            var propName:* = param1;
            var obj:* = param2;
            if (obj == null)
            {
                return false;
            }
            try
            {
                propNameStripped = stripTESTAPI(propName);
                if (propName != propNameStripped)
                {
                    return true;
                }
                else
                {
                    return obj != null && obj.hasOwnProperty(propName);
                }
            }
            catch (e:Error)
            {
                if (e.errorID == 1069)
                {
                    return false;
                }
                throw e;
            }
            return false;
        }// end function

        public static function GetProperty(param1:String, param2:Object) : Object
        {
            var _loc_3:* = getField(param2, param1);
            return _loc_3;
        }// end function

        public static function SetProperty(param1:String, param2:Object, param3:Object) : void
        {
            var _loc_4:* = stripTESTAPI(param1);
            if (param1 != _loc_4)
            {
                param2[_loc_4] = param3;
            }
            else
            {
                param2[param1] = param3;
            }
            return;
        }// end function

        public static function HasField(param1:String, param2:Object) : Boolean
        {
            return HasProperty(param1, param2);
        }// end function

        public static function GetField(param1:String, param2:Object) : Object
        {
            return GetProperty(param1, param2);
        }// end function

        public static function SetField(param1:String, param2:Object, param3:Object) : void
        {
            SetProperty(param1, param2, param3);
            return;
        }// end function

        public static function GetMember(param1:String, param2:Object, param3:Object) : Object
        {
            if (Reflection.HasProperty(param1, param2))
            {
                return Reflection.GetProperty(param1, param2);
            }
            if (Reflection.HasField(param1, param2))
            {
                return Reflection.GetField(param1, param2);
            }
            return param3;
        }// end function

        private static function stripTESTAPI(param1:String) : String
        {
            if (param1.length > 8 && param1.substr(0, 8) == "TESTAPI_")
            {
                return param1.substr(8);
            }
            return param1;
        }// end function

        private static function getField(param1:Object, param2:String) : Object
        {
            var _loc_4:Object = null;
            var _loc_3:* = stripTESTAPI(param2);
            if (param2 != _loc_3)
            {
                return param1[_loc_3];
            }
            _loc_4 = param1[param2];
            return _loc_4;
        }// end function

        public static function Clone(param1:Object) : Object
        {
            var _loc_2:Object = {};
            var _loc_3:* = GetClassName(param1);
            InvokeMethod("StoreCloningData", param1, _loc_2);
            var _loc_4:* = getDefinitionByName(_loc_3) as Class;
            if (getDefinitionByName(_loc_3) as Class == null)
            {
                return null;
            }
            return InvokeStaticMethod("ConstructFromCloningData", _loc_4, _loc_2);
        }// end function

        public static function StoreCloningData(param1:DictionaryCS, param2:Object) : void
        {
            param1.CopyToObject(param2);
            return;
        }// end function

    }
}
