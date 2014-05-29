package com.cntv.common.tools.recorder
{
    import com.cntv.common.model.*;
    import com.utils.net.request.*;
    import flash.external.*;

    public class RecordManager extends Object
    {
        private var _locator:ModelLocator;
        public static const JS_FUNC_VIDEO_ID_SETTER:String = "_vjSetVideoAcc";
        public static const JS_FUNC_CHANNEL_ID_SETTER:String = "_vjSetVolumnAcc";
        public static const JS_FUNC_URL_SETTER:String = "_vjSetPlayUrl";
        public static const JS_FUNC_PLAY_STATUS_SETTER:String = "_vjRecordStatus";
        public static const JS_FUNC_LENGTH_SETTER:String = "_vjSetVideoLen";
        public static const JS_FUNC_CHANGE_VIDEO_SETTER:String = "_vjVideoTrack";

        public function RecordManager()
        {
            this._locator = ModelLocator.getInstance();
            if (ExternalInterface.available && ModelLocator.getInstance().ISWEBSITE)
            {
                try
                {
                    if (ExternalInterface.available)
                    {
                        ExternalInterface.call(JS_FUNC_CHANNEL_ID_SETTER, this._locator.paramVO.channelId);
                        ExternalInterface.call(JS_FUNC_URL_SETTER, "http://video.cntv.com/videoid/" + this._locator.paramVO.videoCenterId);
                    }
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        public function setVideoLength(param1:String) : void
        {
            var _loc_2:Object = null;
            var _loc_3:AttributeVo = null;
            if (ModelLocator.getInstance().ISWEBSITE && ExternalInterface.available)
            {
                ExternalInterface.call(JS_FUNC_LENGTH_SETTER, param1);
            }
            else
            {
                _loc_2 = new Object();
                _loc_2["a"] = "";
                _loc_2["t"] = "";
                _loc_2["i"] = "";
                _loc_2["b"] = "http%3A//out.play.cctv";
                _loc_2["c"] = this._locator.paramVO.outsideChannelId;
                _loc_2["s"] = "";
                _loc_2["l"] = "";
                _loc_2["z"] = "";
                _loc_2["j"] = "";
                _loc_2["f"] = "";
                _loc_2["ut"] = "";
                _loc_2["n"] = "";
                _loc_2["js"] = "";
                _loc_2["ck"] = "";
                _loc_2["st"] = "A-1_3|3_1|-2_0";
                _loc_2["vu"] = "http://video.cntv.com/videoid/" + this._locator.paramVO.videoCenterId;
                _loc_2["vid"] = this._locator.paramVO.outsideChannelId;
                _loc_2["vlen"] = param1;
                _loc_3 = new AttributeVo("http://cntv.wrating.com/v.gif", _loc_2);
                new HttpRequest(_loc_3, this.sendDataSuccess, this.sendDataFail);
            }
            return;
        }// end function

        public function setVideoStatus(param1:String) : void
        {
            if (ExternalInterface.available && ModelLocator.getInstance().ISWEBSITE)
            {
                try
                {
                    ExternalInterface.call(JS_FUNC_PLAY_STATUS_SETTER, param1);
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        public function setVideoChange() : void
        {
            if (ExternalInterface.available && ModelLocator.getInstance().ISWEBSITE)
            {
                try
                {
                    ExternalInterface.call(JS_FUNC_CHANGE_VIDEO_SETTER);
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        private function sendDataSuccess(param1:Object) : void
        {
            return;
        }// end function

        private function sendDataFail(param1:String) : void
        {
            return;
        }// end function

    }
}
