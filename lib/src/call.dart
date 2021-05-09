import 'dart:convert';

import 'package:flutter_apprtc/src/peer_connection_client.dart';
import 'package:flutter_apprtc/src/signaling_channel.dart';
import 'package:http/http.dart' as http;

const APPRTC_URL_BASE = 'https://appr.tc';

class Call {
  SignalingChannel _channel;
  PeerConnectionClient _pcClient;
  Map<String, Object> _params;

  String _roomId;
  String _clientId;
  String _room_link;

  Call(this._params) {
    _channel = SignalingChannel(_params["wssUrl"]);
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
    var iceServers =
        (_params["peerConnectionConfig"] as Map)["iceServers"] as List;
    for (var server in (jsonDecode(response.body)["iceServers"] as List)) {
      iceServers.add(server);
    }
  }

  start(String roomId) async {
    _roomId = roomId;

    _requestMediaAndIceServers();

    await _connectToRoom();

    _startSignaling();
  }

  _connectToRoom() async {
    _channel.open();

    var response = await _joinRoom(_roomId);

    if (response.statusCode == 200) {
      var responseObj = jsonDecode(response.body);
      if (responseObj["result"] == "SUCCESS") {
        _clientId = responseObj["params"]["client_id"];
        _room_link = responseObj["params"]["room_link"];
        _channel.register(_roomId, _clientId);
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
    _createPcClient();
  }

  _sendSignalingMessage(dynamic message) {
    var msgString = jsonEncode(message);
    var url = Uri.parse('$APPRTC_URL_BASE/message/$_roomId/$_clientId');
    http.post(url, body: msgString);
    print('C->GAE: $msgString');
  }

  _createPcClient() {
    _pcClient = PeerConnectionClient(_params);
  }
}
