import 'package:polymer/init.dart';
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:js_interop/main_stage.dart';

main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((log) {
    print(log);
  });
  await initPolymer();
}