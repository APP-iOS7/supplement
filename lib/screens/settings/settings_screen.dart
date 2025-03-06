import 'package:flutter/material.dart';

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
          _buildSettingItem(context, '내 정보 수정', Icons.chevron_right),
          _buildSettingItem(context, '알림 설정', Icons.chevron_right),
          _buildSettingItem(context, '진동 설정', Icons.chevron_right),
          _buildSettingItem(context, '개인화 설정', Icons.chevron_right),

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
                Text(
                  '1.2.3',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
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
                Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.red[400], fontSize: 16),
                ),
              ],
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
  ) {
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
