package com.conviva.utils
{
    import com.conviva.internal_access.*;
    import flash.net.*;
    import flash.utils.*;

    public class DataLoader extends GenericLoader
    {
        private var _loadStartTimeMs:Number;
        private var mockLoader:Object = null;
        public var TheError:Error = null;
        public var Response:DataLoadable = null;
        public var ResponseTime:int = 0;
        public var callback:Function;
        public var url:String;
        public var toSend:DataLoadable;
        public var options:Object;
        static var mockLoaderFactory:Function = null;

        public function DataLoader(param1:String, param2:Function, param3:DataLoadable, param4:Object = null)
        {
            super(GenericLoader.DATA_LOADER, this.dataLoaderCallback);
            this.callback = param2;
            this.toSend = param3;
            this.url = param1;
            this.options = param4;
            this._loadStartTimeMs = ProtectedTimer.GetTickCountMs();
            this.Response = null;
            this.TheError = null;
            if (this.options && !this.options.hasOwnProperty("ToObject"))
            {
                this.options = Lang.DictionaryFromRepr(this.options);
            }
            if (TESTAPI::mockLoaderFactory != null)
            {
                this.mockLoader = .TESTAPI::mockLoaderFactory(this);
                if (this.mockLoader != null)
                {
                    return;
                }
            }
            this.startLoad(param1, this.callback, this.toSend, this.options);
            return;
        }// end function

        protected function startLoad(param1:String, param2:Function, param3:DataLoadable, param4:Object) : void
        {
            if (param4 && param4.ContainsKey("timeoutMs"))
            {
                _timeoutMs = int(param4.GetValue("timeoutMs"));
            }
            if (param4 && param4.ContainsKey("dataFormat") && param4.GetValue("dataFormat") == "BINARY")
            {
                dataFormat = URLLoaderDataFormat.BINARY;
            }
            else
            {
                dataFormat = URLLoaderDataFormat.TEXT;
            }
            var _loc_5:* = new URLRequest(param1);
            if (!(param4 && param4.ContainsKey("noHeaders") && param4.GetValue("noHeaders") == true))
            {
                _loc_5.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
            }
            if (param3 != null)
            {
                _loc_5.method = URLRequestMethod.POST;
                _loc_5.data = param3.ToRepr();
                dataFormat = URLLoaderDataFormat.BINARY;
                if (_loc_5.data.length == 0)
                {
                    _loc_5.data.length = 1;
                }
            }
            load(_loc_5);
            return;
        }// end function

        private function dataLoaderCallback(param1:Error, param2:DataLoader) : void
        {
            if (this.callback == null)
            {
                return;
            }
            this.TheError = param1;
            var _loc_3:* = data;
            if (dataFormat == URLLoaderDataFormat.TEXT)
            {
                this.Response = DataLoadable.FromString(String(_loc_3));
            }
            else
            {
                this.Response = DataLoadable.FromRepr(ByteArray(data));
            }
            this.ResponseTime = this.int(ProtectedTimer.GetTickCountMs() - this._loadStartTimeMs);
            this.callback(param1, param2);
            return;
        }// end function

        override public function Cleanup() : void
        {
            if (this.mockLoader != null)
            {
                Reflection.InvokeMethod("Cleanup", this.mockLoader);
                this.mockLoader = null;
            }
            this.callback = null;
            super.Cleanup();
            return;
        }// end function

        public static function StaticCleanup() : void
        {
            return;
        }// end function

    }
}
