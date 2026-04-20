# CW_HANDOFF_Omar.md — Omar 작업 인수인계

> 에이전트: Omar-3 (Opus) | 담당: Sync+Auth+인프라+IFRS
> 최종 갱신: 2026-04-20 (v2.0 W11~W14 구현 완료)
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
| IFRS 분석 | NAVER IFRS Package 58시트 전수 분석 + SAP S/4HANA 리서치 |
| 아키텍처 v2.0 | CF/CE/결산훅/스냅샷 섹션 집필 |

---

## 2. 완료 작업

### W7 — OCR 파이프라인 + ClassificationEngine (S07)

| 커밋 | 내용 |
|------|------|
| `763df6c` | OCR 파이프라인 + ClassificationEngine 초기 구현 (5파일 신규) |
| `9a82202` | analyze 오류 수정 (Expression.and, CurrencyCode import) |
| `9053e97` | OcrBloc 대변 JEL 자동생성 + retainedEarningsAccountId 시드 조회 |

**구현 파일**: ClassificationEngine.dart, OcrService.dart, OcrBloc.dart, OcrCapturePage.dart

### W10 — 동기화 + 인증 인프라 (S10+S11)

| 커밋 | 내용 |
|------|------|
| `6bb5796` | 동기화 + 인증 인프라 stub 구현 (5파일 신규) |

**구현 파일**: ConnectivityMonitor.dart, OutboxProcessor.dart, SyncService.dart, TokenStorage.dart, AuthService.dart

### QA Loop

6 iterations, 총 34건 수정, 연속 2회 풀패스 → COMPLETE. 커밋 8건 (`e1a08f8`~`5c3abd4`).

### 엑셀 분석

| 커밋 | 내용 |
|------|------|
| `4dbb704` | 엑셀 3파일 시트별 전수 분석 초판 |
| `19d051c` | NAVER IFRS Package 58시트 전수 재작성 (1327줄) |

### 아키텍처 v2.0 세션 (2026-04-20, 현재 세션)

| 작업 | 산출물 |
|------|--------|
| IFRS 58시트 컬럼 전수 대조 | CW_ANALYSIS_Omar.md 보강 (21컬럼 COA + A/B/C 시트 전수) |
| 아키텍처 v2.0 반영안 | CW_ARCH_PROPOSAL_Omar.md (도메인 모델/스키마/UseCase/우선순위) |
| 교차 리뷰 | Arjun/Grace 분석 문서 읽기 + 반영안에 교차 리뷰 섹션 추가 |
| TF 난상토론 3라운드 | 4개 쟁점 합의 (OCI 5+12, 비율 8+5+16, 세그먼트=Perspective, CF 5분류 113코드) |
| CW_ARCHITECTURE.md v2.0 집필 | §7.2 결산 플러그인 훅, §7.6 CF, §7.7 CE, §4 신규 테이블 3개, §4.2 인덱스 4건, §2.5 Repository 2개, ExchangeRates.purpose AVERAGE/CLOSING |
| §12 SAP 보강 | SAP 기업 전용 스킵 8개 + 설계 인사이트 4가지 |
| SAP S/4HANA 리서치 | CW_RESEARCH_SAP.md (흡수 6개, 스킵 8개, §15 예약 5개) |
| 기존 코드 vs v2.0 GAP | 8항목 전부 미구현 확인 |
| 라운드3 보강 | 재고평가 P3, 계정자동결정 P2, 원가배부 스킵 합의 |

### W12 (구현) — 커밋 `a8baa01`, `1f02869`

| 작업 | 산출물 |
|------|--------|
| RunSettlement 플러그인훅 개편 | SettlementPlugin 인터페이스 + 플러그인 순차실행 + Step5 BS/PL 스냅샷 |
| SettlementSnapshotDao/Repo | Drift DAO + ISettlementSnapshotRepository 구현체 |

### W13 (구현) — 커밋 `618da5e`

| 작업 | 산출물 |
|------|--------|
| GenerateCashFlowStatement | 5분류 간접법 CF (영업/투자/재무/환율/순변동) |
| GenerateEquityChangeStatement | 자본 5구성요소 롤포워드 CE |
| CashFlowCodeDao/Repo | ICashFlowCodeRepository 구현체 |

### W14 (구현) — 커밋 `283626f`

| 작업 | 산출물 |
|------|--------|
| CF 영업세부 확장 | 이자지급/이자수취/배당수취/법인세 4항목 분리 (C140~C170) |
| Account.valuationMethod | InventoryValuationMethod enum + AccountTable 컬럼 |
| DepreciationPlugin | SettlementPlugin 구현체 (order=30, 정액법 월 상각) |

### 에러 수정 — 커밋 `4457c28`

| 내용 |
|------|
| SettlementStep.fxRevaluation→executingPlugins (RunSettlement+SettlementPage) |
| CF/CE snapshotDate required 파라미터 추가 |

---

## 3. 설계 결정 (Why) — HANDOVER_Omar.md 병합

### DI: registerSingleton만 사용
- **이유**: BLoC 앱 생명주기 동안 단일 인스턴스. Stream 구독 공유.
- **위치**: `lib/app/di/Injection.dart`

### BLoC Stream 5경로 연결 순서
- **이유**: 모든 BLoC 등록 완료 후 `_connectBlocStreams()` 한 번에 호출. 순서 보장 필수.
- **위치**: `Injection.dart:_connectBlocStreams()`

### enum 직렬화: camelCase
- **이유**: Dart `.name` = camelCase. UPPERCASE 저장하면 `byName()` 실패.
- **예외**: `OutboxEntry.status`는 PENDING/SYNCED 등 문자열 상수 (enum 아님).

### SettlementPage: context.read → getIt
- **이유**: BlocProvider 트리 밖에서 렌더링 가능. `StateError` 방지.
- **위치**: `SettlementPage.dart:69`

### OutboxProcessor: SENDING 상태 재처리
- **이유**: 앱 강제 종료 시 SENDING 고착. 재시작 시 재처리 필수.

### 결산 프로세스: 코어 5단계 + 플러그인 훅 (v2.0)
- **이유**: 감가상각/OCI/대손충당금 등 확장 항목을 Step2에 플러그인으로 삽입. 코어 구조 변경 없이 기능 추가 가능.
- **위치**: CW_ARCHITECTURE.md §7.2

### ExchangeRates.purpose: AVERAGE/CLOSING
- **이유**: 수익/비용 환산(평균환율)과 B/S 잔액 환산(기말환율) 구분 필수. K-IFRS 요건.
- **위치**: CW_ARCHITECTURE.md §4.1 ExchangeRates

---

## 4. 버그/수정 이력 (HANDOVER 병합)

| # | 버그 | 원인 | 수정 커밋 |
|---|------|------|----------|
| B1 | SettlementPage crash | BlocProvider 미등록 상태에서 context.read | `e1a08f8` |
| B2 | AccountNature SQL 불일치 | UPPERCASE 저장 + byName 대소문자 불일치 | `0713d18` |
| B3 | ILegalParameterRepository 타입 오류 | 반환 타입 dynamic → LegalParameter | `269cb23` |
| B4 | BLoC 경로4 과다 트리거 | posted 전체에 RunAutoClassification | `d3794b9` |
| B5 | PerspectiveBloc 중복 subscription | 재초기화 시 이전 구독 미해제 | `5457d3e` |
| B6 | TransactionSource DB 불일치 | UPPER_SNAKE 저장 + byName 실패 | `b7c0c40` |
| B7 | Deductibility DB 불일치 | BOOK_RESPECTED + camelCase 불일치 | `5c3abd4` |

---

## 5. Gotcha (주의사항)

1. **getIt 등록 순서 중요**: `_connectBlocStreams()`는 반드시 마지막에 호출.
2. **OutboxEntry.status는 UPPERCASE 문자열**: enum 아님. `byName()` 사용 금지.
3. **TransactionStatus는 `.toLowerCase()` 후 byName**: DB에 UPPERCASE 저장됨.
4. **BLoC Stream 구독 1회만**: Hot Restart 시 DI 재초기화 필요.
5. **SettlementPage에서 context.read 금지**: ReportBloc 외 Repository는 getIt 사용.
6. **CW_ARCHITECTURE.md 동시 편집 주의**: 다른 에이전트와 동시 수정 시 "File has been modified" 오류 발생. Read→Edit 재시도 패턴 사용.

---

## 6. 미완료 항목

### S07 OCR 실체화 (패키지 설치 필요)
- `google_mlkit_text_recognition`, `image_picker`
- `MobileOcrService`, `OcrCapturePage` 실제 연동

### S10 동기화 실체화 (서버 API 필요)
- `connectivity_plus`
- `ConnectivityMonitor`, `OutboxProcessor` (IServerApiClient 구현체)

### S11 인증 실체화 (네이티브 설정 필요)
- `google_sign_in`, `sign_in_with_apple`, `local_auth`, `flutter_secure_storage`

### v2.0 신규 구현 (아키텍처 확정, 코드 미구현)
- CF 보고서: GenerateCashFlowStatement UseCase + CashFlowCodes 테이블/시드
- CE 보고서: GenerateEquityChangeStatement UseCase + OciCategory enum
- 결산 플러그인: SettlementPlugin 인터페이스 + FxRevaluation/OCI 플러그인
- SettlementSnapshots 테이블 (6종: BS/PL/CF/CE/TAX/RATIO)
- Account 필드 5개 (validFrom/validTo/cashFlowCategory/isFxRevalTarget/vendorRequirement)
- Transaction 필드 1개 (adjustmentType)

---

## 7. 소스 참조 (핵심 파일)

| 파일 | 역할 |
|------|------|
| `lib/app/di/Injection.dart` | DI 컨테이너 + Stream 연결 |
| `lib/features/sync/data/OutboxProcessor.dart` | Outbox FIFO 처리 |
| `lib/features/sync/data/SyncService.dart` | 동기화 오케스트레이터 |
| `lib/infrastructure/auth/AuthService.dart` | 인증 서비스 stub |
| `lib/infrastructure/auth/TokenStorage.dart` | JWT 토큰 저장 |
| `lib/features/ocr/data/ClassificationEngine.dart` | 거래 자동분류 |
| `lib/features/ocr/presentation/OcrBloc.dart` | OCR 상태머신 |
| `.cowork/CW_ANALYSIS_Omar.md` | NAVER IFRS 58시트 분석 |
| `.cowork/CW_ARCH_PROPOSAL_Omar.md` | 아키텍처 v2.0 반영안 + 교차 리뷰 |
| `.cowork/CW_RESEARCH_SAP.md` | SAP S/4HANA 리서치 |
| `.cowork/CW_ARCHITECTURE.md` | 아키텍처 법전 (v2.0 반영 완료) |

---

*최종 갱신: 2026-04-20 | Omar-3 (Opus)*
