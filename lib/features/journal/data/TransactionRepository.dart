import 'package:drift/drift.dart';

import '../../../core/constants/Enums.dart';
import '../../../infrastructure/database/AppDatabase.dart' show TransactionsCompanion, JournalEntryLinesCompanion;
import '../../../core/domain/JournalEntryLine.dart';
import '../../../core/domain/Perspective.dart';
import '../../../core/domain/Transaction.dart';
import '../../../core/interfaces/ITransactionRepository.dart';
import '../../../core/models/CurrencyCode.dart';
import '../../../core/models/TypedId.dart';
import 'TransactionDao.dart';

/// ITransactionRepository 구현체 — Drift row ↔ 도메인 엔티티 변환
class TransactionRepository implements ITransactionRepository {
  TransactionRepository(this._dao);
  final TransactionDao _dao;

  @override
  Future<Transaction?> findById(TransactionId id) async {
    final result = await _dao.findById(id.value);
    if (result == null) return null;
    return _toDomain(result);
  }

  @override
  Future<List<Transaction>> findByPeriod(
    PeriodId periodId, {
    TransactionStatus? status,
  }) async {
    final listResults = await _dao.findByPeriod(
      periodId.value,
      status: status?.name.toUpperCase(),
    );
    return listResults.map(_toDomain).toList();
  }

  @override
  Future<List<Transaction>> findByDateRange(DateTime from, DateTime to) async {
    final listResults = await _dao.findByDateRange(from, to);
    return listResults.map(_toDomain).toList();
  }

  @override
  Future<void> save(Transaction transaction) async {
    final txCompanion = TransactionsCompanion(
      id: transaction.id.value == 0
          ? const Value.absent()
          : Value(transaction.id.value),
      date: Value(transaction.date),
      description: Value(transaction.description),
      status: Value(transaction.status.name.toUpperCase()),
      voidedBy: Value(transaction.voidedBy?.value),
      counterpartyId: Value(transaction.counterpartyId?.value),
      counterpartyName: Value(transaction.counterpartyName),
      source: Value(transaction.source.name),
      confidence: Value(transaction.confidence),
      periodId: Value(transaction.periodId?.value),
      syncStatus: Value(transaction.syncStatus.name.toUpperCase()),
      createdAt: Value(transaction.createdAt),
      updatedAt: Value(transaction.updatedAt),
      referenceNo: Value(transaction.referenceNo),
      reversalType: Value(transaction.reversalType?.name),
    );

    final listLineCompanions = transaction.listLines.map((jel) {
      return JournalEntryLinesCompanion(
        id: jel.id.value == 0
            ? const Value.absent()
            : Value(jel.id.value),
        accountId: Value(jel.accountId.value),
        entryType: Value(jel.entryType.name.toUpperCase()),
        originalAmount: Value(jel.originalAmount),
        originalCurrency: Value(jel.originalCurrency.name),
        exchangeRateAtTrade: Value(jel.exchangeRateAtTrade),
        baseCurrency: Value(jel.baseCurrency.name),
        baseAmount: Value(jel.baseAmount),
        activityTypeOverride: Value(jel.activityTypeOverride?.value),
        ownerIdOverride: Value(jel.ownerIdOverride?.value),
        incomeTypeOverride: Value(jel.incomeTypeOverride?.value),
        deductibility: Value(jel.deductibility.name),
        beneficiaryId: Value(jel.beneficiaryId?.value),
        taxClassification: Value(jel.taxClassification),
        memo: Value(jel.memo),
      );
    }).toList();

    if (transaction.id.value == 0) {
      // 신규 거래: insert
      await _dao.insertTransactionWithLines(txCompanion, listLineCompanions);
    } else {
      // 기존 거래: update + JEL 전체 삭제 후 재삽입
      await _dao.updateTransactionWithLines(
          transaction.id.value, txCompanion, listLineCompanions);
    }
  }

  @override
  Future<void> delete(TransactionId id) async {
    await _dao.deleteTransaction(id.value);
  }

  @override
  Future<List<Transaction>> findByPerspective(
    Perspective perspective, {
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  }) async {
    final listResults = await _dao.findByPerspective(
      perspective,
      from: from,
      to: to,
      limit: limit,
    );
    return listResults.map(_toDomain).toList();
  }

  @override
  Future<Map<AccountId, int>> calculateBalances({
    required PeriodId periodId,
    Perspective? perspective,
  }) async {
    final mapRaw = await _dao.calculateBalancesByAccount(
      periodId: periodId.value,
    );
    // int key → AccountId 변환
    return mapRaw.map((k, v) => MapEntry(AccountId(k), v));
  }

  /// Drift TransactionWithLines → 도메인 Transaction 변환
  Transaction _toDomain(TransactionWithLines result) {
    final tx = result.tx;
    final listLines = result.listLines.map((jel) {
      return JournalEntryLine(
        id: JournalEntryLineId(jel.id),
        accountId: AccountId(jel.accountId),
        entryType: EntryType.values.byName(jel.entryType.toLowerCase()),
        originalAmount: jel.originalAmount,
        originalCurrency: CurrencyCode.values.byName(jel.originalCurrency),
        exchangeRateAtTrade: jel.exchangeRateAtTrade,
        baseCurrency: CurrencyCode.values.byName(jel.baseCurrency),
        baseAmount: jel.baseAmount,
        activityTypeOverride: jel.activityTypeOverride != null
            ? DimensionValueId(jel.activityTypeOverride!)
            : null,
        ownerIdOverride: jel.ownerIdOverride != null
            ? OwnerId(jel.ownerIdOverride!)
            : null,
        incomeTypeOverride: jel.incomeTypeOverride != null
            ? DimensionValueId(jel.incomeTypeOverride!)
            : null,
        deductibility: Deductibility.values.byName(jel.deductibility),
        beneficiaryId: jel.beneficiaryId != null
            ? OwnerId(jel.beneficiaryId!)
            : null,
        taxClassification: jel.taxClassification,
        memo: jel.memo,
      );
    }).toList();

    return Transaction(
      id: TransactionId(tx.id),
      date: tx.date,
      description: tx.description,
      status: TransactionStatus.values.byName(tx.status.toLowerCase()),
      voidedBy: tx.voidedBy != null ? TransactionId(tx.voidedBy!) : null,
      counterpartyId: tx.counterpartyId != null
          ? CounterpartyId(tx.counterpartyId!)
          : null,
      counterpartyName: tx.counterpartyName,
      source: TransactionSource.values.byName(tx.source),
      confidence: tx.confidence,
      periodId: tx.periodId != null ? PeriodId(tx.periodId!) : null,
      syncStatus: SyncStatus.values.byName(tx.syncStatus.toLowerCase()),
      listLines: listLines,
      listTagIds: result.listTagIds.map((id) => TagId(id)).toList(),
      createdAt: tx.createdAt,
      updatedAt: tx.updatedAt,
      referenceNo: tx.referenceNo,
      reversalType: tx.reversalType != null
          ? ReversalType.values.byName(tx.reversalType!)
          : null,
    );
  }

  /// 외부 참조번호(카드승인번호 등)로 거래 조회 (v2.0)
  Future<Transaction?> findByReferenceNo(String referenceNo) async {
    final result = await _dao.findByReferenceNo(referenceNo);
    if (result == null) return null;
    return _toDomain(result);
  }
}
