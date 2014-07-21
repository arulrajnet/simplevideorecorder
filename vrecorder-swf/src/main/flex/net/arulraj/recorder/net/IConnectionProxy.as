/**
 * Created by arul on 5/10/2014.
 */
package net.arulraj.recorder.net {
import flash.events.IEventDispatcher;
import flash.net.NetStream;

public interface IConnectionProxy extends IEventDispatcher {
    function connect():void;
    function getNetConnectionId():String;

    function shutdown():void;
    function initOutgoingStream (streamName:String):NetStream;
    function getOutgoingStream():NetStream;
    function getIncomingStream():NetStream;
}
}
