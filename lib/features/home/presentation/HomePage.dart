import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entry/presentation/EntryPage.dart';
import 'HomeBloc.dart';
import 'HomeV1.dart';
import 'HomeV2.dart';
import 'HomeV3.dart';

/// HomePage — V1/V2/V3 세그먼트 토글 컨테이너
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
    context.read<HomeBloc>().add(const LoadHome());
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<HomeBloc>().add(const RefreshHome()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EntryPage.show(context),
        tooltip: '거래 입력',
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
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
            child: _buildVariant(state.viewModel),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEntrySheet(context),
        tooltip: '거래 입력',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEntrySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      builder: (_) => const EntryPage(),
    );
  }

  Widget _buildVariant(HomeViewModel vm) {
    return switch (_selectedIndex) {
      0 => HomeV1(vm: vm),
      1 => HomeV2(vm: vm),
      2 => HomeV3(vm: vm),
      _ => HomeV1(vm: vm),
    };
  }
}

class _VariantToggle extends StatelessWidget {
  const _VariantToggle({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['숫자', '나무', '저울'];
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
