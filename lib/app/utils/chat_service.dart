import 'dart:async';
import 'package:e_commerce/app/utils/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  IO.Socket? _socket;
  bool _isConnected = false;
  Completer<void>? _connectCompleter;

  Future<void> connect(String userId, void Function(Map<String, dynamic>) onMessage) async {
    if (_isConnected && (_socket?.connected ?? false)) return;
    if (_socket != null && _connectCompleter != null && !(_connectCompleter!.isCompleted)) {
      return _connectCompleter!.future;
    }

    _connectCompleter = Completer<void>();
    _socket = IO.io(
      BASE_URL,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    final socket = _socket!;
    socket.connect();

    socket.off('connect');
    socket.onConnect((_) {
      final id = socket.id;
      print('Connected as ${id ?? '(no id)'}');
      socket.emit('join', userId);
      _isConnected = true;
      if (!(_connectCompleter?.isCompleted ?? true)) {
        _connectCompleter?.complete();
      }
    });

    socket.off('receive_message');
    socket.on('receive_message', (data) {
      try {
        final map = Map<String, dynamic>.from(data as Map);
        onMessage(map);
      } catch (e) {
        print('receive_message parse error: $e');
      }
    });

    socket.off('disconnect');
    socket.onDisconnect((_) {
      print('Disconnected');
      _isConnected = false;
    });

    socket.off('error');
    socket.onError((err) {
      print('Socket error: $err');
      if (!(_connectCompleter?.isCompleted ?? true)) {
        _connectCompleter?.completeError(err ?? 'socket error');
      }
    });

    return _connectCompleter!.future;
  }

  void sendMessage(String senderId, String receiverId, String message, {String? productId}) {
    final socket = _socket;
    if (socket == null || !_isConnected || !(socket.connected)) {
      print("Cannot send message: socket not connected");
      return;
    }
    final timestamp = DateTime.now().toIso8601String();
    socket.emit('send_message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'productId': productId ?? '',
    });
  }

  void disconnect() {
    final socket = _socket;
    if (socket != null) {
      try {
        socket.off('connect');
        socket.off('receive_message');
        socket.off('disconnect');
        socket.off('error');
        socket.disconnect();
      } catch (_) {}
    }
    _socket = null;
    _isConnected = false;
    _connectCompleter = null;
  }

  bool get isConnected => _isConnected && (_socket?.connected ?? false);
}
