# HANDOVER_Arjun.md — 모델 전환 인수인계 문서

> 작성자: Arjun-2 (Sonnet 4.6)
> 작성일: 2026-04-19
> 인수대상: 신규 Arjun 에이전트
> 브랜치: `wk-w7-arjun` (워크트리: `E:/_Develop/dart/mymoney-wk-arjun`)
> 메인 작업 브랜치: `agent-automation`

---

## 1. 담당 도메인 및 완료 태스크

### 담당 도메인

- **S07 Counterparty**: 거래처 CRUD + alias 관리 + 매처
- **S08a Tax 규칙엔진**: 세무조정 규칙엔진 + AutoClassify UseCase + TaxBloc
- **QA Loop**: tax/ocr/journal-usecase 도메인 QA 검증 (Iter1~6)
- **엑셀 분석**: 특수관계자 주석패키지 11시트 전수 분석 + CW_ANALYSIS_Arjun.md 작성

### 완료 태스크 및 커밋

| Wave | 태스크 | 커밋 해시 | 내용 |
|------|--------|-----------|------|
| W7 | S07 Counterparty data | `b2d293e` (wk-w7-arjun → `07cafd4` merge) | CounterpartyDao/Repository/Matcher |
| W8 | S08a 세무조정 | `3472273` | TaxRuleEngine/AutoClassify/TaxBloc |
| QA | QA Loop Iter1~6 | `5c3abd4`, `b7c0c40` (Grace FIX 검증) | 6 iterations, 총 34건, COMPLETE |
| DOCS | 엑셀 11시트 분석 | `19d051c` | CW_ANALYSIS_Arjun.md 710줄 |
| DOCS | HANDOFF 갱신 | `08476a7` | CW_HANDOFF_Arjun.md |

### 구현 파일 위치

| 파일 | 라인 수 | 내용 |
|------|---------|------|
| `lib/features/counterparty/data/CounterpartyDao.dart` | ~140 | Drift DAO — CRUD + alias |
| `lib/features/counterparty/data/CounterpartyDao.g.dart` | ~210 | build_runner 자동 생성 |
| `lib/features/counterparty/data/CounterpartyRepository.dart` | ~120 | ICounterpartyRepository 구현체 |
| `lib/features/counterparty/data/CounterpartyMatcher.dart` | ~60 | ICounterpartyMatcher 구현체 |
| `lib/features/tax/data/TaxRuleEngine.dart` | ~200 | 11개 자동 판정 규칙 |
| `lib/features/tax/usecase/AutoClassifyDeductibility.dart` | ~120 | 자동 deductibility 분류 |
| `lib/features/tax/usecase/ClassifyIncomeType.dart` | ~80 | 소득 8종 자동 분류 |
| `lib/features/tax/presentation/TaxBloc.dart` | ~130 | TaxBloc (4개 이벤트) |
| `lib/features/tax/presentation/TaxEvent.dart` | ~50 | freezed v3 이벤트 |
| `lib/features/tax/presentation/TaxState.dart` | ~50 | freezed v3 상태 |
| `lib/features/tax/presentation/TaxAdjustmentPage.dart` | ~200 | 세무조정 3단계 UI |
| `.cowork/CW_ANALYSIS_Arjun.md` | ~710 | 특수관계자 엑셀 11시트 분석 |

---

## 2. 현재 진행 중인 작업 및 다음 단계

### 현재 상태

- 모든 구현 완료, QA Loop COMPLETE (연속 2회 풀패스)
- 엑셀 분석 완료 → `CW_ANALYSIS_Arjun.md` 11시트 전수 문서화 완료
- **현재 대기 중**: team-lead의 다음 지시 대기

### 다음 단계 후보 (CW_STATE_TASK.md 기준)

| Wave | Subject | 태스크 | 비고 |
|------|---------|--------|------|
| W7 | S07 | Counterparty CRUD + alias | **Arjun 완료** |
| W7 | S07 | OCR 파이프라인 (ML Kit) | Omar 담당, 패키지 미설치 |
| W7 | S07 | ClassificationEngine (로직트리) | 대기 |
| W8 | S08a | 세무조정 규칙엔진 | **Arjun 완료** |
| W8 | S09 | 외환차손익 (다통화) | 대기 |
| W9 | S08b | 결산 프로세스 5단계 | Grace 완료 |
| W10 | S10 | 동기화 (Outbox+Delta) | 서버 API 필요 |
| W10 | S11 | 인증 (OAuth2+생체) | 네이티브 설정 필요 |

**신규 에이전트가 이어받을 가능성 높은 작업**: 플랜 v2.0 후속 구현 또는 CW_ANALYSIS 기반 아키텍처 갱신

---

## 3. 핵심 설계 결정 사항

### 3.1 Counterparty Matcher 신뢰도 체계

```
1순위: 정확 일치 (alias DB) → confidence = 1.0
2순위: 부분 일치 (LIKE '%text%') → confidence = 0.7
3순위: 매칭 없음 → null 반환
```

**Why**: OCR 결과의 표기 변형 (공백/특수문자 차이) 대응 + 과신뢰 방지 (0.7 이상에서만 자동 적용)

### 3.2 TaxRuleEngine 규칙 우선순위

```
손금불산입(nonDeductible) 판정 우선
→ 한도초과(deductibleLimited) 판정
→ 손금산입(deductible) 판정
→ 미판정(undetermined) fallback
```

**Why**: 세무에서는 공제 불가 항목을 보수적으로 먼저 걸러내야 과소납부 위험 방지

### 3.3 TaxBloc.ConfirmSettlement 미판정 잔존 시 에러 반환

```dart
if (state.listPendingItems.isNotEmpty) {
  emit(state.copyWith(errorMessage: '미판정 항목이 남아있습니다'));
  return;
}
```

**Why**: 미판정 항목 존재 시 결산 확정 허용 시 세무조정 누락 위험 — 강제 차단 정책

### 3.4 enum 저장 포맷 — camelCase (중요 gotcha)

- `TransactionSource`: `manual`, `ocr`, `cardApi`, `csvImport`, `ntsImport`, `systemSettlement`
- `Deductibility`: `undetermined`, `deductible`, `deductibleLimited`, `nonDeductible`, `incomeInclusion`, `incomeExclusion`, `bookRespected`
- `TransactionStatus`, `SyncStatus`, `EntryType`: **UPPERCASE** (기존 DB 데이터 유지)

**Why**: Grace의 `5c3abd4` / `b7c0c40` 커밋에서 camelCase로 통일. DB 재생성 전제. 혼합 금지.

### 3.5 BLoC Stream 5경로 연결 구조

`lib/app/di/Injection.dart:_connectBlocStreams()`:
1. PerspectiveBloc → JournalBloc (Perspective 변경 → 거래 리필터링)
2. PerspectiveBloc → ReportBloc (Perspective 변경 → 보고서 갱신)
3. PerspectiveBloc → TaxBloc (Perspective 변경 → 미판정 갱신)
4. JournalBloc → TaxBloc (신규 posted만 RunAutoClassification 트리거)
5. JournalBloc → ReportBloc (거래 목록 로드 완료 → 대시보드 갱신)

**Why**: 경로 4는 `setPrevPostedIds` diff로 신규 posted만 처리 — 전체 재판정 시 성능 문제 방지

---

## 4. 발견한 버그/이슈 및 해결 방법

### 4.1 TransactionSource/Deductibility UPPERCASE 불일치 (Grace FIX)

- **증상**: DB 저장 시 `BOOK_RESPECTED`, 읽기 시 `byName("BOOK_RESPECTED")` → 예외
- **원인**: Grace의 초기 구현이 `.name.toUpperCase()` / `toLowerCase()` 혼용
- **해결**: `5c3abd4` — `.name` (camelCase 그대로) / `.byName()` (camelCase 그대로)
- **파일**: `lib/features/journal/data/TransactionRepository.dart:78,149`

### 4.2 SettlementPage BlocProvider 미등록 crash

- **증상**: `context.read<ReportBloc>()` 호출 시 "BlocProvider not found" crash
- **원인**: SettlementPage가 `BlocProvider` 없이 독립 라우팅됨
- **해결**: `e1a08f8` — `context.read` → `getIt<ReportBloc>()` 교체
- **파일**: `lib/features/report/presentation/SettlementPage.dart`

### 4.3 AccountNature UPPERCASE/lowercase SQL 불일치

- **증상**: ReportQueryService SQL 조건 `= 'asset'` vs DB 저장값 `ASSET` 불일치
- **해결**: `0713d18` — SQL 조건 UPPERCASE 통일 + `byName()` 정규화
- **파일**: `lib/features/report/data/ReportQueryService.dart`

### 4.4 PerspectiveBloc 단일 subscription 필요

- **증상**: PerspectiveBloc stream을 3개별 listen 시 동일 이벤트 3번 dispatch
- **해결**: `5457d3e` — 단일 stream.listen 내부에서 3개 BLoC에 add
- **파일**: `lib/app/di/Injection.dart:257-265`

### 4.5 BLoC Stream 경로4 전체 재판정 문제

- **증상**: JournalBloc 상태 변경마다 모든 posted 거래 재판정 → 성능 저하
- **해결**: `d3794b9` — `setPrevPostedIds` diff로 신규 posted ID만 추출하여 처리
- **파일**: `lib/app/di/Injection.dart:271-288`

---

## 5. 워크트리 경로 및 브랜치명

| 항목 | 값 |
|------|-----|
| 메인 작업 브랜치 | `agent-automation` |
| Arjun 워크트리 브랜치 | `wk-w7-arjun` |
| Arjun 워크트리 경로 | `E:/_Develop/dart/mymoney-wk-arjun` |
| 현재 커밋 (agent-automation) | `08476a7` |
| Grace 워크트리 | `E:/_Develop/dart/mymoney-wk-grace` (wk-w8-grace) |
| Omar 워크트리 | `E:/_Develop/dart/mymoney-wk-omar` (wk-w7-omar) |

**주의**: wk-w7-arjun 브랜치는 이미 agent-automation에 머지 완료 (`07cafd4`). 신규 작업은 새 워크트리 브랜치 생성 필요.

---

## 6. 신규 에이전트 gotcha / 주의사항

### 6.1 enum 저장 포맷 혼용 절대 금지

`TransactionSource`와 `Deductibility`는 **camelCase**로 저장.
`TransactionStatus`, `SyncStatus`, `EntryType`은 **UPPERCASE**로 저장.
절대 혼용하지 말 것. `byName()` 호출 시 대소문자 불일치 = 런타임 예외.

### 6.2 Drift Companion 생성 패턴

```dart
// INSERT: autoIncrement id는 Value.absent()
TransactionsCompanion.insert(
  id: const Value.absent(),  // 자동 생성
  ...
)
// UPDATE: id는 Value(실제값)
TransactionsCompanion(
  id: Value(existingId),
  ...
)
```

### 6.3 freezed v3 패턴 (v2와 다름)

```dart
// v3: abstract class + factory constructor
abstract class TaxEvent {
  const factory TaxEvent.loadPendingItems() = LoadPendingItems;
}
// v2: @freezed annotation 방식 — 현재 프로젝트에서 사용 금지
```

### 6.4 DI 등록 순서

`lib/app/di/Injection.dart`: DAOs → Repositories → Infrastructure → UseCases → BLoCs → `_connectBlocStreams()`
순서 위반 시 `getIt` 미등록 예외 발생.

### 6.5 build_runner 필수 실행 조건

Drift DAO 수정 시 반드시 `dart run build_runner build --delete-conflicting-outputs` 실행.
`.g.dart` 파일이 오래된 경우 런타임 오류 발생.

### 6.6 QA Loop 결과

- **COMPLETE** 상태 (연속 2회 FIXED 0건 풀패스)
- CW_STATE_TASK.md의 `LOOP_STATE: COMPLETE` 확인
- 신규 구현 시 Step 1(원본대조) → Step 2(연결) → Step 3(런타임) 검증 사이클 준수

### 6.7 플랜 v2.0 후보 (CW_ANALYSIS_Arjun.md 기반)

우선순위 A 항목은 다음 스프린트에서 CW_ARCHITECTURE.md 갱신 필요:
- `Counterparty.relatedPartyType` 열거형 추가
- `ExchangeRates.purpose` 확장 (INCOME_STATEMENT / BALANCE_SHEET)
- `LegalParameter` 대손충당금 설정율 규칙

---

## 7. 원본 소스 참조 위치

| 문서/파일 | 경로 |
|----------|------|
| 전체 아키텍처 | `E:/_Develop/dart/mymoney-front-flutter/.cowork/CW_ARCHITECTURE.md` |
| 태스크 상황판 | `E:/_Develop/dart/mymoney-front-flutter/.cowork/CW_STATE_TASK.md` |
| 엑셀 분석 (Arjun) | `E:/_Develop/dart/mymoney-front-flutter/.cowork/CW_ANALYSIS_Arjun.md` |
| 엑셀 분석 (Grace) | `E:/_Develop/dart/mymoney-front-flutter/.cowork/CW_ANALYSIS_Grace.md` |
| 엑셀 분석 (Omar) | `E:/_Develop/dart/mymoney-front-flutter/.cowork/CW_ANALYSIS_Omar.md` |
| 이전 HANDOFF (W7~W8) | `E:/_Develop/dart/mymoney-front-flutter/.cowork/CW_HANDOFF_Arjun.md` |
| 계약/인터페이스 | `E:/_Develop/dart/mymoney-front-flutter/.cowork/CW_CONTRACTS.md` |
| 조직 상태 | `E:/_Develop/dart/mymoney-front-flutter/.cowork/CW_STATE_ORG.md` |
| DI 진입점 | `E:/_Develop/dart/mymoney-front-flutter/lib/app/di/Injection.dart` |
| Counterparty DAO | `E:/_Develop/dart/mymoney-front-flutter/lib/features/counterparty/data/CounterpartyDao.dart` |
| TaxRuleEngine | `E:/_Develop/dart/mymoney-front-flutter/lib/features/tax/data/TaxRuleEngine.dart` |
| AutoClassifyDeductibility | `E:/_Develop/dart/mymoney-front-flutter/lib/features/tax/usecase/AutoClassifyDeductibility.dart` |
| TransactionRepository (enum 저장) | `E:/_Develop/dart/mymoney-front-flutter/lib/features/journal/data/TransactionRepository.dart` |
| Enums 전체 | `E:/_Develop/dart/mymoney-front-flutter/lib/core/constants/Enums.dart` |

---

*HANDOVER 완료. 신규 에이전트는 섹션 3~6 필독 후 작업 시작 권장.*
