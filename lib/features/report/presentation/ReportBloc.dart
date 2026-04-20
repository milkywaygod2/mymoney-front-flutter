import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/Perspective.dart';
import '../../../core/models/FinancialRatio.dart';
import '../data/ReportQueryService.dart';
import '../usecase/CalculateFinancialRatios.dart';
import '../usecase/GenerateBalanceSheet.dart';
import '../usecase/GenerateComprehensiveIncome.dart';
import '../usecase/GenerateIncomeStatement.dart';
import '../usecase/RunSettlement.dart';

// ─────────────────────────────────────────────────────────────────
// 이벤트
// ─────────────────────────────────────────────────────────────────

sealed class ReportEvent {
  const ReportEvent();
}

/// 대시보드 데이터 로드 (순자산, 수입/지출 요약)
class LoadDashboard extends ReportEvent {
  const LoadDashboard({this.perspective});
  final Perspective? perspective;
}

/// B/S 보고서 로드
class LoadBalanceSheet extends ReportEvent {
  const LoadBalanceSheet({
    required this.snapshotDate,
    this.perspective,
  });
  final DateTime snapshotDate;
  final Perspective? perspective;
}

/// P/L 보고서 로드
class LoadIncomeStatement extends ReportEvent {
  const LoadIncomeStatement({
    required this.periodId,
    this.perspective,
  });
  final int periodId;
  final Perspective? perspective;
}

/// 보고서 기간 변경 (Lens Switcher 연동)
class ChangeReportPeriod extends ReportEvent {
  const ChangeReportPeriod({required this.periodId});
  final int periodId;
}

/// 결산 5단계 실행
class RunSettlementEvent extends ReportEvent {
  const RunSettlementEvent({
    required this.periodId,
    required this.snapshotDate,
    required this.retainedEarningsAccountId,
  });
  final int periodId;
  final DateTime snapshotDate;
  final int retainedEarningsAccountId;
}

/// 재무비율 로드 (v2.0 §7.4)
class LoadFinancialRatios extends ReportEvent {
  const LoadFinancialRatios({
    required this.periodId,
    required this.asOfDate,
  });
  final int periodId;
  final DateTime asOfDate;
}

/// 총포괄이익 로드 (v2.0 §12.1a)
class LoadComprehensiveIncome extends ReportEvent {
  const LoadComprehensiveIncome({required this.periodId});
  final int periodId;
}

// ─────────────────────────────────────────────────────────────────
// 상태
// ─────────────────────────────────────────────────────────────────

/// 대시보드 요약 데이터
class DashboardSummary {
  const DashboardSummary({
    required this.netAssets,
    required this.totalRevenue,
    required this.totalExpense,
    required this.netIncome,
    required this.snapshotDate,
    this.pendingDraftCount = 0,
  });

  /// 순자산 (자산 - 부채)
  final int netAssets;
  final int totalRevenue;
  final int totalExpense;

  /// 당기순이익
  final int netIncome;
  final DateTime snapshotDate;

  /// 미확인 Draft 건수 — 대시보드 알림 배너용
  final int pendingDraftCount;
}

class ReportState {
  const ReportState({
    this.isLoading = false,
    this.dashboard,
    this.balanceSheet,
    this.incomeStatement,
    this.activePeriodId,
    this.settlementResult,
    this.settlementStep,
    this.errorMessage,
    this.listRatios,
    this.comprehensiveIncome,
  });

  final bool isLoading;
  final DashboardSummary? dashboard;
  final BalanceSheet? balanceSheet;
  final IncomeStatement? incomeStatement;
  final int? activePeriodId;
  final SettlementResult? settlementResult;

  /// 결산 진행 중 현재 단계
  final SettlementStep? settlementStep;
  final String? errorMessage;

  /// v2.0: 재무비율 목록
  final List<FinancialRatio>? listRatios;
  /// v2.0: 총포괄이익 결과
  final ComprehensiveIncomeResult? comprehensiveIncome;

  ReportState copyWith({
    bool? isLoading,
    DashboardSummary? dashboard,
    BalanceSheet? balanceSheet,
    IncomeStatement? incomeStatement,
    int? activePeriodId,
    SettlementResult? settlementResult,
    SettlementStep? settlementStep,
    String? errorMessage,
    List<FinancialRatio>? listRatios,
    ComprehensiveIncomeResult? comprehensiveIncome,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      dashboard: dashboard ?? this.dashboard,
      balanceSheet: balanceSheet ?? this.balanceSheet,
      incomeStatement: incomeStatement ?? this.incomeStatement,
      activePeriodId: activePeriodId ?? this.activePeriodId,
      settlementResult: settlementResult ?? this.settlementResult,
      settlementStep: settlementStep ?? this.settlementStep,
      errorMessage: errorMessage,
      listRatios: listRatios ?? this.listRatios,
      comprehensiveIncome: comprehensiveIncome ?? this.comprehensiveIncome,
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// BLoC
// ─────────────────────────────────────────────────────────────────

/// ReportBloc — 보고서 및 결산 관리
///
/// [BLoC 간 통신 — CW_ARCHITECTURE.md 섹션 9.2]
/// - PerspectiveBloc.Stream<Perspective> → ReportBloc 리필터링
/// - TaxBloc.DeductibilityUpdated → ReportBloc (세무 보고서 갱신) [TODO: S08a 연동]
/// - JournalBloc.TransactionUpdated → ReportBloc [TODO: Stream 연결]
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc({
    required GenerateBalanceSheet generateBalanceSheet,
    required GenerateIncomeStatement generateIncomeStatement,
    required RunSettlement runSettlement,
    required ReportQueryService queryService,
    required CalculateFinancialRatios calculateFinancialRatios,
    required GenerateComprehensiveIncome generateComprehensiveIncome,
  })  : _generateBalanceSheet = generateBalanceSheet,
        _generateIncomeStatement = generateIncomeStatement,
        _runSettlement = runSettlement,
        _queryService = queryService,
        _calculateFinancialRatios = calculateFinancialRatios,
        _generateComprehensiveIncome = generateComprehensiveIncome,
        super(const ReportState()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<LoadBalanceSheet>(_onLoadBalanceSheet);
    on<LoadIncomeStatement>(_onLoadIncomeStatement);
    on<ChangeReportPeriod>(_onChangePeriod);
    on<RunSettlementEvent>(_onRunSettlement);
    on<LoadFinancialRatios>(_onLoadFinancialRatios);
    on<LoadComprehensiveIncome>(_onLoadComprehensiveIncome);
  }

  final GenerateBalanceSheet _generateBalanceSheet;
  final GenerateIncomeStatement _generateIncomeStatement;
  final RunSettlement _runSettlement;
  final ReportQueryService _queryService;
  final CalculateFinancialRatios _calculateFinancialRatios;
  final GenerateComprehensiveIncome _generateComprehensiveIncome;

  // ─────────────────────────────────────────────────────────────
  // 대시보드 로드 — B/S + P/L 요약 합산
  // ─────────────────────────────────────────────────────────────
  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final now = DateTime.now();

      // B/S로 순자산 계산
      final bs = await _generateBalanceSheet.execute(
        snapshotDate: now,
        perspective: event.perspective,
      );

      // P/L + 미확인 Draft 건수는 activePeriodId가 있어야 조회 가능
      int totalRevenue = 0;
      int totalExpense = 0;
      int netIncome = 0;
      int pendingDraftCount = 0;
      if (state.activePeriodId != null) {
        final pl = await _generateIncomeStatement.execute(
          periodId: state.activePeriodId!,
          perspective: event.perspective,
        );
        totalRevenue = pl.totalRevenue;
        totalExpense = pl.totalExpense;
        netIncome = pl.netIncome;
        // 미확인 Draft 건수 조회 — 대시보드 알림 배너용
        pendingDraftCount = await _queryService.countRemainingDrafts(state.activePeriodId!);
      }

      emit(state.copyWith(
        isLoading: false,
        dashboard: DashboardSummary(
          netAssets: bs.netAssets,
          totalRevenue: totalRevenue,
          totalExpense: totalExpense,
          netIncome: netIncome,
          snapshotDate: now,
          pendingDraftCount: pendingDraftCount,
        ),
        balanceSheet: bs,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // B/S 로드
  // ─────────────────────────────────────────────────────────────
  Future<void> _onLoadBalanceSheet(
    LoadBalanceSheet event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final bs = await _generateBalanceSheet.execute(
        snapshotDate: event.snapshotDate,
        perspective: event.perspective,
      );
      emit(state.copyWith(isLoading: false, balanceSheet: bs));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // P/L 로드
  // ─────────────────────────────────────────────────────────────
  Future<void> _onLoadIncomeStatement(
    LoadIncomeStatement event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final pl = await _generateIncomeStatement.execute(
        periodId: event.periodId,
        perspective: event.perspective,
      );
      emit(state.copyWith(
        isLoading: false,
        incomeStatement: pl,
        activePeriodId: event.periodId,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 기간 변경 — 활성 기간 갱신 후 P/L 재로드
  // ─────────────────────────────────────────────────────────────
  Future<void> _onChangePeriod(
    ChangeReportPeriod event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(activePeriodId: event.periodId));
    // 기간 변경 시 P/L 자동 갱신
    add(LoadIncomeStatement(periodId: event.periodId));
  }

  // ─────────────────────────────────────────────────────────────
  // 결산 5단계 실행 — 단계별 진행 상황 emit
  // ─────────────────────────────────────────────────────────────
  Future<void> _onRunSettlement(
    RunSettlementEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, settlementStep: SettlementStep.preparingClose));
    try {
      final result = await _runSettlement.execute(
        periodId: event.periodId,
        snapshotDate: event.snapshotDate,
        retainedEarningsAccountId: event.retainedEarningsAccountId,
        onProgress: (step) {
          // 단계별 진행 상황 동기 emit은 제한이 있으므로 add()로 우회 불가
          // UI는 settlementStep 상태로 프로그레스 바 표시
        },
      );
      emit(state.copyWith(
        isLoading: false,
        settlementResult: result,
        settlementStep: result.isCompleted
            ? SettlementStep.completed
            : null,
        errorMessage: result.hasError
            ? result.listStepResults
                .where((r) => !r.isSuccess)
                .map((r) => r.message)
                .join('\n')
            : null,
      ));

      // 결산 완료 후 대시보드 자동 갱신
      if (result.isCompleted) {
        add(const LoadDashboard());
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // v2.0: 재무비율 로드
  // ─────────────────────────────────────────────────────────────
  Future<void> _onLoadFinancialRatios(
    LoadFinancialRatios event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final listRatios = await _calculateFinancialRatios.execute(
        periodId: event.periodId,
        asOfDate: event.asOfDate,
      );
      emit(state.copyWith(isLoading: false, listRatios: listRatios));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // v2.0: 총포괄이익 로드
  // ─────────────────────────────────────────────────────────────
  Future<void> _onLoadComprehensiveIncome(
    LoadComprehensiveIncome event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _generateComprehensiveIncome.execute(
        periodId: event.periodId,
      );
      emit(state.copyWith(isLoading: false, comprehensiveIncome: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
