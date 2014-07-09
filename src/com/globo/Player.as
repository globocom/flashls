package com.globo {
    import flash.net.URLStream;

    import org.mangui.chromeless.ChromelessPlayer;
    import org.mangui.hls.model.Level;
    import org.mangui.hls.*;
    import org.mangui.hls.utils.*;

    import flash.display.*;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.geom.Rectangle;
    import flash.media.Video;
    import flash.media.SoundTransform;
    import flash.media.StageVideo;
    import flash.media.StageVideoAvailability;
    import flash.utils.setTimeout;

    public class Player extends ChromelessPlayer {
        public function Player() {
            // Set stage properties
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.fullScreenSourceRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, _onStageVideoState);
            stage.addEventListener(Event.RESIZE, _onStageResize);
            // Draw sheet for catching clicks
            _sheet = new Sprite();
            _sheet.graphics.beginFill(0x000000, 0);
            _sheet.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            _sheet.addEventListener(MouseEvent.CLICK, _clickHandler);
            _sheet.buttonMode = true;
            addChild(_sheet);
            // Connect getters to JS.
            ExternalInterface.addCallback("getLevel", _getLevel);
            ExternalInterface.addCallback("getLevels", _getLevels);
            ExternalInterface.addCallback("getAutoLevel", _getAutoLevel);
            ExternalInterface.addCallback("getMetrics", _getMetrics);
            ExternalInterface.addCallback("getDuration", _getDuration);
            ExternalInterface.addCallback("getPosition", _getPosition);
            ExternalInterface.addCallback("getPlaybackState", _getPlaybackState);
            ExternalInterface.addCallback("getSeekState", _getSeekState);
            ExternalInterface.addCallback("getType", _getType);
            ExternalInterface.addCallback("getmaxBufferLength", _getmaxBufferLength);
            ExternalInterface.addCallback("getminBufferLength", _getminBufferLength);
            ExternalInterface.addCallback("getlowBufferLength", _getlowBufferLength);
            ExternalInterface.addCallback("getbufferLength", _getbufferLength);
            ExternalInterface.addCallback("getLogDebug", _getLogDebug);
            ExternalInterface.addCallback("getLogDebug2", _getLogDebug2);
            ExternalInterface.addCallback("getCapLeveltoStage", _getCapLeveltoStage);
            ExternalInterface.addCallback("getflushLiveURLCache", _getflushLiveURLCache);
            ExternalInterface.addCallback("getstartFromLevel", _getstartFromLevel);
            ExternalInterface.addCallback("getseekFromLowestLevel", _getseekFromLevel);
            ExternalInterface.addCallback("getJSURLStream", _getJSURLStream);
            ExternalInterface.addCallback("getPlayerVersion", _getPlayerVersion);
            ExternalInterface.addCallback("getAudioTrackList", _getAudioTrackList);
            ExternalInterface.addCallback("getAudioTrackId", _getAudioTrackId);
            // Connect calls to JS.
            ExternalInterface.addCallback("playerLoad", _load);
            ExternalInterface.addCallback("playerPlay", _play);
            ExternalInterface.addCallback("playerPause", _pause);
            ExternalInterface.addCallback("playerResume", _resume);
            ExternalInterface.addCallback("playerSeek", _seek);
            ExternalInterface.addCallback("playerStop", _stop);
            ExternalInterface.addCallback("playerVolume", _volume);
            ExternalInterface.addCallback("playerSetLevel", _setLevel);
            ExternalInterface.addCallback("playerSmoothSetLevel", _smoothSetLevel);
            ExternalInterface.addCallback("playerSetmaxBufferLength", _setmaxBufferLength);
            ExternalInterface.addCallback("playerSetminBufferLength", _setminBufferLength);
            ExternalInterface.addCallback("playerSetlowBufferLength", _setlowBufferLength);
            ExternalInterface.addCallback("playerSetflushLiveURLCache", _setflushLiveURLCache);
            ExternalInterface.addCallback("playerSetstartFromLevel", _setstartFromLevel);
            ExternalInterface.addCallback("playerSetseekFromLevel", _setseekFromLevel);
            ExternalInterface.addCallback("playerSetLogDebug", _setLogDebug);
            ExternalInterface.addCallback("playerSetLogDebug2", _setLogDebug2);
            ExternalInterface.addCallback("playerCapLeveltoStage", _setCapLeveltoStage);
            ExternalInterface.addCallback("playerSetAudioTrack", _setAudioTrack);
            ExternalInterface.addCallback("playerSetJSURLStream", _setJSURLStream);

            setTimeout(_pingJavascript, 50);
        };
   }
}
