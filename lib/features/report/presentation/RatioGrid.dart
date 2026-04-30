import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/AppColors.dart';
import '../../../core/models/FinancialRatio.dart';
import 'ReportBloc.dart';

/// 재무비율 카드 그리드 — 4섹션(유동성/수익성/안정성/효율성) 세로 나열
class RatioGrid extends StatelessWidget {
  const RatioGrid({super.key});

  static const _kSections = [
    _RatioSection(
      label: '유동성',
      icon: Icons.water_drop_outlined,
      color: AppColors.equitySoft,
      listCodes: ['CURRENT_RATIO', 'QUICK_RATIO', 'NWC_TURNOVER'],
    ),
    _RatioSection(
      label: '수익성',
      icon: Icons.trending_up,
      color: AppColors.natureAsset,
      listCodes: [
        'ROA', 'ROE', 'ROIC', 'EBITDA_MARGIN',
        'SAVINGS_RATE', 'NET_ASSET_GROWTH',
      ],
    ),
    _RatioSection(
      label: '안정성',
      icon: Icons.shield_outlined,
      color: AppColors.liabilitySoft,
      listCodes: [
        'DEBT_RATIO', 'NET_DEBT_RATIO', 'INTEREST_COVERAGE',
        'CAPITAL_RESERVE', 'FINANCIAL_COST_RATIO',
        'CURRENT_LIABILITY_RATIO', 'NON_CURRENT_LIABILITY_RATIO',
      ],
    ),
    _RatioSection(
      label: '효율성',
      icon: Icons.loop,
      color: AppColors.stateDraft,
      listCodes: [
        'ASSET_TURNOVER', 'EQUITY_TURNOVER', 'AR_TURNOVER',
        'AR_DAYS', 'AP_TURNOVER', 'INVENTORY_TURNOVER',
        'TANGIBLE_ASSET_TURNOVER',
        'CURRENT_ASSET_GROWTH', 'TANGIBLE_ASSET_GROWTH', 'EQUITY_GROWTH',
        'DONATION_RATIO', 'PER', 'EPS',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (prev, curr) => prev.listRatios != curr.listRatios,
      builder: (context, state) {
        final listRatios = state.listRatios ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  '재무비율',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ..._kSections.map((section) {
                final filtered = listRatios
                    .where((r) => section.listCodes.contains(r.ratioCode))
                    .toList();
                return _RatioSectionWidget(
                  section: section,
                  listRatios: filtered,
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

/// 섹션 메타데이터
class _RatioSection {
  const _RatioSection({
    required this.label,
    required this.icon,
    required this.color,
    required this.listCodes,
  });

  final String label;
  final IconData icon;
  final Color color;
  final List<String> listCodes;
}

/// 섹션 헤더 + 카드 그리드
class _RatioSectionWidget extends StatelessWidget {
  const _RatioSectionWidget({
    required this.section,
    required this.listRatios,
  });

  final _RatioSection section;
  final List<FinancialRatio> listRatios;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              Icon(section.icon, size: 16, color: section.color),
              const SizedBox(width: 6),
              Text(
                section.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: section.color,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${listRatios.length})',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        // 카드 그리드
        if (listRatios.isEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              '데이터 없음',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.7,
            ),
            itemCount: listRatios.length,
            itemBuilder: (context, i) => _RatioCard(
              ratio: listRatios[i],
              accentColor: section.color,
            ),
          ),
        const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}

class _RatioCard extends StatelessWidget {
  const _RatioCard({required this.ratio, required this.accentColor});

  final FinancialRatio ratio;
  final Color accentColor;

  String get _displayName => _kRatioNames[ratio.ratioCode] ?? ratio.ratioCode;

  String get _formattedValue {
    final v = ratio.ratioValue;
    final whole = v ~/ 100;
    final decimal = (v.abs() % 100).toString().padLeft(2, '0');
    return '$whole.$decimal%';
  }

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

  @override
  Widget build(BuildContext context) {
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
                color: accentColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '분자: ${_fmtInt(ratio.numerator)}',
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
                Text(
                  '분모: ${_fmtInt(ratio.denominator)}',
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmtInt(int v) {
    if (v.abs() >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v.abs() >= 10000) return '${(v / 10000).toStringAsFixed(1)}만';
    return v.toString();
  }
}
