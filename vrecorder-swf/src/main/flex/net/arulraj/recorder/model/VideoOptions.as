/**
 * Created by arul on 5/9/2014.
 */
package net.arulraj.recorder.model {
import flash.media.Camera;
import flash.media.Microphone;

import mx.collections.ArrayCollection;

import mx.collections.ArrayCollection;

import spark.components.List;

[Bindable]
public class VideoOptions extends Options{

    public static var DEFAULT:VideoOptions = new VideoOptions();

    private static const DEFAULT_CAM_KEY_FRAME_INTERVAL:int = 16;

    private var formats:Array = new Array("H.264", "VP6");

    private var frameRate:Array = new Array("60.00","59.94","30.00","29.97","25.00","20.00","15.00","14.98","12.00","10.00","8.00","6.00","5.00","4.00","1.00");

    private var bitRate:Array = new Array("100","200","350","500","650","800","950","1000", "1100", "1250", "1500", "2000", "2300", "2600", "3000");

    public var cameraList:ArrayCollection = new ArrayCollection(Camera.names);

    public var formatsList:ArrayCollection = new ArrayCollection(formats);

    public var frameRateList:ArrayCollection = new ArrayCollection(frameRate);

    public var bitRateList:ArrayCollection = new ArrayCollection(bitRate);

    public var resolutionList:ArrayCollection = new ResolutionCollection();

    public var selectedCam:int = -1;

    public var selectedFormat:int = 0;

    public var selectedFrameRate:int = 1;

    public var selectedBitRate:int = 2;

    public var selectedResolution:int = VideoResolution._400p.order;

    public var enableVideo:Boolean = true;

    public var enableVideoRecord:Boolean = true;

    public var enableAspectRatio:Boolean = true;

    public var keyFrameInterval:int = DEFAULT_CAM_KEY_FRAME_INTERVAL;

    public function VideoOptions() {
      super ();
    }

    public function toString():String {
      return "VideoOptions{formats=" + String(formats) + ",frameRate=" + String(frameRate) + ",bitRate=" + String(bitRate) + ",cameraList=" + String(cameraList) + ",formatsList=" + String(formatsList) + ",frameRateList=" + String(frameRateList) + ",bitRateList=" + String(bitRateList) + ",resolutionList=" + String(resolutionList) + ",selectedCam=" + String(selectedCam) + ",selectedFormat=" + String(selectedFormat) + ",selectedFrameRate=" + String(selectedFrameRate) + ",selectedBitRate=" + String(selectedBitRate) + ",selectedResolution=" + String(selectedResolution) + ",enableVideo=" + String(enableVideo) + ",enableVideoRecord=" + String(enableVideoRecord) + ",enableAspectRatio=" + String(enableAspectRatio) + ",keyFrameInterval=" + String(keyFrameInterval) + "}";
    }
}
}
