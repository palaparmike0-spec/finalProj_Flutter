import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/marketplace_item.dart';

class ApiService {
  static const String apiUrl = 'https://dummyjson.com/products?limit=30';

  Future<List<MarketplaceItem>> fetchItems() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];

      return products.map((product){
        return MarketplaceItem.fromJson(product);
      }).toList();
    } 

    throw Exception('Failed to load items. Status:  ${response.statusCode}');
    
  }
}