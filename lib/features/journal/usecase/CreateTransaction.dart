import '../../../core/constants/Enums.dart';
import '../../../core/domain/JournalEntryLine.dart';
import '../../../core/domain/Transaction.dart';
import '../../../core/interfaces/ITransactionRepository.dart';
import '../../../core/models/CurrencyCode.dart';
import '../../../core/models/TypedId.dart';

/// Draft 거래 생성 입력 VO
class JournalEntryLineInput {
  const JournalEntryLineInput({
    required this.accountId,
    required this.entryType,
    required this.originalAmount,
    required this.originalCurrency,
    required this.exchangeRateAtTrade,
    required this.baseCurrency,
    required this.baseAmount,
    this.activityTypeOverride,
    this.ownerIdOverride,
    this.incomeTypeOverride,
    this.memo,
  });

  final AccountId accountId;
  final EntryType entryType;
  final int originalAmount;
  final CurrencyCode originalCurrency;
  final int exchangeRateAtTrade;
  final CurrencyCode baseCurrency;
  final int baseAmount;
  final DimensionValueId? activityTypeOverride;
  final OwnerId? ownerIdOverride;
  final DimensionValueId? incomeTypeOverride;
  final String? memo;
}

/// Draft 거래 생성 UseCase
class CreateTransaction {
  CreateTransaction(this._repository);
  final ITransactionRepository _repository;

  /// Draft 생성 → 저장 → 반환
  /// INV-T3(통화 동일), INV-T4(양수 금액)는 Transaction.createDraft에서 자동 검증
  Future<Transaction> execute({
    required DateTime date,
    required String description,
    required List<JournalEntryLineInput> listLineInputs,
    CounterpartyId? counterpartyId,
    String? counterpartyName,
    TransactionSource source = TransactionSource.manual,
    double? confidence,
  }) async {
    // 입력 VO → JEL 도메인 변환
    final listLines = listLineInputs.map((input) {
      return JournalEntryLine(
        id: const JournalEntryLineId(0), // DB에서 자동 생성
        accountId: input.accountId,
        entryType: input.entryType,
        originalAmount: input.originalAmount,
        originalCurrency: input.originalCurrency,
        exchangeRateAtTrade: input.exchangeRateAtTrade,
        baseCurrency: input.baseCurrency,
        baseAmount: input.baseAmount,
        activityTypeOverride: input.activityTypeOverride,
        ownerIdOverride: input.ownerIdOverride,
        incomeTypeOverride: input.incomeTypeOverride,
        deductibility: Deductibility.undetermined,
        memo: input.memo,
      );
    }).toList();

    // Draft 생성 (INV-T3, T4 검증)
    // id=0 → DB에서 autoIncrement로 실제 ID 할당
    final draft = Transaction.createDraft(
      id: const TransactionId(0),
      date: date,
      description: description,
      listLines: listLines,
      counterpartyId: counterpartyId,
      counterpartyName: counterpartyName,
      source: source,
      confidence: confidence,
    );

    await _repository.save(draft);
    return draft;
  }
}
