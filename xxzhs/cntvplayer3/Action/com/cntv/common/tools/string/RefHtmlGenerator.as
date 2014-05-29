package com.cntv.common.tools.string
{
    import com.cntv.common.model.*;
    import flash.external.*;

    public class RefHtmlGenerator extends Object
    {
        private static var tempString:String = "<embed id=\'v_player_cctv\' width=\'{width}\' height=\'{height}\' flashvars=\'videoId={videoId}&filePath={filePath}&isAutoPlay=true&url={url}&tai={tai}&configPath={configPath}&widgetsConfig={widgetsConfig}&languageConfig={languageConfig}&hour24DataURL={hour24DataURL}&outsideChannelId={outsideChannelId}&videoCenterId={videoCenterId}\' allowscriptaccess=\'always\' allowfullscreen=\'true\' menu=\'false\' quality=\'best\' bgcolor=\'#000000\' name=\'v_player_cctv\' src=\'http://player.cntv.cn/standard/cntvOutSidePlayer.swf?v={version}\' type=\'application/x-shockwave-flash\' lk_mediaid=\'lk_juiceapp_mediaPopup_1257416656250\' lk_media=\'yes\'/>";
        private static var audioTempString:String = "<embed id=\'a_player_cctv\' width=\'640\' height=\'30\' flashvars=\'pid={videoCenterId}\' allowscriptaccess=\'always\' allowfullscreen=\'true\' menu=\'false\' quality=\'best\' bgcolor=\'#000000\' name=\'v_player_cctv\' src=\'http://player.cntv.cn/standard/cntvAudioPlayer.swf?v={version}\' type=\'application/x-shockwave-flash\'/>";

        public function RefHtmlGenerator()
        {
            return;
        }// end function

        public static function getRefHtml(param1:Object) : String
        {
            var _loc_2:* = tempString.replace("{videoId}", param1["videoId"]);
            _loc_2 = _loc_2.replace("{filePath}", param1["filePath"]);
            _loc_2 = _loc_2.replace("{url}", getRefUrl());
            _loc_2 = _loc_2.replace("{configPath}", ModelLocator.getInstance().configPath);
            _loc_2 = _loc_2.replace("{widgetsConfig}", param1["widgetsConfig"]);
            _loc_2 = _loc_2.replace("{languageConfig}", param1["languageConfig"]);
            _loc_2 = _loc_2.replace("{hour24DataURL}", param1["hour24DataURL"]);
            _loc_2 = _loc_2.replace("{version}", ModelLocator.VERSION_SHORT);
            _loc_2 = _loc_2.replace("{width}", ModelLocator.getInstance().screenW);
            _loc_2 = _loc_2.replace("{height}", ModelLocator.getInstance().screenH);
            _loc_2 = _loc_2.replace("{outsideChannelId}", ModelLocator.getInstance().paramVO.outsideChannelId);
            _loc_2 = _loc_2.replace("{videoCenterId}", ModelLocator.getInstance().paramVO.videoCenterId);
            _loc_2 = _loc_2.replace("{tai}", ModelLocator.getInstance().paramVO.tai);
            return _loc_2;
        }// end function

        public static function getIpadRefHtml(param1:Object) : String
        {
            var _loc_2:String = "<div id=\'forApple\'>";
            _loc_2 = _loc_2 + getRefHtml(param1);
            _loc_2 = _loc_2 + "<script language=\"javascript\" src=\"http://js.player.cntv.cn/creator/swfobject.js\" ></script>";
            _loc_2 = _loc_2 + "<script language=\"javascript\" src=\"http://js.player.cntv.cn/creator/forApple.js\" ></script>";
            _loc_2 = _loc_2 + "<script>createApplePlayer(\"flashPlayer\"," + ModelLocator.getInstance().screenW + "," + ModelLocator.getInstance().screenH + ",\"" + ModelLocator.getInstance().paramVO.videoCenterId + "\");</script></div>";
            return _loc_2;
        }// end function

        public static function getFlashURL(param1:Object) : String
        {
            var _loc_2:* = "http://player.cntv.cn/standard/cntvOutSidePlayer.swf?videoCenterId=" + ModelLocator.getInstance().paramVO.videoCenterId + "&tai=outSide." + ModelLocator.getInstance().paramVO.tai + "&videoId=" + ModelLocator.getInstance().paramVO.videoId;
            return _loc_2;
        }// end function

        public static function getAudioRefHtml(param1:Object) : String
        {
            var _loc_2:* = audioTempString.replace("{version}", ModelLocator.VERSION_SHORT);
            _loc_2 = _loc_2.replace("{videoCenterId}", ModelLocator.getInstance().paramVO.videoCenterId);
            return _loc_2;
        }// end function

        public static function getRefUrl() : String
        {
            var _loc_1:String = "";
            try
            {
                if (ExternalInterface.available)
                {
                    _loc_1 = ExternalInterface.call("function(){return location.href}");
                }
            }
            catch (e:Error)
            {
            }
            return _loc_1;
        }// end function

    }
}
