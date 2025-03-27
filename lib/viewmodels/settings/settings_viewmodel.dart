import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/theme_provider.dart';
import 'package:supplementary_app/services/auth_service.dart';

class SettingsViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  final ThemeProvider _themeProvider;

  SettingsViewModel({required ThemeProvider themeProvider})
    : _themeProvider = themeProvider;

  bool get isDarkMode => _themeProvider.isDarkMode;

  void toggleTheme() {
    _themeProvider.toggleTheme();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
