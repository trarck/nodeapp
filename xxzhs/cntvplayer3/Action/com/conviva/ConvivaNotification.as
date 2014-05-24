package com.conviva
{
    import com.conviva.utils.*;

    public class ConvivaNotification extends Object
    {
        private var _data:DictionaryCS;
        public static const SUCCESS_LIVEPASS_READY:int = 0;
        public static const ERROR_ARGUMENT:int = 1;
        public static const ERROR_LIVEPASS_NOT_READY:int = 2;
        public static const ERROR_LOAD_CONFIGURATION:int = 10;
        public static const ERROR_LOAD_MODULE:int = 11;
        public static const ERROR_METRICS_QUOTA_EXCEEDED:int = 30;

        public function ConvivaNotification(param1:int, param2:String, param3:String)
        {
            this._data = new DictionaryCS();
            this._data.SetValue("code", param1);
            this._data.SetValue("message", param2);
            this._data.SetValue("objectId", param3);
            return;
        }// end function

        public function get code() : int
        {
            return int(this._data.GetValue("code"));
        }// end function

        public function get message() : String
        {
            return this._data.GetValue("message") as String;
        }// end function

        public function get objectId() : String
        {
            return this._data.GetValue("objectId") as String;
        }// end function

        public function toString() : String
        {
            var _loc_1:String = "ConvivaNotification ";
            var _loc_2:* = this.code.toString();
            if (_loc_2 != null)
            {
                _loc_1 = _loc_1 + "(" + _loc_2 + "): ";
            }
            if (this.message != null)
            {
                _loc_1 = _loc_1 + this.message;
            }
            if (this.objectId != null)
            {
                _loc_1 = _loc_1 + " (for objectId " + this.objectId + ")";
            }
            return _loc_1;
        }// end function

        public function StoreCloningData(param1:Object) : void
        {
            var _loc_2:* = new DictionaryCS();
            _loc_2.SetValue("data", this._data.ToObject());
            Reflection.StoreCloningData(_loc_2, param1);
            return;
        }// end function

        public static function ConstructFromCloningData(param1:Object) : ConvivaNotification
        {
            var _loc_2:* = Lang.DictionaryFromRepr(param1);
            var _loc_3:* = new ConvivaNotification(0, "", "");
            _loc_3._data = Lang.DictionaryFromRepr(_loc_2.GetValue("data"));
            return _loc_3;
        }// end function

    }
}
