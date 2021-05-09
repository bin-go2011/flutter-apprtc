import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SignalingChannel {
  String _wssUrl;
  String _wssPostUrl;
  WebSocketChannel _websocket;
  bool _registered = false;

  connect(String wssUrl, String wssPostUrl) {
    print('Opening signaling channel.');
    _wssUrl = wssUrl;
    _wssPostUrl = wssPostUrl;

    _websocket = IOWebSocketChannel.connect(
      _wssUrl,
      headers: {"Origin": "https://appr.tc"},
    )..stream.listen(
        (event) {
          print(event);
        },
        onDone: () {
          print('Channel closed');
          _websocket.sink.close();
        },
        onError: (Object error, StackTrace stackTrace) {
          print('Signaling channel error: $error');
        },
      );
    print('Signaling channel opened.');
  }

  register(String roomId, String clientId) {
    print('Registering signaling channel.');
    var registerMessage = {
      'cmd': 'register',
      'roomid': roomId,
      'clientid': clientId
    };
    _websocket.sink.add(jsonEncode(registerMessage));
    _registered = true;
    print('Signaling channel registered.');
  }
}
