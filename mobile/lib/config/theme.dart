import 'package:flutter/material.dart';
class Shop4MeTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color.fromARGB(255, 242, 72, 34), 
        secondary: const Color.fromARGB(255, 18, 67, 166),
        tertiary: const Color.fromARGB(255, 1, 28, 64), 
      ),

      //Fond de l'application
      scaffoldBackgroundColor: const Color.fromARGB(255, 242, 238, 216),

      //Bouton principal
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          // Bouton principal
          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 242, 72, 34)), 
          foregroundColor: MaterialStateProperty.all(Colors.white), 
        ),
      ),

      //Bouton secondaire
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 18, 67, 166), 
          foregroundColor: Colors.white, 
        ),
      ),

      //Champ de recherche
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color.fromARGB(255, 29, 100, 242), 
        hintStyle: const TextStyle(color: Colors.white), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, 
        ),
      ),
    );
  }
}