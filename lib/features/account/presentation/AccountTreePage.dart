import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/Enums.dart';
import '../../perspective/presentation/LensSwitcher.dart';
import '../../perspective/presentation/PerspectiveBloc.dart';
import 'AccountBloc.dart';
import 'AccountEvent.dart';
import 'AccountBrowse.dart';
import 'AccountMap.dart';
import 'AccountConfig.dart';
import 'widgets/ModeToggle.dart';

/// 계정과목 트리 페이지 — 조회/지도/설정 3모드 토글
/// Wave U5 재작성
class AccountTreePage extends StatefulWidget {
  const AccountTreePage({super.key});

  @override
  State<AccountTreePage> createState() => _AccountTreePageState();
}

class _AccountTreePageState extends State<AccountTreePage> {
  AccountViewMode _mode = AccountViewMode.browse;

  @override
  void initState() {
    super.initState();
    // 트리 초기 로딩
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountBloc>().add(const AccountEvent.loadTree());
    });
    _loadViewMode();
  }

  Future<void> _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('account_view_mode') ?? 0;
    final mode = AccountViewMode.values[saved.clamp(0, AccountViewMode.values.length - 1)];
    if (mounted && mode != _mode) {
      setState(() => _mode = mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정과목'),
        actions: [
          if (_mode == AccountViewMode.browse) ...[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: '검색',
              onPressed: () => _showSearchDialog(context),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: '관점 전환',
            onPressed: () => _showLensSwitcher(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '계정 추가',
            onPressed: () => _showAddAccountSheet(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ModeToggle(
              selected: _mode,
              onChanged: (mode) {
                setState(() => _mode = mode);
                SharedPreferences.getInstance().then(
                  (prefs) => prefs.setInt('account_view_mode', mode.index),
                );
              },
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: switch (_mode) {
          AccountViewMode.browse => const AccountBrowse(key: ValueKey('browse')),
          AccountViewMode.map => const AccountMap(key: ValueKey('map')),
          AccountViewMode.config => const AccountConfig(key: ValueKey('config')),
        },
      ),
    );
  }

  void _showLensSwitcher(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<PerspectiveBloc>(),
        child: const LensSwitcher(),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('계정과목 검색'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '계정명 입력...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              context.read<AccountBloc>().add(
                    AccountEvent.searchAccounts(query: query),
                  );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 검색 결과 초기화 후 닫기
                context.read<AccountBloc>().add(
                      const AccountEvent.searchAccounts(query: ''),
                    );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _showAddAccountSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddAccountSheet(),
    );
  }
}

/// 계정과목 추가 BottomSheet
class _AddAccountSheet extends StatefulWidget {
  const _AddAccountSheet();

  @override
  State<_AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends State<_AddAccountSheet> {
  final _nameController = TextEditingController();
  AccountNature _nature = AccountNature.asset;

  static const _kNatureLabels = {
    AccountNature.asset: '자산',
    AccountNature.liability: '부채',
    AccountNature.equity: '자본',
    AccountNature.revenue: '수익',
    AccountNature.expense: '비용',
  };

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '계정과목 추가',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: '계정명',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Text('계정 성격', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: AccountNature.values.map((nature) {
              return ChoiceChip(
                label: Text(_kNatureLabels[nature]!),
                selected: _nature == nature,
                onSelected: (_) => setState(() => _nature = nature),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            '※ 분류 경로(Path) 등 상세 설정은 추후 지원 예정',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _nameController.text.trim().isEmpty ? null : _onSave,
              child: const Text('저장'),
            ),
          ),
        ],
      ),
    );
  }

  void _onSave() {
    // TODO: 실제 CreateAccount 이벤트 연동 (equityTypeId 등 필수값 확보 후)
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('계정과목 추가 기능은 분류 경로 설정 후 활성화됩니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
