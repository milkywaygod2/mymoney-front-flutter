import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/Enums.dart';
import '../../../../core/models/TypedId.dart';
import '../../../account/presentation/AccountBloc.dart';
import '../../../account/presentation/AccountState.dart';

/// V2 계정 선택 모달
class AccountPicker extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) =>
          BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: state.listRoots.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final acc = state.listRoots[i];
                          final isSelected = acc.id == selectedId;
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
                            onTap: () => onSelected(acc.id),
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
