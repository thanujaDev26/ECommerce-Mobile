import 'dart:convert';
import 'package:e_commerce/app/utils/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {

  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken') ?? '';

      final url = Uri.parse('$BASE_URL/api/v1/users/password');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Password changed successfully: ${response.body}');
        return true;
      } else {
        debugPrint('Failed to change password: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error changing password: $e');
      return false;
    }
  }
}
