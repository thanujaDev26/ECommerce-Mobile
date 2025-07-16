import 'dart:convert';
import 'package:e_commerce/app/utils/config.dart';
import 'package:e_commerce/features/dashboard/viewmodels/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<UserModel?> fetchUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) throw Exception("Token not found");
      print(token);
      final response = await http.get(
        Uri.parse('$BASE_URL/api/v1/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print(response);
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to fetch user. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print("User fetch error: $e");
      return null;
    }
  }
}
