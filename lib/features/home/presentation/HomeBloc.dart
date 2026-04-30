import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/report/presentation/ReportBloc.dart';

// ─────────────────────────────────────────────────────────────────
// ViewModel
// ─────────────────────────────────────────────────────────────────

class PendingItem {
  const PendingItem({required this.accountName, required this.amount});
  final String accountName;
  final int amount;
}

class HomeViewModel {
  const HomeViewModel({
    required this.netWorth,
    required this.spark7d,
    required this.assets,
    required this.liabilities,
    required this.equity,
    required this.revenue,
    required this.expense,
    this.listPendingExpenses = const [],
    this.listPendingAssets = const [],
    this.listPendingRevenues = const [],
  });

  final int netWorth;
  final List<int> spark7d;
  final int assets;
  final int liabilities;
  final int equity;
  final int revenue;
  final int expense;
  final List<PendingItem> listPendingExpenses;
  final List<PendingItem> listPendingAssets;
  final List<PendingItem> listPendingRevenues;

  static const empty = HomeViewModel(
    netWorth: 0,
    spark7d: [0, 0, 0, 0, 0, 0, 0],
    assets: 0,
    liabilities: 0,
    equity: 0,
    revenue: 0,
    expense: 0,
  );
}

// ─────────────────────────────────────────────────────────────────
// 이벤트
// ─────────────────────────────────────────────────────────────────

sealed class HomeEvent {
  const HomeEvent();
}

class LoadHome extends HomeEvent {
  const LoadHome();
}

class RefreshHome extends HomeEvent {
  const RefreshHome();
}

// ─────────────────────────────────────────────────────────────────
// 상태
// ─────────────────────────────────────────────────────────────────

class HomeState {
  const HomeState({
    this.isLoading = false,
    this.viewModel = HomeViewModel.empty,
    this.errorMessage,
  });

  final bool isLoading;
  final HomeViewModel viewModel;
  final String? errorMessage;

  HomeState copyWith({
    bool? isLoading,
    HomeViewModel? viewModel,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      viewModel: viewModel ?? this.viewModel,
      errorMessage: errorMessage,
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// BLoC — ReportBloc 합성
// ─────────────────────────────────────────────────────────────────

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required ReportBloc reportBloc})
      : _reportBloc = reportBloc,
        super(const HomeState()) {
    on<LoadHome>(_onLoad);
    on<RefreshHome>(_onRefresh);
  }

  final ReportBloc _reportBloc;

  Future<void> _onLoad(LoadHome event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      // ReportBloc의 현재 대시보드 상태를 읽어 ViewModel 구성
      final reportState = _reportBloc.state;
      final vm = _buildViewModel(reportState);
      emit(state.copyWith(isLoading: false, viewModel: vm));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefresh(RefreshHome event, Emitter<HomeState> emit) async {
    // ReportBloc에 대시보드 재로드 트리거
    _reportBloc.add(const LoadDashboard());
    add(const LoadHome());
  }

  HomeViewModel _buildViewModel(ReportState reportState) {
    final dashboard = reportState.dashboard;
    final bs = reportState.balanceSheet;

    if (dashboard == null) return HomeViewModel.empty;

    final int assets = bs?.totalAssets ?? 0;
    final int liabilities = bs?.totalLiabilities ?? 0;
    final int equity = bs?.totalEquity ?? 0;

    return HomeViewModel(
      netWorth: dashboard.netAssets,
      // 7일 추이는 현재 단순화 — TODO: 일별 스냅샷 쿼리 연동
      spark7d: List.generate(7, (i) => (dashboard.netAssets * (0.94 + i * 0.01)).round()),
      assets: assets,
      liabilities: liabilities,
      equity: equity,
      revenue: dashboard.totalRevenue,
      expense: dashboard.totalExpense,
    );
  }
}
