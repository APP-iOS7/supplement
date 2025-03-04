import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supplementary_app/models/user_model.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Firebase 인증 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 구글 로그인 인스턴스
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 사용자 인증 상태 변경 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 현재 로그인된 사용자
  User? get currentUser => _auth.currentUser;

  // 구글 로그인 처리
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
        try {
          // 구글 Provider를 통한 로그인
          print('AuthService: GoogleAuthProvider를 통한 로그인 시도');
          final userCredential = await _auth.signInWithProvider(
            GoogleAuthProvider(),
          );
          print(
            'AuthService: Firebase 로그인 완료 - UID: ${userCredential.user?.uid}',
          );
          return userCredential;
        } catch (providerError) {
          // Provider 방식 오류 시 기존 방식으로 시도
          print('AuthService: Provider 방식 오류, 기존 방식으로 시도 - $providerError');

          // 구글 로그인 흐름 시작
          print('AuthService: GoogleSignIn.signIn() 호출');
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

          // 자동 로그인 상태 저장
          print('AuthService: 자동 로그인 상태 저장');
          await setAutoLogin(true);
          print('AuthService: 자동 로그인 상태 저장 완료');

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

  // 애플 로그인 처리
  Future<UserCredential?> signInWithApple() async {
    try {
      print('AuthService: 애플 로그인 시작');
      // 애플 로그인 서비스의 가용성 확인
      print('AuthService: 애플 로그인 가용성 확인');
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        print('AuthService: 이 기기에서는 Apple 로그인을 사용할 수 없음');
        throw Exception('이 기기에서는 Apple 로그인을 사용할 수 없습니다.');
      }
      print('AuthService: 애플 로그인 서비스 사용 가능');
      // 애플 로그인 요청
      print('AuthService: 애플 ID 인증 요청');
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print('AuthService: 애플 ID 인증 완료');
      // 디버깅 정보 출력
      print(
        'AuthService: 애플 인증 결과 - ID 토큰 있음: ${appleCredential.identityToken != null}',
      );
      print(
        'AuthService: 애플 인증 결과 - 인증 코드 있음: ${appleCredential.authorizationCode != null}',
      );
      print('AuthService: 애플 인증 결과 - 이메일: ${appleCredential.email}');
      print(
        'AuthService: 애플 인증 결과 - 성: ${appleCredential.familyName}, 이름: ${appleCredential.givenName}',
      );
      // Firebase 인증 정보 생성
      print('AuthService: Firebase 인증 정보 생성');
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      // Firebase에 로그인
      print('AuthService: Firebase 로그인 시도');
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      print('AuthService: Firebase 로그인 성공 - UID: ${userCredential.user?.uid}');
      // 사용자 프로필 업데이트 (이름 정보가 있는 경우)
      if (appleCredential.givenName != null && userCredential.user != null) {
        print('AuthService: 사용자 프로필 업데이트 시도');
        String displayName = '';
        if (appleCredential.givenName != null) {
          displayName += appleCredential.givenName!;
        }
        if (appleCredential.familyName != null) {
          if (displayName.isNotEmpty) displayName += ' ';
          displayName += appleCredential.familyName!;
        }
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
          print('AuthService: 사용자 프로필 업데이트 완료 - 이름: $displayName');
        }
      }

      // 자동 로그인 상태 저장
      print('AuthService: 자동 로그인 상태 저장');
      await setAutoLogin(true);
      print('AuthService: 자동 로그인 상태 저장 완료');

      return userCredential;
    } catch (e) {
      print('AuthService: 애플 로그인 에러: $e');
      print('AuthService: 에러 타입: ${e.runtimeType}');
      print('AuthService: 스택 트레이스: ${StackTrace.current}');
      rethrow; // 오류를 호출자에게 전달
    }
  }

  // 사용자 마케팅 동의 정보 저장
  Future<void> saveMarketingAgreement(String uid, bool agreed) async {
    try {
      print('AuthService: Firestore에 마케팅 동의 정보 저장 시작 - UID: $uid, 동의: $agreed');

      // Firestore 문서 경로 확인
      final docRef = _firestore.collection('users').doc(uid);
      print('AuthService: Firestore 문서 경로: ${docRef.path}');

      // 데이터 저장
      await docRef.set({
        'marketingAgreed': agreed,
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
        'isLoggedOut': false, // 로그인 상태 표시
      }, SetOptions(merge: true));

      print('AuthService: 마케팅 동의 정보 저장 완료');
    } catch (e) {
      print('AuthService: 마케팅 동의 정보 저장 오류: $e');
      print('AuthService: 스택 트레이스: ${StackTrace.current}');
      rethrow;
    }
  }

  // 사용자 추가 정보(성별, 생년월일) 저장
  Future<void> saveUserInfo(
    String uid,
    String gender,
    DateTime birthDate,
  ) async {
    try {
      print('AuthService: Firestore에 사용자 정보 저장 시작 - UID: $uid');
      print(
        'AuthService: 저장할 정보 - 성별: $gender, 생년월일: ${birthDate.toIso8601String()}',
      );

      // Firestore 문서 경로 확인
      final docRef = _firestore.collection('users').doc(uid);

      // 저장할 데이터 객체 생성
      final data = {
        'gender': gender,
        'birthDate': birthDate.millisecondsSinceEpoch,
        'lastUpdated': FieldValue.serverTimestamp(),
        'isLoggedOut': false, // 로그인 상태 표시
      };

      // 데이터 저장
      await docRef.set(data, SetOptions(merge: true));
      print('AuthService: 사용자 정보 저장 완료');
    } catch (e) {
      print('AuthService: 사용자 정보 저장 오류: $e');
      print('AuthService: 스택 트레이스: ${StackTrace.current}');
      rethrow;
    }
  }

  // Firestore에서 사용자 정보 가져오기
  Future<UserModel?> getUserData(String uid) async {
    try {
      print('AuthService: 사용자 정보 가져오기 시도 - UID: $uid');
      final doc = await _firestore.collection('users').doc(uid).get();

      print('AuthService: Firestore 문서 존재 여부: ${doc.exists}');
      if (doc.exists && doc.data() != null) {
        print('AuthService: 문서 데이터: ${doc.data()}');
        final userModel = UserModel.fromMap(doc.data()!, uid);
        print(
          'AuthService: 사용자 모델 변환 - 성별: ${userModel.gender}, 생년월일: ${userModel.birthDate}',
        );
        return userModel;
      }

      print('AuthService: 사용자 정보 없음');
      return null;
    } catch (e) {
      print('AuthService: 사용자 정보 가져오기 오류: $e');
      print('AuthService: 스택 트레이스: ${StackTrace.current}');
      return null;
    }
  }

  // auth_service.dart의 signOut 메서드 수정
  Future<void> signOut() async {
    try {
      print('AuthService: 로그아웃 시작');

      // 현재 사용자 확인
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        print('AuthService: 현재 사용자 - ${currentUser.uid}');

        // 1. 로그아웃 상태를 Firestore에 저장 (try-catch로 분리)
        try {
          await _firestore.collection('users').doc(currentUser.uid).set({
            'isLoggedOut': true,
            'lastLogoutTime': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          print('AuthService: 로그아웃 상태 저장 완료');
        } catch (stateError) {
          print('AuthService: 로그아웃 상태 저장 오류 - $stateError');
          // 이 오류는 전체 로그아웃 과정을 중단시키지 않도록 함
        }
      } else {
        print('AuthService: 현재 로그인된 사용자가 없음');
      }

      // 2. 자동 로그인 상태 해제 (try-catch로 분리)
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('autoLogin', false);
        print('AuthService: 자동 로그인 상태 해제 완료');
      } catch (prefError) {
        print('AuthService: 자동 로그인 상태 해제 오류 - $prefError');
        // 이 오류는 전체 로그아웃 과정을 중단시키지 않도록 함
      }

      // 3. 구글 로그인 확인 및 로그아웃 (try-catch로 분리)
      try {
        final isSignedIn = await _googleSignIn.isSignedIn();
        print('AuthService: 구글 로그인 상태 - $isSignedIn');

        if (isSignedIn) {
          await _googleSignIn.signOut();
          print('AuthService: 구글 로그아웃 완료');
        }
      } catch (googleError) {
        print('AuthService: 구글 로그아웃 오류 - $googleError');
        // 이 오류는 전체 로그아웃 과정을 중단시키지 않도록 함
      }

      // 4. Firebase 로그아웃 - 가장 중요한 부분
      print('AuthService: Firebase 로그아웃 시도');
      await _auth.signOut();
      print('AuthService: Firebase 로그아웃 완료');

      print('AuthService: 로그아웃 과정 완료');
    } catch (e) {
      print('AuthService: 로그아웃 오류 - $e');
      print('AuthService: 오류 타입 - ${e.runtimeType}');
      print('AuthService: 스택 트레이스 - ${StackTrace.current}');
      rethrow; // 오류를 호출자에게 전달
    }
  }

  // 자동 로그인 상태 설정
  Future<void> setAutoLogin(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('autoLogin', value);
      print('AuthService: 자동 로그인 상태 설정 - $value');
    } catch (e) {
      print('AuthService: 자동 로그인 상태 설정 오류 - $e');
    }
  }

  // 자동 로그인 상태 확인
  Future<bool> getAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final autoLogin = prefs.getBool('autoLogin') ?? false;
      print('AuthService: 자동 로그인 상태 확인 - $autoLogin');
      return autoLogin;
    } catch (e) {
      print('AuthService: 자동 로그인 상태 확인 오류 - $e');
      return false;
    }
  }

  // 로그아웃 상태 확인
  Future<bool> isLoggedOut(String uid) async {
    try {
      print('AuthService: 로그아웃 상태 확인 - UID: $uid');

      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        final isLoggedOut = doc.data()!['isLoggedOut'] == true;
        print('AuthService: 로그아웃 상태 - $isLoggedOut');
        return isLoggedOut;
      }

      print('AuthService: 사용자 문서 없음, 기본값 false 반환');
      return false;
    } catch (e) {
      print('AuthService: 로그아웃 상태 확인 오류 - $e');
      return false;
    }
  }

  // 로그아웃 상태 제거
  Future<void> clearLogoutState(String uid) async {
    try {
      print('AuthService: 로그아웃 상태 제거 시도 - UID: $uid');

      await _firestore.collection('users').doc(uid).set({
        'isLoggedOut': false,
        'lastLoginTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('AuthService: 로그아웃 상태 제거 완료');
    } catch (e) {
      print('AuthService: 로그아웃 상태 제거 오류 - $e');
    }
  }
}
