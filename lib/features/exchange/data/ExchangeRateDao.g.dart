// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExchangeRateDao.dart';

// ignore_for_file: type=lint
mixin _$ExchangeRateDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExchangeRatesTable get exchangeRates => attachedDatabase.exchangeRates;
  ExchangeRateDaoManager get managers => ExchangeRateDaoManager(this);
}

class ExchangeRateDaoManager {
  final _$ExchangeRateDaoMixin _db;
  ExchangeRateDaoManager(this._db);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db.attachedDatabase, _db.exchangeRates);
}
