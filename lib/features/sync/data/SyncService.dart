import 'dart:async';

import '../../../infrastructure/database/AppDatabase.dart';
import 'ConnectivityMonitor.dart';
import 'OutboxProcessor.dart';

/// 동기화 서비스 인터페이스
abstract interface class ISyncService {
  /// 동기화 수동 트리거 (앱 포그라운드 복귀, 온라인 전환 시 호출)
  Future<SyncResult> triggerSync();

  /// 동기화 중 여부
  bool get isSyncing;

  /// 동기화 상태 스트림
  Stream<SyncStatus> get streamStatus;
}

/// 동기화 결과 VO
class SyncResult {
  const SyncResult({
    required this.outboxSent,
    required this.deltaReceived,
    required this.conflictCount,
    this.errorMessage,
  });

  /// 전송 성공한 Outbox 항목 수
  final int outboxSent;

  /// Delta Sync로 수신한 서버 변경 항목 수
  final int deltaReceived;

  /// 충돌 항목 수 (사용자 해소 필요)
  final int conflictCount;

  /// 오류 메시지 (null = 정상)
  final String? errorMessage;

  bool get hasConflicts => conflictCount > 0;
  bool get hasError => errorMessage != null;
}

/// 동기화 진행 상태 enum
enum SyncStatus {
  idle,           // 대기
  syncing,        // 동기화 중
  success,        // 성공
  partialConflict, // 일부 충돌 (사용자 해소 필요)
  failed,         // 실패
}

/// Outbox + Delta Sync 동기화 서비스 구현
///
/// 동기화 흐름:
///   1. Outbox PENDING → FIFO 순 서버 전송 (OutboxProcessor)
///   2. Delta Sync: last_synced_at 기반 서버 변경분 pull → 로컬 갱신
///   3. 지수 백오프: 오류 시 1s→2s→4s→8s→16s 재시도 (최대 5회)
///
/// 오프라인 전략: Online-First with Offline Capability
///   - 오프라인: Draft 생성은 로컬만 (Outbox에 PENDING 쌓임)
///   - 온라인 복귀: ConnectivityMonitor 감지 → triggerSync() 자동 호출
class SyncService implements ISyncService {
  SyncService({
    required AppDatabase db,
    required OutboxProcessor outboxProcessor,
    required IConnectivityMonitor connectivityMonitor,
  })  : _db = db,
        _outboxProcessor = outboxProcessor,
        _connectivityMonitor = connectivityMonitor,
        _controller = StreamController<SyncStatus>.broadcast() {
    // 온라인 전환 감지 → 자동 동기화 트리거
    _connectivitySub = connectivityMonitor.streamOnline.listen((isOnline) {
      if (isOnline && !_isSyncing) {
        triggerSync();
      }
    });
  }

  // ignore: unused_field — Delta Sync 구현 시 직접 쿼리에 사용 예정
  final AppDatabase _db;
  final OutboxProcessor _outboxProcessor;
  final IConnectivityMonitor _connectivityMonitor;
  final StreamController<SyncStatus> _controller;
  StreamSubscription<bool>? _connectivitySub;

  bool _isSyncing = false;
  // ignore: unused_field — _pullDelta() 구현 시 since 파라미터로 전달 예정
  DateTime? _lastSyncedAt;

  /// 지수 백오프 재시도 간격 (초 단위)
  static const List<int> _backoffSeconds = [1, 2, 4, 8, 16];

  @override
  bool get isSyncing => _isSyncing;

  @override
  Stream<SyncStatus> get streamStatus => _controller.stream;

  @override
  Future<SyncResult> triggerSync() async {
    // 중복 실행 방지
    if (_isSyncing) {
      return const SyncResult(
        outboxSent: 0,
        deltaReceived: 0,
        conflictCount: 0,
        errorMessage: '이미 동기화 중입니다',
      );
    }
    if (!_connectivityMonitor.isOnline) {
      return const SyncResult(
        outboxSent: 0,
        deltaReceived: 0,
        conflictCount: 0,
        errorMessage: '오프라인 상태입니다',
      );
    }

    _isSyncing = true;
    _controller.add(SyncStatus.syncing);

    try {
      // 1단계: Outbox FIFO 전송 (지수 백오프 포함)
      final outboxSent = await _processOutboxWithBackoff();

      // 2단계: Delta Sync (서버 변경분 pull)
      final deltaReceived = await _pullDelta();

      // 3단계: 충돌 항목 수 확인
      final listConflicts = await _outboxProcessor.fetchConflicts();

      _lastSyncedAt = DateTime.now();
      final result = SyncResult(
        outboxSent: outboxSent,
        deltaReceived: deltaReceived,
        conflictCount: listConflicts.length,
      );

      _controller.add(
        result.hasConflicts ? SyncStatus.partialConflict : SyncStatus.success,
      );
      return result;
    } catch (e) {
      _controller.add(SyncStatus.failed);
      return SyncResult(
        outboxSent: 0,
        deltaReceived: 0,
        conflictCount: 0,
        errorMessage: '동기화 실패: $e',
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Outbox 처리 + 지수 백오프 재시도
  Future<int> _processOutboxWithBackoff() async {
    int totalSent = 0;
    int attemptCount = 0;

    while (attemptCount < _backoffSeconds.length) {
      try {
        final sent = await _outboxProcessor.processNext();
        totalSent += sent;
        // 전송할 항목 없으면 종료
        if (sent == 0) break;
        // 남은 항목 있으면 계속 처리
        final remaining = await _outboxProcessor.countPending();
        if (remaining == 0) break;
      } catch (_) {
        // 네트워크 오류 → 백오프 대기 후 재시도
        if (attemptCount < _backoffSeconds.length - 1) {
          await Future.delayed(
            Duration(seconds: _backoffSeconds[attemptCount]),
          );
        }
        attemptCount++;
      }
    }
    return totalSent;
  }

  /// Delta Sync — 서버 변경분 pull
  ///
  /// TODO: IServerApiClient.fetchDelta() 호출 후 로컬 DB 갱신 구현
  ///   - 거래(Transaction), 계정(Account), 거래처(Counterparty) 갱신
  ///   - last_synced_at 기준으로 서버 변경분만 수신
  Future<int> _pullDelta() async {
    // TODO: 서버 API 구현 후 실제 Delta Sync 활성화
    //
    // 구현 예시:
    //   final since = _lastSyncedAt ?? DateTime(2000);
    //   final listChanges = await _apiClient.fetchDelta(since);
    //   for (final change in listChanges) {
    //     await _applyDeltaChange(change);
    //   }
    //   return listChanges.length;
    return 0;
  }

  void dispose() {
    _connectivitySub?.cancel();
    _controller.close();
  }
}
