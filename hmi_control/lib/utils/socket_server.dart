import 'dart:io';
import 'dart:convert';
import 'dart:async';

class SocketServer {
  late Socket _socket;
  late StreamController<String> _messageController;

  SocketServer() {
    _messageController = StreamController<String>.broadcast();
  }

  Future<void> connect(String host, int port) async {
    try {
      _socket = await Socket.connect(host, port);
      print('Connected to server');

      _socket.listen(
        (data) {
          final message = utf8.decode(data);
          _messageController.add(message);
        },
        onError: (error) {
          print('Error receiving data: $error');
          _messageController.addError(error);
        },
        onDone: () {
          print('Connection closed');
          _messageController.close();
        },
      );
    } catch (e) {
      print('Error connecting to server: $e');
      _messageController.addError(e);
    }
  }

  void send(String message) {
    if (_socket.remoteAddress.address.isNotEmpty) {
      _socket.write(message);
      print('Sent: $message');
    } else {
      print('Socket is not connected');
    }
  }

  Stream<String> get messages => _messageController.stream;

  void disconnect() {
    _socket.close();
    print('Disconnected from server');
  }
}
