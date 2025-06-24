import 'dart:convert';
import 'package:e_commerce/features/categories/catgories_pages/models/herbal_model.dart';
import 'package:http/http.dart' as http;

class HerbalService {
  static const String _baseUrl = 'http://172.20.10.2:3001';

  static Future<List<HerbalModel>> fetchProducts() async {
    final response = await http.get(Uri.parse("$_baseUrl/api/v1/products/herbals"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print(data);
      final List<dynamic> productsJson = data['data']['enriched'];

      return productsJson
          .map((productJson) => HerbalModel.fromJson(productJson))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
