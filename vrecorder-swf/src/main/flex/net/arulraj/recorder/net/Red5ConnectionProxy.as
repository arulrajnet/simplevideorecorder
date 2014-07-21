/**
 * Created by arul on 5/10/2014.
 */
package net.arulraj.recorder.net {
import net.arulraj.recorder.model.ServerConf;

import flash.events.NetStatusEvent;
import flash.media.H264Level;
import flash.media.H264Profile;
import flash.media.H264VideoStreamSettings;

import flash.net.NetStream;

import mx.logging.ILogger;

import mx.logging.Log;

import net.arulraj.recorder.model.VideoOptions;

public class Red5ConnectionProxy extends AbstractConnectionProxy implements IConnectionProxy{

    private var LOG:ILogger = Log.getLogger("net.arulraj.recorder.net.Red5ConnectionProxy");

    private var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();

    public function Red5ConnectionProxy() {
        super();
        h264Settings.setProfileLevel( H264Profile.BASELINE, H264Level.LEVEL_3_1 )
    }

    public function connect():void{
        model.netConnection.connect(ServerConf.rtmpUrl);
    }

    public function initIncomingStream( streamName : String ):NetStream{
        if (!model.netConnection.connected) {
            return null;
        }
        model.incomingStream= new NetStream(model.netConnection);
        model.incomingStream.addEventListener(NetStatusEvent.NET_STATUS, incomingStreamHandler);
        model.incomingStream.play(streamName);

        model.incomingStream.client = this;
        return model.incomingStream;
    }

    public function initOutgoingStream(streamName : String):NetStream{
        if (!model.netConnection.connected) {
            return null;
        }

        model.outgoingStream= new NetStream(model.netConnection);
        model.outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, outgoingStreamHandler);
        model.outgoingStream.videoStreamSettings = h264Settings;
        if(VideoOptions.DEFAULT.enableVideoRecord){
          model.outgoingStream.bufferTime = 60;
          model.outgoingStream.publish(streamName, "record");
        } else {
          model.outgoingStream.bufferTime = 1;
          model.outgoingStream.publish(streamName, "live");
        }

        model.outgoingStream.client = this;
        return model.outgoingStream;
    }
}
}
