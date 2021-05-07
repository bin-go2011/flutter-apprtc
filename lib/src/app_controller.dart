import 'package:flutter_apprtc/src/call.dart';

var _loadingParams = {
  "mediaConstraints": {
    "audio": true,
    "video": {
      "optional": [
        {"minWidth": "1280"},
        {"minHeight": "720"}
      ],
      "mandatory": {}
    }
  },
  "offerOptions": {},
  "peerConnectionConfig": {
    "rtcpMuxPolicy": "require",
    "bundlePolicy": "max-bundle",
    "iceServers": []
  },
  "peerConnectionConstraints": {"optional": []},
  "iceServerRequestUrl": 'https://appr.tc/v1alpha/iceconfig?key=',
  "iceServerTransports": '',
  "wssUrl": 'wss://apprtc-ws.webrtc.org:443/ws',
  "wssPostUrl": 'https://apprtc-ws.webrtc.org:443',
};

class AppController {
  Call _call;

  void createCall(String roomId) {
    if (roomId != "") {
      _call = Call(_loadingParams)..start(roomId);
    }
  }
}
