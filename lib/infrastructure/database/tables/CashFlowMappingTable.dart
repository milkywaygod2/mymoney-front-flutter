import 'package:drift/drift.dart';

import 'AccountTable.dart';

/// Account → CF 코드 매핑
/// isAutomatic=true: Account.cashFlowCategory 기반 자동 결정
/// isAutomatic=false: 사용자가 수동으로 지정한 오버라이드
class CashFlowMappings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  /// CashFlowCodes.code 참조 (FK는 아님 — text 참조)
  TextColumn get cfCode => text()();
  /// 자동 매핑 여부 (false = 사용자 오버라이드)
  BoolColumn get isAutomatic => boolean().withDefault(const Constant(true))();
}
