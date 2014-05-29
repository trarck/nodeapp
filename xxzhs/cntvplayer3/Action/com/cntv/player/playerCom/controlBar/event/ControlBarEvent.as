package com.cntv.player.playerCom.controlBar.event
{
    import com.puremvc.view.event.*;

    public class ControlBarEvent extends CommonEvent
    {
        public static const EVENT_VIDEO_PLAY:String = "event.video.play";
        public static const EVENT_VIDEO_PLAY_STOP:String = "event.video.play.stop";
        public static const EVENT_VIDEO_PAUSE:String = "event.video.pause";
        public static const EVENT_ACTIVE_MUTE:String = "event.active.mute";
        public static const EVENT_LOCK_CONTROLBAR:String = "event.lock.controlbar";
        public static const EVENT_UNLOCK_CONTROLBAR:String = "event.unlock.controlbar";
        public static const EVENT_SHOW_CONTROLBAR:String = "event.show.controlbar";
        public static const EVENT_HIDE_CONTROLBAR:String = "event.hide.controlbar";
        public static const EVENT_CHANGE_RATE_BY_DATA:String = "event.change.rate.by.data";
        public static const EVENT_SHOW_HOTDOT:String = "event.show.hotdot";
        public static const EVENT_SHOW_NBA:String = "event.show.nba";
        public static const EVENT_ADD_HOTDOT:String = "event.add.hotdot";
        public static const EVENT_AUDIO_MODEL:String = "event.audio.model";
        public static const EVENT_VIDEO_MODEL:String = "event.video.model";
        public static const EVENT_HIDE_REPLAY:String = "event.hide.replay";
        public static const EVENT_SEEK:String = "event.seek";
        public static const EVENT_ADPLAY_OVER:String = "event.adplay.over";
        public static const EVENT_SHOUND_UP:String = "event.shound.up";
        public static const EVENT_SHOUND_DOWN:String = "event.shound.down";
        public static const EVENT_SOUNDSIZE_CLOSE:String = "event.sound.size.close";
        public static const EVENT_SHOW_SHOUND_SIZE:String = "show.sound.size.tip";
        public static const EVENT_HIDE_SHOUND_SIZE:String = "hide.sound.size.tip";
        public static const EVENT_SET_TEXT:String = "event.set.text";
        public static const EVENT_SET_TEXT2:String = "event.set.text2";

        public function ControlBarEvent(param1:String, param2 = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
