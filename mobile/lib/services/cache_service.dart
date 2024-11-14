import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../models/shop.dart';

class CacheService {
  static const String shopBox = 'shops';
  static const String productBox = 'products';

  late Box<Shop> _shopBox;
  late Box<List<Product>> _productBox;

  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ShopAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProductAdapter());
    }

    _shopBox = await Hive.openBox<Shop>(shopBox);
    _productBox = await Hive.openBox<List<Product>>(productBox);
  }

  Future<void> cacheShop(Shop shop) async {
    await _shopBox.put(shop.id.toString(), shop);
  }

  Shop? getShop(int id) {
    return _shopBox.get(id.toString());
  }

  Future<void> cacheProducts(String key, List<Product> products) async {
    await _productBox.put(key, products);
  }

  List<Product>? getProducts(String key) {
    return _productBox.get(key);
  }

  Future<void> clearCache() async {
    await _shopBox.clear();
    await _productBox.clear();
  }
}