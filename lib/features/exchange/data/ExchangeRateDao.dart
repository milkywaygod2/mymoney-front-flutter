import 'package:drift/drift.dart';

import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/ExchangeRateTable.dart';

part 'ExchangeRateDao.g.dart';

/// ExchangeRate Drift DAO — 환율 조회/저장
/// 인덱스: idx_exchange_rates_lookup (fromCurrency, toCurrency, effectiveDate DESC)
@DriftAccessor(tables: [ExchangeRates])
class ExchangeRateDao extends DatabaseAccessor<AppDatabase>
    with _$ExchangeRateDaoMixin {
  ExchangeRateDao(super.db);

  /// 특정 날짜의 환율 조회 — effectiveDate ≤ date 중 가장 최신 레코드
  /// 환율 테이블은 유효 시작일 기준으로 저장되므로,
  /// 거래일 이전 가장 최근 환율을 사용함 (실무 관행)
  ///
  /// [purpose] 환율 용도 (v2.0): ACCOUNTING|TAX|AVERAGE|CLOSING
  ///   - AVERAGE: 기간 평균환율 → P/L 수익/비용 환산
  ///   - CLOSING: 기말환율 → B/S 자산/부채 환산
  ///   - null이면 purpose 필터 없이 조회 (기존 동작 호환)
  Future<ExchangeRate?> findRate(
    String fromCurrency,
    String toCurrency,
    DateTime date, {
    String? purpose,
  }) {
    final query = select(exchangeRates)
      ..where((r) => r.fromCurrency.equals(fromCurrency))
      ..where((r) => r.toCurrency.equals(toCurrency))
      ..where((r) => r.effectiveDate.isSmallerOrEqualValue(date))
      ..orderBy([(r) => OrderingTerm.desc(r.effectiveDate)])
      ..limit(1);
    if (purpose != null) {
      query.where((r) => r.purpose.equals(purpose));
    }
    return query.getSingleOrNull();
  }

  /// 최신 환율 조회 — effectiveDate 기준 가장 최근 레코드
  /// 온디맨드 미실현 손익 계산 시 현재 환율로 사용
  ///
  /// [purpose] 환율 용도 필터 (v2.0). null이면 용도 무관 조회.
  Future<ExchangeRate?> getLatestRate(
    String fromCurrency,
    String toCurrency, {
    String? purpose,
  }) {
    final query = select(exchangeRates)
      ..where((r) => r.fromCurrency.equals(fromCurrency))
      ..where((r) => r.toCurrency.equals(toCurrency))
      ..orderBy([(r) => OrderingTerm.desc(r.effectiveDate)])
      ..limit(1);
    if (purpose != null) {
      query.where((r) => r.purpose.equals(purpose));
    }
    return query.getSingleOrNull();
  }

  /// 환율 저장 (중복 시 upsert — 동일 날짜/통화쌍 덮어쓰기)
  Future<void> saveRate(ExchangeRatesCompanion entry) {
    return into(exchangeRates).insertOnConflictUpdate(entry);
  }

  /// 특정 통화쌍의 최근 N일 환율 목록 조회 — 캐시 관리용
  Future<List<ExchangeRate>> findRecentRates(
    String fromCurrency,
    String toCurrency, {
    int days = 30,
  }) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(exchangeRates)
          ..where((r) => r.fromCurrency.equals(fromCurrency))
          ..where((r) => r.toCurrency.equals(toCurrency))
          ..where((r) => r.effectiveDate.isBiggerOrEqualValue(cutoff))
          ..orderBy([(r) => OrderingTerm.desc(r.effectiveDate)]))
        .get();
  }

  /// 캐시 만료 레코드 삭제 — cutoffDate 이전 레코드 제거
  Future<int> deleteOlderThan(DateTime cutoffDate) {
    return (delete(exchangeRates)
          ..where((r) => r.effectiveDate.isSmallerThanValue(cutoffDate)))
        .go();
  }
}
