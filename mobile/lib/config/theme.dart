import 'package:flutter/material.dart';
import 'package:mobile/utils/screen_utils.dart';

class Shop4MeTheme {
  static ThemeData getLightTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color.fromARGB(255, 242, 72, 34),
        secondary: const Color.fromARGB(255, 18, 67, 166),
        tertiary: const Color.fromARGB(255, 1, 28, 64),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 242, 238, 216),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 242, 72, 34)),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 18, 67, 166),
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color.fromARGB(255, 29, 100, 242),
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.getResponsiveSize(8)),
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: context.getResponsiveFontSize(32), fontWeight: FontWeight.bold, color: Colors.black),
        headlineMedium: TextStyle(fontSize: context.getResponsiveFontSize(24), fontWeight: FontWeight.bold, color: Colors.black),
        titleLarge: TextStyle(fontSize: context.getResponsiveFontSize(20), fontWeight: FontWeight.bold, color: Colors.black),
        bodyLarge: TextStyle(fontSize: context.getResponsiveFontSize(16), color: Colors.black),
        bodyMedium: TextStyle(fontSize: context.getResponsiveFontSize(14), color: Colors.black),
      ),
    );
  }
}