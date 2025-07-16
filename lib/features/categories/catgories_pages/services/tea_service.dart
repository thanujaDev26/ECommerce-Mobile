import 'dart:convert';
import 'package:e_commerce/app/utils/config.dart';
import 'package:e_commerce/features/categories/catgories_pages/models/tea_model.dart';
import 'package:http/http.dart' as http;

class TeaService {


  static Future<List<TeaModel>> fetchProducts() async {
    final response = await http.get(Uri.parse("$BASE_URL/api/v1/products/food"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print(data);
      final List<dynamic> productsJson = data['data']['enriched'];

      return productsJson
          .map((productJson) => TeaModel.fromJson(productJson))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
