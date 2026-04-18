import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/TypedId.dart';
import '../constants/Enums.dart';
import '../models/CurrencyCode.dart';
import '../errors/DomainErrors.dart';
import 'JournalEntryLine.dart';

part 'Transaction.freezed.dart';

/// 거래 — 하나의 경제적 사건 단위. Aggregate Root.
/// 불변조건 INV-T1~T7을 보호한다.
@freezed
class Transaction with _$Transaction {
  const Transaction._();

  const factory Transaction({
    required TransactionId id,
    required DateTime date,
    required String description,
    required TransactionStatus status,
    TransactionId? voidedBy,
    CounterpartyId? counterpartyId,
    String? counterpartyName,
    required TransactionSource source,
    double? confidence,
    PeriodId? periodId,
    @Default(SyncStatus.localOnly) SyncStatus syncStatus,
    required List<JournalEntryLine> listLines,
    @Default([]) List<TagId> listTagIds,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;

  // ---------------------------------------------------------------------------
  // 팩토리 메서드
  // ---------------------------------------------------------------------------

  /// Draft 생성 — INV-T3, T4만 검증.
  /// 차대변 균형(INV-T2)은 Draft에서는 미검증 (사용자가 아직 수정 중).
  static Transaction createDraft({
    required TransactionId id,
    required DateTime date,
    required String description,
    required List<JournalEntryLine> listLines,
    CounterpartyId? counterpartyId,
    String? counterpartyName,
    TransactionSource source = TransactionSource.manualInput,
    double? confidence,
    List<TagId>? listTagIds,
  }) {
    // INV-T3: 모든 line의 baseCurrency 동일
    _validateBaseCurrencyConsistency(listLines);

    // INV-T4: 모든 line의 originalAmount > 0
    _validatePositiveAmounts(listLines);

    final now = DateTime.now();
    return Transaction(
      id: id,
      date: date,
      description: description,
      status: TransactionStatus.draft,
      source: source,
      confidence: confidence,
      counterpartyId: counterpartyId,
      counterpartyName: counterpartyName,
      listLines: listLines,
      listTagIds: listTagIds ?? [],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Draft → Posted 전환 — INV-T1~T7 전체 검증.
  /// INV-T7: periodId는 required PeriodId이므로 타입 시스템이 null을 방지.
  /// 검증 실패 시 InvariantViolationError throw.
  Transaction post({required PeriodId periodId}) {
    // INV-T5: Draft 상태에서만 전환 가능
    if (status != TransactionStatus.draft) {
      throw InvariantViolationError(
        'INV-T5: Draft 상태에서만 Posted로 전환할 수 있습니다. 현재 상태: $status',
      );
    }

    // INV-T1: 최소 2라인
    if (listLines.length < 2) {
      throw InvariantViolationError(
        'INV-T1: 복식부기는 최소 2개 전표 라인이 필요합니다. 현재: ${listLines.length}개',
      );
    }

    // INV-T3: 모든 line의 baseCurrency 동일
    _validateBaseCurrencyConsistency(listLines);

    // INV-T4: 모든 line의 originalAmount > 0
    _validatePositiveAmounts(listLines);

    // INV-T2: 차대변 균형
    final int sumDebit = listLines
        .where((l) => l.entryType == EntryType.debit)
        .fold(0, (sum, l) => sum + l.baseAmount);
    final int sumCredit = listLines
        .where((l) => l.entryType == EntryType.credit)
        .fold(0, (sum, l) => sum + l.baseAmount);

    if (sumDebit != sumCredit) {
      throw InvariantViolationError(
        'INV-T2: 차변 합계($sumDebit)와 대변 합계($sumCredit)가 일치하지 않습니다.',
      );
    }

    return copyWith(
      status: TransactionStatus.posted,
      periodId: periodId,
      updatedAt: DateTime.now(),
    );
  }

  /// Posted → Voided (역분개).
  /// 원본 데이터는 불변, status만 변경하고 voidedBy를 설정한다.
  /// 실제 역분개 전표 생성은 UseCase 책임.
  Transaction voidTransaction({required TransactionId reversalId}) {
    if (status != TransactionStatus.posted) {
      throw InvariantViolationError(
        'INV-T5: Posted 상태에서만 무효 처리할 수 있습니다. 현재 상태: $status',
      );
    }

    return copyWith(
      status: TransactionStatus.voided,
      voidedBy: reversalId,
      updatedAt: DateTime.now(),
    );
  }

  /// Draft 수정 — INV-T5(Draft만 수정 가능) 검증 후 라인 교체.
  Transaction updateLines(List<JournalEntryLine> listLines) {
    if (status != TransactionStatus.draft) {
      throw InvariantViolationError(
        'INV-T5: Draft 상태에서만 수정할 수 있습니다. 현재 상태: $status',
      );
    }

    // INV-T3, T4 검증
    _validateBaseCurrencyConsistency(listLines);
    _validatePositiveAmounts(listLines);

    return copyWith(
      listLines: listLines,
      updatedAt: DateTime.now(),
    );
  }

  /// 태그 추가
  Transaction addTag(TagId tagId) {
    if (listTagIds.contains(tagId)) return this;
    return copyWith(
      listTagIds: [...listTagIds, tagId],
      updatedAt: DateTime.now(),
    );
  }

  /// 태그 제거
  Transaction removeTag(TagId tagId) {
    if (!listTagIds.contains(tagId)) return this;
    return copyWith(
      listTagIds: listTagIds.where((t) => t != tagId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  // ---------------------------------------------------------------------------
  // 불변조건 검증 헬퍼
  // ---------------------------------------------------------------------------

  /// INV-T3: 모든 line의 baseCurrency가 동일해야 한다.
  static void _validateBaseCurrencyConsistency(
      List<JournalEntryLine> listLines) {
    if (listLines.isEmpty) return;

    final CurrencyCode first = listLines.first.baseCurrency;
    final bool allSame = listLines.every((l) => l.baseCurrency == first);
    if (!allSame) {
      throw InvariantViolationError(
        'INV-T3: 하나의 거래 내 모든 전표 라인의 기준통화는 동일해야 합니다.',
      );
    }
  }

  /// INV-T4: 모든 line의 originalAmount > 0.
  static void _validatePositiveAmounts(List<JournalEntryLine> listLines) {
    for (final line in listLines) {
      if (line.originalAmount <= 0) {
        throw InvariantViolationError(
          'INV-T4: 전표 라인의 거래원화 금액은 양수여야 합니다. line ${line.id}: ${line.originalAmount}',
        );
      }
    }
  }
}
