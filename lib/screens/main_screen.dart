import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supplementary_app/screens/home/home_screen.dart';
import 'package:supplementary_app/screens/mypage/mypage_screen.dart';
import 'package:supplementary_app/screens/search/search_screen.dart';
import 'package:supplementary_app/services/auth_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 현재 선택된 탭 인덱스
  int _currentIndex = 0;

  // 각 탭에 해당하는 화면 위젯들
  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const MypageScreen(),
  ];

  // 인증 서비스
  final AuthService _authService = AuthService();

  // 로그아웃 함수
  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      // 로그아웃 성공 메시지 (개발용)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('로그아웃 완료')));
      }
    } catch (e) {
      // 로그아웃 실패 메시지
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그아웃 오류: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("영양제 추천"),
        actions: [
          // 로그아웃 버튼 (개발용)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: "로그아웃",
          ),
        ],
      ),
      // 현재 선택된 탭에 해당하는 화면 표시
      body: _pages[_currentIndex],
      // 하단 탭 네비게이션
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
