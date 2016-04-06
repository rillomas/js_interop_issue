// Wrapper library for appengine channels
@JS("goog.appengine")
library channel;

import "package:js/js.dart";

@JS("Socket")
class Socket {
  external close();
  external Function get onopen;
  external Function get onmessage;
  external Function get onerror;
  external Function get onclose;
  external void set onopen(Function f);
  external void set onmessage(Function f);
  external void set onerror(Function f);
  external void set onclose(Function f);
}

@JS("Channel")
class Channel {
  external Channel(String token);
  external Socket open();
}

@JS()
@anonymous
class Message {
  external String get data;
}

@JS()
@anonymous
class Error {
  external String get description;
  external int get code;
}
