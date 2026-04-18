import 'package:drift/drift.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/models/CurrencyCode.dart';

/// CurrencyCode ↔ String (ISO 4217 코드)
class CurrencyCodeConverter extends TypeConverter<CurrencyCode, String> {
  const CurrencyCodeConverter();

  @override
  CurrencyCode fromSql(String fromDb) =>
      CurrencyCode.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(CurrencyCode value) => value.name;
}

/// AccountNature ↔ String
class AccountNatureConverter extends TypeConverter<AccountNature, String> {
  const AccountNatureConverter();

  @override
  AccountNature fromSql(String fromDb) =>
      AccountNature.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(AccountNature value) => value.name;
}

/// EntryType ↔ String
class EntryTypeConverter extends TypeConverter<EntryType, String> {
  const EntryTypeConverter();

  @override
  EntryType fromSql(String fromDb) =>
      EntryType.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(EntryType value) => value.name;
}

/// TransactionStatus ↔ String
class TransactionStatusConverter extends TypeConverter<TransactionStatus, String> {
  const TransactionStatusConverter();

  @override
  TransactionStatus fromSql(String fromDb) =>
      TransactionStatus.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(TransactionStatus value) => value.name;
}

/// TransactionSource ↔ String
class TransactionSourceConverter extends TypeConverter<TransactionSource, String> {
  const TransactionSourceConverter();

  @override
  TransactionSource fromSql(String fromDb) =>
      TransactionSource.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(TransactionSource value) => value.name;
}

/// Deductibility ↔ String
class DeductibilityConverter extends TypeConverter<Deductibility, String> {
  const DeductibilityConverter();

  @override
  Deductibility fromSql(String fromDb) =>
      Deductibility.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(Deductibility value) => value.name;
}

/// SyncStatus ↔ String
class SyncStatusConverter extends TypeConverter<SyncStatus, String> {
  const SyncStatusConverter();

  @override
  SyncStatus fromSql(String fromDb) =>
      SyncStatus.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(SyncStatus value) => value.name;
}

/// DimensionType ↔ String
class DimensionTypeConverter extends TypeConverter<DimensionType, String> {
  const DimensionTypeConverter();

  @override
  DimensionType fromSql(String fromDb) =>
      DimensionType.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(DimensionType value) => value.name;
}

/// RecordingDirection ↔ String
class RecordingDirectionConverter extends TypeConverter<RecordingDirection, String> {
  const RecordingDirectionConverter();

  @override
  RecordingDirection fromSql(String fromDb) =>
      RecordingDirection.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(RecordingDirection value) => value.name;
}

/// PermissionLevel ↔ String
class PermissionLevelConverter extends TypeConverter<PermissionLevel, String> {
  const PermissionLevelConverter();

  @override
  PermissionLevel fromSql(String fromDb) =>
      PermissionLevel.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(PermissionLevel value) => value.name;
}
