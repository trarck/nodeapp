package com.conviva.utils
{

    public class Uuid extends Object
    {
        public static const UUID_PROPERTY_NAME:String = "uuid";
        private static var _uuid:ArrayCS = null;

        public function Uuid()
        {
            throw new Error("Uuid is a static class");
        }// end function

        public static function Init() : void
        {
            var rawUuid:* = PersistentConfig.SafeGetPropElse(UUID_PROPERTY_NAME, null);
            try
            {
                _uuid = Lang.ArrayFromRepr(rawUuid as Array);
            }
            catch (e:Error)
            {
                _uuid = null;
            }
            if (_uuid != null && _uuid.Length != 4)
            {
                _uuid = null;
            }
            if (_uuid == null)
            {
                _uuid = ArrayCS.New(0, 0, 0, 0);
            }
            return;
        }// end function

        public static function SetUuid(param1:ArrayCS) : void
        {
            Utils.Assert(param1.Length == 4, "id must have 4 ints");
            _uuid = param1;
            PersistentConfig.SetProperty(UUID_PROPERTY_NAME, Lang.ArrayToRepr(_uuid));
            Ping.Id = uint(_uuid.GetValue(0));
            return;
        }// end function

        public static function CanSetUuid() : Boolean
        {
            return Uuid.isEqual(ArrayCS.New(0, 0, 0, 0));
        }// end function

        public static function Cleanup() : void
        {
            _uuid = null;
            return;
        }// end function

        public static function get uuid() : ArrayCS
        {
            Utils.Assert(_uuid != null, "Uuid");
            return _uuid;
        }// end function

        static function deleteUuid() : void
        {
            PersistentConfig.DeleteProperty(UUID_PROPERTY_NAME);
            _uuid = ArrayCS.New(0, 0, 0, 0);
            return;
        }// end function

        static function deleteLocalUuid() : void
        {
            _uuid = ArrayCS.New(0, 0, 0, 0);
            return;
        }// end function

        static function get uuidNoAssert() : ArrayCS
        {
            return _uuid;
        }// end function

        public static function isEqual(param1:ArrayCS) : Boolean
        {
            if (param1.Length != _uuid.Length)
            {
                return false;
            }
            var _loc_2:int = 0;
            while (_loc_2 < _uuid.Length)
            {
                
                if (_uuid.GetValue(_loc_2) != param1.GetValue(_loc_2))
                {
                    return false;
                }
                _loc_2++;
            }
            return true;
        }// end function

        static function X_isEqual_Repr(param1:Array) : Boolean
        {
            return isEqual(Lang.ArrayFromRepr(param1));
        }// end function

    }
}
