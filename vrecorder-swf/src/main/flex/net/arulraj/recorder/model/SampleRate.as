/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */
package net.arulraj.recorder.model {
import mx.collections.ArrayCollection;

public class SampleRate {

  public static const _44KHZ:SampleRate = new SampleRate(44, "44kHz", 0);//44100 Hz

  public static const _22KHZ:SampleRate = new SampleRate(22, "22kHz", 1);//22050 Hz

  public static const _11KHZ:SampleRate = new SampleRate(11, "11kHz", 2);//11025 Hz

  public static const _8KHZ:SampleRate = new SampleRate(8, "8kHz", 3);//8000 Hz

  public static const _5KHZ:SampleRate = new SampleRate(5, "5kHz", 4);//5512 Hz

  private var _rate:int;

  private var _display:String;

  private var _order:int;

  public function SampleRate(rate:int, display:String, order:int) {
    this._rate = rate;
    this._display = display;
    this._order = order;
  }

  public static function names():ArrayCollection {
    var rates:ArrayCollection = new ArrayCollection();
    rates.addItemAt(_44KHZ, _44KHZ.order);
    rates.addItemAt(_22KHZ, _22KHZ.order);
    rates.addItemAt(_11KHZ, _11KHZ.order);
    rates.addItemAt(_8KHZ, _8KHZ.order);
    rates.addItemAt(_5KHZ, _5KHZ.order);
    return rates;
  }

  public function get rate():int {
    return _rate;
  }

  public function set rate(value:int):void {
    _rate = value;
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
}
}
