import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/CurrencyCode.dart';
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
            if (state.isCustomFilterOpen) const _CustomFilterPanel(),
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
              child: GestureDetector(
                onLongPress: preset.isSystem
                    ? null
                    : () => _showPresetMenu(context, preset.id),
                child: FilterChip(
                  label: Text(preset.name),
                  selected: isActive,
                  onSelected: (_) => context
                      .read<PerspectiveBloc>()
                      .add(SelectPreset(id: preset.id)),
                ),
              ),
            );
          }),
          // 톱니바퀴 (커스텀 필터 열기)
          IconButton(
            icon: Icon(state.isCustomFilterOpen ? Icons.close : Icons.tune),
            onPressed: () =>
                context.read<PerspectiveBloc>().add(const OpenCustomFilter()),
          ),
        ],
      ),
    );
  }

  void _showPresetMenu(BuildContext context, dynamic presetId) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('프리셋 삭제'),
              onTap: () {
                Navigator.pop(context);
                context.read<PerspectiveBloc>().add(DeletePreset(id: presetId));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 2층: 커스텀 필터 패널
// =============================================================================

/// 커스텀 필터 패널 — 3탭(T1/T2/T3) 내부 상태 보유
class _CustomFilterPanel extends StatefulWidget {
  const _CustomFilterPanel();

  @override
  State<_CustomFilterPanel> createState() => _CustomFilterPanelState();
}

class _CustomFilterPanelState extends State<_CustomFilterPanel>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // T1 상태 — 드릴다운 경로 (코드 목록)
  final List<_DimNode> _t1BreadcrumbEquity = [];
  final Set<String> _t1SelectedEquityCodes = {};

  // T2 상태
  final List<_DimNode> _t2BreadcrumbActivity = [];
  final Set<String> _t2SelectedActivityCodes = {};
  final List<_DimNode> _t2BreadcrumbIncome = [];
  final Set<String> _t2SelectedIncomeCodes = {};
  CurrencyCode? _t2SelectedCurrency;
  final TextEditingController _t2CounterpartyCtrl = TextEditingController();

  // T3 상태
  bool _t3TagModeAnd = true;
  final TextEditingController _t3TagSearchCtrl = TextEditingController();
  final Set<String> _t3SelectedTags = {};
  final List<String> _t3RecentTags = ['식비', '교통', '통신', '의료', '교육'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _t2CounterpartyCtrl.dispose();
    _t3TagSearchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '계정 속성'),
            Tab(text: '거래 속성'),
            Tab(text: '분석'),
          ],
        ),
        SizedBox(
          height: 260,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildT1Tab(),
              _buildT2Tab(),
              _buildT3Tab(),
            ],
          ),
        ),
        _buildApplyButton(),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // T1: 계정 속성 탭
  // ─────────────────────────────────────────────────────────────

  Widget _buildT1Tab() {
    final currentNodes = _getCurrentEquityNodes();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb 네비게이션
          _buildBreadcrumb(
            crumbs: ['전체', ..._t1BreadcrumbEquity.map((n) => n.name)],
            onTap: (index) => setState(() {
              if (index == 0) {
                _t1BreadcrumbEquity.clear();
              } else {
                _t1BreadcrumbEquity.removeRange(
                    index, _t1BreadcrumbEquity.length);
              }
            }),
          ),
          const SizedBox(height: 8),
          // "이 레벨 이하 전체 선택" 토글
          if (_t1BreadcrumbEquity.isNotEmpty)
            _buildSelectAllToggle(
              label: '\'${_t1BreadcrumbEquity.last.name}\' 이하 전체',
              isSelected: _t1SelectedEquityCodes
                  .contains('${_t1BreadcrumbEquity.last.code}.*'),
              onToggle: () => setState(() {
                final wildcardKey = '${_t1BreadcrumbEquity.last.code}.*';
                if (_t1SelectedEquityCodes.contains(wildcardKey)) {
                  _t1SelectedEquityCodes.remove(wildcardKey);
                } else {
                  _t1SelectedEquityCodes.add(wildcardKey);
                }
              }),
            ),
          const SizedBox(height: 4),
          // 현재 레벨 노드 칩
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: currentNodes.map((node) {
              final isSelected = _t1SelectedEquityCodes.contains(node.code);
              return GestureDetector(
                onLongPress: node.hasChildren
                    ? () => setState(() {
                          if (_t1BreadcrumbEquity.length < 3) {
                            _t1BreadcrumbEquity.add(node);
                          }
                        })
                    : null,
                child: FilterChip(
                  label: Text(node.name),
                  selected: isSelected,
                  tooltip: node.hasChildren ? '길게 눌러 드릴다운' : null,
                  onSelected: (_) => setState(() {
                    if (isSelected) {
                      _t1SelectedEquityCodes.remove(node.code);
                    } else {
                      _t1SelectedEquityCodes.add(node.code);
                    }
                  }),
                ),
              );
            }).toList(),
          ),
          if (currentNodes.any((n) => n.hasChildren))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '길게 눌러 하위 항목으로 이동',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  List<_DimNode> _getCurrentEquityNodes() {
    final depth = _t1BreadcrumbEquity.length;
    if (depth >= 3) return [];
    final parentCode = depth == 0 ? null : _t1BreadcrumbEquity.last.code;
    return _kEquityTree
        .where((n) => n.parentCode == parentCode)
        .toList();
  }

  // ─────────────────────────────────────────────────────────────
  // T2: 거래 속성 탭
  // ─────────────────────────────────────────────────────────────

  Widget _buildT2Tab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 활동구분 트리
          Text('활동구분',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          _buildBreadcrumb(
            crumbs: ['전체', ..._t2BreadcrumbActivity.map((n) => n.name)],
            onTap: (index) => setState(() {
              if (index == 0) {
                _t2BreadcrumbActivity.clear();
              } else {
                _t2BreadcrumbActivity.removeRange(
                    index, _t2BreadcrumbActivity.length);
              }
            }),
          ),
          const SizedBox(height: 4),
          _buildDimChips(
            nodes: _getCurrentActivityNodes(),
            selected: _t2SelectedActivityCodes,
            breadcrumb: _t2BreadcrumbActivity,
            onToggle: (code) => setState(() {
              if (_t2SelectedActivityCodes.contains(code)) {
                _t2SelectedActivityCodes.remove(code);
              } else {
                _t2SelectedActivityCodes.add(code);
              }
            }),
            onDrillDown: (node) => setState(() {
              if (_t2BreadcrumbActivity.length < 3) {
                _t2BreadcrumbActivity.add(node);
              }
            }),
          ),
          const Divider(height: 20),
          // 소득유형 트리
          Text('소득유형',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          _buildBreadcrumb(
            crumbs: ['전체', ..._t2BreadcrumbIncome.map((n) => n.name)],
            onTap: (index) => setState(() {
              if (index == 0) {
                _t2BreadcrumbIncome.clear();
              } else {
                _t2BreadcrumbIncome.removeRange(
                    index, _t2BreadcrumbIncome.length);
              }
            }),
          ),
          const SizedBox(height: 4),
          _buildDimChips(
            nodes: _getCurrentIncomeNodes(),
            selected: _t2SelectedIncomeCodes,
            breadcrumb: _t2BreadcrumbIncome,
            onToggle: (code) => setState(() {
              if (_t2SelectedIncomeCodes.contains(code)) {
                _t2SelectedIncomeCodes.remove(code);
              } else {
                _t2SelectedIncomeCodes.add(code);
              }
            }),
            onDrillDown: (node) => setState(() {
              if (_t2BreadcrumbIncome.length < 3) {
                _t2BreadcrumbIncome.add(node);
              }
            }),
          ),
          const Divider(height: 20),
          // 통화 선택
          Text('통화', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: CurrencyCode.values.map((currency) {
              final isSelected = _t2SelectedCurrency == currency;
              return ChoiceChip(
                label: Text('${currency.symbol} ${currency.name}'),
                selected: isSelected,
                onSelected: (_) => setState(() {
                  _t2SelectedCurrency = isSelected ? null : currency;
                }),
              );
            }).toList(),
          ),
          const Divider(height: 20),
          // 거래처 검색
          Text('거래처', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          TextField(
            controller: _t2CounterpartyCtrl,
            decoration: const InputDecoration(
              hintText: '거래처명 검색',
              prefixIcon: Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  List<_DimNode> _getCurrentActivityNodes() {
    final depth = _t2BreadcrumbActivity.length;
    if (depth >= 3) return [];
    final parentCode =
        depth == 0 ? null : _t2BreadcrumbActivity.last.code;
    return _kActivityTree
        .where((n) => n.parentCode == parentCode)
        .toList();
  }

  List<_DimNode> _getCurrentIncomeNodes() {
    final depth = _t2BreadcrumbIncome.length;
    if (depth >= 3) return [];
    final parentCode =
        depth == 0 ? null : _t2BreadcrumbIncome.last.code;
    return _kIncomeTree
        .where((n) => n.parentCode == parentCode)
        .toList();
  }

  // ─────────────────────────────────────────────────────────────
  // T3: 분석 탭
  // ─────────────────────────────────────────────────────────────

  Widget _buildT3Tab() {
    final searchQuery = _t3TagSearchCtrl.text.toLowerCase();
    final recentFiltered = searchQuery.isEmpty
        ? _t3RecentTags
        : _t3RecentTags
            .where((t) => t.toLowerCase().contains(searchQuery))
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AND/OR 토글
          Row(
            children: [
              Text('태그 조건',
                  style: Theme.of(context).textTheme.labelMedium),
              const Spacer(),
              Text('AND', style: Theme.of(context).textTheme.bodySmall),
              Switch(
                value: !_t3TagModeAnd,
                onChanged: (val) =>
                    setState(() => _t3TagModeAnd = !val),
              ),
              Text('OR', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          // 태그 검색 (자동완성)
          TextField(
            controller: _t3TagSearchCtrl,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: '태그 검색',
              prefixIcon: Icon(Icons.label_outline),
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          // 최근 사용 태그 (최대 5개)
          if (recentFiltered.isNotEmpty) ...[
            Text('최근 사용',
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: recentFiltered.map((tag) {
                final isSelected = _t3SelectedTags.contains(tag);
                return FilterChip(
                  avatar: const Icon(Icons.history, size: 14),
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (_) => setState(() {
                    if (isSelected) {
                      _t3SelectedTags.remove(tag);
                    } else {
                      _t3SelectedTags.add(tag);
                    }
                  }),
                );
              }).toList(),
            ),
            const Divider(height: 16),
          ],
          // 선택된 태그 표시
          if (_t3SelectedTags.isNotEmpty) ...[
            Text(
              '선택됨 (${_t3TagModeAnd ? "AND" : "OR"})',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _t3SelectedTags.map((tag) {
                return Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () =>
                      setState(() => _t3SelectedTags.remove(tag)),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 공용 위젯
  // ─────────────────────────────────────────────────────────────

  /// Breadcrumb 네비게이션 바
  Widget _buildBreadcrumb({
    required List<String> crumbs,
    required void Function(int index) onTap,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < crumbs.length; i++) ...[
            if (i > 0)
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            GestureDetector(
              onTap: () => onTap(i),
              child: Text(
                crumbs[i],
                style: TextStyle(
                  fontSize: 12,
                  color: i == crumbs.length - 1
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  fontWeight: i == crumbs.length - 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// "이 레벨 이하 전체 선택" 토글 행
  Widget _buildSelectAllToggle({
    required String label,
    required bool isSelected,
    required VoidCallback onToggle,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(label,
              style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  /// 분류 노드 칩 목록 (짧은탭=선택, 긴탭=드릴다운)
  Widget _buildDimChips({
    required List<_DimNode> nodes,
    required Set<String> selected,
    required List<_DimNode> breadcrumb,
    required void Function(String code) onToggle,
    required void Function(_DimNode node) onDrillDown,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: nodes.map((node) {
        final isSelected = selected.contains(node.code);
        return GestureDetector(
          onLongPress: node.hasChildren ? () => onDrillDown(node) : null,
          child: FilterChip(
            label: Text(node.name),
            selected: isSelected,
            tooltip: node.hasChildren ? '길게 눌러 드릴다운' : null,
            onSelected: (_) => onToggle(node.code),
          ),
        );
      }).toList(),
    );
  }

  /// 필터 적용 버튼
  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // 초기화
                setState(() {
                  _t1BreadcrumbEquity.clear();
                  _t1SelectedEquityCodes.clear();
                  _t2BreadcrumbActivity.clear();
                  _t2SelectedActivityCodes.clear();
                  _t2BreadcrumbIncome.clear();
                  _t2SelectedIncomeCodes.clear();
                  _t2SelectedCurrency = null;
                  _t2CounterpartyCtrl.clear();
                  _t3SelectedTags.clear();
                  _t3TagSearchCtrl.clear();
                });
              },
              child: const Text('초기화'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton(
              onPressed: () {
                // 선택된 필터를 BLoC으로 전달
                final mapDimFilters = <String, List<int>>{};
                // TODO: DimensionValue DB ID가 확정되면 코드→ID 매핑 후 전달
                // 현재는 코드 기반 선택을 BLoC 필터 이벤트 구조에 맞게 변환
                context.read<PerspectiveBloc>().add(ApplyCustomFilter(
                  mapDimensionFilters: mapDimFilters,
                  mapAttributeFilters: _t2SelectedCurrency != null
                      ? {'currency': [_t2SelectedCurrency!.name]}
                      : null,
                  listTagIds: const [], // TODO: TagId 조회 후 전달
                ));
              },
              child: const Text('적용'),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: '프리셋으로 저장',
            onPressed: () => _showSavePresetDialog(context),
          ),
        ],
      ),
    );
  }

  void _showSavePresetDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('프리셋으로 저장'),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '프리셋 이름 입력',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isNotEmpty) {
                context
                    .read<PerspectiveBloc>()
                    .add(SaveAsPreset(name: name));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 시드 데이터 기반 정적 트리 — DimensionValue DB 조회 없이 UI에서 직접 사용
// =============================================================================

/// 분류 노드 (UI 표시용)
class _DimNode {
  const _DimNode({
    required this.code,
    required this.name,
    this.parentCode,
    this.hasChildren = false,
  });

  final String code;
  final String name;
  final String? parentCode;
  final bool hasChildren;
}

/// EQUITY_TYPE 트리 — 시드 데이터와 동기화
const List<_DimNode> _kEquityTree = [
  _DimNode(code: 'ASSET', name: '자산', parentCode: null, hasChildren: true),
  _DimNode(code: 'ASSET.CURRENT', name: '유동자산', parentCode: 'ASSET', hasChildren: true),
  _DimNode(code: 'ASSET.CURRENT.CASH', name: '현금및현금성자산', parentCode: 'ASSET.CURRENT'),
  _DimNode(code: 'ASSET.CURRENT.SHORT_TERM_FINANCIAL', name: '단기금융자산', parentCode: 'ASSET.CURRENT'),
  _DimNode(code: 'ASSET.CURRENT.RECEIVABLE', name: '매출채권및미수금', parentCode: 'ASSET.CURRENT'),
  _DimNode(code: 'ASSET.CURRENT.PREPAID', name: '선급금및선급비용', parentCode: 'ASSET.CURRENT'),
  _DimNode(code: 'ASSET.CURRENT.INVENTORY', name: '재고자산', parentCode: 'ASSET.CURRENT'),
  _DimNode(code: 'ASSET.NON_CURRENT', name: '비유동자산', parentCode: 'ASSET', hasChildren: true),
  _DimNode(code: 'ASSET.NON_CURRENT.INVESTMENT', name: '투자자산', parentCode: 'ASSET.NON_CURRENT'),
  _DimNode(code: 'ASSET.NON_CURRENT.TANGIBLE', name: '유형자산', parentCode: 'ASSET.NON_CURRENT'),
  _DimNode(code: 'ASSET.NON_CURRENT.INTANGIBLE', name: '무형자산', parentCode: 'ASSET.NON_CURRENT'),
  _DimNode(code: 'ASSET.NON_CURRENT.OTHER', name: '기타비유동자산', parentCode: 'ASSET.NON_CURRENT'),
  _DimNode(code: 'LIABILITY', name: '부채', parentCode: null, hasChildren: true),
  _DimNode(code: 'LIABILITY.CURRENT', name: '유동부채', parentCode: 'LIABILITY', hasChildren: true),
  _DimNode(code: 'LIABILITY.CURRENT.PAYABLE', name: '미지급금및미지급비용', parentCode: 'LIABILITY.CURRENT'),
  _DimNode(code: 'LIABILITY.CURRENT.SHORT_TERM_BORROWING', name: '단기차입금', parentCode: 'LIABILITY.CURRENT'),
  _DimNode(code: 'LIABILITY.CURRENT.WITHHOLDING', name: '예수금', parentCode: 'LIABILITY.CURRENT'),
  _DimNode(code: 'LIABILITY.CURRENT.ADVANCE', name: '선수금', parentCode: 'LIABILITY.CURRENT'),
  _DimNode(code: 'LIABILITY.NON_CURRENT', name: '비유동부채', parentCode: 'LIABILITY', hasChildren: true),
  _DimNode(code: 'LIABILITY.NON_CURRENT.LONG_TERM_BORROWING', name: '장기차입금', parentCode: 'LIABILITY.NON_CURRENT'),
  _DimNode(code: 'LIABILITY.NON_CURRENT.OTHER', name: '기타비유동부채', parentCode: 'LIABILITY.NON_CURRENT'),
  _DimNode(code: 'EQUITY', name: '자본', parentCode: null, hasChildren: true),
  _DimNode(code: 'EQUITY.CAPITAL', name: '자본금', parentCode: 'EQUITY'),
  _DimNode(code: 'EQUITY.RETAINED', name: '이익잉여금', parentCode: 'EQUITY'),
  _DimNode(code: 'EQUITY.OTHER', name: '기타자본', parentCode: 'EQUITY'),
  _DimNode(code: 'REVENUE', name: '수익', parentCode: null, hasChildren: true),
  _DimNode(code: 'REVENUE.OPERATING', name: '영업수익', parentCode: 'REVENUE'),
  _DimNode(code: 'REVENUE.FINANCIAL', name: '금융수익', parentCode: 'REVENUE'),
  _DimNode(code: 'REVENUE.INVESTMENT', name: '투자수익', parentCode: 'REVENUE'),
  _DimNode(code: 'REVENUE.OTHER', name: '기타수익', parentCode: 'REVENUE'),
  _DimNode(code: 'EXPENSE', name: '비용', parentCode: null, hasChildren: true),
  _DimNode(code: 'EXPENSE.LIVING', name: '생활비', parentCode: 'EXPENSE', hasChildren: true),
  _DimNode(code: 'EXPENSE.LIVING.FOOD', name: '식비', parentCode: 'EXPENSE.LIVING'),
  _DimNode(code: 'EXPENSE.LIVING.TRANSPORT', name: '교통비', parentCode: 'EXPENSE.LIVING'),
  _DimNode(code: 'EXPENSE.LIVING.TELECOM', name: '통신비', parentCode: 'EXPENSE.LIVING'),
  _DimNode(code: 'EXPENSE.LIVING.HOUSING', name: '주거비', parentCode: 'EXPENSE.LIVING'),
  _DimNode(code: 'EXPENSE.LIVING.MEDICAL', name: '의료비', parentCode: 'EXPENSE.LIVING'),
  _DimNode(code: 'EXPENSE.LIVING.EDUCATION', name: '교육비', parentCode: 'EXPENSE.LIVING'),
  _DimNode(code: 'EXPENSE.LIVING.CLOTHING', name: '의류비', parentCode: 'EXPENSE.LIVING'),
  _DimNode(code: 'EXPENSE.LIVING.CULTURE', name: '문화여가비', parentCode: 'EXPENSE.LIVING'),
  _DimNode(code: 'EXPENSE.OPERATING', name: '영업비용', parentCode: 'EXPENSE'),
  _DimNode(code: 'EXPENSE.FINANCIAL', name: '금융비용', parentCode: 'EXPENSE'),
  _DimNode(code: 'EXPENSE.DEPRECIATION', name: '감가상각비', parentCode: 'EXPENSE'),
  _DimNode(code: 'EXPENSE.TAX', name: '세금과공과', parentCode: 'EXPENSE'),
  _DimNode(code: 'EXPENSE.OTHER', name: '기타비용', parentCode: 'EXPENSE'),
];

/// ACTIVITY_TYPE 트리
const List<_DimNode> _kActivityTree = [
  _DimNode(code: 'HOUSEHOLD', name: '가계활동', parentCode: null, hasChildren: true),
  _DimNode(code: 'HOUSEHOLD.CONSUMPTION', name: '소비', parentCode: 'HOUSEHOLD'),
  _DimNode(code: 'HOUSEHOLD.SAVING', name: '저축', parentCode: 'HOUSEHOLD'),
  _DimNode(code: 'OPERATING', name: '영업활동', parentCode: null, hasChildren: true),
  _DimNode(code: 'OPERATING.SALES', name: '매출관련', parentCode: 'OPERATING'),
  _DimNode(code: 'OPERATING.PURCHASE', name: '매입관련', parentCode: 'OPERATING'),
  _DimNode(code: 'INVESTING', name: '투자활동', parentCode: null, hasChildren: true),
  _DimNode(code: 'INVESTING.TANGIBLE', name: '유형자산취득처분', parentCode: 'INVESTING'),
  _DimNode(code: 'INVESTING.FINANCIAL', name: '금융자산취득처분', parentCode: 'INVESTING'),
  _DimNode(code: 'FINANCING', name: '재무활동', parentCode: null, hasChildren: true),
  _DimNode(code: 'FINANCING.BORROWING', name: '차입금', parentCode: 'FINANCING'),
  _DimNode(code: 'FINANCING.DIVIDEND', name: '배당금지급', parentCode: 'FINANCING'),
];

/// INCOME_TYPE 트리
const List<_DimNode> _kIncomeTree = [
  _DimNode(code: 'INTEREST', name: '이자소득', parentCode: null, hasChildren: true),
  _DimNode(code: 'INTEREST.COMPREHENSIVE', name: '종합과세', parentCode: 'INTEREST'),
  _DimNode(code: 'INTEREST.SEPARATE', name: '분리과세', parentCode: 'INTEREST'),
  _DimNode(code: 'DIVIDEND', name: '배당소득', parentCode: null, hasChildren: true),
  _DimNode(code: 'DIVIDEND.COMPREHENSIVE', name: '종합과세', parentCode: 'DIVIDEND'),
  _DimNode(code: 'DIVIDEND.SEPARATE', name: '분리과세', parentCode: 'DIVIDEND'),
  _DimNode(code: 'DIVIDEND.GROSSUP', name: '종합과세(Gross-up)', parentCode: 'DIVIDEND'),
  _DimNode(code: 'BUSINESS', name: '사업소득', parentCode: null),
  _DimNode(code: 'EMPLOYMENT', name: '근로소득', parentCode: null),
  _DimNode(code: 'PENSION', name: '연금소득', parentCode: null),
  _DimNode(code: 'CAPITAL_GAINS', name: '양도소득', parentCode: null),
  _DimNode(code: 'RETIREMENT', name: '퇴직소득', parentCode: null),
  _DimNode(code: 'OTHER', name: '기타소득', parentCode: null),
];
