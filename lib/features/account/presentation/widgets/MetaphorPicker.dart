import 'package:flutter/material.dart';

import '../../../../core/constants/Enums.dart';
import 'MetaphorIcon.dart';

/// 메타포 선택 위젯 — 설정 모드에서 계정 메타포 등록
class MetaphorPicker extends StatelessWidget {
  const MetaphorPicker({
    super.key,
    required this.selectedNature,
    required this.onSelected,
  });

  final AccountNature? selectedNature;
  final ValueChanged<AccountNature> onSelected;

  static const _kNatureLabels = {
    AccountNature.asset: '자산',
    AccountNature.liability: '부채',
    AccountNature.equity: '자본',
    AccountNature.revenue: '수익',
    AccountNature.expense: '비용',
  };

  static const _kNatureDescriptions = {
    AccountNature.asset: '내가 가진 것 (현금, 예금, 부동산 등)',
    AccountNature.liability: '갚아야 할 것 (대출, 카드값 등)',
    AccountNature.equity: '내 자본 (저축, 투자 원금 등)',
    AccountNature.revenue: '들어오는 것 (급여, 이자 등)',
    AccountNature.expense: '나가는 것 (식비, 교통비 등)',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '계정 메타포 선택',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          '직관적인 이해를 위한 K-IFRS 계정 분류 표현입니다',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        ...AccountNature.values.map(
          (nature) => _MetaphorTile(
            nature: nature,
            label: _kNatureLabels[nature]!,
            description: _kNatureDescriptions[nature]!,
            isSelected: selectedNature == nature,
            onTap: () => onSelected(nature),
          ),
        ),
      ],
    );
  }
}

class _MetaphorTile extends StatelessWidget {
  const _MetaphorTile({
    required this.nature,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final AccountNature nature;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          children: [
            Text(
              MetaphorIcon.emojiFor(nature),
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
