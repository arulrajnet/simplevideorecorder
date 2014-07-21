/**
 * Created by arul on 5/10/2014.
 */
package net.arulraj.recorder.helper {
import net.arulraj.recorder.model.CamcorderEvent;
import net.arulraj.recorder.net.IConnectionProxy;
import net.arulraj.recorder.net.Red5ConnectionProxy;

import flash.events.Event;

import flash.events.EventDispatcher;
import flash.media.Camera;
import flash.media.Microphone;
import flash.media.SoundTransform;
import flash.net.NetStream;

import mx.logging.ILogger;

import mx.logging.Log;

public class ServerHelper extends EventDispatcher{

    private var LOG:ILogger = Log.getLogger("net.arulraj.recorder.net.ServerHelper");

    private static var _instance:ServerHelper = new ServerHelper();

    private var red5ConnectionProxy:Red5ConnectionProxy = null;

    private var playStreamName:String;
    private var publishStreamName:String;
    private var autoConnection:Boolean = false;
    private var soundTransform:SoundTransform = new SoundTransform(0);

    public static function get instance():ServerHelper {
        return _instance;
    }

    public function ServerHelper() {
        if(_instance != null) {
            throw new Error("ServerHelper is Singleton Class. So use ServerHelper.instance.")
        }
    }

    public function isRed5Inited():Boolean {
        return red5ConnectionProxy != null;
    }

    /**
     * Base method to init
     * Set true if you need auto play/publish after connection
     * ( for user videos )
     * Set false if you are using it in recorder/ player
     */
    public function initRed5Connection(auto:Boolean):void {
        red5ConnectionProxy = new Red5ConnectionProxy();
        autoConnection = auto;

        prepareConnection(red5ConnectionProxy);
    }

    /**
     * We use this method to publish named stream
     * Set true if you need auto play/publish after connection
     * ( for user videos )
     * Set false if you are using it in recorder/ player
     */
    public function initRed5ConnectionForPublish(streamName:String,auto:Boolean):void {
        this.publishStreamName = streamName;
        initRed5Connection(auto);
    }

    public function getIncomingStream():NetStream {
        return red5ConnectionProxy ? red5ConnectionProxy.getIncomingStream() : null;
    }

    public function getOutgoingStream():NetStream {
        return red5ConnectionProxy ? red5ConnectionProxy.getOutgoingStream() : null;
    }

    public function getRed5Proxy():IConnectionProxy {
        return red5ConnectionProxy;
    }

    private function prepareConnection(proxy :IConnectionProxy):void {

        if (autoConnection){
            proxy.addEventListener(CamcorderEvent.EVENT_CONNECTED,onConnected);
            proxy.addEventListener(CamcorderEvent.EVENT_DISCONNECTED,onDisconnected);
        }
        proxy.connect();
    }

    private function onConnected(event:Event):void {
        var proxy:IConnectionProxy = event.target as IConnectionProxy;

        //remove on connected listener
        if (proxy.hasEventListener(CamcorderEvent.EVENT_CONNECTED)) {
            proxy.removeEventListener(CamcorderEvent.EVENT_CONNECTED, onConnected);
        }
        initProxyPublish(proxy,publishStreamName);
    }

    private function initProxyPublish(proxy:IConnectionProxy,streamName:String):void {
        proxy.addEventListener(CamcorderEvent.EVENT_PUBLISH_STARTED,onPublishStarted);
        proxy.addEventListener(CamcorderEvent.EVENT_PUBLISH_STOPPED, onPublishStopped);
        proxy.initOutgoingStream(streamName);
    }

    private function onDisconnected(event:Event):void {
      var proxy:IConnectionProxy = event.target as IConnectionProxy;

      //remove on disconnected listener
      if (proxy.hasEventListener(CamcorderEvent.EVENT_DISCONNECTED))
          proxy.removeEventListener(CamcorderEvent.EVENT_DISCONNECTED,onDisconnected);
    }

    private function onPlayStarted(event:Event) :void {
      var proxy:IConnectionProxy = event.target as IConnectionProxy;
      proxy.getIncomingStream().soundTransform = soundTransform;
      dispatchEvent(new Event("playStarted"));
    }

    private function onPublishStarted(event:Event):void {
      LOG.debug("onPublishStarted : ");
      var proxy:IConnectionProxy = event.target as IConnectionProxy;
      proxy.removeEventListener(CamcorderEvent.EVENT_PUBLISH_STARTED,onPublishStarted);
      dispatchEvent(new Event(CamcorderEvent.EVENT_PUBLISH_STARTED));
    }

    private function onPublishStopped(event:Event):void {
      LOG.debug("onPublishStopped : ");
      var proxy:IConnectionProxy = event.target as IConnectionProxy;
      proxy.removeEventListener(CamcorderEvent.EVENT_PUBLISH_STOPPED,onPublishStopped);
      dispatchEvent(new Event(CamcorderEvent.EVENT_PUBLISH_STOPPED));
    }

    /**
     * ================================
     *
     * RED5 MANAGEMENT
     *
     * ================================
     */
    public function initRed5Play(streamName:String ):void {
        this.playStreamName = streamName;
        red5ConnectionProxy.addEventListener(CamcorderEvent.EVENT_PLAY_STARTED,onRed5ConnectionPlayStarted);
        red5ConnectionProxy.initIncomingStream(streamName);
    }

    public function initDefaultRed5PlayIfNeeded():void {
        if (playStreamName != null) initRed5Play(playStreamName);
    }


    public function deinitRed5Play():void {
        red5ConnectionProxy.removeEventListener(CamcorderEvent.EVENT_PLAY_STARTED,onRed5ConnectionPlayStarted);

        if (red5ConnectionProxy.getIncomingStream()) {
            red5ConnectionProxy.getIncomingStream().close();
        }
    }

    private function onRed5ConnectionPlayStarted(event:Event) :void {
        red5ConnectionProxy.removeEventListener(CamcorderEvent.EVENT_PLAY_STARTED,onRed5ConnectionPlayStarted);
        onPlayStarted(event);
    }


    public function initRed5Publish(streamName:String):void {
        this.publishStreamName = streamName;
        initProxyPublish(red5ConnectionProxy,streamName);
    }

    public function refreshConnection() :void {

        if (red5ConnectionProxy) {
            red5ConnectionProxy.shutdown();
            red5ConnectionProxy = null;
        }

        initRed5Connection(autoConnection);
    }

    public function shutdown() :void {

        if (red5ConnectionProxy) {
            red5ConnectionProxy.shutdown();
            red5ConnectionProxy = null;
        }

        playStreamName = null;
        publishStreamName = null;
        autoConnection = false;
    }

    /**
     * ===============================================
     *
     * REFRESH
     *
     * ===============================================
     */
    private function refreshSpeakerVolume() :void {
        if (red5ConnectionProxy && red5ConnectionProxy.getIncomingStream()){
            red5ConnectionProxy.getIncomingStream().soundTransform = soundTransform;
        }
    }

    public function refreshCamera(camera:Camera) :void {
        if (red5ConnectionProxy && red5ConnectionProxy.getOutgoingStream()){
            red5ConnectionProxy.getOutgoingStream().attachCamera(camera);
        }
    }

    public function refreshMicrophone(mic:Microphone) :void {
        if (red5ConnectionProxy && red5ConnectionProxy.getOutgoingStream()){
            red5ConnectionProxy.getOutgoingStream().attachAudio(null);
            red5ConnectionProxy.getOutgoingStream().attachAudio(mic);
        }
    }
}
}
