import 'dart:async';
import 'dart:html';
import 'package:js_interop/channel/channel.dart' as AppEngineChan;

class Initializer {
  init() async {
    print("Sending connect request");
    try {
      var socket = await connect(0);
      print("Received channel: ${socket}");

      print("Client Ready");
      // enqueue periodic heartbeat
      _heartbeater = new Timer.periodic(HEARTBEAT_INTERVAL, _pulseHeartbeat);
    } catch (e) {
      print("server connect failed: ${e}");
    }
  }

  _pulseHeartbeat(Timer t) async {
    await HttpRequest.request("", method:"POST");
  }

  /// Connect to server
  Future<AppEngineChan.Socket> connect(int roomId) async {
    var url = "http://localhost:8080/api/client";
    print("Requesting client from ${url}");
    var r = await HttpRequest.request(url, method:"POST");
    var res = r.responseText;
    // connect to the server via channel api
    print("creating channel");
    var chan = new AppEngineChan.Channel(res);
    print("opening channel socket");
    var socket = chan.open();
    print("opened channel socket");
    return socket;
  }

  static const HEARTBEAT_INTERVAL = const Duration(minutes: 3);

  Timer _heartbeater;
}

main() async {
  var i = new Initializer();
  i.init();
}