import 'package:flutter/material.dart';
import 'package:supplementary_app/screens/home/home_screen.dart';
import 'package:supplementary_app/screens/mypage/mypage_screen.dart';
import 'package:supplementary_app/screens/search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainPageState();
}

class _MainPageState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [HomeScreen(), SearchScreen(), MypageScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.pin_drop), label: 'My Page'),
        ],
      ),
    );
  }
}
