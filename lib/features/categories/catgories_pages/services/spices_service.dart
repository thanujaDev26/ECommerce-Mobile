import 'dart:convert';
import 'package:e_commerce/features/categories/catgories_pages/models/spices_model.dart';
import 'package:http/http.dart' as http;

class SpicesService {
  static const String _baseUrl = 'http://192.168.1.104:3001';

  static Future<List<SpicesModel>> fetchProducts() async {
    final response = await http.get(Uri.parse("$_baseUrl/api/v1/products/spices"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print(data);
      final List<dynamic> productsJson = data['data']['enriched'];
      return productsJson
          .map((productJson) => SpicesModel.fromJson(productJson))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
