import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplementary_app/screens/home/home_screen.dart';
import 'package:supplementary_app/screens/mypage/mypage_screen.dart';
import 'package:supplementary_app/screens/search/search_screen.dart';
import 'package:supplementary_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplementary_app/screens/login/login_screen.dart';

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

  // 로그아웃 메서드
  // main_screen.dart에서 _signOutDirect 메서드 개선
  Future<void> _signOutDirect() async {
    try {
      print('MainScreen: 직접 로그아웃 시도');

      // 로딩 표시 (선택사항)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('로그아웃 중...'),
                ],
              ),
            ),
      );

      // 현재 사용자의 UID 저장
      final String? uid = FirebaseAuth.instance.currentUser?.uid;

      // 1. 구글 로그인 상태 확인 및 로그아웃 처리 강화
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.disconnect(); // 모든 계정 연결 해제
        await googleSignIn.signOut();
        print('MainScreen: Google 로그아웃 완료');
      } catch (e) {
        print('MainScreen: Google 로그아웃 오류 - $e');
      }

      // 2. 자동 로그인 해제
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('autoLogin', false);
        print('MainScreen: 자동 로그인 해제 완료');
      } catch (e) {
        print('MainScreen: 자동 로그인 해제 오류 - $e');
      }

      // 3. Firebase 로그아웃
      await FirebaseAuth.instance.signOut();
      print('MainScreen: Firebase 로그아웃 완료');

      // 4. UID가 있으면 Firestore에 로그아웃 상태 저장
      if (uid != null) {
        try {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'isLoggedOut': true,
            'lastLogoutTime': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          print('MainScreen: Firestore 로그아웃 상태 저장 완료');
        } catch (e) {
          print('MainScreen: Firestore 상태 저장 오류 - $e');
        }
      }

      print('MainScreen: 직접 로그아웃 성공');

      // 로딩 다이얼로그 닫기
      if (mounted) {
        Navigator.of(context).pop();
      }

      // 로그인 화면으로 이동
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      // 로딩 다이얼로그 닫기
      if (mounted) {
        Navigator.of(context).pop();
      }

      print('MainScreen: 직접 로그아웃 오류 - $e');

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
            onPressed: _signOutDirect,
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
