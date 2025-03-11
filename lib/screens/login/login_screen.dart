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
    final theme = Theme.of(context);
    // 버튼 너비 - 화면 너비의 80%로 설정
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                      Lottie.asset(
                        'assets/animations/main_logo05.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '당신에게 맞는 영양제를 추천해드립니다',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
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
                              style: _getAppleButtonStyle(theme),
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
                            style: _getGoogleButtonStyle(theme),
                            child: Center(
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min, // 중요: 내용물에 맞게 크기 조절
                                children: [
                                  Image.asset(
                                    'assets/images/t_g_logo.png',
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Google로 로그인",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: theme.textTheme.labelLarge?.color,
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

  SignInWithAppleButtonStyle _getAppleButtonStyle(ThemeData theme) {
    // 다크 테마면 흰색 버튼, 라이트 테마면 검은색 버튼
    return theme.scaffoldBackgroundColor.computeLuminance() < 0.5
        ? SignInWithAppleButtonStyle.white
        : SignInWithAppleButtonStyle.black;
  }

  ButtonStyle _getGoogleButtonStyle(ThemeData theme) {
    // 테마에 맞게 구글 로그인 버튼 스타일 반환
    final isDarkBackground =
        theme.scaffoldBackgroundColor.computeLuminance() < 0.5;

    return ElevatedButton.styleFrom(
      backgroundColor: isDarkBackground ? theme.cardColor : Colors.white,
      foregroundColor: theme.textTheme.labelLarge?.color,
      elevation: 1,
      padding: EdgeInsets.zero, // 패딩 제거
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor),
      ),
    );
  }
}
