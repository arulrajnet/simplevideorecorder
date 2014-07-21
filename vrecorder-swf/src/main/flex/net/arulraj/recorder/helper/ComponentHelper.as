/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */
package net.arulraj.recorder.helper {
import flash.utils.Timer;

import mx.core.Application;
import mx.core.FlexGlobals;
import mx.core.UIComponent;

public class ComponentHelper {

  private static var _instance:ComponentHelper = new ComponentHelper();

  public static function get instance():ComponentHelper {
    return _instance;
  }

  public function ComponentHelper() {
    if(_instance != null) {
      throw new Error("ComponentHelper is Singleton Class. So use VideoHelper.instance.")
    }
  }

  public function get main():video_recorder {
    var dObject:Object = FlexGlobals.topLevelApplication;
    return dObject as video_recorder;
  }

  public function get commonTimer():Timer {
    var dObject:Timer = FlexGlobals.topLevelApplication.commonTimer;
    return dObject;
  }

}
}
