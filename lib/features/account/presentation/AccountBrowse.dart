import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/Account.dart';
import '../../../core/constants/Enums.dart';
import '../../../core/models/TypedId.dart';
import 'AccountBloc.dart';
import 'AccountState.dart';
import 'widgets/MetaphorIcon.dart';
import 'widgets/TreeRow.dart';

/// 조회 모드 — 들여쓰기 트리 + 메타포 + 사용량
class AccountBrowse extends StatefulWidget {
  const AccountBrowse({super.key});

  @override
  State<AccountBrowse> createState() => _AccountBrowseState();
}

class _AccountBrowseState extends State<AccountBrowse> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.errorMessage != null) {
          return Center(child: Text('오류: ${state.errorMessage}'));
        }
        if (state.listRoots.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_tree_outlined, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
                const SizedBox(height: 12),
                Text(
                  '계정과목이 없습니다',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  '계정과목을 추가하면 여기 표시됩니다',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '계정명 검색',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                onChanged: (v) => setState(() => _searchQuery = v.trim().toLowerCase()),
              ),
            ),
            Expanded(
              child: _searchQuery.isNotEmpty
                  ? _LocalSearchList(
                      results: state.listAll
                          .where((a) => a.name.toLowerCase().contains(_searchQuery))
                          .toList(),
                      query: _searchQuery,
                    )
                  : _AccountTree(
                      roots: state.listRoots,
                      allAccounts: state.listAll,
                      mapBalances: state.mapBalances,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _AccountTree extends StatelessWidget {
  const _AccountTree({
    required this.roots,
    required this.allAccounts,
    required this.mapBalances,
  });
  final List<Account> roots;
  final List<Account> allAccounts;
  final Map<AccountId, int> mapBalances;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: roots.length,
      itemBuilder: (context, index) {
        final root = roots[index];
        return InkWell(
          onTap: () => _showAccountDetail(context, root),
          child: TreeRow(
            account: root,
            depth: 0,
            allAccounts: allAccounts,
            mapBalances: mapBalances,
            balance: mapBalances[root.id],
          ),
        );
      },
    );
  }
}

class _LocalSearchList extends StatelessWidget {
  const _LocalSearchList({required this.results, required this.query});
  final List<Account> results;
  final String query;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off,
                size: 40,
                color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 8),
            Text(
              "'$query' 검색 결과 없음",
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final acc = results[index];
        return ListTile(
          leading: Text(
            _emojiFor(acc.nature),
            style: const TextStyle(fontSize: 20),
          ),
          title: Text(acc.name),
          subtitle: Text(
            acc.equityTypePath,
            style: const TextStyle(fontSize: 11),
          ),
          trailing: acc.isActive
              ? null
              : const Icon(Icons.block, size: 14, color: Colors.grey),
          onTap: () => _showAccountDetail(context, acc),
        );
      },
    );
  }

  String _emojiFor(AccountNature nature) {
    return switch (nature) {
      AccountNature.asset => '🌳',
      AccountNature.expense => '🍎',
      AccountNature.revenue => '💧',
      AccountNature.liability => '🫙',
      AccountNature.equity => '🪣',
    };
  }
}

void _showAccountDetail(BuildContext context, Account account) {
  final isDebitNormal = account.nature == AccountNature.asset ||
      account.nature == AccountNature.expense;
  showModalBottomSheet<void>(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                MetaphorIcon.emojiFor(account.nature),
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  account.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            account.equityTypePath,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(account.isActive ? '활성' : '비활성')),
              Chip(label: Text(isDebitNormal ? '차변 계정' : '대변 계정')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ),
        ],
      ),
    ),
  );
}
