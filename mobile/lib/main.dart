import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'services/store_service.dart';
import 'services/cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation de Hive et des services
  await Hive.initFlutter();
  final cacheService = CacheService();
  await cacheService.init();
  final storeService = StoreService(cacheService);  // Passer cacheService

  runApp(
    Shop4MeApp(
      storeService: storeService,
      cacheService: cacheService,
    ),
  );
}