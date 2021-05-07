import 'dart:convert';

import 'package:flutter_apprtc/src/signaling_channel.dart';
import 'package:http/http.dart' as http;

class Call {
  final _channel = SignalingChannel();
  Map<String, Object> _params;

  Call(this._params) {
    _requestMediaAndIceServers();
  }

  _requestMediaAndIceServers() async {
    var url = Uri.parse('${_params['iceServerRequestUrl']}');
    var response = await http.post(
      url,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  start(String roomId) {
    // _channel.open(_params["wssUrl"]);
    _connectToRoom(roomId);
  }

  _connectToRoom(String roomId) async {
    var response = await _joinRoom(roomId);
    if (response.statusCode == 200) {
      var responseObj = jsonDecode(response.body);
      if (responseObj["result"] == "SUCCESS") {
        var clientId = responseObj["params"]["client_id"];
        _channel.register(roomId, clientId);
      }
    }
  }

  Future<http.Response> _joinRoom(String roomId) {
    var url = Uri.parse('https://appr.tc/join/$roomId');
    return http.post(url);
  }
}
