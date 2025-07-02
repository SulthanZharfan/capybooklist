import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'home_screen.dart';
import 'book_form_screen.dart';
import 'user_profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    BookFormScreen(),
    UserProfileScreen(),
  ];

  final List<NavigationRailDestination> _railDestinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.home),
      selectedIcon: Icon(Icons.home, color: Colors.white),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.add_box),
      selectedIcon: Icon(Icons.add_box, color: Colors.white),
      label: Text('Add'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.person),
      selectedIcon: Icon(Icons.person, color: Colors.white),
      label: Text('Account'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      extendBody: true,
      body: isPortrait
          ? _screens[_selectedIndex]
          : Row(
        children: [
          // SIDE NAVIGATION RAIL
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: const Color(0xFF262C4F).withOpacity(0.9),
            selectedIconTheme: const IconThemeData(color: Colors.white, size: 28),
            unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 24),
            selectedLabelTextStyle: const TextStyle(color: Colors.white),
            unselectedLabelTextStyle: const TextStyle(color: Colors.grey),
            labelType: NavigationRailLabelType.all,
            destinations: _railDestinations,
          ),

          // MAIN CONTENT
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),

      bottomNavigationBar: isPortrait
          ? CurvedNavigationBar(
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        color: const Color(0xFF262C4F),
        buttonBackgroundColor: const Color(0xFF362A84),
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.add_box, color: Colors.white, size: 30),
          Icon(Icons.person, color: Colors.white, size: 30),
        ],
      )
          : null,
    );
  }
}
