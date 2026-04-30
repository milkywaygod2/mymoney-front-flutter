import 'package:flutter/material.dart';

import 'NatureBadge.dart';

/// 5대 계정 이모지/아이콘 위젯
/// 자산🌳, 비용🍎, 수익💧, 부채🫙, 자본🪣
class KindIcon extends StatelessWidget {
  const KindIcon(this.nature, {super.key, this.size = 20});

  final AccountNature nature;
  final double size;

  static const Map<AccountNature, String> _emoji = {
    AccountNature.asset: '🌳',
    AccountNature.expense: '🍎',
    AccountNature.revenue: '💧',
    AccountNature.liability: '🫙',
    AccountNature.equity: '🪣',
  };

  @override
  Widget build(BuildContext context) {
    return Text(
      _emoji[nature]!,
      style: TextStyle(fontSize: size),
    );
  }
}
