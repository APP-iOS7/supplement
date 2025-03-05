import 'package:flutter/material.dart';
import 'package:supplementary_app/services/auth_service.dart';

class LoginScreenViewModel with ChangeNotifier {
  final _auth = AuthService();

  Future<void> signInWithGoogle() async {
    await _auth.signInWithGoogle(); // await 키워드 추가
  }
}
