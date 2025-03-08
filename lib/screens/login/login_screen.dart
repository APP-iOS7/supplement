import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:supplementary_app/viewmodels/login/login_screen_viewmodel.dart';

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
                          fit:
                              BoxFit
                                  .cover, // 전체 원형을 채우기 위해 비율 조정 (필요 시 contain으로 변경)
                        ),
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
                Column(
                  children: [
                    // 구글 로그인 버튼
                    ElevatedButton.icon(
                      onPressed: vm.signInWithGoogle,
                      // icon: const Icon(Icons.g_mobiledata, size: 24),
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
                        onPressed: vm.signInWithApple,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
