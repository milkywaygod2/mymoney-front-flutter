# HANDOVER_Grace.md — Grace 모델 전환 핸드오버

> 작성: 2026-04-19
> 담당: Grace (QA검증 + ExchangeRate/Report/Settlement 도메인)
> 워크트리: `E:/_Develop/dart/mymoney-wk-grace` (브랜치: `wk-w8-grace`, HEAD: `5edb281`)

---

## 1. 담당 도메인 + 완료 태스크 (커밋)

| Wave | 태스크 | 커밋 | 주요 파일 |
|------|--------|------|-----------|
| W7 보조 | CounterpartyPage UI | `c736a2b` | `lib/features/counterparty/presentation/CounterpartyPage.dart` |
| W8 | ExchangeRate DAO/Repo + 환산/미실현손익 UseCase | `254a7e0` | exchange/ 5개 파일 |
| W9 | 결산 프로세스 + ReportBloc (S08b) | `850519e` | report/ 7개 파일 |
| QA | QA Loop 6 iterations (34건 수정) | `0713d18`~`3611b18` | 아래 버그/수정 섹션 참조 |
| DOCS | 엑셀 연결결산보고서 11시트 분석 | `19d051c` | `.cowork/CW_ANALYSIS_Grace.md` |

---

## 2. 진행 중 / 다음 작업

| 태스크 | 상태 | 비고 |
|--------|------|------|
| S09 Flow Card 다통화 노드 UI | 대기 | EvaluateUnrealizedFxGain UseCase 완료됨, UI 미구현 |
| S08b FiscalPeriods isClosed 스키마 확장 | 대기 | AppDatabase.g.dart 재생성 필요 |
| S08b 3단계 TaxRuleEngine 연동 | 대기 | S08a (Arjun 담당) 완성 후 RunSettlement 3단계 TODO 교체 |
| CounterpartyBloc 완성 후 BlocBuilder 마이그레이션 | 대기 | 현재 직접 repo 주입 방식 |
| 플랜 v2.0 미커버 18건 반영 | 대기 | CW_ANALYSIS_Grace.md → 플랜 v2.0에 입력 |

---

## 3. 설계 결정 (Why)

### 3-1. Enum 직렬화 원칙 (핵심)

- **단일단어 enum** (예: `AccountNature.asset`, `PostingStatus.draft`) → `.name.toUpperCase()` 저장 → `byName(str.toLowerCase())` 로드
  - DB에 `'ASSET'`, `'DRAFT'` 등 대문자 저장
- **복합 camelCase enum** (예: `TransactionSource.systemSettlement`, `Deductibility.bookRespected`) → `.name` 그대로 저장 → `byName(raw)` 로드
  - `.name.toUpperCase()` 하면 `'SYSTEMSETTLEMENT'` (붙은 대문자)가 되어 역직렬화 불가
  - DB에 `'systemSettlement'`, `'bookRespected'` 저장

**Why**: `byName()`은 case-sensitive. 대문자화 시 camelCase enum은 단어 경계가 소멸되어 매핑 실패.

### 3-2. SQL 리터럴은 항상 대문자

- `IN ('DRAFT', 'POSTED')` — 단일단어 enum의 DB 저장값이 대문자이므로 SQL 리터럴도 대문자
- 틀린 예: `IN ('draft', 'posted')` → 레코드 조회 0건

### 3-3. ExchangeRateNotFoundError 위치

- `DomainErrors.dart` 미수정, `ConvertCurrency.dart` 내부에 정의
- Why: 해당 에러가 오직 ConvertCurrency UseCase에서만 발생하므로 응집도 우선

### 3-4. retainedEarningsAccountId 호출자 전달 방식

- `RunSettlement.execute(periodId, snapshotDate, retainedEarningsAccountId)` — 호출자가 계정 ID 전달
- Why: UseCase가 계정 조회 로직에 의존하지 않도록 분리 (SRP)
- SettlementPage에서 initState에 IAccountRepository.findByDimensionPath()로 조회

---

## 4. 버그/수정 이력 (QA Loop 34건)

| 커밋 | 수정 내용 | 파일:라인 |
|------|-----------|-----------|
| `0713d18` | AccountNature SQL `IN ('asset'...)` → `IN ('ASSET'...)` + byName toLowerCase | `ReportQueryService.dart:100,153,118,170,188`, `AccountRepository.dart:73` |
| `b7c0c40` | TransactionSource/Deductibility `.name.toUpperCase()` → `.name` (camelCase 통일) | `RunSettlement.dart:4개소/10개소` |
| `b7c0c40` | Draft/Posted SQL 리터럴 소문자 → 대문자 | `ReportQueryService.dart` |
| `b7c0c40` | SettlementPage `show SettlementStep` → `show SettlementStep, SettlementResult` | `SettlementPage.dart:8` |
| `e1a08f8` | SettlementPage `context.read<IAccountRepository>()` → `getIt<IAccountRepository>()` | `SettlementPage.dart:69` |
| `96d5843` | SettlementPage unused show import 제거 | `SettlementPage.dart` |
| `5c3abd4` | Deductibility camelCase 통일 (동일 패턴 반복) | `RunSettlement.dart` |

---

## 5. 워크트리

| 경로 | 브랜치 | HEAD |
|------|--------|------|
| `E:/_Develop/dart/mymoney-front-flutter` | `agent-automation` | `08476a7` |
| `E:/_Develop/dart/mymoney-wk-grace` | `wk-w8-grace` | `5edb281` |
| `E:/_Develop/dart/mymoney-wk-arjun` | `wk-w7-arjun` | `5425ce8` |
| `E:/_Develop/dart/mymoney-wk-omar` | `wk-w7-omar` | `e3ba8be` |

Grace 작업은 `wk-w8-grace` 브랜치. agent-automation에 머지 후 계속 작업.

---

## 6. Gotcha (함정/주의사항)

1. **byName() case-sensitive**: Dart enum의 `byName()`은 대소문자 완전 일치. DB 저장값 확인 필수.
2. **복합 camelCase enum 절대 toUpperCase() 금지**: `systemSettlement.name.toUpperCase()` = `'SYSTEMSETTLEMENT'` — 역직렬화 불가.
3. **python3 명령어 불가 (Windows)**: 터미널에서 `python3` 입력 시 Exit code 49. `python` 사용.
4. **CounterpartyPage BLoC 미연결**: 현재 `ICounterpartyRepository` 직접 주입. W7 BLoC 완성 후 마이그레이션 필요.
5. **FiscalPeriods.isClosed 컬럼 미존재**: RunSettlement 5단계 스냅샷은 TODO 상태. 스키마 확장 시 AppDatabase.g.dart 재생성.
6. **Write 도구 "File has not been read yet" 오류**: 기존 파일 덮어쓰기 전 Read 도구로 최소 1회 읽기 필수.
7. **DI 등록 필수**: 새 Repository/UseCase 추가 시 `Injection.dart`에 `getIt.registerLazySingleton` 누락하면 런타임 오류.

---

## 7. 소스 참조

| 파일 | 목적 |
|------|------|
| `.cowork/CW_ANALYSIS_Grace.md` | 연결결산보고서 11시트 전수 분석 (커버됨 17, 미커버 18건, 신규계정 33개) |
| `.cowork/CW_ARCHITECTURE.md` | 아키텍처 기준 (섹션 12.1 MVP 5대 분류, 7.3 외환차손익, 10.1 결산 프로세스) |
| `.cowork/CW_HANDOFF_Grace.md` | Grace 이전 세션 인계 문서 (W7/W8/W9 구현 상세) |
| `lib/features/exchange/usecase/EvaluateUnrealizedFxGain.dart` | 미실현 외환차손익 계산 UseCase |
| `lib/features/report/usecase/RunSettlement.dart` | 결산 5단계 오케스트레이터 |
| `lib/features/report/data/ReportQueryService.dart` | B/S + P/L + 시산표 customSelect SQL |
| `lib/app/di/Injection.dart` | DI 컴포지션 루트 |
