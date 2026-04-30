import 'package:flutter/material.dart';

import '../../../app/MyMoneyApp.dart';

/// 설정 페이지 — 앱 테마 등 기본 설정 관리
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = appThemeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          _SwitchTile(
            title: '다크 모드',
            subtitle: '어두운 테마를 사용합니다',
            value: _isDarkMode,
            onChanged: (v) {
              setState(() => _isDarkMode = v);
              appThemeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
