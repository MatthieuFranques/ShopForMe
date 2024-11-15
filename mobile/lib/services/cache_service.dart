// lib/services/cache_service.dart
import 'package:hive/hive.dart';
import '../models/product.dart';
import '../models/shop.dart';

class CacheService {
  static const String shopBox = 'shops';
  static const String productBox = 'products';

  late Box<Shop> _shopBox;
  late Box<dynamic> _productBox;

  Future<void> init() async {
    // Suppression de Hive.initFlutter()

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ShopAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ShopCellAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ProductAdapter());
    }

    _shopBox = await Hive.openBox<Shop>(shopBox);
    _productBox = await Hive.openBox(productBox);
  }

  Future<void> cacheShop(Shop shop) async {
    await _shopBox.put(shop.id.toString(), shop);
  }

  Shop? getShop(int id) {
    return _shopBox.get(id.toString());
  }

  Future<void> cacheProducts(String key, List<Product> products) async {
    try {
      print('💾 Attempting to cache ${products.length} products');
      await _productBox.put(key, products);
      print('✅ Successfully cached products');
    } catch (e) {
      print('❌ Error caching products: $e');
      rethrow;
    }
  }

  List<Product>? getProducts(String key) {
    try {
      print('🔍 Retrieving products from cache');
      final dynamic data = _productBox.get(key);

      if (data == null) {
        print('⚠️ No products found in cache');
        return null;
      }

      if (data is List<Product>) {
        print('✅ Found ${data.length} products in cache');
        return data;
      }

      if (data is List) {
        print('🔄 Converting cached data to Product list');
        final products = data.map((item) {
          if (item is Product) return item;

          if (item is Map) {
            return Product.fromJson(Map<String, dynamic>.from(item));
          }

          throw TypeError();
        }).toList();

        print('✅ Successfully converted ${products.length} products');
        return products.cast<Product>();
      }

      print('❌ Invalid cache data format');
      return null;
    } catch (e) {
      print('❌ Error retrieving products from cache: $e');
      return null;
    }
  }

  Future<void> clearCache() async {
    await _shopBox.clear();
    await _productBox.clear();
  }
}
