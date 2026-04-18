// LegalParameter는 core/domain에 향후 추가 예정
// import '../domain/LegalParameter.dart';

/// 법률 변수(LegalParameter) 저장소 인터페이스.
/// External Parameter BC — 세율/한도 등 법률 의존 변수의 시계열 조회.
abstract interface class ILegalParameterRepository {
  /// 특정 시점에 유효한 법률 변수 조회
  /// [key]: 변수 키 (예: "종합소득세_기본세율", "접대비_한도")
  /// [asOfDate]: 기준일 (application_basis에 따라 거래일/귀속연도/신고기한)
  /// [countryCode]: 국가 코드 (다국가 확장 시, 기본 "KR")
  Future<dynamic> findEffective(
    String key,
    DateTime asOfDate, {
    String countryCode = 'KR',
  });

  /// 법률 변수 저장
  Future<void> save(dynamic legalParameter);
}
