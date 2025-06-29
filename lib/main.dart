import 'package:flutter/material.dart';
import 'package:capybooklist/screens/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CapyBookList',
      home: const MainNavigationScreen(),
    );
  }
}
