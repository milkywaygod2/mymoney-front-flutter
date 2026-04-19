# MyMoney Flutter 구현 플랜 v2.0

## Context

MyMoney는 복식부기 회계 기반 가계부 Flutter 앱이다.

**현재 상태 (v2.0 시점)**:
- W0~W6 구현 완료 + W7~W9 부분 완료 (S01~S11 코드 존재, QA Loop 6회 완료)
- CW_ARCHITECTURE.md **v2.0** 확정 (TF 3라운드 난상토론 + K-IFRS/SAP 보강)
- lib/ 에 153개 파일 (~44,800줄) 구현 완료
- 팀: Arjun-3(Counterparty/Tax), Grace-3(Report/비율), Omar-3(Sync/IFRS) — 전원 Opus
- v2.0 신규 항목 **52건** (P1:21 + P2:11 + P3:8 + P4:12) 전부 미구현

**목표**: CW_ARCHITECTURE.md v2.0 기반으로 신규 Wave를 정의하고, 기존 대기 태스크(W7~W10 잔여)와 통합하여 구현 계획을 확정한다.

---

## 프로젝트 구조 (최종)

```
lib/
├── core/
│   ├── domain/
│   │   ├── Transaction.dart
│   │   ├── JournalEntryLine.dart
│   │   ├── Account.dart
│   │   ├── Perspective.dart
│   │   ├── Counterparty.dart
│   │   └── CounterpartyAlias.dart
│   ├── models/
│   │   ├── Money.dart
│   │   ├── CurrencyCode.dart
│   │   ├── Period.dart
│   │   ├── TypedId.dart              # TransactionId, AccountId 등 typed wrapper
│   │   └── ExchangeRateValue.dart
│   ├── interfaces/
│   │   ├── ITransactionRepository.dart
│   │   ├── IAccountRepository.dart
│   │   ├── IPerspectiveRepository.dart
│   │   ├── ICounterpartyRepository.dart
│   │   ├── ICounterpartyMatcher.dart
│   │   ├── IExchangeRateRepository.dart
│   │   └── ILegalParameterRepository.dart
│   ├── constants/
│   │   └── Enums.dart                # AccountNature, EntryType, TransactionStatus 등
│   ├── errors/
│   │   └── DomainErrors.dart         # InvariantViolation, BalanceMismatch 등
│   └── extensions/
│       └── MoneyExtensions.dart
├── features/
│   ├── journal/
│   │   ├── data/
│   │   │   ├── TransactionDao.dart
│   │   │   └── TransactionRepository.dart
│   │   ├── usecase/
│   │   │   ├── CreateTransaction.dart
│   │   │   ├── PostTransaction.dart
│   │   │   ├── VoidTransaction.dart
│   │   │   └── DetectDuplicate.dart
│   │   └── presentation/
│   │       ├── JournalBloc.dart
│   │       ├── JournalEvent.dart
│   │       ├── JournalState.dart
│   │       ├── JournalPage.dart
│   │       ├── FlowCard.dart
│   │       └── TransactionForm.dart
│   ├── account/
│   │   ├── data/
│   │   │   ├── AccountDao.dart
│   │   │   └── AccountRepository.dart
│   │   ├── usecase/
│   │   │   ├── CreateAccount.dart
│   │   │   └── DeactivateAccount.dart
│   │   └── presentation/
│   │       ├── AccountBloc.dart
│   │       ├── AccountEvent.dart
│   │       ├── AccountState.dart
│   │       └── AccountTreePage.dart
│   ├── perspective/
│   │   ├── data/
│   │   │   ├── PerspectiveDao.dart
│   │   │   └── PerspectiveRepository.dart
│   │   ├── usecase/
│   │   │   ├── SelectPerspective.dart
│   │   │   └── ManagePerspective.dart
│   │   └── presentation/
│   │       ├── PerspectiveBloc.dart
│   │       ├── PerspectiveEvent.dart
│   │       ├── PerspectiveState.dart
│   │       └── LensSwitcher.dart
│   ├── counterparty/
│   │   ├── data/
│   │   │   ├── CounterpartyDao.dart
│   │   │   ├── CounterpartyRepository.dart
│   │   │   └── CounterpartyMatcher.dart
│   │   └── presentation/
│   │       └── CounterpartyPage.dart
│   ├── ocr/
│   │   ├── data/
│   │   │   ├── OcrService.dart
│   │   │   └── ClassificationEngine.dart
│   │   └── presentation/
│   │       ├── OcrBloc.dart
│   │       ├── OcrEvent.dart
│   │       ├── OcrState.dart
│   │       └── OcrCapturePage.dart
│   ├── tax/
│   │   ├── data/
│   │   │   └── TaxRuleEngine.dart
│   │   ├── usecase/
│   │   │   ├── AutoClassifyDeductibility.dart
│   │   │   └── ClassifyIncomeType.dart
│   │   └── presentation/
│   │       ├── TaxBloc.dart
│   │       ├── TaxEvent.dart
│   │       ├── TaxState.dart
│   │       └── TaxAdjustmentPage.dart
│   ├── report/
│   │   ├── data/
│   │   │   └── ReportQueryService.dart
│   │   ├── usecase/
│   │   │   ├── GenerateBalanceSheet.dart
│   │   │   ├── GenerateIncomeStatement.dart
│   │   │   └── RunSettlement.dart
│   │   └── presentation/
│   │       ├── ReportBloc.dart
│   │       ├── ReportEvent.dart
│   │       ├── ReportState.dart
│   │       ├── DashboardPage.dart
│   │       └── SettlementPage.dart
│   ├── exchange/
│   │   ├── data/
│   │   │   ├── ExchangeRateDao.dart
│   │   │   └── ExchangeRateRepository.dart
│   │   └── usecase/
│   │       ├── ConvertCurrency.dart
│   │       └── EvaluateUnrealizedFxGain.dart
│   └── sync/
│       ├── data/
│       │   ├── SyncService.dart
│       │   ├── OutboxProcessor.dart
│       │   └── ConnectivityMonitor.dart
│       └── presentation/
│           └── SyncStatusWidget.dart
├── infrastructure/
│   ├── database/
│   │   ├── AppDatabase.dart           # @DriftDatabase 메인 클래스
│   │   ├── tables/
│   │   │   ├── DimensionValueTable.dart
│   │   │   ├── OwnerTable.dart
│   │   │   ├── AccountTable.dart
│   │   │   ├── AccountOwnerShareTable.dart
│   │   │   ├── CounterpartyTable.dart
│   │   │   ├── CounterpartyAliasTable.dart
│   │   │   ├── TransactionTable.dart
│   │   │   ├── JournalEntryLineTable.dart
│   │   │   ├── TagTable.dart
│   │   │   ├── TransactionTagTable.dart
│   │   │   ├── PerspectiveTable.dart
│   │   │   ├── ExchangeRateTable.dart
│   │   │   ├── LegalParameterTable.dart
│   │   │   ├── ClassificationRuleTable.dart
│   │   │   ├── FiscalPeriodTable.dart
│   │   │   └── OutboxEntryTable.dart
│   │   ├── converters/
│   │   │   └── TypeConverters.dart    # Money↔int, CurrencyCode↔String 등
│   │   ├── seeds/
│   │   │   └── DimensionValueSeeds.dart  # 5대 분류 기본 트리
│   │   └── migrations/
│   │       └── (향후)
│   ├── network/
│   │   └── ApiClient.dart             # (S10에서 구현)
│   ├── ocr_engine/
│   │   ├── MlKitOcrAdapter.dart
│   │   └── ServerOcrAdapter.dart      # (stub)
│   └── auth/
│       ├── AuthService.dart
│       └── TokenStorage.dart
└── app/
    ├── di/
    │   └── Injection.dart             # get_it + injectable 설정
    ├── router/
    │   └── AppRouter.dart             # go_router 설정
    ├── theme/
    │   └── AppTheme.dart              # 다크 모드 + 초록색 테마
    └── MyMoneyApp.dart                # MaterialApp.router 래퍼
```

---

## 구현 Wave (병렬 실행 단위)

> **v2.0 기준**: W0~W6 완료, W7~W9 부분 완료. 아래는 완료 요약 + 잔여/신규 Wave 정의.

### ════════════════════════════════════════
### 완료된 Wave (v1.0 — 변경 없음)
### ════════════════════════════════════════

| Wave | 내용 | 커밋 | 상태 |
|------|------|------|------|
| W0 | 스캐폴드 (DI/Router/Theme/4탭) | 16849fb | ✅ 완료 |
| W1 | S01 core/ 엔티티+VO+인터페이스+enum | 73993db | ✅ 완료 |
| W2 | S02 Drift 16테이블+시드+Account CRUD+BLoC | 63ab375 | ✅ 완료 |
| W3 | S03a Transaction DAO/Repo/UseCase/BLoC/Page | c6ceddb | ✅ 완료 |
| W4 | S03b+S04 역분개/중복탐지/계정UseCase | fcb01b2 | ✅ 완료 |
| W5 | S05 Flow Card+거래 입력 UI+Split View | 24f0c11 | ✅ 완료 |
| W6 | S06 Perspective+Lens Switcher | fdc0f4d | ✅ 완료 |
| W7(일부) | Counterparty CRUD+alias | 07cafd4 | ✅ 완료 |
| W8(일부) | S08a 세무조정 규칙엔진 | 3472273 | ✅ 완료 |
| W9 | S08b 결산 프로세스 5단계 | — | ✅ 완료 |
| QA | 6 iteration, 34건 수정, 연속 2회 풀패스 | 3611b18 | ✅ 완료 |

---

### ════════════════════════════════════════
### 잔여 + 신규 Wave (v2.0)
### ════════════════════════════════════════

### Wave 7R: S09 외환차손익 (v1.0 W8 잔여)
> 외부 의존 없음. 즉시 실행 가능.

| 담당 | 내용 |
|------|------|
| **Grace-3** | ExchangeRateDao 확장 — purpose AVERAGE/CLOSING 4값 |
| **Grace-3** | EvaluateUnrealizedFxGain 수정 — isFxRevalTarget 기반 대상 선별 |
| **Arjun-3** | ExchangeRates 테이블 purpose 값 확장 반영 |

**의존**: 없음 (기존 코드 위에 확장)
**DoD**: AVERAGE/CLOSING 환율 구분 + FX 대상 계정 자동 선별 + 외환차손익 자동전표

---

### Wave 11: 스키마 마이그레이션 + 도메인 확장 (P1 기반)
> v2.0 전체의 기반. 모든 신규 Wave의 선행 조건.

**11-A: Drift 스키마 변경 (3명 병렬)**

| 담당 | 변경 | 내용 |
|------|------|------|
| **Arjun-3** | Counterparties +2컬럼 | relatedPartyType, entityType |
| **Arjun-3** | Transactions +2컬럼 | referenceNo, reversalType + source enum 확장 |
| **Grace-3** | FiscalPeriods +2컬럼 | isClosed, note |
| **Grace-3** | FinancialRatioSnapshots 신규 | periodId/ratioCode/category/.../ratioValue |
| **Omar-3** | Accounts +3컬럼 | cashFlowCategory, isFxRevalTarget, vendorRequirement |
| **Omar-3** | CashFlowCodes 신규 (시드 113행) | code/name/parentCode/indexType/level/sortOrder |
| **Omar-3** | CashFlowMappings 신규 | accountId/cfCode/isAutomatic |
| **Omar-3** | SettlementSnapshots 신규 | periodId/snapshotType/data(JSON) |
| **공동** | 인덱스 8건 추가 | §4.2 기준 |

**11-B: 도메인 모델 확장 (3명 병렬)**

| 담당 | 내용 |
|------|------|
| **Arjun-3** | Enums +3 (RelatedPartyType/EntityType/ReversalType), Counterparty.dart INV-C4/C5, Transaction.dart INV-T8/T9 |
| **Grace-3** | FinancialRatio VO, PeriodComparison VO, Enums +2 (ComparisonType/RatioCategory) |
| **Omar-3** | CashFlowLineItem VO, EquityChangeItem VO, Enums +5 (CashFlowCategory/VendorRequirement/CfAccountIndex/OciCategory/EquityChangeType) |

**11-C: 시드 데이터 대폭 확장**

| 담당 | 내용 |
|------|------|
| **공동** | DimensionValueSeeds — K-IFRS L3~L4 약 180경로 (§12.1 트리) |
| **Grace-3** | OCI 5종 시드 (EQUITY.OCI_ACCUMULATED.*) |
| **Omar-3** | CashFlowCodes 시드 113행 |
| **Arjun-3** | 대손충당금 LegalParameter 시드 |

**11-D: Repository/DI 갱신**

| 담당 | 내용 |
|------|------|
| **Grace-3** | IFinancialRatioRepository 신규 (5 메서드) |
| **Omar-3** | ICashFlowCodeRepository + ISettlementSnapshotRepository 신규 |
| **Arjun-3** | ICounterpartyRepository 확장 (+findByRelatedPartyType/findRelatedParties) |
| **공동** | Injection.dart DI 갱신 |

**의존**: 없음 (기존 코드 위에 확장)
**DoD**: build_runner 성공 + 신규 테이블 4개 + 시드 로딩 + analyze 에러 0건

---

### Wave 12: 재무보고서 P1 (비율 + OCI + 결산 개편)

| 담당 | 내용 |
|------|------|
| **Grace-3** | CalculateFinancialRatios UseCase (8종 MVP + Rolling 12M) |
| **Grace-3** | GenerateComprehensiveIncome UseCase (NI + OCI 5항목) |
| **Grace-3** | FinancialRatioDao/Repository 구현 |
| **Grace-3** | ReportBloc +LoadFinancialRatios/+LoadComprehensiveIncome |
| **Omar-3** | RunSettlement 개편 (코어 5단계 + SettlementPlugin 훅) |
| **Omar-3** | SettlementSnapshotDao/Repository 구현 |
| **Arjun-3** | TaxRuleEngine 대손충당금 규칙 추가 |
| **Arjun-3** | CounterpartyRepository relatedPartyType 조회 |
| **Arjun-3** | TransactionRepository referenceNo/reversalType 저장 |

**의존**: Wave 11
**DoD**: 비율 8종 + 총포괄이익 + 결산 플러그인 훅 + 대손충당금 자동 판정

---

### Wave 13: 재무보고서 P2 (CF + CE + 기간비교)

| 담당 | 내용 |
|------|------|
| **Omar-3** | GenerateCashFlowStatement (5분류 간접법) |
| **Omar-3** | GenerateEquityChangeStatement (자본 5구성요소 롤포워드) |
| **Omar-3** | CashFlowCodeDao/Repository 구현 |
| **Grace-3** | ComparePeriods UseCase (MOM/QOQ/YOY/YOY_ANNUAL) |
| **Grace-3** | CalculateFinancialRatios +5종 (총 13종) |
| **Grace-3** | OCI 나머지 12종 시드 + ReportBloc 확장 |
| **Arjun-3** | ClassificationRules +creditAccountId (대변 계정 자동결정) |
| **Arjun-3** | Accounts +isRevenueDeduction + DashboardPage 기간비교 표시 |

**의존**: Wave 12
**DoD**: CF 5분류 + CE 롤포워드 + 기간비교 MOM/YOY + 비율 13종 + 대변 계정 자동결정

---

### Wave 14: P3 확장 (중기)

| # | 항목 |
|---|------|
| 1 | 재무비율 +16종 (총 29종) — ROIC/EBITDA마진/PER/EPS 등 |
| 2 | CF 영업세부 확장 — 이자지급/이자수취/배당수취/법인세 분리 |
| 3 | Account.valuationMethod — 재고 계정 평가방법 enum |
| 4 | 매각예정 Path — ASSET.HELD_FOR_SALE / LIABILITY.HELD_FOR_SALE |
| 5 | 감가상각/무형자산상각 — DepreciationPlugin (결산 플러그인) |
| 6 | 대손충당금 연령분석 — CalculateBadDebtAllowance UseCase |
| 7 | 충당부채 롤포워드 뷰 |
| 8 | 통화별 순포지션 뷰 — FX 익스포저 매트릭스 |

**의존**: Wave 13

---

### Wave 15: S10+S11 동기화+인증 (서버 의존)

| # | 항목 | 외부 의존 |
|---|------|-----------|
| 1 | Outbox+Delta Sync | C# 백엔드 REST API + JWT |
| 2 | OAuth2+생체인증 | Google/Apple OAuth 설정 + local_auth |

**의존**: Wave 13 + 서버 API

---

### Wave 7-OCR: S07 잔여 OCR+Classification (패키지 의존)

| # | 항목 | 외부 의존 |
|---|------|-----------|
| 1 | ML Kit OCR 파이프라인 | google_mlkit_text_recognition 미설치 |
| 2 | ClassificationEngine 로직트리 | OCR에 의존 (수동 텍스트로 독립 테스트 가능) |

**의존**: 패키지 설치 후 언제든

---

## 의존성 그래프 (v2.0)

```
[완료] W0→W1→W2→W3→W4→W5→W6→W7(일부)→W8(일부)→W9 + QA

[즉시 실행 가능]
  W7R (외환) ─── 독립
  W11 (스키마+도메인) ─── 독립

[순차]
  W11 → W12 (비율+OCI+결산) → W13 (CF+CE+기간비교) → W14 (P3)

[서버 의존]
  W13 → W15 (Sync+Auth) ─── C# 백엔드 필요

[패키지 의존]
  W7-OCR ─── ML Kit 패키지 필요
```

## 실행 전략 (v2.0)

1. **W7R + W11 동시 시작** — 둘 다 기존 코드 위 확장, 상호 독립
2. W11 완료 → **W12 즉시** (비율+OCI+결산 개편)
3. W12 완료 → **W13** (CF+CE+기간비교) — 이 시점에서 3대 재무제표 완성
4. W13 완료 → **W14** (P3 확장) — 사업자/기업 기능
5. **W15, W7-OCR**는 외부 의존 해소 시 병렬 착수
6. 각 Wave 완료 시 **QA Loop** (3-Step, 연속 2회 풀패스)
7. 팀: Arjun-3/Grace-3/Omar-3 기존 담당 유지 + v2.0 담당 확장

---

## v1.0 Wave 상세 (참조용 — 아래는 완료된 원본)

### Wave 1: S01 — core/ 기반 (4명 병렬 — 완료)

| 담당 | 파일 | 내용 |
|------|------|------|
| **Sofia** | `core/domain/Transaction.dart` | @freezed, createDraft/post/void 팩토리, INV-T1~T7 |
| **Sofia** | `core/domain/JournalEntryLine.dart` | @freezed, AccountId 참조, override 필드 |
| **Sofia** | `core/domain/Account.dart` | @freezed, INV-A1~A5, nature/path/shares |
| **Ryan** | `core/models/Money.dart` | @freezed, amountMinorUnits+CurrencyCode, 같은통화 합산 |
| **Ryan** | `core/models/CurrencyCode.dart` | @freezed enum + decimals 매핑 |
| **Ryan** | `core/models/TypedId.dart` | TransactionId, AccountId 등 typed int wrapper |
| **Ryan** | `core/models/Period.dart` | @freezed, startDate+endDate |
| **Ryan** | `core/models/ExchangeRateValue.dart` | @freezed, rate(배율 1M) + from/to |
| **Priya** | `core/domain/Perspective.dart` | @freezed, INV-P1~P3, dimensionFilters JSON |
| **Priya** | `core/domain/Counterparty.dart` | @freezed, INV-C1~C3, aliases |
| **Priya** | `core/domain/CounterpartyAlias.dart` | @freezed |
| **Priya** | `core/interfaces/*.dart` | 7개 Repository 인터페이스 (아키텍처 섹션 2.5 그대로) |
| **Wei** | `core/constants/Enums.dart` | AccountNature, EntryType, TransactionStatus, TransactionSource, Deductibility, SyncStatus, DimensionType |
| **Wei** | `core/errors/DomainErrors.dart` | InvariantViolation, BalanceMismatchError 등 |
| **Wei** | `core/extensions/MoneyExtensions.dart` | Money 연산 확장 |

**의존**: Wave 0 완료 (앱 부팅에는 필요없지만 import 경로 확정 필요)
**DoD**:
- `dart run build_runner build` 성공 (freezed 코드 생성)
- 불변조건 단위 테스트 통과 (INV-T1~T7, INV-A1~A5, INV-P1~P3, INV-C1~C3)
- Money VO: 같은 통화 합산 OK, 다른 통화 합산 거부
- Repository 인터페이스 컴파일 확인

---

### Wave 2: S02 — Drift 스키마 + Account CRUD (4명 병렬)

| 담당 | 파일 | 내용 |
|------|------|------|
| **Ryan** | `infrastructure/database/tables/*.dart` | 16개 Drift 테이블 전체 (아키텍처 섹션 4 그대로) |
| **Ryan** | `infrastructure/database/AppDatabase.dart` | @DriftDatabase 메인 + 인덱스 |
| **Ryan** | `infrastructure/database/converters/TypeConverters.dart` | Money↔int, CurrencyCode↔String 등 |
| **Priya** | `infrastructure/database/seeds/DimensionValueSeeds.dart` | 5대 분류 기본 트리 시드 데이터 |
| **Sofia** | `features/account/data/AccountDao.dart` | Drift DAO — CRUD + Path 쿼리 |
| **Sofia** | `features/account/data/AccountRepository.dart` | IAccountRepository 구현체 |
| **Wei** | `features/account/presentation/AccountBloc.dart` | LoadAccountTree, CreateAccount |
| **Wei** | `features/account/presentation/AccountEvent.dart` | BLoC 이벤트 |
| **Wei** | `features/account/presentation/AccountState.dart` | BLoC 상태 |
| **Wei** | `features/account/presentation/AccountTreePage.dart` | 기본 트리 UI |

**의존**: Wave 1 (엔티티 + 인터페이스)
**DoD**:
- Drift DB 초기화 성공 (전 플랫폼)
- DimensionValue 시드 로딩 (자산>유동>현금성 트리 탐색)
- Account CRUD 통합 테스트 (생성→조회→수정→비활성화)
- FK 제약 + Materialized Path LIKE 쿼리
- Money VO ↔ int TypeConverter 왕복

---

### Wave 3: S03a — Transaction 복식부기 핵심 (4명 병렬)

| 담당 | 파일 | 내용 |
|------|------|------|
| **Sofia** | `features/journal/data/TransactionDao.dart` | Drift DAO — CRUD + JEL 조인 쿼리 |
| **Sofia** | `features/journal/data/TransactionRepository.dart` | ITransactionRepository 구현체 |
| **Ryan** | `features/journal/usecase/CreateTransaction.dart` | Draft 생성 UseCase |
| **Ryan** | `features/journal/usecase/PostTransaction.dart` | Draft→Posted + INV-T1~T7 전체 검증 |
| **Wei** | `features/journal/presentation/JournalBloc.dart` | 핵심 이벤트/상태 |
| **Wei** | `features/journal/presentation/JournalEvent.dart` | LoadTransactions, Create, Post |
| **Wei** | `features/journal/presentation/JournalState.dart` | transactions[], selectedDetail |
| **Wei** | `features/journal/presentation/JournalPage.dart` | 기본 거래 리스트 (Flow Card 없이) |
| **Priya** | (테스트 전담) | 차대변 균형, COALESCE override, deductibility 기본값 테스트 |

**의존**: Wave 2 (DB + Account)
**DoD**:
- createDraft → post 흐름 통합 테스트
- 차대변 균형 불일치 시 post 거부
- COALESCE(JEL override, Account default) 동작
- deductibility 기본값 "미판정"
- Drift watchQuery 실시간 갱신

---

### Wave 4: S03b + S04 병렬

**S03b (Transaction 부가):**

| 담당 | 파일 | 내용 |
|------|------|------|
| **Ryan** | `features/journal/usecase/VoidTransaction.dart` | 역분개 자동 생성 |
| **Priya** | `features/journal/usecase/DetectDuplicate.dart` | 점수 기반 중복 탐지 |

**S04 (계정과목 표준 트리):**

| 담당 | 파일 | 내용 |
|------|------|------|
| **Priya** | DimensionValueSeeds 확장 | MVP 전체 표준 트리 (섹션 12 전 노드) |
| **Sofia** | `features/account/usecase/CreateAccount.dart` | leaf 하위만 추가, 코드 자동생성 |
| **Sofia** | `features/account/usecase/DeactivateAccount.dart` | Posted 거래 있으면 비활성화만 |
| **Wei** | AccountTreePage 확장 | 펼치기/접기/검색 UI |

**의존**: Wave 3 (Transaction CRUD)
**DoD**:
- void → 역분개 전표 자동 생성 + 원본 Voided
- 태그 M:N CRUD
- 중복 탐지 점수 >=70 경고
- 5대 분류 전체 표준 트리 + 사용자 하위 추가
- Posted 거래 있는 계정 삭제 거부

---

### Wave 5: S05 — Flow Card + 거래 입력 UI

| 담당 | 파일 | 내용 |
|------|------|------|
| **Wei** | `features/journal/presentation/FlowCard.dart` | 노드-엣지 시각화, nature 색상 |
| **Wei** | `features/journal/presentation/TransactionForm.dart` | 거래 입력 폼 (BottomSheet) |
| **Wei** | JournalPage 확장 | Split View (상단 카드 + 하단 리스트) |
| **Sofia** | FlowCard 도메인 로직 | 차변/대변 노드 데이터 변환 |
| **Ryan** | 플랫폼 적응 로직 | 모바일 상하 vs 데스크톱 좌우 |
| **Priya** | 테스트 | Flow Card 렌더링 + 다전표 레이아웃 |

**의존**: Wave 4 (계정 트리 + 역분개)
**DoD**: v1.0 DoD (구현 완료)

---

### Wave 6: S06 — Perspective + Lens Switcher

| 담당 | 파일 | 내용 |
|------|------|------|
| **Sofia** | `features/perspective/data/*.dart` | PerspectiveDao + Repository |
| **Wei** | `features/perspective/presentation/*.dart` | PerspectiveBloc + LensSwitcher |
| **Wei** | LensSwitcher | 1층 칩 바 + 2층 커스텀 필터 (3탭) |
| **Priya** | 시스템 프리셋 | "전체", "세무 미판정 거래" 시드 |
| **Ryan** | Perspective Drift 쿼리 | dimensionFilters JSON 파싱 + SQL 동적 빌드 |

**의존**: Wave 5 (UI 기반)
**DoD**: v1.0 DoD (구현 완료)

---

### Wave 7: S07 — Counterparty + OCR

| 담당 | 파일 | 내용 |
|------|------|------|
| **Sofia** | `features/counterparty/data/*.dart` | CounterpartyDao + Repository + Matcher |
| **Wei** | `features/ocr/presentation/*.dart` | OcrBloc + OcrCapturePage |
| **Wei** | `features/ocr/data/OcrService.dart` | ML Kit 연동 |
| **Priya** | `features/ocr/data/ClassificationEngine.dart` | 로직트리 + ClassificationRules |
| **Ryan** | `infrastructure/ocr_engine/*.dart` | ML Kit 어댑터 + 서버 stub |

**의존**: Wave 6 (Perspective 필터링)
**DoD**: v1.0 DoD (구현 완료)

---

### Wave 8: S08a + S09 병렬 (세무 + 외환)

**S08a (세무):**

| 담당 | 파일 | 내용 |
|------|------|------|
| **Priya** | `features/tax/data/TaxRuleEngine.dart` | 자동 deductibility + 소득 8종 |
| **Priya** | `features/tax/usecase/*.dart` | AutoClassify + ClassifyIncome |
| **Wei** | `features/tax/presentation/*.dart` | TaxBloc + TaxAdjustmentPage |

**S09 (외환):**

| 담당 | 파일 | 내용 |
|------|------|------|
| **Ryan** | `features/exchange/data/*.dart` | ExchangeRateDao + Repository |
| **Ryan** | `features/exchange/usecase/*.dart` | ConvertCurrency + 미실현손익 |
| **Sofia** | LegalParameter 처리 | VALUE/TABLE/FORMULA 파서 |

**의존**: Wave 7 (Counterparty — 접대비 거래처)
**DoD**: v1.0 DoD (구현 완료)

---

### Wave 9: S08b — 결산 프로세스

| 담당 | 파일 | 내용 |
|------|------|------|
| **Priya** | `features/report/usecase/RunSettlement.dart` | 결산 5단계 |
| **Ryan** | 외환 평가 자동 전표 | nature 기반 차변/대변 방향 |
| **Sofia** | `features/report/data/ReportQueryService.dart` | B/S, P/L 집계 쿼리 |
| **Wei** | `features/report/presentation/*.dart` | ReportBloc + DashboardPage + SettlementPage |

**의존**: Wave 8 (세무 확정 + 외환 평가)
**DoD**: v1.0 DoD (구현 완료)

---

### Wave 10: S10 + S11 (동기화 + 인증)

**S10 (동기화):**

| 담당 | 파일 | 내용 |
|------|------|------|
| **Ryan** | `features/sync/data/*.dart` | SyncService + OutboxProcessor + ConnectivityMonitor |
| **Sofia** | 충돌 해소 로직 | Server-Wins + 사용자 해소 |

**S11 (인증):**

| 담당 | 파일 | 내용 |
|------|------|------|
| **Priya** | `infrastructure/auth/*.dart` | google_sign_in + sign_in_with_apple + local_auth |
| **Wei** | Auth UI + SyncStatusWidget | 로그인/가입 + 동기화 상태 |

**의존**: Wave 9 + 서버 API (C#)
**DoD**: v1.0 DoD (대기 — 서버 의존)

---

## 검증 계획 (v2.0)

| Wave | 검증 방법 |
|------|----------|
| 0~9 | ✅ 완료 (QA Loop 6회, 34건 수정, 연속 2회 풀패스) |
| 7R | AVERAGE/CLOSING 환율 조회 + FX 자동전표 대상 계정 자동 선별 |
| 11 | `build_runner build` 성공 + K-IFRS 180경로 시드 로딩 + 신규 테이블 4개 + analyze 에러 0건 |
| 12 | 재무비율 8종 계산 + Rolling 12M + 총포괄이익 NI+OCI + 결산 플러그인 훅 동작 |
| 13 | CF 5분류 간접법 + CE 5구성요소 롤포워드 + MOM/YOY 기간비교 + 비율 13종 |
| 14 | 비율 29종 + CF 영업세부 + 감가상각 플러그인 + 재고평가 기반 |
| 15 | Outbox 동기화 + 소셜 로그인 (서버 의존) |
| 7-OCR | OCR 캡처 → Draft 전체 플로우 (패키지 의존) |

---

## K-IFRS/SAP 참조 매핑 (구현 시 참조)

| Wave | 참조 기준 | 조항/출처 |
|------|----------|----------|
| W11 시드 | K-IFRS 1001호 재무제표 표시 | 계정과목 L3~L4 분류 기준 |
| W11 시드 | K-IFRS 1002호 §25 재고자산 | 재고평가방법 6종 허용/불허 |
| W11 시드 | IFRS 9 금융상품 | FVTPL/FVOCI/상각후원가 3분류 |
| W11 시드 | IFRS 15 수익인식 | 계약자산/계약부채 계정 |
| W11 시드 | IFRS 16 리스 | 사용권자산/리스부채 계정 |
| W11 시드 | IFRS 5 매각예정 | HELD_FOR_SALE 자산/부채 |
| W12 비율 | 법인세법 시행규칙 별지 제3호의2 | 표준재무상태표/손익계산서 양식 |
| W12 OCI | K-IFRS 1001호 §82A | 기타포괄손익 5종 표시 요건 |
| W13 CF | K-IFRS 1007호 현금흐름표 | 간접법 5분류 표시 요건 |
| W13 CE | K-IFRS 1001호 §106 | 자본변동표 5구성요소 표시 요건 |
| W14 재고평가 | K-IFRS 1002호 §25-33 | NRV 저가법 + 평가방법 제한 |
| 전체 | SAP S/4HANA Universal Journal | JEL 단일 테이블 FI+CO 통합 설계 근거 |
| 전체 | SAP Profit Center | Perspective = 이익센터 포지셔닝 근거 |

---

## 아키텍처 섹션 → 구현 매핑 (CW_ARCHITECTURE.md 전 섹션)

아래는 CW_ARCHITECTURE.md 15개 섹션 각각이 구현 Wave 어디에서 반영되는지 추적표이다.
**이 표에 없는 아키텍처 항목은 구현에서 누락된 것이므로, 구현 시 반드시 교차 확인할 것.**

### 섹션 0: 핵심 철학 및 기술 스택

| 하위 | 내용 | 반영 Wave | 구현 위치 |
|------|------|----------|----------|
| 0.1 비전 | 家計 ⊂ 會計 | 전체 | 도메인 모델 설계 기반 원칙 |
| 0.2 5대 도메인 | 복식부기/세무/자본/외환/법률변수 | W1~W9 | 각 도메인별 feature 모듈 |
| 0.3 기술 스택 | Flutter+BLoC+Drift+get_it+go_router | W0 | `app/di/`, `app/router/` |
| 0.4 오프라인 전략 | Online-First + Outbox | W10 | `features/sync/` |
| 0.5 설계 원칙 | 거래원화 기준, 법률변수 격리 | W1,W8 | `core/models/Money.dart`, `features/tax/` |
| 0.6 용어 사전 | 21개 용어 정의 | W1 | 코드 주석 + 클래스명에 반영 |
| 0.7 실사용 예시 | 카드 커피, 복합결제, Perspective 조합 | W3,W6 | 통합 테스트 시나리오로 활용 |

### 섹션 1: Bounded Context Map

| 하위 | 내용 | 반영 Wave | 구현 위치 |
|------|------|----------|----------|
| 1.1 BC 5개 | Accounting, Perspective, Counterparty, ExtParam, Classification | - | feature/ 디렉토리 구조로 물리 분리 |
| 1.2 BC간 관계 | Conformist, Customer-Supplier, Shared ID 등 | W1 | `core/interfaces/` 경계 정의 |
| 1.3 통신 방식 | 동기 메서드, 동기 쿼리, 비동기 Outbox | W3,W10 | Repository 구현체, SyncService |
| 1.4 BC 배치 | Flutter/C#/Python 분담 | W0~W10 | Flutter 전체 + stub 경계 |

**BC → feature 매핑:**
- Accounting BC → `features/journal/` + `features/account/`
- Perspective BC → `features/perspective/`
- Counterparty BC → `features/counterparty/`
- External Parameter BC → `features/exchange/` + `features/tax/` (LegalParameter)
- Classification BC → `features/ocr/`

### 섹션 2: Aggregate 상세 — 불변조건 전체 목록

구현 시 각 엔티티의 팩토리/메서드에서 **반드시 검증해야 할 불변조건:**

**Transaction (INV-T1~T7)** → `core/domain/Transaction.dart`
- T1: `lines.length >= 2` (Posted)
- T2: `SUM(debit.base_amount) == SUM(credit.base_amount)` (Posted)
- T3: 모든 line의 `base_currency` 동일 (항상)
- T4: `original_amount > 0` 모든 line (항상)
- T5: Draft 상태에서만 수정 가능 (항상)
- T6: Voided → `voided_by` 참조 필수 (Voided)
- T7: `period_id not null` (Posted)

**Account (INV-A1~A5)** → `core/domain/Account.dart`
- A1: `equity_type_path`는 유효한 DimensionValue 트리 노드
- A2: `liquidity_path`는 equity_type에 종속
- A3: `owner_shares` 합계 = 1.0 (배율 10000 → 합계 10000)
- A4: nature와 equity_type 일치
- A5: `is_active=false` 계정은 새 JEL 참조 불가

**Perspective (INV-P1~P3)** → `core/domain/Perspective.dart`
- P1: `dimension_filters` 키는 유효한 DimensionType
- P2: `is_system=true` → 삭제/수정 불가
- P3: name 고유 (같은 owner 내)

**Counterparty (INV-C1~C3)** → `core/domain/Counterparty.dart`
- C1: name not empty
- C2: identifier 있으면 identifier_type 필수
- C3: aliases 시스템 전체 유일

**참조 규칙**: AR 간 ID 참조만. 직접 객체 참조 금지.
```dart
class JournalEntryLine {
  final AccountId accountId;  // ✓ ID만
  // Account account; ← ✗ 금지
}
```

### 섹션 3: 금액 정밀도

| 대상 | 저장 단위 | 배율 | 상수 위치 |
|------|----------|------|----------|
| KRW | 원 | 1 | `core/models/CurrencyCode.dart` |
| USD | cent | 100 | `core/models/CurrencyCode.dart` |
| JPY | 엔 | 1 | `core/models/CurrencyCode.dart` |
| 환율 | 배율 | 1,000,000 | `core/constants/Enums.dart` → `kExchangeRateMultiplier` |
| 지분율 | 배율 | 10,000 | `core/constants/Enums.dart` → `kShareRatioMultiplier` |

**Money VO 구현 필수사항:**
```dart
@freezed
class Money with _$Money {
  const factory Money({
    required int amountMinorUnits,  // 최소 단위 int
    required CurrencyCode currency,
  }) = _Money;

  // 같은 통화만 합산 가능, 다른 통화 → DomainError
  Money operator +(Money other);
  Money operator -(Money other);
}
```

### 섹션 4: Drift 스키마 — 인덱스 전략 (4.2)

테이블 정의는 Wave 2에서 구현. **인덱스는 AppDatabase.dart에 반드시 포함:**

| 쿼리 패턴 | 테이블 | 인덱스 |
|-----------|--------|--------|
| 기간별 거래 | Transactions | `(date)` |
| 계정별 잔액 | JEL | `(accountId)` |
| Perspective Path 필터 | Accounts | `(equityTypePath)`, `(liquidityPath)`, `(assetTypePath)` |
| 태그 필터 | TransactionTags | PK + `(tagId)` |
| OCR 매칭 | CounterpartyAliases | `(alias)` |
| 최신 환율 | ExchangeRates | `(fromCurrency, toCurrency, effectiveDate DESC)` |
| 오프라인 큐 | OutboxEntries | `(status, createdAt)` |
| 중복 탐지 | Transactions | `(date, counterpartyName)` |

### 섹션 5: 동기화 프로토콜 상세

**5.1 원칙** → `features/sync/data/SyncService.dart`
- Online-First, 오프라인은 Draft 생성 + 로컬 Draft 수정/삭제만
- SYNCED 거래 수정/삭제는 온라인 필수
- Server-Wins

**5.2 흐름** → `features/sync/data/OutboxProcessor.dart`
```
[오프라인] OCR → Draft → Drift + Outbox PENDING
[복귀] ConnectivityMonitor → SyncService.triggerSync()
  1. Outbox PENDING → FIFO 서버 전송
  2. 성공→SYNCED / 409→CONFLICT / 네트워크→재시도(지수백오프 max5)
  3. Delta Sync: GET /api/sync?since={last_synced_at}
```

**5.3 충돌 해소** → 충돌 UI (Wave 10)
| 시나리오 | 해소 |
|----------|------|
| 중복 UUID | 서버 멱등성 거부 (409) |
| 계정 비활성화 | 서버 422 → 사용자 재분류 |
| 거래처 병합 | 서버 redirect → 자동 갱신 |
| 환율 불일치 | original_amount 불변, base_amount 재계산 |

**5.4 로컬 캐시 정책** → DI 설정 + 각 Repository
| 데이터 | 정책 | 갱신 |
|--------|------|------|
| 계정과목 | 전체 | 앱시작 + delta |
| 거래처 | 전체 | 앱시작 + delta |
| 환율 | 최근 30일 | 1일1회 + 거래입력시 |
| 법률변수 | 현행 유효분 | 앱시작 |
| 거래 | 최근 3개월 | delta |
| Perspective | 전체 | 앱시작 + delta |
| DimensionValue | 전체 | 앱시작 |

### 섹션 6: 세무조정 규칙 엔진 상세

**6.1 자동 Deductibility 판정** → `features/tax/data/TaxRuleEngine.dart`

| 계정과목 | 판정 | 근거 |
|---------|------|------|
| 접대비 | 손금산입(한도) | 법인세법 제25조 |
| 벌과금 | 손금불산입 | 법인세법 제21조 |
| 복리후생비 | 손금산입 | 시행령 제45조 |
| 감가상각비 | 손금산입(한도) | 법인세법 제23조 |
| 비품소모품/급여 | 장부존중 | 회계=세무 일치 |
| 자동 판정 불가 | 미판정 유지 | 특수관계자, 부당행위, 대손충당금 |

**6.2 워크플로우**: 1단계 자동 → 2단계 사용자 리뷰 → 3단계 확정

**6.3 LegalParameter 타입별** → `features/tax/usecase/AutoClassifyDeductibility.dart`
- VALUE: `IF 비용 > value THEN 초과분 불산입`
- TABLE: 구간 매칭 (누진세율)
- FORMULA: 수식 평가 (입력변수 치환 → Dart 수식 파서)

**6.4 소득유형 8종 + 과세방식** → `features/tax/usecase/ClassifyIncomeType.dart`

Account → default_income_type 매핑:
| Account 계정 | 소득유형 |
|-------------|---------|
| 이자수익/예금이자 | 이자소득 |
| 배당금수익/분배금 | 배당소득 |
| 매출/용역수익 | 사업소득 |
| 급여/상여금 | 근로소득 |
| 연금수령액 | 연금소득 |
| 유가증권처분이익/부동산 | 양도소득 |
| 퇴직금수령 | 퇴직소득 |
| 잡수익/위약금 | 기타소득 |
| 비용 전체 | N/A |
| B/S 항목 | N/A |

과세방식 2단계 자동 판정 (결산 시점):
```dart
// 금융소득 종합과세 판정
if (소득유형 in [이자소득, 배당소득]) {
  합계 = sumByOwnerAndYear(이자 + 배당);
  if (합계 > legalParam("금융소득_종합과세_기준금액")) // 현행 2,000만원
    과세방식 = 종합과세;
  else
    과세방식 = 분리과세; // 14% 원천징수 종결
}
```

### 섹션 7: 결산 프로세스 상세

**7.1 실시간 집계** → `features/report/data/ReportQueryService.dart`
```sql
-- B/S 패턴 (Perspective 필터 동적 적용)
SELECT a.equity_type_path, a.nature,
  SUM(CASE WHEN jel.entry_type='DEBIT' THEN jel.base_amount ELSE 0 END)
  - SUM(CASE WHEN jel.entry_type='CREDIT' THEN jel.base_amount ELSE 0 END) AS balance
FROM journal_entry_lines jel
JOIN accounts a ON jel.account_id = a.id
JOIN transactions t ON jel.transaction_id = t.id
WHERE t.status = 'POSTED' AND t.date <= :snapshot_date
  AND COALESCE(jel.owner_id_override, a.owner_id) IN (:owner_filter)
GROUP BY a.equity_type_path, a.nature;
```

**7.2 결산 스냅샷 5단계** → `features/report/usecase/RunSettlement.dart`
1. 기말 마감 준비: Draft 잔존 검증 + 시산표
2. 자동 결산 전표: 외환 평가 + (확장: 감가상각)
3. 세무조정: 자동 → 리뷰 → 확정
4. 손익 마감: 수익/비용 → 손익요약 → 이익잉여금
5. 스냅샷 저장: B/S + P/L + 세무 + 기초 잔액 이월

**7.3 외환차손익 자동 전표** → Wave 9 (Ryan)
```
Asset + 환율 상승: 차변 해당자산 / 대변 외환차익(미실현)
Asset + 환율 하락: 차변 외환차손(미실현) / 대변 해당자산
Liability + 환율 상승: 차변 외환차손 / 대변 해당부채
Liability + 환율 하락: 차변 해당부채 / 대변 외환차익
```
source: SYSTEM_SETTLEMENT, status: Posted, deductibility: 장부존중

### 섹션 8: 거래 중복 탐지 상세

**8.1 점수 기반** → `features/journal/usecase/DetectDuplicate.dart`

| 조건 | 점수 |
|------|------|
| 날짜 동일 | +40 |
| 날짜 +-1일 | +20 |
| 금액(base_amount) 동일 | +30 |
| 거래처명 동일/alias 매칭 | +20 |
| 거래원천 다름 | +10 |
| **>=70**: 중복 의심 → 사용자 확인 | |
| **>=90**: 거의 확실 → 경고 배지 | |

**8.2 UX**: Draft에서만 탐지. Flow Card 주황색 배지. 탭 → 후보 비교 → "병합"/"별개"

### 섹션 9: BLoC 설계 상세

**9.1 6개 BLoC** (OcrBloc 포함 — 아키텍처 원본은 5+1)

| BLoC | 구현 Wave | 파일 |
|------|----------|------|
| JournalBloc | W3 | `features/journal/presentation/JournalBloc.dart` |
| AccountBloc | W2 | `features/account/presentation/AccountBloc.dart` |
| PerspectiveBloc | W6 | `features/perspective/presentation/PerspectiveBloc.dart` |
| OcrBloc | W7 | `features/ocr/presentation/OcrBloc.dart` |
| TaxBloc | W8 | `features/tax/presentation/TaxBloc.dart` |
| ReportBloc | W9 | `features/report/presentation/ReportBloc.dart` |

**9.2 BLoC 간 Stream 통신** → `app/di/Injection.dart`에서 DI 연결
```
PerspectiveBloc ──Stream<Perspective>──→ JournalBloc, ReportBloc, TaxBloc
OcrBloc ──TransactionCreated──→ JournalBloc
JournalBloc ──TransactionPosted──→ TaxBloc (자동 판정 트리거)
JournalBloc ──TransactionUpdated──→ ReportBloc
TaxBloc ──DeductibilityUpdated──→ ReportBloc
```
**규칙**: 단방향 흐름. BLoC 간 직접 참조 금지 → Stream/DI 간접 통신. Composition Root(`app/di/`)에서 연결.

### 섹션 10: 화면 흐름 상세

**10.1 메인 네비게이션** → `app/router/AppRouter.dart` (Wave 0)
```
홈 Shell (Lens Switcher 상단 공통)
  ├── [1] 홈 (대시보드) — 순자산, 수입/지출 요약, 미확인 Draft 알림
  ├── [2] 거래 (Journal) — Split View: Flow Card + 리스트
  ├── [3] 분석 (Report) — B/S, P/L, CF, 예산
  └── [4] 더보기 — 계정/거래처/관점 관리, 세무조정, 결산, 설정
```

**10.2 플랫폼별 적응** → Wave 5 (Ryan)
| 요소 | 모바일 | 데스크톱 |
|------|--------|---------|
| 메인 내비 | BottomNavigationBar | NavigationRail (사이드) |
| Flow Card + 리스트 | 상하 Split View | 좌우 Master-Detail |
| Lens 2층 | BottomSheet | 사이드 패널 |

**10.3 Lens Switcher 전환 리빌드** → Wave 6
PerspectiveBloc 변경 → JournalBloc/ReportBloc 리필터링 (fade 200ms). 탭 구조/계정 트리는 리빌드 안 함.

### 섹션 11: Lens Switcher 상세

**11.1 2계층 구조** → `features/perspective/presentation/LensSwitcher.dart`
- 1층 칩 바: 프리셋 빠른 전환, 수평 스크롤, filled/outlined
- 2층 커스텀 필터: 톱니바퀴 탭 시 확장, 3탭:
  - 계정 속성: T1(자기자본성/유동성/자산종류) + 소유자 + Account 속성
  - 거래 속성: T2(활동구분/소득유형/손익금구분/기간) + 통화 + 거래처
  - 분석: T3(태그/생활분류) + 예산과목

**11.2 트리 드릴다운**
- Breadcrumb: `전체 > 유동자산 > 현금성`
- 깊이 제한 최대 3단계
- 짧은 탭 = 선택/해제, 긴 탭 = 드릴다운
- "이 레벨 이하 전체 선택" 토글

**11.3 태그 멀티셀렉트**
- AND/OR 토글 스위치 (기본 AND)
- 최근 사용 태그 상단 (최대 5개)
- 자동완성 검색

**11.4 프리셋 CRUD**
- 생성: 2층 조합 → "프리셋으로 저장" → 이름 → 칩 추가
- 수정: 칩 롱프레스 → "편집"
- 삭제: 롱프레스 → "삭제" (시스템 프리셋 보호)
- 통합 검색 바

### 섹션 12: 계정과목 표준 체계

**12.1 MVP 5대 분류** → `infrastructure/database/seeds/DimensionValueSeeds.dart`
- 자산: 유동(현금성/단기금융/매출채권/선급/재고) + 비유동(투자/유형/무형/기타)
- 부채: 유동(미지급/단기차입/예수/선수) + 비유동(장기차입/기타)
- 자본: 자본금 + 이익잉여금 + 기타자본
- 수익: 영업 + 금융 + 투자 + 기타
- 비용: 생활 + 영업 + 금융 + 감가상각 + 세금 + 기타

**12.2 사용자 확장 규칙** → `features/account/usecase/CreateAccount.dart`
- leaf 노드 하위에만 추가
- 코드 자동 생성 (Path 연장)
- nature 부모 상속 (변경 불가)
- 재무제표: 부모 위치에 자동 합산

**12.3 정부회계 확장** → DimensionValue 시드
- `entity_type=GOVERNMENT` 행 추가
- `Perspective.recording_direction=Inverted`
- 활동구분: 경상/자본/세입/세출
- 자기자본성: 순자산

### 섹션 14: 코딩 컨벤션 (전 구현 Wave 공통 적용)

> 핵심 원칙: "뇌의 사고 속도를 병목시키는 모든 행위는 적폐."

**네이밍:**
| 대상 | 컨벤션 | 예시 |
|------|--------|------|
| 파일명 | PascalCase | `TransactionRepository.dart` |
| 클래스명 | 도메인 접두사 + PascalCase | `TransactionRepository`, `BalanceSheetPage` |
| 변수명 | 헝가리안 접두사 + camelCase | `listTransactions`, `mapAccountsByCode` |
| 메서드명 | 동사 시작 + camelCase | `fetchData()`, `buildFlowCard()` |
| private | 언더스코어 접두사 | `_selectedStock` |

**헝가리안 접두사:**
| 접두사 | 의미 | 예시 |
|--------|------|------|
| `list` | List | `listTransactions` |
| `map` | Map | `mapAccountsByCode` |
| `set` | Set | `setExpandedIds` |
| `is/has` | bool | `isActive`, `hasPermission` |
| `stream` | Stream | `streamPerspective` |

**Dart 린터**: `file_names: false` (analysis_options.yaml)

**코딩 습관:**
- 한국어 주석 (what보다 why 중심)
- 짧은 메서드는 한 줄 축약
- const 생성자 적극 사용
- 루프 연산은 build() 밖으로 (BLoC 상태에서 처리)
- initState/dispose 틀 잡기 (빈 상태여도 명시)
- 다크 모드 + 초록색 기반 테마

### 섹션 15: 확장 예약 (구현하지 않되 막히지 않도록)

아래 항목은 **코드에 슬롯/인터페이스만 예약하고, 구현은 하지 않는다:**

| 영역 | 예약 사항 | 예약 위치 |
|------|-----------|----------|
| 해외 소득 | LegalParameter `country_code` + `domain` 복합키 | LegalParameterTable |
| 이중 과세 | 조세조약 슬롯 | LegalParameterTable |
| 환율 이중성 | ExchangeRate `purpose`: Accounting/Tax | ExchangeRateTable |
| CRS/FATCA | Counterparty `country_code`, Account `is_foreign_financial` | 해당 테이블 |
| 시스템 프리셋 | "세무 미판정 거래" | PerspectiveTable seeds |
| Domain Event | `core/interfaces/IDomainEventBus.dart` 예약 | core/interfaces/ |
| 감가상각 | 결산 2-b 확장 포인트 | RunSettlement |
| Tag Group | Tags.category 컬럼 | TagTable |

---

## 실행 전략

1. **Wave 0**은 메인 에이전트(나)가 직접 실행 — 다른 작업의 기반
2. **Wave 1부터** 4명 병렬 — 각 담당자별 워크트리 분리
3. 각 Wave 완료 시 → main 머지 → 다음 Wave 시작
4. `build_runner build`는 각 Wave 머지 후 1회 실행
5. 테스트는 Wave 단위로 작성 (test/ 하위 mirror 구조)
6. **섹션 14(코딩 컨벤션)은 전 Wave에 공통 적용** — 코드 리뷰 시 체크리스트로 사용
7. **섹션 15(확장 예약)은 해당 테이블/인터페이스 구현 시 슬롯만 확보** — 구현 금지
