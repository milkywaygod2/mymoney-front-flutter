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
                └── Firebase Admin SDK (.NET) — 토큰 검증

[AI 서버]      Python / FastAPI
                └── OCR 서버 위임, AI 분류 모델

[데이터베이스]  MySQL (서버), SQLite (클라이언트 로컬)

[인증]         Firebase Auth (Google/Apple 소셜 로그인)
                + local_auth (생체인증/PIN)
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
  TextColumn get source => text()();
  RealColumn get confidence => real().nullable()();
  IntColumn get periodId => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('SYNCED'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
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
  IntColumn get accountId => integer().references(Accounts, #id)();
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

자동 판정 불가: 특수관계자 거래, 부당행위계산, 대손충당금 → "미판정" 유지

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

### 7.2 결산 스냅샷 5단계

1. **기말 마감 준비**: Draft 잔존 검증, 시산표 자동 생성
2. **자동 결산 전표**: 외환 평가 (Account.nature 기반 차변/대변 방향 결정), 감가상각 (확장)
3. **세무조정**: 자동 판정 → 사용자 리뷰 → 확정
4. **손익 마감**: 수익/비용 계정 → 손익요약 → 이익잉여금 대체
5. **스냅샷 저장**: B/S, P/L 잔액 + 세무조정 결과 + 기초 잔액 이월

### 7.3 외환차손익 자동 전표 매핑

```
Asset + 환율 상승: 차변 해당자산 / 대변 외환차익(미실현)
Asset + 환율 하락: 차변 외환차손(미실현) / 대변 해당자산
Liability + 환율 상승: 차변 외환차손 / 대변 해당부채
Liability + 환율 하락: 차변 해당부채 / 대변 외환차익
```

source: SYSTEM_SETTLEMENT, status: Posted, deductibility: 장부존중

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
| **ReportBloc** | LoadDashboard, LoadReport, ChangeReportPeriod, RefreshExchangeRates | dashboard, currentReport, activePeriod |

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

### 12.1 MVP 5대 분류

- **자산**: 유동(현금성/단기금융/매출채권/선급/재고) + 비유동(투자/유형/무형/기타)
- **부채**: 유동(미지급/단기차입/예수/선수) + 비유동(장기차입/기타)
- **자본**: 자본금 + 이익잉여금 + 기타자본
- **수익**: 영업(급여/사업/매출) + 금융(이자/배당/외환차익) + 투자(처분이익) + 기타
- **비용**: 생활(식비/교통/통신/주거/의료/교육) + 영업(급여/복리후생/접대/여비) + 금융(이자/외환차손) + 감가상각 + 세금 + 기타

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

## 14. 확장 예약 (구현하지 않되 막히지 않도록)

| 영역 | 예약 사항 |
|------|-----------|
| 해외 소득 | LegalParameter country_code + domain 복합키 |
| 이중 과세 | LegalParameter 조세조약 슬롯 |
| 환율 이중성 | ExchangeRate purpose: Accounting/Tax |
| CRS/FATCA | Counterparty country_code, Account is_foreign_financial |
| 시스템 프리셋 | "세무 미판정 거래" — dimension_filters: {deductibility: [미판정]} |
| Domain Event | core/interfaces/ IDomainEventBus 예약 |
| 감가상각 | 결산 프로세스 2-b 확장 포인트 |
| Tag Group | Tags.category 컬럼 (향후 비공식 축 → 공식 축 승격 경로) |
