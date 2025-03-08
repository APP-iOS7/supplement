import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:supplementary_app/viewmodels/login/login_screen_viewmodel.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginScreenViewModel(),
      child: _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginScreenViewModel>(context);
    // 버튼 너비 - 화면 너비의 80%로 설정
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                      ClipOval(
                        child: Lottie.asset(
                          'assets/animations/loading.json',
                          width: 230, // 원형 크기 (지름)
                          height: 230, // 원형 크기 (지름)
                          fit: BoxFit.cover,
                        ),
                      ),

                      Image.asset(
                        'assets/images/Pick03.gif',
                        width: 250,
                        height: 150,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '당신에게 맞는 영양제를 추천해드립니다',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 33, 33, 33),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 소셜 로그인 버튼들
                Center(
                  child: Column(
                    children: [
                      if (Platform.isIOS)
                        Center(
                          child: SizedBox(
                            width: buttonWidth,
                            child: SignInWithAppleButton(
                              onPressed: vm.signInWithApple,
                              style: SignInWithAppleButtonStyle.black,
                              height: 44,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // 구글 로그인 버튼 - 커스텀 구현
                      Center(
                        child: SizedBox(
                          width: buttonWidth,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: vm.signInWithGoogle,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 1,
                              padding: EdgeInsets.zero, // 패딩 제거
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min, // 중요: 내용물에 맞게 크기 조절
                                children: [
                                  Image.asset(
                                    'assets/images/g-logo.png',
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Google로 로그인",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
