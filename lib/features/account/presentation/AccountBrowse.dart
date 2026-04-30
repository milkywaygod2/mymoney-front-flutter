import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/Account.dart';
import '../../../core/constants/Enums.dart';
import 'AccountBloc.dart';
import 'AccountState.dart';
import 'widgets/TreeRow.dart';

/// 조회 모드 — 들여쓰기 트리 + 메타포 + 사용량
class AccountBrowse extends StatelessWidget {
  const AccountBrowse({super.key});

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
          return const Center(child: Text('계정과목이 없습니다'));
        }

        final searchResults = state.listSearchResults;
        if (searchResults.isNotEmpty) {
          return _SearchResultList(results: searchResults);
        }

        return _AccountTree(roots: state.listRoots);
      },
    );
  }
}

class _AccountTree extends StatelessWidget {
  const _AccountTree({required this.roots});
  final List<Account> roots;

  /// equityTypePath 기반 1단계 자식 추출
  List<Account> _childrenOf(Account parent, List<Account> allRoots) {
    final parentPath = parent.equityTypePath;
    return allRoots.where((a) {
      final path = a.equityTypePath;
      if (!path.startsWith('$parentPath.')) return false;
      // 직접 자식만 (depth +1)
      final suffix = path.substring(parentPath.length + 1);
      return !suffix.contains('.');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: roots.length,
      itemBuilder: (context, index) {
        final root = roots[index];
        return TreeRow(
          account: root,
          depth: 0,
          children: _childrenOf(root, roots),
        );
      },
    );
  }
}

class _SearchResultList extends StatelessWidget {
  const _SearchResultList({required this.results});
  final List<Account> results;

  @override
  Widget build(BuildContext context) {
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
