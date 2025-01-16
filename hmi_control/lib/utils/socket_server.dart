import 'dart:io';
import 'dart:convert';
import 'dart:async';

class SocketServer {
  late Socket _socket;
  // ignore: non_constant_identifier_names
  final Function(String) LOG;

  SocketServer(this.LOG);

  Future<void> connect(String host, int port, String type) async {
    try {
      _socket = await Socket.connect(host, port);
      LOG("CONNECTED");
      _socket.write(type);

      _socket.listen(
        (data) {
          final message = utf8.decode(data);
          LOG(message);
        },
        onError: (error) {
          LOG(error);
        },
        onDone: () {
          LOG('Connection closed');
        },
      );
    } catch (e) {
      LOG(e.toString());
    }
  }

  void send(String message) {
    if (_socket.remoteAddress.address.isNotEmpty) {
      _socket.write(message);
    } else {
      LOG('Socket is not connected.');
    }
  }

  void disconnect() {
    _socket.close();
    LOG('Disconnected from server');
  }
}
