import '../../../core/constants/Enums.dart';
import '../../../core/domain/JournalEntryLine.dart';
import '../../../core/domain/Transaction.dart';
import '../../../core/errors/DomainErrors.dart';
import '../../../core/interfaces/ITransactionRepository.dart';
import '../../../core/models/TypedId.dart';

/// 거래 무효화(역분개) UseCase
class VoidTransaction {
  VoidTransaction(this._repository);
  final ITransactionRepository _repository;

  Future<Transaction> execute({required TransactionId id}) async {
    final original = await _repository.findById(id);
    if (original == null) {
      throw InvariantViolationError('거래를 찾을 수 없습니다: id=$id');
    }
    if (original.status != TransactionStatus.posted) {
      throw InvariantViolationError(
        'Posted 상태의 거래만 무효화 가능 (현재: ${original.status.name})',
      );
    }
    final listReversalLines = original.listLines.map((line) {
      final reversedType = line.entryType == EntryType.debit
          ? EntryType.credit : EntryType.debit;
      return JournalEntryLine(
        id: const JournalEntryLineId(0), accountId: line.accountId,
        entryType: reversedType, originalAmount: line.originalAmount,
        originalCurrency: line.originalCurrency,
        exchangeRateAtTrade: line.exchangeRateAtTrade,
        baseCurrency: line.baseCurrency, baseAmount: line.baseAmount,
        activityTypeOverride: line.activityTypeOverride,
        ownerIdOverride: line.ownerIdOverride,
        incomeTypeOverride: line.incomeTypeOverride,
        deductibility: Deductibility.bookRespected,
        beneficiaryId: line.beneficiaryId,
        taxClassification: line.taxClassification, memo: line.memo,
      );
    }).toList();

    final reversalDraft = Transaction.createDraft(
      id: const TransactionId(0), date: DateTime.now(),
      description: '[역분개] ${original.description}',
      listLines: listReversalLines, source: TransactionSource.systemSettlement,
    );
    final reversalPosted = reversalDraft.post(periodId: original.periodId!);
    await _repository.save(reversalPosted);
    final voided = original.voidTransaction(reversalId: reversalPosted.id);
    await _repository.save(voided);
    return voided;
  }
}
