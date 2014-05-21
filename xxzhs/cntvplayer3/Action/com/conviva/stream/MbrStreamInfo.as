package com.conviva.stream
{

    public class MbrStreamInfo extends Object
    {
        private var _defaultStream:MbrStreamItem = null;
        private var _defaultBitrate:Number = 0;
        private var _streamList:Array;
        private var _autoSwitch:Boolean = true;
        private var _useDefaultAtStart:Boolean = true;
        private var _isFaked:Boolean = false;
        private var _maxBitrate:Number = 0;

        public function MbrStreamInfo()
        {
            this._streamList = [];
            return;
        }// end function

        public function cleanup() : void
        {
            this._defaultStream = null;
            this._defaultBitrate = 0;
            while (this._streamList.length > 0)
            {
                
                this._streamList.shift();
            }
            this._autoSwitch = false;
            this._maxBitrate = 0;
            return;
        }// end function

        public function getUrlGenerateTime(param1:String) : Number
        {
            var _loc_2:int = 0;
            _loc_2 = 0;
            while (_loc_2 < this._streamList.length)
            {
                
                if (this._streamList[_loc_2].url == param1)
                {
                    return this._streamList[_loc_2].creatTimeMs;
                }
                _loc_2++;
            }
            return 0;
        }// end function

        public function addStream(param1:MbrStreamItem, param2:Boolean = false) : void
        {
            var _loc_4:Array = null;
            var _loc_3:int = 0;
            _loc_3 = 0;
            while (_loc_3 < this._streamList.length)
            {
                
                if (this._streamList[_loc_3].bitrate == param1.bitrate)
                {
                    break;
                }
                _loc_3++;
            }
            if (_loc_3 >= 0 && _loc_3 < this._streamList.length)
            {
                _loc_4 = this._streamList.splice(_loc_3, 1);
                if (this._defaultStream == _loc_4[0])
                {
                    param2 = true;
                }
            }
            this._streamList.push(param1);
            this._streamList.sortOn("bitrate", Array.NUMERIC);
            if (param2)
            {
                this._defaultStream = param1;
            }
            return;
        }// end function

        public function getStreamByUrl(param1:String) : MbrStreamItem
        {
            if (this._streamList.length == 0)
            {
                return null;
            }
            var _loc_2:int = 0;
            while (_loc_2 < this._streamList.length)
            {
                
                if (this._streamList[_loc_2].url == param1)
                {
                    return this._streamList[_loc_2];
                }
                _loc_2++;
            }
            return null;
        }// end function

        public function getStreamByRate(param1:Number) : MbrStreamItem
        {
            if (this._streamList.length == 0)
            {
                return null;
            }
            var _loc_2:int = 0;
            while (_loc_2 < this._streamList.length && this._streamList[_loc_2].bitrate <= param1)
            {
                
                _loc_2++;
            }
            if (_loc_2 > 0)
            {
                _loc_2 = _loc_2 - 1;
            }
            return this._streamList[_loc_2];
        }// end function

        public function getNextHighStream(param1:Number) : MbrStreamItem
        {
            var _loc_2:int = 0;
            while (_loc_2 < this._streamList.length && this._streamList[_loc_2].bitrate <= param1)
            {
                
                _loc_2++;
            }
            if (_loc_2 >= this._streamList.length)
            {
                return null;
            }
            return this._streamList[_loc_2];
        }// end function

        public function setDefaultByRate(param1:Number) : MbrStreamItem
        {
            this._defaultBitrate = param1;
            var _loc_2:* = this.getStreamByRate(param1);
            if (_loc_2)
            {
                this._defaultStream = _loc_2;
                return _loc_2;
            }
            return null;
        }// end function

        public function getStreamIndex(param1:MbrStreamItem) : int
        {
            if (param1 == null)
            {
                return -1;
            }
            var _loc_2:int = 0;
            while (_loc_2 < this._streamList.length)
            {
                
                if (param1.url == this._streamList[_loc_2].url && param1.bitrate == this._streamList[_loc_2].bitrate)
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return -1;
        }// end function

        public function adjustBitrate(param1:Number) : Number
        {
            if (this._streamList.length == 0 || this._maxBitrate == 0)
            {
                return param1;
            }
            if (param1 > this._maxBitrate)
            {
                param1 = this._maxBitrate;
            }
            if (param1 < this._streamList[0].bitrate)
            {
                param1 = this._streamList[0].bitrate;
            }
            return param1;
        }// end function

        public function setDeep(param1:Object) : void
        {
            var _loc_2:Object = null;
            var _loc_3:MbrStreamItem = null;
            this.cleanup();
            this._streamList = new Array();
            for each (_loc_2 in param1.streamList)
            {
                
                _loc_3 = new MbrStreamItem("", 0);
                _loc_3.setDeep(_loc_2);
                this.addStream(_loc_3, param1.defaultStream == _loc_2);
            }
            if (param1.hasOwnProperty("defaultBitrate"))
            {
                this._defaultBitrate = param1.defaultBitrate;
            }
            if (param1.hasOwnProperty("autoSwitch"))
            {
                this._autoSwitch = param1.autoSwitch;
            }
            if (param1.hasOwnProperty("useDefaultAtStart"))
            {
                this._useDefaultAtStart = param1.useDefaultAtStart;
            }
            if (param1.hasOwnProperty("maxBitrate"))
            {
                this._maxBitrate = param1.maxBitrate;
            }
            if (param1.hasOwnProperty("isFaked"))
            {
                this._isFaked = param1.isFaked;
            }
            return;
        }// end function

        public function debugString() : String
        {
            var _loc_2:Object = null;
            var _loc_1:* = "isFaked:" + this._isFaked + " auto:" + this._autoSwitch + " useDefaultAtStart:" + this._useDefaultAtStart + " maxBitrate:" + int(this.maxBitrate) + " streams:[";
            for each (_loc_2 in this._streamList)
            {
                
                _loc_1 = _loc_1 + ("{bitrate:" + _loc_2.bitrate + " url:\"" + _loc_2.url + "\"" + " default:" + (this._defaultStream == _loc_2) + "}, ");
            }
            return _loc_1 + "]";
        }// end function

        public function get defaultStream() : MbrStreamItem
        {
            if (!this._defaultStream)
            {
                return this.getStreamByRate(0);
            }
            return this._defaultStream;
        }// end function

        public function get defaultBitrate() : Number
        {
            return this._defaultBitrate;
        }// end function

        public function get isFaked() : Boolean
        {
            return this._isFaked;
        }// end function

        public function set isFaked(param1:Boolean) : void
        {
            this._isFaked = param1;
            return;
        }// end function

        public function get streamList() : Array
        {
            return this._streamList;
        }// end function

        public function set streamList(param1:Array) : void
        {
            this._streamList = param1;
            return;
        }// end function

        public function get autoSwitch() : Boolean
        {
            return this._autoSwitch;
        }// end function

        public function set autoSwitch(param1:Boolean) : void
        {
            this._autoSwitch = param1;
            return;
        }// end function

        public function get useDefaultAtStart() : Boolean
        {
            return this._useDefaultAtStart;
        }// end function

        public function set useDefaultAtStart(param1:Boolean) : void
        {
            this._useDefaultAtStart = param1;
            return;
        }// end function

        public function get maxBitrate() : Number
        {
            return this._maxBitrate;
        }// end function

        public function set maxBitrate(param1:Number) : void
        {
            this._maxBitrate = Math.max(0, param1);
            return;
        }// end function

    }
}
