import 'dart:convert';

import 'package:flutter_apprtc/src/signaling_channel.dart';
import 'package:http/http.dart' as http;

class Call {
  SignalingChannel _channel;
  Map<String, Object> _params;

  Call(this._params) {
    _channel = SignalingChannel(_params["wssUrl"]);
    _requestMediaAndIceServers();
  }

  _requestMediaAndIceServers() {
    _maybeGetMedia();
    _maybeGetIceServers();
  }

  _maybeGetMedia() {}

  _maybeGetIceServers() {
    _requestIceServers();
  }

  _requestIceServers() async {
    var requestUrl = Uri.parse('${_params['iceServerRequestUrl']}');
    var response = await http.post(requestUrl);
    print('Retrieved ICE server information.');
    print('Response body: ${response.body}');
  }

  start(String roomId) {
    _connectToRoom(roomId);
  }

  _connectToRoom(String roomId) async {
    _channel.open();

    var response = await _joinRoom(roomId);

    if (response.statusCode == 200) {
      var responseObj = jsonDecode(response.body);
      if (responseObj["result"] == "SUCCESS") {
        var clientId = responseObj["params"]["client_id"];
        _channel.register(roomId, clientId);
      }
    }
    print('Joined the room.');
  }

  Future<http.Response> _joinRoom(String roomId) {
    var url = Uri.parse('https://appr.tc/join/$roomId');
    return http.post(url);
  }
}
