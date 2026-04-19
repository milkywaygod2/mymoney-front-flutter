# CW_HANDOFF_Omar.md — Omar 작업 인수인계

> 에이전트: Omar | 담당: Sync(S10) + Auth(S11) + W7 OCR 파이프라인
> 최종 갱신: 2026-04-19 (W10 S10+S11 stub 완료)

---

## 완료 작업

### W7 — OCR 파이프라인 + ClassificationEngine (S07 일부)

| 커밋 | 내용 | 파일 |
|------|------|------|
| `763df6c` | OCR 파이프라인 + ClassificationEngine 초기 구현 | 5파일 신규 |
| `9a82202` | analyze 오류 수정 (Expression.and, CurrencyCode import) | 3파일 수정 |

#### 구현 파일
- `lib/features/ocr/data/ClassificationEngine.dart` — 로직트리 분류 엔진
  - ClassificationRules 테이블 기반 패턴 매칭 (EXACT/CONTAINS/REGEX)
  - 우선순위 기반 정렬 (priority DESC, Expression.and 조건)
  - "이 패턴 기억하기": 사용자 규칙 저장 (priority=100)
- `lib/features/ocr/data/OcrService.dart` — OCR 서비스 인터페이스
  - `IOcrService` abstract interface
  - `MobileOcrService` stub (ML Kit TODO)
  - `ServerOcrService` stub (서버 위임 TODO, Phase 2)
- `lib/features/ocr/presentation/OcrBloc.dart` — OCR BLoC
  - `OcrPhase` enum (idle/capturing/recognizing/parsing/classifying/reviewing/saving/done/error)
  - 이벤트: CaptureImage, ProcessOcr, ClassifyTransaction, UpdateOcrField, ToggleRememberPattern, SaveAsDraft, RetryCapture
  - `ParsedOcrData` VO (rawText, date, amount, merchantName, description)
- `lib/features/ocr/presentation/OcrCapturePage.dart` — OCR UI
  - 이미지 소스 선택 (카메라/갤러리 stub)
  - 파싱 결과 프리뷰 + 수정 가능 필드
  - 신뢰도 배지, "이 패턴 기억하기" 체크박스, Draft 저장 버튼

#### TODO (미완료 항목)
- `MobileOcrService`: `google_mlkit_text_recognition` 패키지 설치 후 실제 ML Kit 연동
- `OcrCapturePage`: `image_picker` 패키지 설치 후 실제 캡처 연동
- `OcrBloc._onClassify`: 거래처 매칭 결과를 classified.counterpartyId에 반영하는 로직
- 대변 JEL 자동 생성 (카드미지급금 계정과목 자동 조회)

---

### W10 — 동기화 + 인증 인프라 (S10+S11 stub)

| 커밋 | 내용 | 파일 |
|------|------|------|
| `6bb5796` | 동기화 + 인증 인프라 stub 구현 | 5파일 신규 |

#### 구현 파일
- `lib/features/sync/data/ConnectivityMonitor.dart` — 네트워크 상태 감지
  - `IConnectivityMonitor` abstract interface
  - `ConnectivityMonitor` stub (connectivity_plus TODO)
  - `Stream<bool> streamOnline`, `setOnlineForTest()` 테스트 지원
- `lib/features/sync/data/OutboxProcessor.dart` — Outbox FIFO 처리
  - `IServerApiClient` 인터페이스 (서버 HTTP 호출 주입용)
  - `ConflictException` (409 충돌)
  - `processNext()`: PENDING→SYNCED/CONFLICT/FAILED 상태 전이
  - `fetchConflicts()` / `resolveConflict()`: 충돌 해소 UI 지원
- `lib/features/sync/data/SyncService.dart` — 동기화 오케스트레이터
  - `ISyncService` abstract interface
  - `triggerSync()`: Outbox 처리 + Delta Sync + 지수 백오프 (1→2→4→8→16s)
  - `ConnectivityMonitor` 온라인 전환 감지 → 자동 triggerSync()
  - `SyncResult` VO, `SyncStatus` enum
- `lib/infrastructure/auth/TokenStorage.dart` — JWT 토큰 저장소
  - `ITokenStorage` abstract interface
  - `DevTokenStorage` (인메모리, SharedPreferences TODO)
  - `SecureTokenStorage` (flutter_secure_storage TODO)
  - `TokenPair` VO (accessToken, refreshToken, expiresAt, isExpired)
- `lib/infrastructure/auth/AuthService.dart` — 인증 서비스
  - `IAuthService` abstract interface
  - Google/Apple OAuth2 stub (패키지 TODO)
  - 생체인증/PIN stub (local_auth TODO)
  - JWT 갱신 흐름 설계 완료 (C# 백엔드 연동 TODO)

#### TODO (패키지 미설치 → stub)
- `connectivity_plus`: ConnectivityMonitor 실체화
- `shared_preferences` / `flutter_secure_storage`: TokenStorage 실체화
- `google_sign_in` + `sign_in_with_apple`: AuthService 소셜 로그인 실체화
- `local_auth`: 생체인증/PIN 실체화
- `http`: _exchangeIdToken, refreshToken, signOut 서버 연동

---

## 완료 태스크

| Subject | 내용 | Wave | 상태 |
|---------|------|------|------|
| S07 | OCR 파이프라인 + ClassificationEngine | W7 | stub 완료 |
| S10 | 동기화 Outbox + Delta Sync | W10 | stub 완료 |
| S11 | 인증 OAuth2 + 생체인증 | W10 | stub 완료 |

워크트리: `E:/_Develop/dart/mymoney-wk-omar` (브랜치: `wk-w7-omar`)
