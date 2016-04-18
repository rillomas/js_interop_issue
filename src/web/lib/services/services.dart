library services;

import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'package:logging/logging.dart';
import 'package:js_interop/channel/channel.dart' as AppEngineChan;

/// Server channel for app engine
class AppEngineServerChannel {

  /// Connect to server
  Future<AppEngineChan.Socket> connect(int roomId, {Function onOpen:null, Function onClose:null}) async {
    var url = "http://localhost:8080/api/client";
    Logger.root.info("Requesting client from ${url}");
    var r = await HttpRequest.request(url, method:"POST");
    if (!(r.readyState == HttpRequest.DONE && r.status == 200)) {
      return null;
    }
    // completed normally
    var res = r.responseText;
    // connect to the server via channel api
    Logger.root.info("creating channel");
    var chan = new AppEngineChan.Channel(res);
    Logger.root.info("opening channel socket");
    var socket = chan.open();
    Logger.root.info("Setting handlers to socket");
    if (onOpen != null) {
      socket.onopen = allowInterop(onOpen);
    }
    if (onClose != null) {
      socket.onclose = allowInterop(onClose);
    }
    socket.onerror = allowInterop(_onError);
    socket.onmessage = allowInterop(_onMessage);
    return socket;
  }

  void listen(Function onMessage, Function onError) {
    _controller.stream.listen(onMessage, onError: onError);
  }

  void _onMessage(AppEngineChan.Message message) {
    // send a meesage to all the listeners
    _controller.add(message.data);

  }

  void _onError(AppEngineChan.Error err) {
    // print(message);
    // send a message to all the listeners
    _controller.addError(err);
  }

  Future<bool> sendHeartbeat(int roomId, int clientId, String mutationToken) async {
    var r = await HttpRequest.request("", method:"POST");
    if (!(r.readyState == HttpRequest.DONE && r.status == 200)) {
      return false;
    }
    return true;
  }

  StreamController<String> _controller = new StreamController<String>.broadcast();
}