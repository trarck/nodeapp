package com.cntv.common.tools.recorder
{
    import com.cntv.common.model.*;
    import com.conviva.*;
    import com.puremvc.view.event.*;

    public class ConvivaMonitor extends Object
    {
        private var session:ConvivaLightSession;
        private var sss:ConvivaNetStream;
        private var dispatcher:GlobalDispatcher;
        public static const SERVER_URL:String = "http://livepass.conviva.com";
        public static const CUSMTOR_URL:String = "c3.CCTV";
        public static const EVENT_UPDATE_CONVIVA_BIT:String = "event.updata.conviva.bit";
        public static const EVENT_UPDATE_STREAM:String = "event.updata.stream";
        public static const EVENT_NEW_START:String = "event.new.start";
        public static var STARED:Boolean = false;

        public function ConvivaMonitor()
        {
            return;
        }// end function

        public function init(param1:String, param2:String) : void
        {
            this.dispatcher = GlobalDispatcher.getInstance();
            LivePass.init(SERVER_URL, CUSMTOR_URL, null);
            this.dispatcher.addEventListener(EVENT_UPDATE_CONVIVA_BIT, this.updataBit);
            this.dispatcher.addEventListener(EVENT_UPDATE_STREAM, this.attachNewStream);
            return;
        }// end function

        public function createSession(param1:String, param2:String) : void
        {
            var _loc_3:* = new Object();
            _loc_3["serverName"] = param1;
            _loc_3["from"] = "cntv";
            _loc_3["playerId"] = "cntv";
            _loc_3["cdnName"] = ModelLocator.getInstance().currentVideoInfo.serverName;
            _loc_3["tai"] = ModelLocator.getInstance().paramVO.tai;
            _loc_3["refer"] = ModelLocator.getInstance().currentVideoInfo.refURL;
            if (ModelLocator.getInstance().useStaticData == true)
            {
                _loc_3["vdf"] = "txt";
            }
            else
            {
                _loc_3["vdf"] = "vdn";
            }
            _loc_3["version"] = ModelLocator.VERSION_SHORT;
            if (ModelLocator.getInstance().currentVideoInfo.isRtmp)
            {
                _loc_3["proto"] = "rtmp";
            }
            else if (ModelLocator.getInstance().isP2pMode)
            {
                _loc_3["proto"] = "p2p";
            }
            else
            {
                _loc_3["proto"] = "http";
            }
            var _loc_4:* = new ConvivaContentInfo(param2, param1, _loc_3);
            new ConvivaContentInfo(param2, param1, _loc_3).monitoringOptions = {bitrateKbps:ModelLocator.getInstance().currentBitrate};
            _loc_4.bitrate = ModelLocator.getInstance().currentBitrate;
            this.session = new ConvivaLightSession(_loc_4);
            this.session.setCurrentBitrate(ModelLocator.getInstance().currentBitrate);
            return;
        }// end function

        public function updataBit(event:CommonEvent) : void
        {
            this.session.setCurrentBitrate(event.data);
            return;
        }// end function

        public function attachNewStream(event:CommonEvent) : void
        {
            if (event.data != null)
            {
                this.session.attachStreamer(event.data);
            }
            return;
        }// end function

        public function start(param1:Object, param2:String) : void
        {
            this.session.startMonitor(param1, param2);
            return;
        }// end function

        public function switchStreamer(param1:Object, param2:String) : void
        {
            this.session.pauseMonitor();
            this.session.startMonitor(param1, param2);
            return;
        }// end function

        public function cleanUp() : void
        {
            this.session.cleanup();
            return;
        }// end function

        public function sendPackage(param1:String, param2:Object) : void
        {
            LivePass.metrics.sendEvent(param1, param2);
            return;
        }// end function

    }
}
