import 'package:flutter/material.dart';
import 'package:supplementary_app/services/auth_service.dart';

class MypageScreen extends StatelessWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [FloatingActionButton(onPressed: AuthService().signOut)],
      ),
    );
  }
}
