import '../../../core/constants/Enums.dart';
import '../../../core/domain/Account.dart';
import '../../../core/interfaces/ILegalParameterRepository.dart';

/// 소득유형 분류 결과
class IncomeTypeResult {
  const IncomeTypeResult({
    required this.incomeType,
    required this.taxationType,
    this.annualTotal,
  });

  /// 소득 8종 유형 코드 (DimensionType.incomeType 값과 일치)
  final String incomeType;

  /// 과세방식 — 결산 시점에 확정
  final TaxationType taxationType;

  /// 연간 금융소득 합계 (금융소득 종합과세 판정용)
  final int? annualTotal;
}

/// 과세방식
enum TaxationType {
  comprehensive,  // 종합과세
  separateTax,    // 분리과세 (원천징수 종결)
  notApplicable,  // 해당 없음 (비용, B/S 계정)
  pending,        // 미확정 (결산 전)
}

/// 소득유형 8종 자동 분류 UseCase (CW 섹션 6.4).
///
/// Account.defaultIncomeTypeId → incomeType 매핑.
/// 금융소득(이자+배당) 종합과세 판정: 연간 합계 > 기준금액 → 종합과세.
class ClassifyIncomeType {
  ClassifyIncomeType({
    required ILegalParameterRepository legalParameterRepository,
  }) : _legalParameterRepository = legalParameterRepository;

  final ILegalParameterRepository _legalParameterRepository;

  // ---------------------------------------------------------------------------
  // 계정과목명 → 소득유형 매핑 (CW 섹션 6.4 테이블)
  // ---------------------------------------------------------------------------

  static const Map<String, String> _mapAccountToIncomeType = {
    // 이자소득
    '이자수익': 'INTEREST',
    '예금이자': 'INTEREST',
    '이자': 'INTEREST',
    // 배당소득
    '배당금수익': 'DIVIDEND',
    '분배금': 'DIVIDEND',
    '배당': 'DIVIDEND',
    // 사업소득
    '매출': 'BUSINESS',
    '용역수익': 'BUSINESS',
    '서비스수익': 'BUSINESS',
    // 근로소득
    '급여': 'EMPLOYMENT',
    '상여금': 'EMPLOYMENT',
    '임금': 'EMPLOYMENT',
    // 연금소득
    '연금수령액': 'PENSION',
    '연금': 'PENSION',
    // 양도소득
    '유가증권처분이익': 'CAPITAL_GAINS',
    '부동산처분이익': 'CAPITAL_GAINS',
    '처분이익': 'CAPITAL_GAINS',
    // 퇴직소득
    '퇴직금수령': 'RETIREMENT',
    '퇴직금': 'RETIREMENT',
    // 기타소득
    '잡수익': 'OTHER',
    '위약금수익': 'OTHER',
    '기타수익': 'OTHER',
  };

  static const Set<String> _setFinancialIncomeTypes = {'INTEREST', 'DIVIDEND'};

  // ---------------------------------------------------------------------------
  // public API
  // ---------------------------------------------------------------------------

  /// 계정과목명 기반 소득유형 분류.
  ///
  /// [account]: 분류할 계정과목
  /// [annualFinancialTotal]: 해당 소유자의 귀속연도 금융소득 합계 (종합과세 판정용)
  /// [asOfDate]: 기준일 — LegalParameter 조회에 사용
  Future<IncomeTypeResult> classify({
    required Account account,
    int annualFinancialTotal = 0,
    required DateTime asOfDate,
  }) async {
    // 비용(Expense), B/S 계정 → 소득유형 없음
    if (account.nature != AccountNature.revenue) {
      return const IncomeTypeResult(
        incomeType: 'N/A',
        taxationType: TaxationType.notApplicable,
      );
    }

    final strIncomeType = _matchIncomeType(account.name);
    if (strIncomeType == null) {
      return const IncomeTypeResult(
        incomeType: 'UNKNOWN',
        taxationType: TaxationType.pending,
      );
    }

    // 금융소득 종합과세 판정 (결산 시점)
    if (_setFinancialIncomeTypes.contains(strIncomeType)) {
      final taxationType = await _determineFinancialTaxationType(
        annualFinancialTotal: annualFinancialTotal,
        asOfDate: asOfDate,
      );
      return IncomeTypeResult(
        incomeType: strIncomeType,
        taxationType: taxationType,
        annualTotal: annualFinancialTotal,
      );
    }

    return IncomeTypeResult(
      incomeType: strIncomeType,
      taxationType: TaxationType.pending,
    );
  }

  // ---------------------------------------------------------------------------
  // 내부 헬퍼
  // ---------------------------------------------------------------------------

  /// 계정명 키워드로 소득유형 코드 매핑 — 정확 포함 매칭
  String? _matchIncomeType(String accountName) {
    final strLower = accountName.toLowerCase();
    for (final entry in _mapAccountToIncomeType.entries) {
      if (strLower.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return null;
  }

  /// 금융소득 종합과세 판정:
  ///   IF 연간 합계 > LegalParameter("금융소득_종합과세_기준금액"):
  ///     종합과세, ELSE: 분리과세
  ///
  /// 현행 기준: 2,000만원 (= 20,000,000원)
  Future<TaxationType> _determineFinancialTaxationType({
    required int annualFinancialTotal,
    required DateTime asOfDate,
  }) async {
    final dynamic param = await _legalParameterRepository.findEffective(
      '금융소득_종합과세_기준금액',
      asOfDate,
    );

    int threshold = 20000000; // 기본값 2,000만원
    if (param != null) {
      try {
        final dynamic rawValue =
            param is Map ? param['value'] : (param as dynamic).value;
        threshold = rawValue is int
            ? rawValue
            : int.tryParse(rawValue.toString()) ?? threshold;
      } catch (_) {
        // LegalParameter 조회 실패 → 기본값 유지
      }
    }

    return annualFinancialTotal > threshold
        ? TaxationType.comprehensive
        : TaxationType.separateTax;
  }
}
