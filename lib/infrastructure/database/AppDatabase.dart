import 'package:drift/drift.dart';

import '../../features/account/data/AccountDao.dart';
import '../../features/counterparty/data/CounterpartyDao.dart';
import '../../features/exchange/data/ExchangeRateDao.dart';
import '../../features/journal/data/TransactionDao.dart';
import '../../features/perspective/data/PerspectiveDao.dart';
import '../../features/tax/data/LegalParameterDao.dart';
import 'seeds/DimensionValueSeeds.dart';
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
import 'tables/FinancialRatioSnapshotTable.dart';
import 'tables/CashFlowCodeTable.dart';
import 'tables/CashFlowMappingTable.dart';
import 'tables/SettlementSnapshotTable.dart';

part 'AppDatabase.g.dart';

/// MyMoney 메인 데이터베이스 — 20 테이블 + 16 인덱스 (v2.0)
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
  // v2.0 신규 테이블
  FinancialRatioSnapshots,
  CashFlowCodes,
  CashFlowMappings,
  SettlementSnapshots,
], daos: [
  AccountDao,
  TransactionDao,
  PerspectiveDao,
  CounterpartyDao,
  ExchangeRateDao,
  LegalParameterDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // 인덱스 생성
          await _createIndices(m);
          // 시드 데이터 삽입
          await _seedDimensionValues();
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
      'CREATE INDEX idx_outbox_pending ON outbox_entries(status, created_at)',
    );
    // 중복 탐지용 복합 인덱스
    await customStatement(
      'CREATE INDEX idx_transactions_dup_detect ON transactions(date, counterparty_name)',
    );
    // --- v2.0 인덱스 ---
    // 특수관계자 유형 필터
    await customStatement(
      'CREATE INDEX idx_counterparties_related_party_type ON counterparties(related_party_type)',
    );
    // 외부 참조번호 조회
    await customStatement(
      'CREATE INDEX idx_transactions_reference_no ON transactions(reference_no)',
    );
    // FX 재평가 대상 계정 선별
    await customStatement(
      'CREATE INDEX idx_accounts_fx_reval_target ON accounts(is_fx_reval_target) WHERE is_fx_reval_target = 1',
    );
    // 역분개 유형 필터
    await customStatement(
      'CREATE INDEX idx_transactions_reversal_type ON transactions(reversal_type)',
    );
    // CF 코드 정렬/계층
    await customStatement(
      'CREATE INDEX idx_cash_flow_codes_parent ON cash_flow_codes(parent_code)',
    );
    await customStatement(
      'CREATE INDEX idx_cash_flow_codes_sort ON cash_flow_codes(level, sort_order)',
    );
    // CF 매핑 조회
    await customStatement(
      'CREATE INDEX idx_cash_flow_mappings_account ON cash_flow_mappings(account_id)',
    );
    // 결산 스냅샷 조회
    await customStatement(
      'CREATE INDEX idx_settlement_snapshots_lookup ON settlement_snapshots(period_id, snapshot_type)',
    );
  }

  /// DimensionValue 시드 데이터 삽입 — DB 최초 생성 시 1회 호출
  Future<void> _seedDimensionValues() async {
    final listSeeds = getAllDimensionValueSeeds();
    await batch((b) {
      for (final map in listSeeds) {
        b.insert(
          dimensionValues,
          DimensionValuesCompanion.insert(
            dimensionType: map['dimensionType'] as String,
            code: map['code'] as String,
            name: map['name'] as String,
            path: map['code'] as String,
            entityType: Value(map['entityType'] as String),
            sortOrder: Value(map['sortOrder'] as int),
          ),
        );
      }
    });
  }
}
