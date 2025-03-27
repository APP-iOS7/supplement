import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();
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
          await _googleSignIn.disconnect();
          await _googleSignIn.signOut();
          print('AuthService: 기존 구글 로그인 상태 초기화 완료');
        }
      } catch (e) {
        print('AuthService: 기존 로그인 상태 초기화 오류 - $e');
        // 초기화 오류는 무시하고 계속 진행
      }

      if (Platform.isAndroid) {
        try {
          print('AuthService: Android 방식으로 구글 로그인 시도');
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

          if (googleUser == null) {
            print('AuthService: 사용자가 구글 로그인을 취소함');
            return null;
          }

          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          return await _auth.signInWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          print('AuthService: Firebase 인증 오류 - ${e.message}');
          return null;
        } catch (e) {
          print('AuthService: 구글 로그인 오류 - $e');
          return null;
        }
      } else if (Platform.isIOS) {
        try {
          GoogleAuthProvider googleProvider = GoogleAuthProvider();
          googleProvider.setCustomParameters({
            'prompt': 'select_account',
            'login_hint': '',
            'access_type': 'offline',
          });

          try {
            return await _auth.signInWithProvider(googleProvider);
          } catch (providerError) {
            print('AuthService: Provider 방식 오류, 기존 방식으로 시도 - $providerError');

            await _googleSignIn.signOut();
            final GoogleSignInAccount? googleUser =
                await _googleSignIn.signIn();

            if (googleUser == null) {
              print('AuthService: 사용자가 구글 로그인을 취소함');
              return null;
            }

            final GoogleSignInAuthentication googleAuth =
                await googleUser.authentication;
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            return await _auth.signInWithCredential(credential);
          }
        } on FirebaseAuthException catch (e) {
          print('AuthService: Firebase 인증 오류 - ${e.message}');
          return null;
        } catch (e) {
          print('AuthService: iOS 구글 로그인 오류 - $e');
          return null;
        }
      } else {
        print('AuthService: 지원하지 않는 플랫폼');
        return null;
      }
    } catch (e) {
      print('AuthService: 예상치 못한 오류 - $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      print('AuthService: 애플 로그인 시작');

      if (!await SignInWithApple.isAvailable()) {
        print('AuthService: 이 기기에서는 Apple 로그인을 사용할 수 없음');
        return null;
      }

      try {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        if (appleCredential.identityToken == null) {
          print('AuthService: 애플 로그인 취소됨');
          return null;
        }

        final oauthCredential = OAuthProvider('apple.com').credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        return await _auth.signInWithCredential(oauthCredential);
      } on SignInWithAppleAuthorizationException catch (e) {
        print('AuthService: 애플 로그인 인증 오류 - ${e.message}');
        return null;
      } on FirebaseAuthException catch (e) {
        print('AuthService: Firebase 인증 오류 - ${e.message}');
        return null;
      }
    } catch (e) {
      print('AuthService: 예상치 못한 오류 - $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
