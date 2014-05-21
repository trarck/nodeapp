package deng.utils
{
    import flash.utils.*;

    public class ChecksumUtil extends Object
    {
        private static var crcTable:Array = makeCRCTable();

        public function ChecksumUtil()
        {
            return;
        }// end function

        private static function makeCRCTable() : Array
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_1:Array = [];
            _loc_2 = 0;
            while (_loc_2 < 256)
            {
                
                _loc_4 = _loc_2;
                _loc_3 = 0;
                while (_loc_3 < 8)
                {
                    
                    if (_loc_4 & 1)
                    {
                        _loc_4 = 3988292384 ^ _loc_4 >>> 1;
                    }
                    else
                    {
                        _loc_4 = _loc_4 >>> 1;
                    }
                    _loc_3 = _loc_3 + 1;
                }
                _loc_1.push(_loc_4);
                _loc_2 = _loc_2 + 1;
            }
            return _loc_1;
        }// end function

        public static function CRC32(param1:ByteArray, param2:uint = 0, param3:uint = 0) : uint
        {
            var _loc_4:uint = 0;
            if (param2 >= param1.length)
            {
                param2 = param1.length;
            }
            if (param3 == 0)
            {
                param3 = param1.length - param2;
            }
            if (param3 + param2 > param1.length)
            {
                param3 = param1.length - param2;
            }
            var _loc_5:uint = 4294967295;
            _loc_4 = param2;
            while (_loc_4 < param3)
            {
                
                _loc_5 = uint(crcTable[(_loc_5 ^ param1[_loc_4]) & 255]) ^ _loc_5 >>> 8;
                _loc_4 = _loc_4 + 1;
            }
            return _loc_5 ^ 4294967295;
        }// end function

        public static function Adler32(param1:ByteArray, param2:uint = 0, param3:uint = 0) : uint
        {
            if (param2 >= param1.length)
            {
                param2 = param1.length;
            }
            if (param3 == 0)
            {
                param3 = param1.length - param2;
            }
            if (param3 + param2 > param1.length)
            {
                param3 = param1.length - param2;
            }
            var _loc_4:* = param2;
            var _loc_5:uint = 1;
            var _loc_6:uint = 0;
            while (_loc_4 < param2 + param3)
            {
                
                _loc_5 = (_loc_5 + param1[_loc_4]) % 65521;
                _loc_6 = (_loc_5 + _loc_6) % 65521;
                _loc_4 = _loc_4 + 1;
            }
            return _loc_6 << 16 | _loc_5;
        }// end function

    }
}
