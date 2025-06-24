import 'dart:convert';
import 'package:e_commerce/features/notifications/viewmodels/notification_model.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String baseUrl = 'http://172.20.10.2:3001/api/v1/notifications';

  static Future<List<NotificationModel>> fetchNotifications(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['notifications'] as List;
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  static Future<void> markAsRead(String id, String token) async {
    final url = '$baseUrl/$id/read';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  static Future<void> createNotification(String token, String description) async {
    final response = await http.post(
      Uri.parse('http://172.20.10.2:3001/api/v1/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'description': description}),
    );

    print('🔔 Response ${response.statusCode}: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Failed to create notification');
    }
  }

}
