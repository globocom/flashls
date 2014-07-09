package com.globo {

    import org.mangui.chromeless.ChromelessPlayer;
    import org.mangui.hls.*;
    import org.mangui.hls.utils.Log;

    import flash.display.*;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.geom.Rectangle;
    import flash.media.StageVideoAvailability;
    import flash.utils.setTimeout;

    public class Player extends ChromelessPlayer {
        private var _url : String;

        public function Player() {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.fullScreenSourceRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, _onStageVideoState);
            stage.addEventListener(Event.RESIZE, _onStageResize);

            ExternalInterface.addCallback("globoGetDuration", _getDuration);
            ExternalInterface.addCallback("globoGetState", _getPlaybackState);
            ExternalInterface.addCallback("globoGetPosition", _getPosition);
            ExternalInterface.addCallback("globoGetType", _getType);
            ExternalInterface.addCallback("globoGetLevel", _getLevel);
            ExternalInterface.addCallback("globoGetLevels", _getLevels);
            ExternalInterface.addCallback("globoGetbufferLength", _getbufferLength);
            ExternalInterface.addCallback("globoGetAutoLevel", _getAutoLevel);
            ExternalInterface.addCallback("globoGetDroppedFrames", _getDroppedFrames);
            ExternalInterface.addCallback("globoRemoveLevel", _removeLevel);

            ExternalInterface.addCallback("globoPlayerLoad", _load);
            ExternalInterface.addCallback("globoPlayerPlay", _play);
            ExternalInterface.addCallback("globoPlayerPause", _pause);
            ExternalInterface.addCallback("globoPlayerResume", _resume);
            ExternalInterface.addCallback("globoPlayerSeek", _seek);
            ExternalInterface.addCallback("globoPlayerStop", _stop);
            ExternalInterface.addCallback("globoPlayerVolume", _volume);
            ExternalInterface.addCallback("globoPlayerSetLevel", _setLevel);
            ExternalInterface.addCallback("globoPlayerSmoothSetLevel", _smoothSetLevel);
            ExternalInterface.addCallback("globoPlayerSetflushLiveURLCache", _setflushLiveURLCache);

            setTimeout(_pingJavascript, 50);
        };

        override protected function _load(url : String) : void {
            _url = url;
            super._load(url);
        };

        override protected function _errorHandler(event : HLSEvent) : void {
            if (event.error.code !== HLSError.FORBIDDEN || event.error.code !== HLSError.MANIFEST_LOADING_CROSSDOMAIN_ERROR) {
                CONFIG::LOGGING {
                Log.info("Error: " + event.error.code + " : " + event.error.url + " : " + event.error.msg);
                Log.info("Rebooting.");
                }
                _load(_url);
                _play();
            }
        };

        private function _getDroppedFrames() : int {
            return _hls.droppedFrames;
        };

        private function _removeLevel(pos:Number):void {
            _hls.removeLevel(pos);
        };
   }
}
