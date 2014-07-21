/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */
package net.arulraj.recorder.model {
import flash.events.Event;

public class CamcorderEvent extends Event{

  public static const EVENT_CONNECTED:String = "Connected";
  public static const EVENT_DISCONNECTED:String = "Disconnected";
  public static const EVENT_PUBLISH_STARTED:String = "PublishStarted";
  public static const EVENT_PUBLISH_STOPPED:String = "PublishStopped";
  public static const EVENT_PLAY_STARTED:String = "PlayStarted";
  public static const EVENT_PLAY_STOPPED:String = "PlayStopped";
  public static const EVENT_PLAY_COMPLETED:String = "PlayCompleted";

  public static const EVENT_ASYNC_ERROR:String = "AsyncError";

  public function CamcorderEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) {
    super(type, bubbles, cancelable);
  }
}
}
