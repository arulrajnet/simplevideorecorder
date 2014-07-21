/**
 * Created by arul on 5/10/2014.
 */
package net.arulraj.recorder.net {
import net.arulraj.recorder.model.CamcorderEvent;
import net.arulraj.recorder.model.ConnectionModel;

import flash.events.AsyncErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.NetStatusEvent;
import flash.net.NetConnection;
import flash.net.NetStream;

import mx.logging.ILogger;

import mx.logging.Log;

public class AbstractConnectionProxy extends EventDispatcher{

    private var LOG:ILogger = Log.getLogger("net.arulraj.recorder.net.AbstractConnectionProxy");

    protected var model:ConnectionModel;

    public function AbstractConnectionProxy() {
        model = ConnectionModel.instance;

        model.netConnection = new NetConnection();
//        model.netConnection.objectEncoding = flash.net.ObjectEncoding.AMF3;
        model.netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
        model.netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, ayncErrorHandler);
        model.netConnection.client = new ServerConnectionClient();
    }

    private function netConnectionHandler(event:NetStatusEvent):void {
        LOG.debug("netConnectionHandler : "+event.info.code);
        switch (event.info.code) {
            case "NetConnection.Connect.Success":
                dispatchEvent(new Event(CamcorderEvent.EVENT_CONNECTED));
                break;

            case "NetStream.Connect.Closed":
            case "NetConnection.Connect.Closed":
            case "NetConnection.Connect.Failed":
                dispatchEvent(new Event(CamcorderEvent.EVENT_DISCONNECTED));
                break;
        }
    }

    protected function incomingStreamHandler(event:NetStatusEvent):void {
        LOG.debug("incomingStreamHandler : "+event.info.code);
        switch (event.info.code) {
            case "NetStream.Play.Start":
                dispatchEvent(new Event(CamcorderEvent.EVENT_PLAY_STARTED));
                break;

            case "NetStream.Play.Stop":
            case "NetStream.Play.UnpublishNotify":
            case "NetStream.Failed":
            case "NetStream.Play.Failed":
                dispatchEvent(new Event(CamcorderEvent.EVENT_PLAY_STOPPED));
                break;
        }
    }

    protected function outgoingStreamHandler(event:NetStatusEvent):void {
        LOG.debug("outgoingStreamHandler : "+event.info.code);
        switch (event.info.code) {
            case "NetStream.Publish.Start":
                dispatchEvent(new Event(CamcorderEvent.EVENT_PUBLISH_STARTED));
                break;
            case "NetStream.Publish.Stop":
            case "NetStream.Failed":
            case "NetStream.Unpublish.Success":
            case "NetStream.Publish.Failed":
                dispatchEvent(new Event(CamcorderEvent.EVENT_PUBLISH_STOPPED));
                break;
        }
    }

    public function onMetaData(infoObject:Object):void {
    }
    public function onCuePoint(infoObject:Object):void {
    }


    public function onPeerConnect (caller:NetStream):Boolean{
        return true;
    }


    public function getIncomingStream():NetStream {
        return model.incomingStream;
    }

    public function getOutgoingStream():NetStream {
        return model.outgoingStream;
    }

    public function ayncErrorHandler(event: AsyncErrorEvent): void {
        dispatchEvent(new Event(CamcorderEvent.EVENT_ASYNC_ERROR));
    }

    public function getNetConnectionId():String {
        return "";
    }

    public function shutdown():void {
        if (model.netConnection) {
            model.netConnection.close();
            model.netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
        }

        if (model.incomingStream) {
            model.incomingStream.close();
            model.incomingStream = null;
        }

        if (model.outgoingStream) {
            model.outgoingStream.close();
            model.outgoingStream = null;
        }
    }
}
}
