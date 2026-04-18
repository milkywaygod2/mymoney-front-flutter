import 'package:drift/drift.dart';

import 'AccountTable.dart';
import 'DimensionValueTable.dart';
import 'OwnerTable.dart';
import 'TransactionTable.dart';

/// 전표 라인 — Transaction의 하위 Entity
/// 차대변 균형: SUM(debit.baseAmount) == SUM(credit.baseAmount)
class JournalEntryLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get accountId => integer().references(Accounts, #id)();
  /// DEBIT | CREDIT
  TextColumn get entryType => text()();
  /// 거래원화 최소 단위 int (불변)
  IntColumn get originalAmount => integer()();
  /// ISO 4217 통화 코드 (T1 구조축, TEXT 필드)
  TextColumn get originalCurrency => text().withLength(min: 3, max: 3)();
  /// 거래시점 환율 (배율 1,000,000, 불변)
  IntColumn get exchangeRateAtTrade => integer()();
  /// 기준통화 코드
  TextColumn get baseCurrency => text().withLength(min: 3, max: 3)();
  /// 기준통화 환산액 (파생, 불변)
  IntColumn get baseAmount => integer()();

  // --- T2 Override (nullable = Account 기본값 사용) ---
  IntColumn get activityTypeOverride => integer().nullable().references(DimensionValues, #id)();
  IntColumn get ownerIdOverride => integer().nullable().references(Owners, #id)();
  IntColumn get incomeTypeOverride => integer().nullable().references(DimensionValues, #id)();
  /// 손익금구분 (기본: UNDETERMINED)
  TextColumn get deductibility => text().withDefault(const Constant('UNDETERMINED'))();
  /// 실질 수혜자 (세무 실질과세 원칙)
  IntColumn get beneficiaryId => integer().nullable().references(Owners, #id)();
  TextColumn get taxClassification => text().nullable()();
  TextColumn get memo => text().nullable()();
}
