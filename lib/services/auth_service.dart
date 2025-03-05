import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String get currentUserUid => _auth.currentUser!.uid;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('AuthService: 구글 로그인 시작');
      print(
        'AuthService: 플랫폼 - ${Platform.isAndroid
            ? "Android"
            : Platform.isIOS
            ? "iOS"
            : "기타"}',
      );

      // 먼저 기존 로그인 상태 초기화 시도
      try {
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.disconnect(); // 모든 계정 연결 해제
          await _googleSignIn.signOut();
          print('AuthService: 기존 구글 로그인 상태 초기화 완료');
        }
      } catch (e) {
        print('AuthService: 기존 로그인 상태 초기화 오류 - $e');
      }

      // 안드로이드와 iOS에서 플랫폼별 처리 방식 분리
      if (Platform.isAndroid) {
        // Android에서는 일반적인 구글 로그인 방식 사용
        print('AuthService: Android 방식으로 구글 로그인 시도');

        // 구글 로그인 흐름 시작
        print('AuthService: GoogleSignIn.signIn() 호출');
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          // 사용자가 로그인을 취소한 경우
          print('AuthService: 사용자가 구글 로그인을 취소함');
          return null;
        }

        print('AuthService: 구글 계정 선택 완료 - ${googleUser.email}');

        // 구글 인증 정보 획득
        print('AuthService: 구글 인증 정보 요청');
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        print('AuthService: 구글 인증 정보 획득 완료');

        // Firebase 인증 정보 생성
        print('AuthService: Firebase 인증 정보 생성');
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebase에 로그인
        print('AuthService: Firebase 로그인 시도');
        final userCredential = await _auth.signInWithCredential(credential);
        print(
          'AuthService: Firebase 로그인 완료 - UID: ${userCredential.user?.uid}',
        );

        return userCredential;
      } else if (Platform.isIOS) {
        // iOS에서는 Firebase Auth의 내장 Provider 방식 사용 시도
        print('AuthService: iOS 방식으로 구글 로그인 시도');

        // 구글 로그인의 웹뷰 캐시 강제 삭제를 위한 설정
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({
          'prompt': 'select_account', // 계정 선택 화면 강제 표시
          'login_hint': '', // 이전 이메일 힌트 제거
          'access_type': 'offline', // 새 토큰 발급 요청
        });

        try {
          // 수정된 Provider를 통한 로그인 시도
          print('AuthService: GoogleAuthProvider를 통한 로그인 시도');
          final userCredential = await _auth.signInWithProvider(googleProvider);
          print(
            'AuthService: Firebase 로그인 완료 - UID: ${userCredential.user?.uid}',
          );
          return userCredential;
        } catch (providerError) {
          // Provider 방식 오류 시 기존 방식으로 시도
          print('AuthService: Provider 방식 오류, 기존 방식으로 시도 - $providerError');

          // 구글 로그인 흐름 시작
          print('AuthService: GoogleSignIn.signIn() 호출');

          // 기존 세션 초기화 시도
          await _googleSignIn.signOut();

          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

          if (googleUser == null) {
            print('AuthService: 사용자가 구글 로그인을 취소함');
            return null;
          }

          print('AuthService: 구글 계정 선택 완료 - ${googleUser.email}');

          // 구글 인증 정보 획득
          print('AuthService: 구글 인증 정보 요청');
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          print('AuthService: 구글 인증 정보 획득 완료');

          // Firebase 인증 정보 생성
          print('AuthService: Firebase 인증 정보 생성');
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Firebase에 로그인
          print('AuthService: Firebase 로그인 시도');
          final userCredential = await _auth.signInWithCredential(credential);
          print(
            'AuthService: Firebase 로그인 완료 - UID: ${userCredential.user?.uid}',
          );

          return userCredential;
        }
      } else {
        // 다른 플랫폼 (예: 웹, 데스크톱)은 현재 지원하지 않음
        throw Exception('지원하지 않는 플랫폼입니다.');
      }
    } catch (e) {
      print('AuthService: 구글 로그인 에러: $e');
      print('AuthService: 에러 타입: ${e.runtimeType}');
      print('AuthService: 스택 트레이스: ${StackTrace.current}');
      rethrow; // 오류를 호출자에게 전달
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
