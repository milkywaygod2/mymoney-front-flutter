import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../account/presentation/AccountBloc.dart';
import '../../account/presentation/AccountEvent.dart';
import '../../entry/presentation/EntryPage.dart';
import 'JournalBloc.dart';
import 'JournalEvent.dart';
import 'JournalState.dart';
import 'JournalV1.dart';
import 'JournalV2.dart';
import 'JournalV3.dart';

/// JournalPage — V1/V2/V3 토글 컨테이너 (재작성)
class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
    context.read<JournalBloc>().add(const LoadTransactions());
    context.read<AccountBloc>().add(const AccountEvent.loadTree());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (index == _selectedIndex) return;
    _fadeController.reverse().then((_) {
      setState(() => _selectedIndex = index);
      _fadeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _VariantToggle(
          selected: _selectedIndex,
          onChanged: _onTabChanged,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }
          return FadeTransition(
            opacity: _fadeAnim,
            child: _buildVariant(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EntryPage.show(context),
        tooltip: '거래 입력',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVariant() {
    return switch (_selectedIndex) {
      0 => const JournalV1(),
      1 => const JournalV2(),
      2 => const JournalV3(),
      _ => const JournalV1(),
    };
  }
}

class _VariantToggle extends StatelessWidget {
  const _VariantToggle({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['일반', '분개장', '흐름'];
    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final isActive = selected == i;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? Theme.of(context).colorScheme.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
                border: isActive
                    ? Border.all(color: Theme.of(context).colorScheme.outlineVariant)
                    : Border.all(color: Colors.transparent),
                boxShadow: isActive
                    ? [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 3, offset: const Offset(0, 1))]
                    : null,
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
