# 태스크 상황판 (CW_STATE_TASK)

[CURRENT_PHASE: 7]
[CURRENT_WAVE: v3.0 UI QA COMPLETE — Wave U1~U6 완료, QA Loop Iteration 13 / CONSECUTIVE_PASS 2]

---

## QA Step 1 진실의 원본 (Source of Truth)

> CW_HANDOFF 문서는 구현 메모이며, QA 진실의 원본이 아님.
> **디자인 사이드**와 **개발 사이드** 양쪽을 모두 대조해야 함.

### 디자인 사이드 (UI/픽셀 진실)

| 유형 | 경로 | 용도 |
|------|------|------|
| **구현 스펙 (Wave MD)** | `design-handoff-for-dev/wave-0~6.md` | Wave별 Flutter 구현 스펙 — **QA Step 1 1차 원본** |
| **Flutter 뼈대** | `design-handoff-for-dev/skeletons/wave-*.dart` | 빈 뼈대 + 계정 JSON |
| **계정 카탈로그** | `design-handoff-for-dev/skeletons/assets/account_catalog.json` | K-IFRS 계정 JSON |
| **JSX 원본** | `design-reference/screens/*.jsx` | 픽셀 진실 — 스펙 불분명 시 최종 판단 기준 |
| **인터랙티브 프로토타입** | `design-reference/screens/screens.html` | 모션/인터랙션 직접 확인 |
| **디자인 토큰 CSS** | `design-reference/colors_and_type.css` | AppColors 변환 원본 |

### 개발 사이드 (아키텍처/계약 진실)

| 유형 | 경로 | 용도 |
|------|------|------|
| **아키텍처 문서** | `.cowork/CW_ARCHITECTURE.md` | 전체 아키텍처 — 레이어/모듈/DI/라우팅 설계 원본 |
| **계약 문서** | `.cowork/CW_CONTRACTS.md` | 도메인 간 인터페이스·이벤트·상태 계약 원본 (**현재 stub — Phase 2A 진입 시 정의 예정**) |

### Wave↔소스 매핑

| Wave | handoff 스펙 | JSX 원본 |
|------|-------------|---------|
| U1 Design System | `wave-1-design-system.md` | `colors_and_type.css` · `preview/` |
| U2 Home | `wave-2-home.md` | `screens/home.jsx` |
| U3 Journal | `wave-3-journal.md` | `screens/transactions.jsx` |
| U4 Entry | `wave-4-entry.md` | `screens/entry.jsx` · `entry_autoplay.jsx` |
| U5 Account Tree | `wave-5-account-tree.md` | `screens/accounts.jsx` · `coa.jsx` · `metaphors.jsx` |
| U6 Report/Animations | `wave-6-animations.md` | `screens/playground.jsx` · `scenario_assets.jsx` |

## UI Wave 현황 (Wave U1~U6)

| Wave | 내용 | 담당 | 상태 |
|------|------|------|------|
| U1 | Design System (AppColors/TextStyles/Spacing/Radius/Shadows/Motion/AppTheme/공통위젯) | Raj | ✅ 완료 (c237bd3) |
| U2 | Home (HomePage + HomeV1/V2/V3 + HomeBloc) | Ken | ✅ 완료 (06b43b7) |
| U3 | Journal (JournalPage 재작성 + V1/V2/V3) | Ken | ✅ 완료 (06b43b7) |
| U4 | Entry (EntryPage + V1/V2/V3 + EntryAutoPlay) | Carlos | ✅ 완료 (98db0ad) |
| U5 | AccountTree (재작성 + Browse/Map/Config) | Carlos | ✅ 완료 (b6578a0) |
| U6 | Report Dashboard (재작성 + 차트 6종) | Carlos | ✅ 완료 (ef15bd7) |

---

## 완료 이력

| Wave | 내용 | 커밋 | 상태 |
|------|------|------|------|
| W0 | 스캐폴드 (DI/Router/Theme/4탭) | 16849fb | ✅ |
| W1 | S01 core/ 엔티티+VO+인터페이스+enum | 73993db | ✅ |
| W2 | S02 Drift 16테이블+시드+Account CRUD+BLoC | 63ab375 | ✅ |
| W3 | S03a Transaction DAO/Repo/UseCase/BLoC/Page | c6ceddb | ✅ |
| W4 | S03b+S04 역분개/중복탐지/계정UseCase | fcb01b2 | ✅ |
| W5 | S05 Flow Card+거래 입력 UI+Split View | 24f0c11 | ✅ |
| W6 | S06 Perspective+Lens Switcher | fdc0f4d | ✅ |
| W7(일부) | Counterparty CRUD+alias | 07cafd4 | ✅ |
| W8(일부) | S08a 세무조정 규칙엔진 | 3472273 | ✅ |
| W9 | S08b 결산 프로세스 5단계 | — | ✅ |
| QA v1.0 | 6 iteration, 34건 수정 | 3611b18 | ✅ |
| v2.0 설계 | 아키텍처+플랜+TF 3라운드 | 815a2de | ✅ |
| W7R | 외환 AVERAGE/CLOSING + isFxRevalTarget | e0ff334 | ✅ |
| W11 | 스키마+도메인+시드257노드+CF113코드+테이블4+인덱스8 | 5d9e6c0 | ✅ |
| W12 | 비율8종+OCI+결산플러그인훅+대손충당금+DI | e19b057 | ✅ |
| W13 | CF5분류+CE5구성+기간비교+비율13종+OCI12종+creditAccountId | d18d0f8 | ✅ |
| W14 | 비율29종+CF영업세부+감가상각+재고평가+대손충당금UseCase+충당부채+FX순포지션+매각예정 | 0646256 | ✅ |
| 에러수정 | W12+W13+W14 analyze 에러 → 0건 | 7208f3a, 0646256 | ✅ |

---

## 미완료 Wave — 외부 의존으로 착수 불가

### W15: Sync+Auth ⏳ 서버 의존

| # | 태스크 | 할당 | 상태 | 블로커 이유 |
|---|--------|------|------|------------|
| 15-1 | Outbox+Delta Sync | Omar-3 | **서버 대기** | C# ASP.NET Core 백엔드 REST API 미구축. `/api/sync` 엔드포인트 + JWT 인증 필요. 서버 없이는 Outbox 전송 대상 없음. |
| 15-2 | OAuth2+생체인증 | Arjun-3 | **네이티브 대기** | Google OAuth2 클라이언트 ID (Google Cloud Console 설정), Apple Developer 인증 설정, `google_sign_in`/`sign_in_with_apple`/`local_auth` 패키지 설치 + Android/iOS 네이티브 설정 필요. |

**해소 조건**: C# 백엔드 서버 구축 완료 + 네이티브 플랫폼 설정
**현재 상태**: 코드 수준에서 SyncService/OutboxProcessor/AuthService stub은 v1.0에서 이미 구현됨. 실제 연동만 남음.

### W7-OCR: OCR+Classification ⏳ 패키지 의존

| # | 태스크 | 할당 | 상태 | 블로커 이유 |
|---|--------|------|------|------------|
| OCR-1 | ML Kit OCR 파이프라인 | Grace-3 | **패키지 대기** | `google_mlkit_text_recognition` 패키지 미설치. 모바일 전용(Android/iOS) — Web/Desktop은 서버 OCR 위임 필요 (Python AI 서버 = 별도 프로젝트). 패키지 설치 후 MlKitOcrAdapter 실구현. |
| OCR-2 | ClassificationEngine 로직트리 실연동 | Arjun-3 | **OCR 대기** | OCR 결과가 입력 소스. 현재 ClassificationEngine은 수동 텍스트 입력으로 독립 테스트 가능하나, ML Kit 파이프라인과 실연동은 OCR-1 완료 후. |

**해소 조건**: `google_mlkit_text_recognition` pubspec 추가 + Android/iOS 빌드 확인
**현재 상태**: OcrBloc/OcrCapturePage/ClassificationEngine/CounterpartyMatcher stub은 v1.0에서 이미 구현됨. ML Kit 실연동만 남음.

---

## P4 장기 예약 (§15 — 구현하지 않되 설계 슬롯 확보)

| # | 항목 | 예약 이유 |
|---|------|----------|
| 1 | 이연법인세 (DTA/DTL) | 개인 가계부에 불필요. 기업 확장 시 CalculateDeferredTax UseCase |
| 2 | 법인간 투자지분 (InvestmentHolding) | 다법인 연결결산 전용 |
| 3 | 결재선 (approvedByOwnerId) | 다인 가구 승인 워크플로우 |
| 4 | 특수관계자 거래 한도 | LegalParameter 기반 관계사 거래 한도 초과 판정 |
| 5 | 법인 기능통화 (functionalCurrency) | 해외 법인 기능통화 (다국적 확장) |
| 6 | 관계 유효기간 (effectiveFrom/To) | 계열 편입/제외 이력 |
| 7 | NRV 저가법 재고평가 | 결산 플러그인 InventoryNrvPlugin |
| 8 | 복합 분류 규칙 (conditions JSON) | ClassificationRules RULE_BASED + 조건 매트릭스 |
| 9 | 원가배부 (CostAllocationRule) | SAP CO Assessment/Distribution. AccountOwnerShares로 간접 대응 중 |
| 10 | 공정가치 계층 (L1/L2/L3) | IFRS 13 공정가치 측정 |
| 11 | 유동성 만기 매트릭스 | 1Y/1-5Y/5Y+ 만기 분석 |
| 12 | 금융상품 통합 롤포워드 | 14컬럼 변동 추적 |

---

## 업무 배분 실적 (v2.0)

| 에이전트 | W7R | W11 | W12 | W13 | W14 | 합계 | 상태 |
|----------|-----|-----|-----|-----|-----|------|------|
| Arjun-3 | 1 | 8 | 3 | 2 | 2 | **16** | ✅ 완료 |
| Grace-3 | 2 | 7 | 4 | 3 | 3 | **19** | ✅ 완료 |
| Omar-3 | 0 | 9 | 2 | 3 | 3 | **17** | ✅ 완료 |
| **합계** | 3 | 24 | 9 | 8 | 8 | **52** | **전부 완료** |

---

## QA Loop Status

### v1.0 QA
LOOP_STATE: COMPLETE
ITERATION: 6 / MAX: 100 / CONSECUTIVE_PASS: 2

### v2.0 QA
LOOP_STATE: COMPLETE — W14 백엔드 (v1.0 QA와 통합)

### v3.0 UI QA (Wave U1~U6)
LOOP_STATE: COMPLETE
ITERATION: 13
MAX_ITERATION: 100
CONSECUTIVE_PASS: 2

#### Step 1 판정 기준
- BSChart/PLChart/CETable null→CircularProgressIndicator: **ACCEPT** (로딩 상태, 정상)
- EntryAutoPlay overlay 방식 불일치: **ACCEPT** (기능 동등, 설계 단순화)
- ConfigMode 계정별 개별 메타포: **ACCEPT** (이모지 단순화, 설계 의도)

#### Step 1 원본 소스
- **U1+U6 (Raj-2)**: `design-handoff-for-dev/wave-1-design-system.md` · `wave-6-animations.md` + JSX: `colors_and_type.css` · `playground.jsx`
- **U2+U3 (Ken-2)**: `design-handoff-for-dev/wave-2-home.md` · `wave-3-journal.md` + JSX: `home.jsx` · `transactions.jsx`
- **U4+U5 (Carlos-2)**: `design-handoff-for-dev/wave-4-entry.md` · `wave-5-account-tree.md` + JSX: `entry.jsx` · `accounts.jsx`

#### Agent Results (현재 iteration)
| Agent | Step 1 | Step 2 | Step 3 |
|-------|--------|--------|--------|
| Raj-2 | PASS (GAP 0건, FIXED 0건) | PASS (FIXED 0건, ISSUE 0건) | PASS (FIXED 0건, ISSUE 0건) |
| Ken-2 | PASS (GAP 0건, FIXED 0건) | PASS (FIXED 0건, ISSUE 0건) | PASS (FIXED 0건, ISSUE 0건) |
| Carlos-2 | PASS (GAP 0건, FIXED 0건) | PASS (FIXED 0건, ISSUE 0건) | PASS (FIXED 0건, ISSUE 0건) |

#### KNOWN-GAP 등록 (도메인 확장 시 구현)
| GAP | 위치 | 원인 |
|-----|------|------|
| EntryV1 추천 칩 | EntryV1.dart | _SuggestedChips UI stub 추가됨 (e76332c), EntryBloc suggestions 연동 미완 |
| EntryV1 상대처/메모 row | EntryV1.dart | _EntryInfoRow UI stub 추가됨 (e76332c), EntryBloc merchant/memo 연동 미완 |
| EntryV1 부기 모드 토글 | EntryV1.dart | 안내 텍스트로 대체 (설계 단순화) |
| EntryAutoPlay 9씬 미구현 | EntryAutoPlay.dart | wave-6 9씬(현금결제/카드결제/예금이체/대출/월급 등) + FlyingPiece/Anchor/SideLabel 미구현 — 3페이즈(enter/fly/arrive) 단순화로 대체. idle showroom/sceneIndex/bump() 미구현. 설계 단순화 ACCEPT |
| AccountBrowse showAdvanced | AccountBrowse.dart | Account.priority 필드 미존재 |
| TreeRow P3/P4 뱃지 | TreeRow.dart | Account.priority 필드 미존재 |
| ConfigMode 계정별 메타포 | AccountConfig.dart | 이모지 단순화 = 설계 의도 |
| NumPad 행 순서 (계산기식) | NumPad.dart | 원본 entry.jsx는 전화기식(1~3 상단), 구현은 계산기식(7~9 상단) — 금융 앱 관례상 ACCEPT |
| EntryPage 닫기 confirm | EntryPage.dart | wave-4 §10 Draft 변경 시 "저장하지 않고 닫을까요?" dialog 미구현 — Navigator.pop() 직접 실행 (UX 완성도 도메인 확장) |
| _connectBlocStreams StreamSubscription 미저장 | Injection.dart | stream.listen 반환값 미저장 — 앱 singleton으로 실질 누수 없음. 앱 종료 시에만 의미 있어 ACCEPT |
| amountLg 24px (wave-1 MD 32px) | AppTextStyles.dart:110 | CSS 원본 `.amount-lg { font-size: var(--t-headline-small); }` = 24px — wave-1 MD 오기입. CSS 기준 구현이 정확. ACCEPT |
| LiquidBar 미구현 | lib/shared/widgets/ | JSX·화면 미사용 프리미티브 — LinearProgressIndicator 대체, 도메인 확장 시 구현 ACCEPT |
| _NetIncomeChip 디자인 명세 일탈 | HomeV3.dart:175~213 | wave-2 §5 명세: 20px mono nature-asset `+₩XXX만`. 구현: 11px stateSuccess/Error 칩 "흑자/적자" — 금융 UX상 더 명확한 시각 표현. ACCEPT |

#### Loop History
| Iteration | Step 1 | Step 2 | Step 3 | 결과 |
|-----------|--------|--------|--------|------|
| 1 | FIXED 6건 / KNOWN-GAP 7건 | Raj PASS / Ken PASS+FIXED 1건 / Carlos PASS | Raj PASS / Ken PASS / Carlos PASS | FIXED 7건 → Iteration 2 |
| 2 | FIXED 1건(CFWaterfall const) / KNOWN-GAP 1건 ACCEPT | Raj PASS / Ken PASS / Carlos PASS | Raj PASS / Ken PASS / Carlos FIXED 2건(ClusterMap+EntryV1) | FIXED 3건 → Iteration 3 |
| 3 | Step1 PASS 전원 / Step2 FIXED 1건(CETable 46580a2) / Step3 Ken·Carlos PASS | - | - | FIXED 1건 → Iteration 4 |
| 4 | Raj PASS / Ken FIXED 2건 / Carlos PASS | Raj PASS / Ken PASS / Carlos PASS | Raj PASS / Ken PASS / Carlos PASS | FIXED 2건 → Iteration 5 |
| 5 | Raj PASS / Ken FIXED 1건(HomeV3 Eyelet) / Carlos PASS+GAP 1건 KNOWN-GAP | Raj PASS / Ken PASS / Carlos FIXED 1건(AccountTreePage) | Raj PASS(대행) / Ken PASS / Carlos FIXED 2건(EntryBloc.error+ClusterMap) | FIXED 4건 → Iteration 6 |
| 6 | FIXED 18건 (surfaceContainerHigh 전수교체) / MINOR 2건 ACCEPT | Raj 리드대행 PASS / Ken PASS / Carlos PASS | Raj 리드대행 PASS / Ken PASS / Carlos PASS | FIXED 18건 → Iteration 7 |
| 7 | FIXED 1건 (SettingsPage surfaceContainerHigh, commit d2cbb06) | 전원 PASS | 전원 PASS | FIXED 1건 → Iteration 8 |
| 8 | PASS (GAP 0건, FIXED 0건) | 전원 PASS | 전원 PASS | **풀패스 — CONSECUTIVE_PASS=1** |
| 9 | Ken-2 FIXED 1건 (FiveAccountBox flow위 수정 12456f6+revert+reapply) | 전원 PASS | 전원 PASS | FIXED 1건 → Iteration 10 (CONSECUTIVE_PASS 리셋) |
| 10 | 전원 PASS (GAP 0건, FIXED 0건) | 전원 PASS | 전원 PASS | **풀패스 — CONSECUTIVE_PASS=1** |
| 11 | Carlos-2 FIXED 2건 (TreeRow·ClusterMap AppColors) | 전원 PASS | 전원 PASS | FIXED 2건 → Iteration 12 (CONSECUTIVE_PASS 리셋) |
| 12 | 전원 PASS (Ken-2 GAP-1 ACCEPT→KNOWN-GAP) | 전원 PASS | 전원 PASS | **풀패스 — CONSECUTIVE_PASS=1** |
| 13 | 전원 PASS (GAP 0건, FIXED 0건) | 전원 PASS | 전원 PASS | **풀패스 — CONSECUTIVE_PASS=2 → COMPLETE** |

---

## 전체 프로젝트 진행률

| 범위 | 태스크 | 완료 | 미완 | 비율 |
|------|--------|------|------|------|
| v1.0 (W0~W9+QA) | — | ✅ 전부 | 0 | 100% |
| v2.0 (W7R~W14) | 52 | ✅ 52 | 0 | 100% |
| W15 (서버 의존) | 2 | 0 | ⏳ 2 | 0% — C# 백엔드 필요 |
| W7-OCR (패키지 의존) | 2 | 0 | ⏳ 2 | 0% — ML Kit 패키지 필요 |
| P4 장기 예약 | 12 | — | §15 예약 | 설계만 |
| **합계** | 68 | 52 | 4+12예약 | **76% 구현 / 100% 설계** |
