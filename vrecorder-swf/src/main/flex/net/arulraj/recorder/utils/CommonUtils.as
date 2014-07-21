/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */
package net.arulraj.recorder.utils {
public class CommonUtils {
  public function CommonUtils() {
  }

  public static function zeroPad(number:int, width:int):String {
    var ret:String = ""+number;
    while( ret.length < width )
      ret="0" + ret;
    return ret;
  }

  public static function numberToTimeString(number:int):String {
    var min:int = Math.floor(number / 60);
    var sec:int = number % 60;
    return zeroPad(min,2)+":"+zeroPad(sec,2);
  }

}
}
