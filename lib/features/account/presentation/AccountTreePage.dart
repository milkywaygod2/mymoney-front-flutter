import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/Account.dart';
import '../../../core/constants/Enums.dart';
import '../../../core/models/TypedId.dart';
import 'AccountBloc.dart';
import 'AccountEvent.dart';
import 'AccountState.dart';

/// Nature별 색상 매핑 — Balance Flow Card와 동일 체계
Color _natureColor(AccountNature nature) {
  return switch (nature) {
    AccountNature.asset => const Color(0xFF4CAF50),     // 초록
    AccountNature.liability => const Color(0xFFF44336), // 빨강
    AccountNature.equity => const Color(0xFF9C27B0),    // 보라
    AccountNature.revenue => const Color(0xFF2196F3),   // 파랑
    AccountNature.expense => const Color(0xFFFF9800),   // 주황
  };
}

/// 계정과목 트리 페이지 — 펼치기/접기, nature 색상 표시
class AccountTreePage extends StatelessWidget {
  const AccountTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정과목 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text('오류: ${state.errorMessage}'));
          }
          if (state.listRoots.isEmpty) {
            return const Center(child: Text('계정과목이 없습니다'));
          }
          return ListView.builder(
            itemCount: state.listRoots.length,
            itemBuilder: (context, index) {
              return _AccountTreeTile(
                account: state.listRoots[index],
                depth: 0,
              );
            },
          );
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('계정과목 검색'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '계정명 입력...',
            ),
            onChanged: (query) {
              context.read<AccountBloc>().add(
                    AccountEvent.searchAccounts(query: query),
                  );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}

/// 트리 노드 타일 — 들여쓰기 + nature 색상 점 + 펼치기/접기 아이콘
class _AccountTreeTile extends StatelessWidget {
  const _AccountTreeTile({
    required this.account,
    required this.depth,
  });

  final Account account;
  final int depth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final bool isExpanded = state.setExpandedIds.contains(account.id);
        // 하위 계정이 있는지 판단 — path 기반 (구현 시 children 목록 필요, 현재는 확장 아이콘만)
        final bool hasChildren = account.equityTypePath.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // 펼치기/접기 토글
                if (isExpanded) {
                  context.read<AccountBloc>().add(
                        AccountEvent.collapseNode(id: account.id),
                      );
                } else {
                  context.read<AccountBloc>().add(
                        AccountEvent.expandNode(id: account.id),
                      );
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0 + (depth * 24.0),
                  top: 12.0,
                  bottom: 12.0,
                  right: 16.0,
                ),
                child: Row(
                  children: [
                    // 펼치기/접기 아이콘
                    if (hasChildren)
                      Icon(
                        isExpanded
                            ? Icons.expand_more
                            : Icons.chevron_right,
                        size: 20,
                        color: Colors.grey,
                      )
                    else
                      const SizedBox(width: 20),
                    const SizedBox(width: 8),
                    // Nature 색상 점
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _natureColor(account.nature),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 계정명
                    Expanded(
                      child: Text(
                        account.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: depth == 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    // 비활성 표시
                    if (!account.isActive)
                      const Chip(
                        label: Text(
                          '비활성',
                          style: TextStyle(fontSize: 10),
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
            ),
            // 구분선
            const Divider(height: 1, indent: 16),
          ],
        );
      },
    );
  }
}
