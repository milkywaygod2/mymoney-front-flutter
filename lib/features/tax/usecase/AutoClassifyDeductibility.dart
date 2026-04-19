import '../../../core/constants/Enums.dart';
import '../../../core/domain/Account.dart';
import '../../../core/interfaces/IAccountRepository.dart';
import '../../../core/interfaces/ILegalParameterRepository.dart';
import '../../../core/interfaces/ITransactionRepository.dart';
import '../../../core/models/TypedId.dart';
import '../data/TaxRuleEngine.dart';

/// 세무조정 자동 분류 결과 항목
class DeductibilityClassificationResult {
  const DeductibilityClassificationResult({
    required this.transactionId,
    required this.lineId,
    required this.accountId,
    required this.accountName,
    required this.originalDeductibility,
    required this.suggestedDeductibility,
    this.reason,
    this.limitAmount,
  });

  final TransactionId transactionId;
  final JournalEntryLineId lineId;
  final AccountId accountId;
  final String accountName;
  final Deductibility originalDeductibility;
  final Deductibility suggestedDeductibility;
  final String? reason;

  /// 한도 초과 금액 (손금산입(한도) 계정에만 설정)
  final int? limitAmount;
}

/// 자동 deductibility 분류 UseCase.
///
/// 처리 순서:
///   1. TaxRuleEngine으로 계정과목 기반 1차 판정
///   2. 손금산입(한도) 계정: LegalParameter로 한도 금액 조회 후 초과분 불산입
///   3. 결과 목록 반환 — 실제 저장은 BLoC(ConfirmSettlement)에서 수행
class AutoClassifyDeductibility {
  AutoClassifyDeductibility({
    required ITransactionRepository transactionRepository,
    required IAccountRepository accountRepository,
    required ILegalParameterRepository legalParameterRepository,
    required TaxRuleEngine ruleEngine,
  })  : _transactionRepository = transactionRepository,
        _accountRepository = accountRepository,
        _legalParameterRepository = legalParameterRepository,
        _ruleEngine = ruleEngine;

  final ITransactionRepository _transactionRepository;
  final IAccountRepository _accountRepository;
  final ILegalParameterRepository _legalParameterRepository;
  final TaxRuleEngine _ruleEngine;

  /// 지정 거래 목록에 대해 자동 판정 실행.
  ///
  /// [listTransactionIds]: 판정할 거래 ID 목록 (빈 목록이면 전체 Posted 조회)
  /// [asOfDate]: 기준일 — LegalParameter 조회에 사용
  Future<List<DeductibilityClassificationResult>> execute({
    required List<TransactionId> listTransactionIds,
    required DateTime asOfDate,
  }) async {
    final List<DeductibilityClassificationResult> listResults = [];

    for (final txId in listTransactionIds) {
      final tx = await _transactionRepository.findById(txId);
      if (tx == null) continue;
      // Posted 거래에만 판정
      if (tx.status != TransactionStatus.posted) continue;

      for (final line in tx.listLines) {
        // 차변 라인(Expense 방향)만 판정
        if (line.entryType != EntryType.debit) continue;

        final account = await _accountRepository.findById(line.accountId);
        if (account == null) continue;
        if (account.nature != AccountNature.expense) continue;

        final rule = _ruleEngine.classify(account);

        int? limitAmount;
        Deductibility finalDeductibility = rule.deductibility;

        // 손금산입(한도): LegalParameter로 한도 조회 후 초과분 판정
        if (rule.deductibility == Deductibility.deductibleLimited) {
          limitAmount = await _fetchLimitAmount(
            account: account,
            asOfDate: asOfDate,
            lineAmount: line.baseAmount,
          );
        }

        listResults.add(
          DeductibilityClassificationResult(
            transactionId: txId,
            lineId: line.id,
            accountId: account.id,
            accountName: account.name,
            originalDeductibility: line.deductibility,
            suggestedDeductibility: finalDeductibility,
            reason: rule.reason,
            limitAmount: limitAmount,
          ),
        );
      }
    }

    return listResults;
  }

  // ---------------------------------------------------------------------------
  // 내부 헬퍼
  // ---------------------------------------------------------------------------

  /// 계정과목별 LegalParameter 한도 금액 조회.
  ///
  /// VALUE 타입: 단순 비교값 반환
  /// TABLE 타입: 구간 매칭 (TODO — 누진세율 등 복잡한 케이스)
  /// FORMULA 타입: 수식 평가 (TODO stub)
  Future<int?> _fetchLimitAmount({
    required Account account,
    required DateTime asOfDate,
    required int lineAmount,
  }) async {
    final strName = account.name.toLowerCase();

    // 계정 이름으로 LegalParameter key 결정
    String? strParamKey;
    if (strName.contains('접대')) strParamKey = '접대비_한도';
    if (strName.contains('기부')) strParamKey = '기부금_한도';
    if (strName.contains('감가')) strParamKey = '감가상각_한도';
    if (strParamKey == null) return null;

    final dynamic param = await _legalParameterRepository.findEffective(
      strParamKey,
      asOfDate,
    );
    if (param == null) return null;

    // VALUE 타입 처리 — param.value가 한도 금액
    final dynamic rawValue = _extractValue(param);
    if (rawValue == null) return null;

    final int limitValue = rawValue is int
        ? rawValue
        : int.tryParse(rawValue.toString()) ?? 0;

    // 한도 초과분 반환 (0 이하면 한도 내)
    final int overAmount = lineAmount - limitValue;
    return overAmount > 0 ? overAmount : null;
  }

  /// LegalParameter 동적 타입에서 value 추출 (향후 도메인 클래스 확정 후 교체)
  dynamic _extractValue(dynamic param) {
    try {
      // param이 Map이면 'value' 키 접근
      if (param is Map) return param['value'];
      // param에 value 필드가 있으면 리플렉션으로 접근
      return (param as dynamic).value;
    } catch (_) {
      return null;
    }
  }
}
