import 'package:flutter/material.dart';
import 'package:capybooklist/config/theme.dart';
import 'package:capybooklist/screens/splash_screen.dart';

void main() {
  runApp(const CapyBooklistApp());
}

class CapyBooklistApp extends StatelessWidget {
  const CapyBooklistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capybooklist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Material 3 dari theme.dart
      home: const SplashScreen(),  // Layar awal
    );
  }
}
