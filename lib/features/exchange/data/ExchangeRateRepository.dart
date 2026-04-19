import 'package:drift/drift.dart';

import '../../../core/interfaces/IExchangeRateRepository.dart';
import '../../../core/models/CurrencyCode.dart';
import '../../../core/models/ExchangeRateValue.dart';
import '../../../infrastructure/database/tables/ExchangeRateTable.dart';
import '../usecase/ConvertCurrency.dart';
import 'ExchangeRateDao.dart';

/// IExchangeRateRepository 구현체 — Drift row ↔ ExchangeRateValue VO 변환
class ExchangeRateRepository implements IExchangeRateRepository {
  ExchangeRateRepository(this._dao);
  final ExchangeRateDao _dao;

  @override
  Future<ExchangeRateValue?> findRate(
    CurrencyCode from,
    CurrencyCode to,
    DateTime date,
  ) async {
    final row = await _dao.findRate(from.name, to.name, date);
    if (row == null) return null;
    return _toDomain(row);
  }

  @override
  Future<ExchangeRateValue> getLatestRate(
    CurrencyCode from,
    CurrencyCode to,
  ) async {
    final row = await _dao.getLatestRate(from.name, to.name);
    if (row == null) {
      throw ExchangeRateNotFoundError(
        from: from,
        to: to,
        date: DateTime.now(),
      );
    }
    return _toDomain(row);
  }

  @override
  Future<void> save(ExchangeRateValue exchangeRate) async {
    // ExchangeRateValue에는 effectiveDate/source가 없으므로
    // 저장 시 현재 시각을 effectiveDate로 사용
    // — 실제 API 연동 시 별도 메서드로 확장 예정
    await _dao.saveRate(
      ExchangeRatesCompanion(
        fromCurrency: Value(exchangeRate.fromCurrency.name),
        toCurrency: Value(exchangeRate.toCurrency.name),
        rate: Value(exchangeRate.rate),
        effectiveDate: Value(DateTime.now()),
        source: const Value('MANUAL'),
      ),
    );
  }

  /// 날짜/출처를 명시하여 환율 저장 — API 응답 저장 시 사용
  Future<void> saveWithMeta({
    required ExchangeRateValue exchangeRate,
    required DateTime effectiveDate,
    required String source,
    String purpose = 'ACCOUNTING',
  }) async {
    await _dao.saveRate(
      ExchangeRatesCompanion(
        fromCurrency: Value(exchangeRate.fromCurrency.name),
        toCurrency: Value(exchangeRate.toCurrency.name),
        rate: Value(exchangeRate.rate),
        effectiveDate: Value(effectiveDate),
        source: Value(source),
        purpose: Value(purpose),
      ),
    );
  }

  /// Drift ExchangeRate row → ExchangeRateValue VO 변환
  ExchangeRateValue _toDomain(ExchangeRate row) {
    return ExchangeRateValue(
      fromCurrency: CurrencyCode.values.byName(row.fromCurrency),
      toCurrency: CurrencyCode.values.byName(row.toCurrency),
      rate: row.rate,
    );
  }
}
