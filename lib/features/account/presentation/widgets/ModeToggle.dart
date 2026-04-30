import 'package:flutter/material.dart';

/// 계정과목 화면 모드 열거
enum AccountViewMode { browse, map, config }

/// 조회/지도/설정 3모드 토글 위젯
class ModeToggle extends StatelessWidget {
  const ModeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AccountViewMode selected;
  final ValueChanged<AccountViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AccountViewMode>(
      segments: const [
        ButtonSegment(
          value: AccountViewMode.browse,
          label: Text('조회'),
          icon: Icon(Icons.account_tree, size: 16),
        ),
        ButtonSegment(
          value: AccountViewMode.map,
          label: Text('지도'),
          icon: Icon(Icons.map_outlined, size: 16),
        ),
        ButtonSegment(
          value: AccountViewMode.config,
          label: Text('설정'),
          icon: Icon(Icons.tune, size: 16),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
