import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/AppColors.dart';
import '../../../../core/domain/Account.dart';
import '../../../../core/constants/Enums.dart';
import '../../../../core/models/TypedId.dart';
import '../AccountBloc.dart';
import '../AccountEvent.dart';
import '../AccountState.dart';
import 'MetaphorIcon.dart';

/// 계정과목 트리 행 — 들여쓰기 + 메타포 아이콘 + 잔액 표시 (재귀 렌더링)
class TreeRow extends StatelessWidget {
  const TreeRow({
    super.key,
    required this.account,
    required this.depth,
    required this.allAccounts,
    required this.mapBalances,
    this.balance,
  });

  final Account account;
  final int depth;
  final List<Account> allAccounts;
  final Map<AccountId, int> mapBalances;
  final int? balance;

  List<Account> get _children {
    final parentPath = account.equityTypePath;
    return allAccounts.where((a) {
      final path = a.equityTypePath;
      if (!path.startsWith('$parentPath.')) return false;
      final suffix = path.substring(parentPath.length + 1);
      return !suffix.contains('.');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (prev, curr) =>
          prev.setExpandedIds != curr.setExpandedIds,
      builder: (context, state) {
        final isExpanded = state.setExpandedIds.contains(account.id);
        final children = _children;
        final hasChildren = children.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: hasChildren
                  ? () => _toggleExpand(context, state, isExpanded)
                  : null,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0 + depth * 20.0,
                  top: 10,
                  bottom: 10,
                  right: 16,
                ),
                child: Row(
                  children: [
                    // 펼치기/접기 아이콘
                    SizedBox(
                      width: 20,
                      child: hasChildren
                          ? Icon(
                              isExpanded
                                  ? Icons.expand_more
                                  : Icons.chevron_right,
                              size: 18,
                              color: Colors.grey,
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 6),
                    MetaphorIcon(nature: account.nature, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        account.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: depth == 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: account.isActive
                              ? null
                              : Colors.grey,
                        ),
                      ),
                    ),
                    if (depth == 0)
                      _NatureChip(nature: account.nature),
                    if (balance != null && balance != 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          '₩${_fmtCompact(balance!)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: balance! >= 0
                                ? AppColors.natureAsset
                                : AppColors.natureExpense,
                          ),
                        ),
                      ),
                    if (!account.isActive)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.block,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // 자식 행 (펼쳐진 경우) — 재귀 렌더링
            if (isExpanded && hasChildren)
              ...children.map(
                (child) => TreeRow(
                  account: child,
                  depth: depth + 1,
                  allAccounts: allAccounts,
                  mapBalances: mapBalances,
                  balance: mapBalances[child.id],
                ),
              ),
            if (depth == 0) const Divider(height: 1),
          ],
        );
      },
    );
  }

  void _toggleExpand(
      BuildContext context, AccountState state, bool isExpanded) {
    if (isExpanded) {
      context.read<AccountBloc>().add(
            AccountEvent.collapseNode(id: account.id),
          );
    } else {
      context.read<AccountBloc>().add(
            AccountEvent.expandNode(id: account.id),
          );
    }
  }

  String _fmtCompact(int v) {
    final abs = v.abs();
    final sign = v < 0 ? '-' : '';
    if (abs >= 1000000) return '$sign${(abs / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '$sign${(abs / 1000).toStringAsFixed(0)}K';
    return '$sign$abs';
  }
}

class _NatureChip extends StatelessWidget {
  const _NatureChip({required this.nature});
  final AccountNature nature;

  static const _kLabels = {
    AccountNature.asset: '자산',
    AccountNature.liability: '부채',
    AccountNature.equity: '자본',
    AccountNature.revenue: '수익',
    AccountNature.expense: '비용',
  };

  static const _kColors = {
    AccountNature.asset: Color(0xFF4CAF50),
    AccountNature.liability: Color(0xFFF44336),
    AccountNature.equity: Color(0xFF9C27B0),
    AccountNature.revenue: Color(0xFF2196F3),
    AccountNature.expense: Color(0xFFFF9800),
  };

  @override
  Widget build(BuildContext context) {
    final color = _kColors[nature] ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _kLabels[nature] ?? '',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
