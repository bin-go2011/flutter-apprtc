import 'dart:io';
import 'dart:math';
import 'dart:convert';

typedef void OnMessageCallback(dynamic msg);
typedef void OnCloseCallback(int code, String reason);
typedef void OnOpenCallback();

class WebSocketClient {
  var _socket;

  OnOpenCallback onOpen;
  OnMessageCallback onMessage;
  OnCloseCallback onClose;

  connect(String url) async {
    try {
      _socket = await _connectForSelfSignedCert(url);
      this?.onOpen();
      _socket.listen((data) {
        this?.onMessage(data);
      }, onDone: () {
        this?.onClose(_socket.closeCode, _socket.closeReason);
      });
    } catch (e) {
      this.onClose(500, e.toString());
    }
  }

  send(data) {
    if (_socket != null) {
      _socket.add(data);
      print('sent: $data');
    }
  }

  close() {
    if (_socket != null) _socket.close();
  }

  Future<WebSocket> _connectForSelfSignedCert(url) async {
    try {
      Uri uri = Uri.parse(url);

      if (uri.scheme != "ws" && uri.scheme != "wss") {
        throw new WebSocketException("Unsupported URL scheme '${uri.scheme}'");
      }

      // Generate 16 random bytes.
      Random r = Random();
      String nonce =
          base64.encode(List<int>.generate(16, (_) => r.nextInt(255)));

      int port = uri.port;
      if (port == 0) {
        port = uri.scheme == "wss" ? 443 : 80;
      }
      uri = new Uri(
          scheme: uri.scheme == "wss" ? "https" : "http",
          userInfo: uri.userInfo,
          host: uri.host,
          port: port,
          path: uri.path,
          query: uri.query);

      HttpClient _client = HttpClient();
      // ..badCertificateCallback = (a, b, c) => true;

      HttpClientRequest request = await _client.getUrl(uri);
      request.headers
        ..set(HttpHeaders.connectionHeader, "Upgrade")
        ..set(HttpHeaders.upgradeHeader, "websocket")
        ..set("Sec-WebSocket-Key", nonce)
        ..set("Cache-Control", "no-cache")
        ..set("Sec-WebSocket-Version", "13");

      HttpClientResponse response = await request.close();

      Socket socket = await response.detachSocket();
      return WebSocket.fromUpgradedSocket(
        socket,
        protocol: 'signaling',
        serverSide: false,
      );
    } catch (e) {
      throw e;
    }
  }
}
