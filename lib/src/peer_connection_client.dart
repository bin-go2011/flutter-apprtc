import 'dart:convert';

class PeerConnectionClient {
  Map<String, Object> _params;
  PeerConnectionClient(this._params) {
    print('Creating RTCPeerConnection with: \n' +
        ' config: \'${jsonEncode(_params["peerConnectionConfig"])}' +
        '\'\n' +
        ' constraints: \'${jsonEncode(_params["peerConnectionConstraints"])}\'.');
  }
}
