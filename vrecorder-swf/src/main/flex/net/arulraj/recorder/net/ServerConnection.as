/**
 * Created by arul on 5/9/2014.
 */
package net.arulraj.recorder.net {
import flash.events.AsyncErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.net.NetConnection;

import mx.logging.ILogger;

import mx.logging.Log;

[Event(name="connectResult",    type="flash.events.NetStatusEvent")]
[Event(name="connectFail",      type="flash.events.NetStatusEvent")]
[Event(name="disconnectResult", type="flash.events.NetStatusEvent")]
public class ServerConnection extends NetConnection{
    private static var LOG:ILogger = Log.getLogger("net.arulraj.recorder.net.ServerConnectionClient");

    static public const NOT_CONNECTED:Number = 0;
    static public const CONNECTING:Number = 1;
    static public const CONNECTED:Number = 2;

    [Bindable]
    static public var currentState:int = NOT_CONNECTED;

    public function ServerConnection() {
        super();
        this.client = new ServerConnectionClient();
        this.objectEncoding = flash.net.ObjectEncoding.AMF3;

        addEventListener(NetStatusEvent.NET_STATUS, handleConnectionStatusEvent);
        addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
        addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncError);
        addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
    }

    override public function connect(command:String, ... rest):void {
        rest.unshift(command);
        currentState = CONNECTING;
        super.connect.apply(this, rest);
    }

    override public function close():void {
        currentState = NOT_CONNECTED;
        super.close();
    }

    protected function handleConnectionStatusEvent(event:NetStatusEvent):void {
        var codeTokens:Array = event.info.code.split(".");
        if (codeTokens[1] == "Connect"){
            switch (codeTokens[2]){
                case "Success":
                    currentState = CONNECTED;
                    dispatchEvent(new NetStatusEvent("connectResult", false, false, event.info));
                    break;
                case "Failed":
                    dispatchEvent(new NetStatusEvent("connectFail", false, false, event.info));
                    currentState = NOT_CONNECTED;
                    break;

                case "Closed":
                    if(currentState == CONNECTED){
                        dispatchEvent(new NetStatusEvent("disconnectResult", false, false, event.info));
                        currentState = NOT_CONNECTED;
                    }
                    break;
            }
        }
    }

    protected function handleSecurityError(event:SecurityErrorEvent):void {
    }

    protected function handleAsyncError(event:AsyncErrorEvent):void {
    }

    protected function handleIOError(event:IOErrorEvent):void {
    }

}
}
