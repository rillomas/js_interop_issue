part of services;

/// Server channel for app engine
class AppEngineServerChannel {

  /// Connect to server
  Future<AppEngineChan.Socket> connect(int roomId, {Function onOpen:null, Function onClose:null}) {
    var task = new AsyncHttpRequest<AppEngineChan.Socket>();
    var url = "http://localhost:8080/api/client";
    Logger.root.info("Requesting client from ${url}");
    var f = task.request(url, (res) {
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
      _socket = socket;
      return socket;
    }, method:"POST");
    return f;
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

  Future<bool> sendHeartbeat(int roomId, int clientId, String mutationToken) {
    var task = new AsyncHttpRequest<bool>();
    var f = task.request("", (res) {
      return true;
    }, method: "POST");
    return f;
  }

  StreamController<String> _controller = new StreamController<String>.broadcast();
  /// Socket object for communication
  AppEngineChan.Socket _socket;
}