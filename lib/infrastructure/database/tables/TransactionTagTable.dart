import 'package:drift/drift.dart';

import 'TagTable.dart';
import 'TransactionTable.dart';

/// Transaction ↔ Tag M:N 중간 테이블
class TransactionTags extends Table {
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {transactionId, tagId};
}
