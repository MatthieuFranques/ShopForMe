import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/services/cache_service.dart';
import '../models/product.dart';

class StoreService {
  //If we use local back-end
  static const String baseUrl = 'http://127.0.0.1:3001';
  //If we use remote back-end
  // static const String baseUrl = 'http://91.121.191.34:8080';
  final CacheService _cacheService;
  final http.Client _client;

  StoreService(this._cacheService, {http.Client? client}) 
      : _client = client ?? http.Client();

  Future<List<Product>> getProducts() async {
    try {
      print('🔍 Checking cache for products');
      final cachedProducts = _cacheService.getProducts('all');
      if (cachedProducts != null) {
        print('✅ Found ${cachedProducts.length} products in cache');
        return cachedProducts;
      }

      print('🌐 Fetching products from API');
      
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final Uri url = Uri.parse('$baseUrl/product');
      print('🔗 Requesting URL: ${url.toString()}');

      final response = await _client.get(
        url,
        headers: headers,
      );

      print('📡 API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          // Parse la réponse complète d'abord
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          // Extrait la liste de produits
          final List<dynamic> jsonList = jsonResponse['products'];
          print('📦 Successfully decoded JSON response');
          print('📊 Number of products: ${jsonList.length}');
          
          final products = jsonList.map((json) {
            try {
              return Product.fromJson(json);
            } catch (e) {
              print('⚠️ Error parsing product: $e');
              print('⚠️ Problematic JSON: $json');
              rethrow;
            }
          }).toList();
          
          print('💾 Caching ${products.length} products');
          await _cacheService.cacheProducts('all', products);
          
          return products;
        } catch (e) {
          print('❌ JSON Decode error: $e');
          print('❌ Response body: ${response.body}');
          rethrow;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        throw Exception('Failed to load products (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('❌ Error getting products: $e');
      // En cas d'erreur, essayer d'utiliser le cache
      final cachedProducts = _cacheService.getProducts('all');
      if (cachedProducts != null) {
        print('⚠️ Using cached products due to error');
        return cachedProducts;
      }
      rethrow;
    }
  }
}