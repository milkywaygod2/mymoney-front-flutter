# HANDOVER_Omar.md — Omar 에이전트 인수인계 문서

> 에이전트: Omar (Sync/Infrastructure/Core + Journal Data + App)
> 작성일: 2026-04-19
> 대상: 신규 인계 에이전트
> 현재 브랜치: `agent-automation`
> 워크트리: `E:/_Develop/dart/mymoney-wk-omar` (브랜치: `wk-w7-omar`, 머지 완료)

---

## 1. 담당 도메인

| 도메인 | 설명 |
|--------|------|
| Sync (S10) | Outbox 패턴 기반 동기화, Delta Sync, 지수 백오프 |
| Auth (S11) | OAuth2 (Google/Apple), 생체인증/PIN, JWT 토큰 관리 |
| OCR 파이프라인 (S07 일부) | ML Kit OCR, ClassificationEngine, OcrBloc |
| Core 인프라 | DI(Injection.dart), BLoC Stream 연결, 전체 QA |
| 엑셀 분석 | NAVER IFRS Package 58시트 전수 도메인 분석 |

---

## 2. 완료 태스크 (커밋 포함)

### W7 — OCR 파이프라인 + ClassificationEngine (S07)

| 커밋 | 내용 |
|------|------|
| `763df6c` | OCR 파이프라인 + ClassificationEngine 초기 구현 (5파일 신규) |
| `9a82202` | analyze 오류 수정 (Expression.and, CurrencyCode import) |
| `9053e97` | OcrBloc 대변 JEL 자동생성 + retainedEarningsAccountId 시드 조회 |

**구현 파일:**
- `lib/features/ocr/data/ClassificationEngine.dart` — 로직트리 분류 엔진
- `lib/features/ocr/data/OcrService.dart` — IOcrService + MobileOcrService/ServerOcrService stub
- `lib/features/ocr/presentation/OcrBloc.dart` — OcrPhase 8단계 상태머신
- `lib/features/ocr/presentation/OcrCapturePage.dart` — OCR UI (이미지 소스 선택 + 파싱 결과 프리뷰)

### W10 — 동기화 + 인증 인프라 (S10+S11)

| 커밋 | 내용 |
|------|------|
| `6bb5796` | 동기화 + 인증 인프라 stub 구현 (5파일 신규) |

**구현 파일:**
- `lib/features/sync/data/ConnectivityMonitor.dart` — 네트워크 상태 감지 stub
- `lib/features/sync/data/OutboxProcessor.dart` — Outbox FIFO 처리 (PENDING→SYNCED/CONFLICT/FAILED)
- `lib/features/sync/data/SyncService.dart` — 동기화 오케스트레이터 + 지수 백오프
- `lib/infrastructure/auth/TokenStorage.dart` — JWT 토큰 저장소 (DevTokenStorage/SecureTokenStorage stub)
- `lib/infrastructure/auth/AuthService.dart` — 인증 서비스 stub (Google/Apple/생체인증)

### QA Loop (전체 프로젝트 품질 보증)

| 커밋 | 내용 |
|------|------|
| `e1a08f8` | SettlementPage context.read→getIt 교체 (BlocProvider 미등록 crash 방지) |
| `0713d18` | AccountNature UPPERCASE/lowercase 불일치 수정 |
| `269cb23` | ILegalParameterRepository dynamic 타입 → LegalParameter 타입 정합성 수정 |
| `d3794b9` | BLoC Stream 경로4 — 신규 posted만 RunAutoClassification 트리거 |
| `5457d3e` | BLoC Stream 연결 — PerspectiveBloc 단일 subscription 통합 |
| `5a3fb03` | Iter2 Step1 GAP 수정 (PerspectiveRepository JSON파싱/SaveAsPreset UI 등) |
| `96d5843` | SettlementPage unused show import 제거 (SettlementStepResult) |
| `b7c0c40` | TransactionSource camelCase 통일 + Draft SQL 대문자 |
| `5c3abd4` | Deductibility camelCase 통일 — BOOK_RESPECTED → bookRespected |

**QA 최종 결과:** 6 iterations, 총 34건 수정, 연속 2회 풀패스 → COMPLETE

### 엑셀 분석

| 커밋 | 내용 |
|------|------|
| `4dbb704` | 엑셀 3파일 시트별 전수 분석 초판 |
| `19d051c` | NAVER IFRS Package 58시트 전수 재작성 (1327줄) |

**결과물:** `.cowork/CW_ANALYSIS_Omar.md` (58시트 전수, 각 시트별 컬럼구조/도메인개념/CW커버여부/미커버항목)

---

## 3. 현재 진행 중 / 다음 작업

### 진행 중 (없음)
모든 태스크가 완료 상태. QA Loop COMPLETE.

### 다음 예정 작업

현재 CW_STATE_TASK.md 기준 대기 중인 Omar 관련 태스크:

| Wave | Subject | 내용 | 비고 |
|------|---------|------|------|
| W7 | S07 | OCR 파이프라인 실체화 (ML Kit) | `google_mlkit_text_recognition` 패키지 설치 필요 |
| W7 | S07 | Counterparty CRUD + alias | 별도 배정 없음 (Arjun 담당 가능성) |
| W10 | S10 | 동기화 실체화 | 서버 API 필요, `connectivity_plus` 패키지 |
| W10 | S11 | 인증 실체화 | 네이티브 설정 필요, 소셜 로그인 패키지 |

---

## 4. 설계 결정 (Why)

### DI: registerSingleton만 사용
- **결정**: `get_it`에서 `registerFactory`/`registerLazySingleton` 없이 `registerSingleton`만 사용
- **이유**: BLoC는 앱 생명주기 동안 단일 인스턴스가 필요. Stream 구독이 여러 곳에서 공유되므로 factory 사용 시 구독 누락 발생.
- **위치**: `lib/app/di/Injection.dart`

### BLoC Stream 5경로 연결 순서
- **결정**: 모든 BLoC 싱글톤 등록 완료 후 `_connectBlocStreams()` 한 번에 호출
- **이유**: Stream 연결 시점에 모든 BLoC가 이미 존재해야 함. 순서 보장 필요.
- **경로**: 거래저장→OCR자동분류→결산→Perspective갱신→동기화 트리거
- **위치**: `Injection.dart:_connectBlocStreams()`

### enum 직렬화: camelCase
- **결정**: DB 저장 시 `enum.name` (camelCase), 복원 시 `Enum.values.byName()`
- **이유**: Dart enum `.name`은 camelCase. UPPERCASE로 저장하면 `byName()` 실패.
- **예외**: `OutboxEntry.status` 필드는 PENDING/SYNCED/CONFLICT/FAILED/SENDING — 이것은 enum이 아닌 문자열 상수로, camelCase 규칙과 무관.
- **위치**: `lib/infrastructure/database/converters/TypeConverters.dart`

### SettlementPage: context.read → getIt
- **결정**: `SettlementPage`의 `IAccountRepository` 접근은 `context.read` 대신 `getIt<IAccountRepository>()` 사용
- **이유**: `SettlementPage`는 별도 BlocProvider 트리 밖에서 렌더링될 수 있음. context.read 시 `StateError` 발생.
- **위치**: `lib/features/report/presentation/SettlementPage.dart:69`

### OutboxProcessor: SENDING 상태 재처리
- **결정**: `processNext()`에서 PENDING뿐만 아니라 SENDING 상태도 재처리 대상에 포함
- **이유**: 앱 강제 종료 시 SENDING 상태로 고착될 수 있음. 재시작 시 SENDING을 PENDING으로 복구하지 않으면 영구 손실.
- **위치**: `lib/features/sync/data/OutboxProcessor.dart`

---

## 5. 버그 / 수정 이력

| 번호 | 버그 | 원인 | 수정 |
|------|------|------|------|
| B1 | SettlementPage crash | BlocProvider 미등록 상태에서 context.read 호출 | getIt으로 교체 (`e1a08f8`) |
| B2 | AccountNature SQL 조건 불일치 | DB에 UPPERCASE로 저장, byName 시 대소문자 불일치 | SQL 조건 정규화 + TypeConverter 통일 (`0713d18`) |
| B3 | ILegalParameterRepository 타입 오류 | 반환 타입 dynamic → LegalParameter로 변경 필요 | 타입 명시 (`269cb23`) |
| B4 | BLoC 경로4 과다 트리거 | posted 거래 전체에 RunAutoClassification 실행 | 신규 posted만 트리거하도록 필터 추가 (`d3794b9`) |
| B5 | PerspectiveBloc 중복 subscription | BLoC 재초기화 시 이전 구독 미해제 | 단일 subscription 통합 (`5457d3e`) |
| B6 | TransactionSource DB 불일치 | CARD_API 등 UPPER_SNAKE로 저장, byName 실패 | camelCase 통일 (`b7c0c40`) |
| B7 | Deductibility DB 불일치 | BOOK_RESPECTED로 저장, bookRespected와 불일치 | camelCase 통일 (`5c3abd4`) |
| B8 | SettlementPage unused show import | SettlementStepResult import 후 미사용 | import 제거 (`96d5843`) |

---

## 6. 워크트리

| 워크트리 경로 | 브랜치 | 상태 |
|-------------|--------|------|
| `E:/_Develop/dart/mymoney-front-flutter` | `agent-automation` | 메인 작업 브랜치 (현재) |
| `E:/_Develop/dart/mymoney-wk-omar` | `wk-w7-omar` | Omar W7 작업 워크트리 (머지 완료, 보존 중) |

`wk-w7-omar` 브랜치는 `agent-automation`에 이미 머지(`07cafd4`)되어 있음. 삭제 시 영향 없음.

---

## 7. Gotcha (주의사항)

1. **`getIt<T>()`는 등록 순서 중요**: `Injection.dart`에서 의존성을 먼저 등록해야 함. `_connectBlocStreams()`는 반드시 마지막에 호출.

2. **`OutboxEntry.status`는 UPPERCASE 문자열**: Drift 테이블에서 status 컬럼은 `PENDING/SYNCED/CONFLICT/FAILED/SENDING` — enum이 아님. `byName()` 사용 금지.

3. **`TransactionStatus`는 `.toLowerCase()` 후 byName**: `status` 필드는 DB에 UPPERCASE 저장됨. 복원 시 반드시 `.toLowerCase()` 적용. source/deductibility는 이미 camelCase라 불필요.

4. **BLoC Stream 구독 시 중복 주의**: `_connectBlocStreams()` 내부 구독은 앱 생명주기 동안 한 번만 실행됨. 재구독 로직 없음 — Hot Restart 시 DI 재초기화 필요.

5. **`SettlementPage`에서 `context.read` 금지**: `ReportBloc` 외의 Repository 접근은 반드시 `getIt<T>()` 사용.

6. **COA 계층 설계 참고**: NAVER IFRS COA는 10자리 6계층 (XXXXXX.XX.XX). MyMoney 계정과목의 `dimensionPath` 설계 시 이 구조를 참고할 것.

---

## 8. 소스 참조 (핵심 파일)

| 파일 | 역할 | 핵심 라인 |
|------|------|----------|
| `lib/app/di/Injection.dart` | DI 컨테이너 + Stream 연결 | `_connectBlocStreams()` |
| `lib/features/sync/data/OutboxProcessor.dart` | Outbox FIFO 처리 | `processNext()`, `fetchConflicts()` |
| `lib/features/sync/data/SyncService.dart` | 동기화 오케스트레이터 | `triggerSync()`, 지수 백오프 |
| `lib/infrastructure/auth/AuthService.dart` | 인증 서비스 stub | `signInWithGoogle()`, `refreshToken()` |
| `lib/infrastructure/auth/TokenStorage.dart` | JWT 토큰 저장 | `TokenPair` VO, `isExpired` |
| `lib/features/ocr/data/ClassificationEngine.dart` | 거래 자동분류 | 패턴매칭, 우선순위 정렬 |
| `lib/features/ocr/presentation/OcrBloc.dart` | OCR 상태머신 | `OcrPhase` enum, 8단계 |
| `lib/infrastructure/database/converters/TypeConverters.dart` | enum DB 직렬화 | `TransactionSourceConverter`, `DeductibilityConverter` |
| `.cowork/CW_ANALYSIS_Omar.md` | NAVER IFRS 58시트 분석 | 미커버 항목 우선순위표 |

---

## 9. 미완료 항목 (다음 에이전트 인수)

### S07 OCR 실체화 (패키지 설치 필요)
```
패키지: google_mlkit_text_recognition, image_picker
파일: lib/features/ocr/data/OcrService.dart (MobileOcrService)
파일: lib/features/ocr/presentation/OcrCapturePage.dart (실제 카메라 연동)
```

### S10 동기화 실체화 (서버 API + 패키지 필요)
```
패키지: connectivity_plus
파일: lib/features/sync/data/ConnectivityMonitor.dart
파일: lib/features/sync/data/OutboxProcessor.dart (IServerApiClient 구현체 주입)
서버: C# 백엔드 API 엔드포인트 확정 후 진행
```

### S11 인증 실체화 (네이티브 설정 + 패키지 필요)
```
패키지: google_sign_in, sign_in_with_apple, local_auth, flutter_secure_storage
파일: lib/infrastructure/auth/AuthService.dart
파일: lib/infrastructure/auth/TokenStorage.dart
네이티브: iOS/Android OAuth2 콜백 URL 설정 필요
```

### IFRS 미커버 항목 (도메인 확장 시 참고)
HIGH 우선순위 항목 (W8-W9 설계 시 참고):
- IAS21 FX 재평가 (다통화 외환차손익)
- IAS19 퇴직급여 DB형 (확정급여형)
- IAS36 자산손상
- 이연법인세 DTA/DTL
- 공정가치 3단계 계층 (Level 1/2/3)
- 비지배지분(NCI) 처리
상세: `.cowork/CW_ANALYSIS_Omar.md` 전체 미커버 항목 집계 섹션 참조
