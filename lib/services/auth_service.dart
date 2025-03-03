import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supplementary_app/models/user_model.dart';

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
      // 구글 로그인 흐름 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // 사용자가 로그인을 취소한 경우
        return null;
      }

      // 구글 인증 정보 획득
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase 인증 정보 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('구글 로그인 에러: $e');
      rethrow; // 오류를 호출자에게 전달
    }
  }

  // 애플 로그인 처리
  Future<UserCredential?> signInWithApple() async {
    try {
      // 애플 로그인 서비스의 가용성 확인
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        throw Exception('이 기기에서는 Apple 로그인을 사용할 수 없습니다.');
      }

      // 애플 로그인 요청
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Firebase 인증 정보 생성
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Firebase에 로그인
      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      print('애플 로그인 에러: $e');
      rethrow; // 오류를 호출자에게 전달
    }
  }

  // 사용자 마케팅 동의 정보 저장
  Future<void> saveMarketingAgreement(String uid, bool agreed) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'marketingAgreed': agreed,
      }, SetOptions(merge: true));
    } catch (e) {
      print('마케팅 동의 정보 저장 오류: $e');
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
      await _firestore.collection('users').doc(uid).set({
        'gender': gender,
        'birthDate': birthDate.millisecondsSinceEpoch,
      }, SetOptions(merge: true));
    } catch (e) {
      print('사용자 정보 저장 오류: $e');
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
