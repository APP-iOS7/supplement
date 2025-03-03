// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthStateService {
  // Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 로그아웃 상태 설정
  Future<void> setLogoutState(String uid) async {
    try {
      print('AuthStateService: 로그아웃 상태 설정 시도 - UID: $uid'); // 디버깅 로그

      await _firestore.collection('users').doc(uid).set({
        'isLoggedOut': true,
        'lastLogoutTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('AuthStateService: 로그아웃 상태 설정 완료'); // 디버깅 로그
    } catch (e) {
      print('AuthStateService: 로그아웃 상태 설정 오류 - $e'); // 디버깅 로그
      print('AuthStateService: 스택 트레이스: ${StackTrace.current}'); // 디버깅 로그
    }
  }

  // 로그아웃 상태 제거
  Future<void> clearLogoutState(String uid) async {
    try {
      print('AuthStateService: 로그아웃 상태 제거 시도 - UID: $uid'); // 디버깅 로그

      await _firestore.collection('users').doc(uid).set({
        'isLoggedOut': false,
        'lastLoginTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('AuthStateService: 로그아웃 상태 제거 완료'); // 디버깅 로그
    } catch (e) {
      print('AuthStateService: 로그아웃 상태 제거 오류 - $e'); // 디버깅 로그
      print('AuthStateService: 스택 트레이스: ${StackTrace.current}'); // 디버깅 로그
    }
  }

  // 로그아웃 상태 확인
  Future<bool> isLoggedOut(String uid) async {
    try {
      print('AuthStateService: 로그아웃 상태 확인 - UID: $uid'); // 디버깅 로그

      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        final isLoggedOut = doc.data()!['isLoggedOut'] == true;
        print('AuthStateService: 로그아웃 상태 - $isLoggedOut'); // 디버깅 로그
        return isLoggedOut;
      }

      print('AuthStateService: 사용자 문서 없음, 기본값 false 반환'); // 디버깅 로그
      return false;
    } catch (e) {
      print('AuthStateService: 로그아웃 상태 확인 오류 - $e'); // 디버깅 로그
      print('AuthStateService: 스택 트레이스: ${StackTrace.current}'); // 디버깅 로그
      return false;
    }
  }
}
