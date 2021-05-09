import 'dart:convert';

import 'package:flutter_apprtc/src/peer_connection_client.dart';
import 'package:flutter_apprtc/src/signaling_channel.dart';
import 'package:http/http.dart' as http;

const APPRTC_URL_BASE = 'https://appr.tc';

class Call {
  final _wsClient = SignalingChannel();
  PeerConnectionClient _pcClient;
  Map<String, Object> _params;

  Call(this._params);

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
    var iceServers =
        (_params["peerConnectionConfig"] as Map)["iceServers"] as List;
    for (var server in (jsonDecode(response.body)["iceServers"] as List)) {
      iceServers.add(server);
    }
  }

  start(String roomId) async {
    _requestMediaAndIceServers();

    await _connectToRoom(roomId);

    _startSignaling();
  }

  _connectToRoom(String roomId) async {
    var response = await _joinRoom(roomId);
    if (response.statusCode == 200) {
      var responseObj = jsonDecode(response.body);
      if (responseObj["result"] == "SUCCESS") {
        _params["clientId"] = responseObj["params"]["client_id"];
        _params["roomId"] = responseObj["params"]["room_id"];
        _params["roomLink"] = responseObj["params"]["room_link"];
        _params["isInitiator"] = responseObj["params"]["room_link"];

        _wsClient.connect(_params["wssUrl"], _params["wssPostUrl"]);
        _wsClient.register(_params["roomId"], _params["clientId"]);
      }
    }
    print('Joined the room.');
  }

  Future<http.Response> _joinRoom(String roomId) {
    var url = Uri.parse('$APPRTC_URL_BASE/join/$roomId');
    return http.post(url);
  }

  _startSignaling() {
    print('Starting signaling.');
    _createPeerConnection();
  }

  _sendSignalingMessage(dynamic message) {
    var msgString = jsonEncode(message);
    var url = Uri.parse(
        '$APPRTC_URL_BASE/message/$_params["roomId"]/$_params["clientId"]');
    http.post(url, body: msgString);
    print('C->GAE: $msgString');
  }

  _createPeerConnection() {
    _pcClient = PeerConnectionClient(_params);
    print("Created PeerConnectionClient");
  }
}
