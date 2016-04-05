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

  void ready() {
    Logger.root.info("main-app ready");
    var open = () => Logger.root.info("opened");
    var close = () => Logger.root.info("closed");
    _connectToServer(open, close);
  }

  void _onMessage(AppEngineChan.Message message) {
    Logger.root.info("$message");
  }

  void _onError(AppEngineChan.Error err) {
    Logger.root.info("$err");
  }

  void _connectToServer(Function onOpen, Function onClose) {
    Logger.root.info("creating channel");
    var chan = new AppEngineChan.Channel("testtoken");
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
    _socket = socket;
  }

  AppEngineChan.Socket _socket;
}
