import 'package:flutter/material.dart';
import 'package:flutter_apprtc/src/utils/websocket_client.dart';
import 'dart:convert';

class SignalingChannel {
  final _websocket = WebSocketClient();

  SignalingChannel() {
    _websocket
      ..onOpen = () {
        debugPrint("Signaling channel opened.");
      }
      ..onClose = (int code, String reason) {
        debugPrint('Channel closed with code:$code reason:$reason');
      }
      ..onMessage = (dynamic msg) {
        print(msg);
      };
  }

  open(String url) async {
    await _websocket.connect(url);
  }

  register(String roomId, String clientId) {
    var registerMessage = {
      'cmd': 'register',
      'roomid': roomId,
      'clientid': clientId
    };
    _websocket.send(jsonEncode(registerMessage));
  }

  close() {
    _websocket.close();
  }
}
