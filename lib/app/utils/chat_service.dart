import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;

  void connect(String userId) {
    socket = IO.io('http://172.20.10.3:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to Socket.IO as ${socket.id}');
      socket.emit('join', userId);
    });

    socket.on('receive_message', (data) {
      print('📩 Message from ${data['senderId']}: ${data['message']}');
    });

    socket.onDisconnect((_) {
      print('❌ Disconnected from Socket.IO');
    });
  }

  void sendMessage(String senderId, String receiverId, String message, {String? productId}) {
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
    socket.disconnect();
  }
}
