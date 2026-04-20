import '../constants/Enums.dart';

/// CF 코드 마스터 조회 인터페이스
/// CashFlowCodes 테이블(시드 113행)에 대한 읽기 전용 접근
abstract interface class ICashFlowCodeRepository {
  /// 전체 CF 코드 목록 (sortOrder 순)
  Future<List<CashFlowCodeDto>> findAll();

  /// 특정 코드 조회
  Future<CashFlowCodeDto?> findByCode(String code);

  /// 상위 코드 기준 하위 목록 (1단계만)
  Future<List<CashFlowCodeDto>> findByParent(String parentCode);

  /// 계층 깊이 기준 조회
  Future<List<CashFlowCodeDto>> findByLevel(int level);

  /// 인덱스 유형 기준 조회 (aggregate/actual/automatic)
  Future<List<CashFlowCodeDto>> findByIndexType(CfAccountIndex indexType);
}

/// CF 코드 DTO — 테이블 행 1:1 매핑
class CashFlowCodeDto {
  final int id;
  final String code;
  final String name;
  final String? parentCode;
  final CfAccountIndex indexType;
  final int level;
  final int sortOrder;

  const CashFlowCodeDto({
    required this.id,
    required this.code,
    required this.name,
    this.parentCode,
    required this.indexType,
    required this.level,
    required this.sortOrder,
  });
}
