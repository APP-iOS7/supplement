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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          _themeToggle(context, themeProvider),
          _editMyInfo(context),
          const Divider(height: 16),
          _versionInfo(context),
          _signOut(context),
        ],
      ),
    );
  }

  Widget _themeToggle(BuildContext context, ThemeProvider themeProvider) {
    final isCurrentlyDark = themeProvider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isCurrentlyDark ? Icons.dark_mode : Icons.light_mode,
                color: isCurrentlyDark ? null : Colors.amber,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '다크 모드',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Switch(
            value: isCurrentlyDark,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
        ],
      ),
    );
  }

  ListTile _versionInfo(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.info_outline),
      title: Text('버전 정보'),
      trailing: Text('1.0.0'),
    );
  }

  ListTile _signOut(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
      title: Text(
        '로그아웃',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      onTap: () => AuthService().signOut(),
    );
  }

  ListTile _editMyInfo(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_outline),
      title: const Text('내 정보 수정'),
      trailing: const Icon(Icons.chevron_right),
      onTap:
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GetInfoScreen()),
          ),
    );
  }
}
