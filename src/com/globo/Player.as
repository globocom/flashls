package com.globo {

    import org.mangui.chromeless.ChromelessPlayer;

    import flash.display.*;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.geom.Rectangle;
    import flash.media.StageVideoAvailability;
    import flash.utils.setTimeout;

    public class Player extends ChromelessPlayer {

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

            // Connect calls to JS.
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
   }
}
