import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:mobile/models/shop.dart';
import '../models/product.dart';
import '../models/section.dart';

class ApiService {
  final String baseUrl;
  
  ApiService({required this.baseUrl});
  
  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> productsJson = jsonDecode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching all products: $e');
      rethrow;
    }
  }
  
  // Get a specific product by ID
  Future<Product> getProductById(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final productJson = jsonDecode(response.body);
        return Product.fromJson(productJson);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching product $productId: $e');
      rethrow;
    }
  }
  
  // Get section details for a product
  Future<Section> getSectionForProduct(String productId) async {
    try {
      // First, get the product to find its rayon (section name)
      final product = await getProductById(productId);
      
      // Then fetch the section details using the rayon name
      final response = await http.get(
        Uri.parse('$baseUrl/sections/getByName/${product.rayon}'),
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
  Future<List<Product>> getProductsByShop(String shopId) async {
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

  // // Get products by shop ID
  // Future<List<Shop>> getAllShops() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/products/getAllProductByShop/$shopId'),
  //       headers: {'Content-Type': 'application/json'},
  //     );
      
  //     if (response.statusCode == 200) {
  //       final List<dynamic> productsJson = jsonDecode(response.body);
  //       return productsJson.map((json) => Product.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load shop products: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching products for shop $shopId: $e');
  //     rethrow;
  //   }
  // }


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
        throw Exception('Failed to load shop products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching products for shop $shopId: $e');
      rethrow;
    }
  }
}