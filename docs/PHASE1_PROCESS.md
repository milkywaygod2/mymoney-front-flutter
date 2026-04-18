# Phase 1 토론 과정 기록 (R1~R5)

> TF-001 난상토론 전 과정 — 쟁점, 수렴, 합의 도출 경위

## 참여자

| 역할 | 이름 | 전문 분야 |
|------|------|-----------|
| TF 의장 (Chairman) | James | 퍼실리테이션, 취합, 초안 제시 |
| TF 위원 (Member) | Priya | 회계(Accounting)/세무(Tax) 도메인 |
| TF 위원 (Member) | Wei | UX/프론트엔드(Frontend) |
| TF 위원 (Member) | Sofia | OOP/DDD/클린아키텍처(Clean Architecture) |
| TF 위원 (Member) | Ryan | Dart/Flutter/기술 구현 |

---

## 라운드 1: 분류축(Dimension) 체계 + 트리/태그 분리 원칙

### 논의 주제

- **1-A**: 세부유동성(Sub-Liquidity)을 독립 축(Dimension)으로 만들 것인가, 유동성(Liquidity) 트리의 하위 레벨로 넣을 것인가
- **1-B**: Priya의 "트리(Tree)는 회계 정합성, 태그(Tag)는 분석 자유도" 원칙에 대한 비판적 검토 (사용자 지시: "받아들이되 비판적·생산적 검토 입장")
- **1-C**: Phase 0에서 제안된 12축 목록의 과부족/위치 검토

### 만장일치 합의 (1건)

**세부유동성 → 유동성 트리 하위 레벨로 편입** (독립 축 반대, 4명 전원)

| 위원 | 근거 |
|------|------|
| Priya | 독립 축이면 "유동성=유동인데 세부유동성=비유동" 같은 논리 모순 가능 (직교성 위반) |
| Sofia | Materialized Path(`CURRENT.CASH`)로 트리 하위 표현이 자연스러움 |
| Wei | 축 13개는 사용자 인지 과부하 (Cognitive Overload) |
| Ryan | parent_id 자기참조 하나로 표현 가능, 별도 축은 정합성 관리 복잡도만 증가 |

### 미합의 쟁점 → R2로 이월

**쟁점 1: 트리/태그 이분법의 한계 — 4명 모두 불충분하다고 지적, 확장 방향이 각각 다름**

| 위원 | 제안 | 핵심 근거 |
|------|------|-----------|
| Priya | **축 속성 모델** — 각 축에 `{exclusivity(배타성), hierarchical(계층), aggregatable(집계가능), override_level(재정의 수준)}` 속성 부여 | 소유자(지분율 배분), 예산과목(맥락에 따라 성격 변동) 등 이분법에 안 맞는 축 존재. 자기비판: "소유자를 태그로 분류한 것은 과도한 단순화", "이분법은 연속 스펙트럼을 강제로 끊음" |
| Sofia | **3단계 Tier** — T1 구조축(Structure, 불변조건 참여) / T2 제도축(Institutional, 재무제표 필수) / T3 자유태그(Free) | 활동구분(Activity Type)은 차변=대변 균형(불변조건)에 미참여하지만 현금흐름표(CF)에 필수 → 순수 이분법으로 분류 불가. DDD 관점에서 변경 주기가 다르므로 분리 정당 |
| Ryan | **"참조 필드(Reference Field)"** 3번째 카테고리 — 통화(Currency), 환율(Exchange Rate) 등 | FK JOIN이 불필요한 단순 값이 "축"으로 들어가면 구현 복잡도만 증가. TEXT+CHECK 제약이면 충분 |
| Wei | **UX에서 구분을 숨기는 "통합 검색 바"** — 백엔드는 분리 유지, 프론트에서는 구분 의식 불필요 | "식비"가 트리(계정과목)에도 태그(예산)에도 존재하면 사용자 혼란. "트리로 찾을까 태그로 찾을까" 고민을 제거해야 |

**쟁점 2: 소유자(Owner)의 성격**
- Priya: 순수 트리도 태그도 아님. "지분율 기반 배타적 배분(PROPORTIONAL)"이라는 별도 유형 필요
- Account(계정) 귀속 + JEL(전표 라인) Override(재정의) 패턴 필요 (아빠 카드로 엄마가 결제하는 경우)

**쟁점 3: 축 목록 조정 제안**

| 제안 | 위원 | 근거 |
|------|------|------|
| 금융사(Financial Institution): 축→Account 속성 이동 | Priya | 거래마다 바뀌지 않는 계정 고정 정보 |
| 통화(Currency): 축→필드(Field) 재분류 | Ryan | FK 참조 불필요, TEXT 3글자면 충분 |
| 활동구분(Activity Type): Account→JEL 이동 | Sofia | 같은 보통예금에서 영업/투자 활동 모두 발생 |
| 거래처(Counterparty): 신규 추가 검토 | Wei | 거래 상대방 정보가 분류축에 없음 |
| 세무구분→"손익금구분(Deductibility)" 명칭 변경 | Priya | 세무 실무 용어에 부합 |

---

## 라운드 2: 분류 프레임워크 통합안

### 논의 주제

James(의장)가 R1의 Priya "축 속성 모델" + Sofia "3-Tier"를 통합한 **"3-Tier + 속성" 초안**을 제시.

**통합 방식**: Sofia의 Tier 구조(T1/T2/T3)를 골격으로, Priya의 축 속성 모델(배타성/계층/집계가능/재정의)로 각 Tier 내 축을 정밀 기술. Ryan의 "참조 필드" 제안으로 통화를 JEL 필드로, Wei의 "UI 노출 계층" 원칙으로 Tier=UI 노출 우선순위 매핑.

**축 정리**: 13개→9축 + 2속성 + 2필드. **구분 능력은 하나도 줄지 않음** — "독립 축"이라는 이름표만 떼고 더 자연스러운 위치(속성/필드/트리 하위)로 이동. 필터/검색/집계 전부 가능.

### 만장일치 합의 (3건)

- **3-Tier + 속성 모델**: 4명 동의 (Priya 수정 조건 포함)
- **소유자(Owner) 부착**: Account 기본값 + JEL Override + 지분율 (4명 동의)
- **활동구분(Activity Type) JEL 이동**: 4명 동의

### 수정 제안 (반대 없이 전건 수용)

| # | 제안 | 위원 | 내용 |
|---|------|------|------|
| 1 | 활동구분 계층=O | Priya | CF(현금흐름표)에서 2단계 트리 필요 (영업>매출관련, 투자>유형자산취득) |
| 2 | 소득유형 계층=O | Priya | 8종 하위에 과세방식 2단계 (종합과세/분리과세) — 같은 이자소득도 과세 방식에 따라 세액이 완전히 다름 |
| 3 | 손익금구분 값 체계 | Priya | 6값 명확화: 손금산입/불산입/익금산입/불산입/장부존중/미판정 |
| 4 | Account 속성도 Perspective 필터 대상 | Sofia | 상품구분/금융사가 속성으로 이동해도 Perspective(관점)에서 `account_attribute_filters`로 독립 필터 가능 |
| 5 | 통화는 T1이지만 FK 아닌 TEXT 필드 | Ryan | ISO 4217은 3글자 코드. 별도 테이블+FK 참조보다 TEXT+CHECK 제약이 단순하고 성능 우수. T1 성격(잘못 바꾸면 금액 틀어짐)은 유지 |
| 6 | Tier = UI 노출 계층 문서화 | Wei | T1→Flow Card 항상 표시, T2→Lens 기본 필터, T3→Lens 분석 탭 |
| 7 | 활동구분에도 Default+Override 적용 | Ryan/Sofia | 소유자와 동일 패턴: Account에 기본값 + JEL에서 재정의 가능 |

### 미합의 쟁점 → R3로 이월

**거래처(Counterparty) 처리 방식 — 3:1**

| 위원 | 입장 | 핵심 근거 |
|------|------|-----------|
| **Priya** | **(a) T2 제도축, JEL 부착** | 세무 필수 정보: 세금계산서 발행에 거래처 필수, 접대비 한도 계산에 거래처 유형 필요, 특수관계자 판정, 원천징수. T2가 아니면 세무 자동화 불가 |
| **Ryan** | **(c) Transaction 고정 필드** | M:N 태그는 의미론적 불일치(거래처는 태그가 아님), T2는 초기 구현 비용 과다. nullable TEXT 필드로 시작, 필요 시 참조 테이블로 승격 |
| **Wei** | **(c) Transaction 고정 필드** | 거래처는 분류 기준이 아닌 거래의 본질적 메타데이터. OCR 자동 입력과 자연스럽게 연결. 입력 폼에서 "날짜-거래처-적요-금액" 순서가 자연스러움 |
| **Sofia** | **(c) + 독립 Entity** | T2 기준 미충족(재무제표 구조에 미참여), 단순 태그로도 부족(사업자번호 등 구조화 필요). Counterparty를 독립 Entity로 모델링하여 AI 학습/세무 연동 지원 |

---

## 라운드 3: 거래처(Counterparty) 수렴 + 최종 확인

### 논의 주제

James(의장)가 3:1 쟁점에 대한 절충안 제시.

**절충안 핵심**: "Transaction(거래) 필드 + Counterparty(거래처) 독립 참조 Entity + 모드별 필수성"

| 요소 | 내용 | 수용한 입장 |
|------|------|------------|
| Tier 체계에 포함하지 않음 | T1/T2/T3 어디에도 넣지 않음 | Ryan/Wei/Sofia (c)안 |
| 독립 참조 Entity로 존재 | name, business_number, aliases 구조화 | Sofia 제안 |
| Transaction 레벨 부착 | counterparty_id nullable FK | 복식부기에서 차변/대변 양쪽에 같은 거래처 중복은 비합리 |
| 가계 모드: 선택적 입력 | 빈 값 허용 | Wei/Ryan |
| 세무 모드: 조건부 필수 | 세금계산서/접대비/원천징수 거래에서 "입력 필요" 안내 | Priya 세무 근거 |
| aliases (OCR 매핑) | 가맹점명 표기 변형을 매핑 | Ryan/Wei |

### 만장일치 합의

- **R2 수정사항 7건**: 4명 전원 반대 없음 → 확정
- **거래처 절충안**: 4명 전원 동의 (Priya 입장 전환 포함)

**Priya 입장 전환 근거**: "Transaction 레벨 단일 부착이 복식부기 구조상 더 자연스러움(JEL 양쪽에 중복 불필요). 세무 필수성은 모드별 비즈니스 룰로 충분히 해결 가능."

**보완 수용**:
- Counterparty에 `is_related_party`(특수관계자), `counterparty_type`(유형) 속성 예약 (Priya)
- `counterparty_name` 비정규화 캐시는 기록 시점 이름 유지 (Sofia, 회계 감사 추적성)

### GC (컨텍스트 압축)

R1~R3 합의를 압축 정리. **분류 프레임워크 확정**: 3-Tier + 속성 모델, 9축 + 2속성 + 2필드, 거래처 독립 Entity, Default+Override 패턴.

---

## 라운드 4: Aggregate Root(집합 루트) + 외환차손익(FX Gain/Loss) + 프로젝트 구조

### 논의 주제 (3개 묶어 진행)

- **R4-A**: Transaction/Account/Perspective/Counterparty 4개 AR 구조 확정
- **R4-B**: 외환차손익 Lazy Calculation(지연 계산) 패턴 확정
- **R4-C**: B/L/H → Dart/Flutter 프로젝트 구조 확정

### R4-A Aggregate Root 구조 — 만장일치 (수정 포함)

**Transaction에 status(상태) 필드 추가 — 3명이 독립적으로 제기**

| 위원 | 제안 | 관점 |
|------|------|------|
| Priya | Draft / Posted / Voided + voided_by(역분개) | 회계: 불변조건은 Posted에서만 강제. Voided는 역분개 추적 필요 |
| Wei | Draft / Reviewed / Locked | UX: 자동분류 확인 여부를 사용자에게 시각적으로 구분 |
| Sofia | DRAFT / CONFIRMED / SYNCED | DDD: OCR 워크플로우 상태 관리 + Outbox 동기화 상태 |

→ **Priya 안 채택** (Draft/Posted/Voided). 근거: 회계 표준 용어, 역분개(voided_by) 추적 포함, Wei의 UX 요건은 Draft→Posted 전환으로 커버, Sofia의 동기화는 별도 Outbox 상태로 분리.

**추가 수정 (반대 없이 수용)**:

| 제안 | 위원 | 근거 |
|------|------|------|
| Account에 nature(계정 성격) 추가 | Priya | Asset/Liability/Equity/Revenue/Expense 5대 분류. 차변/대변 정상 방향 결정, 재무제표 위치 매핑, 외환차손익 전표 방향에 필수 |
| LegalParameter 확장 | Priya | application_basis(적용 기준): 거래일/귀속연도/신고기한. retroactive(소급적용 여부). source_law(근거 법령). 법 개정 시 시점+소급+근거를 정확히 추적해야 세액 계산 정확 |
| T1 축 이중 저장 | Ryan | 정규화 FK(쓰기 시 무결성) + Materialized Path(읽기 시 LIKE 쿼리 성능). 계정과목 변경은 극히 드물어 동기화 비용 미미 |
| TransactionSource에 SYSTEM_SETTLEMENT 추가 | Sofia | 결산 자동 전표를 사용자 입력과 구분 |

### R4-B 외환차손익 Lazy Calculation — 만장일치

| 위원 | 동의 근거 |
|------|-----------|
| Priya | K-IFRS 기말 평가 방식과 정확히 일치. 결산 시 자동 전표의 계정 매핑 규칙(nature 기반) 필요 |
| Ryan | Drift DAO에서 base_amount UPDATE 메서드를 미제공하면 코드 레벨에서 불변 보장 가능. watchQuery로 환율 변경 감지 → 미실현 손익 자동 재계산 |
| Sofia | 매일 배치는 인프라 과잉, 환율 변동 이벤트 드리븐은 빈도 과다. 결산 자동 전표는 source: SYSTEM_SETTLEMENT로 표시 |
| Wei | 온디맨드 계산으로 "살아있는 데이터" 대시보드 가능. 결산 확정 vs 추정 경계를 UI에서 시각 표시 |

### R4-C 프로젝트 구조 — 만장일치 (수정 포함)

| 제안 | 위원 | 내용 |
|------|------|------|
| `core/protocols/` → `core/interfaces/` | Sofia | Dart 관용 (abstract interface class) |
| `core/widgets/` 공유 UI 분리 | Wei | Balance Flow Card, Lens Switcher는 여러 feature에서 참조 |
| `infrastructure/database/` 세분화 | Ryan | tables/daos/migrations/converters (Drift 코드 생성 파일 관리) |
| feature 간 직접 참조 금지 명시 | Sofia/Ryan | core/interfaces/를 통해 간접 참조만 허용 (H-chain 역전 원칙) |
| core/models/에는 공유 VO만 | (합의) | 도메인 엔티티(Transaction 등)는 features/*/domain/에 위치. core/models/에는 Money, CurrencyCode 등 공유 Value Object만 |

---

## 라운드 5 (최종): Balance Flow Card + OCR 파이프라인 + 정부회계

### 진행 방식
Phase 0에서 이미 상당한 의견이 축적되어 있어 **확정 투표 + 보완** 형태로 효율적 진행.

### R5-A Balance Flow Card UX — 만장일치

James가 Wei의 Phase 0 제안 + R4 Aggregate 구조를 통합한 초안 제시. 전원 동의.

| 위원 | 보완 사항 |
|------|-----------|
| Priya | 다전표 라인(3행+) 거래의 좌우 다노드 세로 쌓기 레이아웃 필요. 세무 모드 시 손익금구분/소득유형 뱃지 표시 영역 |
| Wei | Status 뱃지 시각 체계: Draft=연필+노랑, Posted=체크+기본, Voided=자물쇠+회색. 다통화: 원본(primary) + 환산(secondary, ≈) |
| Sofia | 다통화 노드에 original_amount + base_amount 두 줄 표시 |
| Ryan | 표준 Flutter 위젯 조합(SliverPersistentHeader, PageView, ThemeExtension)으로 구현 가능 확인 |

### R5-B OCR → 로직트리 파이프라인 — 만장일치

| 위원 | 보완 사항 |
|------|-----------|
| Priya | 로직트리에 세무 자동분류 규칙 포함 (접대비→손금산입(한도), 벌과금→손금불산입). CSV 임포트도 [파싱] 단계부터 동일 경로로 합류 |
| Sofia | feature 간 결합 방지: `ICounterpartyMatcher` 인터페이스를 core/interfaces/에 배치 |
| Ryan | ClassificationRules를 Drift 테이블로 관리 (시스템 규칙 + 사용자 규칙, priority 기반) |
| Wei | "OCR 결과를 바로 저장하지 않고 반드시 프리뷰" 원칙. 캡처→OCR→프리뷰→저장/수정 4단계 UX |

### R5-C 정부회계 + 해외소득 확장 — 만장일치

**정부회계**: Perspective.recording_direction으로 Normal/Inverted 전환. DimensionValue 테이블로 회계주체별 축 값 동적 관리 (Sofia). Inverted 모드에서 Flow Card 색상 반전 + 라벨 표시 (Wei).

**해외소득 확장 4건**: 모두 nullable 컬럼/속성 예약, MVP 미구현. 전원 동의.

---

## 전체 요약

| 라운드 | 주제 | 합의 결과 | 핵심 수렴 과정 |
|--------|------|-----------|---------------|
| **R1** | 분류축 + 트리/태그 원칙 | 세부유동성 트리편입 (만장일치) | 이분법 한계를 4가지 관점(회계/DDD/기술/UX)에서 도출 → R2 통합 초안의 입력물 |
| **R2** | 통합 프레임워크 초안 | 3-Tier+속성 모델 (만장일치) | Priya 축속성 + Sofia 3-Tier를 James가 통합. 거래처만 3:1 미합의 |
| **R3** | 거래처 수렴 + 확인 | 독립 Entity + Transaction FK (만장일치) | 의장 절충안: Priya 세무근거 + 3명 구현근거 양립. Priya 자발적 입장 전환 |
| **R4** | Aggregate + 외환 + 구조 | 3주제 모두 만장일치 | status 필드를 3명이 독립 제기(회계/UX/DDD) → Priya 회계용어 채택 |
| **R5** | Flow Card + OCR + 정부회계 | 3주제 모두 만장일치 | Phase 0 축적 의견 기반 확정 투표 + 보완 |

**R1~R5 전 라운드 만장일치 달성. 미합의 쟁점 0건.**
