import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/theme_provider.dart';
import 'package:supplementary_app/screens/login/get_info_screen.dart';
import 'package:supplementary_app/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          _themeToggle(themeProvider),
          _editMyInfo(),
          const Divider(height: 16, color: Colors.white),
          _versionInfo(),
          _signOut(),
        ],
      ),
    );
  }

  Widget _themeToggle(ThemeProvider themeProvider) {
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
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
        ],
      ),
    );
  }

  ListTile _versionInfo() {
    return ListTile(
      title: Text('버전 정보', style: TextStyle(fontSize: 16)),
      trailing: Text(
        '1.0.0',
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  ListTile _signOut() {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red[400]),
      title: Text(
        '로그아웃',
        style: TextStyle(color: Colors.red[400], fontSize: 16),
      ),
      onTap: () => AuthService().signOut(),
    );
  }

  ListTile _editMyInfo() {
    return ListTile(
      title: Text('내 정보 수정', style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.chevron_right),
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetInfoScreen()),
          ),
    );
  }
}
