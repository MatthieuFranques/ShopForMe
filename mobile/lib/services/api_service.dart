import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:mobile/models/shop.dart';
import '../models/product.dart';
import '../models/section.dart';

class ApiService {
  final String baseUrl;
  
  ApiService({required this.baseUrl});

  
  // // Get section details for a product
  Future<Section> getSectionForProduct(int productId) async {
    try {      
      // Then fetch the section details using the rayon name
      final response = await http.get(
        Uri.parse('$baseUrl/products/getSectionByProductId/$productId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final sectionJson = jsonDecode(response.body);
        return Section.fromJson(sectionJson);
      } else {
        throw Exception('Failed to load section: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching section for product $productId: $e');
      rethrow;
    }
  }
  
  // Get products by shop ID
  Future<List<Product>> getAllProductByShop(String shopId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/getAllProductByShop/$shopId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> productsJson = jsonDecode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load shop products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching products for shop $shopId: $e');
      rethrow;
    }
  }

  // Get products by shop ID
  Future<Shop> getShopById(String shopId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/shops/$shopId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final shopJson = jsonDecode(response.body);
      return Shop.fromJson(shopJson);
    } else {
      throw Exception('Failed to load shop: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error fetching shop $shopId: $e');
    rethrow;
  }
}

}