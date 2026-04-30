import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/Enums.dart';

/// K-IFRS 계정 성격 → 메타포 이모지 매핑
class MetaphorIcon extends StatelessWidget {
  const MetaphorIcon({
    super.key,
    required this.nature,
    this.size = 20.0,
    this.customEmoji,
  });

  final AccountNature nature;
  final double size;
  /// null이면 nature 기본값 사용, non-null이면 커스텀 이모지 우선 표시
  final String? customEmoji;

  // 자산🌳, 비용🍎, 수익💧, 부채🫙, 자본🪣
  static String emojiFor(AccountNature nature) {
    return switch (nature) {
      AccountNature.asset => '🌳',
      AccountNature.expense => '🍎',
      AccountNature.revenue => '💧',
      AccountNature.liability => '🫙',
      AccountNature.equity => '🪣',
    };
  }

  /// accountId 기준으로 저장된 커스텀 이모지를 조회, 없으면 null 반환
  static Future<String?> loadCustomEmoji(int accountId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('metaphor_$accountId');
  }

  /// accountId 기준으로 커스텀 이모지를 저장
  static Future<void> saveCustomEmoji(int accountId, String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('metaphor_$accountId', emoji);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      customEmoji ?? emojiFor(nature),
      style: TextStyle(fontSize: size),
    );
  }
}
