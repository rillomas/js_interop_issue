import 'dart:async';
import 'package:logging/logging.dart';
import 'package:js_interop/services/services.dart';

class Initializer {
  void init() {
    _channel = new AppEngineServerChannel();
    _connectToServer();
  }

  _connectToServer() async {
    Logger.root.info("Sending connect request");
    var onOpen = () => Logger.root.info("channel opened");
    var onClose = () => Logger.root.info("channel closed");
    try {
      var socket = await _channel.connect(0, onOpen: onOpen, onClose: onClose);
      Logger.root.info("Received channel: ${socket}");

      _channel.listen(_onMessage, _onError);
      Logger.root.info("Client Ready");
      // enqueue periodic heartbeat
      _heartbeater = new Timer.periodic(HEARTBEAT_INTERVAL, _pulseHeartbeat);
    } catch (e) {
      Logger.root.warning("server connect failed: ${e}");
    }

 }

  _pulseHeartbeat(Timer t) async {
    try {
      await _channel.sendHeartbeat(0, 0, "");
    } catch (e) {
      Logger.root.warning("send heartbeat failed: ${e}");
    }
  }

  /// Handler for Channel messages
  void _onMessage(String message) {
    Logger.root.info("onmessage at channel: ${message}");
  }

  /// Handler for Channel errors
  void _onError(var error) {
    Logger.root.info("Channel received error: $error");
  }

  static const HEARTBEAT_INTERVAL = const Duration(minutes: 3);

  AppEngineServerChannel _channel;
  Timer _heartbeater;
}

main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((log) {
    print(log);
  });
  var i = new Initializer();
  i.init();
}