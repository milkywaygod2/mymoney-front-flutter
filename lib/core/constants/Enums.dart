/// 계정 성격 5대 분류
/// 재무상태표(B/S)와 손익계산서(P/L)의 위치를 결정하며,
/// 차변/대변 정상 방향도 이 값에 의해 결정됨
enum AccountNature {
  asset,      // 자산
  liability,  // 부채
  equity,     // 자본
  revenue,    // 수익
  expense,    // 비용
}

/// 전표 라인 유형 — 복식부기의 양 측면
enum EntryType {
  debit,   // 차변
  credit,  // 대변
}

/// 거래 상태 — Draft→Posted→Voided 단방향 전이
enum TransactionStatus {
  draft,    // 임시 — OCR 자동 생성 시 기본값, 수정 가능
  posted,   // 확정 — 불변조건(INV-T1~T7) 검증 완료, 수정 불가
  voided,   // 무효 — 역분개로 무효 처리됨
}

/// 거래 원천 — 거래 데이터의 입력 경로
enum TransactionSource {
  manual,           // 수동 입력
  ocr,              // OCR 영수증 인식
  cardApi,          // 카드사 API 연동
  csvImport,        // CSV/Excel 임포트
  ntsImport,        // 국세청(NTS) 데이터 임포트
  systemSettlement,       // 결산 자동 전표 (외환평가, 감가상각 등)
  systemAuditAdjustment,  // 감사 수정분개 (v2.0)
}

/// 손금/익금 판정 — 세무조정 시 사용
/// 기본값은 undetermined(미판정), 자동/수동 판정 후 변경
enum Deductibility {
  undetermined,       // 미판정
  deductible,         // 손금산입
  deductibleLimited,  // 손금산입(한도) — 접대비 등 한도 초과분 불산입
  nonDeductible,      // 손금불산입 — 벌과금 등
  incomeInclusion,    // 익금산입 — 세무상 익금에 산입
  incomeExclusion,    // 익금불산입 — 세무상 익금에서 제외
  bookRespected,      // 장부존중 — 회계=세무 일치 (별도 조정 불필요)
}

/// 동기화 상태 — Outbox 패턴의 각 레코드 상태
enum SyncStatus {
  synced,     // 동기화 완료
  pending,    // 대기 — 서버 전송 전
  sending,    // 전송 중
  conflict,   // 충돌 — 서버 409 응답
  failed,     // 실패 — 재시도 한도 초과
}

/// 분류축 유형 — 3-Tier 프레임워크의 T1 구조축 + T2 제도축
/// Perspective(관점) 필터에서 DimensionType별로 값 집합을 지정
enum DimensionType {
  equityType,    // 자기자본성 (자산/부채/자본 하위 세분류)
  liquidity,     // 유동성 (유동/비유동, 세부유동성은 하위 레벨)
  assetType,     // 자산종류 (현금성/금융/유형/무형)
  activityType,  // 활동구분 (가계/영업/투자/재무, 정부: 경상/자본/세입/세출)
  incomeType,    // 소득유형 (이자/배당/사업/근로/연금/양도/퇴직/기타)
}

/// Perspective 권한 수준 — Lens Switcher에서 잠금 아이콘 표시에 사용
enum PermissionLevel {
  full,        // 전체 권한 (읽기+쓰기)
  readOnly,    // 읽기 전용 (데이터 필터링만, 수정 불가)
  restricted,  // 제한 (특정 항목만 표시)
}

/// 기록 방향 — 정부회계 모드에서 차변/대변 해석 반전
enum RecordingDirection {
  normal,    // 기업/가계 회계 (자산 증가 = 차변)
  inverted,  // 정부회계 (예산 수령 = 대변이 "증가"로 해석)
}

// ===== v2.0 추가 열거형 =====

/// 기간 비교 유형 — 대시보드/보고서에서 4종 증감 동시 표시 (v2.0)
enum ComparisonType {
  mom,         // 전월 대비 (Month-over-Month)
  qoq,         // 전분기 대비 (Quarter-over-Quarter)
  yoy,         // 전년동기 대비 (Year-over-Year)
  yoyAnnual,   // 전년말 대비 (Year-over-Year Annual)
}

/// 재무비율 카테고리 — FinancialRatioSnapshots.category (v2.0)
enum RatioCategory {
  profitability,  // 수익성 (ROA, ROE)
  stability,      // 안정성 (유동비율, 부채비율, 이자보상비율, 자본유보율)
  activity,       // 활동성 (총자산회전율, 매출채권회전율, 채권회수기간, 자기자본회전율)
  growth,         // 성장성 (순자산증가율, 저축율)
}

/// 재무비율 배율 상수 — 33.33% → 3333
const int kRatioMultiplier = 10000;

/// CF 보고서 — Account가 현금흐름표에서 어디에 분류되는지
enum CashFlowCategory {
  cash,                // 현금 및 현금성자산 (기초/기말 현금)
  receivablePayable,   // 채권/채무 (운전자본 변동 또는 투자/재무)
  revenueExpense,      // 수익/비용 (비현금항목 가감)
}

/// Account — 거래처 입력 강제 수준 (COA Col21 기반)
enum VendorRequirement {
  notSet,    // 미설정 (집계/상위 노드)
  optional,  // 선택 (거래처 입력 권장)
  required,  // 필수 (거래처 미입력 시 저장 차단)
}

/// CF 코드 — CashFlowCodes 테이블의 indexType
enum CfAccountIndex {
  aggregate,  // 하위 합산 수식: SUM(children)
  actual,     // 직접 입력/계산: Account.cashFlowCategory 기반
  automatic,  // 타 보고서 연동: 예) C110000 = PL 당기순이익
}

/// OCI 5항목 — 기타포괄손익 분류 (CE 행 항목)
enum OciCategory {
  fvociValuation,              // FVOCI 금융자산 평가손익
  foreignCurrencyTranslation,  // 해외사업환산손익
  equityMethodChanges,         // 지분법자본변동
  actuarialGainsLosses,        // 보험수리적손익 (확정급여 재측정)
  otherOci,                    // 기타 (현금흐름위험회피 등, P2 세분 흡수)
}

/// CE — 자본변동표 행 유형
enum EquityChangeType {
  beginningBalance,   // 기초잔액
  netIncome,          // 당기순이익
  ociChange,          // OCI 변동 (5항목)
  dividends,          // 배당
  treasuryStock,      // 자사주 거래
  other,              // 기타 자본거래
  endingBalance,      // 기말잔액
}

/// 금액 배율 상수 — int 저장 시 소수점 표현을 위한 배율
/// 예: 1 USD = 1,350.123456 KRW → 1350123456 (배율 1,000,000)
const int kExchangeRateMultiplier = 1000000;

/// 지분율 배율 — 100% = 10000, 33.33% = 3333
const int kShareRatioMultiplier = 10000;

/// 재고 평가 방법 — K-IFRS 1002호 기준 (P3 예약)
enum InventoryValuationMethod {
  fifo,                     // 선입선출법
  weightedAverage,          // 가중평균법 (기간 단위)
  movingAverage,            // 이동평균법 (거래 단위)
  specificIdentification,   // 개별법
  standardCost,             // 표준원가법
}

/// 특수관계자 5단계 분류 (K-IFRS 1024 / 공정거래법) — v2.0
enum RelatedPartyType {
  parent,       // 지배기업
  subsidiary,   // 종속기업 (과반수 지배)
  associate,    // 관계기업 (20~50% 영향력)
  affiliate,    // 기타특수관계자 (공정거래법 계열회사)
  otherRelated, // 기타(*) (비영리재단, 공익법인)
}

/// 법인/개인 성격 분류 — v2.0
enum EntityType {
  individual,         // 개인
  domesticCorporate,  // 국내 영리법인
  foreignCorporate,   // 해외 영리법인
  nonprofit,          // 비영리단체/재단
  government,         // 정부/공공기관
  affiliate,          // 관계사/계열사
}

/// 역분개 유형 구분 — v2.0
enum ReversalType {
  reversalOrigin, // 역분개대상 (원본 전표, 향후 취소 예정)
  reversalEntry,  // 역분개처리 (취소 전표 본체)
}
