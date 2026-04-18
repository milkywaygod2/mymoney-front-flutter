import 'package:drift/drift.dart';

/// 소유자 / 가구 구성원
class Owners extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// 이름 (예: "형두", "유리")
  TextColumn get name => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
