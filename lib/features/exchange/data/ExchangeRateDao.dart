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
  Future<ExchangeRate?> findRate(
    String fromCurrency,
    String toCurrency,
    DateTime date,
  ) {
    return (select(exchangeRates)
          ..where((r) => r.fromCurrency.equals(fromCurrency))
          ..where((r) => r.toCurrency.equals(toCurrency))
          // effectiveDate ≤ date (거래일 이전에 등록된 환율 중)
          ..where((r) => r.effectiveDate.isSmallerOrEqualValue(date))
          // 가장 최신 환율을 선택 (인덱스 활용: effectiveDate DESC)
          ..orderBy([(r) => OrderingTerm.desc(r.effectiveDate)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 최신 환율 조회 — effectiveDate 기준 가장 최근 레코드
  /// 온디맨드 미실현 손익 계산 시 현재 환율로 사용
  Future<ExchangeRate?> getLatestRate(
    String fromCurrency,
    String toCurrency,
  ) {
    return (select(exchangeRates)
          ..where((r) => r.fromCurrency.equals(fromCurrency))
          ..where((r) => r.toCurrency.equals(toCurrency))
          ..orderBy([(r) => OrderingTerm.desc(r.effectiveDate)])
          ..limit(1))
        .getSingleOrNull();
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
          ..where((r) => r.effectiveDate.isAfterOrEqualValue(cutoff))
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
