/**
 * Created by arul on 5/9/2014.
 */
package net.arulraj.recorder.model {
import flash.net.NetConnection;
import flash.net.NetStream;

public class ConnectionModel {

    private static var _instance:ConnectionModel = new ConnectionModel();;

    public static const CONNECT_SUCCESSFUL:String = "ConnectionModel::connectSuccessful";
    public static const CONNECT_FAILED:String = "ConnectionModel::connectFailed";

    public var netConnection:NetConnection;
    public var outgoingStream:NetStream;
    public var incomingStream:NetStream;
    public var connected:Boolean;

    function ConnectionModel() {
        if(_instance != null) {
            throw new Error("ConnectionModel is Singleton Class. So use ConnectionModel.instance.")
        }
    }

    public static function get instance():ConnectionModel {
        return _instance;
    }

}
}