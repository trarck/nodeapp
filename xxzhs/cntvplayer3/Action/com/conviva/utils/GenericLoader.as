package com.conviva.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class GenericLoader extends Object
    {
        private var _type:int;
        private var _loader:Object;
        private var _callback:Function;
        protected var _loading:Boolean;
        protected var _loaded:Boolean;
        private var _loadedUrl:String;
        protected var _timeoutDelayAction:Object = null;
        protected var _timeoutMs:uint;
        public static const CLASS_LOADER:int = 111;
        public static const DATA_LOADER:int = 222;

        public function GenericLoader(param1:int, param2:Function)
        {
            var type:* = param1;
            var callback:* = param2;
            Utils.Assert(type == GenericLoader.CLASS_LOADER || type == GenericLoader.DATA_LOADER, "GenericLoader constructor");
            this._type = type;
            this._callback = callback;
            try
            {
                if (this._type == CLASS_LOADER)
                {
                    this._loader = new Loader();
                    this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
                    this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
                    this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
                }
                else
                {
                    this._loader = new URLLoader();
                    this._loader.addEventListener(Event.COMPLETE, this.completeHandler);
                    this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
                    this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
                }
            }
            catch (e:Error)
            {
                Utils.UncaughtException("GenericLoader error", e);
            }
            this._loaded = false;
            this._loadedUrl = "";
            this._loading = false;
            this._timeoutMs = 0;
            this._timeoutDelayAction = null;
            return;
        }// end function

        public function Cleanup() : void
        {
            if (!this._loader)
            {
                return;
            }
            try
            {
                if (this._type == CLASS_LOADER)
                {
                    this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.completeHandler);
                    this._loader.unload();
                    this._loader.close();
                }
                else
                {
                    this._loader.removeEventListener(Event.COMPLETE, this.completeHandler);
                    this._loader.close();
                }
            }
            catch (e)
            {
            }
            this.cleanupTimer();
            this._loader = null;
            this._loaded = false;
            this._loadedUrl = "";
            this._loading = false;
            this._callback = null;
            return;
        }// end function

        public function set timeoutMs(param1:uint) : void
        {
            this._timeoutMs = param1;
            return;
        }// end function

        public function set dataFormat(param1:String) : void
        {
            Utils.Assert(this._type == GenericLoader.DATA_LOADER, "GenericLoader.dataFormat");
            this._loader.dataFormat = param1;
            return;
        }// end function

        public function get dataFormat() : String
        {
            return this._loader.dataFormat;
        }// end function

        protected function setTimeout(param1:int) : void
        {
            if (param1 > 0)
            {
                this._timeoutDelayAction = ProtectedTimer.DelayAction(this.errorHandler, param1, "GenericLoader.timeout");
            }
            else
            {
                this._timeoutDelayAction = null;
            }
            return;
        }// end function

        public function load(param1:URLRequest) : void
        {
            var context:LoaderContext;
            var request:* = param1;
            Utils.Assert(this.available, "GenericLoader.load");
            this._loading = true;
            this._loaded = false;
            this._loadedUrl = request.url;
            try
            {
                this.setTimeout(this._timeoutMs);
                if (this._type == CLASS_LOADER)
                {
                    context = new LoaderContext();
                    context.applicationDomain = new ApplicationDomain();
                    context.securityDomain = SecurityDomain.currentDomain;
                    this._loader.load(request, context);
                }
                else
                {
                    this._loader.load(request);
                }
            }
            catch (e:Error)
            {
                errorHandler(new Event("error"));
            }
            return;
        }// end function

        public function get loaded() : Boolean
        {
            return this._loaded;
        }// end function

        public function get Loaded() : Boolean
        {
            return this._loaded;
        }// end function

        public function get available() : Boolean
        {
            return this._loader != null && !this._loading;
        }// end function

        private function cleanupTimer() : void
        {
            if (this._timeoutDelayAction)
            {
                ProtectedTimer.CancelDelayedAction(this._timeoutDelayAction);
                this._timeoutDelayAction = null;
            }
            return;
        }// end function

        protected function completeHandler(event:Event) : void
        {
            var l:GenericLoader;
            var e:* = event;
            l;
            Utils.ResetBreadCrumbs();
            Utils.RunProtected(function ()
            {
                if (_loading)
                {
                    _loaded = true;
                    _loading = false;
                    cleanupTimer();
                    if (_callback != null)
                    {
                        _callback(null, l);
                    }
                }
                return;
            }// end function
            , "GenericLoader.complete IGNORE " + this._loadedUrl);
            return;
        }// end function

        protected function errorHandler(event:Event = null) : void
        {
            var l:GenericLoader;
            var ev:* = event;
            l;
            Utils.ResetBreadCrumbs();
            Utils.RunProtected(function ()
            {
                var _loc_1:Error = null;
                if (_loading)
                {
                    _loaded = false;
                    _loading = false;
                    cleanupTimer();
                    if (ev == null)
                    {
                        _loc_1 = new Error("timeout");
                    }
                    else if (ev.type == IOErrorEvent.IO_ERROR)
                    {
                        _loc_1 = new Error("IO: " + ev.toString());
                    }
                    else if (ev.type == SecurityErrorEvent.SECURITY_ERROR)
                    {
                        _loc_1 = new Error("Security: " + ev.toString());
                    }
                    else
                    {
                        _loc_1 = new Error("error");
                    }
                    if (_callback != null)
                    {
                        _callback(_loc_1, l);
                    }
                }
                return;
            }// end function
            , "GenericLoader.error IGNORE " + this._loadedUrl);
            return;
        }// end function

        public function GetType(param1:String) : Class
        {
            var className:* = param1;
            Utils.Assert(this._type == GenericLoader.CLASS_LOADER, "GenericLoader.getClass");
            if (this._loading)
            {
                return null;
            }
            var retval:Class;
            try
            {
                retval = this._loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
            }
            catch (e:Error)
            {
                Utils.UncaughtException("GenericLoader.getClass error for " + className + " IGNORE " + _loadedUrl, e);
            }
            return retval;
        }// end function

        public function get data() : Object
        {
            Utils.Assert(this._type == GenericLoader.DATA_LOADER, "GenericLoader.data");
            var retval:Object;
            try
            {
                retval = this._loader.data;
            }
            catch (e:TypeError)
            {
                Utils.UncaughtException("GenericLoader.data error IGNORE for " + _loadedUrl, e);
            }
            return retval;
        }// end function

        public function get xml() : XML
        {
            var msg:String;
            Utils.Assert(this._type == GenericLoader.DATA_LOADER, "GenericLoader.xml");
            var retval:XML;
            try
            {
                retval = new XML(this.data);
            }
            catch (e:TypeError)
            {
                msg;
                if (Utils.NextRandom32() % 100 == 0)
                {
                    try
                    {
                        msg = msg + (" data error IGNORE = " + data.toString());
                    }
                    catch (e:Error)
                    {
                    }
                }
                msg = msg + (" error IGNORE for " + _loadedUrl + " : " + );
                Ping.Send(msg);
                return retval;
        }// end function

    }
}
