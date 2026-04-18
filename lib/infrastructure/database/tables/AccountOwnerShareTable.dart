import 'package:drift/drift.dart';

import 'AccountTable.dart';
import 'OwnerTable.dart';

/// 공동명의 지분율 — 복합 PK (accountId + ownerId)
/// shareRatio는 배율 10000 (33.33% = 3333, 합계 = 10000)
class AccountOwnerShares extends Table {
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get ownerId => integer().references(Owners, #id)();
  /// 지분율 (배율 kShareRatioMultiplier=10000)
  IntColumn get shareRatio => integer()();

  @override
  Set<Column> get primaryKey => {accountId, ownerId};
}
