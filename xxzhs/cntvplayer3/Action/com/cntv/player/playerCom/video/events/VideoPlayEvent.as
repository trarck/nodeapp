package com.cntv.player.playerCom.video.events
{
    import flash.events.*;

    public class VideoPlayEvent extends Event
    {
        public var data:Object;
        public static const EVENT_REAL_START:String = "event.real.start";
        public static const EVENT_VIDEO_PLAYED:String = "event.video.played";
        public static const EVENT_VIDEO_LOADED:String = "event.video.loaded";
        public static const EVENT_SET_VIDEO_PLAY:String = "event.set.video.play";
        public static const EVENT_SET_VIDEO_PLAY_STOP:String = "event.set.video.play.stop";
        public static const EVENT_SET_VIDEO_PAUSE:String = "event.set.video.pause";
        public static const EVENT_VIDEO_SEEK:String = "event.video.seek";
        public static const EVENT_SET_VOLUME:String = "event.set.volume";
        public static const EVENT_TURN_ON_MUTE:String = "event.turn.on.mute";
        public static const EVENT_TURN_OFF_MUTE:String = "event.turn.off.mute";
        public static const EVENT_SET_VIDEO_BRIGHTNESS:String = "event.set.video.brightness";
        public static const EVENT_SET_VIDEO_CONTRAST:String = "event.set.video.contrast";
        public static const EVENT_SET_VIDEO_PROPORTIONS:String = "event.set.video.proportions";
        public static const EVENT_SET_VIDEO_CHANGEBTN:String = "event.set.video.changebtn";
        public static const EVENT_SET_VIDEO_CHANGEBTN2:String = "event.set.video.changebtn2";
        public static const EVENT_SET_VIDEO_SCREEN_WIDE:String = "event.set.video.screen.wide";
        public static const EVENT_SET_VIDEO_SCREEN_NORMAL:String = "event.set.video.screen.normal";
        public static const EVENT_SET_BITERATE_MODE_CHANGE:String = "event.set.biterate.mode.change";
        public static const EVENT_SET_HTTP_BITERATE_MODE_CHANGE:String = "event.set.biterate.mode.change";
        public static const EVENT_SET_REPLAY:String = "event.set.replay";
        public static const EVENT_DOUBLE_CLICK:String = "event.double.click";
        public static const EVENT_SINGLE_CLICK:String = "event.single.click";
        public static const EVENT_PREDOWNLOAD_OVER:String = "event.predown.load.over";
        public static const EVENT_CYCLE_PLAY_NEXT:String = "event.cycle.play.next";
        public static const EVENT_CYCLE_PLAY_OVER:String = "event.cycle.play.over";
        public static const EVENT_CYCLE_CHARGE_TO_HTTP:String = "event.cycle.charge.to.http";
        public static const EVENT_JS_READY:String = "event.js.ready";
        public static const EVENT_RESET_BUFFER_FLAG:String = "event.reset.buffer.flag";
        public static const EVENT_SHOW_FPS:String = "event.show.fps";
        public static const EVENT_BITERATE_MODE_CHECK_OVER:String = "event.bitrate.mode.check.over";
        public static const EVENT_OUTSIDE_FULLSCREEN_CLICK:String = "outside.fullScreen.click";
        public static const EVENT_SMALL_WINDOW_CLICK:String = "event.small.window.click";
        public static const EVENT_UPDATA_LIVE_DATA:String = "event.updata.live.data";
        public static const EVENT_PLAY_SETPROGRES:String = "event.set.progress";
        public static const EVENT_VIDEO_ROTATE:String = "event.video.rotate";
        public static const EVENT_SET_VIDEO_SIZE:String = "event.set.video.size";
        public static const EVENT_SET_VIDEO_RATE:String = "event.set.video.rate";

        public function VideoPlayEvent(param1:String, param2 = null)
        {
            super(param1, false, false);
            this.data = param2;
            return;
        }// end function

    }
}
