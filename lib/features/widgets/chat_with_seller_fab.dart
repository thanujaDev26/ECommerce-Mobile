import 'package:flutter/material.dart';
import 'package:e_commerce/app/constants/app_colors.dart';

class ChatWithSellerFAB extends StatefulWidget {
  final String sellerId;
  final String sellerName;
  final int unreadMessages;

  const ChatWithSellerFAB({
    super.key,
    required this.sellerId,
    required this.sellerName,
    this.unreadMessages = 0,
  });

  @override
  State<ChatWithSellerFAB> createState() => _ChatWithSellerFABState();
}

class _ChatWithSellerFABState extends State<ChatWithSellerFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _startChat(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'sellerId': widget.sellerId,
        'sellerName': widget.sellerName ?? '',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      right: 30,
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.1)
            .animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Hero(
              tag: 'chat-fab',
              child: SizedBox(
                height: 60,
                width: 60,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () => _startChat(context),
                  backgroundColor: AppColors().primary,
                  child: const Icon(Icons.chat, size: 28, color: Colors.white),
                  elevation: 6,
                ),
              ),
            ),
            // if (widget.unreadMessages > 0)
            //   Positioned(
            //     right: -4,
            //     top: -4,
            //     child: Container(
            //       padding: const EdgeInsets.all(4),
            //       decoration: BoxDecoration(
            //         color: Colors.red,
            //         shape: BoxShape.circle,
            //         border: Border.all(color: Colors.white, width: 2),
            //       ),
            //       constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            //       child: Center(
            //         child: Text(
            //           '${widget.unreadMessages}',
            //           style: const TextStyle(
            //               fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
