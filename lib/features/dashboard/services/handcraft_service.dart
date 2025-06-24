import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_commerce/features/dashboard/viewmodels/handcraft_model.dart';

class ProductService {
  static const String _baseUrl = 'http://172.20.10.2:3001';

  static Future<List<HandcraftProduct>> fetchProducts() async {
    final response = await http.get(Uri.parse("http://172.20.10.2:3001/api/v1/products"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print(data);
      final List<dynamic> productsJson = data['data']['enriched'];

      return productsJson
          .map((productJson) => HandcraftProduct.fromJson(productJson))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
