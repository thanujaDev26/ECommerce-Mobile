import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, String>> notifications = [
      {
        'title': '🎉 Order Shipped!',
        'message': 'Your order #1234 has been shipped.',
        'timestamp': '2 mins ago',
      },
      {
        'title': '🔥 Flash Sale Today',
        'message': 'Up to 40% off on selected items.',
        'timestamp': '1 hour ago',
      },
      {
        'title': '📦 Package Delivered',
        'message': 'Order #5678 was delivered to your address.',
        'timestamp': 'Yesterday',
      },
      {
        'title': '👋 Welcome!',
        'message': 'Thanks for signing up. Start exploring now!',
        'timestamp': '2 days ago',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.orange),
              title: Text(
                notification['title']!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['message']!,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['timestamp']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              contentPadding: const EdgeInsets.all(12),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      ),
    );
  }
}
