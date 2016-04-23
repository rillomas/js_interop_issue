// Wrapper library for appengine channels
@JS("goog.appengine")
library channel;

import "package:js/js.dart";

@JS("Socket")
class Socket {
}

@JS("Channel")
class Channel {
  external Channel(String token);
  external Socket open();
}
