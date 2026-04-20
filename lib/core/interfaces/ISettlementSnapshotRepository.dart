/// 결산 스냅샷 저장소 인터페이스
/// 결산 Step5에서 6종 보고서(BS/PL/CF/CE/TAX/RATIO)를 JSON으로 영구 저장
abstract interface class ISettlementSnapshotRepository {
  /// 스냅샷 저장 (동일 periodId+snapshotType 존재 시 덮어쓰기)
  Future<void> saveSnapshot(int periodId, String snapshotType, Map<String, dynamic> data);

  /// 특정 기간+유형의 스냅샷 조회
  Future<Map<String, dynamic>?> findSnapshot(int periodId, String snapshotType);

  /// 특정 기간에 저장된 스냅샷 유형 목록
  Future<List<String>> findSnapshotTypes(int periodId);

  /// 특정 기간의 모든 스냅샷 삭제 (결산 재실행 시)
  Future<void> deleteByPeriod(int periodId);
}
