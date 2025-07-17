import 'dart:convert';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:e_commerce/app/utils/chat_service.dart';
import 'package:http/http.dart' as http;

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
  String? sellerId;
  String? sellerName;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args == null || args['sellerId'] == null) {
        print("⚠️ No seller info passed in navigation.");
        return;
      }
      setState(() {
        sellerId = args['sellerId'];
        sellerName = args['sellerName'] ?? 'Seller';
      });

      _loadBuyerId();
      _fetchMessages();
    });
  }

  Future<void> _loadBuyerId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null) {
      final decodedToken = JwtDecoder.decode(token);
      final id = decodedToken['id'];

      setState(() {
        buyerId = id;
      });

      await _chatService.connect(id, (data) {
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


  Future<void> _fetchMessages() async {
    if (buyerId == null || sellerId == null) return;

    final response = await http.get(Uri.parse(
      '$BASE_URL/api/v1/messages?userId=$buyerId&sellerId=$sellerId',
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List messages = data['messages'];

      setState(() {
        _messages.addAll(messages.map((msg) => {
          'from': msg['senderId'],
          'text': msg['message'],
        }));
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || buyerId == null || sellerId == null || sellerId!.isEmpty) {
      print("⚠️ Cannot send message: Missing buyerId or sellerId.");
      return;
    }

    _chatService.sendMessage(buyerId!, sellerId!, text);

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
    if (sellerId == null || sellerName == null || buyerId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Chat with $sellerName'),
        backgroundColor: AppColors().primary,
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
                    icon: const Icon(Icons.send, color: Color(0xFF8D6E63)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
