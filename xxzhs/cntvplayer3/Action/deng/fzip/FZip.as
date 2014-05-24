package deng.fzip
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class FZip extends EventDispatcher
    {
        protected var filesList:Array;
        protected var filesDict:Dictionary;
        protected var urlStream:URLStream;
        protected var charEncoding:String;
        protected var parseFunc:Function;
        protected var currentFile:FZipFile;
        protected var ddBuffer:ByteArray;
        protected var ddSignature:uint;
        protected var ddCompressedSize:uint;
        static const SIG_CENTRAL_FILE_HEADER:uint = 33639248;
        static const SIG_SPANNING_MARKER:uint = 808471376;
        static const SIG_LOCAL_FILE_HEADER:uint = 67324752;
        static const SIG_DIGITAL_SIGNATURE:uint = 84233040;
        static const SIG_END_OF_CENTRAL_DIRECTORY:uint = 101010256;
        static const SIG_ZIP64_END_OF_CENTRAL_DIRECTORY:uint = 101075792;
        static const SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR:uint = 117853008;
        static const SIG_DATA_DESCRIPTOR:uint = 134695760;
        static const SIG_ARCHIVE_EXTRA_DATA:uint = 134630224;
        static const SIG_SPANNING:uint = 134695760;

        public function FZip(param1:String = "utf-8")
        {
            this.charEncoding = param1;
            this.parseFunc = this.parseIdle;
            return;
        }// end function

        public function get active() : Boolean
        {
            return this.parseFunc !== this.parseIdle;
        }// end function

        public function load(param1:URLRequest) : void
        {
            if (!this.urlStream && this.parseFunc == this.parseIdle)
            {
                this.urlStream = new URLStream();
                this.urlStream.endian = Endian.LITTLE_ENDIAN;
                this.addEventHandlers();
                this.filesList = [];
                this.filesDict = new Dictionary();
                this.parseFunc = this.parseSignature;
                this.urlStream.load(param1);
            }
            return;
        }// end function

        public function loadBytes(param1:ByteArray) : void
        {
            if (!this.urlStream && this.parseFunc == this.parseIdle)
            {
                this.filesList = [];
                this.filesDict = new Dictionary();
                param1.position = 0;
                param1.endian = Endian.LITTLE_ENDIAN;
                this.parseFunc = this.parseSignature;
                if (this.parse(param1))
                {
                    this.parseFunc = this.parseIdle;
                    dispatchEvent(new Event(Event.COMPLETE));
                }
                else
                {
                    dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR, "EOF"));
                }
            }
            return;
        }// end function

        public function close() : void
        {
            if (this.urlStream)
            {
                this.parseFunc = this.parseIdle;
                this.removeEventHandlers();
                this.urlStream.close();
                this.urlStream = null;
            }
            return;
        }// end function

        public function serialize(param1:IDataOutput, param2:Boolean = false) : void
        {
            var _loc_3:String = null;
            var _loc_4:ByteArray = null;
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:int = 0;
            var _loc_8:FZipFile = null;
            if (param1 != null && this.filesList.length > 0)
            {
                _loc_3 = param1.endian;
                _loc_4 = new ByteArray();
                var _loc_9:* = Endian.LITTLE_ENDIAN;
                _loc_4.endian = Endian.LITTLE_ENDIAN;
                param1.endian = _loc_9;
                _loc_5 = 0;
                _loc_6 = 0;
                _loc_7 = 0;
                while (_loc_7 < this.filesList.length)
                {
                    
                    _loc_8 = this.filesList[_loc_7] as FZipFile;
                    if (_loc_8 != null)
                    {
                        _loc_8.serialize(_loc_4, param2, true, _loc_5);
                        _loc_5 = _loc_5 + _loc_8.serialize(param1, param2);
                        _loc_6 = _loc_6 + 1;
                    }
                    _loc_7++;
                }
                if (_loc_4.length > 0)
                {
                    param1.writeBytes(_loc_4);
                }
                param1.writeUnsignedInt(SIG_END_OF_CENTRAL_DIRECTORY);
                param1.writeShort(0);
                param1.writeShort(0);
                param1.writeShort(_loc_6);
                param1.writeShort(_loc_6);
                param1.writeUnsignedInt(_loc_4.length);
                param1.writeUnsignedInt(_loc_5);
                param1.writeShort(0);
                param1.endian = _loc_3;
            }
            return;
        }// end function

        public function getFileCount() : uint
        {
            return this.filesList ? (this.filesList.length) : (0);
        }// end function

        public function getFileAt(param1:uint) : FZipFile
        {
            return this.filesList ? (this.filesList[param1] as FZipFile) : (null);
        }// end function

        public function getFileByName(param1:String) : FZipFile
        {
            return this.filesDict[param1] ? (this.filesDict[param1] as FZipFile) : (null);
        }// end function

        public function addFile(param1:String, param2:ByteArray = null, param3:Boolean = true) : FZipFile
        {
            return this.addFileAt(this.filesList ? (this.filesList.length) : (0), param1, param2, param3);
        }// end function

        public function addFileFromString(param1:String, param2:String, param3:String = "utf-8", param4:Boolean = true) : FZipFile
        {
            return this.addFileFromStringAt(this.filesList ? (this.filesList.length) : (0), param1, param2, param3, param4);
        }// end function

        public function addFileAt(param1:uint, param2:String, param3:ByteArray = null, param4:Boolean = true) : FZipFile
        {
            if (this.filesList == null)
            {
                this.filesList = [];
            }
            if (this.filesDict == null)
            {
                this.filesDict = new Dictionary();
            }
            else if (this.filesDict[param2])
            {
                throw new Error("File already exists: " + param2 + ". Please remove first.");
            }
            var _loc_5:* = new FZipFile();
            new FZipFile().filename = param2;
            _loc_5.setContent(param3, param4);
            if (param1 >= this.filesList.length)
            {
                this.filesList.push(_loc_5);
            }
            else
            {
                this.filesList.splice(param1, 0, _loc_5);
            }
            this.filesDict[param2] = _loc_5;
            return _loc_5;
        }// end function

        public function addFileFromStringAt(param1:uint, param2:String, param3:String, param4:String = "utf-8", param5:Boolean = true) : FZipFile
        {
            if (this.filesList == null)
            {
                this.filesList = [];
            }
            if (this.filesDict == null)
            {
                this.filesDict = new Dictionary();
            }
            else if (this.filesDict[param2])
            {
                throw new Error("File already exists: " + param2 + ". Please remove first.");
            }
            var _loc_6:* = new FZipFile();
            new FZipFile().filename = param2;
            _loc_6.setContentAsString(param3, param4, param5);
            if (param1 >= this.filesList.length)
            {
                this.filesList.push(_loc_6);
            }
            else
            {
                this.filesList.splice(param1, 0, _loc_6);
            }
            this.filesDict[param2] = _loc_6;
            return _loc_6;
        }// end function

        public function removeFileAt(param1:uint) : FZipFile
        {
            var _loc_2:FZipFile = null;
            if (this.filesList != null && this.filesDict != null && param1 < this.filesList.length)
            {
                _loc_2 = this.filesList[param1] as FZipFile;
                if (_loc_2 != null)
                {
                    this.filesList.splice(param1, 1);
                    delete this.filesDict[_loc_2.filename];
                    return _loc_2;
                }
            }
            return null;
        }// end function

        protected function parse(param1:IDataInput) : Boolean
        {
            while (this.parseFunc(param1))
            {
                
            }
            return this.parseFunc === this.parseIdle;
        }// end function

        protected function parseIdle(param1:IDataInput) : Boolean
        {
            return false;
        }// end function

        protected function parseSignature(param1:IDataInput) : Boolean
        {
            var _loc_2:uint = 0;
            if (param1.bytesAvailable >= 4)
            {
                _loc_2 = param1.readUnsignedInt();
                switch(_loc_2)
                {
                    case SIG_LOCAL_FILE_HEADER:
                    {
                        this.parseFunc = this.parseLocalfile;
                        this.currentFile = new FZipFile(this.charEncoding);
                        break;
                    }
                    case SIG_CENTRAL_FILE_HEADER:
                    case SIG_END_OF_CENTRAL_DIRECTORY:
                    case SIG_SPANNING_MARKER:
                    case SIG_DIGITAL_SIGNATURE:
                    case SIG_ZIP64_END_OF_CENTRAL_DIRECTORY:
                    case SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR:
                    case SIG_DATA_DESCRIPTOR:
                    case SIG_ARCHIVE_EXTRA_DATA:
                    case SIG_SPANNING:
                    {
                        this.parseFunc = this.parseIdle;
                        break;
                    }
                    default:
                    {
                        throw new Error("Unknown record signature: 0x" + _loc_2.toString(16));
                        break;
                    }
                }
                return true;
            }
            return false;
        }// end function

        protected function parseLocalfile(param1:IDataInput) : Boolean
        {
            if (this.currentFile.parse(param1))
            {
                if (this.currentFile.hasDataDescriptor)
                {
                    this.parseFunc = this.findDataDescriptor;
                    this.ddBuffer = new ByteArray();
                    this.ddSignature = 0;
                    this.ddCompressedSize = 0;
                    return true;
                }
                this.onFileLoaded();
                if (this.parseFunc != this.parseIdle)
                {
                    this.parseFunc = this.parseSignature;
                    return true;
                }
            }
            return false;
        }// end function

        protected function findDataDescriptor(param1:IDataInput) : Boolean
        {
            var _loc_2:uint = 0;
            while (param1.bytesAvailable > 0)
            {
                
                _loc_2 = param1.readUnsignedByte();
                this.ddSignature = this.ddSignature >>> 8 | _loc_2 << 24;
                if (this.ddSignature == SIG_DATA_DESCRIPTOR)
                {
                    this.ddBuffer.length = this.ddBuffer.length - 3;
                    this.parseFunc = this.validateDataDescriptor;
                    return true;
                }
                this.ddBuffer.writeByte(_loc_2);
            }
            return false;
        }// end function

        protected function validateDataDescriptor(param1:IDataInput) : Boolean
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            if (param1.bytesAvailable >= 12)
            {
                _loc_2 = param1.readUnsignedInt();
                _loc_3 = param1.readUnsignedInt();
                _loc_4 = param1.readUnsignedInt();
                if (this.ddBuffer.length == _loc_3)
                {
                    this.ddBuffer.position = 0;
                    this.currentFile._crc32 = _loc_2;
                    this.currentFile._sizeCompressed = _loc_3;
                    this.currentFile._sizeUncompressed = _loc_4;
                    this.currentFile.parseContent(this.ddBuffer);
                    this.onFileLoaded();
                    this.parseFunc = this.parseSignature;
                }
                else
                {
                    this.ddBuffer.writeUnsignedInt(_loc_2);
                    this.ddBuffer.writeUnsignedInt(_loc_3);
                    this.ddBuffer.writeUnsignedInt(_loc_4);
                    this.parseFunc = this.findDataDescriptor;
                }
                return true;
            }
            return false;
        }// end function

        protected function onFileLoaded() : void
        {
            this.filesList.push(this.currentFile);
            if (this.currentFile.filename)
            {
                this.filesDict[this.currentFile.filename] = this.currentFile;
            }
            dispatchEvent(new FZipEvent(FZipEvent.FILE_LOADED, this.currentFile));
            this.currentFile = null;
            return;
        }// end function

        protected function progressHandler(event:Event) : void
        {
            var evt:* = event;
            dispatchEvent(evt.clone());
            try
            {
                if (this.parse(this.urlStream))
                {
                    this.close();
                    dispatchEvent(new Event(Event.COMPLETE));
                }
            }
            catch (e:Error)
            {
                close();
                if (hasEventListener(FZipErrorEvent.PARSE_ERROR))
                {
                    dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR, e.message));
                }
                else
                {
                    throw e;
                }
            }
            return;
        }// end function

        protected function defaultHandler(event:Event) : void
        {
            dispatchEvent(event.clone());
            return;
        }// end function

        protected function defaultErrorHandler(event:Event) : void
        {
            this.close();
            dispatchEvent(event.clone());
            return;
        }// end function

        protected function addEventHandlers() : void
        {
            this.urlStream.addEventListener(Event.COMPLETE, this.defaultHandler);
            this.urlStream.addEventListener(Event.OPEN, this.defaultHandler);
            this.urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.defaultHandler);
            this.urlStream.addEventListener(IOErrorEvent.IO_ERROR, this.defaultErrorHandler);
            this.urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.defaultErrorHandler);
            this.urlStream.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
            return;
        }// end function

        protected function removeEventHandlers() : void
        {
            this.urlStream.removeEventListener(Event.COMPLETE, this.defaultHandler);
            this.urlStream.removeEventListener(Event.OPEN, this.defaultHandler);
            this.urlStream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.defaultHandler);
            this.urlStream.removeEventListener(IOErrorEvent.IO_ERROR, this.defaultErrorHandler);
            this.urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.defaultErrorHandler);
            this.urlStream.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
            return;
        }// end function

    }
}
