import 'package:drift/drift.dart';

/// 거래처 마스터
class Counterparties extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  /// 고유번호 (사업자번호/주민번호)
  TextColumn get identifier => text().nullable()();
  /// BUSINESS | PERSONAL | NONE
  TextColumn get identifierType => text().withDefault(const Constant('NONE'))();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  /// VERIFIED | INFERRED | UNKNOWN
  TextColumn get confidenceLevel => text().withDefault(const Constant('UNKNOWN'))();
  /// 세무 확장 예약
  BoolColumn get isRelatedParty => boolean().nullable()();
  TextColumn get counterpartyType => text().nullable()();
  /// 해외 확장 예약 (CRS/FATCA)
  TextColumn get countryCode => text().nullable()();
}
