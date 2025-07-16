import 'dart:convert';
import 'package:e_commerce/app/utils/config.dart';
import 'package:e_commerce/features/categories/catgories_pages/models/spices_model.dart';
import 'package:http/http.dart' as http;

class SpicesService {


  static Future<List<SpicesModel>> fetchProducts() async {
    final response = await http.get(Uri.parse("$BASE_URL/api/v1/products/spices"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> productsJson = data['data']['enriched'];
      return productsJson
          .map((productJson) => SpicesModel.fromJson(productJson))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
