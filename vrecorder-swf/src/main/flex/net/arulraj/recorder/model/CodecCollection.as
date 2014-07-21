/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */

package net.arulraj.recorder.model {

import mx.collections.ArrayCollection;

public class CodecCollection extends ArrayCollection{

  public function CodecCollection() {
    addItemAt(AudioCodec.MP3, AudioCodec.MP3.order);
    addItemAt(AudioCodec.NELLYMOSER, AudioCodec.NELLYMOSER.order);
  }

}
}