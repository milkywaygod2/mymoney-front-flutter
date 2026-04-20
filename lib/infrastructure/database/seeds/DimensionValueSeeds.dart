/// DimensionValue 시드 데이터 — 5대 분류 기본 트리 + 정부회계 확장.
/// DB 초기화 시 seedDimensionValues()를 호출하여 batch insert.
///
/// Materialized Path 방식: code = 'ASSET.CURRENT.CASH' 형태.
/// 총 노드 수: 약 80개 (가계/기업 공용) + 정부회계 확장 약 10개.
library;

// --- 시드 데이터 레코드 ---

/// 단일 DimensionValue 시드 항목
class _Seed {
  final String type;
  final String code;
  final String name;
  final String? parentCode;
  final String entityType;
  final int sortOrder;

  const _Seed(this.type, this.code, this.name, this.parentCode, this.entityType, this.sortOrder);
}

// =============================================================================
// 1. EQUITY_TYPE (자기자본성) — 5대 분류 전체 트리
// =============================================================================

const List<_Seed> _kEquityTypeSeeds = [
  // --- ASSET (자산) ---
  _Seed('EQUITY_TYPE', 'ASSET', '자산', null, 'COMMON', 100),
  _Seed('EQUITY_TYPE', 'ASSET.CURRENT', '유동자산', 'ASSET', 'COMMON', 110),
  _Seed('EQUITY_TYPE', 'ASSET.CURRENT.CASH', '현금및현금성자산', 'ASSET.CURRENT', 'COMMON', 111),
  _Seed('EQUITY_TYPE', 'ASSET.CURRENT.SHORT_TERM_FINANCIAL', '단기금융자산', 'ASSET.CURRENT', 'COMMON', 112),
  _Seed('EQUITY_TYPE', 'ASSET.CURRENT.RECEIVABLE', '매출채권및미수금', 'ASSET.CURRENT', 'COMMON', 113),
  _Seed('EQUITY_TYPE', 'ASSET.CURRENT.PREPAID', '선급금및선급비용', 'ASSET.CURRENT', 'COMMON', 114),
  _Seed('EQUITY_TYPE', 'ASSET.CURRENT.INVENTORY', '재고자산', 'ASSET.CURRENT', 'COMMON', 115),
  _Seed('EQUITY_TYPE', 'ASSET.NON_CURRENT', '비유동자산', 'ASSET', 'COMMON', 120),
  _Seed('EQUITY_TYPE', 'ASSET.NON_CURRENT.INVESTMENT', '투자자산', 'ASSET.NON_CURRENT', 'COMMON', 121),
  _Seed('EQUITY_TYPE', 'ASSET.NON_CURRENT.TANGIBLE', '유형자산', 'ASSET.NON_CURRENT', 'COMMON', 122),
  _Seed('EQUITY_TYPE', 'ASSET.NON_CURRENT.INTANGIBLE', '무형자산', 'ASSET.NON_CURRENT', 'COMMON', 123),
  _Seed('EQUITY_TYPE', 'ASSET.NON_CURRENT.OTHER', '기타비유동자산', 'ASSET.NON_CURRENT', 'COMMON', 124),

  // --- LIABILITY (부채) ---
  _Seed('EQUITY_TYPE', 'LIABILITY', '부채', null, 'COMMON', 200),
  _Seed('EQUITY_TYPE', 'LIABILITY.CURRENT', '유동부채', 'LIABILITY', 'COMMON', 210),
  _Seed('EQUITY_TYPE', 'LIABILITY.CURRENT.PAYABLE', '미지급금및미지급비용', 'LIABILITY.CURRENT', 'COMMON', 211),
  _Seed('EQUITY_TYPE', 'LIABILITY.CURRENT.SHORT_TERM_BORROWING', '단기차입금', 'LIABILITY.CURRENT', 'COMMON', 212),
  _Seed('EQUITY_TYPE', 'LIABILITY.CURRENT.WITHHOLDING', '예수금', 'LIABILITY.CURRENT', 'COMMON', 213),
  _Seed('EQUITY_TYPE', 'LIABILITY.CURRENT.ADVANCE', '선수금', 'LIABILITY.CURRENT', 'COMMON', 214),
  _Seed('EQUITY_TYPE', 'LIABILITY.NON_CURRENT', '비유동부채', 'LIABILITY', 'COMMON', 220),
  _Seed('EQUITY_TYPE', 'LIABILITY.NON_CURRENT.LONG_TERM_BORROWING', '장기차입금', 'LIABILITY.NON_CURRENT', 'COMMON', 221),
  _Seed('EQUITY_TYPE', 'LIABILITY.NON_CURRENT.OTHER', '기타비유동부채', 'LIABILITY.NON_CURRENT', 'COMMON', 222),

  // --- EQUITY (자본) ---
  _Seed('EQUITY_TYPE', 'EQUITY', '자본', null, 'COMMON', 300),
  _Seed('EQUITY_TYPE', 'EQUITY.CAPITAL', '자본금', 'EQUITY', 'COMMON', 310),
  _Seed('EQUITY_TYPE', 'EQUITY.RETAINED', '이익잉여금', 'EQUITY', 'COMMON', 320),
  _Seed('EQUITY_TYPE', 'EQUITY.OTHER', '기타자본', 'EQUITY', 'COMMON', 330),
  // v2.0 OCI 핵심 5종 — 기타포괄손익누계액 (AOCI)
  _Seed('EQUITY_TYPE', 'EQUITY.OCI_ACCUMULATED', '기타포괄손익누계액', 'EQUITY', 'COMMON', 340),
  _Seed('EQUITY_TYPE', 'EQUITY.OCI_ACCUMULATED.FVOCI_VALUATION', 'FVOCI 평가손익', 'EQUITY.OCI_ACCUMULATED', 'COMMON', 341),
  _Seed('EQUITY_TYPE', 'EQUITY.OCI_ACCUMULATED.FOREIGN_CURRENCY_TRANSLATION', '해외사업환산손익', 'EQUITY.OCI_ACCUMULATED', 'COMMON', 342),
  _Seed('EQUITY_TYPE', 'EQUITY.OCI_ACCUMULATED.EQUITY_METHOD_CHANGES', '지분법자본변동', 'EQUITY.OCI_ACCUMULATED', 'COMMON', 343),
  _Seed('EQUITY_TYPE', 'EQUITY.OCI_ACCUMULATED.ACTUARIAL', '보험수리적손익', 'EQUITY.OCI_ACCUMULATED', 'COMMON', 344),
  _Seed('EQUITY_TYPE', 'EQUITY.OCI_ACCUMULATED.OTHER_OCI', '기타포괄손익(기타)', 'EQUITY.OCI_ACCUMULATED', 'COMMON', 345),

  // --- REVENUE (수익) ---
  _Seed('EQUITY_TYPE', 'REVENUE', '수익', null, 'COMMON', 400),
  _Seed('EQUITY_TYPE', 'REVENUE.OPERATING', '영업수익', 'REVENUE', 'COMMON', 410),
  _Seed('EQUITY_TYPE', 'REVENUE.FINANCIAL', '금융수익', 'REVENUE', 'COMMON', 420),
  _Seed('EQUITY_TYPE', 'REVENUE.INVESTMENT', '투자수익', 'REVENUE', 'COMMON', 430),
  _Seed('EQUITY_TYPE', 'REVENUE.OTHER', '기타수익', 'REVENUE', 'COMMON', 440),

  // --- EXPENSE (비용) ---
  _Seed('EQUITY_TYPE', 'EXPENSE', '비용', null, 'COMMON', 500),
  _Seed('EQUITY_TYPE', 'EXPENSE.LIVING', '생활비', 'EXPENSE', 'COMMON', 510),
  _Seed('EQUITY_TYPE', 'EXPENSE.LIVING.FOOD', '식비', 'EXPENSE.LIVING', 'COMMON', 511),
  _Seed('EQUITY_TYPE', 'EXPENSE.LIVING.TRANSPORT', '교통비', 'EXPENSE.LIVING', 'COMMON', 512),
  _Seed('EQUITY_TYPE', 'EXPENSE.LIVING.TELECOM', '통신비', 'EXPENSE.LIVING', 'COMMON', 513),
  _Seed('EQUITY_TYPE', 'EXPENSE.LIVING.HOUSING', '주거비', 'EXPENSE.LIVING', 'COMMON', 514),
  _Seed('EQUITY_TYPE', 'EXPENSE.LIVING.MEDICAL', '의료비', 'EXPENSE.LIVING', 'COMMON', 515),
  _Seed('EQUITY_TYPE', 'EXPENSE.LIVING.EDUCATION', '교육비', 'EXPENSE.LIVING', 'COMMON', 516),
  _Seed('EQUITY_TYPE', 'EXPENSE.LIVING.CLOTHING', '의류비', 'EXPENSE.LIVING', 'COMMON', 517),
  _Seed('EQUITY_TYPE', 'EXPENSE.LIVING.CULTURE', '문화여가비', 'EXPENSE.LIVING', 'COMMON', 518),
  _Seed('EQUITY_TYPE', 'EXPENSE.OPERATING', '영업비용', 'EXPENSE', 'COMMON', 520),
  _Seed('EQUITY_TYPE', 'EXPENSE.FINANCIAL', '금융비용', 'EXPENSE', 'COMMON', 530),
  _Seed('EQUITY_TYPE', 'EXPENSE.DEPRECIATION', '감가상각비', 'EXPENSE', 'COMMON', 540),
  _Seed('EQUITY_TYPE', 'EXPENSE.TAX', '세금과공과', 'EXPENSE', 'COMMON', 550),
  _Seed('EQUITY_TYPE', 'EXPENSE.OTHER', '기타비용', 'EXPENSE', 'COMMON', 560),
];

// =============================================================================
// 2. LIQUIDITY (유동성)
// =============================================================================

const List<_Seed> _kLiquiditySeeds = [
  _Seed('LIQUIDITY', 'CURRENT', '유동', null, 'COMMON', 10),
  _Seed('LIQUIDITY', 'NON_CURRENT', '비유동', null, 'COMMON', 20),
];

// =============================================================================
// 3. ASSET_TYPE (자산종류)
// =============================================================================

const List<_Seed> _kAssetTypeSeeds = [
  _Seed('ASSET_TYPE', 'CASH', '현금성자산', null, 'COMMON', 10),
  _Seed('ASSET_TYPE', 'SHORT_TERM_FINANCIAL', '단기금융자산', null, 'COMMON', 20),
  _Seed('ASSET_TYPE', 'RECEIVABLE', '매출채권', null, 'COMMON', 30),
  _Seed('ASSET_TYPE', 'PREPAID', '선급금', null, 'COMMON', 40),
  _Seed('ASSET_TYPE', 'INVENTORY', '재고자산', null, 'COMMON', 50),
  _Seed('ASSET_TYPE', 'INVESTMENT', '투자자산', null, 'COMMON', 60),
  _Seed('ASSET_TYPE', 'TANGIBLE', '유형자산', null, 'COMMON', 70),
  _Seed('ASSET_TYPE', 'INTANGIBLE', '무형자산', null, 'COMMON', 80),
  _Seed('ASSET_TYPE', 'OTHER', '기타자산', null, 'COMMON', 90),
];

// =============================================================================
// 4. ACTIVITY_TYPE (활동구분) — 가계/기업 공용
// =============================================================================

const List<_Seed> _kActivityTypeSeeds = [
  // 가계/기업 공용
  _Seed('ACTIVITY_TYPE', 'HOUSEHOLD', '가계활동', null, 'COMMON', 10),
  _Seed('ACTIVITY_TYPE', 'HOUSEHOLD.CONSUMPTION', '소비', 'HOUSEHOLD', 'COMMON', 11),
  _Seed('ACTIVITY_TYPE', 'HOUSEHOLD.SAVING', '저축', 'HOUSEHOLD', 'COMMON', 12),
  _Seed('ACTIVITY_TYPE', 'OPERATING', '영업활동', null, 'COMMON', 20),
  _Seed('ACTIVITY_TYPE', 'OPERATING.SALES', '매출관련', 'OPERATING', 'COMMON', 21),
  _Seed('ACTIVITY_TYPE', 'OPERATING.PURCHASE', '매입관련', 'OPERATING', 'COMMON', 22),
  _Seed('ACTIVITY_TYPE', 'INVESTING', '투자활동', null, 'COMMON', 30),
  _Seed('ACTIVITY_TYPE', 'INVESTING.TANGIBLE', '유형자산취득처분', 'INVESTING', 'COMMON', 31),
  _Seed('ACTIVITY_TYPE', 'INVESTING.FINANCIAL', '금융자산취득처분', 'INVESTING', 'COMMON', 32),
  _Seed('ACTIVITY_TYPE', 'FINANCING', '재무활동', null, 'COMMON', 40),
  _Seed('ACTIVITY_TYPE', 'FINANCING.BORROWING', '차입금', 'FINANCING', 'COMMON', 41),
  _Seed('ACTIVITY_TYPE', 'FINANCING.DIVIDEND', '배당금지급', 'FINANCING', 'COMMON', 42),
];

// =============================================================================
// 5. INCOME_TYPE (소득유형) — 한국 소득세법 8종
// =============================================================================

const List<_Seed> _kIncomeTypeSeeds = [
  _Seed('INCOME_TYPE', 'INTEREST', '이자소득', null, 'COMMON', 10),
  _Seed('INCOME_TYPE', 'INTEREST.COMPREHENSIVE', '종합과세', 'INTEREST', 'COMMON', 11),
  _Seed('INCOME_TYPE', 'INTEREST.SEPARATE', '분리과세', 'INTEREST', 'COMMON', 12),
  _Seed('INCOME_TYPE', 'DIVIDEND', '배당소득', null, 'COMMON', 20),
  _Seed('INCOME_TYPE', 'DIVIDEND.COMPREHENSIVE', '종합과세', 'DIVIDEND', 'COMMON', 21),
  _Seed('INCOME_TYPE', 'DIVIDEND.SEPARATE', '분리과세', 'DIVIDEND', 'COMMON', 22),
  _Seed('INCOME_TYPE', 'DIVIDEND.GROSSUP', '종합과세(Gross-up)', 'DIVIDEND', 'COMMON', 23),
  _Seed('INCOME_TYPE', 'BUSINESS', '사업소득', null, 'COMMON', 30),
  _Seed('INCOME_TYPE', 'EMPLOYMENT', '근로소득', null, 'COMMON', 40),
  _Seed('INCOME_TYPE', 'PENSION', '연금소득', null, 'COMMON', 50),
  _Seed('INCOME_TYPE', 'CAPITAL_GAINS', '양도소득', null, 'COMMON', 60),
  _Seed('INCOME_TYPE', 'RETIREMENT', '퇴직소득', null, 'COMMON', 70),
  _Seed('INCOME_TYPE', 'OTHER', '기타소득', null, 'COMMON', 80),
];

// =============================================================================
// 6. 정부회계 확장 (entity_type = 'GOVERNMENT')
// =============================================================================

const List<_Seed> _kGovernmentSeeds = [
  // 자기자본성: 자본 → 순자산 대체
  _Seed('EQUITY_TYPE', 'NET_ASSETS', '순자산', null, 'GOVERNMENT', 300),
  _Seed('EQUITY_TYPE', 'NET_ASSETS.ACCUMULATED', '순자산변동누계', 'NET_ASSETS', 'GOVERNMENT', 310),

  // 활동구분: 경상/자본/세입/세출
  _Seed('ACTIVITY_TYPE', 'RECURRENT', '경상적지출', null, 'GOVERNMENT', 10),
  _Seed('ACTIVITY_TYPE', 'RECURRENT.PERSONNEL', '인건비', 'RECURRENT', 'GOVERNMENT', 11),
  _Seed('ACTIVITY_TYPE', 'RECURRENT.GOODS', '물건비', 'RECURRENT', 'GOVERNMENT', 12),
  _Seed('ACTIVITY_TYPE', 'RECURRENT.TRANSFER', '이전경비', 'RECURRENT', 'GOVERNMENT', 13),
  _Seed('ACTIVITY_TYPE', 'CAPITAL_EXPENDITURE', '자본적지출', null, 'GOVERNMENT', 20),
  _Seed('ACTIVITY_TYPE', 'CAPITAL_EXPENDITURE.FACILITY', '시설비', 'CAPITAL_EXPENDITURE', 'GOVERNMENT', 21),
  _Seed('ACTIVITY_TYPE', 'REVENUE_GOV', '세입', null, 'GOVERNMENT', 30),
  _Seed('ACTIVITY_TYPE', 'REVENUE_GOV.TAX', '세수입', 'REVENUE_GOV', 'GOVERNMENT', 31),
  _Seed('ACTIVITY_TYPE', 'REVENUE_GOV.NON_TAX', '세외수입', 'REVENUE_GOV', 'GOVERNMENT', 32),
  _Seed('ACTIVITY_TYPE', 'REVENUE_GOV.SUBSIDY', '보조금', 'REVENUE_GOV', 'GOVERNMENT', 33),
];

// =============================================================================
// 공개 API — DB 초기화 시 호출
// =============================================================================

/// 전체 시드 데이터 목록 (DB batch insert용)
///
/// 반환 형식: List<Map<String, dynamic>> — Drift의 batch insert와 호환.
/// 각 Map의 키: dimensionType, code, name, parentCode, entityType, sortOrder, isSystem
List<Map<String, dynamic>> getAllDimensionValueSeeds() {
  final List<_Seed> listAllSeeds = [
    ..._kEquityTypeSeeds,
    ..._kLiquiditySeeds,
    ..._kAssetTypeSeeds,
    ..._kActivityTypeSeeds,
    ..._kIncomeTypeSeeds,
    ..._kGovernmentSeeds,
  ];

  return listAllSeeds.map((seed) {
    return {
      'dimensionType': seed.type,
      'code': seed.code,
      'name': seed.name,
      'parentCode': seed.parentCode,
      'entityType': seed.entityType,
      'sortOrder': seed.sortOrder,
      'isSystem': true,
    };
  }).toList();
}

/// 특정 entity_type의 시드만 필터 (가계/기업: 'COMMON', 정부: 'GOVERNMENT')
List<Map<String, dynamic>> getDimensionValueSeedsByEntityType(String entityType) {
  return getAllDimensionValueSeeds()
      .where((map) => map['entityType'] == entityType || map['entityType'] == 'COMMON')
      .toList();
}

/// 시드 데이터 통계 (검증용)
Map<String, int> getSeedStatistics() {
  final listAll = getAllDimensionValueSeeds();
  final Map<String, int> mapStats = {};
  for (final map in listAll) {
    final String type = map['dimensionType'] as String;
    mapStats[type] = (mapStats[type] ?? 0) + 1;
  }
  mapStats['TOTAL'] = listAll.length;
  return mapStats;
}
