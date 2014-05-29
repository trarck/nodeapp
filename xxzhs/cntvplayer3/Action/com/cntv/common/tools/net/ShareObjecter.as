package com.cntv.common.tools.net
{
    import flash.net.*;

    public class ShareObjecter extends Object
    {

        public function ShareObjecter()
        {
            return;
        }// end function

        public static function getObject(param1:String, param2:String) : Object
        {
            var name:* = param1;
            var localPath:* = param2;
            try
            {
                return SharedObject.getLocal(name, localPath);
            }
            catch (e:Error)
            {
                return null;
            }
            return null;
        }// end function

        public static function setObject(param1:Object) : Boolean
        {
            var obj:* = param1;
            try
            {
                obj.flush();
                return true;
            }
            catch (e:Error)
            {
                return false;
            }
            return false;
        }// end function

        public static function setOptions(param1:String, param2:String, param3:String, param4:String) : Boolean
        {
            var _loc_5:* = getObject(param1, param2);
            if (getObject(param1, param2) == null)
            {
                return false;
            }
            _loc_5["data"][param3] = param4;
            return setObject(_loc_5);
        }// end function

    }
}
