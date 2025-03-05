import 'package:flutter/material.dart';
import 'package:supplementary_app/models/user_model.dart';
import 'package:supplementary_app/services/auth_service.dart';
import 'package:supplementary_app/services/store_service.dart';

class GetInfoViewModel extends ChangeNotifier {
  final _store = StoreService();
  final _auth = AuthService();
  String? selectedGender;
  DateTime? selectedDate;
  String get _curruntUserUid => _auth.currentUserUid;
  bool get canProceed => selectedGender != null && selectedDate != null;

  set selectGender(String? value) {
    selectedGender = value;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      helpText: '생년월일 선택',
      confirmText: '확인',
      cancelText: '취소',
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  Future<void> saveUserInfo() async {
    if (canProceed) {
      final userInfo = UserModel(
        uid: _curruntUserUid,
        gender: selectedGender!,
        birthDate: selectedDate!,
        createdAt: DateTime.now(),
      );
      _store.makeUserInfo(userInfo);
    }
  }
}
