import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/services/cache_service.dart';
import 'package:mobile/utils/constants.dart'; // Importer constants.dart
import '../models/product.dart';
import '../models/shop.dart';

class StoreService {
  //replace with good URL when ready
  
  final CacheService _cacheService;
  final http.Client _client;
  Shop? _currentShop;

  StoreService(this._cacheService, {http.Client? client}) 
      : _client = client ?? http.Client();

  // Getter for current shop
  Shop? get currentShop => _currentShop;

  // Setter for current shop
  set currentShop(Shop? shop) {
    print('🏪 Setting current shop: ${shop?.name ?? "None"}');
    _currentShop = shop;
  }

  Future<List<Product>> getProducts() async {
    try {
      print('🔍 Checking cache for products');
      final cachedProducts = _cacheService.getProducts('all');
      if (cachedProducts != null) {
        print('✅ Found ${cachedProducts.length} products in cache');
        return List<Product>.from(cachedProducts);
      }

      print('🌐 Fetching products from API');
      
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final Uri url = Uri.parse('$baseUrl/product');
      print('🔗 Requesting URL: ${url.toString()}');

      final response = await _client.get(url, headers: headers);
      print('📡 API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
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
      final cachedProducts = _cacheService.getProducts('all');
      if (cachedProducts != null) {
        print('⚠️ Using cached products due to error');
        return List<Product>.from(cachedProducts);
      }
      rethrow;
    }
  }

  Future<void> loadCurrentShop(int shopId) async {
    print('🔍 Loading shop with id: $shopId');
    try {
      final shop = _cacheService.getShop(shopId);
      if (shop != null) {
        print('✅ Found shop in cache');
        currentShop = shop;
      } else {
        print('⚠️ Shop not found in cache');
        // Ici vous pourriez ajouter la logique pour charger le shop depuis l'API
      }
    } catch (e) {
      print('❌ Error loading shop: $e');
      rethrow;
    }
  }
}