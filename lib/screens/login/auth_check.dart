// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplementary_app/screens/login/get_info_screen.dart';
import 'package:supplementary_app/screens/main_screen.dart';
import 'package:supplementary_app/services/auth_service.dart';

class AuthCheck {
  // 인증 서비스 인스턴스
  final AuthService _authService = AuthService();

  // Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 자동 로그인 체크
  Future<void> checkAuthState(BuildContext context) async {
    print('AuthCheck: 인증 상태 확인 시작');
    User? user = _authService.currentUser;

    if (user != null) {
      try {
        print('AuthCheck: 사용자 UID - ${user.uid}');
        final doc = await _firestore.collection('users').doc(user.uid).get();
        final isLoggedOut = doc.data()?['isLoggedOut'] == true;
        print('AuthCheck: isLoggedOut = $isLoggedOut');

        if (!isLoggedOut) {
          print('AuthCheck: 자동 로그인 진행');
          final userData = await _authService.getUserData(user.uid);
          print('AuthCheck: 사용자 데이터 - $userData');

          if (userData != null &&
              userData.gender != null &&
              userData.birthDate != null) {
            if (context.mounted) {
              print('AuthCheck: 메인 화면으로 이동');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            }
          } else {
            if (context.mounted) {
              print('AuthCheck: 정보 입력 화면으로 이동');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const GetInfoScreen()),
              );
            }
          }
        } else {
          print('AuthCheck: 로그아웃 상태, 자동 로그인 중지');
        }
      } catch (e) {
        print('AuthCheck: 로그인 상태 확인 오류 - $e');
      }
    } else {
      print('AuthCheck: 로그인된 사용자 없음');
    }
    print('AuthCheck: 인증 상태 확인 완료');
  }

  // 사용자 정보 확인
  Future<bool> hasUserInfo(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();
      final isLoggedOut = data?['isLoggedOut'] == true || data == null;
      print('AuthCheck: Firestore 데이터 - $data, isLoggedOut = $isLoggedOut');

      if (doc.exists && doc.data() != null) {
        final gender = doc.data()!['gender'];
        final birthDate = doc.data()!['birthDate'];

        return gender != null && birthDate != null;
      }

      return false;
    } catch (e) {
      print('AuthCheck: 사용자 정보 확인 오류 - $e'); // 디버깅 로그
      return false;
    }
  }
}
