library server_channel;

import "package:js/js.dart";
import 'package:js_interop_issue/channel/channel.dart' as AppEngineChan;
import 'package:logging/logging.dart';

/// Interface class to the server
abstract class ServerChannel {
  /// Connect to the specified room
  AppEngineChan.Socket connect(String token, Function open, Function close);
}

class AppEngineServerChannel extends ServerChannel {

  void _onMessage(AppEngineChan.Message message) {
    Logger.root.info("$message");
  }

  void _onError(AppEngineChan.Error err) {
    Logger.root.info("$err");
  }

  AppEngineChan.Socket connect(String token, Function open, Function close) {
    Logger.root.info("creating channel");
    var chan = new AppEngineChan.Channel(token);
    Logger.root.info("opening channel socket");
    var socket = chan.open();
    Logger.root.info("Setting handlers to socket");
    if (open != null) {
      socket.onopen = allowInterop(open);
    }
    if (close != null) {
      socket.onclose = allowInterop(close);
    }
    socket.onerror = allowInterop(_onError);
    socket.onmessage = allowInterop(_onMessage);
    return socket;
  }
}
