/**
 * Created by arul on 5/9/2014.
 */
package net.arulraj.recorder.net {
import mx.logging.ILogger;
import mx.logging.Log;

public class ServerConnectionClient {

    private static var LOG:ILogger = Log.getLogger("net.arulraj.recorder.net.ServerConnectionClient");

    public function ServerConnectionClient() {
    }

    public function onBWCheck(...rest):Number
    {
        return 0;
    }

    public function onBWDone(...rest):void
    {
        var p_bw:Number;
        if (rest.length > 0){
            p_bw = rest[0];
        }
        LOG.debug("bandwidth = " + p_bw + " Kbps.");
    }
}
}
