import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/screens/main_screen.dart';
import 'package:supplementary_app/providers/theme_provider.dart';  // Import ThemeProvider

// StatefulWidget으로 변경하여 상태 유지
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // listen: false로 설정하여 전체 리빌드 방지
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
        title: const Text('설정', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // 알림 기능 처리
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Personal Settings Section
          _buildSettingItem(context, '내 정보 수정', Icons.chevron_right),
          _buildSettingItem(context, '알림 설정', Icons.chevron_right),
          _buildSettingItem(context, '진동 설정', Icons.chevron_right),
          
          // 다크/라이트 모드 토글 - StatefulBuilder 사용
          StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: themeProvider.isDarkMode ? Colors.white : Colors.amber,
                        ),
                        const SizedBox(width: 12),
                        const Text('다크/라이트 모드', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      activeColor: const Color(0xFF51B47B),
                      onChanged: (value) {
                        // setState로 로컬 상태 업데이트 후 테마 변경
                        setState(() {});
                        themeProvider.toggleTheme();
                      },
                    ),
                  ],
                ),
              );
            }
          ),
          
          // Divider
          const Divider(height: 16, thickness: 8, color: Color(0xFFF5F5F5)),
          
          // Service Settings Section
          _buildSettingItem(context, '서비스 이용약관', Icons.chevron_right),
          _buildSettingItem(context, '개인정보 처리방침', Icons.chevron_right),
          _buildSettingItem(context, '청소년 보호 약관', Icons.chevron_right),
          _buildSettingItem(context, '고객센터', Icons.chevron_right),
          
          // Divider
          const Divider(height: 16, thickness: 8, color: Color(0xFFF5F5F5)),
          
          // Version Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('버전 정보', style: TextStyle(fontSize: 16)),
                Text('1.2.3', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              ],
            ),
          ),
          
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red[400]),
                const SizedBox(width: 8),
                Text('로그아웃', style: TextStyle(color: Colors.red[400], fontSize: 16)),
              ],
            ),
          ),
          
          // Bottom padding
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData trailingIcon) {
    return InkWell(
      onTap: () {
        // Handle tap on setting item
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Icon(trailingIcon, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}