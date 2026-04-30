/// 도메인 에러 기반 클래스
/// 모든 도메인 에러는 이 sealed class를 상속하여 패턴 매칭 가능
sealed class DomainError implements Exception {
  const DomainError(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// 불변조건 위반 (INV-T1~T7, INV-A1~A5 등)
/// Aggregate Root의 불변조건 검증 실패 시 발생
class InvariantViolationError extends DomainError {
  const InvariantViolationError(super.message);
}

/// 차대변 불균형 — 복식부기 핵심 불변조건(INV-T2) 위반
class BalanceMismatchError extends DomainError {
  const BalanceMismatchError({
    required this.debitSum,
    required this.creditSum,
  }) : super('차변 합계($debitSum) != 대변 합계($creditSum)');

  final int debitSum;
  final int creditSum;
}

/// 통화 불일치 — 다른 base_currency 합산 시도 시 발생 (INV-T3)
class CurrencyMismatchError extends DomainError {
  const CurrencyMismatchError({
    required this.expected,
    required this.actual,
  }) : super('통화 불일치: 기대=$expected, 실제=$actual');

  final String expected;
  final String actual;
}

/// Draft 상태가 아닌 거래 수정 시도 (INV-T5)
class NotDraftError extends DomainError {
  const NotDraftError() : super('Draft 상태에서만 수정 가능');
}

/// 시스템 프리셋 수정/삭제 시도 (INV-P2)
class SystemPresetModificationError extends DomainError {
  const SystemPresetModificationError()
      : super('시스템 프리셋은 수정/삭제 불가');
}

/// 비활성 계정 참조 시도 (INV-A5)
class InactiveAccountError extends DomainError {
  const InactiveAccountError(int accountId)
      : super('비활성 계정(id=$accountId)은 새 전표에 사용 불가');
}

/// 전표 라인 부족 (INV-T1) — Posted 시 최소 2개 필요
class InsufficientLinesError extends DomainError {
  const InsufficientLinesError(int lineCount)
      : super('최소 2개 전표 라인 필요 (현재: $lineCount)');
}

/// 금액 음수 (INV-T4) — original_amount는 항상 양수
class NegativeAmountError extends DomainError {
  const NegativeAmountError(int amount)
      : super('금액은 양수여야 합니다 (입력: $amount)');
}

/// 환율 데이터 미존재 — 환산 시 필요한 환율이 DB에 없을 때
class ExchangeRateNotFoundError extends DomainError {
  const ExchangeRateNotFoundError(super.detail);
}
