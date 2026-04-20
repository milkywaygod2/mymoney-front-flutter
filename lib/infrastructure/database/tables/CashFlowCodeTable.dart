import 'package:drift/drift.dart';

/// CF 보고서 코드 마스터 — 시드 113행, 7분류 계층 구조
/// indexType: aggregate(하위 합산) | actual(직접 입력) | automatic(타 보고서 연동)
class CashFlowCodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// CF 코드 (예: "C100000" ~ "C7000000")
  TextColumn get code => text()();
  /// 코드명 (예: "Cash flows from operating activities")
  TextColumn get name => text()();
  /// 상위 코드 (NULL = 최상위 분류)
  TextColumn get parentCode => text().nullable()();
  /// 계정 인덱스 유형: aggregate | actual | automatic
  TextColumn get indexType => text()();
  /// 계층 깊이 (1~4)
  IntColumn get level => integer()();
  /// 정렬 순서
  IntColumn get sortOrder => integer()();
}
