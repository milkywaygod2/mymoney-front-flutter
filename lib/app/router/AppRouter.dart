import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:get_it/get_it.dart';

import '../../features/account/presentation/AccountBloc.dart';
import '../../features/account/presentation/AccountEvent.dart';
import '../../features/account/presentation/AccountTreePage.dart';
import '../../features/home/presentation/HomeBloc.dart';
import '../../features/home/presentation/HomePage.dart';
import '../../features/journal/data/TransactionDao.dart';
import '../../features/journal/presentation/JournalPage.dart';
import '../../features/report/presentation/DashboardPage.dart';
import '../../features/entry/presentation/EntryPage.dart';
import '../../features/report/presentation/ReportBloc.dart';
import '../../features/report/presentation/SettlementPage.dart';
import '../../features/settings/presentation/SettingsPage.dart';

/// 앱 라우터 — 4탭 셸 네비게이션
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => _ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => BlocProvider(
              create: (ctx) => HomeBloc(
                reportBloc: ctx.read<ReportBloc>(),
                transactionDao: GetIt.instance<TransactionDao>(),
              ),
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/journal',
            builder: (context, state) => const JournalPage(),
          ),
          GoRoute(
            path: '/report',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) {
              context.read<AccountBloc>().add(const AccountEvent.loadTree());
              return const AccountTreePage();
            },
          ),
          GoRoute(
            path: '/more',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/settlement',
            builder: (context, state) => BlocProvider.value(
              value: GetIt.instance<ReportBloc>(),
              child: const SettlementPage(),
            ),
          ),
        ],
      ),
    ],
  );
}

/// 4탭 셸 — 플랫폼별 적응 (모바일: BottomNav, 데스크톱: NavigationRail)
class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.child});

  final Widget child;

  static const _listDestinations = [
    NavigationDestination(icon: Icon(Icons.home), label: '홈'),
    NavigationDestination(icon: Icon(Icons.receipt_long), label: '거래'),
    NavigationDestination(icon: Icon(Icons.analytics), label: '분석'),
    NavigationDestination(icon: Icon(Icons.account_tree), label: '계정'),
    NavigationDestination(icon: Icon(Icons.settings), label: '설정'),
  ];

  static const _listPaths = ['/home', '/journal', '/report', '/account', '/more'];

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _listPaths.indexWhere((p) => location.startsWith(p));
    return index >= 0 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    // 넓은 화면(데스크톱): NavigationRail, 좁은 화면(모바일): BottomNav
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (i) => context.go(_listPaths[i]),
              labelType: NavigationRailLabelType.all,
              destinations: _listDestinations
                  .map((d) => NavigationRailDestination(
                        icon: d.icon,
                        label: Text(d.label, style: const TextStyle(fontSize: 11)),
                      ))
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_listPaths[i]),
        destinations: _listDestinations,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EntryPage.show(context),
        tooltip: '거래 입력',
        child: const Icon(Icons.add),
      ),
    );
  }
}

