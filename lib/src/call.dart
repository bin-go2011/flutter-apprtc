import 'package:flutter_apprtc/src/signaling_channel.dart';
import 'package:http/http.dart' as http;

class Call {
  SignalingChannel _channel;
  Map<String, Object> _params;

  Call(this._params) {
    _channel = SignalingChannel(_params["wssUrl"], _params["wssPostUrl"]);
    _requestMediaAndIceServers();
  }

  start(String roomId) {
    _connectToRoom(roomId);
  }

  _requestMediaAndIceServers() async {
    var url = Uri.parse('${_params['iceServerRequestUrl']}');
    var response = await http.post(
      url,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  _connectToRoom(String roomId) {
    _joinRoom(roomId);
  }

  _joinRoom(String roomId) async {
    var url = Uri.parse('https://appr.tc/join/$roomId');
    var response = await http.post(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
