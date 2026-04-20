# CW_HANDOFF_Grace.md — Grace 인계 문서

> 담당: Grace (ExchangeRate + Report + Settlement + OCI + 재무비율 + FX순포지션)
> 워크트리: `E:/_Develop/dart/mymoney-wk-grace` (브랜치: `wk-v2-grace`)
> 최종 갱신: 2026-04-20 (Grace-3 Opus — v2.0 W7R~W14 구현 완료)

---

## 완료 이력

| Wave | 태스크 | 커밋 | 변경 파일 |
|------|--------|------|-----------|
| W7 보조 | CounterpartyPage UI | `c736a2b` | `lib/features/counterparty/presentation/CounterpartyPage.dart` (805줄) |
| W8 | ExchangeRate DAO/Repo + 환산/미실현손익 UseCase | `254a7e0` | 5개 파일 (DAO, Repo, 2 UseCases, Interface 수정) |
| W9 | 결산 프로세스 + ReportBloc (S08b) | `850519e` | 7개 파일 (QueryService, 3 UseCases, ReportBloc, 2 Pages) |
| QA | QA Loop 6 iterations (34건 수정) | `0713d18`~`3611b18` | enum 직렬화, SQL 리터럴, import 수정 |
| DOCS | 엑셀 연결결산보고서 11시트 분석 | `19d051c` | `.cowork/CW_ANALYSIS_Grace.md` |
| **W10** | **연결결산 11시트 컬럼 전수 대조** | 미커밋 | `.cowork/CW_ANALYSIS_Grace.md` (13건 신규 GAP 보강) |
| **W10** | **아키텍처 v2.0 반영안** | 미커밋 | `.cowork/CW_ARCH_PROPOSAL_Grace.md` |
| **W10** | **CW_ARCHITECTURE.md v2.0 집필** | 미커밋 | §7.4 비율 / §7.5 기간비교 / §9 BLoC / §12 OCI+K-IFRS 상세 / §4.1 FiscalPeriod+비율스냅샷 / §2.5 IFinancialRatioRepository |
| **W10** | **K-IFRS 표준 계정과목 리서치** | 미커밋 | `.cowork/CW_RESEARCH_KIFRS.md` (68경로 빠짐 식별) |
| **W10** | **TF 난상토론 3라운드 참여** | - | OCI P1 5종, 비율 8+5+16종, 세그먼트 Perspective 대체, CF 30코드 합의 |
| **W10** | **v2.0 P1~P4 전수 분류** | - | 52항목 (P1:21 / P2:11 / P3:8 / P4:12) |
| **W7R** | FX purpose 확장 + isFxRevalTarget 필터 | `e0ff334` | ExchangeRateDao.dart, EvaluateUnrealizedFxGain.dart |
| **W11** | 스키마+VO+시드+인터페이스 (9건) | `e0ff334` | FiscalPeriodTable+note, FinancialRatioSnapshotTable, FinancialRatio/PeriodComparison VO, Enums+ComparisonType/RatioCategory, OCI 5종시드, IFinancialRatioRepository |
| **W12** | 비율8종+총포괄이익+DAO/Repo+ReportBloc | `a13d27f` | CalculateFinancialRatios, GenerateComprehensiveIncome, FinancialRatioDao/Repository, ReportBloc 확장 |
| **W13** | 기간비교+비율13종+OCI12종+ReportBloc | `11fd71d` | ComparePeriods, CalculateFinancialRatios+5종, DimensionValueSeeds OCI 12종, ReportBloc+LoadPeriodComparisons |
| **FIX** | IncomeStatementEntry 타입에러+DI등록 | `8d681a2` | .balance→.amount 수정, _sumPlByNature/Path 헬퍼, Injection.dart 3 UseCase DI등록 |
| **W14** | 비율29종+매각예정Path+FX순포지션 | `656aaeb` | CalculateFinancialRatios+16종, ASSET/LIABILITY.HELD_FOR_SALE시드, CalculateFxExposure+ReportQueryService.calculateFxExposure |

---

## W7 보조: CounterpartyPage UI (`c736a2b`)

**파일**: `lib/features/counterparty/presentation/CounterpartyPage.dart:1-805`

**구현**: CounterpartyPage(검색+CRUD), _SearchBar, _CounterpartyTile, _TypeIcon, _ConfidenceBadge, _CounterpartyDetailSheet(alias 관리), _CounterpartyAddSheet(Form 검증)

**특이**: BLoC 미연결(직접 repo 주입). CounterpartyBloc 완성 후 BlocBuilder 마이그레이션 필요. alias id=0 임시.

---

## W8: ExchangeRate DAO/Repo + 환산/미실현손익 (`254a7e0`)

**파일**: exchange/ 5개 (DAO, Repo, ConvertCurrency, EvaluateUnrealizedFxGain, IExchangeRateRepository)

**구현**: ExchangeRateDao(findRate/getLatestRate/saveRate), ExchangeRateRepository(Drift↔VO 변환), ConvertCurrency(동일통화 단락+ExchangeRateNotFoundError), EvaluateUnrealizedFxGain(Asset/Liability 방향 결정, execute+evaluateSingle)

**특이**: ExchangeRateNotFoundError는 ConvertCurrency.dart에 로컬 정의 (DomainErrors.dart 미수정)

---

## W9: 결산 프로세스 + ReportBloc (`850519e`)

**파일**: report/ 7개 (ReportQueryService, GenerateBalanceSheet, GenerateIncomeStatement, RunSettlement, ReportBloc, DashboardPage, SettlementPage)

**구현**: ReportQueryService(customSelect B/S+P/L+시산표), GenerateBalanceSheet(대차균형 검증), GenerateIncomeStatement(당기순이익), RunSettlement(5단계 오케스트레이터), ReportBloc(6이벤트), DashboardPage/SettlementPage(스켈레톤)

**특이**: 3단계 TaxRuleEngine = TODO stub. FiscalPeriods.isClosed 미존재(v2.0에서 추가 완료). retainedEarningsAccountId는 호출자 전달 방식(SRP).

---

## W10 (현재 세션): 아키텍처 v2.0

### CW_ARCHITECTURE.md 집필 내역 (Grace 담당 섹션)

| 섹션 | 내용 | 라인 |
|------|------|------|
| §4.1 | FiscalPeriods +isClosed +note, FinancialRatioSnapshots 신규 테이블 | ~591-604 |
| §2.5 | IFinancialRatioRepository (5메서드) | ~352-358 |
| §7.4 | 재무비율 엔진 — P1 8종 + P2 +5종 + P3 +16종, Rolling 12M, CalculateFinancialRatios UseCase | ~838-893 |
| §7.5 | 기간 비교 — MOM/QOQ/YOY/YOY_ANNUAL, ComparePeriods UseCase + PeriodComparison VO | ~897-935 |
| §9.1 | ReportBloc +LoadFinancialRatios +ComparePeriods +LoadCashFlowStatement +LoadEquityChangeStatement | ~1114 |
| §12.1 | 자본 분류에 OCI 추가 | ~1194 |
| §12.1a | OCI 핵심 5종(P1) + 나머지 12종(P2), GenerateComprehensiveIncome UseCase | ~1500-1540 |
| §12.1b | 매각예정자산/부채 P3 예약 (ASSET.HELD_FOR_SALE, LIABILITY.HELD_FOR_SALE) | ~1542-1548 |
| §12.1 원가 | 재고평가 7종 테이블, NRV 저가법, 직접비/간접비, 원가배부 공식 확장 | ~1475-1530 |

### TF 합의 결과 (Grace 관련)

| 쟁점 | 최종 합의 |
|------|----------|
| OCI 범위 | P1 핵심 5종 + P2 나머지 12종 |
| 재무비율 | P1 8종 + P2 +5종(13종) + P3 +16종(29종) |
| 세그먼트 | Perspective로 대체 (DimensionType.SEGMENT 불필요) |
| CF 범위 | 시드 113코드 전체 + UseCase 단계적(P2: 5분류, P3: 세부) |
| ExchangeRates.purpose | ACCOUNTING/TAX/AVERAGE/CLOSING 4값 |
| 결산 구조 | 코어 5단계 + 플러그인 훅 |
| 재고평가 | Account.valuationMethod P3 예약 |
| 계정자동결정 | ClassificationRules.creditAccountId P2 |
| 원가배부 | 스킵 (현행 AccountOwnerShares+activityTypeOverride 충분) |

---

## 설계 결정 (Why) — HANDOVER_Grace.md 병합

### Enum 직렬화 원칙 (핵심)

- **단일단어 enum** (AccountNature.asset 등) → `.name.toUpperCase()` 저장 → `byName(str.toLowerCase())` 로드. DB에 `'ASSET'` 대문자.
- **복합 camelCase enum** (TransactionSource.systemSettlement 등) → `.name` 그대로 저장 → `byName(raw)` 로드. DB에 `'systemSettlement'`.
- **Why**: `byName()`은 case-sensitive. 대문자화 시 camelCase 단어 경계 소멸.

### SQL 리터럴은 항상 대문자

- `IN ('DRAFT', 'POSTED')` — 단일단어 enum DB 저장값이 대문자.
- 틀린 예: `IN ('draft', 'posted')` → 조회 0건.

### ExchangeRateNotFoundError 위치

- ConvertCurrency.dart 내부 정의. DomainErrors.dart 미수정. 해당 에러가 오직 ConvertCurrency에서만 발생하므로 응집도 우선.

### retainedEarningsAccountId 호출자 전달

- RunSettlement.execute(periodId, snapshotDate, retainedEarningsAccountId). UseCase가 계정 조회에 의존하지 않도록 분리 (SRP).

---

## Gotcha (함정/주의사항)

1. **byName() case-sensitive**: Dart enum `byName()` 대소문자 완전 일치. DB 저장값 확인 필수.
2. **복합 camelCase enum toUpperCase() 금지**: `systemSettlement.name.toUpperCase()` = `'SYSTEMSETTLEMENT'` — 역직렬화 불가.
3. **python3 명령어 불가 (Windows)**: `python3` → Exit code 49. `python` 사용.
4. **CounterpartyPage BLoC 미연결**: 현재 ICounterpartyRepository 직접 주입.
5. **DI 등록 필수**: 새 Repository/UseCase 추가 시 `Injection.dart`에 `getIt.registerLazySingleton` 누락 → 런타임 오류.
6. **Write 도구 "File has not been read yet"**: 기존 파일 덮어쓰기 전 Read 1회 필수.
7. **동시 파일 수정 불가**: 다른 에이전트가 같은 파일 수정 중이면 Edit 오류. 순차 실행 필요.

---

## QA 버그/수정 이력 (34건 요약)

| 패턴 | 수정 내용 | 대표 커밋 |
|------|-----------|-----------|
| AccountNature SQL IN | `'asset'` → `'ASSET'` 대문자 | `0713d18` |
| TransactionSource/Deductibility 직렬화 | `.name.toUpperCase()` → `.name` (camelCase 보존) | `b7c0c40` |
| SettlementPage import | `show SettlementStep` → `show SettlementStep, SettlementResult` | `b7c0c40` |
| SettlementPage DI | `context.read<>()` → `getIt<>()` | `e1a08f8` |

---

## 대기 중 (후속)

| 태스크 | 상태 | 우선순위 |
|--------|------|---------|
| S09 Flow Card 다통화 노드 UI | 대기 | - |
| S08b 3단계 TaxRuleEngine 연동 (Arjun S08a 완성 후) | 대기 | - |
| CounterpartyBloc → BlocBuilder 마이그레이션 | 대기 | - |
| **v2.0 P1 구현** (Grace 담당 6건) | 대기 | P1 |
| **v2.0 P2 구현** (Grace 담당 4건) | 대기 | P2 |

### Grace P1 담당 구현 목록

1. OCI 핵심 5종 Path 시드 데이터
2. GenerateComprehensiveIncome UseCase
3. CalculateFinancialRatios UseCase (8종)
4. FinancialRatioSnapshots 테이블 (Drift 마이그레이션)
5. IFinancialRatioRepository 구현
6. FiscalPeriods +isClosed +note (Drift 마이그레이션)
7. ReportBloc 이벤트 추가

### Grace P2 담당 구현 목록

1. OCI 나머지 12종 Path 시드
2. CalculateFinancialRatios +5종 확장 (총 13종)
3. ComparePeriods UseCase + PeriodComparison VO
4. GenerateIncomeStatement 수정 (계속/중단사업 구분)

---

## 워크트리

| 경로 | 브랜치 | 비고 |
|------|--------|------|
| `E:/_Develop/dart/mymoney-front-flutter` | `agent-automation` | 메인 작업 브랜치 |
| `E:/_Develop/dart/mymoney-wk-grace` | `wk-w8-grace` | Grace 워크트리 |

---

## 관련 문서

| 파일 | 목적 |
|------|------|
| `.cowork/CW_ANALYSIS_Grace.md` | 연결결산보고서 11시트 전수 분석 (26건 GAP, 13건 신규 발견) |
| `.cowork/CW_ARCH_PROPOSAL_Grace.md` | 아키텍처 v2.0 반영안 + 교차 리뷰 |
| `.cowork/CW_RESEARCH_KIFRS.md` | K-IFRS 표준 계정과목 리서치 (68경로 빠짐) |
| `.cowork/CW_ARCHITECTURE.md` | 아키텍처 법전 v2.0 (3명 공동 수정) |
