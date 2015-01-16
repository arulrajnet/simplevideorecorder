/**
 * Created by arul on 5/10/2014.
 */
package net.arulraj.recorder.model {
import mx.utils.StringUtil;

public class ServerConf {

  public static const RED5_SERVER:String="23.252.252.82";
  public static const RED5_APP:String = "vod";

  private static const RTMP_PORT:int=1935;
  private static const HTTP_PORT:int=5080;

  public static const RED5_DEFAULT_STREAM_NAME:String = "sample";

  public static var RECORDED_FILE_PREFIX:String = "int";

  private static var isProduction:Boolean = true;

  [Bindable]
  private static var _rtmpUrl:String = buildRtmpUrl();

  [Bindable]
  private static var _streamName:String = RED5_DEFAULT_STREAM_NAME;

  public function ServerConf() {

  }

  private static function buildRtmpUrl():String {
      if(isProduction) {
          return "rtmp://" + RED5_SERVER + ":" + RTMP_PORT + "/" + RED5_APP;
      } else {
          return "rtmp://localhost:1935/live";
      }
  }

  private static function buildStreamName():String {
    var date:Date = new Date();
    var unixTime:Number = Math.round(date.getTime());
    return StringUtil.substitute("{0}{1}S", RECORDED_FILE_PREFIX, unixTime);
  }

  [Bindable]
  public static function get rtmpUrl():String {
      return _rtmpUrl;
  }

  public static function set rtmpUrl(url:String):void {
      _rtmpUrl = url;
  }

  [Bindable]
  public static function get streamName():String {
      return buildStreamName();
  }

  public static function set streamName(value:String):void {
      _streamName = value;
  }

  public static function getHttpUrl():String {
      return "http://"+RED5_SERVER+":"+HTTP_PORT+"/"+RED5_APP;
  }

}
}
