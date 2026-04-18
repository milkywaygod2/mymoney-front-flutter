import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/Perspective.dart';
import 'PerspectiveBloc.dart';
import 'PerspectiveEvent.dart';
import 'PerspectiveState.dart';

/// Lens Switcher — 2계층 Perspective 전환 위젯
/// 1층: 프리셋 칩 바 (수평 스크롤, filled/outlined)
/// 2층: 커스텀 필터 패널 (톱니바퀴 탭 시 확장, 3탭)
class LensSwitcher extends StatelessWidget {
  const LensSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerspectiveBloc, PerspectiveState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1층: 프리셋 칩 바
            _buildChipBar(context, state),
            // 2층: 커스텀 필터 (접힘/펼침)
            if (state.isCustomFilterOpen) _buildCustomFilter(context, state),
          ],
        );
      },
    );
  }

  /// 1층 칩 바 — 프리셋 빠른 전환
  Widget _buildChipBar(BuildContext context, PerspectiveState state) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          ...state.listPresets.map((preset) {
            final isActive = state.activePresetId == preset.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(preset.name),
                selected: isActive,
                onSelected: (_) => context.read<PerspectiveBloc>()
                    .add(SelectPreset(id: preset.id)),
              ),
            );
          }),
          // 톱니바퀴 (커스텀 필터 열기)
          IconButton(
            icon: Icon(state.isCustomFilterOpen ? Icons.close : Icons.tune),
            onPressed: () => context.read<PerspectiveBloc>()
                .add(const OpenCustomFilter()),
          ),
        ],
      ),
    );
  }

  /// 2층 커스텀 필터 — 3탭 (계정속성/거래속성/분석)
  Widget _buildCustomFilter(BuildContext context, PerspectiveState state) {
    return const DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: '계정 속성'),
              Tab(text: '거래 속성'),
              Tab(text: '분석'),
            ],
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              children: [
                // 계정 속성: T1(자기자본성/유동성/자산종류) + 소유자 + 속성
                Center(child: Text('T1 트리 드릴다운 (TODO)')),
                // 거래 속성: T2(활동구분/소득유형) + 통화 + 거래처
                Center(child: Text('T2 필터 (TODO)')),
                // 분석: T3(태그/생활분류) + 예산과목
                Center(child: Text('T3 태그 멀티셀렉트 (TODO)')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
