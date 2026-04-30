import 'package:flutter/material.dart';

import '../../../../core/constants/Enums.dart';

/// K-IFRS 계정 성격 → 메타포 이모지 매핑
class MetaphorIcon extends StatelessWidget {
  const MetaphorIcon({
    super.key,
    required this.nature,
    this.size = 20.0,
  });

  final AccountNature nature;
  final double size;

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

  @override
  Widget build(BuildContext context) {
    return Text(
      emojiFor(nature),
      style: TextStyle(fontSize: size),
    );
  }
}
