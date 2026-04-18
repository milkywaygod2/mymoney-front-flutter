import 'package:drift/drift.dart';

/// 법률 변수 — 세율/한도율 등 법 개정 시 교체되는 파라미터
class LegalParameters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get countryCode => text().withDefault(const Constant('KR'))();
  /// ACCOUNTING | CAPITAL | TAX
  TextColumn get domain => text()();
  /// 파라미터 키 (예: "접대비_한도율")
  TextColumn get key => text()();
  /// VALUE | TABLE | FORMULA
  TextColumn get paramType => text()();
  /// 단순값 (JSON)
  TextColumn get value => text().nullable()();
  /// 구간 테이블 (JSON, 누진세율 등)
  TextColumn get tableData => text().nullable()();
  /// 수식 문자열
  TextColumn get formula => text().nullable()();
  /// 수식 입력 변수 (JSON)
  TextColumn get inputVariables => text().nullable()();
  DateTimeColumn get effectiveFrom => dateTime()();
  DateTimeColumn get effectiveTo => dateTime().nullable()();
  /// TRANSACTION_DATE | FISCAL_YEAR | FILING_DEADLINE
  TextColumn get applicationBasis => text()();
  BoolColumn get retroactive => boolean().withDefault(const Constant(false))();
  /// 근거 법령 (예: "법인세법 제25조")
  TextColumn get sourceLaw => text().nullable()();
  /// 국가별 특수 조건 (JSON)
  TextColumn get conditions => text().nullable()();
}
