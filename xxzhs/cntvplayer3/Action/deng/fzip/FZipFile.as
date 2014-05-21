package deng.fzip
{
    import deng.utils.*;
    import flash.utils.*;

    public class FZipFile extends Object
    {
        protected var _versionHost:int = 0;
        protected var _versionNumber:String = "2.0";
        protected var _compressionMethod:int = 8;
        protected var _encrypted:Boolean = false;
        protected var _implodeDictSize:int = -1;
        protected var _implodeShannonFanoTrees:int = -1;
        protected var _deflateSpeedOption:int = -1;
        protected var _hasDataDescriptor:Boolean = false;
        protected var _hasCompressedPatchedData:Boolean = false;
        protected var _date:Date;
        protected var _adler32:uint;
        protected var _hasAdler32:Boolean = false;
        protected var _sizeFilename:uint = 0;
        protected var _sizeExtra:uint = 0;
        protected var _filename:String = "";
        protected var _filenameEncoding:String;
        protected var _extraFields:Dictionary;
        protected var _comment:String = "";
        protected var _content:ByteArray;
        var _crc32:uint;
        var _sizeCompressed:uint = 0;
        var _sizeUncompressed:uint = 0;
        protected var isCompressed:Boolean = false;
        protected var parseFunc:Function;
        public static const COMPRESSION_NONE:int = 0;
        public static const COMPRESSION_SHRUNK:int = 1;
        public static const COMPRESSION_REDUCED_1:int = 2;
        public static const COMPRESSION_REDUCED_2:int = 3;
        public static const COMPRESSION_REDUCED_3:int = 4;
        public static const COMPRESSION_REDUCED_4:int = 5;
        public static const COMPRESSION_IMPLODED:int = 6;
        public static const COMPRESSION_TOKENIZED:int = 7;
        public static const COMPRESSION_DEFLATED:int = 8;
        public static const COMPRESSION_DEFLATED_EXT:int = 9;
        public static const COMPRESSION_IMPLODED_PKWARE:int = 10;
        static var HAS_UNCOMPRESS:Boolean = _loc_1.parameter.length() > 0;
        static var HAS_INFLATE:Boolean = _loc_1.length() > 0;

        public function FZipFile(param1:String = "utf-8")
        {
            this.parseFunc = this.parseFileHead;
            this._filenameEncoding = param1;
            this._extraFields = new Dictionary();
            this._content = new ByteArray();
            this._content.endian = Endian.BIG_ENDIAN;
            return;
        }// end function

        public function get date() : Date
        {
            return this._date;
        }// end function

        public function set date(param1:Date) : void
        {
            this._date = param1 != null ? (param1) : (new Date());
            return;
        }// end function

        public function get filename() : String
        {
            return this._filename;
        }// end function

        public function set filename(param1:String) : void
        {
            this._filename = param1;
            return;
        }// end function

        function get hasDataDescriptor() : Boolean
        {
            return this._hasDataDescriptor;
        }// end function

        public function get content() : ByteArray
        {
            if (this.isCompressed)
            {
                this.uncompress();
            }
            return this._content;
        }// end function

        public function set content(param1:ByteArray) : void
        {
            this.setContent(param1);
            return;
        }// end function

        public function setContent(param1:ByteArray, param2:Boolean = true) : void
        {
            if (param1 != null && param1.length > 0)
            {
                param1.position = 0;
                param1.readBytes(this._content, 0, param1.length);
                this._crc32 = ChecksumUtil.CRC32(this._content);
                this._hasAdler32 = false;
            }
            else
            {
                this._content.length = 0;
                this._content.position = 0;
                this.isCompressed = false;
            }
            if (param2)
            {
                this.compress();
            }
            else
            {
                var _loc_3:* = this._content.length;
                this._sizeCompressed = this._content.length;
                this._sizeUncompressed = _loc_3;
            }
            return;
        }// end function

        public function get versionNumber() : String
        {
            return this._versionNumber;
        }// end function

        public function get sizeCompressed() : uint
        {
            return this._sizeCompressed;
        }// end function

        public function get sizeUncompressed() : uint
        {
            return this._sizeUncompressed;
        }// end function

        public function getContentAsString(param1:Boolean = true, param2:String = "utf-8") : String
        {
            var _loc_3:String = null;
            if (this.isCompressed)
            {
                this.uncompress();
            }
            this._content.position = 0;
            if (param2 == "utf-8")
            {
                _loc_3 = this._content.readUTFBytes(this._content.bytesAvailable);
            }
            else
            {
                _loc_3 = this._content.readMultiByte(this._content.bytesAvailable, param2);
            }
            this._content.position = 0;
            if (param1)
            {
                this.compress();
            }
            return _loc_3;
        }// end function

        public function setContentAsString(param1:String, param2:String = "utf-8", param3:Boolean = true) : void
        {
            this._content.length = 0;
            this._content.position = 0;
            this.isCompressed = false;
            if (param1 != null && param1.length > 0)
            {
                if (param2 == "utf-8")
                {
                    this._content.writeUTFBytes(param1);
                }
                else
                {
                    this._content.writeMultiByte(param1, param2);
                }
                this._crc32 = ChecksumUtil.CRC32(this._content);
                this._hasAdler32 = false;
            }
            if (param3)
            {
                this.compress();
            }
            else
            {
                var _loc_4:* = this._content.length;
                this._sizeCompressed = this._content.length;
                this._sizeUncompressed = _loc_4;
            }
            return;
        }// end function

        public function serialize(param1:IDataOutput, param2:Boolean, param3:Boolean = false, param4:uint = 0) : uint
        {
            var _loc_10:Object = null;
            var _loc_15:ByteArray = null;
            var _loc_16:Boolean = false;
            if (param1 == null)
            {
                return 0;
            }
            if (param3)
            {
                param1.writeUnsignedInt(FZip.SIG_CENTRAL_FILE_HEADER);
                param1.writeShort(this._versionHost << 8 | 20);
            }
            else
            {
                param1.writeUnsignedInt(FZip.SIG_LOCAL_FILE_HEADER);
            }
            param1.writeShort(this._versionHost << 8 | 20);
            param1.writeShort(this._filenameEncoding == "utf-8" ? (2048) : (0));
            param1.writeShort(this.isCompressed ? (COMPRESSION_DEFLATED) : (COMPRESSION_NONE));
            var _loc_5:* = this._date != null ? (this._date) : (new Date());
            var _loc_6:* = uint(_loc_5.getSeconds()) | uint(_loc_5.getMinutes()) << 5 | uint(_loc_5.getHours()) << 11;
            var _loc_7:* = uint(_loc_5.getDate()) | uint((_loc_5.getMonth() + 1)) << 5 | uint(_loc_5.getFullYear() - 1980) << 9;
            param1.writeShort(_loc_6);
            param1.writeShort(_loc_7);
            param1.writeUnsignedInt(this._crc32);
            param1.writeUnsignedInt(this._sizeCompressed);
            param1.writeUnsignedInt(this._sizeUncompressed);
            var _loc_8:* = new ByteArray();
            new ByteArray().endian = Endian.LITTLE_ENDIAN;
            if (this._filenameEncoding == "utf-8")
            {
                _loc_8.writeUTFBytes(this._filename);
            }
            else
            {
                _loc_8.writeMultiByte(this._filename, this._filenameEncoding);
            }
            var _loc_9:* = _loc_8.position;
            for (_loc_10 in this._extraFields)
            {
                
                _loc_15 = this._extraFields[_loc_10] as ByteArray;
                if (_loc_15 != null)
                {
                    _loc_8.writeShort(uint(_loc_10));
                    _loc_8.writeShort(uint(_loc_15.length));
                    _loc_8.writeBytes(_loc_15);
                }
            }
            if (param2)
            {
                if (!this._hasAdler32)
                {
                    _loc_16 = this.isCompressed;
                    if (_loc_16)
                    {
                        this.uncompress();
                    }
                    this._adler32 = ChecksumUtil.Adler32(this._content, 0, this._content.length);
                    this._hasAdler32 = true;
                    if (_loc_16)
                    {
                        this.compress();
                    }
                }
                _loc_8.writeShort(56026);
                _loc_8.writeShort(4);
                _loc_8.writeUnsignedInt(this._adler32);
            }
            var _loc_11:* = _loc_8.position - _loc_9;
            if (param3 && this._comment.length > 0)
            {
                if (this._filenameEncoding == "utf-8")
                {
                    _loc_8.writeUTFBytes(this._comment);
                }
                else
                {
                    _loc_8.writeMultiByte(this._comment, this._filenameEncoding);
                }
            }
            var _loc_12:* = _loc_8.position - _loc_9 - _loc_11;
            param1.writeShort(_loc_9);
            param1.writeShort(_loc_11);
            if (param3)
            {
                param1.writeShort(_loc_12);
                param1.writeShort(0);
                param1.writeShort(0);
                param1.writeUnsignedInt(0);
                param1.writeUnsignedInt(param4);
            }
            if (_loc_9 + _loc_11 + _loc_12 > 0)
            {
                param1.writeBytes(_loc_8);
            }
            var _loc_13:uint = 0;
            if (!param3 && this._content.length > 0)
            {
                if (this.isCompressed)
                {
                    if (HAS_UNCOMPRESS || HAS_INFLATE)
                    {
                        _loc_13 = this._content.length;
                        param1.writeBytes(this._content, 0, _loc_13);
                    }
                    else
                    {
                        _loc_13 = this._content.length - 6;
                        param1.writeBytes(this._content, 2, _loc_13);
                    }
                }
                else
                {
                    _loc_13 = this._content.length;
                    param1.writeBytes(this._content, 0, _loc_13);
                }
            }
            var _loc_14:* = 30 + _loc_9 + _loc_11 + _loc_12 + _loc_13;
            if (param3)
            {
                _loc_14 = _loc_14 + 16;
            }
            return _loc_14;
        }// end function

        function parse(param1:IDataInput) : Boolean
        {
            while (param1.bytesAvailable && this.parseFunc(param1))
            {
                
            }
            return this.parseFunc === this.parseFileIdle;
        }// end function

        protected function parseFileIdle(param1:IDataInput) : Boolean
        {
            return false;
        }// end function

        protected function parseFileHead(param1:IDataInput) : Boolean
        {
            if (param1.bytesAvailable >= 30)
            {
                this.parseHead(param1);
                if (this._sizeFilename + this._sizeExtra > 0)
                {
                    this.parseFunc = this.parseFileHeadExt;
                }
                else
                {
                    this.parseFunc = this.parseFileContent;
                }
                return true;
            }
            return false;
        }// end function

        protected function parseFileHeadExt(param1:IDataInput) : Boolean
        {
            if (param1.bytesAvailable >= this._sizeFilename + this._sizeExtra)
            {
                this.parseHeadExt(param1);
                this.parseFunc = this.parseFileContent;
                return true;
            }
            return false;
        }// end function

        protected function parseFileContent(param1:IDataInput) : Boolean
        {
            var _loc_2:Boolean = true;
            if (this._hasDataDescriptor)
            {
                this.parseFunc = this.parseFileIdle;
                _loc_2 = false;
            }
            else if (this._sizeCompressed == 0)
            {
                this.parseFunc = this.parseFileIdle;
            }
            else if (param1.bytesAvailable >= this._sizeCompressed)
            {
                this.parseContent(param1);
                this.parseFunc = this.parseFileIdle;
            }
            else
            {
                _loc_2 = false;
            }
            return _loc_2;
        }// end function

        protected function parseHead(param1:IDataInput) : void
        {
            var _loc_2:* = param1.readUnsignedShort();
            this._versionHost = _loc_2 >> 8;
            this._versionNumber = Math.floor((_loc_2 & 255) / 10) + "." + (_loc_2 & 255) % 10;
            var _loc_3:* = param1.readUnsignedShort();
            this._compressionMethod = param1.readUnsignedShort();
            this._encrypted = (_loc_3 & 1) !== 0;
            this._hasDataDescriptor = (_loc_3 & 8) !== 0;
            this._hasCompressedPatchedData = (_loc_3 & 32) !== 0;
            if ((_loc_3 & 800) !== 0)
            {
                this._filenameEncoding = "utf-8";
            }
            if (this._compressionMethod === COMPRESSION_IMPLODED)
            {
                this._implodeDictSize = (_loc_3 & 2) !== 0 ? (8192) : (4096);
                this._implodeShannonFanoTrees = (_loc_3 & 4) !== 0 ? (3) : (2);
            }
            else if (this._compressionMethod === COMPRESSION_DEFLATED)
            {
                this._deflateSpeedOption = (_loc_3 & 6) >> 1;
            }
            var _loc_4:* = param1.readUnsignedShort();
            var _loc_5:* = param1.readUnsignedShort();
            var _loc_6:* = _loc_4 & 31;
            var _loc_7:* = (_loc_4 & 2016) >> 5;
            var _loc_8:* = (_loc_4 & 63488) >> 11;
            var _loc_9:* = _loc_5 & 31;
            var _loc_10:* = (_loc_5 & 480) >> 5;
            var _loc_11:* = ((_loc_5 & 65024) >> 9) + 1980;
            this._date = new Date(_loc_11, (_loc_10 - 1), _loc_9, _loc_8, _loc_7, _loc_6, 0);
            this._crc32 = param1.readUnsignedInt();
            this._sizeCompressed = param1.readUnsignedInt();
            this._sizeUncompressed = param1.readUnsignedInt();
            this._sizeFilename = param1.readUnsignedShort();
            this._sizeExtra = param1.readUnsignedShort();
            return;
        }// end function

        protected function parseHeadExt(param1:IDataInput) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:ByteArray = null;
            if (this._filenameEncoding == "utf-8")
            {
                this._filename = param1.readUTFBytes(this._sizeFilename);
            }
            else
            {
                this._filename = param1.readMultiByte(this._sizeFilename, this._filenameEncoding);
            }
            var _loc_2:* = this._sizeExtra;
            while (_loc_2 > 4)
            {
                
                _loc_3 = param1.readUnsignedShort();
                _loc_4 = param1.readUnsignedShort();
                if (_loc_4 > _loc_2)
                {
                    throw new Error("Parse error in file " + this._filename + ": Extra field data size too big.");
                }
                if (_loc_3 === 56026 && _loc_4 === 4)
                {
                    this._adler32 = param1.readUnsignedInt();
                    this._hasAdler32 = true;
                }
                else if (_loc_4 > 0)
                {
                    _loc_5 = new ByteArray();
                    param1.readBytes(_loc_5, 0, _loc_4);
                    this._extraFields[_loc_3] = _loc_5;
                }
                _loc_2 = _loc_2 - (_loc_4 + 4);
            }
            if (_loc_2 > 0)
            {
                param1.readBytes(new ByteArray(), 0, _loc_2);
            }
            return;
        }// end function

        function parseContent(param1:IDataInput) : void
        {
            var _loc_2:uint = 0;
            if (this._compressionMethod === COMPRESSION_DEFLATED && !this._encrypted)
            {
                if (HAS_UNCOMPRESS || HAS_INFLATE)
                {
                    param1.readBytes(this._content, 0, this._sizeCompressed);
                }
                else if (this._hasAdler32)
                {
                    this._content.writeByte(120);
                    _loc_2 = ~this._deflateSpeedOption << 6 & 192;
                    _loc_2 = _loc_2 + (31 - (120 << 8 | _loc_2) % 31);
                    this._content.writeByte(_loc_2);
                    param1.readBytes(this._content, 2, this._sizeCompressed);
                    this._content.position = this._content.length;
                    this._content.writeUnsignedInt(this._adler32);
                }
                else
                {
                    throw new Error("Adler32 checksum not found.");
                }
                this.isCompressed = true;
            }
            else if (this._compressionMethod == COMPRESSION_NONE)
            {
                param1.readBytes(this._content, 0, this._sizeCompressed);
                this.isCompressed = false;
            }
            else
            {
                throw new Error("Compression method " + this._compressionMethod + " is not supported.");
            }
            this._content.position = 0;
            return;
        }// end function

        protected function compress() : void
        {
            if (!this.isCompressed)
            {
                if (this._content.length > 0)
                {
                    this._content.position = 0;
                    this._sizeUncompressed = this._content.length;
                    if (HAS_INFLATE)
                    {
                        this._content.deflate();
                        this._sizeCompressed = this._content.length;
                    }
                    else if (HAS_UNCOMPRESS)
                    {
                        this._content.compress.apply(this._content, ["deflate"]);
                        this._sizeCompressed = this._content.length;
                    }
                    else
                    {
                        this._content.compress();
                        this._sizeCompressed = this._content.length - 6;
                    }
                    this._content.position = 0;
                    this.isCompressed = true;
                }
                else
                {
                    this._sizeCompressed = 0;
                    this._sizeUncompressed = 0;
                }
            }
            return;
        }// end function

        protected function uncompress() : void
        {
            if (this.isCompressed && this._content.length > 0)
            {
                this._content.position = 0;
                if (HAS_INFLATE)
                {
                    this._content.inflate();
                }
                else if (HAS_UNCOMPRESS)
                {
                    this._content.uncompress.apply(this._content, ["deflate"]);
                }
                else
                {
                    this._content.uncompress();
                }
                this._content.position = 0;
                this.isCompressed = false;
            }
            return;
        }// end function

        public function toString() : String
        {
            return "[FZipFile]" + "\n  name:" + this._filename + "\n  date:" + this._date + "\n  sizeCompressed:" + this._sizeCompressed + "\n  sizeUncompressed:" + this._sizeUncompressed + "\n  versionHost:" + this._versionHost + "\n  versionNumber:" + this._versionNumber + "\n  compressionMethod:" + this._compressionMethod + "\n  encrypted:" + this._encrypted + "\n  hasDataDescriptor:" + this._hasDataDescriptor + "\n  hasCompressedPatchedData:" + this._hasCompressedPatchedData + "\n  filenameEncoding:" + this._filenameEncoding + "\n  crc32:" + this._crc32.toString(16) + "\n  adler32:" + this._adler32.toString(16);
        }// end function

        var _loc_2:int = 0;
        var _loc_3:* = describeType(ByteArray).factory.method;
        var _loc_1:* = new XMLList("");
        for each (_loc_4 in _loc_3)
        {
            
            var _loc_5:* = _loc_3[_loc_2];
            with (_loc_3[_loc_2])
            {
                if (@name == "uncompress")
                {
                    _loc_1[_loc_2] = _loc_4;
                }
            }
        }
        var _loc_2:int = 0;
        var _loc_3:* = describeType(ByteArray).factory.method;
        var _loc_1:* = new XMLList("");
        for each (_loc_4 in _loc_3)
        {
            
            var _loc_5:* = _loc_3[_loc_2];
            with (_loc_3[_loc_2])
            {
                if (@name == "inflate")
                {
                    _loc_1[_loc_2] = _loc_4;
                }
            }
        }
    }
}
