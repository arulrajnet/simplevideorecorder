/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */
package net.arulraj.recorder.model {
import mx.collections.ArrayCollection;

public class ResolutionCollection extends ArrayCollection{
  public function ResolutionCollection() {
    addItemAt(VideoResolution._144p, VideoResolution._144p.order);
    addItemAt(VideoResolution._240p, VideoResolution._240p.order);
    addItemAt(VideoResolution._288p, VideoResolution._288p.order);
    addItemAt(VideoResolution._400p, VideoResolution._400p.order);
    addItemAt(VideoResolution._480p, VideoResolution._480p.order);
    addItemAt(VideoResolution._720p, VideoResolution._720p.order);
    addItemAt(VideoResolution._1280p, VideoResolution._1280p.order);
  }
}
}
