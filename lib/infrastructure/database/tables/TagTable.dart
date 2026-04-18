import 'package:drift/drift.dart';

/// 사용자 태그 (T3 자유축)
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// 태그명 (고유, 예: "#출근길")
  TextColumn get name => text().unique()();
  /// 태그 그룹 (향후 확장)
  TextColumn get category => text().nullable()();
}
