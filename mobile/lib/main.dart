// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/cache_service.dart';
import 'services/store_service.dart';
import 'models/shop.dart';
import 'models/product.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ShopAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ShopCellAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(ProductAdapter());
  }

  final cacheService = CacheService();
  await cacheService.init();

  final storeService = StoreService(cacheService);

  runApp(
    Shop4MeApp(
      storeService: storeService,
      cacheService: cacheService,
    ),
  );
}
