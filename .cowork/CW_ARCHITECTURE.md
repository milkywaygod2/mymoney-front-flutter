# CW_ARCHITECTURE.md — MyMoney 아키텍처 법전

> Phase 2A 산출물. Phase 1 기획 합의문(PHASE1_AGREEMENT.md) 기반 구현 수준 정밀화.
> 작성: TF tf-mymoney (James 의장, Priya/Sofia/Ryan/Wei 위원)
> 일자: 2026-04-18

---

## 0. 핵심 철학 및 기술 스택

### 0.1 프로젝트 비전

> **家計 ⊂ 會計** — 가계부와 회계는 본질적으로 같다. 스코프만 다를 뿐이다.
> 더 넓은 회계를 기준으로 가계를 포괄하는 설계를 한다.

| 주체 | 목적 | 수익/비용 관점 |
|------|------|---------------|
| 가계 | 돈을 덜 쓰고 많이 벌기 | 수익 > 비용 추구 |
| 기업 | 돈을 덜 쓰고 많이 벌기 | 수익 > 비용 추구 |
| 정부 | 예산을 받아서 쓰기 | 수익/비용 개념이 반대 — 기록 방향도 반대 |

### 0.2 5대 도메인

| # | 도메인 | 핵심 |
|---|--------|------|
| 1 | **복식부기** | ��든 거래 = 차변 + 대변. 정합성 보장의 기반 |
| 2 | **세무** | 손금/익금 판정 → 과세표준 → 세�� 자동 산출 |
| 3 | **자본** | 주식 거래, 배당, 자��� 변동 정밀 추적 |
| 4 | **외환차손익** | 거래원화 기준 기록 + 거래시점 환율 병기. Lazy Calculation (조회 시 온디맨드, 결산 시 확정) |
| 5 | **법률 변수 분리** | 세율/비율 등을 Parameter로 격리. 법 개정 시 변수값만 교체 |

### 0.3 기술 스택

```
[프론트엔드]  Flutter (전 플랫폼: Android/iOS/Web/Desktop)
                ├── 상태관리: BLoC + Feature-first
                ├── 로컬 DB: Drift (SQLite 래퍼)
                ├── DI: get_it + injectable
                └── OCR: ML Kit (모바일) / 서��� 위임 (Web/Desktop)

[메인 백엔드]  C# / ASP.NET Core
                └── ASP.NET Core Identity — 자체 인증/JWT 발급/검증

[AI 서버]      Python / FastAPI
                └── OCR 서버 위임, AI 분류 모델

[데이터베이스]  MySQL (서버), SQLite (클라이언트 로컬)

[인증]         자체 구현 (외부 서비스 의존 없음, 비용 0)
                ├── google_sign_in (Google OAuth2 직접 연동)
                ├── sign_in_with_apple (Apple OAuth2 직접 연동)
                ├── local_auth (생체인증/PIN)
                └── C# 백엔드: ASP.NET Core Identity + JWT 자체 발급/검증
```

### 0.4 오프라인 전략

**Online-First with Offline Capability**
- 오프라인 허용: Draft 생성 + 로컬 Draft 수정/삭제
- 서버 SYNCED 거래의 수정/삭제는 온라인 필수
- 동기화: Outbox 패턴 (FIFO 순차 전송, Server-Wins)

### 0.5 설계 원칙

- 도메인을 한번 잘 설계하면 이후는 도��인을 따라가면 됨
- 어려운 부분은 로직이 아니라 **법�� 의존 변수의 식별과 격리**
- 확장 가능한 구조: 새 계정과목, 새 법률 변수를 언��든 추가 가능해야 함
- **거래의 실질은 거래원화 금액**. 기준통화 환산은 파생 정보

---

## 0.6 용어 사전 (Glossary)

| 영문 | 한국어 | 설명 |
|------|--------|------|
| Transaction | 거래 | 하나의 경제적 사건 단위. "커피를 카드로 샀다" = 1 Transaction |
| Journal Entry Line (JEL) | 전표 라인 | Transaction을 복식부기로 기록한 개별 행. 1거래 = 최소 2 JEL (차변+대변) |
| Account | 계정과목 | 돈의 위치/용도를 분류하는 항목. "보통예금", "식비", "카드미지급금" 등 |
| Counterparty | 거래처 | 거래 상대방. "스타벅스 강���점", "국민은행" 등 |
| Perspective | 관점 | 거래 풀을 특정 ���건으로 필터링하는 렌즈. "남편 투자 현황" 등 |
| Aggregate Root (AR) | 집합 루트 | DDD 개념. 관련 데이터를 하나로 묶어 정합성을 보장하�� 단위 |
| Bounded Context (BC) | 경계 컨텍스트 | 독립적으로 동작하는 도메인 영역 |
| Debit | 차변 | 복식부기 왼쪽. 자산 증가, 비용 발생 시 기록 |
| Credit | 대변 | 복식부기 오른쪽. 부채 증가, 수익 발생 시 기록 |
| Materialized Path | 구체화 경로 | 트리 구조를 문자열로 저장. `ASSET.CURRENT.CASH` = 자산>유동>현금 |
| Override | 재정의 | Account 기본값을 특정 JEL에서 다른 값으로 덮어쓰기 |
| Nature | 계정 성격 | Asset/Liability/Equity/Revenue/Expense 5대 분류 |
| FK (Foreign Key) | 외래키 | 다른 테이블의 행을 참조하는 키 |
| Value Object (VO) | 값 객체 | 식별자 없이 값으로 동등성 결정. Money, CurrencyCode 등 |
| Dimension | 분류축 | 거래나 계정을 분류하는 독립적 기준 |
| Attribute | 속성 | 엔티티에 딸린 고정 정보. Account의 금융사, 상품구분 등 |

> **차변 마이너스 표현 참고:** 복식부기 원칙상 자산 증가=차변, 자산 감소=대변이지만, 음의 표현은 통상 '취소(Reversal)'를 의미함. 실질은 역분개와 동일하나 뉘앙스/의도를 담는 표현.

---

## 0.7 실사용 예시

### 예시 1: 단순 거래 — "카드로 커피 ��매 4,500원"

```
[Transaction]
  날짜: 2026-04-18, 거래처: 스타벅스 강남점, 상태: Posted
  거래원천: OCR, 신뢰도: 0.95, 태그: #출근길 #커피

  [JEL 1 - 차변] 식비(Expense) +4,500 KRW, 활동: 영업(Account 기본값)
  [JEL 2 - 대변] 신한카���(Liability) +4,500 KRW, 소유자: 형두(Account 기본값)

  차변 합계: 4,500 = 대변 ��계: 4,500 ✓
```

### 예시 2: 복잡한 거래 — "카드 3만�� + 포인트 2천원 사용 + 포인트 300원 적립"

```
[Transaction] 거래처: 올리브영, 태그: #생필품

  [JEL 1 - 차변] 생활용품(Expense)    +30,000원
  [JEL 2 - 차변] 포인트(Asset)          +300원  ← 적립
  [JEL 3 - 대변] 신한카드(Liability)   +28,000원
  [JEL 4 - 대변] 포인트(Asset)         -2,000원  ← 사용

  차변 합계: 30,300 = 대변 합계: 30,300 ✓
```

### 예시 3: Perspective 조합

```
"유리의 가계 지출" → {소유자: [유리], 활동구분: [가계]}
"가구 전체 투자"   → {활동구분: [투자]}, account_attr: {상품구분: [주식, CMA]}
"정��� 예산 집행"   → {활동구분: [세출]}, recording_direction: Inverted
```

---

## 1. Bounded Context Map

### 1.1 BC 식별 (5개)

| BC | 책임 | 핵심 AR |
|----|------|---------|
| **Accounting** | 거래 기록, 복식부기 정합성, 계정과목 관리 | Transaction, Account |
| **Perspective** | 관점 프리셋 관리, Query 측 필터링 렌즈 | Perspective |
| **Counterparty** | 거래처 마스터, 별칭 매칭, 중복 병합 | Counterparty |
| **External Parameter** | 환율/법률 변수 관리, Temporal 이력 | ExchangeRate, LegalParameter |
| **Classification** | OCR 텍스트 추출, 파싱, 로직트리 분류, Draft 생성 | (AR 없음 — Upstream Application Service) |

### 1.2 BC 간 관계

```
                    [Classification]
                     (Upstream)
                         │ Customer-Supplier
                         ▼
[External Parameter] ──▶ [Accounting] ◀── [Perspective]
   (Conformist)           (Core)          (Published Language)
                         │
                         │ Shared ID
                         ▼
                    [Counterparty]
                     (독립)
```

| 관계 | 유형 | 설명 |
|------|------|------|
| External Parameter → Accounting | Conformist | 환율/법률 변수를 그대로 수용 |
| Classification → Accounting | Customer-Supplier | Draft 생성 요청, Accounting이 검증 후 수락/거부 |
| Accounting → Counterparty | Separate Ways + Shared ID | counterparty_id FK만 보유 |
| Accounting → Perspective | Published Language | Accounting 데이터를 읽기 전용 소비 (CQRS) |
| Classification → Counterparty | Customer-Supplier | ICounterpartyMatcher 호출 |

### 1.3 통신 방식

- BC 내부: **동기 메서드 호출** (단일 Flutter 프로세스)
- Accounting ↔ Perspective: **동기 쿼리** (같은 Drift DB)
- 서버 동기화: **비동기 Outbox**
- 결산 이벤트: MVP는 UseCase 직접 호출, 향후 Domain Event 분리 (`IDomainEventBus` 예약)

### 1.4 BC 배치 (클라이언트/서버 분담)

| BC | Flutter (클라이언트) | C# (메인 서버) | Python (AI 서버) |
|----|---------------------|---------------|-----------------|
| **Accounting** | Drift 로컬 저장 + 불변조건 검증 | 마스터 DB + 동기화 API | - |
| **Classification** | OCR 전처리(ML Kit) + 로직트리 | - | OCR 서버 위임 + AI 분류 (2단계) |
| **External Parameter** | 로컬 캐시 | 환율/법률 변수 관리 API | - |
| **Perspective** | 로컬 Query (순수 클라이언트) | - | - |
| **Counterparty** | 로컬 캐시 + 별칭 매칭 | 마스터 관리 | - |

> MVP(1단계): Flutter + C# 서버만으로 동작. Python AI 서버는 2단계에서 활성화.
> Classification BC의 서버 위임 OCR 경로(Web/Desktop)는 2단계까지 stub 처리.

---

## 2. Aggregate 상세

### 2.1 Transaction (AR) — Accounting BC

#### 불변조건

| # | 불변조건 | 적용 시점 |
|---|----------|-----------|
| INV-T1 | `lines.length >= 2` | Posted |
| INV-T2 | `SUM(debit.base_amount) == SUM(credit.base_amount)` | Posted |
| INV-T3 | `모든 line의 base_currency 동일` | 항상 |
| INV-T4 | `original_amount > 0` (모든 line) | 항상 |
| INV-T5 | `Draft 상태에서만 수정 가능` | 항상 |
| INV-T6 | `Voided → voided_by 참조 필수` | Voided |
| INV-T7 | `period_id not null` | Posted |
| INV-T8 | `reversalType == reversalOrigin → voidedBy != null` | Voided |
| INV-T9 | `reversalType == reversalEntry → status == VOIDED` | Voided |

#### 팩토리 메서드

```dart
static Transaction createDraft({...});     // INV-T3, T4만 검증
Transaction post({required PeriodId});     // INV-T1~T7 전체 검증
Transaction void({required TransactionId reversalId}); // 원본 불변
Transaction updateLines(List<JELInput>);   // Draft만 (INV-T5)
Transaction addTag(TagName) / removeTag(TagName);
```

#### 참조 규칙: **ID 참조만. 직접 객체 참조 금지.**

```dart
class JournalEntryLine {
  final AccountId accountId;           // 다른 AR → ID만
  // Account account; ← 금지
}
```

### 2.2 Account (AR)

#### 불변조건

| # | 불변조건 |
|---|----------|
| INV-A1 | equity_type_path는 유효한 DimensionValue 트리 노드 |
| INV-A2 | liquidity_path는 equity_type에 종속 (비유동+당좌 불가) |
| INV-A3 | owner_shares 합계 = 1.0 (100%) |
| INV-A4 | nature와 equity_type 일치 |
| INV-A5 | is_active=false 계정은 새 JEL 참조 불가 |
| INV-A6 | `isRevenueDeduction == true` → `nature == EXPENSE` (비용 계정만 매출차감 가능) |
| INV-A7 | `isFxRevalTarget == true` → 결산 외환평가 자동 선별 대상 |

### 2.3 Perspective (AR)

| # | 불변조건 |
|---|----------|
| INV-P1 | dimension_filters 키는 유효한 DimensionType |
| INV-P2 | is_system=true → 삭제/수정 불가 |
| INV-P3 | name 고유 (같은 owner 내) |

### 2.4 Counterparty (AR)

| # | 불변조건 |
|---|----------|
| INV-C1 | name not empty |
| INV-C2 | identifier 있으면 identifier_type 필수 |
| INV-C3 | aliases 시스템 전체 유일 |
| INV-C4 | `relatedPartyType != null` → `isRelatedParty = true` (자동 동기) |

#### 열거형 (v2.0 추가)

```dart
/// 특수관계자 5단계 분류 (K-IFRS 1024 / 공정거래법)
enum RelatedPartyType {
  parent,       // 지배기업
  subsidiary,   // 종속기업 (과반수 지배)
  associate,    // 관계기업 (20~50% 영향력)
  affiliate,    // 기타특수관계자 (공정거래법 계열회사)
  otherRelated, // 기타(*) (비영리재단, ��익법인)
}

/// 법인/개인 성격 분류 (P2)
enum EntityType {
  individual,          // 개인
  domesticCorporate,   // 국내 영리법인
  foreignCorporate,    // 해외 영리법인
  nonprofit,           // 비영리단체/재단
  government,          // 정부/공공기관
  affiliate,           // 관계사/계열사
}
```

### 2.5 Repository 인터페이스 (core/interfaces/)

```dart
abstract interface class ITransactionRepository {
  Future<Transaction?> findById(TransactionId id);
  Future<List<Transaction>> findByPeriod(PeriodId, {TransactionStatus?});
  Future<List<Transaction>> findByDateRange(DateTime from, DateTime to);
  Future<void> save(Transaction);
  Future<void> delete(TransactionId); // Draft만
  Future<List<Transaction>> findByPerspective(Perspective, {DateTime? from, to, int? limit, offset});
  Future<Map<AccountId, int>> calculateBalances({required PeriodId, Perspective?});
}

abstract interface class IAccountRepository {
  Future<Account?> findById(AccountId);
  Future<List<Account>> findByNature(AccountNature);
  Future<List<Account>> findByDimensionPath(DimensionType, String pathPrefix);
  Future<List<Account>> findActive();
  Future<void> save(Account);
}

abstract interface class IPerspectiveRepository {
  Future<Perspective?> findById(PerspectiveId);
  Future<List<Perspective>> findByOwner(OwnerId);
  Future<List<Perspective>> findSystem();
  Future<void> save(Perspective);
  Future<void> delete(PerspectiveId); // INV-P2 검증
}

abstract interface class ICounterpartyRepository {
  Future<Counterparty?> findById(CounterpartyId);
  Future<Counterparty?> findByAlias(String);
  Future<List<Counterparty>> search(String query);
  Future<void> save(Counterparty);
  Future<bool> isAliasUnique(String);
  Future<List<Counterparty>> findByRelatedPartyType(RelatedPartyType type);  // v2.0
  Future<List<Counterparty>> findRelatedParties();  // relatedPartyType != null, v2.0
}

abstract interface class ICounterpartyMatcher {
  Future<CounterpartyMatch?> matchByText(String rawText);
}

abstract interface class IExchangeRateRepository {
  Future<ExchangeRate?> findRate(CurrencyCode from, to, DateTime date);
  Future<ExchangeRate> getLatestRate(CurrencyCode from, to);
  Future<void> save(ExchangeRate);
}

abstract interface class ILegalParameterRepository {
  Future<LegalParameter?> findEffective(String key, DateTime asOfDate, {String countryCode = "KR"});
  Future<void> save(LegalParameter);
}

// v2.0 추가
abstract interface class ICashFlowCodeRepository {
  Future<List<CashFlowCode>> findAll();
  Future<CashFlowCode?> findByCode(String code);
  Future<List<CashFlowCode>> findByParent(String parentCode);
  Future<List<CashFlowCode>> findByIndexType(CfAccountIndex indexType);
}

abstract interface class ISettlementSnapshotRepository {
  Future<void> saveSnapshot(PeriodId periodId, String snapshotType, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> findSnapshot(PeriodId periodId, String snapshotType);
  Future<List<String>> findSnapshotTypes(PeriodId periodId);  // 해당 기간에 저장된 스냅샷 유형 목록
}

abstract interface class IFinancialRatioRepository {
  Future<List<FinancialRatio>> findByPeriod(int periodId);
  Future<FinancialRatio?> findByPeriodAndCode(int periodId, String ratioCode);
  Future<List<FinancialRatio>> findTrend(String ratioCode, {int limit = 12});  // 특정 비율의 기간별 추이
  Future<void> save(FinancialRatio);
  Future<void> saveAll(List<FinancialRatio>);
}
```

---

## 3. 금액 정밀도

**결정: int (최소 단위 저장)**

| 통화 | 저장 | 예시 |
|------|------|------|
| KRW | 원 단위 | 4,500원 → `4500` |
| USD | cent 단위 | $45.67 → `4567` |
| JPY | 엔 단위 | 1,000엔 → `1000` |
| 환율 | 배율 1,000,000 | 1 USD = 1,350.123456 KRW → `1350123456` |
| 지분율 | 배율 10,000 | 33.33% → `3333` |

double은 부동소수점 오차(0.1+0.2≠0.3)로 차대변 불일치 위험. Decimal 패키지는 SQLite SUM 불가.

```dart
@freezed
class Money with _$Money {
  const factory Money({
    required int amountMinorUnits,
    required CurrencyCode currency,
  }) = _Money;
}
```

---

## 4. Drift 스키마

### 4.1 핵심 테이블

```dart
// DimensionValues — 분류축 값 (T1/T2 트리 노드)
class DimensionValues extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dimensionType => text()();     // EQUITY_TYPE|LIQUIDITY|ASSET_TYPE|ACTIVITY_TYPE|INCOME_TYPE
  TextColumn get code => text()();
  TextColumn get name => text()();
  IntColumn get parentId => integer().nullable().references(DimensionValues, #id)();
  TextColumn get path => text()();              // Materialized Path
  TextColumn get entityType => text().withDefault(const Constant('ALL'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// Owners — 소유자/가구 구성원
class Owners extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// Accounts — 계정과목
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nature => text()();            // ASSET|LIABILITY|EQUITY|REVENUE|EXPENSE
  // T1 이중 저장 (FK=쓰기, Path=읽기)
  IntColumn get equityTypeId => integer().references(DimensionValues, #id)();
  TextColumn get equityTypePath => text()();
  IntColumn get liquidityId => integer().references(DimensionValues, #id)();
  TextColumn get liquidityPath => text()();
  IntColumn get assetTypeId => integer().references(DimensionValues, #id)();
  TextColumn get assetTypePath => text()();
  // T2 기본값
  IntColumn get defaultActivityTypeId => integer().nullable().references(DimensionValues, #id)();
  IntColumn get defaultIncomeTypeId => integer().nullable().references(DimensionValues, #id)();
  IntColumn get ownerId => integer().references(Owners, #id)();
  // 속성
  TextColumn get productType => text().nullable()();
  TextColumn get financialInstitution => text().nullable()();
  TextColumn get countrySpecific => text().nullable()();  // JSON 확장
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  // v2.0 추가
  BoolColumn get isFxRevalTarget => boolean().withDefault(const Constant(false))();   // FX 재평가 대상 (P1) — 결산 외환평가 자동 선별
  BoolColumn get isRevenueDeduction => boolean().withDefault(const Constant(false))(); // 매출차감 계정 (P1) — 순액 표시 수수료
  // v2.0 P3 예약 — 재고 계정(INVENTORY.*)에만 적용
  TextColumn get valuationMethod => text().nullable()();  // fifo|weightedAverage|movingAverage|specificIdentification|standardCost
}

// AccountOwnerShares — 공동명의 지분율
class AccountOwnerShares extends Table {
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get ownerId => integer().references(Owners, #id)();
  IntColumn get shareRatio => integer()();      // 배율 10000
  @override
  Set<Column> get primaryKey => {accountId, ownerId};
}

// Counterparties — 거래처
class Counterparties extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get identifier => text().nullable()();
  TextColumn get identifierType => text().withDefault(const Constant('NONE'))();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get confidenceLevel => text().withDefault(const Constant('UNKNOWN'))();
  BoolColumn get isRelatedParty => boolean().nullable()();
  TextColumn get counterpartyType => text().nullable()();
  TextColumn get countryCode => text().nullable()();
  // v2.0 추가
  TextColumn get relatedPartyType => text().nullable()();  // parent|subsidiary|associate|affiliate|otherRelated (P1)
  TextColumn get entityType => text().nullable()();         // individual|domesticCorporate|foreignCorporate|nonprofit|government|affiliate (P2)
}

// CounterpartyAliases — OCR 표기 변형
class CounterpartyAliases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get counterpartyId => integer().references(Counterparties, #id)();
  TextColumn get alias => text()();
}

// Transactions — 거래
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text()();
  TextColumn get status => text().withDefault(const Constant('DRAFT'))();
  IntColumn get voidedBy => integer().nullable().references(Transactions, #id)();
  IntColumn get counterpartyId => integer().nullable().references(Counterparties, #id)();
  TextColumn get counterpartyName => text().nullable()();
  TextColumn get source => text()();              // manual|ocr|cardApi|csvImport|ntsImport|systemSettlement|systemAuditAdjustment (v2.0: systemAuditAdjustment 추가)
  RealColumn get confidence => real().nullable()();
  IntColumn get periodId => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('SYNCED'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  // v2.0 추가
  TextColumn get referenceNo => text().nullable()();     // 외부 전표번호/카드승인번호 (P1)
  TextColumn get reversalType => text().nullable()();    // reversalOrigin|reversalEntry (P1)
}

// JournalEntryLines — 전표 라인
class JournalEntryLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get accountId => integer().references(Accounts, #id)();
  TextColumn get entryType => text()();         // DEBIT|CREDIT
  IntColumn get originalAmount => integer()();  // 최소 단위 int
  TextColumn get originalCurrency => text().withLength(min: 3, max: 3)();
  IntColumn get exchangeRateAtTrade => integer()();  // 배율 1,000,000
  TextColumn get baseCurrency => text().withLength(min: 3, max: 3)();
  IntColumn get baseAmount => integer()();
  IntColumn get activityTypeOverride => integer().nullable().references(DimensionValues, #id)();
  IntColumn get ownerIdOverride => integer().nullable().references(Owners, #id)();
  IntColumn get incomeTypeOverride => integer().nullable().references(DimensionValues, #id)();
  TextColumn get deductibility => text().withDefault(const Constant('UNDETERMINED'))();
  IntColumn get beneficiaryId => integer().nullable().references(Owners, #id)();
  TextColumn get taxClassification => text().nullable()();
  TextColumn get memo => text().nullable()();
}

// Tags + TransactionTags — M:N
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get category => text().nullable()();
}
class TransactionTags extends Table {
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();
  @override
  Set<Column> get primaryKey => {transactionId, tagId};
}

// Perspectives — 관점
class Perspectives extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get ownerId => integer().references(Owners, #id)();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  TextColumn get dimensionFilters => text().withDefault(const Constant('{}'))();
  TextColumn get accountAttributeFilters => text().withDefault(const Constant('{}'))();
  TextColumn get tagFilters => text().withDefault(const Constant('[]'))();
  TextColumn get recordingDirection => text().withDefault(const Constant('NORMAL'))();
  TextColumn get baseCurrency => text().nullable()();
  TextColumn get permissionLevel => text().withDefault(const Constant('FULL'))();
}

// ExchangeRates — 환율
class ExchangeRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fromCurrency => text().withLength(min: 3, max: 3)();
  TextColumn get toCurrency => text().withLength(min: 3, max: 3)();
  IntColumn get rate => integer()();            // 배율 1,000,000
  DateTimeColumn get effectiveDate => dateTime()();
  TextColumn get source => text()();
  TextColumn get purpose => text().withDefault(const Constant('ACCOUNTING'))();
  // v2.0: purpose 값 4종 — ACCOUNTING | TAX | AVERAGE | CLOSING
  // AVERAGE: 기간 평균환율 (수익/비용 환산, P/L용)
  // CLOSING: 기말환율 (채권/채무 잔액 환산, B/S용)
}

// LegalParameters — 법률 변수
class LegalParameters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get countryCode => text().withDefault(const Constant('KR'))();
  TextColumn get domain => text()();
  TextColumn get key => text()();
  TextColumn get paramType => text()();         // VALUE|TABLE|FORMULA
  TextColumn get value => text().nullable()();
  TextColumn get table => text().nullable()();
  TextColumn get formula => text().nullable()();
  TextColumn get inputVariables => text().nullable()();
  DateTimeColumn get effectiveFrom => dateTime()();
  DateTimeColumn get effectiveTo => dateTime().nullable()();
  TextColumn get applicationBasis => text()();
  BoolColumn get retroactive => boolean().withDefault(const Constant(false))();
  TextColumn get sourceLaw => text().nullable()();
  TextColumn get conditions => text().nullable()();
}

// ClassificationRules — 분류 규칙
class ClassificationRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pattern => text()();
  TextColumn get patternType => text()();       // EXACT|CONTAINS|REGEX
  IntColumn get accountId => integer().references(Accounts, #id)();           // 차변 계정
  IntColumn get creditAccountId => integer().nullable().references(Accounts, #id)();  // v2.0 P2: 대변 계정 자동결정 (카드→미지급금 등)
  IntColumn get counterpartyId => integer().nullable().references(Counterparties, #id)();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  BoolColumn get isSystemRule => boolean().withDefault(const Constant(false))();
  BoolColumn get isUserRule => boolean().withDefault(const Constant(true))();
}

// FiscalPeriods — 결산기간
class FiscalPeriods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();  // v2.0: 결산 마감 여부
  TextColumn get note => text().nullable()();  // v2.0: 결산 코멘트 (비정형 메모)
}

// FinancialRatioSnapshots — 재무비율 스냅샷 (v2.0)
class FinancialRatioSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(FiscalPeriods, #id)();
  TextColumn get ratioCode => text()();         // NET_ASSET_GROWTH|SAVINGS_RATE|CURRENT_RATIO|...
  TextColumn get category => text()();          // PROFITABILITY|STABILITY|ACTIVITY|GROWTH
  IntColumn get numerator => integer()();       // 분자 (최소단위)
  IntColumn get denominator => integer()();     // 분모 (최소단위)
  IntColumn get ratioValue => integer()();      // 배율 10000 (33.33% → 3333)
  DateTimeColumn get calculatedAt => dateTime().withDefault(currentDateAndTime)();
}

// OutboxEntries — 오프라인 동기화 큐
class OutboxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();           // TRANSACTION|ACCOUNT|COUNTERPARTY
  IntColumn get entityId => integer()();
  TextColumn get operation => text()();            // CREATE|UPDATE|DELETE
  TextColumn get payload => text()();              // JSON
  TextColumn get status => text().withDefault(const Constant('PENDING'))();  // PENDING|SENDING|SYNCED|CONFLICT|FAILED
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get attemptedAt => dateTime().nullable()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get serverResponse => text().nullable()();
}

// v2.0 추가 — CashFlowCodes: CF 보고서 코드 마스터 (시드 113행)
class CashFlowCodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()();              // "C100000" ~ "C7000000"
  TextColumn get name => text()();              // "Cash flows from operating activities"
  TextColumn get parentCode => text().nullable()();  // 상위 코드 (NULL = 최상위)
  TextColumn get indexType => text()();         // aggregate|actual|automatic
  IntColumn get level => integer()();           // 1~4
  IntColumn get sortOrder => integer()();
}

// v2.0 추가 — CashFlowMappings: Account → CF 코드 매핑
class CashFlowMappings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  TextColumn get cfCode => text()();            // CashFlowCodes.code 참조
  BoolColumn get isAutomatic => boolean().withDefault(const Constant(true))();
}

// v2.0 추가 — SettlementSnapshots: 결산 스냅샷 (BS/PL/CF/CE/TAX/RATIO)
class SettlementSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(FiscalPeriods, #id)();
  TextColumn get snapshotType => text()();      // BS|PL|CF|CE|TAX|RATIO
  TextColumn get data => text()();              // JSON — 보고서 데이터
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 4.2 인덱스 전략

| 쿼리 패턴 | 테이블 | 인덱스 |
|-----------|--------|--------|
| 기간별 거래 | Transactions | `(date)` |
| 계정별 잔액 | JEL | `(accountId)` |
| Perspective Path 필터 | Accounts | `(equityTypePath)`, `(liquidityPath)`, `(assetTypePath)` |
| 태그 필터 | TransactionTags | PK `(transactionId, tagId)` + `(tagId)` |
| OCR 매칭 | CounterpartyAliases | `(alias)` |
| 최신 환율 | ExchangeRates | `(fromCurrency, toCurrency, effectiveDate DESC)` |
| 오프라인 큐 | OutboxEntries | `(status, createdAt)` |
| 중복 탐지 | Transactions | `(date, counterpartyName)` |
| CF 코드 정렬 (v2.0) | CashFlowCodes | `(sortOrder)` |
| CF 코드 계층 (v2.0) | CashFlowCodes | `(parentCode)` |
| CF 매핑 조회 (v2.0) | CashFlowMappings | `(accountId)` |
| 스냅샷 조회 (v2.0) | SettlementSnapshots | `(periodId, snapshotType)` |
| 특수관계자 유형별 조회 (v2.0) | Counterparties | `(relatedPartyType)` |
| 외부 참조번호 검색 (v2.0) | Transactions | `(referenceNo)` |
| FX 재평가 대상 (v2.0) | Accounts | `(isFxRevalTarget)` |
| 역분개 유형 조회 (v2.0) | Transactions | `(reversalType)` |

---

## 5. 동기화 프로토콜 (Online-First + Outbox)

### 5.1 원칙
- Online-First: 온라인 기본, 오프라인은 graceful degradation
- 오프라인 허용: Draft 생성 + 로컬 Draft 수정/삭제. **서버에 동기화된(SYNCED) 거래**의 수정/삭제는 온라인 필수
- Server-Wins: 충돌 시 서버 우선

### 5.2 흐름

```
[오프라인] OCR → Draft 생성 → Drift 저장 + Outbox PENDING
[복귀] ConnectivityMonitor → SyncService.triggerSync()
  1. Outbox PENDING → FIFO 순 서버 전송
  2. 성공 → SYNCED / 충돌(409) → CONFLICT / 네트워크 오류 → 재시도 (지수 백오프, 최대 5회)
  3. Delta Sync: GET /api/sync?since={last_synced_at} → 서버 변경분 pull → 로컬 갱신
```

### 5.3 충돌 해소

| 시나리오 | 해소 |
|----------|------|
| 중복 전표 (같은 UUID) | 서버 멱등성 거부 (409) |
| 계정 비활성화 | 서버 검증 실패 (422) → 사용자 재분류 |
| 거래처 병합 | 서버 redirect → 클라이언트 자동 갱신 |
| 환율 불일치 | original_amount 불변, 서버 동기화 시 base_amount 재계산 |

### 5.4 로컬 캐시

| 데이터 | 정책 | 갱신 |
|--------|------|------|
| 계정과목 | 전체 | 앱 시작 + delta sync |
| 거래처 | 전체 | 앱 시작 + delta sync |
| 환율 | 최근 30일 | 1일 1회 + 거래 입력 시 |
| 법률 변수 | 현행 유효분 | 앱 시작 |
| 거래 | 최근 3개월 + Perspective 범위 | delta sync |
| Perspective 프리셋 | 전체 | 앱 시작 + delta sync |
| DimensionValue | 전체 | 앱 시작 |

---

## 6. 세무조정 규칙 엔진

### 6.1 자동 Deductibility 판정

| 계정과목 | 판정 | 근거 |
|---------|------|------|
| 접대비 | 손금산입(한도) | 법인세법 제25조, LegalParameter 참조 |
| 벌과금 | 손금불산입 | 법인세법 제21조 |
| 복리후생비 | 손금산입 | 시행령 제45조 |
| 감가상각비 | 손금산입(한도) | 법인세법 제23조 |
| 비품소모품/급여 | 장부존중 | 회계=세무 일치 |
| 대손충당금 | 손금산입(한도) | 법인세법 제34조, LegalParameter 설정율 한도 참조 (v2.0 추가) |

자동 판정 불가: 특수관계자 거래, 부당행위계산 → "미판정" 유지

> **v2.0 변경**: 대손충당금을 자동 판정 대상으로 승격. LegalParameter key: `대손충당금_설정율_한도` (paramType: TABLE, table: `{"일반채권":0.01,"금융기관채권":0.02}`). 채권잔액 x 설정율 한도 초과분 → 손금불산입.

### 6.2 세무조정 워크플로우

```
1단계 자동 판정 → 2단계 사용자 리뷰 → 3단계 확정 (전체 deductibility 비미판정 검증)
```

### 6.3 LegalParameter 타입별 처리

- **VALUE**: 단순 비교 (`IF 비용 > value THEN 초과분 불산입`)
- **TABLE**: 구간 매칭 (누진세율 구간 → rate/deduction)
- **FORMULA**: 수식 평가 (입력 변수 치환 → Dart 수식 파서)

### 6.4 소득유형 자동 분류 (8종 + 과세방식)

#### Account → default_income_type 매핑

| Account 계정 | 소득유형 기본값 |
|-------------|---------------|
| 이자수익, 예금이자 | 이자소득 |
| 배당금수익, 분배금 | 배당소득 |
| 매출, 용역수익 | 사업소득 |
| 급여, 상여금 | 근로소득 |
| 연금수령액 | 연금소득 |
| 유가증권처분이익, 부동산처분이익 | 양도소득 |
| 퇴직금수령 | 퇴직소득 |
| 잡수익, 위약금수익 | 기타소득 |
| 비용(Expense) 전체 | N/A (소득유형 미적용) |
| 자산/부채/자본(B/S 항목) | N/A |

#### 과세방식 2단계 자동 판정 (결산 시점)

```
IF 소득유형 IN (이자소득, 배당소득):
  금융소득 연간합계 = SUM(해당 소유자의 귀속연도 이자+배당)
  IF 합계 > LegalParameter("금융소득_종합과세_기준금액"):  // 현행 2,000만원
    과세방식 = 종합과세
  ELSE:
    과세방식 = 분리과세 (14% 원천징수로 종결)
```

> 거래 입력 시점에는 연간 합계를 모르므로 과세방식은 결산 시 확정.

---

## 7. 결산 프로세스

### 7.1 실시간 집계

B/S, P/L, CF 모두 JEL 집계 쿼리로 동적 생성. Perspective 필터 동적 적용.

```sql
-- B/S 패턴
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

### 7.2 결산 프로세스 — 코어 5단계 + 플러그인 훅 (v2.0)

**코어 5단계** (변경 불가):

1. **기말 마감 준비**: Draft 잔존 검증, 시산표 자동 생성
2. **자동 결산 전표**: 플러그인 훅 순차 실행 (`List<SettlementPlugin>`)
3. **세무조정**: 자동 판정 → 사용자 리뷰 → 확정
4. **손익 마감**: 수익/비용 계정 → 손익요약 → 이익잉여금 대체
5. **스냅샷 저장**: BS + PL + CF + CE + TAX + RATIO 6종 → `SettlementSnapshots` 테이블 → `FiscalPeriods.isClosed = true`

**Step 2 플러그인 훅**:

```dart
/// 결산 2단계에서 순차 실행. 각 플러그인은 자동전표를 반환.
abstract interface class SettlementPlugin {
  String get name;
  int get order;  // 실행 순서 (낮을수록 먼저)
  Future<List<Transaction>> execute(PeriodId periodId);
}
```

| 순서 | 플러그인 | 설명 | 구현 시점 |
|------|---------|------|---------|
| 10 | `FxRevaluationPlugin` | 외환 평가 자동전표 (§7.3) — `Account.isFxRevalTarget` 기반, 환율 CLOSING 사용 | P1 |
| 20 | `OciPlugin` | OCI 자동전표 — FVOCI 평가손익, 해외사업환산손익 등 5항목 | P1 |
| 30 | `DepreciationPlugin` | 감가상각/무형자산 상각 자동전표 | P3 |
| 40 | `BadDebtPlugin` | 대손충당금 설정/환입 자동전표 | P3 |

**Step 5 스냅샷 6종**: BS / PL / CF(§7.6) / CE(§7.7) / TAX / RATIO(§7.4)

### 7.3 외환차손익 자동 전표 매핑

```
Asset + 환율 상승: 차변 해당자산 / 대변 외환차익(미실현)
Asset + 환율 하락: 차변 외환차손(미실현) / 대변 해당자산
Liability + 환율 상승: 차변 외환차손 / 대변 해당부채
Liability + 환율 하락: 차변 해당부채 / 대변 외환차익
```

source: SYSTEM_SETTLEMENT, status: Posted, deductibility: 장부존중

### 7.4 재무비율 엔진 (v2.0)

#### 비율 목록 (P1: 8종 → P2: +5종 → P3: +16종 = 총 29종)

**P1 — 8종 (가계부 핵심)**:

| 코드 | 비율명 | 공식 | 분류 |
|------|--------|------|------|
| NET_ASSET_GROWTH | 순자산증가율 | (기말순자산 - 기초순자산) / 기초순자산 | 성장성 |
| SAVINGS_RATE | 저축율 | (수입 - 지출) / 수입 | 성장성 |
| CURRENT_RATIO | 유동비율 | 유동자산 / 유동부채 | 안정성 |
| DEBT_RATIO | 부채비율 | 부채 / 자기자본 | 안정성 |
| ROA | 총자산이익률 | Rolling12M(순이익) / 평균(총자산) | 수익성 |
| ROE | 자기자본이익률 | Rolling12M(순이익) / 평균(자기자본) | 수익성 |
| AR_TURNOVER | 매출채권회전율 | Rolling12M(매출) / 평균(매출채권) | 활동성 |
| INTEREST_COVERAGE | 이자보상비율 | 영업이익 / 이자비용 | 안정성 |

**P2 — +5종 (총 13종)**:

| 코드 | 비율명 | 공식 | 분류 |
|------|--------|------|------|
| CAPITAL_RESERVE | 자본유보율 | (이익잉여금+자본잉여금) / 납입자본금 × 100 | 안정성 |
| ASSET_TURNOVER | 총자산회전율 | Rolling12M(매출) / 총자산 | 활동성 |
| EQUITY_TURNOVER | 자기자본회전율 | Rolling12M(매출) / 자기자본 | 활동성 |
| AR_DAYS | 채권회수기간 | 365 / AR_TURNOVER | 활동성 |
| DONATION_RATIO | 기부금비율 | 기부금 / 매출 | 기타 |

**P3 — +16종 (총 29종, 확장 예약)**:
PER, EPS, ROIC, EBITDA마진율, 유동자산증가율, 유형자산증가율, 자기자본증가율, 유동부채비율, 비유동부채비율, 순부채비율, 당좌비율, 금융비부담률, 재고자산회전율, 순운전자본회전율, 유형자산회전율, 매입채무회전율

#### Rolling 12M 패턴

ROA/ROE 등 수익성·활동성 비율의 핵심 계산 패턴:

```
분자(순이익/매출): SUM(JEL.baseAmount) WHERE t.date BETWEEN (asOfDate - 12M) AND asOfDate
분모(평균자산):    (잔액(asOfDate) + 잔액(asOfDate - 12M)) / 2
분모(평균매출채권): (잔액(asOfDate) + 잔액(asOfDate - 12M)) / 2
```

#### 계산 시점

- **대시보드**: 온디맨드 실시간 계산 (캐시 없음)
- **결산 Step5**: FinancialRatioSnapshots 테이블에 영구 저장

#### UseCase: `CalculateFinancialRatios`

```dart
class CalculateFinancialRatios {
  Future<List<FinancialRatio>> execute({
    required DateTime asOfDate,
    required int periodId,
    List<String>? ratioCodes,  // null이면 전체 계산
  });
}
```

위치: `lib/features/report/usecase/CalculateFinancialRatios.dart`

### 7.5 기간 비교 (v2.0)

#### 4종 비교

| 코드 | 비교 유형 | 설명 |
|------|----------|------|
| MOM | 전월 대비 | 당월 vs 전월 |
| QOQ | 전분기 대비 | 당분기 vs 전분기 |
| YOY | 전년동기 대비 | 당월(분기) vs 전년 동월(분기) |
| YOY_ANNUAL | 전년말 대비 | 당기말 vs 전기말 |

#### UseCase: `ComparePeriods`

```dart
class ComparePeriods {
  /// 두 기간의 B/S 또는 P/L 잔액을 비교하여 증감액/증감률 반환
  Future<Map<String, PeriodComparison>> execute({
    required int currentPeriodId,
    required int previousPeriodId,
    required String reportType,  // BALANCE_SHEET|INCOME_STATEMENT
  });

  /// 특정 날짜 기준 4종 비교를 한번에 반환
  Future<Map<String, Map<String, PeriodComparison>>> compareAll({
    required DateTime asOfDate,
    required List<String> accountPaths,
  });
}

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

위치: `lib/features/report/usecase/ComparePeriods.dart`

### 7.6 현금흐름표 — CF (v2.0)

#### 5분류 간접법

| # | 분류 | 설명 |
|---|------|------|
| 1 | **영업활동** | 당기순이익 + 비현금항목 가감 + 운전자본 변동 |
| 2 | **투자활동** | 유형/무형자산 취득·처분 + 금융자산 변동 |
| 3 | **재무활동** | 차입금 증감 + 자본거래(배당 등) |
| 4 | **환율변동효과** | 외화 현금에 대한 환율 변동분 |
| 5 | **현금 순변동** | 1+2+3+4, 기초현금 + 순변동 = 기말현금 |

#### CashFlowCodes 코드 체계 (시드 113행)

```
C100000  영업활동 현금흐름 [Aggregate]
  C110000  당기순이익 [Automatic — PL 연동]
  C120000  비현금항목 가감 [Aggregate]
    C120100~C123000  감가상각비/대손상각비/외환차손익/기타 (35개 Actual)
  C130000  운전자본 변동 [Aggregate]
    C130200~C131600  매출채권/재고/매입채무/기타 (20개 Actual)
  C140000  이자지급 [Actual]
  C150000  이자수취 [Actual]
  C160000  배당수취 [Actual]
  C170000  법인세납부 [Actual]
C200000  투자활동 현금흐름 [Aggregate]
  C210000  투자 유입 (14개 Actual)
  C220000  투자 유출 (16개 Actual)
C300000  재무활동 현금흐름 [Aggregate]
  C310000  재무 유입 (6개 Actual)
  C320000  재무 유출 (6개 Actual)
C400000  환율변동효과 [Actual]
C500000  현금 순변동 [Aggregate]
C6000000 기초현금 [Actual]
C7000000 기말현금 [Actual]
```

#### CfAccountIndex 3유형

| 유형 | 설명 | 계산 방법 |
|------|------|---------|
| `aggregate` | 하위 코드 합산 | SUM(children) |
| `actual` | 직접 입력/계산 | Account.cashFlowCategory 기반 JEL 변동 집계 |
| `automatic` | 타 보고서 연동 | C110000 = PL 당기순이익 |

#### Account.cashFlowCategory — CF 자동 분류 태그

```dart
enum CashFlowCategory { cash, receivablePayable, revenueExpense }
```

| 태그 | 계정 예시 | CF 분류 근거 |
|------|---------|------------|
| `cash` | 현금, 보통예금, CMA, MMF | 기초/기말 현금 잔액 |
| `receivablePayable` | 매출채권, 미지급금, 대여금 | 운전자본 변동 (영업) 또는 투자/재무 |
| `revenueExpense` | 매출, 급여, 감가상각비 | 비현금항목 가감 (영업) |

#### GenerateCashFlowStatement UseCase

```dart
class GenerateCashFlowStatement {
  /// P2: 5분류 기본 구현 (영업/투자/재무/환율/순변동)
  /// P3: 영업 세부 분리 (이자/배당/법인세)
  Future<List<CashFlowLineItem>> execute({
    required int periodId,
    Perspective? perspective,
  });
}

@freezed
class CashFlowLineItem with _$CashFlowLineItem {
  const factory CashFlowLineItem({
    required String code,          // CashFlowCodes.code
    required String name,
    required int amount,           // 최소 단위 int
    required int level,
    required CfAccountIndex indexType,
  }) = _CashFlowLineItem;
}
```

### 7.7 자본변동표 — CE (v2.0)

#### 5구성요소 + OCI 5항목

| 구성요소 | 설명 |
|---------|------|
| **자본금** (capitalStock) | 보통주/우선주 |
| **자본잉여금** (capitalSurplus) | 주식발행초과금 등 |
| **기타자본** (otherCapital) | 자사주, 주식선택권 등 |
| **기타포괄손익누계액** (aoci) | OCI 5항목 누적 |
| **이익잉여금** (retainedEarnings) | 미처분이익잉여금 |

#### OciCategory enum (5종)

```dart
enum OciCategory {
  fvociValuation,              // FVOCI 금융자산 평가손익
  foreignCurrencyTranslation,  // 해외사업환산손익
  equityMethodChanges,         // 지분법자본변동
  actuarialGainsLosses,        // 보험수리적손익 (퇴직연금)
  otherOci,                    // 기타 (P2에서 12개 세분 흡수)
}
```

#### EquityChangeType enum (변동 유형)

```dart
enum EquityChangeType {
  beginningBalance,   // 기초잔액
  netIncome,          // 당기순이익
  ociChange,          // OCI 변동 (5항목)
  dividends,          // 배당
  treasuryStock,      // 자사주 거래
  other,              // 기타 자본거래
  endingBalance,      // 기말잔액
}
```

#### GenerateEquityChangeStatement UseCase

```dart
class GenerateEquityChangeStatement {
  /// CE = 기초잔액 + 포괄손익(NI + OCI) + 소유주거래 = 기말잔액
  /// OCI 5항목은 Grace의 GenerateComprehensiveIncome 결과를 소비
  Future<List<EquityChangeItem>> execute({
    required int periodId,
  });
}

@freezed
class EquityChangeItem with _$EquityChangeItem {
  const factory EquityChangeItem({
    required EquityChangeType changeType,
    OciCategory? ociCategory,      // changeType == ociChange일 때만
    required int capitalStock,
    required int capitalSurplus,
    required int otherCapital,
    required int aoci,
    required int retainedEarnings,
  }) = _EquityChangeItem;
}
```

---

## 8. 거래 중복 탐지

### 8.1 탐지 기준 (점수 기반)

| 조건 | 점수 |
|------|------|
| 날짜 동일 | +40 |
| 날짜 +-1일 | +20 |
| 금액(base_amount) 동일 | +30 |
| 거래처명 동일/alias 매칭 | +20 |
| 거래원천 다름 | +10 |
| **>=70**: 중복 의심 → 사용자 확인 | |
| **>=90**: 거의 확실 → 경고 배지 | |

### 8.2 UX

Draft 상태에서만 탐지. Flow Card에 주황색 경고 배지. 탭 시 후보 비교 → "병합" 또는 "별개" 선택.

---

## 9. BLoC 설계

### 9.1 5개 BLoC

| BLoC | 핵심 이벤트 | 핵심 상태 |
|------|------------|-----------|
| **JournalBloc** | LoadTransactions, Create/Update/Delete, ReviewTransaction(Draft→Posted), VoidTransaction | transactions[], selectedDetail, activePerspectiveId |
| **AccountBloc** | LoadAccountTree, ExpandNode, SearchAccounts, Create/Deactivate | roots[], expandedIds, searchResults |
| **PerspectiveBloc** | LoadPresets, SelectPreset, OpenCustomFilter, ApplyCustomFilter, SaveAsPreset | presets[], activePresetId, filterDraft, effectivePerspective |
| **OcrBloc** | CaptureImage, ProcessOcr, ParseResult, ClassifyTransaction, UpdatePreviewField, ToggleRememberPattern, EditInFlowCard, SaveAsDraft, RetryCapture | phase(enum), parsed, classified, confidence, rememberPattern |
| **TaxBloc** | RunAutoClassification, ReviewPending, OverrideDeductibility, ConfirmSettlement | pendingItems[], autoResults[], taxSummary |
| **ReportBloc** | LoadDashboard, LoadReport, ChangeReportPeriod, RefreshExchangeRates, **LoadFinancialRatios**, **ComparePeriods**, LoadCashFlowStatement, LoadEquityChangeStatement | dashboard, currentReport, activePeriod, **ratios[], periodComparisons[]**, cashFlowStatement, equityChangeStatement |

### 9.2 BLoC 간 통신

```
PerspectiveBloc ──Stream<Perspective>──→ JournalBloc, ReportBloc, TaxBloc
OcrBloc ──TransactionCreated──→ JournalBloc
JournalBloc ──TransactionPosted──→ TaxBloc (자동 판정 트리거)
JournalBloc ──TransactionUpdated──→ ReportBloc
TaxBloc ──DeductibilityUpdated──→ ReportBloc (세무 보고서 갱신)
```

단방향 흐름. BLoC 간 직접 참조 금지 → Stream/DI 간접 통신. Composition Root에서 연결.

---

## 10. 화면 흐름

### 10.1 메인 네비게이션

```
홈 Shell (Lens Switcher 상단 공통)
  ├── [1] 홈 (대시보드) — 순자산, 수입/지출 요약, 미확인 Draft 알림
  ├── [2] 거래 (Journal) — Split View: Flow Card + 리스트
  ├── [3] 분석 (Report) — B/S, P/L, CF, 예산
  └── [4] 더보기 — 계정/거래처/관점 관리, 세무조정, 결산(5단계 프로세스), 설정
```

### 10.2 플랫폼별 적응

| 요소 | 모바일 | 데스크톱 |
|------|--------|---------|
| 메인 내비 | BottomNavigationBar | NavigationRail (사이드) |
| Flow Card + 리스트 | 상하 Split View | 좌우 Master-Detail |
| Lens 2층 | BottomSheet | 사이드 패널 |

### 10.3 Lens Switcher 전환 리빌드

PerspectiveBloc 변경 → JournalBloc/ReportBloc 리필터링 (fade 200ms). 탭 구조/계정 트리/거래처는 리빌드 안 함.

---

## 11. Lens Switcher 상세

### 11.1 2계층 구조

- **1층 칩 바**: 프리셋 빠른 전환 (일상 90%). 수평 스크롤, 활성=filled, 비활성=outlined
- **2층 커스텀 필터**: 톱니바퀴 탭 시 확장. 3탭 구성:
  - **계정 속성**: T1(자기자본성/유동성/자산종류) + 소유자 + Account 속성(상품구분/금융사)
  - **거래 속성**: T2(활동구분/소득유형/손익금구분/기간) + 통화 + 거래처 검색
  - **분석**: T3(태그/생활분류) + 예산과목

### 11.2 트리 드릴다운 인터랙션

- **Breadcrumb 네비게이션**: `전체 > 유동자산 > 현금성` — 상위 탭으로 되돌아가기
- **깊이 제한**: 최대 3단계 (인지 부하 방지)
- **탭 구분**: 짧은 탭 = 선택/해제 토글, 긴 탭 = 해당 레벨로 드릴다운
- **"이 레벨 이하 전체 선택"**: breadcrumb 레벨별 토글 제공

### 11.3 태그 멀티셀렉트

- **AND/OR 토글 스위치**: 기본 AND (선택된 태그 모두 포함), OR (하나라도 포함)
- **최근 사용 태그**: 상단 배치 (최대 5개)
- **검색**: 자동완성 드롭다운

### 11.4 프리셋 CRUD

- 생성: 2층 조합 → "프리셋으로 저장" → 이름 입력 → 칩 추가
- 수정: 칩 롱프레스 → "편집" → 2층 열림 → 저장
- 삭제: 롱프레스 → "삭제". 시스템 프리셋 삭제 불가
- 통합 검색 바: 트리/태그/거래처 구분 없이 검색 → 적절한 필터에 자동 추가

---

## 12. 계정과목 표준 체계

### 12.1 K-IFRS 기반 표준 계정과목 트리 (v2.0)

> 기준: K-IFRS 1001호(재무제표 표시), 1002호(재고자산), IFRS 9(금융상품), IFRS 15(계약), IFRS 16(리스)
> SAP S/4HANA Account Group 개념 참조, 가계부 전용 확장 포함
> 우선순위: P1=가계부 MVP, P2=기능 완성, P3=사업자 확장, P4=장기 예약

#### 자산 (ASSET)

```
ASSET
├── CURRENT (유동자산)
│   ├── CASH (현금및현금성자산)
│   │   ├── CASH_ON_HAND                    -- 시재금 (P2)
│   │   ├── CHECKING                        -- 보통예금 (P1)
│   │   ├── SAVINGS_CMA                     -- CMA/MMF/MMDA (P1)
│   │   └── TIME_DEPOSIT_SHORT              -- 정기예금 3개월 이내 (P2)
│   ├── SHORT_TERM_FINANCIAL (단기금융상품)
│   │   ├── TIME_DEPOSIT                    -- 정기예금 3개월 초과 (P2)
│   │   ├── TIME_SAVINGS                    -- 정기적금 (P1)
│   │   └── CD                              -- 양도성예금증서 (P3)
│   ├── FVTPL (당기손익-공정가치측정 금융자산, 유동) -- 주식/펀드 (P2)
│   ├── FVOCI (기타포괄손익-공정가치측정 금융자산, 유동) (P3)
│   ├── AMORTIZED_COST (상각후원가측정 금융자산, 유동) (P3)
│   ├── DERIVATIVE (파생금융자산, 유동) (P4)
│   ├── TRADE_RECEIVABLE (매출채권)
│   │   └── ALLOWANCE                       -- 대손충당금(매출채권) (P2)
│   ├── OTHER_RECEIVABLE                    -- 미수금 (P2)
│   ├── ACCRUED_REVENUE                     -- 미수수익 (P3)
│   ├── PREPAID (선급금/선급비용)
│   │   ├── ADVANCE_PAYMENT                 -- 선급금 (P2)
│   │   └── PREPAID_EXPENSE                 -- 선급비용 (P2)
│   ├── VAT_RECEIVABLE                      -- 부가세대급금 (P2)
│   ├── INCOME_TAX_ASSET                    -- 당기법인세자산 (P3)
│   ├── CONTRACT_ASSET                      -- 계약자산 IFRS 15 (P3)
│   ├── INVENTORY (재고자산)
│   │   ├── MERCHANDISE                     -- 상품 (P2)
│   │   ├── FINISHED_GOODS                  -- 제품 (P3)
│   │   ├── SEMI_FINISHED                   -- 반제품 (P3)
│   │   ├── WORK_IN_PROGRESS               -- 재공품 (P3)
│   │   ├── RAW_MATERIALS                   -- 원재료 (P3)
│   │   ├── SUPPLIES                        -- 저장품/소모품 (P3)
│   │   ├── IN_TRANSIT                      -- 미착품 (P4)
│   │   └── VALUATION_ALLOWANCE             -- 재고자산평가충당금 (P3)
│   └── HELD_FOR_SALE                       -- 매각예정자산 IFRS 5 (P3 예약)
│
├── NON_CURRENT (비유동자산)
│   ├── TANGIBLE (유형자산)
│   │   ├── LAND                            -- 토지 (P1)
│   │   ├── BUILDING                        -- 건물 (P1)
│   │   ├── BUILDING_ACCUM_DEPR             -- 건물감가상각누계액 (P2)
│   │   ├── MACHINERY                       -- 기계장치 (P3)
│   │   ├── VEHICLE                         -- 차량운반구 (P2)
│   │   ├── EQUIPMENT                       -- 비품/집기 (P2)
│   │   ├── CONSTRUCTION_IN_PROGRESS        -- 건설중자산 (P3)
│   │   └── OTHER_TANGIBLE                  -- 기타유형자산 (P3)
│   ├── INTANGIBLE (무형자산)
│   │   ├── GOODWILL                        -- 영업권 (P4)
│   │   ├── SOFTWARE                        -- 소프트웨어 (P3)
│   │   ├── INDUSTRIAL_PROPERTY             -- 산업재산권(특허/상표) (P3)
│   │   └── OTHER_INTANGIBLE               -- 기타무형자산 (P3)
│   ├── INVESTMENT_PROPERTY (투자부동산)
│   │   ├── LAND                            -- 투자부동산-토지 (P2)
│   │   ├── BUILDING                        -- 투자부동산-건물 (P2)
│   │   └── ACCUM_DEPR                      -- 투자부동산감가상각누계액 (P2)
│   ├── INVESTMENT (투자자산)
│   │   ├── EQUITY_METHOD                   -- 관계기업투자/지분법 (P3)
│   │   ├── LONG_TERM_DEPOSIT               -- 장기예금 (P2)
│   │   ├── LONG_TERM_SAVINGS               -- 장기적금 (P2)
│   │   └── LONG_TERM_LOAN                  -- 장기대여금 (P2)
│   ├── FVTPL (당기손익-공정가치측정, 비유동) (P2)
│   ├── FVOCI (기타포괄손익-공정가치측정, 비유동) (P3)
│   ├── AMORTIZED_COST (상각후원가측정, 비유동) (P3)
│   ├── DEPOSIT (보증금)
│   │   └── LEASE_DEPOSIT                   -- 임차보증금 전세/월세 (P1)
│   ├── RIGHT_OF_USE                        -- 사용권자산 IFRS 16 (P3)
│   ├── DEFERRED_TAX                        -- 이연법인세자산 (P4)
│   └── LONG_TERM_RECEIVABLE                -- 장기매출채권 (P3)
```

#### 부채 (LIABILITY)

```
LIABILITY
├── CURRENT (유동부채)
│   ├── TRADE_PAYABLE                       -- 매입채무/외상매입금 (P2)
│   ├── OTHER_PAYABLE                       -- 미지급금 (P2)
│   ├── CARD_PAYABLE                        -- 카드미지급금 (P1)
│   ├── ACCRUED_EXPENSE                     -- 미지급비용 (P2)
│   ├── SHORT_TERM_BORROWING (단기차입금)
│   │   ├── BANK_LOAN                       -- 은행대출 유동 (P1)
│   │   └── OVERDRAFT                       -- 마이너스통장 (P1)
│   ├── CURRENT_PORTION_LTD                 -- 유동성장기부채 (P2)
│   ├── ADVANCE_RECEIVED                    -- 선수금 (P2)
│   ├── UNEARNED_REVENUE                    -- 선수수익 (P3)
│   ├── WITHHOLDING (예수금)
│   │   ├── INCOME_TAX                      -- 소득세예수금 (P3)
│   │   └── SOCIAL_INSURANCE                -- 4대보험예수금 (P3)
│   ├── VAT_PAYABLE                         -- 부가세예수금 (P2)
│   ├── INCOME_TAX_LIABILITY                -- 미지급법인세 (P3)
│   ├── PROVISIONS                          -- 충당부채 유동 (P3)
│   ├── CONTRACT_LIABILITY                  -- 계약부채 IFRS 15 (P3)
│   ├── LEASE                               -- 리스부채 유동 IFRS 16 (P3)
│   ├── DERIVATIVE                          -- 파생금융부채 유동 (P4)
│   └── HELD_FOR_SALE                       -- 매각예정부채 IFRS 5 (P3 예약)
│
├── NON_CURRENT (비유동부채)
│   ├── LONG_TERM_BORROWING (장기차입금)
│   │   ├── MORTGAGE                        -- 주택담보대출 (P1)
│   │   ├── PERSONAL_LOAN                   -- 신용대출 (P1)
│   │   └── STUDENT_LOAN                    -- 학자금대출 (P1)
│   ├── BONDS                               -- 사채 (P4)
│   ├── RENTAL_DEPOSIT                      -- 임대보증금 임대인 (P2)
│   ├── DEFINED_BENEFIT                     -- 퇴직급여부채 DB형 (P3)
│   ├── PROVISIONS                          -- 충당부채 비유동 (P3)
│   ├── DEFERRED_TAX                        -- 이연법인세부채 (P4)
│   ├── LEASE                               -- 리스부채 비유동 IFRS 16 (P3)
│   └── DERIVATIVE                          -- 파생금융부채 비유동 (P4)
```

#### 자본 (EQUITY)

```
EQUITY
├── CAPITAL                                 -- 자본금
│   ├── COMMON_STOCK                        -- 보통주자본금 (P3)
│   └── PREFERRED_STOCK                     -- 우선주자본금 (P4)
├── CAPITAL_SURPLUS                         -- 자본잉여금 (P3)
│   └── SHARE_PREMIUM                       -- 주식발행초과금 (P3)
├── OTHER_CAPITAL                           -- 기타자본구성요소
│   └── TREASURY_STOCK                      -- 자기주식 (P4)
├── OCI_ACCUMULATED                         -- 기타포괄손익누계액 (v2.0 §12.1a 참조)
├── RETAINED_EARNINGS                       -- 이익잉여금
│   ├── LEGAL_RESERVE                       -- 법정적립금 (P3)
│   ├── VOLUNTARY_RESERVE                   -- 임의적립금 (P3)
│   └── UNAPPROPRIATED                      -- 미처분이익잉여금 (P2)
└── MINORITY_INTEREST                       -- 비지배지분 (P3)
```

#### 수익 (REVENUE)

```
REVENUE
├── OPERATING (영업수익)
│   ├── SALES (매출)
│   │   ├── MERCHANDISE_SALES               -- 상품매출 (P2)
│   │   ├── PRODUCT_SALES                   -- 제품매출 (P3)
│   │   └── SERVICE_SALES                   -- 용역매출 (P2)
│   └── SALARY (급여수입 — 가계부 전용)
│       ├── BASE                            -- 기본급 (P1)
│       ├── BONUS                           -- 상여금/성과급 (P1)
│       └── PENSION_RECEIVED                -- 퇴직연금수령 (P2)
├── FINANCIAL (금융수익)
│   ├── INTEREST (이자수익)
│   │   ├── DEPOSIT_INTEREST                -- 예금이자 (P1)
│   │   └── LOAN_INTEREST_INCOME            -- 대여금이자 (P3)
│   ├── DIVIDEND                            -- 배당수익 (P2)
│   │   └── STOCK_DIVIDEND                  -- 주식배당 (P2)
│   ├── FX_GAIN                             -- 외환차익 실현
│   ├── FX_TRANSLATION_GAIN                 -- 외화환산이익 미실현 (P2)
│   ├── FVTPL_GAIN                          -- FVTPL 평가이익 (P2)
│   └── DERIVATIVE_GAIN                     -- 파생상품 평가이익 (P4)
├── INVESTMENT (투자수익)
│   ├── DISPOSAL_GAIN_PPE                   -- 유형자산처분이익
│   ├── DISPOSAL_GAIN_INTANGIBLE            -- 무형자산처분이익 (P3)
│   └── DISPOSAL_GAIN_INVESTMENT_PROPERTY   -- 투자부동산처분이익 (P2)
├── RENTAL_INCOME                           -- 임대수익 (P2)
├── BAD_DEBT_REVERSAL                       -- 대손충당금환입 (P3)
└── OTHER                                   -- 기타수익 (잡이익 등)
```

#### 비용 (EXPENSE)

```
EXPENSE
├── LIVING (생활비 — 가계부 전용)
│   ├── FOOD (식비)
│   │   ├── DINING_OUT                      -- 외식 (P1)
│   │   ├── GROCERIES                       -- 식재료 (P1)
│   │   ├── DELIVERY                        -- 배달 (P1)
│   │   └── COFFEE_SNACK                    -- 카페/간식 (P1)
│   ├── TRANSPORT (교통비)
│   │   ├── PUBLIC_TRANSIT                  -- 대중교통 (P1)
│   │   ├── FUEL                            -- 유류비 (P1)
│   │   ├── PARKING_TOLL                    -- 주차/통행료 (P1)
│   │   └── TAXI_RIDE                       -- 택시/라이드 (P1)
│   ├── HOUSING (주거비)
│   │   ├── RENT                            -- 월세 (P1)
│   │   ├── MAINTENANCE_FEE                 -- 관리비 (P1)
│   │   ├── UTILITY_HOME                    -- 수도/전기/가스 (P1)
│   │   └── REPAIR_HOME                     -- 수선비 (P2)
│   ├── COMMUNICATION (통신비)
│   │   ├── MOBILE                          -- 휴대폰 (P1)
│   │   └── INTERNET_TV                     -- 인터넷/TV (P1)
│   ├── MEDICAL (의료비)
│   │   ├── HOSPITAL                        -- 병원비 (P1)
│   │   ├── PHARMACY                        -- 약국 (P1)
│   │   └── DENTAL                          -- 치과 (P2)
│   ├── EDUCATION (교육비)
│   │   ├── TUITION                         -- 학비/수업료 (P1)
│   │   └── ACADEMY                         -- 학원/자격증 (P1)
│   ├── CLOTHING                            -- 의류/미용 (P1)
│   ├── CULTURE                             -- 문화/여가 (P1)
│   ├── GIFTS                               -- 경조사비 (P2)
│   ├── PETS                                -- 반려동물 (P2)
│   ├── INSURANCE_PERSONAL                  -- 개인보험료 생명/실손 (P1)
│   └── OTHER_LIVING                        -- 기타 생활비
│
├── COGS (매출원가)
│   ├── MERCHANDISE (상품매출원가) (P2)
│   │   ├── BEGINNING_INVENTORY             -- 기초상품재고
│   │   ├── PURCHASES                       -- 당기상품매입
│   │   ├── PURCHASE_RETURNS                -- 매입환출/에누리 (차감)
│   │   ├── ENDING_INVENTORY                -- 기말상품재고 (차감)
│   │   └── VALUATION_LOSS                  -- 재고자산평가손실
│   ├── MANUFACTURED (제품매출원가) (P3)
│   │   ├── BEGINNING_INVENTORY             -- 기초제품재고
│   │   ├── MANUFACTURING_COST              -- 당기제품제조원가 (→ MANUFACTURING)
│   │   └── ENDING_INVENTORY                -- 기말제품재고 (차감)
│   └── SERVICE (용역매출원가) (P3)
│
├── SGA (판매비와관리비)
│   ├── SALARY                              -- 급여 (P2)
│   ├── RETIREMENT_BENEFITS                 -- 퇴직급여 (P2)
│   ├── WELFARE                             -- 복리후생비
│   ├── ENTERTAINMENT                       -- 접대비
│   ├── TRAVEL                              -- 여비교통비
│   ├── DEPRECIATION                        -- 감가상각비
│   ├── AMORTIZATION                        -- 무형자산상각비 (P3)
│   ├── BAD_DEBT                            -- 대손상각비 (P2)
│   ├── ADVERTISING                         -- 광고선전비 (P3)
│   ├── RENT                                -- 지��임차료 (P2)
│   ├── INSURANCE                           -- 보험료 (P2)
│   ├── REPAIR                              -- 수선비 (P3)
│   ├── SUPPLIES                            -- 소모품비 (P2)
│   ├── COMMUNICATION                       -- 통신비(사업) (P2)
│   ├── COMMISSION                          -- 지급수수료 (P2)
│   ├── OUTSOURCING                         -- 외주용역비 (P3)
│   ├── FREIGHT                             -- 운반비 (P3)
│   └── RND                                 -- 연구개발비 (P4)
│
├── MANUFACTURING (제조원가) (P4)
│   ├── DIRECT_MATERIALS                    -- 직접재료비
│   │   ├── RAW_MATERIALS_USED              -- 원재료 사용액
│   │   ├── PURCHASED_PARTS                 -- 매입부품비
│   │   └── SUBCONTRACTING                  -- 외주가공비
│   ├── DIRECT_LABOR                        -- 직접노무비
│   │   ├── WAGES                           -- 임금
│   │   └── ALLOWANCES                      -- 제수당/상여
│   └── OVERHEAD                            -- 제조경비(간접비)
│       ├── INDIRECT_MATERIALS              -- 간접재료비
│       ├── INDIRECT_LABOR                  -- 간접노무비
│       ├── DEPRECIATION_FACTORY            -- 감가상각비(공장)
│       ├── UTILITIES_FACTORY               -- 수도광열비(공장)
│       └── OTHER_OVERHEAD                  -- 기타 제조경비
│
├── FINANCIAL (금융비용)
│   ├── INTEREST (이자비용)
│   │   ├── LOAN_INTEREST                   -- 대출이자 (P1)
│   │   └── INSTALLMENT_INTEREST            -- 카드할부이자 (P2)
│   ├── FX_LOSS                             -- 외환차손 실현
│   ├── FX_TRANSLATION_LOSS                 -- 외화환산손실 미실현 (P2)
│   ├── FVTPL_LOSS                          -- FVTPL 평가손실 (P2)
│   └── DERIVATIVE_LOSS                     -- 파생상품 평가손실 (P4)
│
├── TAX (세금/공과)
│   ├── INCOME_TAX                          -- 소득세(개인) (P2)
│   ├── CORPORATE_TAX                       -- 법인세 (P3)
│   ├── PROPERTY_TAX                        -- 재산세 (P2)
│   ├── VEHICLE_TAX                         -- 자동차세 (P2)
│   ├── HEALTH_INSURANCE                    -- 건강보험료 (P1)
│   ├── NATIONAL_PENSION                    -- 국민연금 (P1)
│   ├── EMPLOYMENT_INSURANCE                -- 고용보험 (P2)
│   └── OTHER_TAX                           -- 기타 세금/공과
│
├── IMPAIRMENT (손상차손) (P3)
│   ├── PPE                                 -- 유형자산손상차손
│   ├── INTANGIBLE                          -- 무형자산손상차손
│   └── GOODWILL                            -- 영업권손상차손 (P4)
│
└── OTHER                                   -- 기타비용 (잡손실/기부금 등)
```

#### 원가 공식 참조

**매출원가 산출 공식**:
```
[매출원가]
  기초재고자산 (기초상품 + 기초제품)
+ 당기매입액 (상품매입) 또는 당기제품제조원가
- 기말재고자산 (기말상품 + 기말제품)
- 타계정대체 (자가소비, 광고선전용 등)
= 매출원가 (Cost of Goods Sold)

[제조원가]
  기초재공품
+ 당기 총 제조비용 (직접재료비 + 직접노무비 + 제조경비)
- 기말재공품
= 당기제품제조원가
```

**재고평가방법 (K-IFRS 1002호 §25)**:

| 방법 | 설명 | K-IFRS 허용 |
|------|------|------------|
| 개별법 | 개별 단가 추적 | 허용 (고가 단품) |
| 선입선출법 (FIFO) | 먼저 매입 → 먼저 출고 | 허용 |
| 가중평균법 | 총액 / 총수량 | 허용 |
| 이동평균법 | 매입 시마다 평균 갱신 | 허용 (가중평균의 변형) |
| 후입선출법 (LIFO) | 나중 매입 → 먼저 출고 | **불허** (K-IFRS 1002호 §25) |
| 표준원가법 | 사전 결정 표준 단가 | 허용 (실제원가와 근사 시) |
| 소매재고법 | 소매가 x 원가율 | 허용 (유통업) |

> 아키텍처 대응: Account.valuationMethod enum (P3 예약). MVP에서는 수동 입력.

**재고자산 감액 — 저가법 (K-IFRS 1002호)**:
```
장부금액 vs 순실현가능가치(NRV) 중 낮은 금액으로 평가
NRV = 추정 판매가격 - 추정 완성원가 - 추정 판매비용
감액분 → 매출원가에 가산 (재고자산평가손실)
환입분 → 매출원가에서 차감 (재고자산평가손실환입) — 당초 감액 한도 내
```

> 아키텍처 대응: §15 예약 — InventoryNrvPlugin (결산 플러그인). P4 장기.

**직접비/간접비 구분**:

| 구분 | 직접비 | 간접비 |
|------|--------|--------|
| 재료비 | 원재료비, 매입부품비 | 간접재료비, 소모품비(공장) |
| 노무비 | 생산직 임금, 상여금 | 간접노무비 (공장관리자) |
| 경비 | 외주가공비 | 감가상각비, 임차료, 수도광열비, 보험료 등 |

**원가배부 공식**:
```
간접비 배부 = 간접비 총액 x (배부 기준량 / 배부 기준 총량)
배부 기준: 직접노무시간 / 기계가동시간 / 직접재료비 비율 / 활동기준원가(ABC)
```

> 아키텍처 대응: AccountOwnerShares(지분율) + JEL.activityTypeOverride(활동구분)로 가계부 배분 시나리오 대응. 기업 확장 시 §15 예약 — CostAllocationRule.

#### SAP S/4HANA 개념 매핑 (참고)

| SAP 개념 | MyMoney 대응 | 상태 |
|----------|-------------|------|
| Operating COA | Account 테이블 (단일 COA) | 구현 완료 |
| Account Group (번호범위) | Account.nature enum (5종) | 구현 완료 |
| Profit Center | Perspective (수익+비용+자산+부채 필터) | 구현 완료 |
| Universal Journal (ACDOCA) | JEL 테이블 (FI+CO 통합) | 구현 완료 |
| Statistical Key Figure | AccountOwnerShares (지분율) | 구현 완료 |
| Cost Center | DimensionValues.activityType | 구현 완료 |
| Internal Order | Tags (프로젝트별 비용 추적) | 구현 완료 |
| 이동평균법 (투자 평균단가) | §15 예약 — InvestmentLot | P3 예약 |
| Rule-Based Account Determination | §15 예약 — ClassificationEngine 확장 | P3 예약 |
| Group/Country COA | 불필요 (단일 법인) | 스킵 |
| Secondary Cost Element | 불필요 (내부 배부) | 스킵 |

#### SAP 기업 전용 개념 (스킵 — 근거)

| SAP 개념 | 스킵 이유 |
|---------|---------|
| Group/Country COA | 다법인 연결결산 전용. 단일 가계부에 3계층 COA 불필요 |
| Secondary Cost Element | 내부 배부 전용 원가요소. 가계부에서 간접비 2차 배부 없음 |
| Cost Center 계층 | 부서별 비용 추적. Account 분류+Perspective로 대체 |
| Internal Order (투자주문) | 자본적 지출→자산화. Tags로 프로젝트 추적 대체 |
| Assessment vs Distribution | 2차 원가요소 배부 방식 차이. AccountOwnerShares로 대체 |
| Activity-Based Costing | 활동 기반 간접비 배부. 과도한 복잡성 |
| GR/IR 3-Way Matching | 구매주문→입고→송장 3단계. 카드미지급금으로 2단계 대체 |
| 표준원가법 가격차이 | 제조업 전용 원가 관리 |

#### SAP 설계 인사이트 (MyMoney에 적용한 원칙)

1. **Universal Journal = 단일 진실의 원천**: JEL 테이블에 FI+CO 통합. 별도 CO 테이블 만들지 않음.
2. **Account Group = 화면 제어**: Account.nature에 따라 JEL 입력 UI 필드 가시성 제어 가능.
3. **Profit Center = Perspective**: 수익+비용+자산+부채 필터링으로 내부 P/L+B/S 생성.
4. **이동평균법 = 투자 평균단가**: 주식/펀드 매매 시 이동평균가 자동 계산 (P3 예약).

### 12.1a OCI 계정 경로 (v2.0)

**P1 핵심 5종** — 기타포괄손익누계액(AOCI) 하위:

```
EQUITY.OCI_ACCUMULATED                                    -- 기타포괄손익누계액 (합계)
├── EQUITY.OCI_ACCUMULATED.FVOCI_VALUATION                -- FVOCI 금융자산 평가손익
├── EQUITY.OCI_ACCUMULATED.FOREIGN_CURRENCY_TRANSLATION   -- 해외사업환산손익
├── EQUITY.OCI_ACCUMULATED.EQUITY_METHOD_CHANGES          -- 지분법자본변동
├── EQUITY.OCI_ACCUMULATED.ACTUARIAL                      -- 보험수리적손익 (확정급여 재측정)
└── EQUITY.OCI_ACCUMULATED.OTHER_OCI                      -- 기타 (현금흐름위험회피 등)
```

**P2 나머지 12종** (시드 데이터 추가, UseCase 변경 없음):

```
EQUITY.OCI_ACCUMULATED.AFS_GAIN                           -- 매도가능금융자산평가이익 (구 IFRS)
EQUITY.OCI_ACCUMULATED.AFS_LOSS                           -- 매도가능금융자산평가손실 (구 IFRS)
EQUITY.OCI_ACCUMULATED.FVOCI_EQUITY_GAIN                  -- FVOCI 처분이익_지분상품
EQUITY.OCI_ACCUMULATED.FVOCI_EQUITY_LOSS                  -- FVOCI 처분손실_지분상품
EQUITY.OCI_ACCUMULATED.FX_NET_INVEST_GAIN                 -- 해외순투자환산이익
EQUITY.OCI_ACCUMULATED.FX_NET_INVEST_LOSS                 -- 해외순투자환산손실
EQUITY.OCI_ACCUMULATED.HEDGE_GAIN                         -- 현금흐름위험회피 평가이익
EQUITY.OCI_ACCUMULATED.HEDGE_LOSS                         -- 현금흐름위험회피 평가손실
EQUITY.OCI_ACCUMULATED.EQUITY_METHOD_NEG                  -- 부의지분법자본변동
EQUITY.OCI_ACCUMULATED.REVALUATION                        -- 재평가차액
EQUITY.OCI_ACCUMULATED.FVOCI_VALUATION_GAIN               -- FVOCI 평가이익 (세분리)
EQUITY.OCI_ACCUMULATED.FVOCI_VALUATION_LOSS               -- FVOCI 평가손실 (세분리)
```

**OCI UseCase**: `GenerateComprehensiveIncome`
```dart
class GenerateComprehensiveIncome {
  Future<ComprehensiveIncomeResult> execute({
    required int periodId,
    Perspective? perspective,
  });
}
// 반환: netIncome + continuingOps + discontinuedOps + listOciItems + totalOci + comprehensiveIncome
```
위치: `lib/features/report/usecase/GenerateComprehensiveIncome.dart`

### 12.1b 매각예정자산/부채 (v2.0 P3 예약)

```
ASSET.HELD_FOR_SALE                                       -- 매각예정자산 (IFRS 5)
LIABILITY.HELD_FOR_SALE                                   -- 매각예정부채 (IFRS 5)
```

> IFRS 5: 매각 예정으로 분류된 비유동자산/부채는 유동/비유동과 별도로 재무상태표에 표시.

### 12.2 사용자 확장 규칙

- leaf 노드 하위에만 추가 가능
- 코드 자동 생성 (Path 연장)
- nature 부모 상속 (변경 불가)
- 재무제표 매핑: 부모 위치에 자동 합산

### 12.3 정부회계 확장

DimensionValue 테이블의 entity_type=GOVERNMENT 행 추가. Perspective.recording_direction=Inverted. 활동구분: 경상/자본/세입/세출. 자기자본성: 순자산.

---

## 13. 프로젝트 구조

```
lib/
├── core/                    # B0 Foundation
│   ├── domain/              # 도메인 엔티티 (Transaction, Account, Perspective, Counterparty)
│   ├── models/              # VO (Money, CurrencyCode, Period)
│   ├── interfaces/          # Repository 인터페이스 (H-chain)
│   ├── constants/
│   ├── extensions/
│   ├── errors/
│   └── widgets/             # 공유 UI (Flow Card, Lens Switcher)
├── features/                # Feature-first
│   ├── journal/             # usecase/ + data/ + presentation/
│   ├── account/
│   ├── perspective/
│   ├── counterparty/
│   ├── ocr/
│   ├── report/
│   ├── tax/
│   ├── exchange/
│   └── sync/
├── infrastructure/          # L-chain
│   ├── database/            # tables/ + daos/ + migrations/ + converters/
│   ├── network/
│   ├── ocr_engine/          # ML Kit / 서버 OCR 어댑터
│   └── auth/
└── app/                     # Composition Root
    ├── di/                  # get_it + injectable
    ├── router/
    └── main.dart
```

**의존성 규칙:**
- `core/` ← 어디서든 (B0)
- `features/*/usecase/` → `core/domain/`, `core/interfaces/`만 (H-chain 역전)
- `features/*/data/` → `core/`, `infrastructure/` (L-chain 직접)
- `features/*/presentation/` → `usecase/` + `core/domain/`
- **feature 간 직접 참조 금지** → `core/interfaces/` 간접 참조

---

## 14. 코딩 컨벤션

> 핵심 원칙: "뇌의 사고 속도를 병목시키는 모든 행위는 적폐."
> 코드를 보는 즉시 뇌에 정보가 들어와야 한다. IDE 지원과 무관하게 코드 자체의 가독성이 최우선.

### 네이밍

| 대상 | 컨벤션 | 예시 |
|------|--------|------|
| 파일명 | PascalCase | `TransactionRepository.dart` |
| 클래스명 | 도메인 접두사 + PascalCase | `TransactionRepository`, `BalanceSheetPage` |
| 변수명 | 헝가리안 접두사 + camelCase | `listTransactions`, `mapAccountsByCode` |
| 메서드명 | 동사 시작 + camelCase | `fetchData()`, `buildFlowCard()` |
| private | 언더스코어 접두사 | `_selectedStock` |

### 헝가리안 접두사

| 접두사 | 의미 | 예시 |
|--------|------|------|
| `list` | List | `listTransactions` |
| `map` | Map | `mapAccountsByCode` |
| `set` | Set | `setExpandedIds` |
| `is/has` | bool | `isActive`, `hasPermission` |
| `stream` | Stream | `streamPerspective` |

### Dart 린터 예외

```yaml
# analysis_options.yaml
linter:
  rules:
    file_names: false  # PascalCase 파일명 허용 (가독성 우선)
```

### 코딩 습관

- 한국어 주석 (what보다 why 중심)
- 짧은 메서드는 한 줄 축약
- const 생성자 적극 사용
- 루프 연산은 build() 밖으로 (BLoC 상태에서 처리)
- initState/dispose 틀 잡기 (빈 상태여도 명시)
- 다크 모드 + 초록색 기반 테마

상세: `docs/CODE_STYLE_ANALYSIS.md` 참조

---

## 15. 확장 예약 (구현하지 않되 막히지 않도록)

| 영역 | 예약 사항 |
|------|-----------|
| 해외 소득 | LegalParameter country_code + domain 복합키 |
| 이중 과세 | LegalParameter 조세조약 슬롯 |
| 환율 이중성 | ~~ExchangeRate purpose: Accounting/Tax~~ → **v2.0 구현 완료**: ACCOUNTING/TAX/AVERAGE/CLOSING 4값 |
| CRS/FATCA | Counterparty country_code, Account is_foreign_financial |
| 시스템 프리셋 | "세무 미판정 거래" — dimension_filters: {deductibility: [미판정]} |
| Domain Event | core/interfaces/ IDomainEventBus 예약 |
| 감가상각 | 결산 프로세스 2-b 확장 포인트 |
| Tag Group | Tags.category 컬럼 (향후 비공식 축 → 공식 축 승격 경로) |
| 법인 간 투자지분 (v2.0) | `InvestmentHolding` 테이블: investor_id, investee_id, directOwnership, effectiveOwnership, acquiredAt |
| 결재선 (v2.0) | `Transaction.approvedByOwnerId` — 다인 가구 승인 워크플로우 |
| 특수관계자 거래 한도 (v2.0) | LegalParameter 기반 관계사 거래 한도 초과 판정 |
| 법인 기능통화 (v2.0) | `Counterparty.functionalCurrency` — 해외 법인 기능통화 (다국적 확장) |
| 관계 유효기간 (v2.0) | `Counterparty.effectiveFrom/effectiveTo` — 계열 편입/제외 이력 |
| 매각예정자산/부채 (v2.0) | `ASSET.HELD_FOR_SALE`, `LIABILITY.HELD_FOR_SALE` DimensionPath (IFRS 5) |
| 보고서 제외 계정 (v2.0) | Perspective 시스템 프리셋("주석 제외 거래")으로 대체 — Account에 isNoteExcluded 추가 대신 |
| 재고평가 UseCase (v2.0) | `CalculateInventoryValuation`: 기초재고+매입-기말재고=COGS, 평가방법별(FIFO/가중평균/이동평균) 단가 계산. Account.valuationMethod enum 참조. 결산 플러그인 `InventoryNrvPlugin`(저가법 NRV) 별도 예약 |
| 복합 분류 규칙 (v2.0) | ClassificationRules에 `patternType=RULE_BASED` + `conditions: JSON` 매트릭스 추가. 조건: `{field, op, value}[]` → 거래처+금액대+카드사 복합 조건으로 차변+대변 계정 쌍 자동 결정 (SAP Account Determination 가계부 버전) |
| 원가배부 (v2.0) | SAP CO Assessment/Distribution 패턴. 현행 AccountOwnerShares(지분율)+activityTypeOverride(활동구분)로 가계부 배분 시나리오 대응 완료. 기업 확장 시 `CostAllocationRule` 테이블 신설 |
