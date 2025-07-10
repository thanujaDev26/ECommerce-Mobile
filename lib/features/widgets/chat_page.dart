import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final sellerId = args?['sellerId'] ?? 'Unknown ID';
    final sellerName = args?['sellerName'] ?? 'Seller';

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $sellerName'),
        backgroundColor: AppColors().primary,
      ),
      body: const Center(
        child: Text("Chat functionality coming soon..."),
      ),
    );
  }
}
