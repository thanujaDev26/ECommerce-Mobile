import 'dart:convert';

import 'package:e_commerce/app/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CartItem {
  final String cartId;
  final int quantity;
  final String name;
  final String image;
  final double price;
  final double discount;
  final double finalPrice;
  final double total;

  CartItem({
    required this.cartId,
    required this.quantity,
    required this.name,
    required this.image,
    required this.price,
    required this.discount,
    required this.finalPrice,
    required this.total,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    return CartItem(
      cartId: json['id'].toString(),
      quantity: json['quantity'] ?? 0,
      name: product['name'] ?? '',
      image: (product['image'] ?? '').toString(),
      price: _toDouble(product['price']),
      discount: _toDouble(product['discount']),
      finalPrice: _toDouble(product['finalPrice']),
      total: _toDouble(json['total']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
class CartService {


  static Future<void> addToCart(String productId, String token) async {
    final url = '$BASE_URL/api/v1/cart/add';
    final response = await http.post(
      Uri.parse(url),
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

  static Future<List<CartItem>> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) throw Exception("⚠️ No token found");
    print("🔐 Token: ${prefs.getString('authToken')}");
    final response = await http.get(
      Uri.parse('$BASE_URL/api/v1/cart'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("📦 Cart API status: ${response.statusCode}");
    print("📦 Response body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        final rawItems = data['items'];
        print("🧾 Parsed items: $rawItems");
        return (rawItems as List).map((e) => CartItem.fromJson(e)).toList();
      } catch (e) {
        print("❌ Parsing error: $e");
        throw Exception("Failed to parse cart items");
      }
    } else {
      throw Exception("Failed to fetch cart: ${response.body}");
    }
  }



  static Future<void> deleteCartItem(String cartId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final url = '$BASE_URL/api/v1/cart/$cartId';

    final response = await http.delete(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to remove item");
    }
  }
}

