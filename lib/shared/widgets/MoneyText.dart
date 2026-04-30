import 'package:flutter/material.dart';

import '../../app/theme/AppTextStyles.dart';

enum MoneySize { lg, md, sm }

/// JetBrains Mono + tabular-nums 금액 텍스트 위젯
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.amount, {
    super.key,
    this.size = MoneySize.md,
    this.color,
    this.prefix = '₩',
  });

  final String amount;
  final MoneySize size;
  final Color? color;
  final String prefix;

  TextStyle get _style {
    switch (size) {
      case MoneySize.lg:
        return AppTextStyles.amountLg;
      case MoneySize.md:
        return AppTextStyles.amountMd;
      case MoneySize.sm:
        return AppTextStyles.amountSm;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = color != null ? _style.copyWith(color: color) : _style;
    return Text('$prefix$amount', style: style);
  }
}
