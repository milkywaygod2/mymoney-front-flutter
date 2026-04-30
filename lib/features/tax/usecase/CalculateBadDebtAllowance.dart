import '../../../core/interfaces/ILegalParameterRepository.dart';
import '../../../core/models/TypedId.dart';
import '../../journal/data/TransactionDao.dart';

/// 대손충당금 연령분석 결과 항목
class AgingBucket {
  const AgingBucket({
    required this.label,
    required this.daysRange,
    required this.receivableBalance,
    required this.allowanceRate,
    required this.allowanceAmount,
  });

  /// 구간 라벨 (예: "30일 이내", "31~60일")
  final String label;

  /// 경과일수 범위 (예: "0-30", "31-60")
  final String daysRange;

  /// 해당 구간 채권 잔액 (최소 단위 int)
  final int receivableBalance;

  /// 적용 설정율 (배율 10000, 예: 100 = 1%)
  final int allowanceRate;

  /// 대손충당금 설정액 = 잔액 × 설정율
  final int allowanceAmount;
}

/// 대손충당금 계산 결과
class BadDebtAllowanceResult {
  const BadDebtAllowanceResult({
    required this.totalReceivables,
    required this.totalAllowance,
    required this.listBuckets,
    required this.legalLimit,
    required this.excessAmount,
  });

  /// 채권 총잔액
  final int totalReceivables;

  /// 대손충당금 총설정액
  final int totalAllowance;

  /// 연령 구간별 상세
  final List<AgingBucket> listBuckets;

  /// 법정 한도 (채권잔액 × 설정율 한도)
  final int legalLimit;

  /// 한도 초과분 (손금불산입 대상) = totalAllowance - legalLimit (양수면 초과)
  final int excessAmount;
}

/// 대손충당금 자동 계산 UseCase (v2.0)
///
/// 법인세법 제34조 기반:
/// - 채권 연령분석 (30/60/90/90일 초과)
/// - LegalParameter '대손충당금_설정율_한도' 참조
/// - 한도 초과분 → Deductibility.deductibleLimited (손금불산입)
class CalculateBadDebtAllowance {
  CalculateBadDebtAllowance({
    required this.legalParameterRepository,
    required this.transactionDao,
  });

  final ILegalParameterRepository legalParameterRepository;
  final TransactionDao transactionDao;

  /// 대손충당금 계산 실행
  ///
  /// [periodId] 결산 기간 ID
  /// [asOfDate] 기준일 (기말일)
  Future<BadDebtAllowanceResult> execute({
    required PeriodId periodId,
    required DateTime asOfDate,
  }) async {
    // 1. LegalParameter에서 설정율 한도 조회
    await legalParameterRepository.findEffective(
      '대손충당금_설정율_한도',
      asOfDate,
    );
    // 기본값: 일반채권 1% (TODO: TABLE 타입이면 JSON 파싱하여 채권 유형별 설정율 적용)
    final double limitRate = 0.01;
    // TODO: LP가 TABLE 타입이면 JSON 파싱하여 채권 유형별 설정율 적용

    // 2. 채권 계정 잔액 조회 (cashFlowCategory = receivablePayable 기반)
    final mapBalances = await transactionDao.calculateBalancesByAccount(
      periodId: periodId.value,
    );

    // 3. 연령분석 — 간소화 버전 (거래일 기준 경과일수 분류)
    // 실제 구현에서는 개별 채권별 경과일 계산 필요
    // 여기서는 전체 채권 잔액에 단일 설정율 적용 (MVP)
    final int totalReceivables = mapBalances.values
        .where((v) => v > 0) // 차변 잔액(채권)만
        .fold(0, (sum, v) => sum + v);

    // 4. 연령 구간별 대손충당금 (MVP: 단일 구간)
    final listBuckets = <AgingBucket>[
      AgingBucket(
        label: '일반채권 (전체)',
        daysRange: '0-365+',
        receivableBalance: totalReceivables,
        allowanceRate: (limitRate * 10000).round(), // 배율 10000
        allowanceAmount: (totalReceivables * limitRate).round(),
      ),
    ];

    final int totalAllowance =
        listBuckets.fold(0, (sum, b) => sum + b.allowanceAmount);
    final int legalLimit = (totalReceivables * limitRate).round();
    final int excessAmount =
        totalAllowance > legalLimit ? totalAllowance - legalLimit : 0;

    return BadDebtAllowanceResult(
      totalReceivables: totalReceivables,
      totalAllowance: totalAllowance,
      listBuckets: listBuckets,
      legalLimit: legalLimit,
      excessAmount: excessAmount,
    );
  }
}
