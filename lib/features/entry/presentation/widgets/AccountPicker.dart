import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/Enums.dart';
import '../../../../core/models/TypedId.dart';
import '../../../account/presentation/AccountBloc.dart';
import '../../../account/presentation/AccountState.dart';

/// V2 계정 선택 모달
class AccountPicker extends StatefulWidget {
  const AccountPicker({
    super.key,
    required this.title,
    required this.onSelected,
    this.selectedId,
  });

  final String title;
  final ValueChanged<AccountId> onSelected;
  final AccountId? selectedId;

  static Future<AccountId?> show(
    BuildContext context, {
    required String title,
    AccountId? selectedId,
  }) {
    return showModalBottomSheet<AccountId>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<AccountBloc>(),
        child: AccountPicker(
          title: title,
          onSelected: (id) => Navigator.of(context).pop(id),
          selectedId: selectedId,
        ),
      ),
    );
  }

  @override
  State<AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> {
  AccountNature? _selectedNature;

  static const _kNatureLabels = <String, AccountNature>{
    '자산': AccountNature.asset,
    '부채': AccountNature.liability,
    '자본': AccountNature.equity,
    '수익': AccountNature.revenue,
    '비용': AccountNature.expense,
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) =>
          BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final accounts = _selectedNature == null
              ? state.listAll
              : state.listAll.where((a) => a.nature == _selectedNature).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 필터 칩
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('전체'),
                        selected: _selectedNature == null,
                        onSelected: (_) => setState(() => _selectedNature = null),
                      ),
                    ),
                    ..._kNatureLabels.entries.map((e) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(e.key),
                        selected: _selectedNature == e.value,
                        onSelected: (_) => setState(() => _selectedNature = e.value),
                      ),
                    )),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : accounts.isEmpty
                        ? Center(
                            child: Text(
                              '해당 계정이 없습니다',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            itemCount: accounts.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, i) {
                              final acc = accounts[i];
                              final isSelected = acc.id == widget.selectedId;
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
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : null,
                                onTap: () => widget.onSelected(acc.id),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
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
