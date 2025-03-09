import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  
  // 테마 변경 중인지 확인하는 플래그 추가
  bool _isChangingTheme = false;
  bool get isChangingTheme => _isChangingTheme;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // 저장된 테마 설정 불러오기
  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      notifyListeners();
    } catch (e) {
      print('테마 설정 불러오기 오류: $e');
    }
  }

  // 테마 모드 전환 - 상태 변경 최소화
  void toggleTheme() async {
    if (_isChangingTheme) return; // 이미 변경 중이면 무시
    
    _isChangingTheme = true;
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      print('테마 설정 저장 오류: $e');
    } finally {
      _isChangingTheme = false;
    }
  }

  // 다크 테마 설정
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF2E2E2E),
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF51B47B),
      secondary: Colors.grey[600]!,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF51B47B),
        foregroundColor: Colors.white,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
    ),
    useMaterial3: true,
  );
}
