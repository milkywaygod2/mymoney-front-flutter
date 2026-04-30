# 태스크 상황판 (CW_STATE_TASK)

[CURRENT_PHASE: 7]
[CURRENT_WAVE: U1 진행 중 — Design System (Foundation)]

## UI Wave 현황 (Wave U1~U6)

| Wave | 내용 | 담당 | 상태 |
|------|------|------|------|
| U1 | Design System (AppColors/TextStyles/Spacing/Radius/Shadows/Motion/AppTheme/공통위젯) | Raj | ✅ 완료 (c237bd3) |
| U2 | Home (HomePage + HomeV1/V2/V3 + HomeBloc) | Ken | ⏳ U1 대기 |
| U3 | Journal (JournalPage 재작성 + V1/V2/V3) | Ken | ⏳ U1 대기 |
| U4 | Entry (EntryPage + V1/V2/V3 + EntryAutoPlay) | Carlos | ⏳ U1 대기 |
| U5 | AccountTree (재작성 + Browse/Map/Config) | Carlos | ⏳ U1 대기 |
| U6 | Report Dashboard (재작성 + 차트 6종) | Carlos | ⏳ U1 대기 |

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
LOOP_STATE: **미실행** — W14 완료 후 QA Loop 실행 권장

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
