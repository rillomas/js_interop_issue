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
    try {
      await HttpRequest.request("", method:"POST");
    } catch (e) {
      print("Pulse heartbeat failed: ${e}");
    }
  }

  /// Connect to server
  Future<AppEngineChan.Socket> connect(int roomId) async {
    // connect to the server via channel api
    print("creating channel");
    var chan = new AppEngineChan.Channel("");
    print("opening channel socket");
    var socket = chan.open();
    print("opened channel socket");
    return socket;
  }

  static const HEARTBEAT_INTERVAL = const Duration(seconds: 5);

  Timer _heartbeater;
}

main() async {
  var i = new Initializer();
  i.init();
}