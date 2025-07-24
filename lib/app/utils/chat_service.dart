import 'dart:async';
import 'package:e_commerce/app/utils/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  IO.Socket? _socket;
  bool _isConnected = false;
  Completer<void>? _connectCompleter;
  Future<void> connect(String userId, void Function(Map<String, dynamic>) onMessage) async {
    if (_isConnected) {
      print('Already connected');
      return;
    }
    if (_socket != null && _connectCompleter != null) {
      print('Waiting for existing connection to finish...');
      return _connectCompleter!.future;
    }
    _connectCompleter = Completer<void>();
    _socket = IO.io(BASE_URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket!.connect();
    _socket!.onConnect((_) {
      print('Connected as ${_socket!.id}');
      _socket!.emit('join', userId);
      _isConnected = true;
      _connectCompleter?.complete();
    });
    _socket!.off('receive_message');
    _socket!.on('receive_message', (data) {
      print('📩 Message: ${data['message']}');
      onMessage(Map<String, dynamic>.from(data));
    });
    _socket!.onDisconnect((_) {
      print('Disconnected');
      _isConnected = false;
    });
    _socket!.onError((err) {
      print('Socket error: $err');
    });
    return _connectCompleter!.future;
  }
  void sendMessage(String senderId, String receiverId, String message, {String? productId}) {
    if (_socket == null || !_isConnected) {
      print("Cannot send message: socket not connected");
      return;
    }
    final timestamp = DateTime.now().toIso8601String();
    _socket!.emit('send_message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'productId': productId ?? '',
    });
  }
  void disconnect() {
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
    _isConnected = false;
    _connectCompleter = null;
  }
  bool get isConnected => _isConnected;
}
