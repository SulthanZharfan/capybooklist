import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF262C4F),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFF2F3144),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2F3144),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF262C4F),
        foregroundColor: Colors.white,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF262C4F),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF2F3144),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2F3144),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF262C4F),
        foregroundColor: Colors.white,
      ),
    ),
  );
}
