/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */
package net.arulraj.recorder.model {

public class VideoResolution {

  public static const _144p:VideoResolution = new VideoResolution(176, 144, "176x144", 0);

  public static const _240p:VideoResolution = new VideoResolution(320, 240, "320x240", 1);

  public static const _288p:VideoResolution = new VideoResolution(352, 288, "352x288", 2);

  public static const _400p:VideoResolution = new VideoResolution(640, 400, "640x400", 3);

  public static const _480p:VideoResolution = new VideoResolution(640, 480, "640x480", 4);

  public static const _720p:VideoResolution = new VideoResolution(960, 720, "960x720", 5);

  public static const _1280p:VideoResolution = new VideoResolution(1280, 720, "1280x720", 6);

  private var _height:int;

  private var _width:int;

  private var _display:String;

  private var _order:int;

  public function VideoResolution(width:int, height:int, display:String, order:int = 0) {
    this._width = width;
    this._height = height;
    this._display = display;
    this._order = order;
  }

  public function get height():int {
    return _height;
  }

  public function set height(value:int):void {
    _height = value;
  }

  public function get width():int {
    return _width;
  }

  public function set width(value:int):void {
    _width = value;
  }

  public function get display():String {
    return _display;
  }

  public function set display(value:String):void {
    _display = value;
  }

  public function get order():int {
    return _order;
  }

  public function set order(value:int):void {
    _order = value;
  }

  public function toString():String {
    return "VideoResolution{_height=" + String(_height) + ",_width=" + String(_width) + ",_display=" + String(_display) + ",_order=" + String(_order) + "}";
  }
}
}
