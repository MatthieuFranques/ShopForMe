import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';
import 'config/theme.dart';

class Shop4MeApp extends StatelessWidget {
  const Shop4MeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop4Me',
      theme: Shop4MeTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}