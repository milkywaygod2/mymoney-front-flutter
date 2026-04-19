import '../../../core/constants/Enums.dart';
import '../../../core/domain/Account.dart';

/// 계정과목명 기반 자동 deductibility 판정 결과
class DeductibilityRule {
  const DeductibilityRule({
    required this.deductibility,
    this.reason,
  });

  final Deductibility deductibility;

  /// 판정 근거 (법령 등)
  final String? reason;
}

/// 세무조정 규칙엔진 — 계정과목 기반 11개 자동 판정 규칙 (CW 섹션 6.1).
///
/// 판정 우선순위:
///   1. 계정명 키워드 매칭 (정확 포함 순서)
///   2. 매칭 불가 → Deductibility.undetermined 유지
///
/// 특수관계자 거래, 부당행위계산, 대손충당금은 자동 판정 불가 → 미판정 유지.
class TaxRuleEngine {
  const TaxRuleEngine();

  // ---------------------------------------------------------------------------
  // 계정과목명 키워드 → Deductibility 매핑 규칙 (우선순위 순)
  // ---------------------------------------------------------------------------

  static const List<_TaxRule> _listRules = [
    // 손금불산입 — 가장 먼저 적용 (부정적 판정 우선)
    _TaxRule(
      keywords: ['벌과금', '과태료', '범칙금', '과료'],
      deductibility: Deductibility.nonDeductible,
      reason: '법인세법 제21조 — 벌과금 등 손금불산입',
    ),
    // 손금산입(한도) — 접대비
    _TaxRule(
      keywords: ['접대비', '교제비', '접대'],
      deductibility: Deductibility.deductibleLimited,
      reason: '법인세법 제25조 — 접대비 손금산입 한도',
    ),
    // 손금산입 — 복리후생비
    _TaxRule(
      keywords: ['복리후생', '복리', '후생'],
      deductibility: Deductibility.deductible,
      reason: '시행령 제45조 — 복리후생비 손금산입',
    ),
    // 손금산입(한도) — 감가상각비
    _TaxRule(
      keywords: ['감가상각', '상각비', '감가'],
      deductibility: Deductibility.deductibleLimited,
      reason: '법인세법 제23조 — 감가상각비 손금산입 한도',
    ),
    // 장부존중 — 급여 계열
    _TaxRule(
      keywords: ['급여', '임금', '월급', '상여금', '성과급', '퇴직급여'],
      deductibility: Deductibility.bookRespected,
      reason: '회계=세무 일치 — 별도 조정 불필요',
    ),
    // 장부존중 — 소모품/비품
    _TaxRule(
      keywords: ['소모품', '비품', '사무용품'],
      deductibility: Deductibility.bookRespected,
      reason: '회계=세무 일치 — 별도 조정 불필요',
    ),
    // 손금산입 — 일반 영업비용
    _TaxRule(
      keywords: ['임차료', '지급임차료', '리스료'],
      deductibility: Deductibility.deductible,
      reason: '일반 손금 — 업무 관련 임차료',
    ),
    // 손금산입 — 광고선전비
    _TaxRule(
      keywords: ['광고선전', '광고비', '마케팅'],
      deductibility: Deductibility.deductible,
      reason: '일반 손금 — 광고선전비',
    ),
    // 손금산입(한도) — 기부금
    _TaxRule(
      keywords: ['기부금', '후원금', '기부'],
      deductibility: Deductibility.deductibleLimited,
      reason: '법인세법 제24조 — 기부금 손금산입 한도',
    ),
    // 손금산입 — 세금과공과 (일부)
    _TaxRule(
      keywords: ['재산세', '자동차세', '취득세', '등록세'],
      deductibility: Deductibility.deductible,
      reason: '일반 손금 — 사업 관련 세금과공과',
    ),
    // 손금불산입 — 법인세 자체
    _TaxRule(
      keywords: ['법인세', '소득세비용'],
      deductibility: Deductibility.nonDeductible,
      reason: '법인세법 제21조 — 법인세 등 손금불산입',
    ),
  ];

  // ---------------------------------------------------------------------------
  // 자동 판정 불가 키워드 — 미판정 강제
  // ---------------------------------------------------------------------------

  static const List<String> _listUndeterminedKeywords = [
    '특수관계', '부당행위', '대손충당', '채권', '대여금', '가지급금',
  ];

  // ---------------------------------------------------------------------------
  // public API
  // ---------------------------------------------------------------------------

  /// 계정과목 기반 자동 deductibility 판정.
  ///
  /// - Expense 계정에만 적용 (Revenue/Asset/Liability/Equity → undetermined)
  /// - 자동 판정 불가 키워드 → undetermined
  /// - 규칙 매칭 → 해당 판정값
  /// - 미매칭 → undetermined
  DeductibilityRule classify(Account account) {
    // Expense 계정에만 판정 적용
    if (account.nature != AccountNature.expense) {
      return const DeductibilityRule(
        deductibility: Deductibility.undetermined,
        reason: '비용(Expense) 계정에만 세무조정 판정 적용',
      );
    }

    final strName = account.name.toLowerCase();

    // 자동 판정 불가 — 미판정 강제
    for (final keyword in _listUndeterminedKeywords) {
      if (strName.contains(keyword)) {
        return const DeductibilityRule(
          deductibility: Deductibility.undetermined,
          reason: '자동 판정 불가 — 특수관계자/부당행위 등 수동 검토 필요',
        );
      }
    }

    // 규칙 순서대로 키워드 매칭
    for (final rule in _listRules) {
      for (final keyword in rule.keywords) {
        if (strName.contains(keyword)) {
          return DeductibilityRule(
            deductibility: rule.deductibility,
            reason: rule.reason,
          );
        }
      }
    }

    // 매칭 없음 — 미판정 유지
    return const DeductibilityRule(deductibility: Deductibility.undetermined);
  }
}

// ---------------------------------------------------------------------------
// 내부 규칙 정의 클래스
// ---------------------------------------------------------------------------

class _TaxRule {
  const _TaxRule({
    required this.keywords,
    required this.deductibility,
    this.reason,
  });

  final List<String> keywords;
  final Deductibility deductibility;
  final String? reason;
}
