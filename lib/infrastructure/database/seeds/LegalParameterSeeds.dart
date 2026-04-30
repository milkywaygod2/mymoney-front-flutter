// ignore_for_file: unused_element_parameter
/// LegalParameter 시드 데이터 — 세무조정 규칙엔진에서 사용하는 법률 변수.
/// DB 초기화 시 seedLegalParameters()를 호출하여 batch insert.
///
/// v2.0 추가: 대손충당금 설정율 한도 (법인세법 §34)
// ignore_for_file: unused_element_parameter
library;

/// 단일 LegalParameter 시드 항목
class _LPSeed {
  final String countryCode;
  final String domain;
  final String key;
  final String paramType;
  final String? value;
  final String? table;
  final String? formula;
  final String? inputVariables;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final String applicationBasis;
  final bool retroactive;
  final String? sourceLaw;
  final String? conditions;

  const _LPSeed({
    required this.countryCode,
    required this.domain,
    required this.key,
    required this.paramType,
    this.value,
    this.table,
    this.formula,
    this.inputVariables,
    required this.effectiveFrom,
    this.effectiveTo,
    required this.applicationBasis,
    this.retroactive = false,
    this.sourceLaw,
    this.conditions,
  });
}

/// 모든 LegalParameter 시드 목록
final List<_LPSeed> _listLegalParameterSeeds = [
  // --- 기존 세무조정 규칙 (v1.0) ---
  _LPSeed(
    countryCode: 'KR',
    domain: '법인세',
    key: '접대비_한도',
    paramType: 'TABLE',
    table: '{"기본한도":36000000,"매출1000억이하_률":0.003,"매출1000억초과_률":0.002}',
    effectiveFrom: DateTime(2019, 1, 1),
    applicationBasis: '사업연도',
    sourceLaw: '법인세법 제25조',
  ),
  _LPSeed(
    countryCode: 'KR',
    domain: '소득세',
    key: '금융소득_종합과세_기준금액',
    paramType: 'VALUE',
    value: '20000000',
    effectiveFrom: DateTime(2013, 1, 1),
    applicationBasis: '귀속연도',
    sourceLaw: '소득세법 제14조 제3항',
  ),

  // --- v2.0 추가: 대손충당금 ---
  _LPSeed(
    countryCode: 'KR',
    domain: '법인세',
    key: '대손충당금_설정율_한도',
    paramType: 'TABLE',
    table: '{"일반채권":0.01,"금융기관채권":0.02}',
    effectiveFrom: DateTime(2019, 1, 1),
    applicationBasis: '결산기말',
    sourceLaw: '법인세법 제34조',
    conditions: '채권잔액 × 설정율 한도 초과분 → 손금불산입',
  ),
  _LPSeed(
    countryCode: 'KR',
    domain: '법인세',
    key: '대손충당금_대손사유',
    paramType: 'VALUE',
    value: '90',
    effectiveFrom: DateTime(2019, 1, 1),
    applicationBasis: '결산기말',
    sourceLaw: '법인세법 시행령 제19조의2',
    conditions: '채권 회수 불능 인정 경과일수(일)',
  ),
];

/// DB batch insert용 시드 데이터 제공.
/// AppDatabase.seedLegalParameters() 에서 호출.
List<Map<String, dynamic>> getLegalParameterSeedMaps() {
  return _listLegalParameterSeeds.map((seed) {
    return {
      'countryCode': seed.countryCode,
      'domain': seed.domain,
      'key': seed.key,
      'paramType': seed.paramType,
      'value': seed.value,
      'table': seed.table,
      'formula': seed.formula,
      'inputVariables': seed.inputVariables,
      'effectiveFrom': seed.effectiveFrom.toIso8601String(),
      'effectiveTo': seed.effectiveTo?.toIso8601String(),
      'applicationBasis': seed.applicationBasis,
      'retroactive': seed.retroactive ? 1 : 0,
      'sourceLaw': seed.sourceLaw,
      'conditions': seed.conditions,
    };
  }).toList();
}
