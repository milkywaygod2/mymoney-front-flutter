# CW_SUBJECTS.md — MyMoney 구현 목표 (Master Goals)

> Phase 2B 산출물. CW_ARCHITECTURE.md 기반 점진적 구현 순서.
> 원칙: "코어부터 구현+검증 → 하나 붙이고 검증" (Incremental Implementation)
> 작성: TF tf-mymoney (2026-04-18)

---

## 구현 순서 총괄

```
S01 → S02 → S03a → S03b → S04 → S05 → S06 → S07 → S08a → S09 → S08b → S10 → S11
```

각 Subject는 이전 Subject가 완성+검증된 후 시작. 의존성 방향: 왼→오.

---

## S01. core/ 기반 — 도메인 엔티티 + VO + 인터페��스

**범위**: `core/domain/`, `core/models/`, `core/interfaces/`, `core/constants/`, `core/errors/`

**구현 내용**:
- freezed 불변 엔티티: Transaction, Account, Perspective, Counterparty
- VO: Money(int 최소단위 + CurrencyCode), ExchangeRateValue, Period, OwnerId 등
- 불변조건 로직: INV-T1~T7, INV-A1~A5, INV-P1~P3, INV-C1~C3
- 팩토리 메서드: createDraft, post, void 등
- Repository 인터페이스: ITransactionRepository, IAccountRepository 등
- 열거형: AccountNature, EntryType, TransactionStatus, TransactionSource, Deductibility 등

**의존**: 없음 (최하위 기반)

**DoD**:
- [ ] freezed 코드 생성(build_runner) 성공
- [ ] 불변조건 단위 테스트 ��과 (INV-T1~T7, INV-A1~A5 등)
- [ ] Money VO 연산 테스트 (같은 통화 합산, 다른 통화 합산 거부)
- [ ] Repository 인터페이스 컴파일 확인

---

## S02. Drift 스키마 + DimensionValue 시드 + Account CRUD

**범위**: `infrastructure/database/`, `features/account/`

**구현 내용**:
- Drift AppDatabase 클래스 + 전체 테이블 정의 (CW_ARCHITECTURE.md 섹션 4)
- TypeConverter: Money↔int, CurrencyCode↔String 등
- DimensionValue 시드 데이터: 5대 분류(자산/부채/자본/수익/비용) 기본 트리 + 활동구분/소득유형 기본값
- Account CRUD: AccountDao + AccountRepository 구현
- AccountBloc (기본): LoadAccountTree, CreateAccount, DeactivateAccount
- 테스트용 샘플 Account 몇 개 (보통예금, 식비, 카드미지급금 등)

**의존**: S01 (엔티티, 인터페이스)

**DoD**:
- [ ] Drift DB 초기화 성공 (전 플랫폼)
- [ ] DimensionValue 시드 로딩 확인 (자산>유동>현금성 트리 탐색)
- [ ] Account CRUD 통합 테스트 (생성→조회→수정→비활성화)
- [ ] FK 제약 검증 (존재하지 않는 DimensionValue 참조 시 에러)
- [ ] Materialized Path LIKE 쿼리 동작 확인
- [ ] Money VO ↔ int TypeConverter 왕복 테스트

---

## S03a. Transaction 핵심 — 복식부기 CRUD

**범위**: `features/journal/` (usecase + data + 기본 presentation)

**구현 내용**:
- TransactionDao + TransactionRepository 구현
- JournalBloc (핵심): CreateTransaction, LoadTransactions, ReviewTransaction(Draft→Posted)
- 차대변 균형 검증 (INV-T2, Posted 시 강제)
- 단일 통화(KRW) 거래 생성
- JEL Override 패턴 구현 (COALESCE 로직)
- 기본 거래 리스트 UI (Flow Card 없이 단순 리스트)

**의존**: S02 (DB + Account)

**DoD**:
- [ ] Transaction.createDraft → post 흐름 통합 테스트
- [ ] 차대변 균형 불일치 시 post 거부 테스트
- [ ] COALESCE(JEL override, Account default) 소유자/활동구분 동작 확인
- [ ] deductibility 기본값 "미판정" 확인
- [ ] Drift watchQuery로 거래 목록 실시간 갱신 확인
- [ ] 거래 리스트 UI 렌더링 (단순 리스트)

---

## S03b. Transaction 부가 — 역분개, 태그, 중복 탐지

**범위**: `features/journal/` 확장

**구현 내용**:
- void/역분개: VoidTransaction → 역분개 전표 자동 생성
- 태그 M:N: Tags + TransactionTags 테이블, addTag/removeTag
- 중복 탐지: 점수 기반 (날짜+금액+거래처, 70점/90점 임계치)
- JournalBloc 확장: VoidTransaction, 태그 관리, 중복 경고

**의존**: S03a (Transaction 핵심)

**DoD**:
- [ ] void → 역분개 전표 자동 생성 + 원본 status=Voided + voided_by 설정
- [ ] 태그 M:N CRUD (추가/삭제/조회)
- [ ] 중복 탐지: 동일 날짜+금액 거래 입력 시 경고 (점수 >=70)
- [ ] Draft만 수정/삭제 가능, Posted 거부 확인

---

## S04. 계정과목 표준 트리 확장

**범위**: `features/account/` 확장, DimensionValue ���세 시드

**구현 내용**:
- MVP 전체 계정과목 트리 (CW_ARCHITECTURE.md 섹션 12의 전체 트리)
- 사용자 하위 계정 추가 기능 (leaf 노드 하위만)
- 코드 자동 생성 (Materialized Path 연장)
- nature 자동 상속
- 삭제 제한 (Posted 거래 있으면 비활성화만)
- AccountBloc 확장: ExpandNode, CollapseNode, SearchAccounts

**의존**: S02 (기본 시드), S03a (거래 연동 확인)

**DoD**:
- [ ] 5대 분류 전체 표준 트리 시드 완성 (자산~비용 전 노드)
- [ ] Materialized Path 정합성 (모든 노드 parent 유효)
- [ ] nature 일관성 (자산 하위=Asset, 부채 하위=Liability 등)
- [ ] 사용자 하위 계정 추가 성공 + 중간 노드 추가 거부
- [ ] Posted 거래 있는 계정 삭제 거부, is_active=false만 허용
- [ ] entity_type별 DimensionValue 분리 로드 확인 (가계/기업/정부)
- [ ] 트리 탐색 UI (펼치기/접기/검색)

---

## S05. Balance Flow Card + 거래 입력 UI

**범위**: `core/widgets/`, `features/journal/presentation/` 확장

**구현 내용**:
- Balance Flow Card 위젯 (노드-엣지 시각화, nature 색상, 금액, 균형 체크마크)
- Split View 레이아웃 (상단 카드 + 하단 리스트)
- 거래 입력 폼 (BottomSheet/전체화면)
- Draft→Posted 상태 전환 UI (status 뱃지)
- 다전표 라인(3행+) 레이아웃 (좌우 노드 세로 쌓기)
- 리스트 탭 → 카드 전환, 스와이프 → 다음 거래
- 플랫폼별 적응 (모바일 상하 Split, 데스크톱 좌우 Master-Detail)

**의존**: S03a (Transaction CRUD), S04 (계정과목 트리)

**DoD**:
- [ ] Flow Card 렌더링: 차변/대변 노드, nature 색상, 금액, 균형 ✓
- [ ] 다전표 라인 (3행+) 정상 표시
- [ ] 리스트 탭 → 카드 전환 동작
- [ ] 거래 입력 → Draft 생성 → Posted 전환 플로우
- [ ] source/confidence 아이콘/뱃지 표시
- [ ] 플랫폼별 레이아웃 확인 (최소 2개 플랫폼)

---

## S06. Perspective + Lens Switcher

**범위**: `features/perspective/`, `core/widgets/lens/`

**구현 내용**:
- Perspective CRUD (PerspectiveDao, PerspectiveRepository)
- PerspectiveBloc: SelectPreset, OpenCustomFilter, ApplyCustomFilter, SaveAsPreset
- 1층 칩 바 (프리셋 탭 전환)
- 2층 커스텀 필터 패널 (3탭: 계정속성/거래속성/분석)
- 트리 드릴다운 + 태그 멀티셀렉트
- 통합 검색 바
- BLoC Stream 전파: Perspective → JournalBloc/ReportBloc 리필터링
- 시스템 프리셋: "전체", "세무 미판정 거래"

**의존**: S05 (Flow Card — 필터 결과 시각화), S03b (태그)

**DoD**:
- [ ] 프리셋 칩 탭 → 거래 리스트 리필터링 동작
- [ ] 2층 필터: 트리 드릴다운 동작 (자산>유동>현금성)
- [ ] 2층 필터: 태그 멀티셀렉트 (AND/OR)
- [ ] 프리�� CRUD (생성/편집/삭제, 시스템 프리셋 보호)
- [ ] BLoC Stream 전파 검증 (Perspective 변경 → 리스트 갱신)
- [ ] account_attribute_filters 동작 (상품구분/금융사 필터)

---

## S07. Counterparty + OCR 파이프라인

**범위**: `features/counterparty/`, `features/ocr/`, `infrastructure/ocr_engine/`

**구현 내용**:
- Counterparty CRUD (CounterpartyDao, aliases 관리)
- ICounterpartyMatcher 구현 (alias 기반 매칭)
- IOcrService 구현: 모바일=ML Kit, Web/Desktop=서버 위임 (또는 stub)
- OCR 파이프라인: 캡처→파싱→분류(로직트리)→Draft 생성
- ClassificationRules 테이블 + 시스템/사용자 규칙
- CSV/Excel 임포트 (파이프라인 [파싱] 합류)
- OcrBloc: 전체 플로우
- "이 패턴 기억하기" → 사용자 규칙 저장
- 오프라인 OCR (모바일 온디바이스)

**의존**: S06 (Perspective — OCR 결과 필터링), S03a (Transaction Draft 생성)

**DoD**:
- [ ] Counterparty CRUD + alias 추가/검색
- [ ] OCR 캡처 → 파싱 프리뷰 → Draft 저장 전체 플로우 (모바일)
- [ ] 로직트리 분류: "스타벅스" → 식비 자동 매핑
- [ ] CSV 임포트 → 파싱 → Draft 일괄 생성
- [ ] "이 패턴 기억하기" → ClassificationRules에 저장 → 다음 OCR 시 적용
- [ ] 오프라인 모바일 OCR 동작 확인

---

## S08a. 세무조정 규칙 엔진

**범위**: `features/tax/`

**구현 내용**:
- 자동 deductibility 판정 (계정과목 기반 11개 규칙)
- 소득 8종 자동 분류
- LegalParameter VALUE/TABLE/FORMULA 처리
- TaxBloc: RunAutoClassification, ReviewPending, OverrideDeductibility, ConfirmSettlement
- 세무조정 화면: 미판정 목록 → 수동 수정 → 확정
- BLoC 통신: JournalBloc.TransactionPosted → TaxBloc 자동 판정

**의존**: S07 (Counterparty — 접대비 거래처, 특수관계자), S03a (Posted 거래)

**DoD**:
- [ ] Posted 거래에 자동 판정 실행 (접대비→손금산입(한도), 벌과금→손금불산입)
- [ ] 소득 8종 자동 분류 (이자/배당/사업/근로/연금/기타/퇴직/양도)
- [ ] LegalParameter VALUE 조회 + TABLE 구간 매칭 + FORMULA 수식 평가
- [ ] 미판정 목록 표시 → 수동 수정 → 전체 확정
- [ ] TaxBloc → ReportBloc Stream 전파

---

## S09. 외환차손익 (다통화)

**범위**: `features/exchange/`

**구현 내용**:
- ExchangeRate CRUD (환율 테이블)
- 다통화 거래 생성 (original_currency ≠ base_currency)
- base_amount 파생값 계산 (거래 시점 환율)
- 일상 조회: 온디맨드 미실현 손익 계산 (저장 안 함)
- 환율 캐시: 최근 30일, 1일 1회 갱신
- Flow Card 다통화 표시 (원본 금액 primary + 환산 secondary)

**의존**: S03a (Transaction — 다통화 JEL 필드), S05 (Flow Card 다통화 UI)

**DoD**:
- [ ] USD→KRW ���래 생성: original_amount=4567(cent), exchange_rate, base_amount 파생
- [ ] 온디맨드 미실현 손익: 현재 환율 vs 거래 시점 환율 차이 표시
- [ ] Flow Card 다통화 노드: ¥1,000 / ≈₩9,000 / @9.0 표시
- [ ] 환율 캐시 동작 확인

---

## S08b. 결산 프로세스

**범위**: `features/report/` 확장, 결산 UseCase

**구현 내용**:
- 실시간 집계 쿼리 (Perspective 기반 B/S, P/L, CF)
- 결산 5단계: 마감준비 → 외환평가 자동전표 → 세무조정 → 손익마감 → 스냅샷
- 외환차손익 자동 전표 (Account.nature 기반 차변/대변 방향)
- 손익 마감 (수익/비용 → 손익요약 → 이익잉여금)
- 결산 스냅샷 저장
- ReportBloc: LoadReport, 대시보드 집계
- 결산 화면 진입점 ("더보기 > 결산")

**의존**: S08a (세무조정 확정), S09 (외환 평가 전표)

**DoD**:
- [ ] B/S 실시간 집계: Perspective 필터 적용 → 계정별 잔액 정확
- [ ] P/L 기간별 집계: 수익-비용 = 당기순이익
- [ ] 외환 평가 자동 전표: Asset 환율 상승 → 차변 자산 / ��변 외환차익
- [ ] 손익 마감: 수익/비용 계정 잔액 0 확인 + 이익잉여금 대체
- [ ] 결산 스냅샷 저장 + 기초 잔액 이월

---

## S10. 동기화 (Outbox + Delta Sync)

**범위**: `features/sync/`, `infrastructure/network/`

**구현 내용**:
- SyncService (ISyncService 구현)
- Outbox 처리: PENDING → SENDING → SYNCED/CONFLICT/FAILED
- Delta Sync: last_synced_at 기반 서버→클라이언트 pull
- 충돌 해소 UI (CONFLICT 상태 거래 비교/선택)
- ConnectivityMonitor (connectivity_plus)
- 지수 백오프 재시도 (최대 5회)
- 로컬 캐시 갱신 정책 적용

**의존**: S07 (OCR — 오프라인 Draft 생성이 동기화 주 대상), 서버 API (C#/ASP.NET Core)

**DoD**:
- [ ] 오프라인 Draft 생성 → 온라인 복귀 → 서버 전송 → SYNCED
- [ ] 중복 UUID 거부 (409) → 자동 처리
- [ ] CONFLICT 상태 → 사용자 해소 UI
- [ ] Delta Sync: 서버 변경분 pull → 로컬 갱신
- [ ] 지수 백오프: 네트워크 오류 시 1s→2s→4s→8s 재시도

---

## S11. 인증/권한

**범위**: `infrastructure/auth/`, `features/auth/`

**구현 내용**:
- firebase_auth (Google/Apple 소셜 로그인)
- local_auth (생체인증/PIN)
- Perspective 기반 권한 모드 (permission_level: Full/ReadOnly/Restricted)
- 소유자별 접근 제어 (Lens 전환 시 권한 체크)
- 회원가입 → 소유자(Owner) 자동 생성

**의존**: S06 (Perspective — 권한 모드), 서버 인증 API

**DoD**:
- [ ] Google/Apple 소셜 로그인 성공
- [ ] 생체인증/PIN 앱 잠금 동작
- [ ] ReadOnly Perspective: 거래 수정 불가 UI
- [ ] Restricted Perspective: 특정 계정만 조회 가능

---

## 의존성 그래프 요약

```
S01 ──→ S02 ──→ S03a ──→ S03b
                  │              ↘
                  │         S04 ──→ S05 ──→ S06 ──→ S07 ──→ S08a ──→ S09 ──→ S08b
                  │                                                              │
                  │                                                         S10 ←┘
                  │                                                          │
                  └──────────────────────────────────────────────────── S11 ←┘
```

핵심 경로: S01 → S02 → S03a → S05 → S06 → S07 → S08a → S09 → S08b
