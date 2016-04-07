library server_channel;

import "dart:async";
import "dart:html";
import "package:js/js.dart";
import 'package:js_interop_issue/channel/channel.dart' as AppEngineChan;
import 'package:logging/logging.dart';

/// Interface class to the server
abstract class ServerChannel {
  /// Connect to the specified room
  Future<AppEngineChan.Socket> connect(Function open, Function close);
}

class AppEngineServerChannel extends ServerChannel {

  void _onMessage(AppEngineChan.Message message) {
    Logger.root.info("$message");
  }

  void _onError(AppEngineChan.Error err) {
    Logger.root.info("$err");
  }

  Future<AppEngineChan.Socket> connect(Function open, Function close) async {
    Logger.root.info("getting token");
    var url = "http://localhost:8080/api/client";
    try {
      var r = await HttpRequest.request(url, method:"POST");
      if (r.readyState == HttpRequest.DONE && r.status == 200) {
        // completed normally
        var token = r.responseText;
        Logger.root.info("creating channel with token: $token");
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
    } catch (error) {
      throw error;
    }
    return null;
  }
}
