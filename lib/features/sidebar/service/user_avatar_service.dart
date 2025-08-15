import 'dart:convert';
import 'package:e_commerce/app/utils/config.dart';
import 'package:e_commerce/features/sidebar/model/user_avatar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAvatarService {
  static Future<UserAvatar?> fetchUserAvatar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken') ?? '';

      final url = Uri.parse('$BASE_URL/api/v1/users');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserAvatar.fromJson(data);
      } else {
        debugPrint('Failed to fetch user avatar: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user avatar: $e');
      return null;
    }
  }
}
