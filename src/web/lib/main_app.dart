@HtmlImport('main_app.html')

library main_app;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:logging/logging.dart';
import 'package:js_interop_issue/channel/channel.dart' as AppEngineChan;
import 'package:js_interop_issue/server_channel/server_channel.dart';

@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  MainApp.created() : super.created();

  void ready() {
    Logger.root.info("main-app ready");
    _connectToServer();
  }

  _connectToServer() async {
    var open = () => Logger.root.info("opened");
    var close = () => Logger.root.info("closed");
    Logger.root.info("creating channel");
    var chan = new AppEngineServerChannel();
    _socket = await chan.connect(open, close);
  }

  AppEngineChan.Socket _socket;
}
