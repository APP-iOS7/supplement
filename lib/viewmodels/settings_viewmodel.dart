import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  // 설정 관련 상태 및 로직
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // 설정 항목 클릭 처리
  void handleSettingItemTap(BuildContext context, String title) {
    // 각 설정 항목별 처리 로직
    switch (title) {
      case '내 정보 수정':
        // 내 정보 수정 화면으로 이동
        break;
      case '알림 설정':
        // 알림 설정 화면으로 이동
        break;
      case '진동 설정':
        // 진동 설정 화면으로 이동
        break;
      case '개인화 설정':
        // 개인화 설정 화면으로 이동
        break;
      case '서비스 이용약관':
        // 서비스 이용약관 화면으로 이동
        break;
      case '개인정보 처리방침':
        // 개인정보 처리방침 화면으로 이동
        break;
      case '청소년 보호 약관':
        // 청소년 보호 약관 화면으로 이동
        break;
      case '고객센터':
        // 고객센터 화면으로 이동
        break;
    }
  }

  // 로그아웃 처리
  void logout(BuildContext context) {
    // 로그아웃 로직
    // 예: 토큰 삭제, 사용자 정보 초기화 등
    
    // 로그아웃 후 로그인 화면으로 이동
    // Navigator.pushAndRemoveUntil(...);
  }

  // 알림 아이콘 클릭 처리
  void handleNotificationTap(BuildContext context) {
    // 알림 화면으로 이동 또는 알림 목록 표시
  }
}