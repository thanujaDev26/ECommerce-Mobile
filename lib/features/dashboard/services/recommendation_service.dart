import 'dart:convert';
import 'package:e_commerce/features/dashboard/viewmodels/user_profile.dart';
import 'package:http/http.dart' as http;

class RecommendationService {
  static Future<List<Map<String, dynamic>>> fetchRecommendedItems() async {
    final response = await http.get(Uri.parse("http://192.168.1.104:3001/api/v1/products"));
    // if (response.statusCode == 200) {
    //   final List<dynamic> jsonList = json.decode(response.body);
    //   return jsonList.cast<Map<String, dynamic>>();
    // } else {
    //   throw Exception("Failed to load recommended items");
    // }
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);

      // final List<dynamic> enrichedList = jsonMap['data']['enriched'];
      final enrichedList = (jsonMap['data']?['enriched'] ?? []) as List;
      return enrichedList.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load recommended items");
    }
  }

  List<Map<String, dynamic>> filterItems(
      List<Map<String, dynamic>> items,
      UserProfile user,
      ) {
    final ageTag = user.age < 20 ? 'teen' : 'adult';

    return items.where((item) {
      final List<dynamic> tags = item['tags'] ?? [];

      return tags.contains(ageTag) &&
          tags.contains(user.gender.toLowerCase()) &&
          tags.contains(user.location.toLowerCase());
    }).toList();
  }
}
