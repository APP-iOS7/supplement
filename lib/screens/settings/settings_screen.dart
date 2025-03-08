import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notification action
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Personal Settings Section
          _buildSettingItem(context, '내 정보 수정', Icons.chevron_right, () {}),
          _buildSettingItem(context, '알림 설정', Icons.chevron_right, () {}),
          _buildSettingItem(context, '진동 설정', Icons.chevron_right, () {}),
          _buildThemeToggle(context), // 라이트/다크모드 토글 수정

          // Divider
          const Divider(height: 16, thickness: 8, color: Color(0xFFF5F5F5)),

          // Service Settings Section
          _buildSettingItem(context, '서비스 이용약관', Icons.chevron_right, () {}),
          _buildSettingItem(context, '개인정보 처리방침', Icons.chevron_right, () {}),
          _buildSettingItem(context, '청소년 보호 약관', Icons.chevron_right, () {}),
          _buildSettingItem(context, '고객센터', Icons.chevron_right, () {}),

          // Divider
          const Divider(height: 16, thickness: 8, color: Color(0xFFF5F5F5)),

          // Version Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('버전 정보', style: TextStyle(fontSize: 16)),
                Text(
                  '1.2.3',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Logout Button
          InkWell(
            onTap: () {
              // 로그아웃 기능 추가 예정
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red[400]),
                  const SizedBox(width: 8),
                  Text(
                    '로그아웃',
                    style: TextStyle(color: Colors.red[400], fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Bottom padding
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    IconData trailingIcon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
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

  Widget _buildThemeToggle(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('라이트/다크모드', style: TextStyle(fontSize: 16)),
              Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
