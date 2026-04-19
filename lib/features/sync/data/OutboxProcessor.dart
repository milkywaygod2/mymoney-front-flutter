import 'package:drift/drift.dart';

import '../../../infrastructure/database/AppDatabase.dart';

/// Outbox 큐 처리 결과
enum OutboxProcessResult {
  success,   // 서버 전송 성공 → SYNCED
  conflict,  // 서버 409 충돌 → CONFLICT (Server-Wins)
  failed,    // 재시도 한도 초과 → FAILED
  skipped,   // 전송할 항목 없음
}

/// 서버 전송 계약 — 실제 HTTP 호출은 외부에서 주입
///
/// C# ASP.NET Core 서버 API와 통신하는 어댑터 인터페이스.
/// 테스트 시 Mock으로 대체 가능.
abstract interface class IServerApiClient {
  /// [entry] Outbox 항목 전송
  /// 성공: true, 충돌(409): throws ConflictException, 네트워크 오류: throws Exception
  Future<bool> sendEntry(OutboxEntry entry);

  /// Delta Sync: [sinceAt] 이후 서버 변경분 조회
  /// 반환: 변경된 엔티티 JSON 목록
  Future<List<Map<String, dynamic>>> fetchDelta(DateTime sinceAt);
}

/// 서버 충돌(409) 예외
class ConflictException implements Exception {
  const ConflictException(this.message);
  final String message;
  @override
  String toString() => 'ConflictException: $message';
}

/// Outbox 큐 FIFO 순차 처리기
///
/// 처리 흐름:
///   1. OutboxEntries에서 isSent=false 항목을 createdAt ASC 순으로 조회
///   2. 각 항목을 서버로 전송
///   3. 성공 → isSent=true
///   4. 충돌(409) → retryCount를 maxRetries로 설정 (사용자 해소 대기)
///   5. 네트워크 오류 → retryCount++ (지수 백오프는 SyncService에서 제어)
class OutboxProcessor {
  OutboxProcessor({
    required AppDatabase db,
    required IServerApiClient apiClient,
  })  : _db = db,
        _apiClient = apiClient;

  final AppDatabase _db;
  final IServerApiClient _apiClient;

  /// 최대 재시도 횟수 — 초과 시 FAILED로 확정
  static const int maxRetries = 5;

  /// 미전송 Outbox 항목 수 조회 (UI 배지 등에 활용)
  Future<int> countPending() async {
    final count = await (_db.selectOnly(_db.outboxEntries)
          ..addColumns([_db.outboxEntries.id.count()])
          ..where(_db.outboxEntries.isSent.equals(false) &
              _db.outboxEntries.retryCount.isSmallerThanValue(maxRetries)))
        .map((row) => row.read(_db.outboxEntries.id.count())!)
        .getSingle();
    return count;
  }

  /// FIFO 순서로 미전송 항목 1개씩 처리
  ///
  /// 반환: 처리된 항목 수 (0 = 전송할 항목 없음)
  Future<int> processNext() async {
    // createdAt ASC, 미전송(isSent=false), 재시도 한도 미초과 항목 조회
    final listPending = await (_db.select(_db.outboxEntries)
          ..where((e) =>
              e.isSent.equals(false) &
              e.retryCount.isSmallerThanValue(maxRetries))
          ..orderBy([(e) => OrderingTerm.asc(e.createdAt)])
          ..limit(10))
        .get();

    if (listPending.isEmpty) return 0;

    int processedCount = 0;
    for (final entry in listPending) {
      final result = await _processEntry(entry);
      if (result != OutboxProcessResult.skipped) processedCount++;
      // FAILED/CONFLICT는 계속 처리하지 않고 중단 (FIFO 순서 보장)
      if (result == OutboxProcessResult.conflict) break;
    }
    return processedCount;
  }

  /// 단일 항목 전송 처리
  Future<OutboxProcessResult> _processEntry(OutboxEntry entry) async {
    try {
      await _apiClient.sendEntry(entry);
      // 성공 → isSent=true
      await (_db.update(_db.outboxEntries)
            ..where((e) => e.id.equals(entry.id)))
          .write(OutboxEntriesCompanion(
        isSent: const Value(true),
      ));
      return OutboxProcessResult.success;
    } on ConflictException {
      // 충돌(409) → retryCount를 maxRetries로 설정 (사용자 해소 대기)
      await (_db.update(_db.outboxEntries)
            ..where((e) => e.id.equals(entry.id)))
          .write(OutboxEntriesCompanion(
        retryCount: Value(maxRetries),
      ));
      return OutboxProcessResult.conflict;
    } catch (_) {
      // 네트워크 오류 → retryCount 증가
      final newCount = entry.retryCount + 1;
      await (_db.update(_db.outboxEntries)
            ..where((e) => e.id.equals(entry.id)))
          .write(OutboxEntriesCompanion(
        retryCount: Value(newCount),
      ));
      return newCount >= maxRetries
          ? OutboxProcessResult.failed
          : OutboxProcessResult.skipped;
    }
  }

  /// CONFLICT 상태 항목 목록 조회 (충돌 해소 UI용)
  Future<List<OutboxEntry>> fetchConflicts() async {
    return (_db.select(_db.outboxEntries)
          ..where((e) =>
              e.isSent.equals(false) &
              e.retryCount.equals(maxRetries)))
        .get();
  }

  /// CONFLICT 항목 수동 해소 — 서버 데이터를 수용하고 해당 항목 삭제
  Future<void> resolveConflict(int entryId) async {
    await (_db.delete(_db.outboxEntries)
          ..where((e) => e.id.equals(entryId)))
        .go();
  }
}
