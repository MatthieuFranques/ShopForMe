// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(ProductAdapter());
  }



  runApp(
    const Shop4MeApp(),
  );
}
}