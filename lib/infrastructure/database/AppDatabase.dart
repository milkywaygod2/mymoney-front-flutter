import 'package:drift/drift.dart';

import 'tables/DimensionValueTable.dart';
import 'tables/OwnerTable.dart';
import 'tables/AccountTable.dart';
import 'tables/AccountOwnerShareTable.dart';
import 'tables/CounterpartyTable.dart';
import 'tables/CounterpartyAliasTable.dart';
import 'tables/TransactionTable.dart';
import 'tables/JournalEntryLineTable.dart';
import 'tables/TagTable.dart';
import 'tables/TransactionTagTable.dart';
import 'tables/PerspectiveTable.dart';
import 'tables/ExchangeRateTable.dart';
import 'tables/LegalParameterTable.dart';
import 'tables/ClassificationRuleTable.dart';
import 'tables/FiscalPeriodTable.dart';
import 'tables/OutboxEntryTable.dart';

part 'AppDatabase.g.dart';

/// MyMoney 메인 데이터베이스 — 16 테이블 + 8 인덱스
@DriftDatabase(tables: [
  DimensionValues,
  Owners,
  Accounts,
  AccountOwnerShares,
  Counterparties,
  CounterpartyAliases,
  Transactions,
  JournalEntryLines,
  Tags,
  TransactionTags,
  Perspectives,
  ExchangeRates,
  LegalParameters,
  ClassificationRules,
  FiscalPeriods,
  OutboxEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // 인덱스 생성
          await _createIndices(m);
        },
      );

  Future<void> _createIndices(Migrator m) async {
    // 기간별 거래 조회
    await customStatement(
      'CREATE INDEX idx_transactions_date ON transactions(date)',
    );
    // 계정별 잔액 조회
    await customStatement(
      'CREATE INDEX idx_jel_account_id ON journal_entry_lines(account_id)',
    );
    // Perspective 필터 (Materialized Path LIKE 쿼리)
    await customStatement(
      'CREATE INDEX idx_accounts_equity_type_path ON accounts(equity_type_path)',
    );
    await customStatement(
      'CREATE INDEX idx_accounts_liquidity_path ON accounts(liquidity_path)',
    );
    await customStatement(
      'CREATE INDEX idx_accounts_asset_type_path ON accounts(asset_type_path)',
    );
    // 태그 기반 필터링
    await customStatement(
      'CREATE INDEX idx_transaction_tags_tag_id ON transaction_tags(tag_id)',
    );
    // OCR 거래처 매칭
    await customStatement(
      'CREATE INDEX idx_counterparty_aliases_alias ON counterparty_aliases(alias)',
    );
    // 최신 환율 조회
    await customStatement(
      'CREATE INDEX idx_exchange_rates_lookup ON exchange_rates(from_currency, to_currency, effective_date DESC)',
    );
    // 오프라인 동기화 FIFO
    await customStatement(
      'CREATE INDEX idx_outbox_pending ON outbox_entries(is_sent, created_at)',
    );
    // 중복 탐지용 복합 인덱스
    await customStatement(
      'CREATE INDEX idx_transactions_dup_detect ON transactions(date, counterparty_name)',
    );
  }
}
