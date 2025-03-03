import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/models/user_model.dart';
import 'package:supplementary_app/providers/theme_provider.dart';
import 'package:supplementary_app/screens/login/get_info_screen.dart';
import 'package:supplementary_app/screens/login/login_screen.dart';
import 'package:supplementary_app/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supplementary_app/services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  // Flutter 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 앱 실행
  runApp(
    // 앱 전체에서 테마 상태를 공유하기 위한 Provider 설정
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '영양제 추천',
      theme: ThemeData(
        // 메인 컬러 설정
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // 인증 상태에 따라 화면 전환을 담당하는 AuthWrapper를 홈 화면으로 설정
      home: const AuthWrapper(),
    );
  }
}

// 인증 상태에 따라 로그인 화면 또는 메인 화면을 보여주는 위젯
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    print('AuthWrapper: 빌드 시작'); // 디버깅 로그

    // Firebase 인증 상태 변경을 구독하는 StreamBuilder
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        // 인증 상태 로딩 중일 때 로딩 인디케이터 표시
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('AuthWrapper: 인증 상태 로딩 중'); // 디버깅 로그
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 사용자가 로그인되어 있으면
        if (snapshot.hasData) {
          print('AuthWrapper: 사용자 로그인됨 - UID: ${snapshot.data!.uid}'); // 디버깅 로그

          // 사용자 추가 정보 확인 (성별, 생년월일이 등록되어 있는지)
          return FutureBuilder<UserModel?>(
            future: AuthService().getUserData(snapshot.data!.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                print('AuthWrapper: 사용자 데이터 로딩 중'); // 디버깅 로그
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              print(
                'AuthWrapper: 사용자 데이터 로드 완료 - ${userSnapshot.data}',
              ); // 디버깅 로그

              // 사용자 정보가 없거나 성별/생년월일이 없으면 정보 입력 화면으로
              if (userSnapshot.data == null ||
                  userSnapshot.data!.gender == null ||
                  userSnapshot.data!.birthDate == null) {
                print('AuthWrapper: 추가 정보 필요, GetInfoScreen으로 이동'); // 디버깅 로그
                return const GetInfoScreen();
              }

              // 모든 정보가 있으면 메인 화면으로
              print('AuthWrapper: 모든 정보 있음, MainScreen으로 이동'); // 디버깅 로그
              return const MainScreen();
            },
          );
        }

        // 로그인되어 있지 않으면 로그인 화면으로
        print('AuthWrapper: 로그인 안됨, LoginScreen으로 이동'); // 디버깅 로그
        return const LoginScreen();
      },
    );
  }
}
