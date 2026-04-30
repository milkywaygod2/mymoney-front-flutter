import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/models/FinancialRatio.dart';
import 'ReportBloc.dart';

/// 재무비율 카드 그리드 — 카테고리별 탭 + 최대 29종
class RatioGrid extends StatefulWidget {
  const RatioGrid({super.key});

  @override
  State<RatioGrid> createState() => _RatioGridState();
}

class _RatioGridState extends State<RatioGrid>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _kCategories = [
    (label: '전체', value: null),
    (label: '수익성', value: RatioCategory.profitability),
    (label: '안정성', value: RatioCategory.stability),
    (label: '활동성', value: RatioCategory.activity),
    (label: '성장성', value: RatioCategory.growth),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _kCategories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (prev, curr) => prev.listRatios != curr.listRatios,
      builder: (context, state) {
        final listRatios = state.listRatios ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                '재무비율',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: _kCategories
                  .map((c) => Tab(text: c.label))
                  .toList(),
            ),
            SizedBox(
              height: 320,
              child: TabBarView(
                controller: _tabController,
                children: _kCategories.map((cat) {
                  final filtered = cat.value == null
                      ? listRatios
                      : listRatios
                          .where((r) => r.category == cat.value!.name)
                          .toList();
                  return _RatioCardGrid(listRatios: filtered);
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RatioCardGrid extends StatelessWidget {
  const _RatioCardGrid({required this.listRatios});
  final List<FinancialRatio> listRatios;

  @override
  Widget build(BuildContext context) {
    if (listRatios.isEmpty) {
      return const Center(child: Text('데이터 없음'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.6,
      ),
      itemCount: listRatios.length,
      itemBuilder: (context, index) =>
          _RatioCard(ratio: listRatios[index]),
    );
  }
}

class _RatioCard extends StatelessWidget {
  const _RatioCard({required this.ratio});
  final FinancialRatio ratio;

  String get _displayName => _kRatioNames[ratio.ratioCode] ?? ratio.ratioCode;

  String get _formattedValue {
    final v = ratio.ratioValue;
    final whole = v ~/ 100;
    final decimal = (v.abs() % 100).toString().padLeft(2, '0');
    return '$whole.$decimal%';
  }

  // ratioCode → 한국어 표시명
  static const _kRatioNames = <String, String>{
    'NET_ASSET_GROWTH': '순자산증가율',
    'SAVINGS_RATE': '저축율',
    'CURRENT_RATIO': '유동비율',
    'DEBT_RATIO': '부채비율',
    'ROA': 'ROA',
    'ROE': 'ROE',
    'AR_TURNOVER': '매출채권회전율',
    'INTEREST_COVERAGE': '이자보상비율',
    'CAPITAL_RESERVE': '자본유보율',
    'ASSET_TURNOVER': '총자산회전율',
    'EQUITY_TURNOVER': '자기자본회전율',
    'AR_DAYS': '채권회수기간(일)',
    'DONATION_RATIO': '기부금비율',
    'PER': 'PER',
    'EPS': 'EPS',
    'ROIC': 'ROIC',
    'EBITDA_MARGIN': 'EBITDA마진율',
    'CURRENT_ASSET_GROWTH': '유동자산증가율',
    'TANGIBLE_ASSET_GROWTH': '유형자산증가율',
    'EQUITY_GROWTH': '자기자본증가율',
    'CURRENT_LIABILITY_RATIO': '유동부채비율',
    'NON_CURRENT_LIABILITY_RATIO': '비유동부채비율',
    'NET_DEBT_RATIO': '순부채비율',
    'QUICK_RATIO': '당좌비율',
    'FINANCIAL_COST_RATIO': '금융비용부담률',
    'INVENTORY_TURNOVER': '재고자산회전율',
    'NWC_TURNOVER': '순운전자본회전율',
    'TANGIBLE_ASSET_TURNOVER': '유형자산회전율',
    'AP_TURNOVER': '매입채무회전율',
  };

  Color _categoryColor(BuildContext context) {
    final cat = _kCategoryColors[ratio.category];
    return cat ?? Theme.of(context).colorScheme.primary;
  }

  static const _kCategoryColors = <String, Color>{
    'profitability': Color(0xFF2196F3),
    'stability': Color(0xFF4CAF50),
    'activity': Color(0xFFFF9800),
    'growth': Color(0xFF9C27B0),
  };

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(context);
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _displayName,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _formattedValue,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '분자: ${_formatInt(ratio.numerator)}',
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
                Text(
                  '분모: ${_formatInt(ratio.denominator)}',
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatInt(int v) {
    if (v.abs() >= 100000000) {
      return '${(v / 100000000).toStringAsFixed(1)}억';
    } else if (v.abs() >= 10000) {
      return '${(v / 10000).toStringAsFixed(1)}만';
    }
    return v.toString();
  }
}
