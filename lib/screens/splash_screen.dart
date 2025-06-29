import 'package:flutter/material.dart';
import 'package:capybooklist/db/user_dao.dart';
import 'package:capybooklist/models/user.dart';
import 'package:capybooklist/screens/home_screen.dart';
import 'package:capybooklist/screens/user_profile_screen.dart';
import 'package:capybooklist/screens/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi loading

    final user = await UserDao().getUser();
    if (!mounted) return;

    if (user == null) {
      // User belum diisi -> ke form profile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserProfileScreen()),
      );
    } else {
      // User sudah ada -> ke home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_rounded, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              'Capybooklist',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Organize your books with capy style!'),
          ],
        ),
      ),
    );
  }
}
