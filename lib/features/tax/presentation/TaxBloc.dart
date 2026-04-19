import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import '../usecase/AutoClassifyDeductibility.dart';
import 'TaxEvent.dart';
import 'TaxState.dart';

/// 세무조정 BLoC.
///
/// BLoC 간 통신:
///   JournalBloc.TransactionPosted → TaxBloc.RunAutoClassification (TODO: Stream 연결)
///   TaxBloc.DeductibilityUpdated → ReportBloc (세무 보고서 갱신, TODO)
class TaxBloc extends Bloc<TaxEvent, TaxState> {
  TaxBloc({
    required AutoClassifyDeductibility autoClassifyDeductibility,
  })  : _autoClassifyDeductibility = autoClassifyDeductibility,
        super(const TaxState()) {
    on<RunAutoClassification>(_onRunAutoClassification);
    on<LoadPendingItems>(_onLoadPendingItems);
    on<OverrideDeductibility>(_onOverrideDeductibility);
    on<ConfirmSettlement>(_onConfirmSettlement);
  }

  final AutoClassifyDeductibility _autoClassifyDeductibility;

  // ---------------------------------------------------------------------------
  // 이벤트 핸들러
  // ---------------------------------------------------------------------------

  /// 자동 분류 실행 — UseCase 호출 후 결과를 상태에 저장
  Future<void> _onRunAutoClassification(
    RunAutoClassification event,
    Emitter<TaxState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final listResults = await _autoClassifyDeductibility.execute(
        listTransactionIds: event.listTransactionIds,
        asOfDate: event.asOfDate,
      );

      // 미판정 항목 분리 — suggestedDeductibility가 undetermined인 것
      final listPending = listResults
          .where(
            (r) => r.suggestedDeductibility == Deductibility.undetermined,
          )
          .toList();

      emit(state.copyWith(
        listAutoResults: listResults,
        listPendingItems: listPending,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// 미판정 항목 로드 — 현재 상태에서 undetermined 항목 필터링
  Future<void> _onLoadPendingItems(
    LoadPendingItems event,
    Emitter<TaxState> emit,
  ) async {
    final listPending = state.listAutoResults
        .where(
          (r) => r.suggestedDeductibility == Deductibility.undetermined,
        )
        .toList();
    emit(state.copyWith(listPendingItems: listPending));
  }

  /// 수동 재정의 — 특정 라인의 deductibility를 사용자가 직접 설정
  Future<void> _onOverrideDeductibility(
    OverrideDeductibility event,
    Emitter<TaxState> emit,
  ) async {
    // 해당 라인을 listAutoResults에서 찾아 suggestedDeductibility 교체
    final listUpdated = state.listAutoResults.map((item) {
      if (item.transactionId == event.transactionId &&
          item.lineId == event.lineId) {
        return DeductibilityClassificationResult(
          transactionId: item.transactionId,
          lineId: item.lineId,
          accountId: item.accountId,
          accountName: item.accountName,
          originalDeductibility: item.originalDeductibility,
          suggestedDeductibility: event.deductibility,
          reason: event.memo ?? '사용자 수동 재정의',
          limitAmount: item.limitAmount,
        );
      }
      return item;
    }).toList();

    // 미판정 항목 재산출
    final listPending = listUpdated
        .where(
          (r) => r.suggestedDeductibility == Deductibility.undetermined,
        )
        .toList();

    emit(state.copyWith(
      listAutoResults: listUpdated,
      listPendingItems: listPending,
    ));
  }

  /// 세무조정 확정 — 미판정 0건 검증 후 거래 저장
  ///
  /// 미판정 잔존 시 에러 메시지 반환 — 확정 거부
  Future<void> _onConfirmSettlement(
    ConfirmSettlement event,
    Emitter<TaxState> emit,
  ) async {
    // 미판정 항목 잔존 → 확정 불가
    if (state.listPendingItems.isNotEmpty) {
      emit(state.copyWith(
        errorMessage:
            '세무조정 확정 불가: 미판정 항목 ${state.listPendingItems.length}건이 남아있습니다. '
            '수동으로 처리 후 다시 확정하십시오.',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      // 확정된 deductibility를 각 거래 라인에 실제 저장
      // TODO: JournalEntryLine.deductibility 업데이트 UseCase 추가 시 연동
      // 현재는 상태만 confirmed로 전환
      emit(state.copyWith(
        isSettlementConfirmed: true,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
