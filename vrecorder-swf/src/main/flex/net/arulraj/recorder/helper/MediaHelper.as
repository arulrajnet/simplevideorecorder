/**
 * Created by arul on 5/10/2014.
 */
package net.arulraj.recorder.helper {
import net.arulraj.recorder.model.AudioCodec;
import net.arulraj.recorder.model.AudioOptions;
import net.arulraj.recorder.model.SampleRate;
import net.arulraj.recorder.model.VideoOptions;
import net.arulraj.recorder.model.VideoResolution;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.media.Camera;
import flash.media.Microphone;
import flash.media.MicrophoneEnhancedMode;
import flash.media.MicrophoneEnhancedOptions;

import mx.events.PropertyChangeEvent;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.utils.ObjectUtil;

public class MediaHelper extends  EventDispatcher {

    private var LOG:ILogger = Log.getLogger("net.arulraj.recorder.helper.VideoHelper");

    public static const EVENT_CAMERA_STARTED:String = "CameraStarted";

    private static var _instance:MediaHelper = new MediaHelper();

    [Bindable]
    public var videoOption:VideoOptions = VideoOptions.DEFAULT;

    [Bindable]
    public var audioOption:AudioOptions = AudioOptions.DEFAULT;

    [Bindable]
    public var serverHelper:ServerHelper = ServerHelper.instance;

    [Bindable]
    public var microphone:Microphone;

    [Bindable]
    public var camera:Camera;

    [Bindable]
    public var lastMicGain:Number = 50;

    public static function get instance():MediaHelper {
        return _instance;
    }

    public function MediaHelper() {
        if (_instance != null) {
            throw new Error("VideoHelper is Singleton Class. So use VideoHelper.instance.")
        }
    }

    public function startup():void {
        LOG.debug("Startup...");
        setCamera();
        setMicrophone();

        videoOption.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, refreshMedia);
        audioOption.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, refreshMedia);
        if (camera) {
            dispatchEvent(new Event(EVENT_CAMERA_STARTED, true, false))
        }
        LOG.debug("Camera : "+ObjectUtil.toString(camera));
        LOG.debug("Microphone : "+ObjectUtil.toString(microphone));
    }

    public function refreshMedia(event:PropertyChangeEvent = null):void {
        LOG.debug("On Refresh Media...");
        LOG.debug(event.property.toString());
        if (serverHelper.getOutgoingStream()) {

            if (videoOption.enableVideo) {
              if (event.property.toString() == "enableVideo") {
                serverHelper.getOutgoingStream().attachCamera(camera);
              }
            } else {
              serverHelper.getOutgoingStream().attachCamera(null);
            }

            if (audioOption.enableAudio) {
              if (event.property.toString() == "enableAudio") {
                serverHelper.getOutgoingStream().attachAudio(microphone);
              }
            } else {
              serverHelper.getOutgoingStream().attachAudio(null);
            }
        }
        refreshQuality();
        LOG.debug("Camera : "+ObjectUtil.toString(camera));
        LOG.debug("Microphone : "+ObjectUtil.toString(microphone));
        LOG.debug("Video Option : "+videoOption.toString());
        LOG.debug("Audio Option : "+audioOption.toString());
    }

    /**
     * ===============================================
     *
     * CAMERA
     *
     * ===============================================
     */
    public function checkIsCurrentCamera(name:String) : Boolean{
        return camera && camera.name == name;
    }

    public function setCamera(name:String=null) : void{

        camera = Camera.getCamera(name);
        videoOption.selectedCam = camera.index;

        if (!camera || checkNoCam()){
            setNoCam(true);
            return;
        }

        setNoCam(false);

        //check for camera muted
        setCameraMuted(camera.muted);

        if (!camera.hasEventListener(StatusEvent.STATUS))
            camera.addEventListener(StatusEvent.STATUS,onCameraSatusChanged);

        //refresh
        initializeCurrentCamera();
        refreshOutStreamCamera();
    }

    private function onCurrentUserEnterConference(event:Event):void{
        checkCameraMuted();
        checkNoCam();
    }
    private function checkCameraMuted():void{
        if (!camera) return;

        setCameraMuted(camera.muted);

        if (!camera.hasEventListener(StatusEvent.STATUS))
            camera.addEventListener(StatusEvent.STATUS,onCameraSatusChanged);
    }

    private function checkNoCam():void{
        if (!camera || !Camera.isSupported || Camera.names.length == 0)
            setNoCam(true);
        else setNoCam(false);
    }

    private function onCameraSatusChanged(event:StatusEvent):void{
        if (event.code == "Camera.Unmuted") {
            setCameraMuted(false);
        }else if (event.code == "Camera.Muted") {
            setCameraMuted(true);
        }
    }
    private function setCameraMuted(value:Boolean):void{
    }

    private function setNoCam(value:Boolean):void{
    }

    private function initializeCurrentCamera() : void{
        if (camera == null) return;
        var resolution:VideoResolution = videoOption.resolutionList.getItemAt(videoOption.selectedResolution) as VideoResolution;
        camera.setQuality( 0, 75);
        camera.setMode( resolution.width, resolution.height, new Number(videoOption.frameRateList.getItemAt(videoOption.selectedFrameRate).toString()), true );
        camera.setKeyFrameInterval(videoOption.keyFrameInterval);
        camera.setLoopback( false );
    }

    /**
     * ===============================================
     *
     * MICROPHONE
     *
     * ===============================================
     */
    public function changeMicGain(value:Number) : void{
        lastMicGain = value;

        if (microphone) microphone.gain = value;
    }

    public function checkIsCurrentMicrophone(index:Number) : Boolean{
        return microphone && microphone.index == index;
    }

    public function setMicrophone(index:int=-1) : void{
        microphone = Microphone.getEnhancedMicrophone(index);

        if (microphone==null) {
            microphone = Microphone.getMicrophone();
            audioOption.selectedMic = microphone.index;
            if (microphone == null) return;
            microphone.setUseEchoSuppression(true);
        }	else {
            microphone.enhancedOptions = getEnhMicOptions();
            microphone.setUseEchoSuppression(false);
        }

        initializeCurrentMicrophone();
        refreshOutStreamMicrophone();
    }

    private function initializeCurrentMicrophone() : void{
        if (microphone == null) return;
        microphone.codec = (audioOption.formatsList.getItemAt(audioOption.selectedFormat) as AudioCodec).codec;
        microphone.rate = (audioOption.sampleRateList.getItemAt(audioOption.selectedSampleRate) as SampleRate).rate;
        microphone.framesPerPacket = 2;
        microphone.encodeQuality = 8;
        microphone.setSilenceLevel(0,2000);
        if(videoOption.isBroadcasting) {
          microphone.setLoopBack(false);
        } else {
          // Loop Back to true to detect Mic activity
          microphone.setLoopBack(true);
        }
        microphone.gain = lastMicGain;
    }

    private function getEnhMicOptions():MicrophoneEnhancedOptions {
        var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
        options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;

        options.echoPath = 128; //128 or 256(better)
        options.nonLinearProcessing = true;

        options.autoGain = true;
        return options;
    }

    /**
     * =============================================
     *  REFRESH
     * =============================================
     */
    private function refreshQuality():void {
        if (!checkIsCurrentCamera(videoOption.cameraList.getItemAt(videoOption.selectedCam).toString())) {
            setCamera(videoOption.selectedCam.toString());
        } else {
          /**
           * TODO: This is not needed since we don't have option to change camera at runtime.
           */
//            initializeCurrentCamera();
            refreshOutStreamCamera();
        }

        if(!checkIsCurrentMicrophone(audioOption.selectedMic)) {
            setMicrophone(audioOption.selectedMic);
        } else {
            initializeCurrentMicrophone();
            refreshOutStreamMicrophone();
        }
    }

    private function refreshOutStreamCamera():void {
        if(!camera) {
            return;
        }
        ServerHelper.instance.refreshCamera(camera);

        if(ComponentHelper.instance.main) {
          ComponentHelper.instance.main.refreshCamera();
        }
    }

    private function refreshOutStreamMicrophone():void {
        if(!microphone) {
            return;
        }
        ServerHelper.instance.refreshMicrophone(microphone);
    }
}
}
