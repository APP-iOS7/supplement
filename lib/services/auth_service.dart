import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supplementary_app/models/user_model.dart';
import 'dart:io' show Platform;

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
      print('AuthService: 구글 로그인 시작'); // 디버깅 로그
      print(
        'AuthService: 플랫폼 - ${Platform.isAndroid
            ? "Android"
            : Platform.isIOS
            ? "iOS"
            : "기타"}',
      ); // 디버깅 로그

      // 안드로이드와 iOS에서 플랫폼별 처리 방식 분리
      if (Platform.isAndroid) {
        // Android에서는 일반적인 구글 로그인 방식 사용
        print('AuthService: Android 방식으로 구글 로그인 시도'); // 디버깅 로그

        // 구글 로그인 흐름 시작
        print('AuthService: GoogleSignIn.signIn() 호출'); // 디버깅 로그
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          // 사용자가 로그인을 취소한
          print('AuthService: 사용자가 구글 로그인을 취소함'); // 디버깅 로그
          return null;
        }

        print('AuthService: 구글 계정 선택 완료 - ${googleUser.email}'); // 디버깅 로그

        // 구글 인증 정보 획득
        print('AuthService: 구글 인증 정보 요청'); // 디버깅 로그
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        print('AuthService: 구글 인증 정보 획득 완료'); // 디버깅 로그

        // Firebase 인증 정보 생성
        print('AuthService: Firebase 인증 정보 생성'); // 디버깅 로그
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebase에 로그인
        print('AuthService: Firebase 로그인 시도'); // 디버깅 로그
        final userCredential = await _auth.signInWithCredential(credential);
        print(
          'AuthService: Firebase 로그인 완료 - UID: ${userCredential.user?.uid}',
        ); // 디버깅 로그

        return userCredential;
      } else if (Platform.isIOS) {
        // iOS에서는 Firebase Auth의 내장 Provider 방식 사용 시도
        print('AuthService: iOS 방식으로 구글 로그인 시도'); // 디버깅 로그
        try {
          // 구글 Provider를 통한 로그인
          print('AuthService: GoogleAuthProvider를 통한 로그인 시도'); // 디버깅 로그
          final userCredential = await _auth.signInWithProvider(
            GoogleAuthProvider(),
          );
          print(
            'AuthService: Firebase 로그인 완료 - UID: ${userCredential.user?.uid}',
          ); // 디버깅 로그
          return userCredential;
        } catch (providerError) {
          // Provider 방식 오류 시 기존 방식으로 시도
          print(
            'AuthService: Provider 방식 오류, 기존 방식으로 시도 - $providerError',
          ); // 디버깅 로그

          // 구글 로그인 흐름 시작
          print('AuthService: GoogleSignIn.signIn() 호출'); // 디버깅 로그
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

          if (googleUser == null) {
            print('AuthService: 사용자가 구글 로그인을 취소함'); // 디버깅 로그
            return null;
          }

          print('AuthService: 구글 계정 선택 완료 - ${googleUser.email}'); // 디버깅 로그

          // 구글 인증 정보 획득
          print('AuthService: 구글 인증 정보 요청'); // 디버깅 로그
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          print('AuthService: 구글 인증 정보 획득 완료'); // 디버깅 로그

          // Firebase 인증 정보 생성
          print('AuthService: Firebase 인증 정보 생성'); // 디버깅 로그
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Firebase에 로그인
          print('AuthService: Firebase 로그인 시도'); // 디버깅 로그
          final userCredential = await _auth.signInWithCredential(credential);
          print(
            'AuthService: Firebase 로그인 완료 - UID: ${userCredential.user?.uid}',
          ); // 디버깅 로그

          return userCredential;
        }
      } else {
        // 다른 플랫폼 (예: 웹, 데스크톱)은 현재 지원하지 않음
        throw Exception('지원하지 않는 플랫폼입니다.');
      }
    } catch (e) {
      print('AuthService: 구글 로그인 에러: $e'); // 디버깅 로그
      print('AuthService: 에러 타입: ${e.runtimeType}'); // 디버깅 로그
      print('AuthService: 스택 트레이스: ${StackTrace.current}'); // 스택 트레이스 출력
      rethrow; // 오류를 호출자에게 전달
    }
  }

  // 애플 로그인 처리
  Future<UserCredential?> signInWithApple() async {
    try {
      print('AuthService: 애플 로그인 시작'); // 디버깅 로그

      // 애플 로그인 서비스의 가용성 확인
      print('AuthService: 애플 로그인 가용성 확인'); // 디버깅 로그
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        print('AuthService: 이 기기에서는 Apple 로그인을 사용할 수 없음'); // 디버깅 로그
        throw Exception('이 기기에서는 Apple 로그인을 사용할 수 없습니다.');
      }
      print('AuthService: 애플 로그인 서비스 사용 가능'); // 디버깅 로그

      // 애플 로그인 요청
      print('AuthService: 애플 ID 인증 요청'); // 디버깅 로그
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print('AuthService: 애플 ID 인증 완료'); // 디버깅 로그

      // 디버깅 정보 출력
      print(
        'AuthService: 애플 인증 결과 - ID 토큰 있음: ${appleCredential.identityToken != null}',
      ); // 디버깅 로그
      print(
        'AuthService: 애플 인증 결과 - 인증 코드 있음: ${appleCredential.authorizationCode != null}',
      ); // 디버깅 로그
      print('AuthService: 애플 인증 결과 - 이메일: ${appleCredential.email}'); // 디버깅 로그
      print(
        'AuthService: 애플 인증 결과 - 성: ${appleCredential.familyName}, 이름: ${appleCredential.givenName}',
      ); // 디버깅 로그

      // Firebase 인증 정보 생성
      print('AuthService: Firebase 인증 정보 생성'); // 디버깅 로그
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Firebase에 로그인
      print('AuthService: Firebase 로그인 시도'); // 디버깅 로그
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      print(
        'AuthService: Firebase 로그인 성공 - UID: ${userCredential.user?.uid}',
      ); // 디버깅 로그

      // 사용자 프로필 업데이트 (이름 정보가 있는 경우)
      if (appleCredential.givenName != null && userCredential.user != null) {
        print('AuthService: 사용자 프로필 업데이트 시도'); // 디버깅 로그
        String displayName = '';
        if (appleCredential.givenName != null)
          displayName += appleCredential.givenName!;
        if (appleCredential.familyName != null) {
          if (displayName.isNotEmpty) displayName += ' ';
          displayName += appleCredential.familyName!;
        }

        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
          print('AuthService: 사용자 프로필 업데이트 완료 - 이름: $displayName'); // 디버깅 로그
        }
      }

      return userCredential;
    } catch (e) {
      print('AuthService: 애플 로그인 에러: $e'); // 디버깅 로그
      print('AuthService: 에러 타입: ${e.runtimeType}'); // 디버깅 로그
      print('AuthService: 스택 트레이스: ${StackTrace.current}'); // 스택 트레이스 출력
      rethrow; // 오류를 호출자에게 전달
    }
  }

  // 사용자 마케팅 동의 정보 저장
  Future<void> saveMarketingAgreement(String uid, bool agreed) async {
    try {
      print(
        'AuthService: Firestore에 마케팅 동의 정보 저장 시작 - UID: $uid, 동의: $agreed',
      ); // 디버깅 로그

      // Firestore 문서 경로 확인
      final docRef = _firestore.collection('users').doc(uid);
      print('AuthService: Firestore 문서 경로: ${docRef.path}'); // 디버깅 로그

      // 데이터 저장
      await docRef.set({
        'marketingAgreed': agreed,
        'createdAt': FieldValue.serverTimestamp(), // 생성 시간 추가
        'lastUpdated': FieldValue.serverTimestamp(), // 마지막 업데이트 시간
      }, SetOptions(merge: true));

      // 저장 확인
      final docSnapshot = await docRef.get();
      print(
        'AuthService: Firestore 문서 저장 후 확인 - 존재함: ${docSnapshot.exists}',
      ); // 디버깅 로그
      if (docSnapshot.exists) {
        print('AuthService: 저장된 데이터: ${docSnapshot.data()}'); // 디버깅 로그
      }
    } catch (e) {
      print('AuthService: 마케팅 동의 정보 저장 오류: $e'); // 디버깅 로그
      print('AuthService: 스택 트레이스: ${StackTrace.current}'); // 스택 트레이스 출력
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
      print('AuthService: Firestore에 사용자 정보 저장 시작 - UID: $uid'); // 디버깅 로그
      print(
        'AuthService: 저장할 정보 - 성별: $gender, 생년월일: ${birthDate.toIso8601String()}',
      ); // 디버깅 로그

      // Firestore 문서 경로 확인
      final docRef = _firestore.collection('users').doc(uid);
      print('AuthService: Firestore 문서 경로: ${docRef.path}'); // 디버깅 로그

      // 데이터 저장
      await docRef.set({
        'gender': gender,
        'birthDate': birthDate.millisecondsSinceEpoch,
        'lastUpdated': FieldValue.serverTimestamp(), // 마지막 업데이트 시간
      }, SetOptions(merge: true));

      // 저장 확인
      final docSnapshot = await docRef.get();
      print(
        'AuthService: Firestore 문서 저장 후 확인 - 존재함: ${docSnapshot.exists}',
      ); // 디버깅 로그
      if (docSnapshot.exists) {
        print('AuthService: 저장된 데이터: ${docSnapshot.data()}'); // 디버깅 로그
      }
    } catch (e) {
      print('AuthService: 사용자 정보 저장 오류: $e'); // 디버깅 로그
      print('AuthService: 스택 트레이스: ${StackTrace.current}'); // 스택 트레이스 출력
      rethrow;
    }
  }

  // Firestore에서 사용자 정보 가져오기
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      print('사용자 정보 가져오기 오류: $e');
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // 구글 로그인 상태도 함께 로그아웃
      await _auth.signOut();
    } catch (e) {
      print('로그아웃 오류: $e');
      rethrow;
    }
  }
}
