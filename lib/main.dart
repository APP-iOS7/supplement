import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/providers/theme_provider.dart';
import 'package:supplementary_app/screens/login/get_info_screen.dart';
import 'package:supplementary_app/screens/login/login_screen.dart';
import 'package:supplementary_app/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supplementary_app/firebase_options.dart';
import 'package:supplementary_app/providers/user_provider.dart';

void main() async {
  // Flutter 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 앱 실행
  runApp(
    // 앱 전체에서 테마 상태를 공유하기 위한 Provider 설정
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SupplementSurveyProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
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
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (!snapshot.hasData) {
          return LoginScreen();
        }
        return StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasError) return Text('err');
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return GetInfoScreen();
            }
            return MainScreen();
          },
        );
      },
    );
  }
}
