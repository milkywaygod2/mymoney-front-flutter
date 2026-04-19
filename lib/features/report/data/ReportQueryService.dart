import 'package:drift/drift.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/domain/Perspective.dart';
import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/AccountTable.dart';
import '../../../infrastructure/database/tables/JournalEntryLineTable.dart';
import '../../../infrastructure/database/tables/TransactionTable.dart';

/// B/S 계정별 잔액 항목
class BalanceSheetEntry {
  const BalanceSheetEntry({
    required this.accountId,
    required this.accountName,
    required this.nature,
    required this.equityTypePath,
    required this.liquidityPath,
    required this.balance,
  });

  final int accountId;
  final String accountName;
  final AccountNature nature;

  /// Materialized Path (예: ASSET.CURRENT.CASH)
  final String equityTypePath;
  final String liquidityPath;

  /// 잔액 (차변 - 대변, 부채·자본·수익은 부호 반전 후 전달)
  final int balance;
}

/// P/L 계정별 금액 항목
class IncomeStatementEntry {
  const IncomeStatementEntry({
    required this.accountId,
    required this.accountName,
    required this.nature,
    required this.equityTypePath,
    required this.amount,
  });

  final int accountId;
  final String accountName;
  final AccountNature nature;
  final String equityTypePath;

  /// 수익은 양수, 비용은 양수 (각각 별도 집계 후 호출자가 차감)
  final int amount;
}

/// ReportQueryService — B/S, P/L 실시간 집계 쿼리 서비스
///
/// [아키텍처 근거 — CW_ARCHITECTURE.md 섹션 7.1]
/// B/S, P/L, CF 모두 JEL 집계 쿼리로 동적 생성.
/// Perspective 필터 동적 적용.
///
/// SQL 패턴:
///   SELECT equity_type_path, nature,
///     SUM(CASE WHEN entry_type='DEBIT' THEN base_amount ELSE 0 END)
///     - SUM(CASE WHEN entry_type='CREDIT' THEN base_amount ELSE 0 END) AS balance
///   FROM journal_entry_lines jel
///   JOIN accounts a ON jel.account_id = a.id
///   JOIN transactions t ON jel.transaction_id = t.id
///   WHERE t.status = 'POSTED' AND t.date <= :snapshot_date
///     AND COALESCE(jel.owner_id_override, a.owner_id) IN (:owner_filter)
///   GROUP BY a.equity_type_path, a.nature
class ReportQueryService {
  ReportQueryService(this._db);
  final AppDatabase _db;

  /// B/S 잔액 집계 — snapshotDate 기준 누적 잔액
  ///
  /// [snapshotDate] 기준일 (이 날짜까지의 누적 잔액)
  /// [perspective] 관점 필터 (null = 전체)
  Future<List<BalanceSheetEntry>> calculateBalanceSheet({
    required DateTime snapshotDate,
    Perspective? perspective,
  }) async {
    // Drift 타입 안전 쿼리 — customSelect로 집계 실행
    // (Drift의 selectOnly + addColumns 집계 한계 우회)
    final listOwnerIds = _extractOwnerIds(perspective);
    final strOwnerFilter = listOwnerIds.isNotEmpty
        ? listOwnerIds.map((id) => id.toString()).join(',')
        : null;

    // 집계 쿼리: Posted 거래 기준, snapshotDate 이하, B/S 계정(ASSET/LIABILITY/EQUITY)
    final strSql = '''
      SELECT
        a.id          AS account_id,
        a.name        AS account_name,
        a.nature      AS nature,
        a.equity_type_path AS equity_type_path,
        a.liquidity_path   AS liquidity_path,
        SUM(CASE WHEN jel.entry_type = 'DEBIT'  THEN jel.base_amount ELSE 0 END)
        - SUM(CASE WHEN jel.entry_type = 'CREDIT' THEN jel.base_amount ELSE 0 END)
          AS balance
      FROM journal_entry_lines jel
      JOIN accounts a ON jel.account_id = a.id
      JOIN transactions t ON jel.transaction_id = t.id
      WHERE t.status = 'POSTED'
        AND t.date <= ?
        AND a.nature IN ('asset', 'liability', 'equity')
        ${strOwnerFilter != null ? 'AND COALESCE(jel.owner_id_override, a.owner_id) IN ($strOwnerFilter)' : ''}
      GROUP BY a.id, a.name, a.nature, a.equity_type_path, a.liquidity_path
      HAVING balance != 0
      ORDER BY a.equity_type_path, a.liquidity_path
    ''';

    final listRows = await _db.customSelect(
      strSql,
      variables: [Variable.withDateTime(snapshotDate)],
      readsFrom: {_db.journalEntryLines, _db.accounts, _db.transactions},
    ).get();

    return listRows.map((row) {
      final strNature = row.read<String>('nature');
      return BalanceSheetEntry(
        accountId: row.read<int>('account_id'),
        accountName: row.read<String>('account_name'),
        nature: AccountNature.values.byName(strNature),
        equityTypePath: row.read<String>('equity_type_path'),
        liquidityPath: row.read<String>('liquidity_path'),
        balance: row.read<int>('balance'),
      );
    }).toList();
  }

  /// P/L 기간별 집계 — periodId 기간 내 수익/비용 합계
  ///
  /// [periodId] 결산 기간 ID
  /// [perspective] 관점 필터 (null = 전체)
  Future<List<IncomeStatementEntry>> calculateIncomeStatement({
    required int periodId,
    Perspective? perspective,
  }) async {
    final listOwnerIds = _extractOwnerIds(perspective);
    final strOwnerFilter = listOwnerIds.isNotEmpty
        ? listOwnerIds.map((id) => id.toString()).join(',')
        : null;

    final strSql = '''
      SELECT
        a.id          AS account_id,
        a.name        AS account_name,
        a.nature      AS nature,
        a.equity_type_path AS equity_type_path,
        SUM(CASE WHEN jel.entry_type = 'DEBIT'  THEN jel.base_amount ELSE 0 END)
        - SUM(CASE WHEN jel.entry_type = 'CREDIT' THEN jel.base_amount ELSE 0 END)
          AS amount
      FROM journal_entry_lines jel
      JOIN accounts a ON jel.account_id = a.id
      JOIN transactions t ON jel.transaction_id = t.id
      WHERE t.status = 'POSTED'
        AND t.period_id = ?
        AND a.nature IN ('revenue', 'expense')
        ${strOwnerFilter != null ? 'AND COALESCE(jel.owner_id_override, a.owner_id) IN ($strOwnerFilter)' : ''}
      GROUP BY a.id, a.name, a.nature, a.equity_type_path
      ORDER BY a.nature, a.equity_type_path
    ''';

    final listRows = await _db.customSelect(
      strSql,
      variables: [Variable.withInt(periodId)],
      readsFrom: {_db.journalEntryLines, _db.accounts, _db.transactions},
    ).get();

    return listRows.map((row) {
      final strNature = row.read<String>('nature');
      // 수익 계정은 대변 정상 → raw amount 부호 반전이 실질 수익액
      // 비용 계정은 차변 정상 → raw amount가 실질 비용액
      final int rawAmount = row.read<int>('amount');
      final AccountNature nature = AccountNature.values.byName(strNature);
      final int amount = nature == AccountNature.revenue ? -rawAmount : rawAmount;
      return IncomeStatementEntry(
        accountId: row.read<int>('account_id'),
        accountName: row.read<String>('account_name'),
        nature: nature,
        equityTypePath: row.read<String>('equity_type_path'),
        amount: amount,
      );
    }).toList();
  }

  /// 특정 기간의 Draft 잔존 건수 조회 — 결산 1단계 검증용
  Future<int> countRemainingDrafts(int periodId) async {
    final listRows = await _db.customSelect(
      '''
      SELECT COUNT(*) AS cnt
      FROM transactions
      WHERE period_id = ? AND status = 'draft'
      ''',
      variables: [Variable.withInt(periodId)],
      readsFrom: {_db.transactions},
    ).get();
    return listRows.first.read<int>('cnt');
  }

  /// 시산표 생성 — 기간 내 모든 계정의 차변/대변 합계
  /// 결산 1단계에서 차대변 균형 전체 검증에 사용
  Future<Map<String, int>> buildTrialBalance(int periodId) async {
    final listRows = await _db.customSelect(
      '''
      SELECT
        SUM(CASE WHEN jel.entry_type = 'DEBIT'  THEN jel.base_amount ELSE 0 END) AS total_debit,
        SUM(CASE WHEN jel.entry_type = 'CREDIT' THEN jel.base_amount ELSE 0 END) AS total_credit
      FROM journal_entry_lines jel
      JOIN transactions t ON jel.transaction_id = t.id
      WHERE t.status = 'POSTED' AND t.period_id = ?
      ''',
      variables: [Variable.withInt(periodId)],
      readsFrom: {_db.journalEntryLines, _db.transactions},
    ).get();

    final row = listRows.first;
    return {
      'totalDebit': row.read<int>('total_debit'),
      'totalCredit': row.read<int>('total_credit'),
    };
  }

  /// Perspective에서 소유자 ID 목록 추출 (owner 필터용)
  /// mapDimensionFilters에 소유자 정보가 없으면 빈 목록 (전체 소유자)
  List<int> _extractOwnerIds(Perspective? perspective) {
    // 현재 Perspective는 dimensionFilters 기반 — 소유자 직접 필터는 별도 확장 필요
    // MVP: 소유자 필터 없이 전체 집계 (추후 PerspectiveBloc에서 ownerId 전달 예정)
    return [];
  }
}
