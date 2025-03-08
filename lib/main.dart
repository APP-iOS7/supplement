import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/page_route_provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/login/get_info_screen.dart';
import 'package:supplementary_app/screens/login/login_screen.dart';
import 'package:supplementary_app/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supplementary_app/firebase_options.dart';
import 'package:supplementary_app/providers/user_provider.dart';
import 'package:supplementary_app/widgets/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SupplementSurveyProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PageRouteProvider()),
      ],
      child: MaterialApp(
        title: '영양제 추천',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF51B47B),
            primary: const Color(0xFF51B47B),
            secondary: const Color(0xFF6D6D6D),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF51B47B),
              foregroundColor: Colors.white,
            ),
          ),
          useMaterial3: true,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Loading());
        }

        if (!snapshot.hasData) {
          return LoginScreen();
        }

        final user = snapshot.data!;
        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Loading());
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return GetInfoScreen();
            }
            Provider.of<UserProvider>(context).initUser();
            return MainScreen();
          },
        );
      },
    );
  }
}
