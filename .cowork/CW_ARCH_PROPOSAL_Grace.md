# 아키텍처 v2.0 반영안 — Grace (연결결산/재무제표)

> 근거: CW_ANALYSIS_Grace.md 26건 GAP (P1:2, P2:7, P3:7, P4:10)
> 대상: CW_ARCHITECTURE.md 전 섹션
> 작성: Grace-3 (2026-04-20)

---

## 1. 도메인 모델 변경

### 1.1 FiscalPeriod — 필드 추가 (M-08)

```dart
// 기존 FiscalPeriods 테이블에 추가
BoolColumn get isClosed => boolean().withDefault(const Constant(false))();
TextColumn get note => text().nullable()();  // 결산 코멘트 (비정형 텍스트)
```

**근거**: 시트2 Row 35-43, 시트3 결산보고에 결산 코멘트 존재. 현재 FiscalPeriods에 isClosed(W9 TODO), note 없음.

### 1.2 FinancialRatio — 신규 VO (M-02, M-12)

```dart
@freezed
abstract class FinancialRatio with _$FinancialRatio {
  const factory FinancialRatio({
    required String code,          // ROA|ROE|CURRENT_RATIO|DEBT_RATIO|...
    required String category,      // PROFITABILITY|STABILITY|ACTIVITY|GROWTH|VALUATION
    required int periodId,
    required int numerator,        // 분자 (최소단위 int)
    required int denominator,      // 분모 (최소단위 int)
    required int ratioValue,       // 배율 10000 (33.33% → 3333)
    DateTime? calculatedAt,
  }) = _FinancialRatio;
}
```

**근거**: 비율 시트 13종 구현 + 16종 미구현 = 29종. Rolling 12M 합산 필요.

### 1.3 PeriodComparison — 신규 VO (M-03)

```dart
@freezed
abstract class PeriodComparison with _$PeriodComparison {
  const factory PeriodComparison({
    required int currentValue,
    required int previousValue,
    required int changeAmount,     // current - previous
    required int changeRatio,      // 배율 10000 (5.25% → 525)
    required String comparisonType, // MOM|QOQ|YOY|YOY_ANNUAL
  }) = _PeriodComparison;
}
```

**근거**: 시트 1,2,3,7,11 모두 M/M, Q/Q, Y/Y, Y/Y연간 4종 증감 동시 제공.

### 1.4 OCI 관련 — AccountNature 확장 미필요, Materialized Path로 해결 (M-01)

OCI는 별도 AccountNature가 아니라 **EQUITY.OCI_ACCUMULATED** 하위의 Materialized Path + **REVENUE.OCI.*** / **EXPENSE.OCI.*** P/L 경유 경로로 표현.

기존 AccountNature 5종 (ASSET/LIABILITY/EQUITY/REVENUE/EXPENSE) 변경 없음. OCI 계정은 nature=EQUITY (누계액) 또는 nature=REVENUE/EXPENSE (당기 P/L 경유) 유지.

### 1.5 ReportLine — 신규 VO (M-01, M-07)

```dart
@freezed
abstract class ReportLine with _$ReportLine {
  const factory ReportLine({
    required String path,          // Materialized Path
    required String label,         // 표시명
    required int level,            // 표시 깊이 (0-based)
    required int balance,          // 잔액 (최소단위 int)
    required AccountNature nature,
    bool? isSubtotal,              // 소계 행 여부
    bool? isOci,                   // OCI 항목 여부
    bool? isDiscontinued,          // 중단사업 항목 여부
  }) = _ReportLine;
}
```

**근거**: B/S, P/L 보고서 생성 시 계속사업/중단사업 구분 + OCI 구분 필요.

---

## 2. Drift 스키마 변경

### 2.1 FiscalPeriods 테이블 — 컬럼 추가 (M-08)

```dart
class FiscalPeriods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();  // ★ 추가
  TextColumn get note => text().nullable()();                                  // ★ 추가
}
```

### 2.2 FinancialRatioSnapshots — 신규 테이블 (M-02)

```dart
// 재무비율 스냅샷 — 결산 시점 비율 결과 저장
class FinancialRatioSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(FiscalPeriods, #id)();
  TextColumn get ratioCode => text()();         // ROA|ROE|CURRENT_RATIO|DEBT_RATIO|...
  TextColumn get category => text()();          // PROFITABILITY|STABILITY|ACTIVITY|GROWTH|VALUATION
  IntColumn get numerator => integer()();       // 분자 (최소단위)
  IntColumn get denominator => integer()();     // 분모 (최소단위)
  IntColumn get ratioValue => integer()();      // 배율 10000
  DateTimeColumn get calculatedAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 2.3 DimensionValues — dimensionType 확장 (M-09)

기존:
```
EQUITY_TYPE | LIQUIDITY | ASSET_TYPE | ACTIVITY_TYPE | INCOME_TYPE
```

추가:
```
SEGMENT  // 사업부문 (네이버/라인/밴드/스노우/라인 및 기타)
```

> DimensionValues 테이블 자체 변경 불필요 — dimensionType 열에 새 값만 추가.
> JEL에 `segmentOverride` 컬럼 추가 필요:

```dart
// JournalEntryLines 테이블에 추가
IntColumn get segmentOverride => integer().nullable().references(DimensionValues, #id)();  // ★ 추가 (P3)
```

### 2.4 인덱스 추가 (섹션 4.2)

| 쿼리 패턴 | 테이블 | 인덱스 |
|-----------|--------|--------|
| 비율 조회 | FinancialRatioSnapshots | `(periodId, ratioCode)` |
| 기간별 비율 추이 | FinancialRatioSnapshots | `(ratioCode, periodId)` |

---

## 3. 신규 기능/UseCase

### 3.1 [P1] CalculateFinancialRatios — 재무비율 계산 엔진 (M-02)

```dart
/// 29종 재무비율 계산. Rolling 12M 합산 + 평균 산출 패턴.
class CalculateFinancialRatios {
  /// 구현 13종 (즉시)
  /// - 수익성: ROA, ROE
  /// - 안정성: 유동비율, 부채비율, 이자보상비율, 자본유보율
  /// - 활동성: 총자산회전율, 매출채권회전율, 채권회수기간, 자기자본회전율
  /// - 기타: 기부금비율
  /// - 주가: PER, EPS (외부 데이터 의존)
  ///
  /// 핵심 패턴:
  /// - 분자(순이익): Rolling 12M SUM — findByDateRange(date-12M, date) 합산
  /// - 분모(평균자산): (T잔액 + T-12잔액) / 2
  /// - 분모(평균매출채권): (T잔액 + T-12잔액) / 2
  Future<List<FinancialRatio>> execute({
    required DateTime asOfDate,
    required int periodId,
  });
}
```

위치: `lib/features/report/usecase/CalculateFinancialRatios.dart`

### 3.2 [P1] GenerateComprehensiveIncome — 총포괄이익 계산 (M-01)

```dart
/// 당기순이익 + OCI = 총포괄이익
/// OCI 항목: FVOCI평가/해외사업환산/지분법자본변동/보험수리적손익
class GenerateComprehensiveIncome {
  Future<ComprehensiveIncomeResult> execute({
    required int periodId,
    Perspective? perspective,
  });
}

@freezed
abstract class ComprehensiveIncomeResult with _$ComprehensiveIncomeResult {
  const factory ComprehensiveIncomeResult({
    required int netIncome,                  // 당기순이익
    required int continuingOperationsIncome,  // 계속사업손익
    required int discontinuedOperationsIncome, // 중단사업손익
    required List<ReportLine> listOciItems,  // OCI 항목 목록
    required int totalOci,                   // OCI 합계
    required int comprehensiveIncome,        // 총포괄이익 = NI + OCI
  }) = _ComprehensiveIncomeResult;
}
```

위치: `lib/features/report/usecase/GenerateComprehensiveIncome.dart`

### 3.3 [P2] ComparePeriods — 기간 비교 서비스 (M-03)

```dart
/// M/M, Q/Q, Y/Y, Y/Y연간 4종 증감 동시 계산
class ComparePeriods {
  /// 두 기간의 B/S 또는 P/L 잔액을 비교하여 증감액/증감률 반환
  Future<Map<String, PeriodComparison>> execute({
    required int currentPeriodId,
    required int previousPeriodId,
    required String reportType,  // BALANCE_SHEET|INCOME_STATEMENT
  });

  /// 특정 계정의 4종 비교를 한번에 반환
  Future<Map<String, PeriodComparison>> compareAll({
    required DateTime asOfDate,
    required String accountPath,
  });
}
```

위치: `lib/features/report/usecase/ComparePeriods.dart`

### 3.4 [P3] GenerateChartData — 차트용 데이터 변환 (M-20)

```dart
/// Long format + Wide format 피벗 데이터 생성
class GenerateChartData {
  /// Long format: List<{기간, 항목, 금액}>
  Future<List<ChartDataPoint>> generateLongFormat({
    required DateTime from,
    required DateTime to,
    required String granularity,  // MONTHLY|QUARTERLY
    required List<String> accountPaths,
  });

  /// Wide format: 기간을 열, 항목을 행으로 피벗
  Future<Map<String, Map<String, int>>> generatePivot({
    required DateTime from,
    required DateTime to,
    required String granularity,
    required List<String> accountPaths,
  });
}
```

위치: `lib/features/report/usecase/GenerateChartData.dart`

### 3.5 [P2] ReportQueryService 확장 (M-03, M-07)

기존 `ReportQueryService`에 메서드 추가:

```dart
/// 기존: calculateBalanceSheet(), calculateIncomeStatement(), buildTrialBalance()
/// 추가:
Future<int> calculateBalanceAsOf(String accountPath, DateTime date);  // 특정 계정 잔액 조회
Future<Map<String, int>> calculateBalancesByDateRange(DateTime from, DateTime to, String groupBy);  // 월별/분기별 집계
Future<int> sumByDateRange(String accountPath, DateTime from, DateTime to);  // Rolling N월 합산
```

---

## 4. 기존 섹션 수정

### 4.1 섹션 4.1 (Drift 스키마) 수정

**FiscalPeriods 테이블**:
```
기존: id, name, startDate, endDate
변경: id, name, startDate, endDate, isClosed, note  ← 2컬럼 추가
```

**신규 테이블 추가**: FinancialRatioSnapshots (섹션 4.1 하단)

**JournalEntryLines**: `segmentOverride` 컬럼 추가 (P3)

### 4.2 섹션 4.2 (인덱스 전략) 추가

| 쿼리 패턴 | 테이블 | 인덱스 |
|-----------|--------|--------|
| 비율 조회 | FinancialRatioSnapshots | `(periodId, ratioCode)` |
| 기간별 비율 추이 | FinancialRatioSnapshots | `(ratioCode, periodId)` |

### 4.3 섹션 7.2 (결산 스냅샷 5단계) 수정

**5단계 수정**:
```
기존 5단계: 스냅샷 저장 (B/S, P/L 잔액 + 세무조정 결과 + 기초 잔액 이월)
변경 5단계: 스냅샷 저장 (B/S, P/L 잔액 + OCI/총포괄이익 + 세무조정 결과 + 재무비율 29종 + 기초 잔액 이월)
            → FiscalPeriods.isClosed = true, FinancialRatioSnapshots 기록
```

**2단계 확장 (OCI 자동전표)**:
```
기존 2단계: 외환 평가 + 감가상각
추가: OCI 항목 자동 전표 — FVOCI 평가손익 / 해외사업환산손익 등
     (계정 nature=EQUITY, path LIKE 'EQUITY.OCI_ACCUMULATED.%' → OCI 집계 대상)
```

### 4.4 섹션 7 하단 — 신규 7.4 추가

```markdown
### 7.4 재무비율 계산 (29종)

#### 7.4.1 비율 공식

| 카테고리 | 코드 | 공식 | 출처 | 비고 |
|---------|------|------|------|------|
| 수익성 | ROA | Rolling12M(순이익) / 평균(총자산) | PL+BS | 분자: 12M합산, 분모: (T+T-12)/2 |
| 수익성 | ROE | Rolling12M(순이익) / 평균(자기자본) | PL+BS | 동일 |
| 안정성 | CURRENT_RATIO | 유동자산 / 유동부채 | BS | 시점 잔액 |
| 안정성 | DEBT_RATIO | 부채 / 자기자본 | BS | 시점 잔액 |
| 안정성 | INTEREST_COVERAGE | 영업이익 / 이자비용 | PL | 당기 발생액 |
| 안정성 | CAPITAL_RESERVE | (이익잉여금+자본잉여금) / 납입자본금 × 100 | BS | |
| 활동성 | ASSET_TURNOVER | Rolling12M(매출) / 총자산 | PL+BS | |
| 활동성 | AR_TURNOVER | Rolling12M(매출) / 평균(매출채권) | PL+BS | |
| 활동성 | AR_DAYS | 365 / AR_TURNOVER | 파생 | |
| 활동성 | EQUITY_TURNOVER | Rolling12M(매출) / 자기자본 | PL+BS | |
| 기타 | DONATION_RATIO | 기부금 / 매출 | PL | |
| 주가 | PER | 주가 / EPS | 외부 | LegalParameter 또는 수동 입력 |
| 주가 | EPS | Rolling12M(순이익) / 주식수 | PL+외부 | |

#### 7.4.2 Rolling 12M 패턴

- 분자(순이익/매출): `SUM(JEL.baseAmount) WHERE t.date BETWEEN (asOfDate - 12M) AND asOfDate`
- 분모(평균자산): `(잔액(asOfDate) + 잔액(asOfDate - 12M)) / 2`
- 매출채권 평균도 동일 패턴

#### 7.4.3 계산 시점

- 대시보드: 온디맨드 (실시간 계산, 캐시 없음)
- 결산 5단계: FinancialRatioSnapshots에 영구 저장
```

### 4.5 섹션 9.1 (BLoC 설계) — ReportBloc 이벤트 추가

```
기존: LoadDashboard, LoadReport, ChangeReportPeriod, RefreshExchangeRates
추가: LoadFinancialRatios, ComparePeriods(type: MOM|QOQ|YOY), LoadChartData
```

### 4.6 섹션 12.1 (계정과목 표준 체계) — 대폭 확장

**자본 분류 수정**:
```
기존: 자본금 + 이익잉여금 + 기타자본
변경: 자본금(보통주/우선주) + 자본잉여금(7종) + 기타자본구성요소(6종) + 기타포괄손익누계액(17종) + 이익잉여금(5종) + 비지배지분
```

**자산 유동 추가**:
```
추가: FVTPL / FVOCI / 상각후원가 / 파생금융상품 / 매도가능(구IFRS) / 만기보유(구IFRS)
      매각예정자산 (IFRS 5)
```

**자산 비유동 추가**:
```
추가: 투자부동산(L4 3종) / 관계기업투자 / 장기 FVTPL/FVOCI/상각후원가/매도가능/만기보유
      장기성매출채권및기타채권(L4 6종)
```

**부채 추가**:
```
추가: 유동성금융리스부채 / 미지급소비세(일본) / 미지급영업세및부가세 / 파생금융부채
      매각예정부채(IFRS 5)
      충당부채 L4 세분류(제품보증/소송/포인트/반품/기타)
```

**수익/비용 추가**:
```
추가: 지분법평가이익/손실 / FVTPL평가이익/손실 / 파생거래이익/손실
      OCI 경유 항목 (FVOCI평가/해외사업환산/지분법자본변동/보험수리적)
      중단사업수익/비용
```

> 상세 Materialized Path: CW_ANALYSIS_Grace.md "계정과목 표준 체계 보완" 섹션 참조 (약 80개 경로)

### 4.7 섹션 15 (확장 예약) — 추가

```
| 영역 | 예약 사항 |
|------|-----------|
| OCI 17종 | EQUITY.OCI_ACCUMULATED.* 하위 17개 Path (v2.0에서 정의, 시드 데이터는 점진 추가) |
| 재무비율 엔진 | FinancialRatioSnapshots 테이블 + CalculateFinancialRatios UseCase |
| 기간 비교 4종 | ComparePeriods UseCase (MOM/QOQ/YOY/YOY_ANNUAL) |
| 차트 데이터 | GenerateChartData UseCase (Long + Pivot) |
| 사업부문 세그먼트 | DimensionType SEGMENT + JEL.segmentOverride (P3) |
| 매각예정 자산/부채 | IFRS 5 경로 + Transaction.isDiscontinued 플래그 (P3) |
| 미구현 비율 16종 | ROIC/EBITDA마진/성장성3종/안정성5종/활동성5종 (P4) |
| 외부 데이터 | PER/EPS용 주가/주식수 — LegalParameter key='STOCK_PRICE'/'SHARES_OUTSTANDING' (P4) |
```

### 4.8 섹션 2.5 (Repository 인터페이스) — 추가

```dart
/// 재무비율 스냅샷 저장소
abstract interface class IFinancialRatioRepository {
  Future<List<FinancialRatio>> findByPeriod(int periodId);
  Future<FinancialRatio?> findByPeriodAndCode(int periodId, String ratioCode);
  Future<List<FinancialRatio>> findTrend(String ratioCode, {int limit = 12});
  Future<void> save(FinancialRatio);
  Future<void> saveAll(List<FinancialRatio>);
}
```

---

## 5. 우선순위별 분류

### MVP 필수 (P1 — 즉시 구현)

| GAP | 변경 내용 | 영향 범위 |
|-----|----------|----------|
| M-01 OCI 체계 | 섹션 12.1 계정 경로 확장 (OCI 17종 + P/L OCI 11종) + GenerateComprehensiveIncome UseCase + 결산 2단계 OCI 자동전표 + ReportLine VO isOci 플래그 | 도메인 VO 1개, UseCase 1개, 시드 데이터, 결산 프로세스 |
| M-02 재무비율 엔진 | FinancialRatioSnapshots 테이블 + CalculateFinancialRatios UseCase (13종) + IFinancialRatioRepository + 섹션 7.4 신규 | 테이블 1개, UseCase 1개, Repository 1개, VO 1개 |

### 단기 (P2 — 소규모 추가)

| GAP | 변경 내용 | 영향 범위 |
|-----|----------|----------|
| M-03 기간 비교 4종 | ComparePeriods UseCase + PeriodComparison VO + ReportQueryService 확장 3메서드 | UseCase 1개, VO 1개 |
| M-04 비지배지분 | EQUITY.MINORITY_INTEREST 경로 추가 (시드 데이터만) | 시드 데이터 |
| M-05 충당부채 경로 | LIABILITY.*.PROVISIONS.* L4 5세분류 경로 추가 | 시드 데이터 |
| M-06 이익잉여금 5종 | EQUITY.RETAINED_EARNINGS.* 5하위 경로 추가 | 시드 데이터 |
| M-07 중단사업손익 | 계속사업/중단사업 이원 구조 — ReportLine.isDiscontinued + GenerateIncomeStatement 수정 | VO 필드 1개, UseCase 수정 |
| M-08 FiscalPeriod 확장 | isClosed + note 컬럼 2개 추가 | 테이블 수정 |
| M-19 매각예정자산/부채 | ASSET.CURRENT.ASSETS_HELD_FOR_SALE + LIABILITY.CURRENT.HELD_FOR_SALE 경로 | 시드 데이터 |

### 중기 (P3 — 도메인 확장)

| GAP | 변경 내용 | 영향 범위 |
|-----|----------|----------|
| M-09 사업부문 세그먼트 | DimensionType SEGMENT + JEL.segmentOverride + Accounts.defaultSegmentId | 스키마 수정 2건 |
| M-10 지분법 | 지분법평가손익 자동전표 + 결산 2단계 확장 | UseCase 수정 |
| M-11 IFRS 9 금융자산 3분류 | FVTPL/FVOCI/상각후원가 경로 전수 정의 (구 IFRS 병존) | 시드 데이터 대량 |
| M-12 Rolling 12M | ReportQueryService.sumByDateRange() + 평균 산출 헬퍼 | 서비스 수정 |
| M-13 투자부동산 | ASSET.NON_CURRENT.INVESTMENT_PROPERTY (L4 3종) + 감가상각 확장 | 시드 데이터, UseCase 수정 |
| M-20 차트 데이터 | GenerateChartData UseCase (Long + Pivot) | UseCase 1개 |
| M-21 지급수수료 5레벨 | Materialized Path 최대 깊이 5 지원 확인 (현행 제한 없으면 시드만) | 시드 데이터 |

### 장기 예약 (P4 — MVP 범위 초과)

| GAP | 변경 내용 | 비고 |
|-----|----------|------|
| M-14 이연법인세 | 유동/비유동 이연법인세자산/부채 경로 | 기업 전용 |
| M-15 파생 헤지 회계 | Cash Flow Hedge / Fair Value Hedge OCI | 전문 투자자 |
| M-16 연결범위 관리 | 200법인/14통화/12구분/Level 6 | 기업 전용 |
| M-17 주식보상비용 | IFRS 2 | 기업 전용 |
| M-18 전환권/신주인수권 | 기타자본구성요소 세부 | 기업 전용 |
| M-22 미구현 비율 16종 | ROIC/EBITDA마진/성장성/안정성/활동성 추가 | 점진 확장 |
| M-23 외부 데이터 연동 | 주가/주식수 → PER/EPS | LegalParameter 활용 |
| M-24 국가/지역 속성 | Counterparty region 필드 | 소규모 |
| M-25 계열별 법인수 추이 | 계열(그룹)별 변동 추적 | 기업 전용 |

---

## 6. 변경 영향 요약

### 스키마 변경 (Drift migration 필요)

| 대상 | 변경 | 우선순위 |
|------|------|---------|
| FiscalPeriods | +isClosed (bool), +note (text?) | P2 |
| FinancialRatioSnapshots | 신규 테이블 | P1 |
| JournalEntryLines | +segmentOverride (int? FK) | P3 |

### 신규 UseCase

| UseCase | 위치 | 우선순위 |
|---------|------|---------|
| CalculateFinancialRatios | features/report/usecase/ | P1 |
| GenerateComprehensiveIncome | features/report/usecase/ | P1 |
| ComparePeriods | features/report/usecase/ | P2 |
| GenerateChartData | features/report/usecase/ | P3 |

### 기존 UseCase 수정

| UseCase | 수정 내용 | 우선순위 |
|---------|----------|---------|
| GenerateIncomeStatement | 계속/중단사업 구분 + OCI 항목 반환 | P1-P2 |
| RunSettlement | 5단계에 비율 저장 추가 + 2단계 OCI 자동전표 | P1 |
| ReportQueryService | +calculateBalanceAsOf, +sumByDateRange, +calculateBalancesByDateRange | P2 |

### 신규 Repository 인터페이스

| Interface | 우선순위 |
|-----------|---------|
| IFinancialRatioRepository | P1 |

### 시드 데이터 (Materialized Path)

| 범위 | 경로 수 | 우선순위 |
|------|--------|---------|
| OCI 17종 (EQUITY.OCI_ACCUMULATED.*) | 17 | P1 |
| 이익잉여금 5종 | 5 | P2 |
| 비지배지분 | 1 | P2 |
| 충당부채 L4 세분류 | 10 | P2 |
| 매각예정자산/부채 | 2 | P2 |
| 수익/비용 OCI 경유 + 지분법 + 파생 + 중단사업 | ~20 | P1-P2 |
| IFRS 9 금융자산 3분류 (유동+비유동) | ~15 | P3 |
| 투자부동산 L4 | 3 | P3 |
| 합계 | ~73 | |

---

## 7. 구현 순서 제안

```
Phase 1 (P1, 즉시):
  1. FiscalPeriods 스키마 확장 (isClosed + note)
  2. FinancialRatioSnapshots 테이블 생성
  3. OCI 17종 + P/L OCI 계정 시드 데이터
  4. GenerateComprehensiveIncome UseCase
  5. CalculateFinancialRatios UseCase (13종)
  6. RunSettlement 5단계 수정 (비율 저장 + OCI)

Phase 2 (P2, 단기):
  7. ComparePeriods UseCase
  8. ReportQueryService 확장 (3메서드)
  9. 시드 데이터 (비지배지분/충당부채/이익잉여금/매각예정)
  10. GenerateIncomeStatement 수정 (계속/중단사업)

Phase 3 (P3, 중기):
  11. SEGMENT DimensionType + JEL.segmentOverride
  12. GenerateChartData UseCase
  13. IFRS 9 금융자산 경로 시드
  14. 투자부동산 경로 + 감가상각 연동
```

---

## 8. 교차 리뷰 의견

### Arjun 분석(특수관계자) 관련

**중복 GAP 3건**:

| Arjun GAP | Grace GAP | 합치는 방법 |
|-----------|-----------|------------|
| A-1 `Counterparty.relatedPartyType` 5단계 | 내 분석에는 없음 (연결결산에서는 부문별 분리만) | **Arjun 주도로 Counterparty 스키마 확장. Grace 영역에서는 Counterparty 참조만 하므로 충돌 없음** |
| A-2 `ExchangeRates.purpose` 확장 (INCOME_STATEMENT/BALANCE_SHEET) | M-01 OCI + M-02 재무비율에서 환율 구분 필요 | **공동 관심사. Arjun이 AVERAGE/COMPANY 발견, 내가 P/L vs B/S 환산 용도 발견. purpose 값을 `ACCOUNTING|TAX|INCOME_STATEMENT|BALANCE_SHEET` 4종으로 통합 제안** |
| A-3 `LegalParameter` 대손충당금 | M-05 충당부채 경로와 연관 | **Arjun이 대손충당금 LegalParameter 추가, Grace가 충당부채 Materialized Path 추가 — 상호 보완적, 충돌 없음** |

**좋은 아이디어**:
- `Account.isRevenueDeduction` (B-2): 매출차감 계정 플래그 — 순액 표시 P/L에서 유용. 내 GenerateIncomeStatement 수정 시 이 플래그 활용 가능
- `Account.isExcludedFromReport` (B-5): 주석 범위 제외 계정 — 내 ReportQueryService에서 필터링 조건으로 쓸 수 있음
- `Transactions.referenceNo` (B-1): 내 반영안에 없으나, 카드승인번호/이체번호 저장에 유용 — 가계부 MVP에도 가치 있음

**주의사항**:
- Arjun의 `InvestmentHolding` 테이블(C-1)과 내 M-10(지분법 투자 처리)은 같은 도메인이나 접근이 다름. Arjun은 법인 간 지분율 테이블, 나는 결산 자동전표. **통합 시 InvestmentHolding이 기반이 되고 결산 UseCase가 그 위에 올라가는 구조가 맞음**
- Arjun의 `Counterparty.legalCode` (B-4, N/B/I/L/E)는 기업 전용 — 가계부 MVP에서는 skip 합의 필요

### Omar 분석(IFRS) 관련

**중복 GAP 6건 (상당히 많음)**:

| Omar GAP | Grace GAP | 합치는 방법 |
|----------|-----------|------------|
| HIGH: CF 보고서 생성 (7분류, 113 C코드) | 내 분석에 CF 없음 | **Omar 주도. 내 ReportQueryService 확장(sumByDateRange 등)이 CF 데이터 제공 기반이 됨** |
| HIGH: 자본변동표(CE) 생성 | M-01 OCI 체계 | **직접 중복. Omar의 CE 시트가 자본 5구성요소+OCI 5항목 롤포워드를 정의. 내 OCI 17종 Path + GenerateComprehensiveIncome이 CE의 구성요소가 됨. 통합: Grace가 OCI Path/VO, Omar가 CE UseCase 담당** |
| HIGH: 이연법인세 | M-14 (내 P4) | **동일 GAP. 둘 다 P4/장기로 분류** |
| MEDIUM: 감가상각/무형자산 상각 UseCase | M-13 투자부동산 상각 | **부분 중복. Omar의 C9-(1) 유형자산 7분류 + C10 무형자산 5분류 롤포워드가 상위 개념. 내 투자부동산은 그 확장** |
| MEDIUM: 충당부채 롤포워드 (15컬럼) | M-05 충당부채 경로 | **보완적. 내가 Path 정의, Omar가 UseCase(롤포워드 변동 추적) 담당** |
| LOW: OCI 처리 | M-01 OCI 체계 | **동일 GAP. Omar도 LOW로 분류했으나 내가 P1으로 올림 — 가계부에서 해외 금융자산 보유 시 즉시 필요하므로 P1이 맞음** |

**좋은 아이디어**:
- **COA 6레벨 + 10자리 숫자 코드 체계** (Omar COA 시트): 현재 Materialized Path는 문자열(`ASSET.CURRENT.CASH`)이지만, NAVER GCOA처럼 숫자 코드(`1101020110`)를 병행하면 외부 시스템 연동에 유리. 단, MVP에서는 문자열 Path 유지가 적절 — `Account.externalCode` nullable 필드 정도로 예약
- **COA 외환평가 대상 태그 (Col19, 17건)**: 내 EvaluateUnrealizedFxGain UseCase에서 FX 재평가 대상 계정을 식별할 때 유용. 현재는 `originalCurrency != baseCurrency` 조건으로 필터하지만, 계정 레벨 태그가 더 정확
- **COA Vendor 필수/선택 3단계**: `Account.requiresCounterparty` enum (`NONE|OPTIONAL|REQUIRED`) — 거래처 입력 강제 수준. 가계부에서도 "식비 → 거래처 선택 권장" 같은 UX에 활용 가능
- **SAD 조정분개 분리**: `Transaction.source`에 `SYSTEM_AUDIT_ADJUSTMENT` 값 추가 — 감사인 수정 vs 일반 전표 구분

**주의사항**:
- Omar의 COA 유효기간 (`validFrom`/`validTo`)과 현재 `Account.isActive` boolean은 충돌. **통합 방안: Account에 validFrom/validTo 추가하고 isActive는 computed getter (`validTo == null || validTo > now`)로 전환. 이전 구현 코드 영향 확인 필요**
- Omar가 COA `채권/채무` 3분류 (현금/채권채무/수익비용)를 발견 — 내 ReportQueryService에서 B/S 계정과 P/L 계정 구분에 유용하나, 현재 nature(ASSET/LIABILITY vs REVENUE/EXPENSE)로 충분히 구분 가능. 중복 우려

### 3개 문서 통합 시 주의점

**1. OCI 주도권 충돌 위험**:
- Grace: M-01 (P1) — OCI 17종 Path + GenerateComprehensiveIncome
- Omar: LOW — OCI 처리 (AFS/보험수리적)
- **제안**: Grace가 OCI Path 정의 + P/L 반영 UseCase, Omar가 자본변동표(CE) UseCase 담당. OCI는 P/L과 B/S 양면이므로 인터페이스(VO)를 공유해야 충돌 방지

**2. Counterparty 스키마 확장 일원화**:
- Arjun: relatedPartyType + legalCode + ownershipRatio + functionalCurrency (4필드)
- Grace: 내 분석에서는 Counterparty 변경 없음
- Omar: 내 분석에서도 Counterparty 변경 없음
- **제안**: Counterparty 스키마 변경은 Arjun 반영안에 일원화. Grace/Omar는 Arjun이 추가한 필드를 읽기 전용으로 참조

**3. Account 테이블 과부하 위험**:
- Arjun: +isRevenueDeduction, +isExcludedFromReport (2필드)
- Grace: 직접 추가 없으나 OCI/충당부채 등 ~73개 시드 Path
- Omar: +externalCode(숫자코드), +validFrom/validTo, +requiresCounterparty, +fxRevaluationTarget (4필드)
- **합산하면 Account에 6필드 추가**. 대부분 nullable이므로 기존 코드 영향은 적으나, Drift 마이그레이션 한 번에 처리 권장

**4. ExchangeRates.purpose 값 통합**:
- 현재: `ACCOUNTING | TAX` (2값)
- Arjun: `INCOME_STATEMENT | BALANCE_SHEET` 추가 필요
- Omar: (명시 언급 없으나 평균환율/기말환율 구분 필요)
- **통합 제안**: `ACCOUNTING | TAX | AVERAGE | CLOSING` (4값). AVERAGE = 기간 평균(P/L 환산), CLOSING = 기말(B/S 환산). INCOME_STATEMENT/BALANCE_SHEET보다 회계 용어에 가까움

**5. 우선순위 조정 제안**:

| 항목 | Grace | Arjun | Omar | 통합 제안 |
|------|-------|-------|------|----------|
| OCI 체계 | P1 | 미언급 | LOW | **P1** — 가계부 핵심 (해외 투자 사용자) |
| 재무비율 엔진 | P1 | 미언급 | 미언급 | **P1** — 대시보드 핵심 기능 |
| CF 보고서 | 미언급 | 미언급 | HIGH | **P2** — B/S+P/L 다음 순서 |
| 자본변동표 | 미언급 | 미언급 | HIGH | **P2** — OCI 완성 후 자연 확장 |
| relatedPartyType | 미언급 | A(MVP) | 미언급 | **P2** — 가계부 특수관계자 거래는 낮은 빈도 |
| Transactions.referenceNo | 미언급 | B(기능) | 미언급 | **P2** — 카드승인번호 저장, 모든 사용자 해당 |
| ExchangeRates.purpose 확장 | P3(OCI 부속) | A-2(MVP) | 미언급 | **P1** — OCI와 함께 가야 함 |
| 감가상각 UseCase | P3 | C-2(장기) | MEDIUM | **P3** — 결산 2단계 확장 |
| InvestmentHolding | P4(장기) | C-1(장기) | 미언급 | **P4** — 합의 |
| COA validFrom/validTo | 미언급 | 미언급 | MEDIUM | **P3** — isActive 전환 영향도 검토 필요 |

**6. 구현 순서 권장 (3개 통합)**:

```
Phase 1: OCI Path(Grace) + 비율엔진(Grace) + purpose확장(Arjun+Grace)
Phase 2: CF(Omar) + CE(Omar) + referenceNo(Arjun) + relatedPartyType(Arjun) + 기간비교(Grace)
Phase 3: 감가상각(Omar+Grace) + 세그먼트(Grace) + COA확장(Omar) + 충당부채롤포워드(Omar+Grace)
Phase 4: InvestmentHolding(Arjun) + 이연법인세(Omar) + 파생헤지(Grace) + 연결범위(Grace)
```
