package com.adobe.net
{
    import flash.utils.*;

    public class URIEncodingBitmap extends ByteArray
    {

        public function URIEncodingBitmap(param1:String) : void
        {
            var _loc_2:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_3:* = new ByteArray();
            _loc_2 = 0;
            while (_loc_2 < 16)
            {
                
                this.writeByte(0);
                _loc_2++;
            }
            _loc_3.writeUTFBytes(param1);
            _loc_3.position = 0;
            while (_loc_3.bytesAvailable)
            {
                
                _loc_4 = _loc_3.readByte();
                if (_loc_4 > 127)
                {
                    continue;
                }
                this.position = _loc_4 >> 3;
                _loc_5 = this.readByte();
                _loc_5 = _loc_5 | 1 << (_loc_4 & 7);
                this.position = _loc_4 >> 3;
                this.writeByte(_loc_5);
            }
            return;
        }// end function

        public function ShouldEscape(param1:String) : int
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_2:* = new ByteArray();
            _loc_2.writeUTFBytes(param1);
            _loc_2.position = 0;
            _loc_3 = _loc_2.readByte();
            if (_loc_3 & 128)
            {
                return 0;
            }
            if (_loc_3 < 31 || _loc_3 == 127)
            {
                return _loc_3;
            }
            this.position = _loc_3 >> 3;
            _loc_4 = this.readByte();
            if (_loc_4 & 1 << (_loc_3 & 7))
            {
                return _loc_3;
            }
            return 0;
        }// end function

    }
}
