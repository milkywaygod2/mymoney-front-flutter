import 'package:drift/drift.dart';

import '../../../core/domain/Perspective.dart';
import '../../../infrastructure/database/AppDatabase.dart' hide Perspective;
import '../../../infrastructure/database/tables/TransactionTable.dart';
import '../../../infrastructure/database/tables/JournalEntryLineTable.dart';
import '../../../infrastructure/database/tables/TagTable.dart';
import '../../../infrastructure/database/tables/TransactionTagTable.dart';

part 'TransactionDao.g.dart';

/// Transaction + JEL 조인 결과 데이터 클래스
class TransactionWithLines {
  final Transaction tx;
  final List<JournalEntryLine> listLines;
  final List<String> listTagNames;
  final List<int> listTagIds;

  const TransactionWithLines({
    required this.tx,
    required this.listLines,
    this.listTagNames = const [],
    this.listTagIds = const [],
  });
}

/// Transaction Drift DAO — CRUD + JEL 조인 쿼리
@DriftAccessor(tables: [Transactions, JournalEntryLines, Tags, TransactionTags])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  /// 거래 + 전표 라인 일괄 삽입 (트랜잭션 내)
  Future<int> insertTransactionWithLines(
    TransactionsCompanion txEntry,
    List<JournalEntryLinesCompanion> listLineEntries,
  ) async {
    return transaction(() async {
      final txId = await into(transactions).insert(txEntry);
      for (final lineEntry in listLineEntries) {
        await into(journalEntryLines).insert(
          lineEntry.copyWith(transactionId: Value(txId)),
        );
      }
      return txId;
    });
  }

  /// 거래 업데이트
  Future<bool> updateTransaction(TransactionsCompanion entry) {
    return update(transactions).replace(entry);
  }

  /// 거래 업데이트 + JEL 전체 삭제 후 재삽입 (트랜잭션 내)
  Future<void> updateTransactionWithLines(
    int txId,
    TransactionsCompanion txEntry,
    List<JournalEntryLinesCompanion> listLineEntries,
  ) async {
    await transaction(() async {
      await update(transactions).replace(txEntry);
      // 기존 JEL 전체 삭제
      await (delete(journalEntryLines)
            ..where((jel) => jel.transactionId.equals(txId)))
          .go();
      // 새 JEL 삽입
      for (final lineEntry in listLineEntries) {
        await into(journalEntryLines).insert(
          lineEntry.copyWith(transactionId: Value(txId)),
        );
      }
    });
  }

  /// 거래 삭제 (Draft만 — 비즈니스 규칙은 UseCase에서 검증)
  Future<int> deleteTransaction(int id) {
    return transaction(() async {
      // JEL 먼저 삭제 (FK)
      await (delete(journalEntryLines)
            ..where((jel) => jel.transactionId.equals(id)))
          .go();
      // 태그 연결 삭제
      await (delete(transactionTags)
            ..where((tt) => tt.transactionId.equals(id)))
          .go();
      // 거래 삭제
      return (delete(transactions)..where((t) => t.id.equals(id))).go();
    });
  }

  /// ID로 거래 + JEL + 태그 조회
  Future<TransactionWithLines?> findById(int id) async {
    final txRow = await (select(transactions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (txRow == null) return null;
    return _buildTransactionWithLines(txRow);
  }

  /// 기간별 거래 조회
  Future<List<TransactionWithLines>> findByPeriod(
    int periodId, {
    String? status,
  }) async {
    final query = select(transactions)
      ..where((t) => t.periodId.equals(periodId));
    if (status != null) {
      query.where((t) => t.status.equals(status));
    }
    final listRows = await query.get();
    return Future.wait(listRows.map(_buildTransactionWithLines));
  }

  /// 날짜 범위로 거래 조회
  Future<List<TransactionWithLines>> findByDateRange(
    DateTime from,
    DateTime to,
  ) async {
    final listRows = await (select(transactions)
          ..where((t) => t.date.isBetweenValues(from, to))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    return Future.wait(listRows.map(_buildTransactionWithLines));
  }

  /// 실시간 거래 목록 감시
  Stream<List<TransactionWithLines>> watchTransactions({int? limit}) {
    final query = select(transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    if (limit != null) query.limit(limit);

    return query.watch().asyncMap((listRows) async {
      return Future.wait(listRows.map(_buildTransactionWithLines));
    });
  }

  /// 계정별 잔액 계산 (기간 내 Posted 거래의 JEL 집계)
  Future<Map<int, int>> calculateBalancesByAccount({
    required int periodId,
  }) async {
    // 해당 기간의 Posted 거래 JEL을 집계
    final query = selectOnly(journalEntryLines).join([
      innerJoin(
        transactions,
        transactions.id.equalsExp(journalEntryLines.transactionId),
      ),
    ])
      ..where(transactions.periodId.equals(periodId))
      ..where(transactions.status.equals('POSTED'))
      ..addColumns([
        journalEntryLines.accountId,
        journalEntryLines.entryType,
        journalEntryLines.baseAmount.sum(),
      ])
      ..groupBy([journalEntryLines.accountId, journalEntryLines.entryType]);

    final listResults = await query.get();
    final Map<int, int> mapBalances = {};

    for (final row in listResults) {
      final accountId = row.read(journalEntryLines.accountId)!;
      final entryType = row.read(journalEntryLines.entryType)!;
      final sum = row.read(journalEntryLines.baseAmount.sum()) ?? 0;

      // 차변은 양수, 대변은 음수로 합산
      final amount = entryType == 'DEBIT' ? sum : -sum;
      mapBalances[accountId] = (mapBalances[accountId] ?? 0) + amount;
    }

    return mapBalances;
  }

  /// Perspective 필터 적용 거래 조회 (태그 + 차원 필터 + 날짜 범위)
  Future<List<TransactionWithLines>> findByPerspective(
    Perspective perspective, {
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    // 태그 필터: listTagFilters가 있으면 해당 태그를 가진 txId만 허용
    Set<int>? setTagTxIds;
    if (perspective.listTagFilters.isNotEmpty) {
      final listTagIds = perspective.listTagFilters.map((t) => t.value).toList();
      final listTagRows = await (select(transactionTags)
            ..where((tt) => tt.tagId.isIn(listTagIds)))
          .get();
      setTagTxIds = listTagRows.map((r) => r.transactionId).toSet();
      if (setTagTxIds.isEmpty) return [];
    }

    // 차원 필터: mapDimensionFilters 'OWNER_ID' → ownerIdOverride IN
    //           'ACTIVITY_TYPE' → activityTypeOverride IN
    Set<int>? setDimTxIds;
    final mapDim = perspective.mapDimensionFilters;
    if (mapDim.isNotEmpty) {
      final listOwnerIds = (mapDim['OWNER_ID'] ?? []).map((d) => d.value).toList();
      final listActivityIds = (mapDim['ACTIVITY_TYPE'] ?? []).map((d) => d.value).toList();
      if (listOwnerIds.isNotEmpty || listActivityIds.isNotEmpty) {
        final jelQuery = select(journalEntryLines);
        if (listOwnerIds.isNotEmpty && listActivityIds.isNotEmpty) {
          jelQuery.where((jel) =>
              jel.ownerIdOverride.isIn(listOwnerIds) |
              jel.activityTypeOverride.isIn(listActivityIds));
        } else if (listOwnerIds.isNotEmpty) {
          jelQuery.where((jel) => jel.ownerIdOverride.isIn(listOwnerIds));
        } else {
          jelQuery.where((jel) => jel.activityTypeOverride.isIn(listActivityIds));
        }
        final listJelRows = await jelQuery.get();
        setDimTxIds = listJelRows.map((j) => j.transactionId).toSet();
        if (setDimTxIds.isEmpty) return [];
      }
    }

    // 교집합: 태그 필터 ∩ 차원 필터
    final setAllowedIds = _intersectSets(setTagTxIds, setDimTxIds);

    final query = select(transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (from != null) query.where((t) => t.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((t) => t.date.isSmallerOrEqualValue(to));
    if (setAllowedIds != null) {
      query.where((t) => t.id.isIn(setAllowedIds));
    }
    if (limit != null) query.limit(limit);

    final listRows = await query.get();
    return Future.wait(listRows.map(_buildTransactionWithLines));
  }

  Set<int>? _intersectSets(Set<int>? a, Set<int>? b) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return a.intersection(b);
  }

  /// 외부 참조번호(카드승인번호 등)로 거래 조회 (v2.0)
  Future<TransactionWithLines?> findByReferenceNo(String referenceNo) async {
    final txRow = await (select(transactions)
          ..where((t) => t.referenceNo.equals(referenceNo)))
        .getSingleOrNull();
    if (txRow == null) return null;
    return _buildTransactionWithLines(txRow);
  }

  /// 내부: 거래 row에서 JEL + 태그를 조합하여 TransactionWithLines 생성
  Future<TransactionWithLines> _buildTransactionWithLines(
    Transaction txRow,
  ) async {
    final listLines = await (select(journalEntryLines)
          ..where((jel) => jel.transactionId.equals(txRow.id)))
        .get();

    // 태그 이름 조회
    final listTagRows = await (select(transactionTags).join([
      innerJoin(tags, tags.id.equalsExp(transactionTags.tagId)),
    ])
          ..where(transactionTags.transactionId.equals(txRow.id)))
        .get();
    final listTagNames =
        listTagRows.map((row) => row.readTable(tags).name).toList();
    final listTagIds =
        listTagRows.map((row) => row.readTable(tags).id).toList();

    return TransactionWithLines(
      tx: txRow,
      listLines: listLines,
      listTagNames: listTagNames,
      listTagIds: listTagIds,
    );
  }
}
