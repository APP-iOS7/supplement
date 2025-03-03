// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplementary_app/models/user_model.dart';

class UserService {
  // Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 사용자 마케팅 동의 정보 저장
  Future<void> saveMarketingAgreement(String uid, bool agreed) async {
    try {
      print(
        'UserService: Firestore에 마케팅 동의 정보 저장 시작 - UID: $uid, 동의: $agreed',
      ); // 디버깅 로그

      // Firestore 문서 경로 확인
      final docRef = _firestore.collection('users').doc(uid);
      print('UserService: Firestore 문서 경로: ${docRef.path}'); // 디버깅 로그

      // 데이터 저장
      await docRef.set({
        'marketingAgreed': agreed,
        'createdAt': FieldValue.serverTimestamp(), // 생성 시간 추가
        'lastUpdated': FieldValue.serverTimestamp(), // 마지막 업데이트 시간
      }, SetOptions(merge: true));

      // 저장 확인
      final docSnapshot = await docRef.get();
      print(
        'UserService: Firestore 문서 저장 후 확인 - 존재함: ${docSnapshot.exists}',
      ); // 디버깅 로그
      if (docSnapshot.exists) {
        print('UserService: 저장된 데이터: ${docSnapshot.data()}'); // 디버깅 로그
      }
    } catch (e) {
      print('UserService: 마케팅 동의 정보 저장 오류: $e'); // 디버깅 로그
      print('UserService: 스택 트레이스: ${StackTrace.current}'); // 스택 트레이스 출력
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
      print('UserService: Firestore에 사용자 정보 저장 시작 - UID: $uid'); // 디버깅 로그
      print(
        'UserService: 저장할 정보 - 성별: $gender, 생년월일: ${birthDate.toIso8601String()}',
      ); // 디버깅 로그

      // Firestore 문서 경로 확인
      final docRef = _firestore.collection('users').doc(uid);
      print('UserService: Firestore 문서 경로: ${docRef.path}'); // 디버깅 로그

      // 저장할 데이터 객체 생성
      final data = {
        'gender': gender,
        'birthDate': birthDate.millisecondsSinceEpoch,
        'lastUpdated': FieldValue.serverTimestamp(), // 마지막 업데이트 시간
      };
      print('UserService: 저장할 데이터 객체: $data'); // 디버깅 로그

      // 데이터 저장 시도
      try {
        print('UserService: Firestore 데이터 저장 시도...'); // 디버깅 로그
        await docRef.set(data, SetOptions(merge: true));
        print('UserService: Firestore 데이터 저장 성공'); // 디버깅 로그
      } catch (setError) {
        print('UserService: Firestore set 작업 오류: $setError'); // 디버깅 로그
        print('UserService: 오류 타입: ${setError.runtimeType}'); // 디버깅 로그
        rethrow;
      }

      // 저장 확인
      try {
        print('UserService: 저장된 데이터 확인 시도...'); // 디버깅 로그
        final docSnapshot = await docRef.get();
        print(
          'UserService: Firestore 문서 존재 여부: ${docSnapshot.exists}',
        ); // 디버깅 로그
        if (docSnapshot.exists) {
          print('UserService: 저장된 데이터: ${docSnapshot.data()}'); // 디버깅 로그
        } else {
          print('UserService: 문서가 존재하지 않음 - 저장 실패'); // 디버깅 로그
        }
      } catch (getError) {
        print('UserService: 저장 확인 중 오류: $getError'); // 디버깅 로그
      }
    } catch (e) {
      print('UserService: 사용자 정보 저장 오류: $e'); // 디버깅 로그
      print('UserService: 스택 트레이스: ${StackTrace.current}'); // 스택 트레이스 출력
      rethrow;
    }
  }

  // Firestore에서 사용자 정보 가져오기
  Future<UserModel?> getUserData(String uid) async {
    try {
      print('UserService: 사용자 정보 가져오기 시도 - UID: $uid'); // 디버깅 로그
      final doc = await _firestore.collection('users').doc(uid).get();

      print('UserService: Firestore 문서 존재 여부: ${doc.exists}'); // 디버깅 로그
      if (doc.exists && doc.data() != null) {
        print('UserService: 문서 데이터: ${doc.data()}'); // 디버깅 로그
        final userModel = UserModel.fromMap(doc.data()!, uid);
        print(
          'UserService: 사용자 모델 변환 - 성별: ${userModel.gender}, 생년월일: ${userModel.birthDate}',
        ); // 디버깅 로그
        return userModel;
      }

      print('UserService: 사용자 정보 없음'); // 디버깅 로그
      return null;
    } catch (e) {
      print('UserService: 사용자 정보 가져오기 오류: $e'); // 디버깅 로그
      print('UserService: 스택 트레이스: ${StackTrace.current}'); // 디버깅 로그
      return null;
    }
  }
}
