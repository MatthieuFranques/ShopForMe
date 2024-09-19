import 'package:flutter/material.dart';

class Shop4MeTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: Colors.orange,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(fontSize: 16),
      ),
    );
  }
}