import 'package:flutter/material.dart';

class Shop4MeTheme {
  static ThemeData getTheme({required FontSize fontSize}) {
    final baseTextTheme = _getBaseTextTheme(fontSize);

    return ThemeData(
      primaryColor: Colors.blue[900],
      scaffoldBackgroundColor: const Color(0xFFF5F5DC),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: const Color(0xFFF24822),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF011C40),
        foregroundColor: Colors.white,
      ),
      textTheme: baseTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static TextTheme _getBaseTextTheme(FontSize fontSize) {
    final double scaleFactor = _getFontScaleFactor(fontSize);
    return TextTheme(
      headlineMedium: TextStyle(
          fontSize: 24 * scaleFactor,
          fontWeight: FontWeight.bold,
          color: Colors.black),
      titleLarge: TextStyle(
          fontSize: 20 * scaleFactor,
          fontWeight: FontWeight.bold,
          color: Colors.black),
      bodyLarge: TextStyle(fontSize: 16 * scaleFactor, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14 * scaleFactor, color: Colors.black),
    );
  }

  static double _getFontScaleFactor(FontSize fontSize) {
    switch (fontSize) {
      case FontSize.small:
        return 0.8;
      case FontSize.medium:
        return 1.0;
      case FontSize.large:
        return 1.2;
    }
  }
}

enum FontSize { small, medium, large }
