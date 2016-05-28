# js_interop_issue
Sample to see if js interop issue (https://github.com/dart-lang/sdk/issues/25785) reproduces

## Steps to reprodue
1. pub get
1. pub build
1. cd build/web
1. python -m SimpleHTTPServer
1. access `localhost:8000` with a browser and open the console to see error

If you comment out the following line in index.dart, the code will work properly.

    _heartbeater = new Timer.periodic(HEARTBEAT_INTERVAL, _pulseHeartbeat);
