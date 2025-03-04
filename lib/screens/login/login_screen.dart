import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supplementary_app/screens/login/get_info_screen.dart';
import 'package:supplementary_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 약관 동의 상태
  bool _termsAgreed = false; // 이용약관 동의
  bool _privacyAgreed = false; // 개인정보 처리방침 동의
  bool _marketingAgreed = false; // 마케팅 정보 수신 동의

  // 필수 약관 모두 동의했는지 확인
  bool get _requiredAgreementsChecked => _termsAgreed && _privacyAgreed;

  // 로딩 상태
  bool _isLoading = false;

  // 인증 서비스 인스턴스
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    // 앱 로고 및 타이틀
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            size: 80,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '영양제 추천',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '당신에게 맞는 영양제를 추천해드립니다',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 64),
                    // 소셜 로그인 버튼들
                    Column(
                      children: [
                        // 구글 로그인 버튼
                        ElevatedButton.icon(
                          onPressed:
                              _requiredAgreementsChecked
                                  ? _handleGoogleSignIn
                                  : null,
                          icon: const Icon(Icons.g_mobiledata, size: 24),
                          label: const Text('Google로 로그인'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 16),
                            minimumSize: const Size(double.infinity, 0),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 애플 로그인 버튼 - iOS에서만 표시
                        if (Platform.isIOS)
                          ElevatedButton.icon(
                            onPressed:
                                _requiredAgreementsChecked
                                    ? _handleAppleSignIn
                                    : null,
                            icon: const Icon(Icons.apple),
                            label: const Text('Apple로 로그인'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 0),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // 약관 동의 섹션
                    const Text(
                      '약관 동의',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 이용약관 동의 체크박스
                    _buildSimpleAgreementItem(
                      title: '[필수] 이용약관 동의',
                      value: _termsAgreed,
                      onChanged: (value) {
                        setState(() {
                          _termsAgreed = value;
                        });
                      },
                      onViewTap: () => _showTermsDialog(context),
                    ),
                    // 개인정보 처리방침 동의 체크박스
                    _buildSimpleAgreementItem(
                      title: '[필수] 개인정보 처리방침 동의',
                      value: _privacyAgreed,
                      onChanged: (value) {
                        setState(() {
                          _privacyAgreed = value;
                        });
                      },
                      onViewTap: () => _showPrivacyDialog(context),
                    ),
                    // 마케팅 정보 수신 동의 체크박스
                    _buildSimpleAgreementItem(
                      title: '[선택] 마케팅 정보 수신 동의',
                      value: _marketingAgreed,
                      onChanged: (value) {
                        setState(() {
                          _marketingAgreed = value;
                        });
                      },
                      onViewTap: () => _showMarketingDialog(context),
                    ),
                  ],
                ),
              ),
            ),
            // 로딩 인디케이터 (로딩 중일 때만 표시)
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  // 체크박스 대신 사용할 커스텀 동의 위젯
  Widget _buildSimpleAgreementItem({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required VoidCallback onViewTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // 체크박스 대신 GestureDetector와 아이콘 사용
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Icon(
                value ? Icons.check_box : Icons.check_box_outline_blank,
                color: value ? Theme.of(context).primaryColor : Colors.grey,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!value),
              child: Text(title),
            ),
          ),
          TextButton(onPressed: onViewTap, child: const Text('보기')),
        ],
      ),
    );
  }

  // 이용약관 다이얼로그
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('이용약관'),
            content: const SingleChildScrollView(
              child: Text(
                '이용약관 내용...\n\n'
                '1. 서비스 이용 조건\n'
                '2. 회원 의무 사항\n'
                '3. 서비스 제공 및 변경\n'
                '4. 책임 제한\n'
                '5. 분쟁 해결\n'
                '\n실제 이용약관 내용으로 대체해주세요.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  // 개인정보 처리방침 다이얼로그
  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('개인정보 처리방침'),
            content: const SingleChildScrollView(
              child: Text(
                '개인정보 처리방침 내용...\n\n'
                '1. 수집하는 개인정보 항목\n'
                '2. 개인정보 수집 및 이용목적\n'
                '3. 개인정보의 보유 및 이용기간\n'
                '4. 개인정보의 파기절차 및 방법\n'
                '5. 개인정보 보호책임자\n'
                '\n실제 개인정보 처리방침 내용으로 대체해주세요.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  // 마케팅 정보 수신 동의 다이얼로그
  void _showMarketingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('마케팅 정보 수신 동의'),
            content: const SingleChildScrollView(
              child: Text(
                '마케팅 정보 수신 동의 내용...\n\n'
                '당사는 고객님께 알림, 혜택, 프로모션 정보를 제공하기 위해 마케팅 정보를 발송할 수 있습니다. '
                '동의하지 않으셔도 서비스 이용에는 제한이 없으며, 언제든지 수신 동의를 철회하실 수 있습니다.\n\n'
                '- 수신 정보: 신규 콘텐츠, 이벤트, 프로모션, 맞춤 추천\n'
                '- 수신 방법: 앱 내 알림, 이메일, SMS\n'
                '\n실제 마케팅 동의 내용으로 대체해주세요.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  // 구글 로그인 처리
  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() {
        _isLoading = true; // 로딩 시작
      });

      print('구글 로그인 시작'); // 디버깅 로그

      try {
        // 구글 로그인 실행
        final credential = await _authService.signInWithGoogle();
        print('구글 로그인 응답 받음: ${credential != null ? "성공" : "취소됨"}'); // 디버깅 로그

        // 로그인이 성공했는지 확인
        if (credential != null && credential.user != null) {
          print('사용자 UID: ${credential.user!.uid}'); // 디버깅 로그

          try {
            // 마케팅 동의 여부 저장
            print('마케팅 동의 정보 저장 시작'); // 디버깅 로그
            await _authService.saveMarketingAgreement(
              credential.user!.uid,
              _marketingAgreed,
            );
            print('마케팅 동의 정보 저장 완료'); // 디버깅 로그

            // 로그아웃 상태 제거 (자동 로그인 활성화)
            await _authService.clearLogoutState(credential.user!.uid);

            // 화면이 아직 유효한지 확인 후 추가 정보 입력 화면으로 이동
            if (mounted) {
              print('추가 정보 입력 화면으로 이동'); // 디버깅 로그
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const GetInfoScreen()),
                (route) => false, // 모든 이전 화면 제거
              );
            }
          } catch (firestoreError) {
            print('Firestore 저장 오류: $firestoreError'); // 디버깅 로그
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('사용자 정보 저장 오류: $firestoreError')),
              );
            }
          }
        } else {
          print('로그인 취소 또는 실패'); // 디버깅 로그
        }
      } catch (authError) {
        print('인증 과정 오류: $authError'); // 디버깅 로그
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('구글 로그인 오류: $authError')));
        }
      }
    } catch (e) {
      // 기타 오류 발생 시 스낵바로 메시지 표시
      print('예상치 못한 오류: $e'); // 디버깅 로그
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인 처리 중 오류 발생: $e')));
      }
    } finally {
      // 로딩 상태 종료
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('구글 로그인 처리 완료'); // 디버깅 로그
    }
  }

  // 애플 로그인 처리
  Future<void> _handleAppleSignIn() async {
    try {
      setState(() {
        _isLoading = true; // 로딩 시작
      });

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
            await _authService.saveMarketingAgreement(
              credential.user!.uid,
              _marketingAgreed,
            );
            print('마케팅 동의 정보 저장 완료'); // 디버깅 로그

            // 로그아웃 상태 제거 (자동 로그인 활성화)
            await _authService.clearLogoutState(credential.user!.uid);

            // 화면이 아직 유효한지 확인 후 추가 정보 입력 화면으로 이동
            if (mounted) {
              print('추가 정보 입력 화면(GetInfoScreen)으로 이동'); // 디버깅 로그
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const GetInfoScreen()),
                (route) => false, // 모든 이전 화면 제거
              );
            }
          } catch (firestoreError) {
            print('Firestore 저장 오류: $firestoreError'); // 디버깅 로그
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('사용자 정보 저장 오류: $firestoreError')),
              );
            }
          }
        } else {
          print('애플 로그인 실패 또는 취소됨'); // 디버깅 로그
        }
      } catch (authError) {
        print('애플 인증 과정 오류: $authError');
        print('오류 타입: ${authError.runtimeType}');

        // 사용자가 취소한 경우 조용히 처리
        if (authError.toString().contains('canceled') ||
            authError.toString().contains('error 1001')) {
          print('사용자가 애플 로그인을 취소함');
          // 취소 메시지 표시 안함
        } else {
          // 다른 오류는 메시지 표시
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('애플 로그인 오류: $authError')));
          }
        }
      }
    } catch (e) {
      // 기타 오류 발생 시 스낵바로 메시지 표시
      print('예상치 못한 오류: $e'); // 디버깅 로그
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인 처리 중 오류 발생: $e')));
      }
    } finally {
      // 로딩 상태 종료
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('애플 로그인 처리 완료'); // 디버깅 로그
    }
  }
}
