import '../models/TypedId.dart';
import '../constants/Enums.dart';
import '../domain/Perspective.dart';

// Transaction은 Sofia 워크트리에서 동시 작성 중 — 머지 후 import 경로 확정
// import '../domain/Transaction.dart';

/// 거래(Transaction) 저장소 인터페이스.
/// Accounting BC의 핵심 AR 영속화 계약.
abstract interface class ITransactionRepository {
  /// ID로 거래 조회
  Future<dynamic> findById(TransactionId id);

  /// 귀속기간 + 상태 필터 조회
  Future<List<dynamic>> findByPeriod(
    PeriodId periodId, {
    TransactionStatus? status,
  });

  /// 날짜 범위 조회
  Future<List<dynamic>> findByDateRange(DateTime from, DateTime to);

  /// 거래 저장 (생성 + 수정)
  Future<void> save(dynamic transaction);

  /// 거래 삭제 — Draft 상태만 허용
  Future<void> delete(TransactionId id);

  /// Perspective(관점) 기반 필터 조회
  Future<List<dynamic>> findByPerspective(
    Perspective perspective, {
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  });

  /// 계정별 잔액 집계 (결산/재무제표 생성용)
  Future<Map<AccountId, int>> calculateBalances({
    required PeriodId periodId,
    Perspective? perspective,
  });
}
