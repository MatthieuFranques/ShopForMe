import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/services/cache_service.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/models/shop.dart';

class StoreService {
  final CacheService _cacheService;
  final http.Client _client;
  Shop? _currentShop;

  StoreService(this._cacheService, {http.Client? client}) 
      : _client = client ?? http.Client() {
    // Charger le magasin par défaut dans le constructeur
    loadCurrentShop(defaultShopId).then((_) {
      print('✅ Default shop initialized (ID: $defaultShopId)');
    }).catchError((error) {
      print('❌ Error initializing default shop: $error');
    });
  }

  Shop? get currentShop => _currentShop;

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
      // 1. Vérifier le cache d'abord
      final cachedShop = _cacheService.getShop(shopId);
      if (cachedShop != null) {
        print('✅ Found shop in cache');
        currentShop = cachedShop;
        return;
      }

      // 2. Si pas en cache, essayer l'API
      print('🌐 Fetching shop from API');
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final Uri url = Uri.parse('$baseUrl/shops/$shopId');
      final response = await _client.get(url, headers: headers);
      print("Successfully fetched from backend");
      print(response);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final shop = Shop.fromJson(jsonData);
        
        // Mettre en cache
        await _cacheService.cacheShop(shop);
        currentShop = shop;
        print('✅ Shop loaded and cached successfully');
      } else if (shopId == defaultShopId) {
        // Si c'est le magasin par défaut qui échoue, lancer une erreur
        print('❌ Failed to load default shop');
        throw Exception('Failed to load default shop');
      } else {
        // Si ce n'est pas le magasin par défaut, essayer de charger le magasin par défaut à la place
        print('⚠️ Failed to load requested shop, falling back to default shop');
        await loadCurrentShop(defaultShopId);
      }
    } catch (e) {
      print('❌ Error loading shop: $e');
      rethrow;
    }
  }
}