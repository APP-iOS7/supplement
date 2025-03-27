import 'package:flutter/material.dart';
import 'package:supplementary_app/screens/home/home_screen.dart';
import 'package:supplementary_app/screens/search/search_screen.dart';
import 'package:supplementary_app/screens/settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: '검색',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
