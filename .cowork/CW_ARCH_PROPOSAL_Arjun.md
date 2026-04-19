# 아키텍처 v2.0 반영안 — Arjun (특수관계자)

> 작성자: Arjun-3 (Opus)
> 기반: CW_ANALYSIS_Arjun.md 미커버 14건 (A:3, B:5, C:6)
> 대상: CW_ARCHITECTURE.md
> 일자: 2026-04-20

---

## 1. 도메인 모델 변경

### 1.1 Counterparty AR 확장 (A-1, B-4)

**현재** (§2.4):
```
- name, identifier, identifierType, phone, address
- confidenceLevel, isRelatedParty: bool, counterpartyType, countryCode
```

**추가 필드**:

| 필드명 | 타입 | 설명 | 근거 |
|--------|------|------|------|
| `relatedPartyType` | `RelatedPartyType?` (enum) | 특수관계자 5단계 분류 | A-1 |
| `legalCode` | `String?` | 법인코드 분류 체계 (N100, B200 등) | B-4 |

**RelatedPartyType 열거형 정의**:
```dart
enum RelatedPartyType {
  parent,       // 지배기업 (NAVER → NBP 기준)
  subsidiary,   // 종속기업 (과반수 지배)
  associate,    // 관계기업 (20~50% 영향력)
  affiliate,    // 기타특수관계자 (공정거래법 계열회사)
  otherRelated, // 기타(*) (비영리재단, 공익법인)
}
```

**불변조건 추가**:
- `INV-C4`: `relatedPartyType != null` → `isRelatedParty = true` (자동 동기)
- `INV-C5`: `legalCode` 형식은 대문자 1자 + 숫자 (정규식: `^[A-Z]\d{2,3}$`, nullable)

**DB 저장 포맷**: `.name` (camelCase) — 프로젝트 enum 저장 컨벤션 준수

### 1.2 Transaction AR 확장 (B-1, B-3)

**현재** (§2.1):
```
- date, description, status, voidedBy, counterpartyId, counterpartyName
- source, confidence, periodId, syncStatus, createdAt, updatedAt
```

**추가 필드**:

| 필드명 | 타입 | 설명 | 근거 |
|--------|------|------|------|
| `referenceNo` | `String?` | 외부 전표번호/카드승인번호 | B-1 |
| `reversalType` | `ReversalType?` | 역분개 유형 구분 | B-3 |

**ReversalType 열거형 정의**:
```dart
enum ReversalType {
  reversalOrigin,  // 역분개대상 (원본 전표, 향후 취소 예정)
  reversalEntry,   // 역분개처리 (취소 전표 본체)
}
```

**불변조건 추가**:
- `INV-T8`: `reversalType == reversalOrigin` → `voidedBy != null` (역분개대상은 반드시 취소 전표 참조)
- `INV-T9`: `reversalType == reversalEntry` → `status == VOIDED` (역분개처리는 Voided 상태)

### 1.3 Account AR 확장 (B-2, B-5)

**현재** (§2.2):
```
- name, nature, equityTypeId/Path, liquidityId/Path, assetTypeId/Path
- defaultActivityTypeId, defaultIncomeTypeId, ownerId
- productType, financialInstitution, countrySpecific, isActive
```

**추가 필드**:

| 필드명 | 타입 | 설명 | 근거 |
|--------|------|------|------|
| `isRevenueDeduction` | `bool` (default: false) | 순액 표시 계정 플래그 — 매출차감 수수료 등 | B-2 |
| `isExcludedFromReport` | `bool` (default: false) | 보고서/주석 제외 플래그 | B-5 |

**불변조건 추가**:
- `INV-A6`: `isRevenueDeduction == true` → `nature == EXPENSE` (비용 계정만 매출차감 가능)
- `INV-A7`: `isExcludedFromReport == true` → 해당 계정의 JEL은 주석 보고서 집계에서 제외

### 1.4 ExchangeRate 확장 (A-2)

**현재** (§4.1):
```dart
TextColumn get purpose => text().withDefault(const Constant('ACCOUNTING'))();
// 현재 값: ACCOUNTING | TAX
```

**변경**: `purpose` 값 체계 확장

| 값 | 설명 | 용도 |
|----|------|------|
| `INCOME_STATEMENT` | 기간 평균환율 (AVERAGE) | 수익/비용 환산 — 포괄손익계산서 |
| `BALANCE_SHEET` | 기말환율 (COMPANY) | 채권/채무 잔액 환산 — 재무상태표 |
| `ACCOUNTING` | 기존 호환 (범용) | 명시적 용도 구분 불필요 시 |
| `TAX` | 세무 목적 환율 | 세무조정 시 적용 |

**마이그레이션**: 기존 `ACCOUNTING` 데이터는 그대로 유지. 신규 환율 입력 시 `INCOME_STATEMENT`/`BALANCE_SHEET` 선택 UI 제공.

---

## 2. Drift 스키마 변경

### 2.1 Counterparties 테이블 (§4.1)

```dart
// 추가 컬럼
TextColumn get relatedPartyType => text().nullable()();  // parent|subsidiary|associate|affiliate|otherRelated
TextColumn get legalCode => text().nullable()();          // N100, B200 등 법인코드
```

### 2.2 Transactions 테이블 (§4.1)

```dart
// 추가 컬럼
TextColumn get referenceNo => text().nullable()();        // 외부 전표번호/카드승인번호
TextColumn get reversalType => text().nullable()();       // reversalOrigin|reversalEntry
```

### 2.3 Accounts 테이블 (§4.1)

```dart
// 추가 컬럼
BoolColumn get isRevenueDeduction => boolean().withDefault(const Constant(false))();
BoolColumn get isExcludedFromReport => boolean().withDefault(const Constant(false))();
```

### 2.4 인덱스 추가 (§4.2)

| 쿼리 패턴 | 테이블 | 인덱스 |
|-----------|--------|--------|
| 특수관계자 유형별 조회 | Counterparties | `(relatedPartyType)` |
| 외부 참조번호 검색 | Transactions | `(referenceNo)` |
| 보고서 제외 계정 필터링 | Accounts | `(isExcludedFromReport)` |
| 역분개 유형 조회 | Transactions | `(reversalType)` |

---

## 3. 신규 기능/UseCase

### 3.1 대손충당금 자동 판정 규칙 (A-3)

**위치**: TaxRuleEngine (§6.1) 확장

**규칙 추가**:
```
대손충당금 → 손금산입(한도)
  근거: 법인세법 §34
  LegalParameter key: "대손충당금_설정율_한도"
  paramType: TABLE
  table: { "일반채권": 0.01, "금융기관채권": 0.02 }
  조건: 채권잔액 × 설정율 한도 초과분 → 손금불산입
```

**LegalParameter 시드 데이터 예시**:
```dart
LegalParametersCompanion.insert(
  countryCode: const Value('KR'),
  domain: '법인세',
  key: '대손충당금_설정율_한도',
  paramType: 'TABLE',
  table: const Value('{"일반채권":0.01,"금융기관채권":0.02}'),
  effectiveFrom: DateTime(2019, 1, 1),
  applicationBasis: '결산기말',
  sourceLaw: const Value('법인세법 제34조'),
)
```

**UseCase 변경**: `AutoClassifyDeductibility` 에 대손충당금 판정 경로 추가
```
기존: 접대비 → 벌과금 → 복리후생비 → 감가상각비 → 비품소모품/급여 → 미판정
추가: ... → 대손충당금(한도) → 미판정
```

### 3.2 ICounterpartyRepository 확장

```dart
// 추가 메서드
Future<List<Counterparty>> findByRelatedPartyType(RelatedPartyType type);
Future<List<Counterparty>> findRelatedParties();  // relatedPartyType != null
```

### 3.3 IExchangeRateRepository 확장

```dart
// 기존 findRate에 purpose 파라미터 추가
Future<ExchangeRate?> findRate(CurrencyCode from, to, DateTime date, {String purpose = 'ACCOUNTING'});
Future<ExchangeRate?> findAverageRate(CurrencyCode from, to, DateTime periodStart, DateTime periodEnd);  // INCOME_STATEMENT용
Future<ExchangeRate?> findClosingRate(CurrencyCode from, to, DateTime closingDate);  // BALANCE_SHEET용
```

---

## 4. 기존 섹션 수정

### 4.1 §2.4 Counterparty AR 불변조건 테이블

**현재**:
```
| INV-C1 | name not empty |
| INV-C2 | identifier 있으면 identifier_type 필수 |
| INV-C3 | aliases 시스템 전체 유일 |
```

**추가**:
```
| INV-C4 | relatedPartyType != null → isRelatedParty = true |
| INV-C5 | legalCode 형식: ^[A-Z]\d{2,3}$ (nullable) |
```

### 4.2 §2.1 Transaction AR 불변조건 테이블

**추가**:
```
| INV-T8 | reversalType == reversalOrigin → voidedBy != null |
| INV-T9 | reversalType == reversalEntry → status == VOIDED |
```

### 4.3 §2.2 Account AR 불변조건 테이블

**추가**:
```
| INV-A6 | isRevenueDeduction == true → nature == EXPENSE |
| INV-A7 | isExcludedFromReport 계정은 주석 보고서 집계 제외 |
```

### 4.4 §4.1 Drift 스키마 — Counterparties 테이블

**추가 2줄**: `relatedPartyType`, `legalCode` 컬럼 (위 §2.1 참조)

### 4.5 §4.1 Drift 스키마 — Transactions 테이블

**추가 2줄**: `referenceNo`, `reversalType` 컬럼 (위 §2.2 참조)

### 4.6 §4.1 Drift 스키마 — Accounts 테이블

**추가 2줄**: `isRevenueDeduction`, `isExcludedFromReport` 컬럼 (위 §2.3 참조)

### 4.7 §4.1 Drift 스키마 — ExchangeRates 테이블

**기존**: `purpose` default `'ACCOUNTING'` — 변경 없음 (값 체계만 확장)

**§4.1 주석 추가**: purpose 값 목록에 `INCOME_STATEMENT | BALANCE_SHEET` 추가 기재

### 4.8 §4.2 인덱스 전략 테이블

**추가 4행**: (위 §2.4 인덱스 참조)

### 4.9 §6.1 자동 Deductibility 판정 테이블

**추가 1행**:
```
| 대손충당금 | 손금산입(한도) | 법인세법 제34조, LegalParameter 참조 |
```

**"자동 판정 불가" 목록 수정**: `대손충당금` 제거 (자동 판정 가능으로 승격)

### 4.10 §15 확장 예약 테이블

**수정**: `환율 이중성` 행 → "v2.0에서 구현 완료 (INCOME_STATEMENT/BALANCE_SHEET)" 표시

**추가 행**:

| 영역 | 예약 사항 |
|------|-----------|
| 법인 간 투자지분 | InvestmentHolding 테이블 (investor_id, investee_id, directOwnership, effectiveOwnership) |
| 감가상각 자동전표 | 자산 등록 후 내용연수/상각방법 기반 정기 전표 (결산 프로세스 2-b) |
| 결재선 | Transaction.approvedByOwnerId (다인 가구 승인) |
| 특수관계자 거래 한도 | LegalParameter 기반 관계사 거래 한도 초과 판정 |
| 법인 기능통화 | Counterparty.functionalCurrency (다국적 확장) |
| 관계 유효기간 | Counterparty.effectiveFrom/effectiveTo (계열 편입/제외 이력) |

### 4.11 §2.5 Repository 인터페이스

**ICounterpartyRepository 추가**: `findByRelatedPartyType`, `findRelatedParties` (위 §3.2 참조)

**IExchangeRateRepository 변경**: `findRate`에 purpose 파라미터 추가, `findAverageRate`/`findClosingRate` 추가 (위 §3.3 참조)

---

## 5. 우선순위별 분류

### MVP 필수 (v2.0 즉시 반영) — 3건

| # | 항목 | 변경 범위 | 이유 |
|---|------|-----------|------|
| A-1 | `Counterparty.relatedPartyType` | Drift + AR + DAO + Repository | 특수관계자 5단계 분류 없이 세무조정/주석 보고서 불가능. isRelatedParty bool만으로는 유형별 규칙 적용 불가 |
| A-2 | `ExchangeRates.purpose` 확장 | Drift (값 확장만) + Repository 메서드 | 평균환율/기말환율 구분 없이 외환차손익 자동전표(§7.3) 정확도 저하. K-IFRS 핵심 요건 |
| A-3 | 대손충당금 LegalParameter | LegalParameter 시드 + TaxRuleEngine 규칙 추가 | 법인세법 §34 — 자동 판정 대상에서 누락되면 미판정 잔류 증가 |

### 중기 (v2.1 기능 완성도) — 5건

| # | 항목 | 변경 범위 | 이유 |
|---|------|-----------|------|
| B-1 | `Transactions.referenceNo` | Drift 컬럼 1개 추가 | 카드 승인번호, 외부 전표번호 저장. 중복 탐지(§8) 정확도 향상 |
| B-2 | `Account.isRevenueDeduction` | Drift + AR 불변조건 | 순액 표시(매출차감 수수료) 보고서 정확도. 없으면 수익 과대 표시 |
| B-3 | `Transaction.reversalType` | Drift + AR 불변조건 | 역분개 대상/처리 구분. 없어도 voidedBy로 동작하나 명시성 향상 |
| B-4 | `Counterparty.legalCode` | Drift 컬럼 1개 추가 | N/B/I/L/E 법인코드. 가계부에서는 identifier로 대체 가능하나 기업 확장 시 필수 |
| B-5 | `Account.isExcludedFromReport` | Drift + ReportQueryService 필터 | 주석 범위 제외 계정 명시. 없으면 ReportQueryService에서 하드코딩 필터 필요 |

### 장기 예약 (§15 확장) — 6건

| # | 항목 | 구현 시기 | 비고 |
|---|------|-----------|------|
| C-1 | InvestmentHolding 테이블 | 기업용 확장 시 | 법인 간 직접/유효지분율. 가계부 MVP 완전 스킵 |
| C-2 | 감가상각 자동전표 | 자산관리 BC 신설 시 | 결산 프로세스 §7.2 Step 2-b 확장 포인트에 이미 예약 |
| C-3 | 결재선 (approvedByOwnerId) | 다인 가구 확장 시 | 단일 사용자 가계부에서는 불필요 |
| C-4 | 특수관계자 거래 한도 | 세무 고도화 시 | LegalParameter 추가 규칙으로 구현 가능 |
| C-5 | Counterparty.functionalCurrency | 다국적 확장 시 | 해외 법인 기능통화. KRW 단일 통화 가계부에서는 불필요 |
| C-6 | 관계 유효기간 | 기업용 확장 시 | effectiveFrom/effectiveTo. Temporal 이력 관리 |

---

## 6. 기존 코드 영향 범위 (구현 시 참고)

### A-1 relatedPartyType 구현 시 영향 파일

| 파일 | 변경 내용 |
|------|-----------|
| `lib/infrastructure/database/tables/CounterpartyTable.dart` (추정) | 컬럼 추가 |
| `lib/features/counterparty/data/CounterpartyDao.dart` | 신규 쿼리 메서드 |
| `lib/features/counterparty/data/CounterpartyRepository.dart` | findByRelatedPartyType 구현 |
| `lib/core/interfaces/ICounterpartyRepository.dart` | 인터페이스 메서드 추가 |
| `lib/core/constants/Enums.dart` | RelatedPartyType enum 추가 |
| `lib/infrastructure/database/AppDatabase.g.dart` | build_runner 재생성 |

### A-2 ExchangeRates.purpose 확장 시 영향 파일

| 파일 | 변경 내용 |
|------|-----------|
| `lib/features/exchange/data/ExchangeRateRepository.dart` | findRate purpose 파라미터 추가 |
| `lib/core/interfaces/IExchangeRateRepository.dart` | 인터페이스 시그니처 변경 |
| `lib/features/report/data/ReportQueryService.dart` | 환율 조회 시 purpose 분기 |

### A-3 대손충당금 규칙 추가 시 영향 파일

| 파일 | 변경 내용 |
|------|-----------|
| `lib/features/tax/data/TaxRuleEngine.dart` | 대손충당금 판정 규칙 추가 |
| `lib/features/tax/usecase/AutoClassifyDeductibility.dart` | 판정 경로 추가 |

---

---

## 7. 교차 리뷰 의견

### Grace 분석(연결결산) 관련

Grace는 연결결산보고서 기반으로 12시트를 분석하여 총 25건의 미커버(M-01~M-25)를 식별했다.

**중복 GAP (내 분석과 겹치는 항목)**:

| Grace 항목 | 내 항목 | 중복 내용 | 합치는 방법 |
|-----------|---------|-----------|-------------|
| M-10 지분법 투자 — `Counterparty.ownershipPercent` | A-1 relatedPartyType + C-1 InvestmentHolding | 지분율 관리 필요성이 양쪽에서 독립 발견 | **InvestmentHolding 테이블에 통합** — Counterparty에 지분율을 직접 넣지 말고, InvestmentHolding에서 관리하되 조회 시 Counterparty와 JOIN. relatedPartyType은 별도로 유지 (지분율과 독립적인 법적 분류) |
| M-04 비지배지분 | C-1 InvestmentHolding | 비지배지분 = 연결 관점에서의 소수주주 지분 | 가계부에서는 **AccountOwnerShares 패턴으로 흡수** 가능 (공동명의 계좌에서 소유 비율 이미 관리 중). 별도 엔티티 불필요 |
| M-08 FiscalPeriod.note | 신규 (내 분석에 없음) | 결산 코멘트 저장 | **수용 권장** — FiscalPeriods에 `note TEXT nullable` 컬럼 1개 추가. 가계부에서도 "이번 달 특이사항" 메모 유용 |

**Grace 고유 GAP 중 주목할 항목**:

1. **M-01 OCI 체계** (P1 즉시): Grace가 가장 우선순위 높게 잡음. 해외 자산 보유 시 외화환산차이가 OCI에 누적되므로, 다통화 가계부에서는 피할 수 없는 GAP. 내 반영안의 A-2(ExchangeRates.purpose 확장)와 **선행 의존 관계** — BALANCE_SHEET 환율로 외화 자산 재평가 시 차이가 OCI로 가야 함.
   - **제안**: OCI 계정 경로(`EQUITY.AOCI.*`)를 §12에 추가하되, OCI 자동 전표 생성은 EvaluateUnrealizedFxGain UseCase 확장으로 처리 (새 UseCase 불필요)

2. **M-02 재무비율 계산 엔진** (P1 즉시): 가계부에서도 순자산 증가율, 저축율 등 기본 비율은 필수. 29종 전체는 과하지만 **가계부 핵심 5종** (순자산증가율, 저축율, 부채비율, 유동비율, 투자수익률) 선별 권장.
   - **제안**: ReportQueryService에 `calculateRatios(PeriodId, List<RatioType>)` 메서드 추가. RatioType enum으로 선택적 계산.

3. **M-03 기간 간 비교** (P2 단기): MoM/QoQ/YoY 증감 — 가계부 대시보드 핵심 기능. 내 반영안에는 없으나 v2.0에서 반드시 필요.
   - **제안**: ReportQueryService에 `compareperiods(PeriodId current, PeriodId previous)` 추가. §7.1에 비교 쿼리 패턴 기술.

4. **M-09 세그먼트(SEGMENT)** (P3 중기): DimensionType에 SEGMENT 추가 — 내 반영안의 귀속구분2 GAP과 연결. `activityTypeOverride`처럼 `segmentOverride`를 JEL에 추가하면 통합 가능.

### Omar 분석(IFRS) 관련

Omar는 IFRS 패키지(58시트) 기반으로 광범위한 미커버를 식별했다. 기업 연결결산 전용 항목이 많아 가계부 직접 적용 범위가 좁지만, COA 분석이 매우 유용.

**중복 GAP (내 분석과 겹치는 항목)**:

| Omar 항목 | 내 항목 | 중복 내용 | 합치는 방법 |
|-----------|---------|-----------|-------------|
| HIGH 대손충당금+연령분석 (C6) | A-3 대손충당금 LegalParameter | 대손충당금 자동 판정 | **통합** — 내 반영안의 LegalParameter 시드 + Omar의 연령분석(30/60/90일) 결합. JEL.dueDate 필드 추가(내 시트5 GAP)가 전제 조건 |
| MEDIUM COA 유효기간(validFrom/validTo) | (없음 — 내 분석에서 미발견) | Account 활성/비활성의 시간적 관리 | **수용 권장** — 현재 `isActive: bool`을 `validFrom/validTo` 쌍으로 교체. 가계부에서도 "옛날 카드 계좌" 비활성화에 시간 이력 유용 |
| MEDIUM COA 외환평가 대상 태그(Col19) | A-2 ExchangeRates.purpose 확장 | 어떤 계정이 FX 재평가 대상인지 | **수용 권장** — `Account.isFxRevaluation: bool` 추가. EvaluateUnrealizedFxGain에서 이 태그 기반 대상 계정 자동 선정. 현재는 하드코딩 의심 |
| HIGH CF 보고서 생성 | (없음 — 내 담당 영역 아님) | 현금흐름표 UseCase | Grace 담당 영역과 겹침. Grace M-20(차트용 API)과 연계하여 **GenerateCashFlowStatement UseCase** 신설 필요 |
| MEDIUM 감가상각/무형자산 상각 UseCase | C-2 감가상각 자동전표 | 감가상각 계산 | **동일 GAP, 양쪽 독립 발견** — §15 확장 예약에 이미 있으므로 별도 제안 불필요 |

**Omar 고유 GAP 중 주목할 항목**:

1. **COA 10자리 숫자 코드 체계**: 현재 CW_ARCH는 Materialized Path를 문자열(`ASSET.CURRENT.CASH`)로 정의. Omar의 COA 분석에서 NAVER는 10자리 숫자 코드(`1101020110`). **두 체계 병존이 필요** — DimensionValues에 `code` 필드가 이미 있으나 형식 제약 없음. 숫자 코드 매핑은 가계부 MVP에서 불필요하나, §15에 예약 필요.

2. **COA Vendor 필수/선택/미설정 3단계**: `Account`에 `vendorRequired` 필드 — 거래처 입력 강제 수준. 가계부에서 "식비 계정 입력 시 거래처 필수" 같은 UX에 유용.
   - **제안**: B 우선순위로 `Account.counterpartyRequired: CounterpartyRequirement` (enum: required/optional/none) 추가 검토

3. **COA 채권/채무 3분류 태그(Col10)**: 현금(34)/채권채무(274)/수익비용(448) — 이 태그가 있으면 B/S vs P/L 계정을 자동 판별 가능. 현재는 `Account.nature`로 간접 추론.
   - **제안**: `Account.nature` (5분류)로 이미 커버 가능하므로 추가 필드 불필요. 다만 "현금" 태그는 `Account.isCashEquivalent: bool` 추가 가치 있음 (CF 생성 시 핵심)

### 3개 문서 통합 시 주의점

**1. Account 테이블 비대화 위험**

3개 반영안을 합치면 Account에 추가되는 필드가 과도해질 수 있음:
- 내 반영안: `isRevenueDeduction`, `isExcludedFromReport` (2개)
- Omar 제안 수용 시: `isFxRevaluation`, `validFrom/validTo` (3개)
- Grace 제안 수용 시: OCI 관련 계정 경로 (경로만, 필드 아님)

**대안**: 계정 속성 태그를 별도 테이블(`AccountTags`)로 분리하는 것도 고려. 하지만 MVP에서는 bool 필드 3~4개가 더 단순하므로 현 시점에서는 인라인 유지 권장.

**2. ExchangeRates.purpose 값 충돌**

내 반영안(`INCOME_STATEMENT/BALANCE_SHEET`)과 Omar의 COA 외환평가 태그가 서로 다른 레이어:
- `purpose`: 환율 자체의 용도 (어떤 환율을 쓸지)
- `isFxRevaluation`: 계정의 속성 (어떤 계정을 재평가할지)

→ **충돌 없음. 보완 관계.** 두 개 모두 필요.

**3. 우선순위 조정 제안**

3개 문서의 우선순위를 통합하면:

| 순위 | 항목 | 제안자 | 이유 |
|------|------|--------|------|
| **MVP 필수** | relatedPartyType | Arjun | 세무조정/주석 보고서 핵심 |
| **MVP 필수** | ExchangeRates.purpose 확장 | Arjun | K-IFRS 환율 이중성 |
| **MVP 필수** | 대손충당금 LegalParameter | Arjun+Omar | 세무조정 완성도 |
| **MVP 필수** | OCI 체계 (AOCI 경로) | Grace | 다통화 가계부 시 FX 차이 OCI 필수 |
| **단기** | 재무비율 엔진 (핵심 5종) | Grace | 대시보드 핵심 |
| **단기** | 기간 간 비교 (MoM/YoY) | Grace | 대시보드 핵심 |
| **단기** | referenceNo, reversalType | Arjun | 기능 완성도 |
| **단기** | Account 속성 (isRevenueDeduction, isExcludedFromReport, isFxRevaluation) | Arjun+Omar | 보고서 정확도 |
| **단기** | FiscalPeriod.note | Grace | 소규모 추가 |
| **단기** | Account validFrom/validTo | Omar | COA 시간 이력 |
| **중기** | legalCode, 세그먼트 | Arjun+Grace | 기업 확장 |
| **중기** | CF 보고서 생성 | Omar+Grace | 3대 재무제표 완성 |
| **장기** | InvestmentHolding, 감가상각, 결재선 등 | 전원 | §15 예약 |

**4. Drift 마이그레이션 순서**

3개 반영안의 스키마 변경을 한 번에 적용하면 build_runner 충돌 위험. **권장 순서**:
1. Counterparties 테이블 변경 (relatedPartyType, legalCode) — 나 담당
2. Transactions 테이블 변경 (referenceNo, reversalType) — 나 담당
3. Accounts 테이블 변경 (isRevenueDeduction, isExcludedFromReport + Omar 제안 필드) — 나+Omar 공동
4. ExchangeRates 변경 (purpose 값 확장) — 나 담당
5. FiscalPeriods 변경 (note 추가) — Grace 담당
6. OCI 계정 경로 시드 데이터 — Grace 담당
7. build_runner 일괄 실행

---

*반영안 + 교차 리뷰 작성 완료. 의장 리뷰 대기.*
