import 'dart:convert';

import 'package:http/http.dart' as http;

class CartService {
  static const String baseUrl = 'http://172.20.10.2:3001/api/v1/cart/add';

  static Future<void> addToCart(String productId, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'productId': productId,
        'quantity': 1,
      }),
    );

    print("🔽 Cart response ${response.statusCode}: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to add to cart");
    }
  }
}

