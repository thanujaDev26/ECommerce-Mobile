import 'package:e_commerce/app/utils/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;

  void connect(String userId) {
    socket = IO.io('$BASE_URL', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to Socket.IO');
      socket.emit('join', userId);
    });

    socket.on('receive_message', (data) {
      print('📩 New message from ${data['senderId']}: ${data['message']}');
    });

    socket.onDisconnect((_) => print('Disconnected from Socket.IO'));
  }

  void sendMessage(String senderId, String receiverId, String message) {
    socket.emit('send_message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
