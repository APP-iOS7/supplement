import 'package:flutter/material.dart';
import 'package:supplementary_app/models/user_model.dart';
import 'package:supplementary_app/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();

  UserModel? get user => _user;

  UserProvider() {
    _initUser();
  }

  Future<void> _initUser() async {}
}
