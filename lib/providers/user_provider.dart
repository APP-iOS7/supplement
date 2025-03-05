import 'package:flutter/material.dart';
import 'package:supplementary_app/models/user_model.dart';
import 'package:supplementary_app/services/auth_service.dart';
import 'package:supplementary_app/services/store_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _auth = AuthService();
  final StoreService _store = StoreService();
  UserModel? _user;
  UserModel? get user => _user;

  UserProvider() {
    _initUser();
  }

  Future<void> _initUser() async {
    final String uid = _auth.currentUserUid;
    _user = await _store.getUserInfoByUid(uid);
    print('user init completed $uid');
    notifyListeners();
  }
}
