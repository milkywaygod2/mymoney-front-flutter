import '../models/FinancialRatio.dart';

/// 재무비율 스냅샷 저장소 인터페이스 (v2.0)
/// 결산 시 확정 비율을 FinancialRatioSnapshots 테이블에 저장/조회
abstract interface class IFinancialRatioRepository {
  /// 특정 결산기간의 전체 비율 조회
  Future<List<FinancialRatio>> findByPeriod(int periodId);

  /// 특정 결산기간의 특정 비율 조회
  Future<FinancialRatio?> findByPeriodAndCode(int periodId, String ratioCode);

  /// 특정 비율의 기간별 추이 (최근 limit건, 시계열 분석용)
  Future<List<FinancialRatio>> findTrend(String ratioCode, {int limit = 12});

  /// 단일 비율 저장
  Future<void> save(FinancialRatio ratio);

  /// 결산 시 전체 비율 일괄 저장
  Future<void> saveAll(List<FinancialRatio> listRatios);
}
