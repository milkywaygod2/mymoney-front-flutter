# CW_ANALYSIS_Arjun.md — 특수관계자 주석패키지 전체 시트 분석

> 분석 대상: `★(NBP)특수관계자 주석패키지_2018.4Q_v4.xlsx` (NBP=네이버비즈니스플랫폼)
> 분석자: Arjun-2 → Arjun-3 (Opus) 컬럼 전수 대조 보강
> 기준: CW_ARCHITECTURE.md 대비 커버/미커버 판정
> 일자: 2026-04-19 (보강: 2026-04-19)
> 시트 수: 11개 전수 문서화
> **보강 방법**: 엑셀 실제 Read (openpyxl) → 헤더행+샘플 대조 → 누락 컬럼 보정 → CW 매핑

---

## 시트 1: [서식]

**기본 정보**: ~122행 × 다중 섹션 (단일 테이블이 아닌 재무제표 주석 출력 서식)

> **[보강]** 기존 문서는 "18열 단일 테이블"로 기술했으나, 실제 Read 결과 4개 섹션으로 구성된 K-IFRS 주석 서식. 당기/전기 좌우 병렬 구조.

### 섹션 구조 (실제 확인)

**섹션 (1)~(2): 지분 현황 + 기타특수관계자** (R9~R20)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| 1 | 구분 | 종속기업/관계기업/기타특수관계자/기타(*) | **GAP**: Counterparty.relatedPartyType |
| 2 | 회사명 | 법인명 | Counterparty.name |
| 3 | 지분율(%) 당기말 | 당기말 유효지분율 | **GAP**: Counterparty에 지분율 필드 없음 |
| 4 | 지분율(%) 전기말 | 전기말 유효지분율 (비교) | **GAP**: 동일 |

**섹션 (4): 수익비용** (R22~R65, 당기/전기 좌우 병렬 18열)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| 1 | 구분 | 지배기업/종속기업및관계기업/기타/기타(*) | **GAP**: relatedPartyType |
| 2 | 회사명 | 법인명 | Counterparty.name |
| 3 | 매출 | 영업수익 등 — 매출 | ReportQueryService 집계 |
| 4 | 기타수익 | 영업수익 등 — 기타수익 | ReportQueryService 집계 |
| 5 | 지급수수료 | 영업비용 등 | ReportQueryService 집계 |
| 6 | 지급임차료 | 영업비용 등 | ReportQueryService 집계 |
| 7 | 기타비용 | 영업비용 등 | ReportQueryService 집계 |
| 8~11 | (빈 열/구분) | 당기/전기 구분용 | — |
| 12~18 | (전기 반복) | 동일 구조 전기 데이터 | FiscalPeriods 기간 쿼리 |

**섹션 (5): 채권채무** (R68~R108, 당기/전기 좌우 병렬 17열)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| 1 | 구분 | 특수관계자 분류 | **GAP**: relatedPartyType |
| 2 | 회사명 | 법인명 | Counterparty.name |
| 3 | 매출채권 | 채권 | GenerateBalanceSheet |
| 4 | 미수금 | 채권 | GenerateBalanceSheet |
| 5 | 임차보증금 | 채권 | GenerateBalanceSheet |
| 6 | 미지급금 | 채무 | GenerateBalanceSheet |
| 7~11 | (빈 열/구분) | 당기/전기 구분용 | — |
| 12~17 | (전기 반복) | 동일 구조 전기 데이터 | FiscalPeriods 기간 쿼리 |

**섹션 (6): 고정자산 이관/취득** (R110~R122, 5열)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| 1 | 구분 | 특수관계자 분류 | **GAP**: relatedPartyType |
| 2 | 회사명 | 법인명 | Counterparty.name |
| 3 | 이관 | 이관 금액 (천원) | JEL 차대변 집계 |
| 4 | 취득 | 취득 금액 (천원) | JEL 차대변 집계 |

### 도메인 개념

- 재무제표 주석 "25. 특수관계자 거래" 출력 서식
- 특수관계자 5단계 분류 체계:
  - `지배기업`: 100% 지배주주 (NAVER → NBP 기준 상위)
  - `종속기업`: 과반수 지배 (50% 초과 실질 지배)
  - `관계기업`: 중요한 영향력 (20~50% 지분)
  - `기타특수관계자`: 공정거래법상 계열회사
  - `기타(*)`: 비영리재단, 공익법인 등 (지분율 0)
- 금액 단위: 천원 (원 단위 원장 ÷ 1000)

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 특수관계자 5단계 분류 | **GAP** | `Counterparty.isRelatedParty: bool` 단일 필드만 존재 |
| 수익/비용 집계 주석 | 커버 | ReportQueryService로 집계 가능 |
| 채권/채무 잔액 주석 | 커버 | GenerateBalanceSheet 대응 가능 |
| 유효지분율 | **GAP** | Counterparty에 지분율 필드 없음 |
| 금액 단위 변환(천원) | 커버 | UI 레이어에서 처리 가능 |
| 당기/전기 비교 구조 | 커버 | FiscalPeriods 테이블 기반 기간 비교 |
| 고정자산 이관/취득 | 커버 | JEL 복식부기 기록 |

### 미커버 항목

- `Counterparty.relatedPartyType` 열거형 필요: `parent | subsidiary | associate | affiliate | other_related`
- 지분율 보관 필드 없음 (가계부 MVP 스킵 가능, 기업 확장 시 필수)

---

## 시트 2: [특관자주석]

**기본 정보**: 753행 × 18열

> **[보강]** 기존 문서는 19열로 기술했으나 실제 18열. 3개 섹션(수익비용/채권채무/고정자산)이 세로로 이어진 구조.

### 컬럼 구조 (실제 확인 — 전체 18열, 3개 섹션 공통)

**섹션 (1) 수익/비용** (R8~R254)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| A | 주석기재라인(TRUE) | TRUE/FALSE — 주석 출력 포함 여부 | **GAP**: Account/Perspective 레벨 플래그 없음 |
| B | 해당 회사 명 | 특수관계자 법인명 | Counterparty.name |
| C | 구분 | 지배기업/종속회사/관계회사/기타 | **GAP**: relatedPartyType |
| D | 기준일 | 2018-12-31 (회계연도 말) | FiscalPeriods.endDate |
| 1 | 1)용역매출 | 수익 | ReportQueryService 집계 |
| 2 | 2)재고자산매출 | 수익 | ReportQueryService 집계 |
| 3 | 3)이자수익 | 수익 | ReportQueryService 집계 |
| 4 | 4)기타(수익) | 수익 | ReportQueryService 집계 |
| 5 | 6)수수료비용 | 비용 | ReportQueryService 집계 |
| 6 | 7)수수료비용(매출차감) | 비용(순액) | **GAP**: Account.isRevenueDeduction |
| 7 | 8)지급임차료 | 비용 | ReportQueryService 집계 |
| 8 | 9)기타(비용) | 비용 | ReportQueryService 집계 |
| 9 | 10)재고자산매입 | 비용 | ReportQueryService 집계 |
| 10~13 | 매출/기타수익/지급수수료/지급임차료/기타비용 | 서식 시트용 요약 컬럼 | — |

**섹션 (2) 채권/채무** (R256~R505)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| A | 주석기재라인(TRUE) | TRUE/FALSE | **GAP** |
| B | 해당 회사 명 | 법인명 | Counterparty.name |
| C | 약어 | 법인 약어 코드 | **GAP**: Counterparty.legalCode |
| D | 기준일 | 2018-12-31 | FiscalPeriods.endDate |
| 1~5 | 1)매출채권 ~ 5)임차보증금 | 채권 5종 | GenerateBalanceSheet |
| 6~9 | 6)미지급금 ~ 9)기타채무 | 채무 4종 | GenerateBalanceSheet |
| 10~13 | 매출채권/미수금/임차보증금/미지급금 | 서식 시트용 요약 | — |

**섹션 (3) 고정자산 이관/취득** (R506~R753)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| A | 주석기재라인(TRUE) | TRUE/FALSE | **GAP** |
| B | 해당 회사 명 | 법인명 | Counterparty.name |
| C | 약어 | 법인 약어 코드 | **GAP** |
| D | 기준일 | 2018-12-31 | FiscalPeriods.endDate |
| 1 | 미수금 | 이관/처분 대금 미수 | GenerateBalanceSheet |
| 2 | 1.유형자산 | 유형자산 이관/취득 | JEL 집계 |
| 3 | 2.투자부동산 | 투자부동산 이관/취득 | JEL 집계 |
| 4 | 3.무형자산 | 무형자산 이관/취득 | JEL 집계 |

### 도메인 개념

- 주석 출력의 핵심 필터: `주석기재라인 = TRUE`인 행만 재무제표 주석에 포함
- 당기/전기 비교 표시: K-IFRS 1024호 요구 (이전 회계기간 비교 공시)
- `관계구분` = 서식 시트의 5단계 분류와 동일 코드 체계
- 법인별/거래처별/항목별 3차원 집계
- **[보강]** 투자부동산(2.투자부동산) 컬럼 발견 — 기존 문서 누락

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 당기/전기 비교 | 커버 | FiscalPeriods.type 기반 기간 쿼리 가능 |
| 주석 출력 필터링 | **GAP** | `Account.isExcludedFromReport` 플래그 없음 |
| 관계구분 5단계 | **GAP** | `relatedPartyType` 없음 (시트1과 동일 이슈) |
| 거래처-법인 N:N 집계 | 커버 | ReportQueryService JEL 집계 가능 |
| 비교기간 자동 산출 | 커버 | FiscalPeriods 테이블 이전 기간 조회 |
| 투자부동산 계정 | 커버 | Account.dimensionPath 확장으로 대응 |

### 미커버 항목

- `주석기재라인(TRUE/FALSE)` 로직: Account 또는 Perspective 레벨에서 "주석 포함/제외" 플래그 필요
- `Counterparty.relatedPartyType` (시트 1과 동일)

---

## 시트 3: [피벗]

**기본 정보**: 168행 × 37열

> **[보강]** 실제 확인 결과 3개 피벗 테이블이 좌우 병렬 배치. 헤더 구조는 R3(섹션명) + R5(합계헤더) + R6(대표계정 컬럼명).

### 컬럼 구조 (실제 확인 — R6 헤더 기준, 37열)

**피벗A: 수익비용** (열 1~17)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| 1 | (구분) | 특수관계자 분류 (기타(*)/기타/관계회사 등) | **GAP**: relatedPartyType |
| 2 | (법인코드) | N/B/I/L/E 코드 | **GAP**: Counterparty.legalCode |
| 3 | 합계:잔액(원화) | 법인별 수익비용 합계 | ReportQueryService |
| 4 | 법인명 | 법인명 | Counterparty.name |
| 5 | 01)용역매출 | 대표계정별 합계 | ReportQueryService |
| 6 | 02)재고자산매출 | | ReportQueryService |
| 7 | 03)이자수익 | | ReportQueryService |
| 8 | 04)기타(수익) | | ReportQueryService |
| 9 | 06)수수료비용 | | ReportQueryService |
| 10 | 07)수수료비용(매출차감) | | **GAP**: isRevenueDeduction |
| 11 | 08)지급임차료 | | ReportQueryService |
| 12 | 09)기타(비용) | | ReportQueryService |
| 13 | 10)재고자산매입 | | ReportQueryService |
| 14 | 대지급 | 대지급 금액 | **GAP**: 대지급 범주 필터 없음 |
| 15 | 제외 | 제외 대상 금액 | **GAP**: isExcludedFromReport |
| 16~17 | (빈 열) | 구분용 | — |

**피벗B: 채권채무** (열 18~31)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| 18 | 합계:잔액(원화) | 법인별 채권채무 합계 | GenerateBalanceSheet |
| 19 | 법인명 | | Counterparty.name |
| 20 | 01)매출채권 | | GenerateBalanceSheet |
| 21 | 02)미수금 | | GenerateBalanceSheet |
| 22 | 03)대여금 | | GenerateBalanceSheet |
| 23 | 04)기타채권 | | GenerateBalanceSheet |
| 24 | 05)임차보증금 | | GenerateBalanceSheet |
| 25 | 06)미지급금 | | GenerateBalanceSheet |
| 26 | 07)임대보증금 | | GenerateBalanceSheet |
| 27 | 08)차입금 | | GenerateBalanceSheet |
| 28 | 09)기타채무 | | GenerateBalanceSheet |
| 29 | 제외 | 제외 대상 금액 | **GAP** |
| 30~31 | (빈 열) | 구분용 | — |

**피벗C: 고정자산 이관/처분** (열 32~37)

| # | 컬럼명 | 내용 | CW 매핑 |
|---|--------|------|---------|
| 32 | 합계:잔액(원화) | 고정자산 합계 | JEL 집계 |
| 33 | 행 레이블 | 법인명 | Counterparty.name |
| 34 | 02)미수금 | 이관/처분 미수 | JEL 집계 |
| 35 | 1.유형자산 | 유형자산 이관 | JEL 집계 |
| 36 | 3.무형자산 | 무형자산 이관 | JEL 집계 |
| 37 | 제외 | 제외 대상 | **GAP** |

### 도메인 개념

- 3개 피벗 테이블이 하나의 시트에 병렬 배치
- 법인코드 체계: `N` = NAVER 직접 계열, `B` = 비즈플랫폼, `I` = 인터넷계열, `L` = LINE계열, `E` = 외부 관계회사
- 피벗 목적: 특관자 주석 초안 자동 생성 → 담당자 검토 후 확정
- **[보강]** `대지급` 및 `제외` 컬럼 발견 — 대지급은 별도 범주, 제외는 주석 대상 외 금액
- 당기/전기 비교 열: 증감액, 증감율 자동 계산

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 법인별 집계 | 커버 | Owners + AccountOwnerShares 구조 |
| 대표계정 집계 | 커버 | Account.dimensionPath 기반 집계 |
| 법인코드 체계 | **GAP** | Counterparty.legalCode (N/B/I/L/E) 없음 |
| 3개 피벗 자동 산출 | 커버(일부) | ReportQueryService 확장으로 구현 가능 |
| 증감율 계산 | 커버 | UI 레이어에서 처리 가능 |
| 대지급 범주 분리 | **GAP** | Tag/DimensionValues로 대체 가능하나 명시 범주 없음 |
| 제외 컬럼 필터링 | **GAP** | `Account.isExcludedFromReport` 없음 |

### 미커버 항목

- `Counterparty.legalCode`: 법인코드 분류 체계 (N/B/I/L/E) 없음
  - 가계부에서는 식별자(주민번호/사업자번호) 체계로 대체 가능

---

## 시트 4: [수익비용]

**기본 정보**: 162,865행 × **46열** (R3 헤더행 기준)

> **[보강]** 기존 문서는 47열로 기술했으나 실제 R3 헤더 Read 결과 **46열**. 컬럼명도 다수 보정 — `라인적요`(기존 누락), `부서/부서코드/원가구분`(기존 `귀속구분` 표현과 다름), `출처`(기존 누락), `담당자`(기존 `기안자`와 별개 컬럼).

### 컬럼 구조 (실제 확인 — R3 헤더행 전수, 46열)

| # | 컬럼명 (실제) | 설명 | CW 매핑 |
|---|--------------|------|---------|
| 1 | 대표계정 | 주석 분류 코드 (01)용역매출 ~ 10)재고자산매입) | Account.dimensionPath 계층 집계 |
| 2 | 잔액(원화) | 기간 합산 원화 금액 | ReportQueryService |
| 3 | 법인명 | 거래처 법인명 (특수관계자) | Counterparty.name |
| 4 | 기간 | 2018-01 ~ 2018-12 (월별) | FiscalPeriods |
| 5 | 법인 | 보고법인 코드 (NAVER 회계장부) | Owners |
| 6 | 사업장 | 보고법인 사업장명 | **GAP**: Owner.businessUnit 없음 |
| 7 | 전표일자 | 거래 발생일 | Transactions.date |
| 8 | 계정명 | 세부 계정과목명 (DA광고매출 등) | Account.name |
| 9 | 계정코드 | Materialized Path (4001010100 등) | Account.dimensionPath |
| 10 | 거래처 | 거래처명 | Transactions.counterpartyName |
| 11 | 거래처코드 | N10743227 형식 | Counterparty.identifier |
| 12 | 사업자번호 | 사업자등록번호 | Counterparty.identifier (businessRegistration) |
| 13 | 전표번호 | NAVER00-180125-000009-AD 형식 | **GAP**: Transactions.referenceNo 없음 |
| 14 | 통화(장부통화) | KRW/USD/JPY 등 | JEL.baseCurrency |
| 15 | 차변(장부통화) | 차변 금액 (원화 환산) | JEL.baseAmount (DEBIT) |
| 16 | 대변(장부통화) | 대변 금액 (원화 환산) | JEL.baseAmount (CREDIT) |
| 17 | 잔액(장부통화) | 차대변 차감 잔액 | 계산 필드 |
| 18 | 환율(전표통화) | 전표 원본 통화 환율 | JEL.exchangeRateAtTrade |
| 19 | 통화(전표통화) | 전표 원본 통화 코드 | JEL.originalCurrency |
| 20 | 차변(전표통화) | 차변 금액 (원본 통화) | JEL.originalAmount (DEBIT) |
| 21 | 대변(전표통화) | 대변 금액 (원본 통화) | JEL.originalAmount (CREDIT) |
| 22 | 잔액(전표통화) | 잔액 (원본 통화) | 계산 필드 |
| 23 | **라인적요** | 전표 라인별 적요/메모 | JEL.memo |
| 24 | **부서** | 부서명 (N/A 등) | **GAP**: Owner 하위 조직 구조 없음 |
| 25 | **부서코드** | 부서 코드 (0000000 등) | **GAP** |
| 26 | **원가구분** | 원가 배부 구분 | **GAP**: DimensionValues 1단계 매핑 가능 |
| 27 | 서비스 | 서비스명 ([DA]네이버광고_PC 등) | Tag 또는 DimensionValues |
| 28 | 서비스코드 | 서비스 분류 코드 (N2175 등) | Tag 또는 DimensionValues |
| 29 | **출처** | 시스템 출처 (배너광고시스템 등) | Transactions.source |
| 30 | 범주 | 거래 범주 (DA위약금매출 등) | Tag |
| 31 | **담당자** | 전표 담당자 ID | **GAP**: 가계부 단일 사용자 |
| 32 | 승인자 | 최종 승인자 ID | **GAP**: 가계부 단일 사용자 |
| 33 | 기안자 | 전표 기안자 ID | **GAP**: 가계부 단일 사용자 |
| 34 | 원기안번호 | 원본 기안 번호 (역분개 역참조) | **GAP**: Transactions.referenceNo |
| 35 | LEGACY NO | 구시스템 전표번호 | **GAP**: 외부 참조번호 |
| 36 | 예산번호 | 연계 예산 번호 | **GAP**: 가계부 MVP 불필요 |
| 37 | 전표상태 | 승인 / 승인-역분개 | TransactionStatus.POSTED/VOIDED |
| 38 | 역분개여부 | Y/N | Transactions.voidedBy (간접) |
| 39 | 역분개유형 | (빈 값 — 수익비용에선 미사용) | **GAP**: Transaction.reversalType |
| 40 | 생성일자 | 시스템 생성 일자 | Transactions.createdAt |
| 41 | 증빙일자 | 증빙 서류 날짜 | **GAP**: Transactions.evidenceDate 없음 |
| 42 | 전표라인번호 | 동일 전표 내 라인 순번 (171483971 등) | JEL.id (시스템ID로 대체) |
| 43 | **귀속구분1** | 1차 원가 귀속 | JEL.activityTypeOverride (부분 매핑) |
| 44 | **귀속구분2** | 2차 원가 귀속 | **GAP**: DimensionValues 2단계 없음 |
| 45 | **사내계좌번호** | 내부 계좌 (Cost Center) | **GAP**: 가계부 MVP 불필요 |
| 46 | **전표승인일자** | 승인 처리 일자 | **GAP**: Transactions.approvedAt 없음 |

### 도메인 개념

- 복식부기 이중통화 원장: 장부통화(KRW) + 전표통화(외화) 쌍 기록
- 전표상태 2종: `승인`(정상) / `승인-역분개`(역분개처리된 전표)
- 역분개 2종:
  - `역분개대상`: 원본 전표 (향후 취소될 예정)
  - `역분개처리`: 취소 전표 본체 (역분개대상을 상쇄)
- 원기안번호: 역분개 시 원본 전표 역참조용
- **[보강]** `라인적요`: 전표 라인별 상세 적요 (JEL.memo에 매핑)
- **[보강]** `부서/부서코드`: 기존 `귀속구분1/2`와 별개 — 부서는 조직 구조, 귀속구분은 원가 배부 기준
- **[보강]** `출처`: 시스템 출처명 (배너광고시스템, 그룹웨어시스템 등) — Transactions.source와 의미 유사하나 값 체계 다름
- **[보강]** `담당자`: 기안자/승인자와 별개의 제3자 (전표 실행 담당)
- 전표번호 체계: `[법인코드][연도]-[날짜]-[시퀀스]-[전표유형]`

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 복식부기 차대변 | 커버 | JEL.entryType + baseAmount |
| 이중통화 (장부+전표) | 커버 | JEL.originalAmount/baseCurrency/originalCurrency |
| 역분개 (voidedBy) | 커버 | VoidTransaction + Transactions.voidedBy |
| 역분개유형 구분 | **GAP** | `Transaction.reversalType` 없음 |
| 전표번호(외부 참조) | **GAP** | `Transactions.referenceNo` 없음 |
| 라인적요 | 커버 | JEL.memo |
| 부서/부서코드 | **GAP** | Owner 하위 조직 구조 없음 (가계부 불필요) |
| 원가구분 | 부분커버 | DimensionValues.activityTypeOverride 1단계만 |
| 귀속구분1/2 | 부분커버 | activityTypeOverride 1단계만 |
| 출처 | 커버 | Transactions.source (값 체계 다름) |
| 결재선 (담당자/기안자/승인자) | **GAP** | 가계부 단일 사용자 구조 |
| 전표라인번호 | 커버 | JEL.id (lineOrder 없음, id로 대체) |
| 전표상태 | 커버 | TransactionStatus.POSTED/VOIDED |
| 증빙일자 | **GAP** | Transactions.evidenceDate 없음 |
| 전표승인일자 | **GAP** | Transactions.approvedAt 없음 |

### 미커버 항목

- `Transaction.reversalType`: 역분개대상(REVERSAL_ORIGIN) / 역분개처리(REVERSAL_ENTRY) 구분
- `Transactions.referenceNo`: 외부 전표번호/카드승인번호 저장용 (nullable)
- 귀속구분2: 2단계 원가귀속 (DimensionValues 1개 추가 또는 Tag로 대체 가능)
- **[보강]** 증빙일자/전표승인일자: 가계부 MVP에서는 date 하나로 충분하나, 기업 확장 시 필요

---

## 시트 5: [채권채무]

**기본 정보**: 22,754행 × **42열** (R2 헤더행 기준)

> **[보강]** 실제 R2 헤더 Read 확인. 42열 정확. 기존 누락 컬럼 3개 발견: `입금번호`, `원천라인번호`, `계정과목`(기존 `계정명`으로 표기).

### 컬럼 구조 (실제 확인 — R2 헤더행 전수, 42열)

| # | 컬럼명 (실제) | 설명 | CW 매핑 |
|---|--------------|------|---------|
| 1 | 대표계정 | 01)매출채권 ~ 09)기타채무/제외 | Account.dimensionPath |
| 2 | 잔액(원화) | 원화 잔액 합계 | ReportQueryService |
| 3 | 법인명 | 거래처 법인명 | Counterparty.name |
| 4 | 기간 | 2018-01 ~ 2018-12 | FiscalPeriods |
| 5 | 법인 | 보고법인 코드 | Owners |
| 6 | 사업장 | 보고법인 사업장 | **GAP** |
| 7 | 전표일자 | 거래 발생일 | Transactions.date |
| 8 | 증빙일자 | 증빙 서류 날짜 | **GAP**: Transactions.evidenceDate |
| 9 | 거래처코드 | N10743227 형식 | Counterparty.identifier |
| 10 | 거래처 | 거래처명 | Transactions.counterpartyName |
| 11 | 사업자등록번호 | 10자리 | Counterparty.identifier |
| 12 | **계정과목** | 세부 계정과목명 (외상매출금-DA광고 등) | Account.name |
| 13 | 계정코드 | Materialized Path | Account.dimensionPath |
| 14 | 전표번호 | NAVER00-... 형식 | **GAP**: referenceNo |
| 15 | 통화(장부통화) | KRW 등 | JEL.baseCurrency |
| 16 | **발생(장부통화)** | 신규 채권/채무 발생액 | JEL.baseAmount (간접) |
| 17 | **반제(장부통화)** | 결제된 상계액 | JEL.baseAmount (간접) |
| 18 | **잔액(장부통화)** | 미결제 잔액 (발생-반제) | 계산 필드 |
| 19 | 환율 | 전표 통화 환율 | JEL.exchangeRateAtTrade |
| 20 | 통화(전표통화) | 원본 통화 코드 | JEL.originalCurrency |
| 21 | **발생(전표통화)** | 원본 통화 발생액 | JEL.originalAmount |
| 22 | **반제(전표통화)** | 원본 통화 반제액 | JEL.originalAmount |
| 23 | **잔액(전표통화)** | 원본 통화 잔액 | 계산 필드 |
| 24 | 라인적요 | 전표 적요 | JEL.memo |
| 25 | **반제완료여부** | 미완료/완료 | **GAP**: 잔액=0 간접 표현 가능 |
| 26 | **예정일자** | 결제 예정일 (만기) | **GAP**: JEL.dueDate |
| 27 | 상대계정과목 | 대응 계정명 | **GAP**: 단일 전표 내 상대 라인 참조 |
| 28 | 상대계정코드 | 대응 계정 코드 | **GAP** |
| 29 | 서비스 | 서비스명 | Tag/DimensionValues |
| 30 | 서비스코드 | 서비스 코드 | Tag/DimensionValues |
| 31 | 전표상태 | 승인 | TransactionStatus |
| 32 | 출처 | 배너광고시스템 등 | Transactions.source |
| 33 | 범주 | 선수금충전 등 | Tag |
| 34 | 담당자 | 담당자 ID | **GAP** |
| 35 | 승인자 | 승인자 ID | **GAP** |
| 36 | LEGACY NO | 구시스템 번호 | **GAP** |
| 37 | **입금번호** | 입금 처리 번호 (AD-181130-241480 등) | **GAP**: 가계부 불필요 |
| 38 | 역분개여부 | Y/N | Transactions.voidedBy |
| 39 | **원천라인번호** | 원본 전표 라인 ID (194845770 등) | **GAP**: JEL 간 참조 |
| 40 | 은행 | 결제 은행 | **GAP**: 가계부 MVP 불필요 |
| 41 | 계좌번호 | 결제 계좌 | **GAP** |
| 42 | 계좌용도 | 계좌 용도 | **GAP** |

**대표계정 분류 (채권 5종 + 채무 4종 + 제외)**:
- 01)매출채권, 02)미수금, 03)대여금, 04)기타채권, 05)임차보증금
- 06)미지급금, 07)임대보증금, 08)차입금, 09)기타채무
- 제외: 특수관계자 주석 범위 외 거래

### 도메인 개념

- 발생-반제-잔액 3분할 회계 (B/S 잔액 = 발생 누적 - 반제 누적)
- 반제완료여부: `미완료`/`완료` — 채권/채무 소멸 시점 추적 (부도/대손 탐지 가능)
- 예정일자: 미결제 채권의 만기일 → 대손충당금 설정 기준
- 범주: 내부 거래 유형 (선수금/광고시스템/결제대금 등)
- 결제계좌 정보: 은행송금 자동화 연계 (ERP-은행 연동)
- **[보강]** `입금번호`: AD-YYMMDD-NNNNNN 형식의 입금 처리 추적번호
- **[보강]** `원천라인번호`: 원본 전표의 JEL ID — 반제 시 원본 라인 역참조

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 발생-반제-잔액 | 커버 | JEL 차대변 합산으로 잔액 계산 |
| 반제완료여부 | **GAP** | 잔액=0 조건으로 간접 계산 가능하나 명시 필드 없음 |
| 예정일자 (만기) | **GAP** | `JEL.dueDate` 없음 |
| 대손충당금 | **GAP** | LegalParameter 대손충당금 한도 없음 |
| 결제계좌 정보 | **GAP** | 가계부 MVP 불필요 |
| 범주(내부 서비스) | 부분커버 | Tag/DimensionValues로 대체 가능 |
| 입금번호 | **GAP** | 가계부 불필요 |
| 원천라인번호 | **GAP** | JEL 간 참조 (반제 추적) |

### 미커버 항목

- 예정일자: `JEL.dueDate` 추가 시 연체 탐지 가능
- 대손충당금 LegalParameter: 법인세법 §34 설정율 (미판정 유지 → 한도 자동 계산)
- 반제완료여부는 `잔액 = 0` 으로 간접 표현 가능 (추가 필드 불필요)
- **[보강]** 입금번호/원천라인번호: 기업용 ERP 연동 시 필요 (가계부 MVP 스킵)

---

## 시트 6: [고정자산이관처분]

**기본 정보**: 62,311행 × **46열** (R3 헤더행 기준)

> **[보강]** 실제 Read 확인, 수익비용과 동일한 46열 구조. 기존 기술 정확.

### 컬럼 구조 (실제 확인 — R3 헤더행 전수, 46열)

수익비용 시트(46열)와 **컬럼 구조 완전 동일**. 차이점은 데이터 범위만 다름:

| 차이점 | 수익비용 | 고정자산이관처분 |
|--------|---------|----------------|
| 대표계정 분류 | 01)용역매출 ~ 10)재고자산매입 | 02)미수금, 1.유형자산, 3.무형자산 |
| 계정 범위 | 4001~6xxx (수익/비용) | 1201~1203 (유형/무형자산) + 1105 (미수금) |
| 금액 컬럼 | 차변/대변/잔액(장부+전표) | 차변/대변/잔액(장부+전표) — 동일 |

**대표계정 3종**:
- `02)미수금`: 이관/처분 대금 미수 채권
- `1.유형자산`: 건물/설비/차량/IT기기 등
- `3.무형자산`: 소프트웨어/특허권/상표권 등

### 도메인 개념

- 자산 이관: 계열회사 간 자산을 장부가액 또는 공정가액으로 이전
- 자산 처분: 계열회사에 자산을 매각 → 처분이익/손실 발생
- 대금 미수: 이관/처분 대금을 아직 수취하지 못한 경우 미수금으로 계상
- K-IFRS 1024호: 특수관계자에 대한 자산 이관/처분은 독립거래조건(arm's length) 검토 필요
- 62,311행의 대부분: 감가상각비를 월별로 계열사에 배부(이관)하는 내부 거래

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 자산 이관 전표 | 커버 | Transaction + JEL 복식부기 기록 가능 |
| 유형자산 계정 | 커버 | AccountType.asset + Materialized Path |
| 무형자산 계정 | 커버 | AccountType.asset (동일) |
| 자산처분이익/손실 | 커버 | JEL 차대변 차이 → 처분손익 자동 계산 |
| arm's length 검토 | **GAP** | LegalParameter 기반 관련 규칙 없음 |
| 감가상각 자동전표 | **GAP** | 주기적 자동전표 생성 로직 없음 |

### 미커버 항목

- 감가상각 자동전표: 자산 등록 후 내용연수/상각방법 기반 정기 전표 생성 (장기 확장)
- 특수관계자 자산 이관 arm's length 검토: 공정가액 vs 장부가액 비교 로직 (기업 확장)

---

## 시트 7: [MASTER]

**기본 정보**: 494행 × **21열** (좌측 + 우측 마스터 병렬, 최대 컬럼 F~V)

> **[보강]** 기존 문서는 22열로 기술했으나 실제 Read 결과 **21열**. 3개 마스터 테이블이 병렬 배치. 컬럼명 세부 보정.

### 컬럼 구조 (실제 확인 — R14~R15 헤더행 전수, 21열)

이 시트는 **세 개의 마스터 테이블이 병렬 배치** (좌측/중간/우측):

**A. 계정과목 매핑** (열 B~D, R15 헤더 기준):

| # | 컬럼명 (실제) | 내용 | CW 매핑 |
|---|--------------|------|---------|
| B | 계정코드 | 10자리 세부 계정 코드 (1105010110 등) | Account.dimensionPath |
| C | 계정명 | 세부 계정과목명 (외상매출금-DA광고 등) | Account.name |
| D | 대표계정 | 주석 표시용 분류 코드 (01)매출채권 등) | Account.dimensionPath 상위 노드 |

**B. 거래처 매핑** (열 I~N, R15 헤더 기준):

| # | 컬럼명 (실제) | 내용 | CW 매핑 |
|---|--------------|------|---------|
| I | 별도원장-거래처명 | 회계장부상 거래처명 | CounterpartyAliases.alias |
| J | 연결시스템-회사명 | 연결결산시스템상 회사명 | Counterparty.name |
| K | 종속/관계회사 | 법인코드 (E136, N129 등) | **GAP**: Counterparty.legalCode |
| L | 계열회사 | 계열회사 코드 (있으면 기재) | **GAP** |
| M | 공시대상 | 기타/기타(*) — 주석 표시 분류 | **GAP**: relatedPartyType |

**C. 종속기업 및 관계기업 마스터** (열 P~U, R15 헤더 기준):

| # | 컬럼명 (실제) | 내용 | CW 매핑 |
|---|--------------|------|---------|
| P | 회사명 | 법인 한국어명 | Counterparty.name |
| Q | 약어 | N100/B103 등 법인코드 | **GAP**: Counterparty.legalCode |
| R | 지분율 | 유효지분율(%) | **GAP**: 지분율 필드 없음 |
| S | 구분 | 지배기업/종속회사/관계회사/기타 | **GAP**: relatedPartyType |
| T | 공시회사명 | 연결재무제표 공시 명칭 | **GAP**: 가계부 불필요 |
| U | 당기처분일자 | 지분 처분/제외 시점 (2999-12=유지) | **GAP**: 관계 유효기간 |

**대표계정 전수 목록** (R2~R12, 좌측 참조 테이블):

채권채무: `01)매출채권, 02)미수금, 03)대여금, 04)기타채권, 05)임차보증금, 06)미지급금, 07)임대보증금, 08)차입금, 09)기타채무`

수익비용: `01)용역매출, 02)재고자산매출, 03)이자수익, 04)기타(수익), 06)수수료비용, 07)수수료비용(매출차감), 08)지급임차료, 09)기타(비용), 10)재고자산매입`

고정자산: `02)미수금, 1.유형자산, 3.무형자산`

제외계정: `상품, 제품, 선급비용, 외환차손익, 당기손익공정가치금융자산평손익`

**[보강]** 별도로 제외/대지급 구분 코드 존재 (R12: `제외`, `대지급`)

### 도메인 개념

- 계정코드 체계 (Materialized Path):
  - `1105xxxxxx`: 유동자산 (외상매출금, 미수금, 단기대여금 등)
  - `1209xxxxxx`: 비유동자산 (임차보증금, 장기대여금, 대손충당금)
  - `2101xxxxxx`: 유동부채 (미지급금)
  - `4001xxxxxx`: 수익 (DA광고매출, SA광고매출, EC 등)
  - `5xxx/6xxx`: 판관비/영업외비용
- `수익비용여부=X(제외)`: 특관자 주석 범위 제외 계정 — 비관계사 계정, 내부 선급비용, 외환차손익 등
- `07)수수료비용(매출차감)`: 순액 처리 계정 — 수익에서 차감하여 순액 표시
- **[보강]** 거래처 매핑의 별도원장-거래처명 vs 연결시스템-회사명: 이름 정규화 매핑 (CounterpartyAliases에 해당)
- **[보강]** `당기처분일자 = 2999-12`: 유지 중인 관계 (사실상 무한 유효)

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 계정코드 Materialized Path | 커버 | §12 AccountType + dimensionPath |
| 계정-대표계정 매핑 | 커버 | Account.dimensionPath 계층 집계 |
| 거래처 별칭 매핑 | 커버 | CounterpartyAliases 테이블 |
| 법인 마스터 | 커버 | Owners + Counterparty |
| 법인코드 체계 (N/B/I/L/E) | **GAP** | Counterparty.legalCode 없음 |
| 제외 계정 (X) | **GAP** | `Account.isExcludedFromReport` 없음 |
| 매출차감 계정 (순액) | **GAP** | `Account.isRevenueDeduction` 없음 |
| 지분율 | **GAP** | Counterparty.ownershipRatio 없음 |
| 당기처분일자 | **GAP** | 관계 유효기간 없음 |
| 공시대상 분류 | **GAP** | relatedPartyType |

### 미커버 항목

- `Account.isExcludedFromReport`: 보고 범위 제외 플래그 (주석에서 제외되는 계정)
- `Account.isRevenueDeduction`: 순액 표시 계정 플래그 (수수료비용 매출차감 처리)
- `Counterparty.legalCode`: N/B/I/L/E 법인코드 체계
- 기능통화: 법인별 `Owner.functionalCurrency` (다국적 법인 확장 시 필요)

---

## 시트 8: [환율]

**기본 정보**: 616행 × **14열** (2개 테이블 좌우 병렬 + 유의사항)

> **[보강]** 기존 문서는 18열로 기술했으나 실제 Read 결과 **14열**. 평균환율 테이블(6열) + 기말환율 테이블(6열) + 유의사항(2열)이 좌우 병렬 배치.

### 컬럼 구조 (실제 확인 — R4 헤더행 전수, 14열)

**A. 평균환율 테이블** (열 B~F):

| # | 컬럼명 (실제) | 내용 | CW 매핑 |
|---|--------------|------|---------|
| B | From 통화 | AUD/BDT/BHD/BND/... (30개+) | ExchangeRates.fromCurrency |
| C | To 통화 | KRW (고정) | ExchangeRates.toCurrency |
| D | 환율일자 | 2018-01 ~ 2018-12 (월별) | ExchangeRates.effectiveDate |
| E | 유형 | AVERAGE (고정) | **GAP**: ExchangeRates.purpose 확장 필요 |
| F | 환율 | KRW 기준 환율 (소수점 포함) | ExchangeRates.rate |

**B. 기말환율 테이블** (열 H~L):

| # | 컬럼명 (실제) | 내용 | CW 매핑 |
|---|--------------|------|---------|
| H | From 통화 | USD/JPY/EUR/CNY/... | ExchangeRates.fromCurrency |
| I | To 통화 | KRW (고정) | ExchangeRates.toCurrency |
| J | 환율일자 | 2018-12-31 (기말일) | ExchangeRates.effectiveDate |
| K | 유형 | COMPANY (고정) | **GAP**: purpose 확장 필요 |
| L | 환율 | KRW 기준 기말환율 | ExchangeRates.rate |

**C. 유의사항** (열 N):

| # | 컬럼명 (실제) | 내용 |
|---|--------------|------|
| N | 유의사항 | 제외 대상 계정 및 특수 처리 규칙 목록 |

**환율 유형 2종**:

| 유형 | 설명 | 용도 |
|------|------|------|
| AVERAGE | 기간 평균환율 (월별) | 수익/비용 환산 (포괄손익계산서) |
| COMPANY | 기말환율 (COMPANY 고시) | 채권/채무 잔액 환산 (재무상태표) |

**지원 통화 (30개+)**: AUD, BDT, BHD, BND, BRL, CAD, CHF, CNY, CZK, DKK, EUR, GBP, HKD, HUF, IDR, INR, JPY, KWD, MYR, MZN, NOK, PHP, PLN, RUB, SEK, SGD, THB, TRY, TWD, USD, VND, ZAR 등

**환율 유의사항 (시트 내 기재)**:
- 선급비용-기간인식, 소득세 예수금: 특관자 환산 대상 제외
- 당기손익공정가치측정금융자산평손익: 제외
- 외환차손익, 외화환산손익: 제외 (별도 계산)
- PG수수료: 순액 처리 (미지급금 대신 외상매출금 차감)
- 역분개 대지급: 제외
- 취득법인: 취득 익월부터 수익비용 산입

### 도메인 개념

- AVERAGE(평균환율) vs COMPANY(기말환율) 이중성: K-IFRS 핵심 요건
  - 수익/비용 → 발생 시점 기준 평균환율 적용 (실현 손익 개념)
  - 자산/부채 잔액 → 기말 기준 환율 재평가 (미실현 외환차손익 발생)
- 외환차손익 자동 생성: (기말환율 - 취득시환율) x 외화 잔액
- 기능통화 vs 표시통화: NBP는 기능통화=KRW, 표시통화=KRW (해외 법인은 다름)

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 환율 테이블 | 커버 | ExchangeRates 테이블 |
| 다통화 지원 (30개+) | 커버 | ExchangeRates.fromCurrency/toCurrency |
| 기간별 환율 | 커버 | ExchangeRates.effectiveDate |
| AVERAGE vs COMPANY | **GAP** | `purpose = ACCOUNTING/TAX` 만 존재, INCOME_STATEMENT/BALANCE_SHEET 없음 |
| 외환차손익 자동전표 | 커버 | EvaluateUnrealizedFxGain UseCase + §7.3 |
| 유효기간 (적용시작/종료) | 부분커버 | effectiveDate 만 존재, endDate 없음 |

### 미커버 항목

- `ExchangeRates.purpose` 값 확장:
  - 현재: `ACCOUNTING | TAX`
  - 필요: `INCOME_STATEMENT | BALANCE_SHEET | ACCOUNTING | TAX`
  - 이유: 평균환율(수익비용)과 기말환율(채권채무) 명시적 구분 필요
- `ExchangeRates.endDate`: 환율 유효 종료일 (현재 effectiveDate만 있어 기간 범위 조회 어려움)

---

## 시트 9: [계열회사(공정거래법)X]

**기본 정보**: 48행 × **9열** (R2 헤더행 기준)

> **[보강]** 기존 문서는 10열로 기술했으나 실제 Read 결과 **9열**. `NO` 순번 컬럼 없음 — 첫 열이 법인명(풀네임), 두번째가 법인코드.

### 컬럼 구조 (실제 확인 — R2 헤더행 + R3~ 데이터 전수, 9열)

| # | 컬럼명 (실제) | 내용 | CW 매핑 |
|---|--------------|------|---------|
| A | (법인명-풀) | 법인 한국어 풀네임 (데이터 행 첫 열) | Counterparty.name |
| B | (법인코드) | N100/B100/I100 등 | **GAP**: Counterparty.legalCode |
| C | (순번) | 1, 2, 3... | — |
| D | 회사명 | 법인 한국어명 (헤더상) | Counterparty.name |
| E | 대표자 | 대표이사 성명 | **GAP**: 가계부 불필요 |
| F | 등기번호 | 법인 등기 번호 (110111-1707178 등) | Counterparty.identifier (legalRegistration) |
| G | 사업자등록번호 | 10자리 사업자번호 | Counterparty.identifier (businessRegistration) |
| H | 네온미사용법인 | 연결결산시스템(네온) 미사용 표시 | **GAP**: 가계부 불필요 |
| I | 연결대상 | 연결/비연결 | **GAP**: Counterparty.isConsolidated |

**법인코드 체계**:

| 접두사 | 계열 | 예시 |
|--------|------|------|
| N | NAVER 직접 운영 | N100(NAVER), N117(스노우), N128(스프링캠프) |
| B | 비즈플랫폼 (NBP) | B100(NBP) |
| I | 인터넷계열 | I100(네이버아이앤에스), I102(그린웹서비스), I103(인컴즈), I104(컴파트너스), I105(엔아이티서비스) |
| L | LINE계열 | L100(LINE Corp) |
| E | 외부 관계회사 | E100~ |

### 도메인 개념

- 공정거래법 §14: 기업집단 계열회사 목록 (연 1회 이상 공시 의무)
- 특수관계자 범위 확정의 첫 단계: 계열회사 = 특수관계자 기본 집합
- `연결대상`: K-IFRS 1110 연결재무제표 포함 여부
  - 연결: 실질 지배력 보유 (과반수 의결권 또는 사실상 지배)
  - 비연결: 지배력 없음 (관계기업/기타)
- **[보강]** `네온미사용법인`: 연결결산시스템 '네온'에 등록되지 않은 법인 표시 (시스템 연동 메타)
- **[보강]** 계열편입/제외일 컬럼은 이 시트에 없음 (기존 문서 오류) — 관계회사(외감법) 시트에 유효시작/종료일 존재

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 거래처 식별자 | 커버 | Counterparty.identifierType + identifier |
| 사업자등록번호 | 커버 | identifierType = businessRegistration |
| 등기번호 | 커버 | identifierType = legalRegistration |
| 법인코드 체계 | **GAP** | Counterparty.legalCode (N/B/I/L/E) 없음 |
| 연결대상 여부 | **GAP** | `Counterparty.isConsolidated` 없음 |
| 특수관계자 유형 | **GAP** | isRelatedParty: bool 만 존재 |

### 미커버 항목

- `Counterparty.legalCode`: 공정거래법 기업집단 코드 체계 (가계부에서는 식별자로 대체 가능)
- `Counterparty.relatedPartyType`: 공정거래법/외감법 구분 포함한 5단계 분류

---

## 시트 10: [관계회사(외감법)E~]

**기본 정보**: 262행 × **32열** (R1~R2 헤더행 기준)

> **[보강]** 32열 정확. 실제 R1(카테고리 헤더) + R2(컬럼명 헤더)의 2행 헤더 구조 확인. 컬럼명 세부 보정.

### 컬럼 구조 (실제 확인 — R1~R2 헤더행 전수, 32열)

| # | R1 (카테고리) | R2 (컬럼명) | 내용 | CW 매핑 |
|---|-------------|------------|------|---------|
| A | — | 처분여부 | 법인명 또는 "처분여부" 표시 | **GAP**: 관계 유효기간 |
| B | — | NBP입장 | 지배회사/종속회사/관계회사/기타 | **GAP**: relatedPartyType |
| C | NO(*) | NO | 순번 | — |
| D | 법인 | 코드(*) | N/B/I/L/E 코드 | **GAP**: Counterparty.legalCode |
| E | 법인 | 약어(*) | 영문 약칭 (NAVER, NBP 등) | **GAP**: 가계부 불필요 |
| F | 법인 | 법인명(*) | 한국어 법인명 | Counterparty.name |
| G | 법인 | 법인명(*) | 한국어 법인명 (중복 열) | — |
| H | 법인 | 법인명(EN)(*) | 영문 법인명 | **GAP**: Counterparty.nameEn |
| I | 법인 | 법인명(CN)(*) | 중국어 법인명 | **GAP**: 가계부 불필요 |
| J | 법인 | 법인명(JP)(*) | 일본어 법인명 | **GAP**: 가계부 불필요 |
| K | 연동법인 | 연동법인 | Y/N — 연결시스템 연동 여부 | **GAP**: 가계부 불필요 |
| L | 계정맵핑 | 계정맵핑 | Y/N — 계정과목 매핑 완료 여부 | **GAP**: 가계부 불필요 |
| M | 장부명 | 장부명 | 회계장부명 (NAVER 회계장부 등) | **GAP** |
| N | 통화 | 기능(*) | 법인 기능통화 (KRW/USD/JPY 등) | **GAP**: Counterparty.functionalCurrency |
| O | 통화 | 보고(*) | 법인 보고통화 | **GAP** |
| P | 사업자등록번호 | 사업자등록번호 | (국내 법인만) | Counterparty.identifier |
| Q | 대표서비스 | 대표서비스 | 대표 서비스명 | **GAP**: 가계부 불필요 |
| R | 시작일자(*) | 시작일자 | 관계 유효 시작 (지분 취득/설립일) | **GAP**: 유효기간 |
| S | 종료일자(*) | 종료일자 | 관계 유효 종료 (지분 처분일, 2999-12-31=유지) | **GAP**: 유효기간 |
| T | 취득(*) | 취득 | 취득/설립 구분 | **GAP** |
| U | 법인구분(*) | 법인구분 | 연결/제외(처분/청산 등) | **GAP**: Counterparty.isConsolidated |
| V | 변경일자(*) | 변경일자 | 법인구분 최종 변경일 | **GAP** |
| W | 변경사유(*) | 변경사유 | 연결대상/피합병(NAVER) 등 | **GAP** |
| X | 사용여부 | 사용여부 | Y/N — 현재 활성 여부 | Counterparty.isActive (간접) |
| Y | 연결장부 | 사업장ID | 연결결산시스템 사업장 ID | **GAP** |
| Z | 연결장부 | 연동장부ID | 연결결산시스템 장부 ID | **GAP** |
| AA | 연결장부 | 거래처ID | 회계시스템 거래처 ID (2966221 등) | Counterparty.identifier |
| AB | 연결장부 | 거래처 | 시스템 표시명 (법인명+코드+약어) | CounterpartyAliases |
| AC | 연결장부 | 주소 | 본사 주소 | Counterparty.address |
| AD | 연결통합회사 | ID(*) | 연결 통합 모회사 ID | **GAP** |
| AE | 연결통합회사 | Name | 연결 통합 모회사명 | **GAP** |
| AF | Old | 코드 | 이전 시스템 법인 코드 | **GAP** |

**NBP입장 구분**:

| 값 | 의미 | K-IFRS 기준 |
|----|------|------------|
| 지배회사 | NAVER (NBP의 지배주주) | IFRS 1110 |
| 종속회사 | NBP가 과반수 지배 | IFRS 1110 |
| 관계회사 | NBP가 중요한 영향력 보유 (20~50%) | IFRS 1028 |
| 기타 | 계열회사이나 지배력/영향력 없음 | IFRS 1024 |

### 도메인 개념

- 외감법(주식회사 등의 외부감사에 관한 법률): 연결 범위 확정의 법적 근거
- 기능통화: 법인의 주 영업 환경 통화 (KRW/USD/TWD 등 국가별 상이)
  - 기능통화≠KRW인 법인: 환산조정 발생 (자본 항목으로 처리)
- 유효시작/종료일: 관계의 시간적 이력 관리 (기업 인수/합병/처분 추적)
- 연결통합회사: 복잡한 지배구조에서 중간 지주회사 개념
- **[보강]** 다국어 법인명 (한/영/중/일): 다국적 기업 연결결산 요건
- **[보강]** `법인구분` 값: `연결`, `제외(처분/청산 등)` — 변경사유와 함께 이력 추적
- **[보강]** `종료일자 = 2999-12-31`: 유지 중인 관계 (사실상 무한 유효)

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 거래처 ID/코드 | 커버 | Counterparty.identifier |
| 법인명 (한) | 커버 | Counterparty.name |
| 법인명 (영/중/일) | **GAP** | 다국어 이름 필드 없음 |
| 사업자등록번호 | 커버 | identifierType = businessRegistration |
| 기능통화/보고통화 | **GAP** | Counterparty.functionalCurrency 없음 |
| NBP입장(4단계) | **GAP** | relatedPartyType 없음 |
| 유효시작/종료일 | **GAP** | 관계 유효기간 추적 없음 |
| 연결대상여부 | **GAP** | isConsolidated 없음 |
| 거래처 주소 | 커버 | Counterparty.address |
| 법인구분 변경이력 | **GAP** | 이력 추적 없음 |

### 미커버 항목

- `Counterparty.relatedPartyType` (4단계): parent/subsidiary/associate/other
- `Counterparty.functionalCurrency`: 해외 법인 기능통화 (다국적 확장 시 필요)
- 유효기간 관리: 지분 취득/처분 이력 (가계부 MVP 범위 외, §15 확장 예약)

---

## 시트 11: [지분율표]

**기본 정보**: 206행 × **16열** (R1 헤더행 기준)

> **[보강]** 16열 정확. R1이 바로 헤더행 (다른 시트와 달리 빈 행 없이 시작). 기존 문서의 `비고`, `기준일자` 2개 컬럼은 실제 엑셀에 없음 — `투자부문코드`, `피투자부문코드` 컬럼이 대신 존재.

### 컬럼 구조 (실제 확인 — R1 헤더행 전수, 16열)

| # | 컬럼명 (실제) | 내용 | CW 매핑 |
|---|--------------|------|---------|
| A | 결산년월 | 2018-12 | FiscalPeriods |
| B | 투자법인Id | 투자하는 법인의 시스템 ID (1073 등) | **GAP**: InvestmentHolding |
| C | 투자법인코드 | N100/B100 등 | **GAP**: Counterparty.legalCode |
| D | 투자법인 | 투자 법인 약칭 (NAVER, NBP 등) | Counterparty.name |
| E | **투자부문코드** | 투자 법인의 부문 코드 (0000000 등) | **GAP** |
| F | **투자부문** | 투자 법인의 사업 부문 (N/A 등) | **GAP** |
| G | 피투자법인Id | 투자 받는 법인의 시스템 ID | **GAP** |
| H | 피투자법인코드 | N/B/I/L/E 코드 | **GAP** |
| I | 피투자법인 | 피투자 법인 약칭 (NBP, INS 등) | **GAP** |
| J | **피투자부문코드** | 피투자 법인의 부문 코드 | **GAP** |
| K | **피투자부문** | 피투자 법인의 사업 부문 | **GAP** |
| L | 취득가액(GC) | 투자 주식 취득 원가 (Group Cost) | **GAP** |
| M | 보유주식수 | 현재 보유 주식 수 | **GAP** |
| N | 총발행주식수 | 피투자법인 총 발행 주식 수 | **GAP** |
| O | 직접지분율 | (보유주식수 / 총발행주식수) — 비율값 (0~1) | **GAP** |
| P | 유효지분율 | 직접지분율 + 계열 법인을 통한 간접 지분율 | **GAP** |

> **[보강]** 기존 문서의 `비고`(#15), `기준일자`(#16) 컬럼은 실제 엑셀에 존재하지 않음. 대신 `투자부문코드`(#5), `투자부문`(#6), `피투자부문코드`(#10), `피투자부문`(#11) 4개 컬럼이 있음.
> 직접지분율은 100이 아닌 **0~1 비율값** (예: 1 = 100%, 0.733 = 73.3%)

### 도메인 개념

- 직접지분율: A사가 B사 주식을 직접 보유한 비율
  - `직접지분율 = 보유주식수 / 총발행주식수` (0~1 비율)
- 유효지분율: 간접 지배 포함 실질 지배력 수치
  - 예시: NAVER→NBP 직접 1.0 + NBP→LINE 직접 0.733 → NAVER의 LINE 유효지분율 = 0.733
  - K-IFRS 1110: 실질 지배력 판단의 핵심 지표
- 결산년월별 이력: 지분율 변동 추적 (주식 취득/처분 시마다 갱신)
- 취득가액(GC): Group Cost — 연결결산 시 내부 거래 제거에 사용
- **[보강]** 투자부문/피투자부문: 대부분 `N/A` — 부문별 세분화가 필요한 경우에만 사용

### CW_ARCHITECTURE 대비

| 항목 | CW 커버 여부 | 비고 |
|------|-------------|------|
| 투자/피투자 관계 | **GAP** | AccountOwnerShares는 Owner 내 지분이지, 법인 간 투자 아님 |
| 직접지분율 | **GAP** | 법인 간 지분율 테이블 없음 |
| 유효지분율 | **GAP** | 간접 지배 계산 로직 없음 |
| 취득가액 이력 | **GAP** | 투자주식 원가 관리 없음 |
| 지분율 이력 (결산년월별) | **GAP** | 시계열 지분율 변동 없음 |
| 지배력 판단 로직 | **GAP** | 20%/50% 임계값 기반 분류 없음 |
| 투자/피투자 부문 | **GAP** | 부문별 세분화 없음 |

### 미커버 항목

- 법인 간 투자지분 구조 전체: `InvestmentHolding` 테이블 신설 필요 (장기 확장)
  - `investor_id`, `investee_id`, `directOwnership`, `effectiveOwnership`, `acquiredAt`
  - **가계부 MVP에서는 완전히 스킵** → §15 확장 예약

---

## 종합: CW_ARCHITECTURE 대비 커버/미커버 항목 집계

### 커버 항목 (현재 아키텍처에서 지원)

| 엑셀 개념 | CW_ARCHITECTURE 대응 |
|-----------|---------------------|
| 복식부기 차대변 균형 | INV-T1/T2, JournalEntryLines |
| 이중통화 (장부통화 + 전표통화) | JEL.baseCurrency + originalCurrency |
| 다통화 환율 테이블 | ExchangeRates 테이블 (30개+ 통화) |
| 역분개 추적 (voidedBy) | VoidTransaction + Transactions.voidedBy |
| 계정코드 Materialized Path | Account.dimensionPath + §12 표준 코드 |
| 거래처 식별자 (사업자번호 등) | Counterparty.identifier + identifierType |
| 거래처 별칭 매핑 | CounterpartyAliases 테이블 |
| 전표라인번호 | JEL.id |
| 전표상태 (승인/취소) | TransactionStatus.POSTED/VOIDED |
| 귀속구분 (원가귀속 1단계) | DimensionValues.activityTypeOverride |
| 법인/사업장 구분 | Owners + AccountOwnerShares.shareRatio |
| 관계사 거래 (bool) | Counterparty.isRelatedParty |
| 외환차손익 자동전표 | EvaluateUnrealizedFxGain + §7.3 매핑 |
| 발생-반제-잔액 계산 | JEL 차대변 합산 (간접 계산) |
| 기간별 보고서 집계 | FiscalPeriods + ReportQueryService |
| 라인적요 | JEL.memo |
| 거래처 주소 | Counterparty.address |

### 미커버 항목 우선순위 분류

**우선순위 A — MVP 확장에 직접 영향 (3건)**

| # | 항목 | 발견 시트 | 추가 위치 |
|---|------|-----------|-----------|
| A-1 | `Counterparty.relatedPartyType` 열거형 | 시트1,2,9,10 | §2.4 + Drift 스키마 |
| A-2 | `ExchangeRates.purpose` 확장: `INCOME_STATEMENT \| BALANCE_SHEET` | 시트8 | §4.1 + §15 |
| A-3 | `LegalParameter` 대손충당금 설정율 한도 규칙 | 시트5,7 | §6.1 TaxRuleEngine |

**우선순위 B — 기능 완성도 향상 (5건)**

| # | 항목 | 발견 시트 | 추가 위치 |
|---|------|-----------|-----------|
| B-1 | `Transactions.referenceNo` (nullable) | 시트4 | §4.1 Drift 스키마 |
| B-2 | `Account.isRevenueDeduction: bool` | 시트7 | §4.1 + §12 |
| B-3 | `Transaction.reversalType` 열거형 | 시트4 | §2.1 Transactions |
| B-4 | `Counterparty.legalCode` (N/B/I/L/E 체계) | 시트3,7,9 | §2.4 |
| B-5 | `Account.isExcludedFromReport: bool` | 시트2,3,7 | §4.1 + §12 |

**우선순위 C — 장기 확장 / §15 예약 (6건)**

| # | 항목 | 발견 시트 | 설명 |
|---|------|-----------|------|
| C-1 | `InvestmentHolding` 테이블 | 시트11 | 법인 간 직접/유효지분율 이력 |
| C-2 | 감가상각 자동전표 | 시트6 | 자산 내용연수/상각방법 기반 |
| C-3 | 결재선 `Transaction.approvedByOwnerId` | 시트4 | 다인 가구 승인 워크플로우 |
| C-4 | 특수관계자 거래 한도 LegalParameter | 시트1,2 | 관계사 거래 한도 초과 판정 |
| C-5 | `Counterparty.functionalCurrency` | 시트10 | 해외 법인 기능통화 |
| C-6 | 관계 유효기간 (취득일/처분일) | 시트9,10 | 계열 편입/제외 이력 |

---

## 보강 이력

| 일시 | 작업자 | 내용 |
|------|--------|------|
| 2026-04-19 | Arjun-2 (Sonnet) | 초기 11시트 분석 및 문서화 |
| 2026-04-19 | Arjun-3 (Opus) | 엑셀 실제 Read 기반 컬럼 전수 대조 보강 |

### 보강 주요 변경 사항

| 시트 | 변경 내용 |
|------|-----------|
| 시트1 [서식] | 18열 단일 테이블 → 4개 섹션(지분/기타특관자/수익비용/채권채무/고정자산) 구조로 정정 |
| 시트2 [특관자주석] | 19열→18열 정정, 3개 섹션(수익비용/채권채무/고정자산) 구조 상세화, 투자부동산 컬럼 발견 |
| 시트3 [피벗] | 37열 구조 상세화, `대지급`/`제외` 컬럼 발견 |
| 시트4 [수익비용] | 47열→**46열** 정정, `라인적요`/`부서`/`부서코드`/`원가구분`/`출처`/`담당자`/`전표승인일자` 누락 컬럼 추가 |
| 시트5 [채권채무] | 42열 정확, `입금번호`/`원천라인번호`/`계정과목` 누락 컬럼 추가 |
| 시트6 [고정자산이관처분] | 46열 정확 확인, 수익비용과 동일 컬럼 구조 명시 |
| 시트7 [MASTER] | 22열→**21열** 정정, 3개 마스터 테이블(계정매핑/거래처매핑/법인마스터) 구조 상세화 |
| 시트8 [환율] | 18열→**14열** 정정, 2개 테이블(평균환율6열+기말환율6열)+유의사항 병렬 구조로 정정, 통화 30개+ 확인 |
| 시트9 [계열회사] | 10열→**9열** 정정, `NO` 순번 컬럼 없음 확인, 계열편입/제외일 컬럼 없음(기존 오류) 정정, `대표자`/`네온미사용법인` 컬럼 발견 |
| 시트10 [관계회사] | 32열 정확, 2행 헤더 구조 상세화, 다국어 법인명(한/영/중/일) 4개 열 발견, `법인구분`/`변경일자`/`변경사유` 이력 컬럼 발견 |
| 시트11 [지분율표] | 16열 정확, `비고`/`기준일자` 컬럼 실제 미존재 정정, `투자부문코드`/`투자부문`/`피투자부문코드`/`피투자부문` 4개 컬럼 발견, 직접지분율 0~1 비율값 확인 |

---

*분석 완료. 시트 11개 전수 문서화 + 컬럼 전수 대조 보강, 총 미커버 항목 14건 (A:3, B:5, C:6) 식별.*
