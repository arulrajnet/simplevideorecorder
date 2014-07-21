/**
 * Created by arul on 5/9/2014.
 */
package net.arulraj.recorder.model {
import flash.media.Microphone;

import mx.collections.ArrayCollection;

import mx.collections.ArrayCollection;

[Bindable]
public class AudioOptions extends Options{

    public static var DEFAULT:AudioOptions = new AudioOptions();

    private var channels:Array = new Array("Mono","Stereo");

    private var bitRate:Array = new Array("128","112","96","48","40","32");

    public var formatsList:ArrayCollection = new CodecCollection();

    public var microphonesList:ArrayCollection = new ArrayCollection(Microphone.names);

    public var channelsList:ArrayCollection = new ArrayCollection(channels);

    public var sampleRateList:ArrayCollection = SampleRate.names();

    public var bitRateList:ArrayCollection = new ArrayCollection(bitRate);

    public var micVolume:int = 75;

    public var selectedMic:int = -1;

    public var selectedFormat:int = AudioCodec.MP3.order;

    public var selectedChannels:int = 0;

    public var selectedSampleRate:int = SampleRate._22KHZ.order;

    public var selectedBitRate:int = 0;

    public var enableAudio:Boolean = true;

    public function AudioOptions() {
      super ();
    }

    public function toString():String {
      return "AudioOptions{channels=" + String(channels) + ",bitRate=" + String(bitRate) + ",formatsList=" + String(formatsList) + ",microphonesList=" + String(microphonesList) + ",channelsList=" + String(channelsList) + ",sampleRateList=" + String(sampleRateList) + ",bitRateList=" + String(bitRateList) + ",micVolume=" + String(micVolume) + ",selectedMic=" + String(selectedMic) + ",selectedFormat=" + String(selectedFormat) + ",selectedChannels=" + String(selectedChannels) + ",selectedSampleRate=" + String(selectedSampleRate) + ",selectedBitRate=" + String(selectedBitRate) + ",enableAudio=" + String(enableAudio) + "}";
    }
}
}
