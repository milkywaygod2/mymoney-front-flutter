import 'package:flutter/material.dart';

/// V2 숫자패드 — 0~9, ., C, ⌫
class NumPad extends StatelessWidget {
  const NumPad({
    super.key,
    required this.onPressed,
  });

  final ValueChanged<String> onPressed;

  static const _kButtons = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    ['.', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // C (전체 지우기)
        _NumPadButton(
          label: 'C',
          onTap: () => onPressed('C'),
          flex: 3,
          isWide: true,
        ),
        const SizedBox(height: 4),
        // 3x4 그리드
        ...List.generate(_kButtons.length, (row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: List.generate(_kButtons[row].length, (col) {
                final digit = _kButtons[row][col];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _NumPadButton(
                      label: digit,
                      onTap: () => onPressed(digit),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
}

class _NumPadButton extends StatelessWidget {
  const _NumPadButton({
    required this.label,
    required this.onTap,
    this.flex = 1,
    this.isWide = false,
  });

  final String label;
  final VoidCallback onTap;
  final int flex;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final isDelete = label == '⌫';
    final isClear = label == 'C';

    return Material(
      color: isClear
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 52,
          child: Center(
            child: isDelete
                ? Icon(
                    Icons.backspace_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: isClear ? 14 : 20,
                      fontWeight: FontWeight.w600,
                      color: isClear
                          ? Theme.of(context).colorScheme.onErrorContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
