/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */
package net.arulraj.recorder.model {
import flash.media.SoundCodec;

public class AudioCodec {

  public static const MP3:AudioCodec = new AudioCodec(SoundCodec.SPEEX, "Mp3", 0);
  public static const NELLYMOSER:AudioCodec = new AudioCodec(SoundCodec.NELLYMOSER, "NellyMoser", 1);

  private var _codec:String;

  private var _display:String;

  private var _order:int;

  public function AudioCodec(codec:String, display:String, order:int) {
    this._codec = codec;
    this._display = display;
    this._order = order;
  }

  public function get codec():String {
    return _codec;
  }

  public function set codec(value:String):void {
    _codec = value;
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
    return "AudioCodec{codec=" + String(_codec) + ",display=" + String(_display) + ",order=" + String(_order) + "}";
  }
}
}
