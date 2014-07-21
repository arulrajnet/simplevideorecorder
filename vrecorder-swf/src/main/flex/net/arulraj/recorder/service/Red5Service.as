/**
 * Created by arul on 5/9/2014.
 */
package net.arulraj.recorder.service {
import net.arulraj.recorder.model.ConnectionModel;
import net.arulraj.recorder.net.ServerConnection;

public class Red5Service {
    private var resultFunction:Function;
    private var connection:ServerConnection;

    public function Red5Service (resultFunction:Function,connection:ServerConnection):void{
        this.resultFunction = resultFunction;
        this.connection = connection != null ? connection : ServerConnection(ConnectionModel.instance.netConnection);
    }
}
}
