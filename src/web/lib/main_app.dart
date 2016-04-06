@HtmlImport('main_app.html')

library main_app;

import "dart:html";
import "dart:async";
import "package:js/js.dart";
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:logging/logging.dart';
import 'package:js_interop_issue/channel/channel.dart' as AppEngineChan;

@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  MainApp.created() : super.created();

  @property String token;

  void ready() {
    Logger.root.info("main-app ready");
    _connectToServer();
  }

  void _onMessage(AppEngineChan.Message message) {
    Logger.root.info("$message");
  }

  void _onError(AppEngineChan.Error err) {
    Logger.root.info("$err");
  }

  _connectToServer() async {
    var open = () => Logger.root.info("opened");
    var close = () => Logger.root.info("closed");
    var token = await _getToken();
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
    _socket = socket;
  }

  Future<String> _getToken() async {
    return token;
  }

  AppEngineChan.Socket _socket;
}
