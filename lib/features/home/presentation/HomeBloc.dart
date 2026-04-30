import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/journal/data/TransactionDao.dart';
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
    required this.periodLabel,
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
  final String periodLabel;
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
    periodLabel: '',
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
  HomeBloc({required ReportBloc reportBloc, required TransactionDao transactionDao})
      : _reportBloc = reportBloc,
        _transactionDao = transactionDao,
        super(const HomeState()) {
    on<LoadHome>(_onLoad);
    on<RefreshHome>(_onRefresh);
  }

  final ReportBloc _reportBloc;
  final TransactionDao _transactionDao;

  Future<void> _onLoad(LoadHome event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final reportState = _reportBloc.state;
      final spark7d = await _computeSpark7d();
      final vm = _buildViewModel(reportState, spark7d);
      emit(state.copyWith(isLoading: false, viewModel: vm));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefresh(RefreshHome event, Emitter<HomeState> emit) async {
    _reportBloc.add(const LoadDashboard());
    add(const LoadHome());
  }

  /// 최근 7일 일별 순수익(revenue - expense) 합산 리스트
  Future<List<int>> _computeSpark7d() async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day - 6);
    final to = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final listTxns = await _transactionDao.findByDateRange(from, to);

    final Map<String, int> mapDailyNet = {};
    for (final twl in listTxns) {
      final key = '${twl.tx.date.year}-${twl.tx.date.month}-${twl.tx.date.day}';
      final revenue = twl.listLines
          .where((l) => l.entryType == 'CREDIT')
          .fold<int>(0, (s, l) => s + l.baseAmount);
      final expense = twl.listLines
          .where((l) => l.entryType == 'DEBIT')
          .fold<int>(0, (s, l) => s + l.baseAmount);
      mapDailyNet[key] = (mapDailyNet[key] ?? 0) + revenue - expense;
    }

    return List.generate(7, (i) {
      final d = DateTime(now.year, now.month, now.day - (6 - i));
      final key = '${d.year}-${d.month}-${d.day}';
      return mapDailyNet[key] ?? 0;
    });
  }

  HomeViewModel _buildViewModel(ReportState reportState, List<int> spark7d) {
    final dashboard = reportState.dashboard;
    final bs = reportState.balanceSheet;

    if (dashboard == null) return HomeViewModel.empty;

    final int assets = bs?.totalAssets ?? 0;
    final int liabilities = bs?.totalLiabilities ?? 0;
    final int equity = bs?.totalEquity ?? 0;

    final now = DateTime.now();
    final periodLabel = '${now.year}년 ${now.month}월';

    return HomeViewModel(
      netWorth: dashboard.netAssets,
      spark7d: spark7d,
      assets: assets,
      liabilities: liabilities,
      equity: equity,
      revenue: dashboard.totalRevenue,
      expense: dashboard.totalExpense,
      periodLabel: periodLabel,
    );
  }
}
