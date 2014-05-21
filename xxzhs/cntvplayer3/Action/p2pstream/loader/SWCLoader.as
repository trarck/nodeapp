package p2pstream.loader
{
    import com.adobe.net.*;
    import deng.fzip.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import p2pstream.cntv.*;

    public class SWCLoader extends EventDispatcher
    {
        private var S:ByteArray = null;
        private var _isSWC:Boolean = false;
        private var _startTime:Number = 0;
        private var _timeout:Number = 0;
        private var _urlTimer:Timer = null;
        private var _urlLoader:URLLoader = null;
        private var _data:ByteArray = null;
        private var _swcErrors:int = 0;
        private var _swfErrors:int = 0;
        private var _rawSWC:FZip = null;
        private var _loader:Loader = null;
        public static const COMPLETE:String = "swcLoadComplete";
        public static const ERROR:String = "swcLoadError";
        public static const STATUS_SUCCESS:int = 0;
        public static const STATUS_TIMEOUT:int = -1;
        public static const STATUS_URL_ERROR:int = -2;
        public static const STATUS_SWC_ERROR:int = -3;
        public static const STATUS_SWF_ERROR:int = -4;
        public static const STATUS_VER_ERROR:int = -5;
        private static var CHANNEL:String = "4b81f918dbf95fc01073b342616f7a57";
        private static var _LoggerURL:String = "http://slt.cntv.ss3w.com/log.html";
        private static var _SwfURL:String = "http://swf.cntv.ss3w.com/4b81f918dbf95fc01073b342616f7a57/ss.swf";

        public function SWCLoader()
        {
            return;
        }// end function

        public function load(param1:String = null, param2:Number = 6000, param3:Number = 0) : void
        {
            if (param1 == null || Math.random() <= param3)
            {
                param1 = _SwfURL;
            }
            if (!this.checkVersion())
            {
                this.notifyStatus(STATUS_VER_ERROR);
                return;
            }
            var _loc_4:* = /\.(swf$|swf\?)""\.(swf$|swf\?)/i;
            this._isSWC = _loc_4.exec(param1) == null;
            if (param2 != 0)
            {
                this._urlTimer = new Timer(param2, 1);
                this._urlTimer.addEventListener(TimerEvent.TIMER, this.onURLTimeout);
                this._urlTimer.start();
            }
            this._timeout = param2;
            this._startTime = new Date().time;
            var _loc_5:* = new URI(param1);
            var _loc_6:* = new URI(param1).authority;
            var _loc_7:* = Number(_loc_5.port);
            if (!Number(_loc_5.port))
            {
                _loc_7 = 80;
            }
            Security.loadPolicyFile("http://" + _loc_6 + ":" + _loc_7 + "/crossdomain.xml");
            this._urlLoader = new URLLoader();
            this._urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this._urlLoader.addEventListener(Event.COMPLETE, this.onURLLoaded);
            this._urlLoader.addEventListener(ProgressEvent.PROGRESS, this.onURLProgress);
            this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onURLError);
            this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onURLError);
            try
            {
                this._urlLoader.load(new URLRequest(param1));
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function onURLProgress(event:Event) : void
        {
            if (this._urlTimer != null)
            {
                this._urlTimer.reset();
                this._urlTimer.start();
            }
            return;
        }// end function

        private function onURLTimeout(event:Event) : void
        {
            if (this._urlTimer != null)
            {
                this._urlTimer.stop();
                this._urlTimer.removeEventListener(TimerEvent.TIMER, this.onURLTimeout);
                this._urlTimer = null;
            }
            this.notifyStatus(STATUS_TIMEOUT);
            return;
        }// end function

        private function onURLError(event:Event) : void
        {
            if (this._urlTimer != null)
            {
                this._urlTimer.stop();
                this._urlTimer.removeEventListener(TimerEvent.TIMER, this.onURLTimeout);
                this._urlTimer = null;
            }
            this.notifyStatus(STATUS_URL_ERROR);
            return;
        }// end function

        private function onURLLoaded(event:Event) : void
        {
            if (this._urlTimer != null)
            {
                this._urlTimer.stop();
                this._urlTimer.removeEventListener(TimerEvent.TIMER, this.onURLTimeout);
                this._urlTimer = null;
            }
            if (this._urlLoader.bytesLoaded > 0 && this._urlLoader.bytesLoaded == this._urlLoader.bytesTotal)
            {
                this._data = this._urlLoader.data as ByteArray;
                if (this._isSWC)
                {
                    this.loadSWC();
                }
                else
                {
                    this.loadSWF();
                }
            }
            else
            {
                this.notifyStatus(STATUS_URL_ERROR);
            }
            return;
        }// end function

        private function loadSWC() : void
        {
            this._rawSWC = new FZip();
            this._rawSWC.addEventListener(Event.COMPLETE, this.onSWCLoaded);
            this._rawSWC.addEventListener(FZipErrorEvent.PARSE_ERROR, this.onSWCError);
            try
            {
                this._rawSWC.loadBytes(this._data);
            }
            catch (e:Error)
            {
                onSWCError(null);
            }
            return;
        }// end function

        private function onSWCError(event:Event) : void
        {
            this._rawSWC.removeEventListener(Event.COMPLETE, this.onSWCLoaded);
            this._rawSWC.removeEventListener(FZipErrorEvent.PARSE_ERROR, this.onSWCError);
            var _loc_2:String = this;
            _loc_2._swcErrors = this._swcErrors + 1;
            if (++this._swcErrors == 1 && this.decipher())
            {
                this.loadSWC();
            }
            else
            {
                this.notifyStatus(STATUS_SWC_ERROR);
            }
            return;
        }// end function

        private function onSWCLoaded(event:Event) : void
        {
            var codeSWF:FZipFile;
            var e:* = event;
            this._rawSWC.removeEventListener(Event.COMPLETE, this.onSWCLoaded);
            this._rawSWC.removeEventListener(FZipErrorEvent.PARSE_ERROR, this.onSWCError);
            try
            {
                this._data = null;
                codeSWF = this._rawSWC.getFileByName("library.swf");
                this._data = codeSWF.content;
            }
            catch (e:Error)
            {
                notifyStatus(STATUS_SWC_ERROR);
            }
            if (this._data != null)
            {
                this.loadSWF();
            }
            else
            {
                this.notifyStatus(STATUS_SWC_ERROR);
            }
            return;
        }// end function

        private function loadSWF() : void
        {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onSWFLoaded);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onSWFError);
            var _loc_1:* = new LoaderContext(false, ApplicationDomain.currentDomain);
            this._loader.loadBytes(this._data, _loc_1);
            return;
        }// end function

        private function onSWFError(event:Event) : void
        {
            this._loader.removeEventListener(Event.COMPLETE, this.onSWFLoaded);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onSWFError);
            var _loc_2:String = this;
            _loc_2._swfErrors = this._swfErrors + 1;
            if (++this._swfErrors == 1 && this.decipher())
            {
                this.loadSWF();
            }
            else
            {
                this.notifyStatus(STATUS_SWF_ERROR);
            }
            return;
        }// end function

        private function onSWFLoaded(event:Event) : void
        {
            this._loader.removeEventListener(Event.COMPLETE, this.onSWFLoaded);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onSWFError);
            this.notifyStatus(STATUS_SUCCESS);
            return;
        }// end function

        private function notifyStatus(param1:int) : void
        {
            var _loc_2:* = new Date().time;
            var _loc_3:* = param1 == STATUS_SUCCESS ? (_loc_2 - this._startTime) : (param1);
            var _loc_4:* = Math.random() * uint(4294967295);
            var _loc_5:* = uint(uint(_loc_4 ^ uint(_loc_2 / 1000)) * 1725243750) ^ 883767687;
            var _loc_6:Object = {version:0, StartTime:this._startTime, EndTime:_loc_2, ID:_loc_4, MAC:_loc_5, reportId:0, swcLoadTime:_loc_3, Channel:CHANNEL};
            var _loc_7:* = this.getFormatV0();
            var _loc_8:* = this.encodeReportObject(_loc_6, _loc_7);
            trace(_loc_8);
            var _loc_9:* = _LoggerURL + "?v=" + uint(Math.random() * 4294967296) + "&c=cntv";
            var _loc_10:* = new URLRequest(_loc_9);
            new URLRequest(_loc_9).method = URLRequestMethod.POST;
            _loc_10.data = _loc_8;
            try
            {
                sendToURL(_loc_10);
            }
            catch (e:Error)
            {
            }
            if (param1 == STATUS_SUCCESS)
            {
                dispatchEvent(new Event(COMPLETE));
            }
            else
            {
                SSNetStream.swcLoaded = false;
                dispatchEvent(new Event(ERROR));
            }
            return;
        }// end function

        private function decipher() : Boolean
        {
            var _loc_1:* = "4e30d" + "0314e4" + "9552a3" + "0fb70" + "06c7" + "d48d70";
            var _loc_2:* = parseInt("1393") + parseInt("1607") + parseInt("72");
            if (this._data.length < 4)
            {
                return false;
            }
            var _loc_3:* = this._data[0] << 24 | this._data[1] << 16 | this._data[2] << 8 | this._data[3];
            if (this._data.length < 4 + _loc_3)
            {
                return false;
            }
            var _loc_4:* = new ByteArray();
            new ByteArray().length = _loc_3 + _loc_1.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_4[_loc_5] = this._data[4 + _loc_5];
                _loc_5++;
            }
            _loc_5 = 0;
            while (_loc_5 < _loc_1.length)
            {
                
                _loc_4[_loc_3 + _loc_5] = _loc_1.charCodeAt(_loc_5);
                _loc_5++;
            }
            var _loc_6:* = new ByteArray();
            this._data.position = 4 + _loc_3;
            this._data.readBytes(_loc_6);
            this.ksa(_loc_4);
            var _loc_7:* = this.prga(_loc_2);
            _loc_5 = 0;
            while (_loc_5 < _loc_6.length)
            {
                
                _loc_6[_loc_5] = uint(_loc_6[_loc_5] ^ _loc_7);
                _loc_7 = this.prga((uint(_loc_7 & 31) + 1));
                _loc_5++;
            }
            this._data = _loc_6;
            return true;
        }// end function

        private function ksa(param1:ByteArray) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            this.S = new ByteArray();
            _loc_2 = 0;
            while (_loc_2 < 255)
            {
                
                this.S[_loc_2] = _loc_2;
                _loc_2 = _loc_2 + 1;
            }
            _loc_4 = param1.length;
            _loc_2 = 0;
            _loc_3 = 0;
            while (_loc_2 < 255)
            {
                
                _loc_3 = (_loc_3 + this.S[_loc_2] + param1[_loc_2 % _loc_4]) % 256;
                this.swap(_loc_2, _loc_3);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function prga(param1:int) : int
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            _loc_4 = 0;
            _loc_2 = 0;
            _loc_3 = 0;
            while (_loc_4 < param1)
            {
                
                _loc_2 = (_loc_2 + 1) & 255;
                _loc_3 = _loc_3 + this.S[_loc_2] & 255;
                this.swap(_loc_2, _loc_3);
                _loc_4 = _loc_4 + 1;
            }
            return this.S[this.S[_loc_2] + this.S[_loc_3] & 255];
        }// end function

        private function swap(param1:int, param2:int) : void
        {
            var _loc_3:* = this.S[param1];
            this.S[param1] = this.S[param2];
            this.S[param2] = _loc_3;
            return;
        }// end function

        private function checkVersion() : Boolean
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_1:* = Capabilities.version.split(" ")[1];
            var _loc_2:* = _loc_1.split(",");
            if (_loc_2.length >= 2)
            {
                _loc_3 = int(_loc_2[0]);
                _loc_4 = int(_loc_2[1]);
                if (_loc_3 > 10 || _loc_3 == 10 && _loc_4 >= 2)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private function getFormatV0() : Object
        {
            var _loc_1:Object = {version:0, StartTime:1, EndTime:2, ID:3, MAC:4, reportId:5, swcLoadTime:6, Channel:7};
            return _loc_1;
        }// end function

        private function encodeReportObject(param1:Object, param2:Object) : String
        {
            var _loc_4:String = null;
            var _loc_5:int = 0;
            var _loc_6:ByteArray = null;
            var _loc_7:Array = null;
            var _loc_8:int = 0;
            var _loc_3:* = new Array();
            for (_loc_4 in param2)
            {
                
                _loc_3[param2[_loc_4]] = _loc_4;
            }
            _loc_5 = _loc_3.length;
            _loc_6 = new ByteArray();
            _loc_6.length = Math.ceil(_loc_5 / 8);
            _loc_7 = new Array();
            _loc_8 = 0;
            while (_loc_8 < _loc_5)
            {
                
                if (param1.hasOwnProperty(_loc_3[_loc_8]))
                {
                    _loc_6[uint(_loc_8 / 8)] = _loc_6[uint(_loc_8 / 8)] | 1 << _loc_8 % 8;
                    _loc_7.push(param1[_loc_3[_loc_8]]);
                }
                _loc_8++;
            }
            var _loc_9:String = "";
            _loc_9 = "" + ("0" + _loc_5.toString(16)).substr(-2);
            _loc_8 = 0;
            while (_loc_8 < _loc_6.length)
            {
                
                _loc_9 = _loc_9 + ("0" + _loc_6[_loc_8].toString(16)).substr(-2);
                _loc_8++;
            }
            return "\t" + _loc_9 + "\t" + _loc_7.join("\t");
        }// end function

    }
}
