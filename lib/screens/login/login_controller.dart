// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplementary_app/screens/login/get_info_screen.dart';
import 'package:supplementary_app/screens/login/auth_check.dart';
import 'package:supplementary_app/services/auth_service.dart';

class LoginController {
  // 인증 서비스 인스턴스
  final AuthService _authService = AuthService();

  // 인증 확인 유틸리티
  final AuthCheck _authCheck = AuthCheck();

  // FireStore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // context 및 상태 관리 변수
  late BuildContext _context;
  late Function(void Function()) _setState;
  late bool Function() _getLoading;
  late Function(bool) _setLoading;

  // 초기화 함수
  void init(
    BuildContext context,
    Function(void Function()) setState,
    bool Function() getLoading,
    Function(bool) setLoading,
  ) {
    _context = context;
    _setState = setState;
    _getLoading = getLoading;
    _setLoading = setLoading;
  }

  // 인증 상태 확인
  // LoginController.checkAuthState
  Future<void> checkAuthState() async {
    print('LoginController: 로딩 시작 - _isLoading = true');
    _setLoading(true);
    try {
      await _authCheck.checkAuthState(_context);
      print('LoginController: 인증 상태 확인 완료');
    } catch (e) {
      print('LoginController: 인증 상태 확인 오류 - $e');
    } finally {
      // context가 없어도 로딩 상태 강제 종료
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_context.mounted) {
          print('LoginController: 로딩 종료 - _isLoading = false');
          _setLoading(false);
        } else {
          print('LoginController: context.mounted가 false, 하지만 로딩 종료 시도');
        }
      });
    }
  }

  // 구글 로그인 처리
  // login_controller.dart
  // login_controller.dart
  Future<void> handleGoogleSignIn(bool marketingAgreed) async {
    try {
      _setLoading(true);
      print('구글 로그인 시작');
      try {
        final credential = await _authService.signInWithGoogle();
        print('구글 로그인 응답 받음: ${credential != null ? "성공" : "취소됨"}');

        if (credential != null && credential.user != null) {
          print('사용자 UID: ${credential.user!.uid}');
          try {
            print('마케팅 동의 정보 저장 시작');
            await _saveMarketingAgreement(
              credential.user!.uid,
              marketingAgreed,
            );
            print('마케팅 동의 정보 저장 완료');

            await _clearLogoutState(credential.user!.uid);

            if (_context.mounted) {
              print('추가 정보 입력 화면으로 수동 이동');
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.of(_context)
                  .pushReplacement(
                    MaterialPageRoute(builder: (_) => const GetInfoScreen()),
                  )
                  .then((value) {
                    print('LoginController: 네비게이션 완료');
                  })
                  .catchError((error) {
                    print('LoginController: 네비게이션 오류 - $error');
                  });
            } else {
              print('LoginController: context.mounted가 false로, 네비게이션 실패');
            }
          } catch (firestoreError) {
            print('Firestore 저장 오류: $firestoreError');
            if (_context.mounted) {
              ScaffoldMessenger.of(_context).showSnackBar(
                SnackBar(content: Text('사용자 정보 저장 오류: $firestoreError')),
              );
            }
          }
        } else {
          print('로그인 취소 또는 실패');
        }
      } catch (authError) {
        print('인증 과정 오류: $authError');
        if (_context.mounted) {
          ScaffoldMessenger.of(
            _context,
          ).showSnackBar(SnackBar(content: Text('구글 로그인 오류: $authError')));
        }
      }
    } catch (e) {
      print('예상치 못한 오류: $e');
      if (_context.mounted) {
        ScaffoldMessenger.of(
          _context,
        ).showSnackBar(SnackBar(content: Text('로그인 처리 중 오류 발생: $e')));
      }
    } finally {
      // 강제로 로딩 상태 종료 (context 상태 상관없이)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('LoginController: 로딩 강제 종료 - _isLoading = false');
        if (_context.mounted) {
          _setLoading(false);
        }
      });
      print('구글 로그인 처리 완료');
    }
  }

  // 애플 로그인 처리
  Future<void> handleAppleSignIn(bool marketingAgreed) async {
    try {
      _setLoading(true);

      print('애플 로그인 시작'); // 디버깅 로그

      // 애플 로그인 실행
      try {
        final credential = await _authService.signInWithApple();
        print('애플 로그인 응답 받음: ${credential != null ? "성공" : "취소됨"}'); // 디버깅 로그

        // 로그인이 성공했는지 확인
        if (credential != null && credential.user != null) {
          print('애플 로그인 성공 - 사용자 UID: ${credential.user!.uid}'); // 디버깅 로그

          try {
            // 마케팅 동의 여부 저장
            print('마케팅 동의 정보 Firestore에 저장 시작'); // 디버깅 로그
            await _saveMarketingAgreement(
              credential.user!.uid,
              marketingAgreed,
            );
            print('마케팅 동의 정보 저장 완료'); // 디버깅 로그

            // 로그아웃 상태 제거
            await _clearLogoutState(credential.user!.uid);

            // 화면이 아직 유효한지 확인 후 추가 정보 입력 화면으로 이동
            if (_context.mounted) {
              print('추가 정보 입력 화면(GetInfoScreen)으로 수동 이동'); // 디버깅 로그

              // 이 부분에서 메인 스트림에 효과가 반영될 수 있도록 delay 추가
              await Future.delayed(Duration(milliseconds: 500));

              if (_context.mounted) {
                Navigator.of(_context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const GetInfoScreen()),
                );
              }
            }
          } catch (firestoreError) {
            print('Firestore 저장 오류: $firestoreError'); // 디버깅 로그
            if (_context.mounted) {
              ScaffoldMessenger.of(_context).showSnackBar(
                SnackBar(content: Text('사용자 정보 저장 오류: $firestoreError')),
              );
            }
          }
        } else {
          print('애플 로그인 실패 또는 취소됨'); // 디버깅 로그
        }
      } catch (authError) {
        print('애플 인증 과정 오류: $authError'); // 디버깅 로그
        print('오류 타입: ${authError.runtimeType}'); // 디버깅 로그
        if (_context.mounted) {
          ScaffoldMessenger.of(
            _context,
          ).showSnackBar(SnackBar(content: Text('애플 로그인 오류: $authError')));
        }
      }
    } catch (e) {
      // 기타 오류 발생 시 스낵바로 메시지 표시
      print('예상치 못한 오류: $e'); // 디버깅 로그
      if (_context.mounted) {
        ScaffoldMessenger.of(
          _context,
        ).showSnackBar(SnackBar(content: Text('로그인 처리 중 오류 발생: $e')));
      }
    } finally {
      // 로딩 상태 종료
      if (_context.mounted) {
        _setLoading(false);
      }
      print('애플 로그인 처리 완료'); // 디버깅 로그
    }
  }

  // 마케팅 동의 저장
  Future<void> _saveMarketingAgreement(String uid, bool agreed) async {
    await _firestore.collection('users').doc(uid).set({
      'marketingAgreed': agreed,
      'createdAt': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // 로그아웃 상태 제거
  Future<void> _clearLogoutState(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'isLoggedOut': false,
        'lastLoginTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('로그아웃 상태 제거 완료'); // 디버깅 로그
    } catch (stateError) {
      print('로그아웃 상태 제거 오류: $stateError'); // 디버깅 로그
    }
  }
}
