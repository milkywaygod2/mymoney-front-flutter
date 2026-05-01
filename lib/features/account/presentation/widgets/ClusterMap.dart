import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/domain/Account.dart';
import '../../../../core/constants/Enums.dart';
import 'MetaphorIcon.dart';

/// 5클러스터 계정 지도 시각화 — CustomPainter 기반
class ClusterMap extends StatelessWidget {
  const ClusterMap({
    super.key,
    required this.listAccounts,
  });

  final List<Account> listAccounts;

  @override
  Widget build(BuildContext context) {
    if (listAccounts.isEmpty) {
      return const Center(child: Text('계정과목 없음'));
    }

    // nature별 그룹화
    final Map<AccountNature, List<Account>> grouped = {};
    for (final acc in listAccounts) {
      grouped.putIfAbsent(acc.nature, () => []).add(acc);
    }

    return Stack(
      children: [
        CustomPaint(
          painter: _ClusterLinePainter(),
          child: const SizedBox.expand(),
        ),
        ...AccountNature.values.map(
          (nature) => _ClusterBubble(
            nature: nature,
            accounts: grouped[nature] ?? [],
          ),
        ),
      ],
    );
  }
}

/// 5클러스터 배치 좌표 (상대 비율)
const _kClusterPositions = {
  AccountNature.asset: Offset(0.5, 0.18),     // 상단 중앙 — 자산
  AccountNature.liability: Offset(0.15, 0.55), // 좌측 중단 — 부채
  AccountNature.equity: Offset(0.85, 0.55),   // 우측 중단 — 자본
  AccountNature.revenue: Offset(0.75, 0.82),  // 우하단 — 수익
  AccountNature.expense: Offset(0.25, 0.82),  // 좌하단 — 비용
};

class _ClusterBubble extends StatefulWidget {
  const _ClusterBubble({
    required this.nature,
    required this.accounts,
  });

  final AccountNature nature;
  final List<Account> accounts;

  @override
  State<_ClusterBubble> createState() => _ClusterBubbleState();
}

class _ClusterBubbleState extends State<_ClusterBubble> {
  bool _isShowingSheet = false;

  static const _kNatureColors = {
    AccountNature.asset: Color(0xFF4CAF50),
    AccountNature.liability: Color(0xFFF44336),
    AccountNature.equity: Color(0xFF9C27B0),
    AccountNature.revenue: Color(0xFF2196F3),
    AccountNature.expense: Color(0xFFFF9800),
  };

  static const _kNatureLabels = {
    AccountNature.asset: '자산',
    AccountNature.liability: '부채',
    AccountNature.equity: '자본',
    AccountNature.revenue: '수익',
    AccountNature.expense: '비용',
  };

  @override
  Widget build(BuildContext context) {
    final pos = _kClusterPositions[widget.nature]!;
    final color = _kNatureColors[widget.nature]!;
    final count = widget.accounts.length;
    // 계정 수에 비례한 버블 크기 (최소 56, 최대 100)
    final size = (56.0 + min(count * 4.0, 44.0)).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final x = pos.dx * constraints.maxWidth - size / 2;
        final y = pos.dy * constraints.maxHeight - size / 2;

        return Positioned(
          left: x.clamp(0.0, constraints.maxWidth - size),
          top: y.clamp(0.0, constraints.maxHeight - size),
          child: GestureDetector(
            onTap: () => _showAccountList(context),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    MetaphorIcon.emojiFor(widget.nature),
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(
                    _kNatureLabels[widget.nature]!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    '$count',
                    style: TextStyle(fontSize: 10, color: color),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAccountList(BuildContext context) {
    if (_isShowingSheet) return;
    setState(() => _isShowingSheet = true);
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _AccountListSheet(
        nature: widget.nature,
        accounts: widget.accounts,
      ),
    ).whenComplete(() {
      if (mounted) setState(() => _isShowingSheet = false);
    });
  }
}

class _AccountListSheet extends StatelessWidget {
  const _AccountListSheet({
    required this.nature,
    required this.accounts,
  });

  final AccountNature nature;
  final List<Account> accounts;

  static const _kNatureLabels = {
    AccountNature.asset: '자산',
    AccountNature.liability: '부채',
    AccountNature.equity: '자본',
    AccountNature.revenue: '수익',
    AccountNature.expense: '비용',
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(MetaphorIcon.emojiFor(nature)),
                const SizedBox(width: 8),
                Text(
                  '${_kNatureLabels[nature]} 계정과목 (${accounts.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: accounts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => ListTile(
                dense: true,
                title: Text(accounts[i].name),
                subtitle: Text(
                  accounts[i].equityTypePath,
                  style: const TextStyle(fontSize: 10),
                ),
                trailing: accounts[i].isActive
                    ? null
                    : const Icon(Icons.block, size: 14, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 클러스터 간 관계선 (자산=부채+자본, 수익→이익잉여금)
class _ClusterLinePainter extends CustomPainter {
  const _ClusterLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // 자산 — 부채 연결
    final asset = _kClusterPositions[AccountNature.asset]!;
    final liability = _kClusterPositions[AccountNature.liability]!;
    final equity = _kClusterPositions[AccountNature.equity]!;
    final revenue = _kClusterPositions[AccountNature.revenue]!;
    final expense = _kClusterPositions[AccountNature.expense]!;

    void drawLine(Offset a, Offset b) {
      canvas.drawLine(
        Offset(a.dx * size.width, a.dy * size.height),
        Offset(b.dx * size.width, b.dy * size.height),
        paint,
      );
    }

    drawLine(asset, liability);
    drawLine(asset, equity);
    drawLine(equity, revenue);
    drawLine(expense, liability);
  }

  @override
  bool shouldRepaint(_ClusterLinePainter _) => false;
}
