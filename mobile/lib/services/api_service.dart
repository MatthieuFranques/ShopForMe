import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:mobile/models/shop.dart';
import '../models/product.dart';
import '../models/section.dart';
import 'package:mobile/utils/constants.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // // Get section details for a product
  Future<Section> getSectionForProduct(int productId) async {
    try {
      // Then fetch the section details using the rayon name
      final response = await http.get(
        Uri.parse('$baseUrl/products/getSectionByProductId/$productId'),
        headers: {'Content-Type': 'application/json', 'x-api-key': API_KEY},
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
        headers: {'Content-Type': 'application/json', 'x-api-key': API_KEY},
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
        headers: {'Content-Type': 'application/json', 'x-api-key': API_KEY},
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

//Send shortestPath on the backend
  Future<void> sendPosition(
    List<int> currentPosition,
    List<int> productPosition,
    List<List<int>>? shortestPath,
  ) async {
    final url = Uri.parse(apiGatewayUrl);

    final List<List<int>> reducedShortestPath =
        reduceShortestPath(currentPosition, shortestPath!);

    final Map<String, dynamic> data = {
      'id': '1',
      'currentPosition': currentPosition,
      'productPosition': productPosition,
      'shortestPath': reducedShortestPath,
    };

    print('Reduced shortest path ${reducedShortestPath}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': apiGatewayBearer,
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Data sent successfully to API Gateway");
      } else {
        print("❌ Status: ${response.statusCode}");
        print("❌ Response body: ${response.body}");
        throw Exception("Error sending data to backend");
      }
    } catch (e) {
      print("❌ Exception during HTTP request: $e");
      rethrow;
    }
  }

  bool isInRange(List<int> currentPosition, List<int> targetPosition) {
    final int currentY = currentPosition[0];
    final int currentX = currentPosition[1];
    final int targetY = targetPosition[0];
    final int targetX = targetPosition[1];

    return (targetY <= currentY + 1 &&
        targetY >= currentY - 1 &&
        targetX <= currentX + 1 &&
        targetX >= currentX - 1);
  }

  List<List<int>> reduceShortestPath(
      List<int> currentPosition, List<List<int>> path) {
    List<List<int>> reducedShortestPath = [];
    int i = 0;
    bool isAccessible = false;
    while (isAccessible == false) {
      if (isInRange(currentPosition, path[i])) {
        if (currentPosition != path[i]) {
          reducedShortestPath.add(currentPosition);
        }
        isAccessible = true;
      }
      i++;
    }
    if (i < path.length) {
      reducedShortestPath.addAll(path.sublist(i));
    }
    return reducedShortestPath;
  }
}
