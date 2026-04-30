import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/Perspective.dart';
import '../../../core/models/TypedId.dart';
import '../usecase/CreateTransaction.dart';

part 'JournalEvent.freezed.dart';

/// 거래 관리 이벤트
@freezed
abstract class JournalEvent with _$JournalEvent {
  /// 거래 목록 로드
  const factory JournalEvent.loadTransactions({
    int? limit,
    Perspective? perspective,
  }) = LoadTransactions;

  /// 거래 선택 (상세 보기)
  const factory JournalEvent.selectTransaction({
    required TransactionId id,
  }) = SelectTransaction;

  /// Draft 거래 생성
  const factory JournalEvent.createTransaction({
    required DateTime date,
    required String description,
    required List<JournalEntryLineInput> listLineInputs,
    CounterpartyId? counterpartyId,
    String? counterpartyName,
  }) = CreateTransactionEvent;

  /// Draft → Posted 전환
  const factory JournalEvent.postTransaction({
    required TransactionId id,
    required PeriodId periodId,
  }) = PostTransactionEvent;

  /// Draft 거래 삭제
  const factory JournalEvent.deleteTransaction({
    required TransactionId id,
  }) = DeleteTransactionEvent;
}
