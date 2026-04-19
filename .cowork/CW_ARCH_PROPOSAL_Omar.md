# 아키텍처 v2.0 반영안 — Omar (IFRS COA/CF/CE)

> 작성자: Omar-3 | 작성일: 2026-04-20
> 근거: CW_ANALYSIS_Omar.md 미커버 항목 (HIGH:4, MEDIUM:10, LOW:6)
> 대상: CW_ARCHITECTURE.md 섹션별 수정 제안

---

## 1. 도메인 모델 변경

### 1.1 Account 엔티티 — 필드 추가 (6개)

| 신규 필드 | 타입 | 설명 | 근거 |
|-----------|------|------|------|
| `validFrom` | `DateTime` | 계정 유효 시작일 | COA Col08 — 1,918개 계정 전체에 유효기간 존재 |
| `validTo` | `DateTime` | 계정 유효 종료일 | COA Col09 — isActive boolean만으로 이력 추적 불가 |
| `cashFlowCategory` | `CashFlowCategory?` (enum) | 현금/채권채무/수익비용/null | COA Col10 — CF 보고서 자동 분류 근거 (34+274+448건) |
| `isFxRevalTarget` | `bool` | FX 재평가 대상 여부 | COA Col19 — 17개 계정, 결산 외환평가 자동 선별 |
| `vendorRequirement` | `VendorRequirement` (enum) | 거래처 입력 필수/선택/미설정 | COA Col21 — 거래 입력 시 Counterparty 검증 수준 |
| `counterpartyInputLevel` | — | vendorRequirement로 통합 | — |

**신규 enum**:
```dart
enum CashFlowCategory { cash, receivablePayable, revenueExpense }
enum VendorRequirement { notSet, optional, required }
```

**기존 필드 변경**:
- `isActive: bool` → 유지하되, `validFrom/validTo`에서 파생 가능. 런타임 편의용으로 보존.

### 1.2 Transaction 엔티티 — 필드 추가 (1개)

| 신규 필드 | 타입 | 설명 | 근거 |
|-----------|------|------|------|
| `adjustmentType` | `AdjustmentType?` (enum) | 일반/결산/감사수정(SAD) | A①BS/A②PL Col18 SAD — 조정분개 분리 |

```dart
enum AdjustmentType { normal, settlement, auditAdjustment }
```

### 1.3 신규 도메인 엔티티

#### CashFlowCode (VO)
```dart
/// CF 보고서용 코드 체계 — NAVER C코드 참조 (113개)
@freezed
class CashFlowCode with _$CashFlowCode {
  const factory CashFlowCode({
    required String code,          // "C100000" ~ "C7000000"
    required String name,          // "Cash flows from operating activities"
    String? parentCode,            // 상위 코드
    required CfAccountIndex indexType,  // aggregate/actual/automatic
    required int level,            // 1~4
  }) = _CashFlowCode;
}

enum CfAccountIndex { aggregate, actual, automatic }
```

#### CashFlowLineItem (VO)
```dart
/// CF 보고서 개별 항목 — 코드 + 금액
@freezed
class CashFlowLineItem with _$CashFlowLineItem {
  const factory CashFlowLineItem({
    required CashFlowCode code,
    required int amount,           // 최소 단위 int
  }) = _CashFlowLineItem;
}
```

#### EquityChangeItem (VO)
```dart
/// CE(자본변동표) 행 항목
@freezed
class EquityChangeItem with _$EquityChangeItem {
  const factory EquityChangeItem({
    required EquityChangeType changeType,
    required int capitalStock,
    required int capitalSurplus,
    required int otherCapital,
    required int aoci,             // 기타포괄손익누계액
    required int retainedEarnings,
  }) = _EquityChangeItem;
}

enum EquityChangeType {
  beginningBalance,
  netIncome,
  ociAfsValuation,
  ociCurrencyDifference,
  ociEquityMethod,
  ociActuarial,
  dividends,
  treasuryStock,
  other,
  endingBalance,
}
```

#### DeferredTaxItem (VO)
```dart
/// 이연법인세 일시적 차이 항목
@freezed
class DeferredTaxItem with _$DeferredTaxItem {
  const factory DeferredTaxItem({
    required String sourceDescription,   // 일시적 차이 원천
    required int temporaryDifference,    // 일시적 차이 금액
    required int deferredTaxAsset,       // DTA
    required int deferredTaxLiability,   // DTL
    required DateTime asOfDate,
  }) = _DeferredTaxItem;
}
```

---

## 2. Drift 스키마 변경

### 2.1 Accounts 테이블 — 컬럼 추가

```dart
// 기존 Accounts 테이블에 추가
DateTimeColumn get validFrom => dateTime().withDefault(Constant(DateTime(1999, 1, 1)))();
DateTimeColumn get validTo => dateTime().withDefault(Constant(DateTime(2999, 12, 31)))();
TextColumn get cashFlowCategory => text().nullable()();     // cash|receivablePayable|revenueExpense
BoolColumn get isFxRevalTarget => boolean().withDefault(const Constant(false))();
TextColumn get vendorRequirement => text().withDefault(const Constant('notSet'))();  // notSet|optional|required
```

### 2.2 Transactions 테이블 — 컬럼 추가

```dart
// 기존 Transactions 테이블에 추가
TextColumn get adjustmentType => text().withDefault(const Constant('normal'))();  // normal|settlement|auditAdjustment
```

### 2.3 신규 테이블: CashFlowCodes

```dart
/// CF 보고서 코드 마스터 (시드 데이터 113행)
class CashFlowCodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()();              // "C100000"
  TextColumn get name => text()();              // "Cash flows from operating activities"
  TextColumn get parentCode => text().nullable()();  // 상위 코드
  TextColumn get indexType => text()();         // aggregate|actual|automatic
  IntColumn get level => integer()();           // 1~4
  IntColumn get sortOrder => integer()();
}
```

### 2.4 신규 테이블: CashFlowMappings

```dart
/// Account → CF 코드 매핑 (Account.cashFlowCategory 기반 자동 + 수동 오버라이드)
class CashFlowMappings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  TextColumn get cfCode => text()();            // CashFlowCodes.code 참조
  BoolColumn get isAutomatic => boolean().withDefault(const Constant(true))();
}
```

### 2.5 신규 테이블: SettlementSnapshots — 확장

```dart
/// 결산 스냅샷 — 기존 "Step5 스냅샷 저장"의 구체화
class SettlementSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(FiscalPeriods, #id)();
  TextColumn get snapshotType => text()();      // BS|PL|CF|CE|TAX
  TextColumn get data => text()();              // JSON — 보고서 데이터
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 2.6 신규 테이블: DeferredTaxEntries

```dart
/// 이연법인세 일시적 차이 추적
class DeferredTaxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(FiscalPeriods, #id)();
  TextColumn get sourceDescription => text()();
  IntColumn get temporaryDifference => integer()();
  IntColumn get deferredTaxAsset => integer()();     // DTA 금액
  IntColumn get deferredTaxLiability => integer()();  // DTL 금액
  TextColumn get differenceType => text()();          // temporary|permanent
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 2.7 인덱스 추가

| 쿼리 패턴 | 테이블 | 인덱스 |
|-----------|--------|--------|
| FX 재평가 대상 | Accounts | `(isFxRevalTarget) WHERE isFxRevalTarget = true` |
| CF 분류 | Accounts | `(cashFlowCategory)` |
| 유효기간 조회 | Accounts | `(validFrom, validTo)` |
| 조정분개 필터 | Transactions | `(adjustmentType)` |
| CF 코드 정렬 | CashFlowCodes | `(sortOrder)` |
| 스냅샷 조회 | SettlementSnapshots | `(periodId, snapshotType)` |

---

## 3. 신규 기능/UseCase

### 3.1 HIGH — CF 보고서 생성

**UseCase**: `GenerateCashFlowStatement`
```
입력: PeriodId, Perspective?
처리:
  1. PL에서 당기순이익 가져오기 (C110000 — Automatic)
  2. Account.cashFlowCategory 기반으로 JEL 변동분 → CF 코드 자동 매핑
  3. CashFlowMappings 오버라이드 적용
  4. CashFlowCodes 계층 구조로 집계 (Aggregate 노드)
  5. 영업/투자/재무 3활동 + 환율효과 + 기초/기말현금 산출
출력: List<CashFlowLineItem> (113개 코드 중 유효 항목)
```

**영업활동 세부 분리** (C140~C170):
- C140 이자지급: JEL에서 이자비용 계정 + 실제 현금유출 매칭
- C150 이자수취: 이자수익 계정 + 현금유입
- C160 배당수취: 배당수익 계정
- C170 법인세납부: 법인세비용 계정

### 3.2 HIGH — 자본변동표 생성

**UseCase**: `GenerateEquityChangeStatement`
```
입력: PeriodId
처리:
  1. 기초잔액: 전기 스냅샷 또는 자본 계정 기초 잔액
  2. 당기순이익: PL에서 가져오기
  3. OCI 5항목: AOCI 계정별 변동 분해
     - AFS 평가손익, 외화환산차이, 지분법변동, 보험수리적손익
  4. 소유주 거래: 배당/자사주 등
  5. 기말잔액 = 기초 + 포괄손익 + 소유주거래
출력: List<EquityChangeItem> (5구성요소 x 변동유형)
```

### 3.3 HIGH — 이연법인세

**UseCase**: `CalculateDeferredTax`
```
입력: PeriodId
처리:
  1. 일시적 차이 식별: 회계 장부가 vs 세무 기준가 차이
  2. DTA/DTL 계산: 일시적 차이 × 적용세율
  3. 이연법인세 변동: 전기 vs 당기 차이
  4. DeferredTaxEntries 저장
출력: DeferredTaxSummary (DTA 합계, DTL 합계, 순액)
```

### 3.4 HIGH — 법인세 실효세율

**UseCase**: `CalculateEffectiveTaxRate`
```
입력: PeriodId
처리:
  1. 세전이익: PL 합산
  2. 이론 법인세: 세전이익 × LegalParameter("법인세_기본세율") 누진 계산
  3. 영구적 차이 조정: 손금불산입/익금불산입 항목
  4. 실효세율 = 실제 법인세비용 / 세전이익
출력: TaxRateSummary (세전이익, 이론세, 실효세율, 차이요인 목록)
```

### 3.5 MEDIUM — 감가상각/상각 UseCase

**UseCase**: `CalculateDepreciation`
```
입력: PeriodId, AssetCategory (유형7 + 무형6)
처리:
  1. 유형/무형 자산 계정에서 기초 취득원가, 누적상각 조회
  2. 상각 방법 (정액법 기본) × 내용연수 → 당기 상각비 계산
  3. 자동 결산 전표 생성 (차변: 감가상각비/무형자산상각비, 대변: 감가상각누계액)
출력: List<DepreciationEntry>
```

**기존 결산 Step2 확장 포인트 활성화**: 현재 "감가상각 (확장)" 주석만 존재 → 실체화

### 3.6 MEDIUM — 대손충당금

**UseCase**: `CalculateBadDebtAllowance`
```
입력: PeriodId
처리:
  1. 채권 계정(Account.cashFlowCategory == receivablePayable) 잔액 조회
  2. 연령분석: 거래일 기준 30/60/90/90일초과 구간별 분류
  3. 구간별 대손율 적용 (LegalParameter)
  4. 대손충당금 전표 자동 생성
출력: AllowanceSummary (구간별 채권잔액, 충당금 설정액)
```

---

## 4. 기존 섹션 수정

### 섹션 2.2 Account (AR) — 불변조건 추가

| # | 추가 불변조건 |
|---|-------------|
| INV-A6 | `validFrom < validTo` |
| INV-A7 | `validTo < now() → isActive = false` (자동 비활성화) |
| INV-A8 | `vendorRequirement == required → JEL 저장 시 counterpartyId 필수` |

### 섹션 2.5 Repository 인터페이스 — 추가 메서드

```dart
// IAccountRepository 추가
Future<List<Account>> findFxRevalTargets();  // isFxRevalTarget == true
Future<List<Account>> findByCashFlowCategory(CashFlowCategory);
Future<List<Account>> findValidAt(DateTime date);  // validFrom <= date <= validTo

// 신규 인터페이스
abstract interface class ICashFlowCodeRepository {
  Future<List<CashFlowCode>> findAll();
  Future<CashFlowCode?> findByCode(String code);
  Future<List<CashFlowCode>> findByParent(String parentCode);
}

abstract interface class IDeferredTaxRepository {
  Future<List<DeferredTaxItem>> findByPeriod(PeriodId);
  Future<void> save(DeferredTaxItem);
}

abstract interface class ISettlementSnapshotRepository {
  Future<void> saveSnapshot(PeriodId, String type, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> findSnapshot(PeriodId, String type);
}
```

### 섹션 4.1 핵심 테이블 — Accounts 테이블

기존 Accounts 정의 뒤에 5개 컬럼 추가: `validFrom`, `validTo`, `cashFlowCategory`, `isFxRevalTarget`, `vendorRequirement`

### 섹션 4.2 인덱스 전략 — 3건 추가

| 쿼리 패턴 | 테이블 | 인덱스 |
|-----------|--------|--------|
| FX 재평가 대상 | Accounts | `(isFxRevalTarget)` |
| CF 분류 | Accounts | `(cashFlowCategory)` |
| 조정분개 필터 | Transactions | `(adjustmentType)` |

### 섹션 7.1 실시간 집계 — CF 쿼리 패턴 추가

현재 B/S 패턴만 존재. CF 간접법 집계 SQL 패턴 추가:
```sql
-- CF 간접법 패턴: 운전자본 변동
SELECT a.cash_flow_category,
  SUM(CASE WHEN jel.entry_type='DEBIT' THEN jel.base_amount ELSE 0 END)
  - SUM(CASE WHEN jel.entry_type='CREDIT' THEN jel.base_amount ELSE 0 END) AS net_change
FROM journal_entry_lines jel
JOIN accounts a ON jel.account_id = a.id
JOIN transactions t ON jel.transaction_id = t.id
WHERE t.status = 'POSTED'
  AND t.period_id = :period_id
  AND a.cash_flow_category = 'receivablePayable'
GROUP BY a.cash_flow_category;
```

### 섹션 7.2 결산 스냅샷 5단계 → 7단계로 확장

```
1. 기말 마감 준비: Draft 잔존 검증, 시산표 자동 생성
2. 자동 결산 전표: 외환 평가 + 감가상각 + 무형자산 상각 + 대손충당금
3. 세무조정: 자동 판정 → 사용자 리뷰 → 확정
4. 이연법인세 계산: 일시적 차이 식별 → DTA/DTL 계산
5. 법인세 확정: 실효세율 계산 → 법인세비용 전표
6. 손익 마감: 수익/비용 → 손익요약 → 이익잉여금 대체
7. 스냅샷 저장: B/S + P/L + CF + CE + TAX 5종 스냅샷
```

### 섹션 9.1 BLoC — ReportBloc 이벤트 추가

| BLoC | 추가 이벤트 |
|------|------------|
| **ReportBloc** | `LoadCashFlowStatement`, `LoadEquityChangeStatement` |
| **TaxBloc** | `CalculateDeferredTax`, `CalculateEffectiveTaxRate` |

### 섹션 15. 확장 예약 — 활성화 항목

기존 "감가상각" 예약 → **활성화** (결산 Step2 확장 포인트 실체화)

추가 예약 항목:
| 영역 | 예약 사항 |
|------|-----------|
| OCI 5항목 | Account에 ociCategory 필드 예약 (AFS/FX/EquityMethod/Actuarial/Other) |
| 공정가치 계층 | Account에 fairValueLevel 필드 예약 (L1/L2/L3) |
| 유동성 만기 | Account에 maturityDate, interestRate 필드 예약 |
| 금융상품 롤포워드 | FinancialInstrumentChange 테이블 예약 (14컬럼 변동 추적) |
| 세그먼트 | Perspective로 대체 가능, 별도 세그먼트 P&L 불필요 |
| 계약부채 | Account.productType으로 "contractLiability" 태그 가능 |

---

## 5. 우선순위별 분류

### MVP 필수 (v2.0 — 즉시 반영)

| # | 항목 | 영향 범위 | 구현 규모 |
|---|------|---------|---------|
| 1 | Account 5필드 추가 (validFrom/validTo/cashFlowCategory/isFxRevalTarget/vendorRequirement) | Drift 스키마 + 도메인 | 소 |
| 2 | Transaction.adjustmentType 추가 | Drift 스키마 + 도메인 | 소 |
| 3 | CashFlowCodes 테이블 + 시드 데이터 | Drift 스키마 + 시드 | 중 |
| 4 | GenerateCashFlowStatement UseCase | features/report/ | 대 |
| 5 | GenerateEquityChangeStatement UseCase | features/report/ | 중 |
| 6 | 결산 5단계 → 7단계 확장 | features/report/ | 중 |

### 중기 (v2.1 — S08~S09)

| # | 항목 | 영향 범위 | 구현 규모 |
|---|------|---------|---------|
| 7 | CalculateDeferredTax + DeferredTaxEntries 테이블 | features/tax/ + Drift | 대 |
| 8 | CalculateEffectiveTaxRate | features/tax/ | 중 |
| 9 | CalculateDepreciation (유형7+무형6 분류) | features/report/ | 대 |
| 10 | CalculateBadDebtAllowance + 연령분석 | features/report/ | 중 |
| 11 | 충당부채 롤포워드 뷰 | features/report/ | 소 |
| 12 | 통화별 순포지션 뷰 (FX 리스크 매트릭스) | features/exchange/ | 소 |

### 장기 예약 (v3.0+ — 구현하지 않되 막히지 않도록)

| # | 항목 | 예약 방법 |
|---|------|---------|
| 13 | 공정가치 계층 (L1/L2/L3) | Account.countrySpecific JSON 슬롯 |
| 14 | 유동성 만기 매트릭스 | Account 확장 필드 예약 |
| 15 | OCI 처리 (5항목) | EquityChangeType enum 이미 포함 |
| 16 | 금융상품 통합 롤포워드 | FinancialInstrumentChange 테이블 예약 |
| 17 | 세그먼트 P&L | Perspective 기반 대체 |
| 18 | 계약부채 (포인트/선불금) | Account.productType 태그 |

---

## 6. 교차 리뷰 의견

### Arjun 분석(특수관계자 주석패키지) 관련

**중복 GAP**:
- **대손충당금**: Arjun A-3(LegalParameter 대손충당금 설정율 한도)과 내 MEDIUM(CalculateBadDebtAllowance) 완전 중복. 합칠 방법: 내 UseCase가 LegalParameter를 소비하는 구조이므로, Arjun이 LegalParameter 규칙 정의를, 내가 계산 로직을 담당하면 자연스럽게 통합됨.
- **감가상각 자동전표**: Arjun C-2(감가상각 자동전표)와 내 MEDIUM CalculateDepreciation 중복. 동일 UseCase.
- **Transaction.reversalType**: Arjun B-3(역분개대상/역분개처리 구분)은 내 Transaction.adjustmentType과 별개 필드. 둘 다 필요 — adjustmentType은 일반/결산/감사 분류, reversalType은 역분개 방향 분류.

**좋은 아이디어**:
- **Counterparty.relatedPartyType** (Arjun A-1): 5단계 분류(parent/subsidiary/associate/affiliate/other_related)는 가계부에서도 유용. "가족/친인척/직장/거래처/기타"로 변환하면 개인 가계부에서 특수관계 거래(예: 가족 간 대출) 추적에 활용 가능.
- **Account.isRevenueDeduction** (Arjun B-2): 순액 표시 계정 플래그. PL 보고서에서 수수료 매출차감 처리 시 필요. 내 CF 보고서에서도 순액/총액 구분에 영향.
- **Transactions.referenceNo** (Arjun B-1): 카드승인번호, OCR 추출 영수증번호 등 외부 참조. 가계부 MVP에서도 즉시 유용 — OCR에서 추출한 참조번호 저장용.

**주의사항**:
- Arjun의 legalCode(N/B/I/L/E)는 NAVER 그룹 전용 코드. 가계부에서는 Counterparty.identifier + identifierType으로 충분. 별도 legalCode 필드 추가는 과잉.

### Grace 분석(연결결산보고서) 관련

**중복 GAP**:
- **이연법인세 (Grace M-14 + 내 HIGH CalculateDeferredTax)**: 완전 중복. Grace는 "기업 전용, P4(후기)"로 분류했으나, 나는 "HIGH"로 분류. 의견: 가계부 MVP에서는 Grace 판단이 맞음. **중기~장기로 하향 조정 제안** — 개인에게 이연법인세는 거의 불필요.
- **OCI 체계 (Grace M-01 + 내 장기예약 #15)**: Grace는 P1(즉시)로 분류, 나는 장기예약. **절충안: CE UseCase에 OCI 5항목 enum은 포함하되, 17개 하위 계정 경로 정의는 중기로.**
- **충당부채 (Grace M-05 + 내 MEDIUM 충당부채 롤포워드)**: 중복. Grace는 Account 경로 정의(L4 세분류), 나는 변동 추적(15컬럼). 합치면: Grace가 DimensionPath 경로를, 내가 롤포워드 뷰를 담당.
- **비지배지분 (Grace M-04)**: 가계부에서는 "공동명의 소유자 중 비주체 지분"으로 해석 가능. AccountOwnerShares 패턴으로 대응 가능하다는 Grace 의견에 동의.

**좋은 아이디어**:
- **재무비율 계산 엔진 (Grace M-02)**: 29종 비율 + Rolling 12M 이동합산. 가계부에서도 핵심 가치 — "내 재무 건강도" 대시보드. 내 CF/CE 보고서와 함께 ReportBloc에 통합하면 시너지. **MVP 포함 강력 추천.**
- **기간 간 비교 M/M, Q/Q, Y/Y (Grace M-03)**: 모든 보고서의 기본 기능. ReportQueryService에 `compareWithPrevious(period, comparisonType)` 메서드 1개로 해결.
- **FiscalPeriod.note (Grace M-08)**: 결산 코멘트 저장. FiscalPeriods 테이블에 `TextColumn get note` 1컬럼 추가로 해결. 비용 제로.
- **차트용 Long format API (Grace M-20)**: Graph 시트 패턴. 대시보드에 필수.

**주의사항**:
- Grace의 사업부문 세그먼트(M-09)는 NAVER 5종. 가계부에서는 Perspective가 이 역할을 충분히 대체. 별도 SEGMENT DimensionType 추가는 과잉.

### 3개 문서 통합 시 주의점

**1. Account 테이블 비대화 위험**:
- Omar: 5필드 추가 (validFrom/validTo/cashFlowCategory/isFxRevalTarget/vendorRequirement)
- Arjun: isRevenueDeduction, isExcludedFromReport 추가 가능
- Grace: 별도 추가 없으나 DimensionPath 경로 대폭 확장
- **위험**: Account 테이블이 20+ 컬럼으로 비대해짐. **대안**: 태그성 필드는 `countrySpecific` JSON 통합도 검토 필요. 다만 쿼리 성능(WHERE 조건)을 고려하면 별도 컬럼이 나음.

**2. 결산 프로세스 단계 충돌**:
- Omar: 5→7단계 (이연법인세+법인세확정 삽입)
- Grace: OCI 처리 + 비지배지분 배분 추가 가능
- **해결**: 결산을 "코어 5단계 + 확장 플러그인"으로 설계. 코어: 준비→결산전표→세무→손익마감→스냅샷. 플러그인: 감가상각, FX평가, 이연법인세, OCI 재분류 등을 Step2/Step4에 훅으로 삽입.

**3. 우선순위 조정 제안**:

| 항목 | Omar | Grace | Arjun | **통합 제안** |
|------|------|-------|-------|-------------|
| CF 보고서 | HIGH | — | — | **MVP** |
| CE 보고서 | HIGH | — | — | **MVP** |
| 재무비율 엔진 | — | P1 | — | **MVP** (가계부 핵심 가치) |
| 기간 비교 (M/M,Q/Q,Y/Y) | — | P2 | — | **MVP** (모든 보고서 기본) |
| referenceNo | — | — | B | **MVP** (OCR 영수증번호, 비용 제로) |
| FiscalPeriod.note | — | P2 | — | **MVP** (1컬럼, 비용 제로) |
| OCI 5항목 | 장기 | P1 | — | **중기** (CE에 필요, 17개 전체는 과잉) |
| 이연법인세 | HIGH | P4 | — | **장기** (개인 가계부 불필요) |
| relatedPartyType | — | — | A | **중기** (가계부 "가족/친인척" 변환 시 유용) |
| 감가상각 | MEDIUM | 예약 | C | **중기** (결산 Step2 확장) |
| 대손충당금 | MEDIUM | — | A | **중기** (LegalParam 규칙 + UseCase) |

**4. Drift 마이그레이션 순서 제안**:
1. **1차**: Account 필드 추가 (Omar 5 + Arjun 2) + Transaction 필드 (Omar 1 + Arjun 2) + FiscalPeriod.note
2. **2차**: 신규 테이블 (CashFlowCodes, CashFlowMappings, SettlementSnapshots)
3. **3차**: DimensionPath 경로 확장 (OCI 17개 + 충당부채 L4 + 이익잉여금 5종)

---

*반영안 작성 완료 + 교차 리뷰 추가 | Omar-3 | 2026-04-20*
