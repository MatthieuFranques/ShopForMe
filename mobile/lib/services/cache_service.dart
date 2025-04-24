// lib/services/cache_service.dart
import 'package:hive/hive.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/models/shop.dart';

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
      // coverage:ignore-start
      print('💾 Attempting to cache ${products.length} products');
      // coverage:ignore-end
      await _productBox.put(key, products);
      // coverage:ignore-start
      print('✅ Successfully cached products');
      // coverage:ignore-end
    } catch (e) {
      // coverage:ignore-start
      print('❌ Error caching products: $e');
      // coverage:ignore-end
      rethrow;
    }
  }

  List<Product>? getProducts(String key) {
    try {
      // coverage:ignore-start
      print('🔍 Retrieving products from cache');
      // coverage:ignore-end
      final dynamic data = _productBox.get(key);

      if (data == null) {
        // coverage:ignore-start
        print('⚠️ No products found in cache');
        // coverage:ignore-end
        return null;
      }

      if (data is List<Product>) {
        // coverage:ignore-start
        print('✅ Found ${data.length} products in cache');
        // coverage:ignore-end
        return data;
      }

      if (data is List) {
        // coverage:ignore-start
        print('🔄 Converting cached data to Product list');
        // coverage:ignore-end
        final products = data.map((item) {
          if (item is Product) return item;

          if (item is Map) {
            return Product.fromJson(Map<String, dynamic>.from(item));
          }

          throw TypeError();
        }).toList();
        // coverage:ignore-start
        print('✅ Successfully converted ${products.length} products');
        // coverage:ignore-end
        return products.cast<Product>();
      }

      // coverage:ignore-start
      print('❌ Invalid cache data format');
      // coverage:ignore-end
      return null;
    } catch (e) {
      // coverage:ignore-start
      print('❌ Error retrieving products from cache: $e');
      // coverage:ignore-end
      return null;
    }
  }

  Future<void> clearCache() async {
    await _shopBox.clear();
    await _productBox.clear();
  }
}
