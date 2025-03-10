import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

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

  // 테마 모드 전환
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      print('테마 설정 저장 오류: $e');
    }
  }

  // 다크 테마 설정
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    fontFamily: "MaruBuri",
    primaryColor: const Color(0xFF51B47B),
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF51B47B),
      secondary: Color(0xFF84C4AE),
      tertiary: Color(0xFFFFB74D),
      error: Color(0xFFE57373),
      surface: Color(0xFF1E1E1E),
    ),
    iconTheme: const IconThemeData(color: Colors.white70, size: 24),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF51B47B),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
    ),
    cardTheme: const CardTheme(color: Color(0xFF2A2A2A), elevation: 2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      indicatorColor: Color(0xFF51B47B),
      surfaceTintColor: Colors.white70,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      bodySmall: TextStyle(color: Colors.white60),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3A3A3A),
      thickness: 1,
    ),
  );

  // 라이트 테마 설정
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    fontFamily: "MaruBuri",
    primaryColor: const Color(0xFF51B47B),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF51B47B),
      primary: const Color(0xFF51B47B),
      tertiary: const Color(0xFFFF9800),
      error: const Color(0xFFB00020),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF424242), size: 24),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF51B47B),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
    ),
    cardTheme: const CardTheme(color: Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF51B47B)),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Color(0xFF51B47B),
      surfaceTintColor: Colors.white70,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Color(0xFF212121),
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF212121),
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(color: Color(0xFF212121)),
      bodyLarge: TextStyle(color: Color(0xFF212121)),
      bodyMedium: TextStyle(color: Color(0xFF424242)),
      bodySmall: TextStyle(color: Color(0xFF616161)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
    ),
  );
}
