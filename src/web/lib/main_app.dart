@HtmlImport('main_app.html')

library main_app;

import "dart:html";
import "dart:async";
import "package:js/js.dart";
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:logging/logging.dart';
import 'package:js_interop_issue/channel/channel.dart' as AppEngineChan;
import 'package:js_interop_issue/server_channel/server_channel.dart';

@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  MainApp.created() : super.created();

  @property String token;

  void ready() {
    Logger.root.info("main-app ready");
    _connectToServer();
  }

  _connectToServer() async {
    var open = () => Logger.root.info("opened");
    var close = () => Logger.root.info("closed");
    var token = await _getToken();
    Logger.root.info("creating channel");
    var chan = new AppEngineServerChannel();
    _socket = chan.connect(token, open, close);
  }

  Future<String> _getToken() async {
    return token;
  }

  AppEngineChan.Socket _socket;
}
