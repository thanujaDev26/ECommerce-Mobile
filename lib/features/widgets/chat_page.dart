import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:e_commerce/app/utils/chat_service.dart';
import 'package:e_commerce/features/dashboard/viewmodels/user_profile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ChatService _chatService = ChatService();

  String? buyerId;
  late String sellerId;
  late String sellerName;

  @override
  void initState() {
    super.initState();
    _loadTokenAndBuyerId();
  }

  Future<void> _loadTokenAndBuyerId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final id = decodedToken['id'];

      setState(() {
        buyerId = id;
      });

      _chatService.connect(id);

      _chatService.socket.on('receive_message', (data) {
        if (!mounted) return;
        setState(() {
          _messages.add({
            'from': data['senderId'],
            'text': data['message'],
          });
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    sellerId = args?['sellerId'] ?? '';
    sellerName = args?['sellerName'] ?? 'Seller';
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || buyerId == null) return;

    _chatService.sendMessage(buyerId!, sellerId, text);

    setState(() {
      _messages.add({'from': buyerId!, 'text': text});
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    _chatService.disconnect();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Chat with $sellerName'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['from'] == buyerId;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.blue),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
