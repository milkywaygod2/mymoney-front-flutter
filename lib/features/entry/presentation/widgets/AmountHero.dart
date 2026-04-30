import 'package:flutter/material.dart';

import '../../../../app/theme/AppColors.dart';

/// 큰 금액 표시 영역 — Entry 모든 V에서 공통 사용
class AmountHero extends StatelessWidget {
  const AmountHero({
    super.key,
    required this.display,
    this.description,
  });

  final String display;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (description != null)
            Text(
              description!,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          const SizedBox(height: 4),
          Text(
            '₩$display',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
