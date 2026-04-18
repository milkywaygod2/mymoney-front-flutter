// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TransactionDao.dart';

// ignore_for_file: type=lint
mixin _$TransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $CounterpartiesTable get counterparties => attachedDatabase.counterparties;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $DimensionValuesTable get dimensionValues => attachedDatabase.dimensionValues;
  $OwnersTable get owners => attachedDatabase.owners;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $JournalEntryLinesTable get journalEntryLines =>
      attachedDatabase.journalEntryLines;
  $TagsTable get tags => attachedDatabase.tags;
  $TransactionTagsTable get transactionTags => attachedDatabase.transactionTags;
  TransactionDaoManager get managers => TransactionDaoManager(this);
}

class TransactionDaoManager {
  final _$TransactionDaoMixin _db;
  TransactionDaoManager(this._db);
  $$CounterpartiesTableTableManager get counterparties =>
      $$CounterpartiesTableTableManager(
        _db.attachedDatabase,
        _db.counterparties,
      );
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$DimensionValuesTableTableManager get dimensionValues =>
      $$DimensionValuesTableTableManager(
        _db.attachedDatabase,
        _db.dimensionValues,
      );
  $$OwnersTableTableManager get owners =>
      $$OwnersTableTableManager(_db.attachedDatabase, _db.owners);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$JournalEntryLinesTableTableManager get journalEntryLines =>
      $$JournalEntryLinesTableTableManager(
        _db.attachedDatabase,
        _db.journalEntryLines,
      );
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$TransactionTagsTableTableManager get transactionTags =>
      $$TransactionTagsTableTableManager(
        _db.attachedDatabase,
        _db.transactionTags,
      );
}
