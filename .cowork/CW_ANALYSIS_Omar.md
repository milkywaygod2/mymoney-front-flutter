# NAVER IFRS Package FY2018 4Q (대만버전) — 58시트 전수 문서화

분석자: Omar | 분석일: 2026-04-19
원본: `★NAVER_IFRS_Package_FY2018_4Q_Eng_V1_MGW.xlsx` (58시트)
제출법인: Mission World Group Limited (MWGL) | 기능통화: USD | 분기: 4Q 2018

---

## 범례

- **CW 커버**: MyMoney 현재 코드베이스에서 대응 구현이 존재하는 개념
- **미커버**: 현재 미구현, 향후 Wave 대상
- **해당없음**: 연결 패키지 전용 개념으로 단일법인 가계부앱에 불필요

---

## 관리 섹션 (4시트)

---

### [00] Consolidation Scope

**목적**: NAVER 연결 그룹 전체 법인 목록 (연결 126개 + 지분법 65개)

**컬럼 구조**:
```
연결/지분법 | NEON코드 | 법인명(국문) | 법인명(영문) | 약어 | 기능통화
| 상위회사코드 | 상위회사명 | Status(자회사/손자회사/중간지배) | 담당자 | 연락처
```

**Status 분류**:
- `1.최상위회사` — NAVER Corp. (HQ)
- `2.중간지배회사` — WMJ, SNC 등
- `3.자회사` — 직접 소유 자회사
- `4.손자회사` — 2단계 이하

**기능통화 종류**: KRW, JPY, USD, HKD, CNY, TWD 확인

**도메인 개념**: 연결 범위 정의 + 법인 계층 구조 + NEON 코드(내부 법인 식별자)

| 항목 | CW 커버 여부 |
|------|-------------|
| 단일 법인 관리 | CW 커버 (Account/Transaction 단일 법인) |
| 다법인 계층 구조 | 미커버 — 연결 지원 시 `Entity` 도메인 필요 |
| NEON 법인코드 | 미커버 — 현재 `OwnerId`로 단순화 |
| 기능통화 법인별 지정 | 미커버 — 현재 단일 baseCurrency |

---

### [01] Cover

**목적**: 패키지 제출 메타데이터

**컬럼 구조**:
```
Holding Company | Compiled Period(시작~종료) | Quarter
| Company Name | Abbreviation | Region | Currency | Compiling Employee
```

**이 시트의 데이터**:
- 제출 법인: Mission World Group Limited / 약어: MWGL / 지역: Other(대만) / 통화: USD

**도메인 개념**: 패키지 메타데이터 (제출자·기간·통화)

| 항목 | CW 커버 여부 |
|------|-------------|
| 기간 관리 | CW 커버 — `FiscalPeriod` 테이블 |
| 기능통화 | CW 커버 — `baseCurrency` 필드 |
| 제출자/담당자 | 해당없음 (연결 보고 전용) |

---

### [02] Index

**목적**: 58시트 전체 목차 + 작성주기(M/Q/Y) 정의

**컬럼 구조**:
```
Contents | Reference No. | 작성주기(M=월/Q=분기/Y=연간)
```

**작성주기**: M(월간): BS·B①Rec&Pay / Q(분기): CE·C1·C2·C3-(5)·C5~C17·L1 / Y(연간): C3-(1)~(4)

**도메인 개념**: IFRS 공시 주기 관리

| 항목 | CW 커버 여부 |
|------|-------------|
| 보고 주기 관리 | 미커버 — 현재 단일 결산 프로세스만 존재 |

---

### [03] Check

**목적**: 전체 시트 입력 완료 여부 + 수식 검증 결과 집계

**컬럼 구조**:
```
Reference No. | Refer Sheet | Complete(Y/N) | Check(TRUE/FALSE 수식 결과들)
```

**검증 구조**: 각 시트의 합계·대차 일치 여부를 TRUE/FALSE 셀로 자동 집계. 오류 건수를 R2에 표시.

**도메인 개념**: 패키지 전체 검증 게이트 — 모든 Check가 TRUE여야 제출 가능

| 항목 | CW 커버 여부 |
|------|-------------|
| 결산 검증 | CW 커버 — `RunSettlement._preparingClose()` (Draft잔존·시산표균형) |
| 다시트 교차검증 | 미커버 — 현재 단일 프로세스 내 검증만 |

---

## A섹션 — 재무제표 (7시트)

---

### [04] A (섹션 목차)

**목적**: A섹션 하위 6시트 목차 (A①BS / A②PL / A③CE / A④CF / A④-1_NCT / A⑤SAD)

**CW 커버 여부**: 해당없음 (목차 시트)

---

### [05] A①BS (대차대조표) — 958행 x 25컬럼

**목적**: 당기말 BS — 현지 계정 → NAVER GCOA → IFRS 3단계 매핑

**이중 구조 (엑셀 실측)**:
```
[왼쪽: 로컬 COA → GCOA 매핑 (Col02-08)] — 21행 데이터
  Col02: Account (로컬 계정코드, 예: 111200)
  Col03: Account Description (현지명, 예: 銀行存款-玉山銀行USD)
  Col04: Account Description (IFRS 영문, 예: Cash in banks)
  Col05: Amount (로컬 금액)
  Col06: IFRS Account Code (GCOA 10자리, F/S mapping)
  Col07: Amount (GCOA 매핑 금액)
  Col08: Note

[오른쪽: IFRS GCOA 계층 전개 (Col10-20)] — 902행 데이터
  Col10: Account Code (GCOA 10자리)
  Col11-16: Level 1~6 계정명 (트리 구조 — 레벨별 들여쓰기)
  Col17: Suggested BS (잔액 — DR. 기준)
  Col18: SAD (감사인 수정분개 영향)
  Col19: CR. (대변 잔액)
  Col20: BS, after adjustment (최종 BS 잔액)
```

**상단 Check 항목**: Suggested F/S vs Final F/S 잔액 일치 / Suspense TRUE/FALSE

**계정 매핑 예시 (엑셀 실측)**:
```
좌측: 111200 | 銀行存款-玉山銀行USD | Cash in banks | 4,887,488 → 1101020110 | 4,887,488
우측: 1101020110 | (L6) Passbook Account | Suggested: 4,887,488
```

**도메인 개념**: 로컬 COA→GCOA 1:1 매핑 + GCOA 6계층 자동 집계 + SAD 조정 반영

| 항목 | CW 커버 여부 |
|------|-------------|
| BS 생성 | CW 커버 — `GenerateBalanceSheet` |
| 계정 계층 집계 | CW 커버 — `DimensionPath` 기반 |
| 6계층 트리 전개 (Col11-16) | CW 커버(부분) — DimensionPath 다단계 지원 |
| 3단계 코드 매핑 (Local→GCOA→IFRS) | 미커버 — 현재 단일 코드 체계 |
| SAD 조정분개 분리 (Col18) | 미커버 — 결산전표와 일반전표 구분 없음 |
| 연결 조정 매핑 | 해당없음 |

---

### [06] A②PL (손익계산서) — 972행 x 26컬럼

**목적**: 당기 PL — 수익·비용 → GCOA 매핑

**이중 구조 (엑셀 실측 — A①BS와 동일 패턴)**:
```
[왼쪽: 로컬 COA → GCOA 매핑 (Col02-08)] — 16행 데이터
  Col02: Account (로컬 계정코드, 예: 4202)
  Col03: Account Description (현지명, 예: 勞務收入- 版權)
  Col04: Account Description (IFRS, 예: Operating revenue)
  Col05: Amount (기간: 2018/11/1~12/31)
  Col06: IFRS Account Code (GCOA 10자리)
  Col07: Amount (GCOA 매핑 금액)
  Col08: Note

[오른쪽: IFRS GCOA 계층 전개 (Col10-21)] — 874행 데이터
  Col10: Account Code (GCOA 10자리)
  Col11-16: Level 1~6 계정명 (트리 구조)
  Col17: Suggested PL (잔액)
  Col18: SAD (감사인 수정분개)
  Col19: CR. (대변 잔액)
  Col20: PL, after adjustment (누적)
  Col21: (추가 검증열)
```

**상단 Check (엑셀 실측)**:
```
R5: Suggested Net Income: -3,268,583
R7: Adjusting entries effect: 0
R8: Net Income on GCOA: -3,268,583
R9: Validation: True
```

**도메인 개념**: 당기순이익 자동검증 (Suggested vs GCOA 합산 일치) + SAD 조정 반영

| 항목 | CW 커버 여부 |
|------|-------------|
| PL 생성 | CW 커버 — `GenerateIncomeStatement` |
| 순이익 검증 | CW 커버 — `RunSettlement` Step1 시산표 균형 |
| 조정분개 효과 분리 (Col18 SAD) | 미커버 — 결산전표와 일반전표 구분 없음 |
| 기간 귀속(2018/11/1~12/31) | CW 커버 — `FiscalPeriod` 테이블 |

---

### [07] A③CE (자본변동표) — 45행 x 17컬럼

**목적**: 자본 5구성요소의 기초→기말 변동 추적

**컬럼 구조 (엑셀 실측)**:
```
Col02: Title (행 레이블)
Col03: Capital Stock (자본금)
Col04: Capital Surplus (자본잉여금)
Col05: Other Capital Composition Elements (기타자본)
Col06: Accumulated Other Comprehensive Income (기타포괄손익누계액)
Col07: Retained Earnings (이익잉여금)
Col08: Total (합계)
Col09-17: (검증/참조 열, NCI 등 연결 전용)
```

**행 구조 (엑셀 실측)**:
```
R6:  Beginning Balance (기초잔액)
R7:  Comprehensive Income (포괄손익)
R8:    Net Income (순이익)
R9:    Gain and Loss from Valuation of AFS Securities (OCI)
R10:   Currency differences (외화환산차이 OCI)
R11:   Changes in equity method investments (지분법 OCI)
R12:   Actuarial gains/losses (보험수리적 OCI)
R13-: 소유주 거래: 자회사설립/취득/처분, 자사주, 배당, 기타
     Ending Balance (기말잔액)
```

**도메인 개념**: 자본 롤포워드 5구성요소 + OCI 5항목 분리 추적

| 항목 | CW 커버 여부 |
|------|-------------|
| 이익잉여금 대체 | CW 커버 — `RunSettlement._closeIncome()` |
| OCI 처리 | 미커버 — AOCI 계정 및 OCI 전표 미구현 |
| 자사주/배당 | 미커버 |
| 자본변동표 생성 | 미커버 — BS/PL만 생성 |

---

### [08] A④CF (현금흐름표) — 126행 x 16컬럼

**목적**: 간접법 CF — C코드 독자 체계로 7분류

**컬럼 구조 (엑셀 실측)**:
```
Col02: CF Acc. Code (C코드 — 7자리, 예: C100000)
Col03: Code Name Level 1 (대분류명)
Col04: Code Name Level 2 (중분류명)
Col05-06: (참조/비고)
Col07: Account Index (Aggregate ACCOUNT / Actual ACCOUNT / Automatic ACCOUNT)
Col08: Amount (금액)
Col09-16: (검증/참조열)
```

**CF 코드 체계 (엑셀 실측 — 총 113개 코드)**:
```
C100000  Cash flows from operating activities [Aggregate]
  C110000  Profit(loss) for the period [Automatic — PL 연동]
  C120000  Addition of expenses, deduction of income items... [Aggregate]
    C120100~C123000  비현금항목 개별 (35개 Actual ACCOUNT)
  C130000  Changes in assets and liabilities [Aggregate]
    C130200~C131600  운전자본 변동 개별 (20개 Actual ACCOUNT)
  C140000  Payment of interest [Actual]
  C150000  Receipt of interest [Actual]
  C160000  Receipt of dividends [Actual]
  C170000  Income tax payments [Actual]
C200000  Cash flows from investing activities [Aggregate]
  C210000  Cash inflows (14개 Actual)
  C220000  Cash outflows (16개 Actual)
C300000  Cash flow from financial activities [Aggregate]
  C310000  Cash inflows (6개 Actual)
  C320000  Cash outflows (6개 Actual)
C400000  Exchange gains (losses) on cash [Actual]
C500000  Net increase in cash [Aggregate]
C6000000 Cash at beginning [Actual]
C7000000 Cash at end [Actual]
```

**Account Index 유형 3종**:
- **Aggregate ACCOUNT**: 하위 합산 수식 (C100000, C120000, C200000 등)
- **Actual ACCOUNT**: 직접 입력 항목 (C120100~, C140000 등)
- **Automatic ACCOUNT**: 타시트 자동 연동 (C110000 — PL 당기순이익)

**도메인 개념**: 간접법 CF + C코드 7분류 + 3가지 계정 인덱스 유형 + 영업/투자/재무 in/outflow 분리

| 항목 | CW 커버 여부 |
|------|-------------|
| activityType 분류 | CW 커버 — `ActivityType` enum |
| CF 보고서 생성 | 미커버 — CF 집계 UseCase 없음 |
| 영업활동 세부 (이자/배당/법인세 분리) | 미커버 — C140~C170 |
| 투자활동 in/outflow 분리 | 미커버 — C210/C220 |
| 재무활동 in/outflow 분리 | 미커버 — C310/C320 |
| 환율변동 효과 분리(C400000) | 미커버 |
| 비현금거래 추적 | 미커버 |
| Automatic→PL 연동 | 미커버 — 시트 간 자동 연결 없음 |

---

### [09] A④CF정보 (CF 보충정보 — 한국어) — 127행 x 18컬럼

**목적**: CF 보충 정보 — 외화환산손익·이자수익/비용의 계정별 원천 분류

**컬럼 구조 (엑셀 실측)**:
```
Col02: 구분 (채권/채무)
Col03: 계정명
Col04: 외화환산이익
Col05: 외화환산손실
Col06: 이자수익
Col07: 이자비용
Col08: 기타
Col09: 금융분류 (금융/기타)
Col10-18: (추가 분석열)
```

**채권 계정 목록**: 현금및현금성자산, 단기금융상품, 장기금융상품, 파생상품자산, 매출채권, 미수금, 대여금, 기타금융자산
**채무 계정 목록**: 매입채무, 차입금, 사채, 기타금융부채

**도메인 개념**: FX손익·이자손익을 계정 원천별로 분해 → CF 영업/금융 구분 근거

| 항목 | CW 커버 여부 |
|------|-------------|
| 외화환산 손익 | CW 커버 — `EvaluateUnrealizedFxGain` |
| 계정원천별 FX 분해 | 미커버 — 현재 집계만 |
| 이자수익/비용 분류 | 미커버 |

---

### [10] A④-1_NCT (비현금거래) — 29행 x 16컬럼

**목적**: CF에서 제외되는 비현금 거래 목록 (현물출자, 전환사채 전환 등)

**컬럼 구조 (엑셀 실측)**:
```
Col02: Type (비현금 거래 유형)
Col03: Description (상세 설명)
Col07: Amount (금액)
```

**도메인 개념**: 비현금거래 별도 공시 — CF 완전성 보완

| 항목 | CW 커버 여부 |
|------|-------------|
| 비현금 거래 추적 | 미커버 |
| 자동전표 구분 | CW 커버(부분) — `TransactionSource.systemSettlement` |

---

### [11] A⑤SAD (감사인 수정분개) — 45행 x 9컬럼

**목적**: 감사 과정에서 발생하는 수정전표 (Subsequent Adjusting Differences)

**컬럼 구조 (엑셀 실측)**:
```
Col02: CoA Code (GCOA 10자리)
Col03: Account (계정명)
Col04: BS Dr. (BS 차변 금액)
Col05: BS Cr. (BS 대변 금액)
Col06: PL Dr. (PL 차변 금액)
Col07: PL Cr. (PL 대변 금액)
Col08: Description (수정 사유)
```

**도메인 개념**: BS/PL 양면 영향 기록 — 감사 수정분개 이력

| 항목 | CW 커버 여부 |
|------|-------------|
| 수정전표 | CW 커버 — `VoidTransaction` + 역분개 패턴 |
| 감사인 수정 구분 | 미커버 — 수정 원천 구분 없음 |

---

## B섹션 — 내부거래 (5시트)

---

### [12] B (섹션 목차)

**목적**: B섹션 5시트 목차

```
B① Rec&Pay(Consolidated)  — 연결법인 채권채무
B② Rev&Exp(Consolidated)  — 연결법인 수익비용
B③ Inv.Transaction         — 연결법인 재고거래
B④ Rec&Pay(Equity)         — 지분법 채권채무
B⑤ Rev&Exp(Equity)         — 지분법 수익비용
```

**CW 커버 여부**: 해당없음 (목차 시트)

---

### [13] B①Rec&Pay(Consolid.) (연결 채권채무) — 1,095행 x 15컬럼

**목적**: 연결 법인 간 채권채무 잔액 — 연결 상계 소거 근거 / 작성주기: M

**컬럼 구조 (엑셀 실측 — R11 헤더)**:
```
Col02: Your Company (보고법인)
Col03: Counterpart (상대법인)
Col04: Account Code (Receivables) — 채권 계정코드 (GCOA 10자리)
Col05: Account Name (Receivables) — 채권 계정명
Col06: Currency (거래통화)
Col07: Receivables Amount (Transaction Curr.) — 거래통화 채권 금액
Col08: Receivables Amount (Local Curr.) — 기능통화 채권 금액
Col09: Receivables Remark
Col10: Account Code (Payables) — 채무 계정코드
Col11: Account Name (Payables) — 채무 계정명
Col12: Currency
Col13: Payables Amount (Transaction Curr.) — 거래통화 채무 금액
Col14: Payables Amount (Local Curr.) — 기능통화 채무 금액
Col15: Payables Remark
```

**데이터 예시 (엑셀 실측)**:
```
MWGL | CHOCO MEDIA CO., LIMITED | 1105020100 | Non-trade Receivables | USD | 96,000 | 96,000
MWGL | CHOCOLABS PTE. LTD. | 1105020100 | Non-trade Receivables | USD | 50,000 | 50,000
```

**도메인 개념**: 쌍방 계정코드 매핑 + 다통화 금액 동시 기록 + 내부/외부 구분

| 항목 | CW 커버 여부 |
|------|-------------|
| 거래처 관리 | CW 커버 — `Counterparty` |
| 채권채무 구분 | CW 커버 — `entryType` DR/CR |
| 다통화 금액 | CW 커버 — `originalAmount + originalCurrency + baseAmount` |
| 법인간 소거 | 해당없음 (단일법인) |

---

### [14] B②Rev&Exp(Consolid.) (연결 수익비용) — 175행 x 20컬럼

**목적**: 연결 법인 간 수익·비용 거래 내역 / 작성주기: M

**컬럼 구조 (엑셀 실측 — R11 헤더, 19컬럼 유효)**:
```
Col02: Your Company (보고법인)
Col03: Counterpart (상대법인)
Col04: DATE (수익 거래일)
Col05: Account Code (Revenue) — 수익 계정코드
Col06: Account Name (Revenue) — 수익 계정명
Col07: Currency (거래통화)
Col08: Revenue Amount (Transaction Curr.)
Col09: Revenue Amount (Local Curr.)
Col10: Revenue Remark
Col11: DATE (비용 거래일)
Col12: Account Code (Expense) — 비용 계정코드
Col13: Account Name (Expense) — 비용 계정명
Col14: Currency
Col15: Expense Amount (Transaction Curr.)
Col16: Expense Amount (Local Curr.)
Col17: Expense Remark
Col19: Expense Remark (추가)
```

**도메인 개념**: 수익·비용 대응 쌍 기록 — 같은 거래의 양면

| 항목 | CW 커버 여부 |
|------|-------------|
| 복식부기 수익·비용 | CW 커버 — JEL DR/CR 쌍 |
| 내부거래 손익 소거 | 해당없음 |

---

### [15] B③Inv.Transaction (재고 내부거래) — 207행 x 25컬럼

**목적**: 연결 법인 간 재고 거래 및 기말 미실현손익

**구조 (엑셀 실측)**:
```
섹션 1 (R25~): 기말 재고 잔액 + 변동
  (1) FG(Finished Goods) / (2) Merchandise — 병렬 2열 구조
  행: Beginning Balance / Increase: Purchases / Decrease 5유형 / Ending Balance / Sales Ratio(%)

섹션 2: 법인간 매매 금액
  법인간 매출액 / 매입액

섹션 3: 재판매 마진율(%)
섹션 4: 원가결정방법 (FIFO/이동평균/총평균/개별법/표준원가)
섹션 5: 매입 용도별 구분 (resell/consumption/invested)
```

**감소 유형 5가지 (Check 포함)**:
```
Sold(COGS) [True] / Valuation loss [True] / Obsolescence [True]
/ Other(COGS) / Other(except COGS)
```

**도메인 개념**: 재고 FG/Merchandise 이원 관리 + 감소 5분류 + 마진율 + 원가법

| 항목 | CW 커버 여부 |
|------|-------------|
| 재고 자산 | 미커버 (가계부 범위 외) |
| COGS 계정 | CW 커버 — COA `5001270000 Cost of Goods Sold` |

---

### [16] B④Rec&Pay(Equi.) (지분법 채권채무) — 39행 x 16컬럼

**목적**: 지분법 적용 회사와의 채권채무 잔액 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R11 헤더, B①과 동일 15컬럼 구조)**:
```
Col02-09: Receivables 측 (Your Company/Counterpart/Code/Name/Currency/Txn Amt/Local Amt/Remark)
Col10-15: Payables 측 (Code/Name/Currency/Txn Amt/Local Amt/Remark)
```

**도메인 개념**: 지분법 투자 — 연결 범위 밖이나 유의적 영향력 있는 관계사 거래

| 항목 | CW 커버 여부 |
|------|-------------|
| 지분법 투자 | 미커버 |
| 관계사 채권채무 | 미커버 |

---

### [17] B⑤Rev&Exp(Equi.) (지분법 수익비용) — 39행 x 16144컬럼(유효~17)

**목적**: 지분법 적용 회사와의 수익·비용 거래 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — B②와 동일 17컬럼 유효 구조)**:
```
Col02-10: Revenue 측 (Company/Counterpart/Date/Code/Name/Currency/Txn Amt/Local Amt/Remark)
Col11-17: Expense 측 (Date/Code/Name/Currency/Txn Amt/Local Amt/Remark)
```

**도메인 개념**: 지분법 관계사와의 영업거래 투명성 확보

| 항목 | CW 커버 여부 |
|------|-------------|
| 지분법 손익 | 미커버 |

---

## C섹션 — 주석 (30시트)

---

### [18] C (섹션 목차)

**목적**: C섹션 주석 목록 + 대상 법인(모두 ALL)

**목록**:
```
C1 주요주주 / C2 고객계약수익 / C3-(1~5) 재무위험+공정가치
C5 현금 / C6 채권 / C7-(1~4) 유가증권 / C8 종속·관계기업투자
C9-(1~2) 유형자산+리스 / C10 무형자산 / C11 차입금 / C12 충당부채
C13-(1~2) 종업원급여 / C14 우발부채 / C15 자본 / C16 주식기준보상
C17 이익잉여금 / C18 금융상품손익 / C19-(1~2) 법인세 / C21 보고기간후사건
```

**CW 커버 여부**: 해당없음 (목차 시트)

---

### [19] C1 (주요 주주 현황) — 28행 x 12컬럼

**목적**: 기말 주주 구성 및 지분율 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R11 헤더)**:
```
Col02: Shareholder's Name (주주명)
Col03: No. of Common shares (보통주 수)
Col04: Common share ratio(%) (보통주 비율)
Col05: No. of Preferred shares (우선주 수)
Col06: Preferred share ratio(%) (우선주 비율)
```

**도메인 개념**: 보통주/우선주 분리 + 자사주 별도 표시

| 항목 | CW 커버 여부 |
|------|-------------|
| 자본 구성 | 미커버 — 개인 가계부 범위 외 |

---

### [20] C2 (고객계약수익 — IFRS 15)

**목적**: IFRS 15 기반 수익 분류 + 계약자산/부채 공시 / 작성주기: Q

**주요 공시 항목**:
```
수익 유형 분류 (계약 vs 기타원천)
계약자산(Contract Asset) vs 계약부채(Contract Liability) 잔액
계약부채 변동 (기초→인식→기말)
미이행 장기계약 잔여의무
계약자산 취득원가·상각·손상
```

**핵심 개념**:
- 포인트(Naver Paypoint) → `Contract Liability - customer loyalty system`
- IAS 18 비교 공시 (FY2018 전환연도 한정)

| 항목 | CW 커버 여부 |
|------|-------------|
| 수익 인식 | CW 커버 — PL Revenue 계정 |
| 계약부채(선불/포인트) | 미커버 — COA `2107020700 Contract Liabilities` 계정 존재하나 UseCase 없음 |
| 이행의무 추적 | 미커버 |

---

### [21] C3-(1) (재무위험 — 신용위험)

**목적**: 자산별 신용위험 노출 금액 집계 / 작성주기: Y

**컬럼 구조**:
```
Index | 기말잔액
현금성자산 / 단기금융상품 / FVTPL / 매출채권 / AFS / HTM유동
/ 장기금융상품 / FVTPL비유동 / 리스보증금 / 장기매출채권 / 장기대여금
```

**도메인 개념**: 신용리스크 최대 노출액 매트릭스

| 항목 | CW 커버 여부 |
|------|-------------|
| 자산 잔액 집계 | CW 커버 — `GenerateBalanceSheet` |
| 신용리스크 계산 | 미커버 |

---

### [22] C3-(2) (재무위험 — 유동성위험)

**목적**: 금융부채 만기별 현금유출 매트릭스 / 작성주기: Y

**컬럼 구조**:
```
Index | Book Value | Contractual Cash-flows
| Within 1 year (원금/이자) | 1~5 years (원금/이자) | Over 5 years (원금/이자)
```

**도메인 개념**: 부채 만기 사다리(maturity ladder) — 유동성 조기경보

| 항목 | CW 커버 여부 |
|------|-------------|
| 부채 잔액 | CW 커버 |
| 만기별 분류 | 미커버 — 현재 만기일 필드 없음 |
| 유동성 분석 뷰 | 미커버 |

---

### [23] C3-(3) (재무위험 — 외환위험)

**목적**: 통화별 자산·부채 매트릭스 — 환위험 노출액 / 작성주기: Y

**컬럼 구조**:
```
Index | Local Currency | KRW | USD | JPY | TWD | EUR | Others(*1) | Total
[자산 행들 / 부채 행들 / 순노출액]
```

**도메인 개념**: 7통화 FX 리스크 매트릭스 — 통화별 순포지션 계산

| 항목 | CW 커버 여부 |
|------|-------------|
| 다통화 잔액 | CW 커버 — `originalCurrency + baseAmount` |
| FX 미실현손익 | CW 커버 — `EvaluateUnrealizedFxGain` |
| 통화별 순포지션 뷰 | 미커버 |

---

### [24] C3-(4) (재무위험 — 이자율위험)

**목적**: 이자부 자산·부채를 고정/변동금리로 분류 / 작성주기: Y

**컬럼 구조**:
```
Index | Non Interest-bearing | Fixed Rate | Hedged Floating | Unhedged Floating | Total
```

**도메인 개념**: 금리 감응도 분석 — 변동금리 자산/부채 식별

| 항목 | CW 커버 여부 |
|------|-------------|
| 이자율 관리 | 미커버 — 이자율 필드 없음 |
| 헤지회계 | 미커버 |

---

### [25] C3-(5) (공정가치)

**목적**: 금융상품 공정가치 계층 분류 / 작성주기: Q

**컬럼 구조**:
```
Index | Book Value | 공정가치 측정 자산 | 원가 측정 자산
Level 1(시장가) / Level 2(관측가능 투입변수) / Level 3(비관측 투입변수)
```

**도메인 개념**: IFRS 13 공정가치 계층 3단계

| 항목 | CW 커버 여부 |
|------|-------------|
| 공정가치 평가 | 미커버 — 현재 장부가 기반만 |
| FV 계층 분류 | 미커버 |

---

### [26] C5 (현금및현금성자산)

**목적**: 현금성자산 세부 분류 + 합계 검증 / 작성주기: Q

**컬럼 구조**:
```
Index | 기말잔액
현금보유(Cash on Hand)
예금: 요구불·MMDA / 정기·CD / 설치
외화예금: 요구불 / 정기·CD
정부보조금 예금
합계 → BS 현금성자산 검증(TRUE/FALSE)
```

**도메인 개념**: 현금성 판단 기준(3개월 이내 만기)

| 항목 | CW 커버 여부 |
|------|-------------|
| 현금 계정 | CW 커버 — COA 1101xxx |
| 예금 세부 분류 | CW 커버 — COA 6레벨(Passbook/CMA/MMF/MMDA 등) |
| 정부보조금 분리 | 미커버 |

---

### [27] C6 (매출채권 및 기타채권)

**목적**: 채권 4분면 매트릭스 + 대손충당금 + 연령분석 / 작성주기: Q

**컬럼 구조**:
```
Index | 연결법인 내부(유동/비유동) | 외부(유동/비유동)
매출채권 / 대손충당금 / 미수금 / 미수수익 / 대여금 / 리스보증금 등
```

**추가 섹션**: 대손충당금 변동(설정/환입/상각) + 연령분석(30/60/90/90일초과)

| 항목 | CW 커버 여부 |
|------|-------------|
| 채권 계정 | CW 커버 — COA 1105xxx |
| 대손충당금 | 미커버 |
| 연령분석 | 미커버 |
| 내부/외부 구분 | 미커버 |

---

### [28] C7-(1) (FVOCI 금융자산 — 구 AFS) — 54행 x 32컬럼

**목적**: 기타포괄손익-공정가치 금융자산 변동 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R8 헤더)**:
```
Col02: Index
Col03: Current/Non-Current (유동/비유동)
Col04: Consolidation scope (연결범위 내외)
Col05: Fair Value Assessment (O/X)
Col06: Account Name (계정명)
Col07: % of Ownership (지분율)
Col08~12: Acquisition (취득원가: 기초/IFRS9조정/처분/기타/기말)
Col13~18: Valuation (평가액: 기초/평가손익/처분/기타/기말)
Col19~23: Impairment (손상: 기초/당기/환입/기타/기말)
Col24~: Term-End Amount (기말 장부가)
```

**도메인 개념**: AFS → FVOCI (IFRS 9 전환) 변동 추적

| 항목 | CW 커버 여부 |
|------|-------------|
| 금융자산 평가 | 미커버 |
| OCI 누계 | 미커버 |

---

### [29] C7-(2) (상각후원가 금융자산 — 구 HTM) — 135행 x 19컬럼

**목적**: 상각후원가 장기금융상품 변동 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R8 헤더, 18컬럼)**:
```
Col02: Current/Non-Current
Col03: Consolidation scope
Col04: Account Name
Col05: Asset Name
Col06: Maturity Date (만기일)
Col07: Interest Rate (이자율)
Col08: Acquisition Cost (취득원가)
Col09: Initial Amount (기초)
Col10: IFRS 9 Initial Adjustment
Col11: IFRS 9 Initial Adjustment - Bad Debt Allowance
Col12: Acquisition (당기 취득)
Col13: Depreciation Amount (Interest Revenue) — 유효이자율 상각
Col14: Financial Asset Bad Debt Allowance (대손충당금)
Col15: Disposal Amount due to Maturity (만기 처분)
Col16: Substitution for (유동성 대체)
Col17: Others
Col18: Term-end Amount (기말)
```

**도메인 개념**: HTM 상각후원가 측정 + IFRS 9 전환 조정

| 항목 | CW 커버 여부 |
|------|-------------|
| 만기/이자율 필드 | 미커버 |

---

### [30] C7-(3) (FVTPL 금융자산) — 135행 x 16컬럼

**목적**: 당기손익-공정가치 금융자산(구 Trading) 변동 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R8 헤더, 15컬럼)**:
```
Col02: Current/Non-Current
Col03: Consolidation scope
Col04: Fair Value Assessment (O/X)
Col05: Asset Name
Col06: Maturity Date
Col07: Interest Rate
Col08: Acquisition Cost
Col09: Initial Amount (기초)
Col10: Current-Term Acquisition (당기 취득)
Col11: Disposal Amount due to Maturity (만기 처분)
Col12: Gains on valuation (평가이익)
Col13: Losses on valuation (평가손실)
Col14: Others
Col15: Term-end Amount (기말)
```

**도메인 개념**: FVTPL = 매매목적 금융자산, 공정가치 변동 → PL 직접 반영

| 항목 | CW 커버 여부 |
|------|-------------|
| FVTPL 평가손익 | 미커버 |

---

### [31] C7-(4) (주요 금융상품 변동 통합) — 158행 x 16컬럼

**목적**: 주요 금융상품 전체 기초→기말 롤포워드 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R8 헤더, 15컬럼)**:
```
Col02: Accounts (계정명)
Col03: Consolidated or External (연결내/외부)
Col04: Initial Amount (기초)
Col05: Acquisition(+) (취득)
Col06: Disposal(-) (처분)
Col07: Liquidity Substitution(+/-) (유동성 대체)
Col08: Valuation(+/-) (평가)
Col09: Impairment(Provision) or Reversal(+/-) (손상/환입)
Col10: The effective interest rate amortization(+) (유효이자율 상각)
Col11: Business Combination(+) (사업결합)
Col12: Seperation(-) (분리)
Col13: Foreign Currency Translation(+/-) (외화환산)
Col14: Other(+/-) (기타)
Col15: Term-end Amount (기말)
```

**대상 계정(자산)**: 단기/장기금융상품, 단기/장기대여금(내외), 유동/비유동보증금
**대상 계정(부채)**: 수령보증금

**도메인 개념**: 금융상품 통합 롤포워드 매트릭스 + 연결/외부 이원화

| 항목 | CW 커버 여부 |
|------|-------------|
| 금융상품 계정 | CW 커버 — COA 1102~1211 |
| 롤포워드 추적 | 미커버 |

---

### [32] C8 (종속기업·관계기업·조인트벤처 투자) — 96행 x 18컬럼

**목적**: 투자 법인별 변동 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R6 헤더, 15컬럼)**:
```
Col02: Index
Col03: Name of company (법인명)
Col04: % of ownership (Ending) (기말 지분율)
Col05: % of ownership (Beginning) (기초 지분율)
Col06: Acquisition Cost (취득원가)
Col07: Initial Amount (기초)
Col08: Acquisition (당기 취득)
Col09: Disposal (처분)
Col10: Business Combination (사업결합)
Col11: Decrease due to Seperation (분리)
Col12: Loss on Impairment (Subsequent Gain) (손상/환입)
Col13: Others (기타)
Col14: Term-end Amount (기말)
Col15: Remarks
```

**도메인 개념**: 지분법 투자 롤포워드 + 지분율 변동 추적

| 항목 | CW 커버 여부 |
|------|-------------|
| 지분법 투자 | 미커버 — COA 1207xxx 계정 존재하나 UseCase 없음 |

---

### [33] C9-(1) (유형자산) — 135행 x 23컬럼

**목적**: 유형자산 7분류 취득원가·감가상각 롤포워드 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R6 헤더, 11컬럼 = 행 레이블 + 자산분류 9개)**:
```
Col02: Index (행 레이블)
Col03: Land (토지)
Col04: Building (건물)
Col05: Construction (구축물)
Col06: Machinery & Equipment (기계장치)
Col07: Furniture & Fixtures (집기비품)
Col08: Delivery Equipment or Vehicles (차량운반구)
Col09: Other Tangible Assets (기타유형자산)
Col10: Construction in Progress (건설중인자산)
Col11: Total (합계)
```
**행 구조**: 취득원가(기초/취득/복구충당/처분현금/처분비현금/기타/기말)
          + 누적상각+손상(기초/당기/손상/처분/기타/기말)
          + 기말 장부가

**도메인 개념**: 유형자산 7분류 + 이중 구조(취득원가/누적상각)

| 항목 | CW 커버 여부 |
|------|-------------|
| 유형자산 계정 | CW 커버 — COA 1201xxx |
| 감가상각 계산 | 미커버 — COA `5001080000 Depreciation` 계정 존재 |
| 복구충당금 | 미커버 |

---

### [34] C9-(2) (리스)

**목적**: 금융리스·운용리스 공시 (IAS 17 / IFRS 16 전환기) / 작성주기: Q

**컬럼 구조**:
```
리스 분류: 금융리스(2) / 운용리스(3)
금융리스 자산: 취득가/누적상각/정부보조금/장부가
운용리스 미래 최소리스료: 1년내/1~5년/5년초과
```

**도메인 개념**: 리스 분류 기준 + 미래 현금유출 공시

| 항목 | CW 커버 여부 |
|------|-------------|
| 리스 부채 | 미커버 |
| 운용리스 약정 | 미커버 |

---

### [35] C10 (무형자산) — 183행 x 24컬럼

**목적**: 무형자산 5분류 롤포워드 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R6 헤더, 8컬럼)**:
```
Col02: Index (행 레이블)
Col03: Industrial Property Right (산업재산권)
Col04: Software (소프트웨어)
Col05: Business Rights (영업권)
Col06: Other Intangible Assets (기타무형자산)
Col07: Construction in Progress(Japan) (건설중자산 — 일본)
Col08: Total (합계)
```
**행 구조**: 취득원가(기초/취득/처분현금/처분비현금/기타/기말)
          + 누적상각+손상(기초/상각비/손상/처분/기타/기말)
          + 기말 장부가

**도메인 개념**: 무형자산 상각 + 손상

| 항목 | CW 커버 여부 |
|------|-------------|
| 무형자산 계정 | CW 커버 — COA 1203xxx |
| 상각비 계산 | 미커버 — COA `5001090000 Amortization` 계정 존재 |

---

### [36] C11 (차입금·사채) — 50행 x 17컬럼

**목적**: 차입금 및 사채 명세 + 변동 내역 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R6 헤더, 13컬럼)**:
```
Col02: Currency (통화)
Col03: Borrowings Type (차입 유형)
Col04: Source: In/Out of Consolidation scope (연결내/외부)
Col05: Floating/Fixed Interest Rate (변동/고정금리)
Col06: Borrower (Debentures:Underwriter)
Col07: Annual Interest Rate(%) (연이자율)
Col08: Borrowed Date (Debentures:Issued Date) (차입일/발행일)
Col09: Maturity Date (만기일)
Col10: Curr. (통화)
Col11: Applicable Exchange Rate (적용환율)
Col12: Borrowing Amount (transaction currency) (거래통화 차입액)
Col13: 2018-12-31 (기말잔액 — 기능통화)
```

**하단 변동 내역**: 기초 / 차입(+) / 상환(-) / 유동성대체 / 환율효과 / 기타 / 기말

**도메인 개념**: 부채 만기 + 금리 유형 + 연결/외부 구분

| 항목 | CW 커버 여부 |
|------|-------------|
| 차입금 계정 | CW 커버 — COA 2102/2202 |
| 이자율 필드 | 미커버 |
| 만기 관리 | 미커버 |

---

### [37] C12 (충당부채) — 55행 x 21컬럼

**목적**: 충당부채 유형별 롤포워드 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R13 헤더, 16컬럼)**:
```
Col02: Current/Non-Current (유동/비유동)
Col03: Account Code (GCOA 계정코드)
Col04: Account (계정명)
Col05: Provisions Type (충당 유형)
Col06: 2018-01-01 (기초잔액)
Col07: Additional provisions(+) (추가설정)
Col08: Depreciation of the period(+) (유효이자율 상각)
Col09: Reversal of unused amount(-) (환입)
Col10: Used(-) (사용)
Col11: Business combination(+) (사업결합)
Col12: Seperation(-) (분리)
Col13: Liquidity Substitution(+/-) (유동성 대체)
Col14: Others(+/-) (기타)
Col15: 2018-12-31 (기말잔액)
Col17: Mainly Using Year (주요 사용연도)
```

**충당 유형 4가지**:
- `Additional provisions`: 최초 인식 또는 추가 적립
- `Depreciation of period`: 유효이자율 상각에 의한 변동
- `Reversal of unused amount`: 미사용분 환입
- `Used(-)`: 실제 발생으로 충당금 사용

| 항목 | CW 커버 여부 |
|------|-------------|
| 충당부채 계정 | CW 커버 — COA 2104/2204 |
| 충당금 롤포워드 UseCase | 미커버 |

---

### [38] C13-(1) (종업원급여 — 연간)

**목적**: 확정급여형(DB) 퇴직부채 전체 롤포워드 / 작성주기: Y

**컬럼 구조**:
```
1. 퇴직급여부채: DB채무(적립형/비적립형) / 외부적립자산 / 순부채
2. DB채무 변동: 기초/퇴직금지급/당기근무원가/과거근무원가/이자비용/계열사이동/보험수리적손익/기말
3. 외부적립자산 변동: 기초/납입/운용수익/기말
4. OCI — 보험수리적 손익: 인구통계가정/재무가정/경험조정
```

**도메인 개념**: DB형 퇴직부채 전체 롤포워드 + OCI 처리

| 항목 | CW 커버 여부 |
|------|-------------|
| 퇴직급여 계정 | CW 커버 — COA 2203/5001020000 |
| DB 채무 계산 | 미커버 |
| 보험수리적 가정 | 미커버 |

---

### [39] C13-(2) (종업원급여 — 분기 중간)

**목적**: C13-(1)의 분기 버전 (간소화) / 작성주기: Q

**추가 항목**: 계열사 이동(전입/전출/순이동) 별도 컬럼

**컬럼 구조**: C13-(1)과 동일, 분기 합산 데이터

**도메인 개념**: 분기 DB채무 추정 (연간 계리 계산의 분기 배분)

| 항목 | CW 커버 여부 |
|------|-------------|
| 분기 배분 | 미커버 |

---

### [40] C14 (우발부채 및 약정) — 108행 x 21컬럼

**목적**: 소송·대출약정·지급보증 공시 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R12 헤더)**:
```
Col02: No.
Col03: Occurred Year (발생연도)
Col04: Lawsuit (Lawsuit No.) (소송명/번호)
Col05: Facts of Event (사실관계)
Col07: Litigation Costs (소송금액)
Col09: The parties to a suit (당사자)
Col13: Progress Status (진행상황)
Col14: Conclusion (결론)
```

**도메인 개념**: 우발부채 — 현재 인식 불가하나 공시 필요

| 항목 | CW 커버 여부 |
|------|-------------|
| 우발부채 | 미커버 |

---

### [41] C15 (자본 — 주식수 변동) — 248행 x 14컬럼

**목적**: 발행주식수 변동 + 기타자본 구성요소 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R6 헤더)**:
```
Col02: Common Stock (보통주)
Col03: Date of variation (변동일)
Col04: No. of Issued Stocks (발행주식수)
Col05: Treasury Stock (자사주)
Col06: No. of Distributed Stocks (유통주식수)
```
**행 구조**: 기초/스톡옵션행사/자사주취득/기타/기말

**기타자본 구성요소**: 주식발행초과금, 자사주, 기타자본잉여금, 재평가잉여금, FVOCI 누계

**도메인 개념**: 자본거래 이력 + 자기주식 관리

| 항목 | CW 커버 여부 |
|------|-------------|
| 자본 계정 | CW 커버 — COA 3101~3105 |
| 자사주 관리 | 미커버 |
| 자본거래 이력 | 미커버 |

---

### [42] C16 (주식기준보상) — 50행 x 15컬럼

**목적**: 스톡옵션·ESOP 등 주식기준보상 공시 / 작성주기: Q

**컬럼 구조 (엑셀 실측 — R11 헤더)**:
```
Col02: Grant Date (부여일)
Col03: Classification (주식결제/현금결제)
Col04: Type (유형)
Col05: Total No. of Shares Granted (총부여수)
Col06: Base quantity (기준수량)
Col07~09: Decrease in amount (감소: 행사/소멸/기타)
Col10: No. of Non-Exercised Shares at Term-End (기말 미행사수)
Col11: Granted Company (부여 회사)
Col12: Exercise Value (행사가, 단위: KRW)
Col13: Exercisable Period (행사 가능 기간)
Col14: Exercisable Condition (행사 조건)
```

**도메인 개념**: 스톡옵션 풀 관리 + 가중평균 행사가

| 항목 | CW 커버 여부 |
|------|-------------|
| 주식보상 비용 | CW 커버 — COA `5001030000 Stock Option Expense` |
| 옵션 수량 관리 | 미커버 |

---

### [43] C17 (이익잉여금 변동)

**목적**: 이익잉여금 기초→기말 롤포워드 / 작성주기: Q

**컬럼 구조**:
```
1. 기말 이익잉여금 구성: 법정적립금 / 임의적립금 / 미처분이익잉여금 / 합계
2. 변동 내역: 기초 → 당기순이익 → 법정적립금 → 보험수리적손익 → 배당 → 기타 → 기말
```

**실제 데이터**:
```
기초: -2,158,161 / 당기순이익: -3,268,583 / 기말: -5,426,744
```

**도메인 개념**: RE 롤포워드 = 결산 4단계의 핵심 구조

| 항목 | CW 커버 여부 |
|------|-------------|
| 이익잉여금 대체 전표 | CW 커버 — `RunSettlement._closeIncome()` |
| 법정적립금 적립 | 미커버 |
| 배당금 처리 | 미커버 |
| 보험수리적손익 OCI | 미커버 |

---

### [44] C18 (금융상품 손익)

**목적**: 금융자산/부채별 손익 항목 분해 / 작성주기: Q

**컬럼 구조**:
```
[자산]
FVOCI: 이자수익/FX환산이익/FX환산손실/FX거래이익/FX거래손실/OCI/OCI재분류/처분이익/처분손실/배당/손상/손상환입
FVTPL: 이자수익/평가이익/평가손실/처분이익/처분손실/배당
상각후원가: 이자수익/FX환산손익/대손충당금 손익
[부채]
이자비용/FX환산손익/FV변동
```

**도메인 개념**: 금융상품 측정 방식(FVOCI/FVTPL/AC)별 손익 분해

| 항목 | CW 커버 여부 |
|------|-------------|
| FX 손익 | CW 커버 — `EvaluateUnrealizedFxGain` |
| 이자수익/비용 | 미커버 — COA 6100/6200 계정 존재하나 계산 없음 |
| 측정 방식별 분류 | 미커버 |

---

### [45] C19-(1) (법인세 — 분기 중간)

**목적**: 분기 법인세 추정 계산 / 작성주기: Q

**컬럼 구조**:
```
1. 법인세 계산: 세전이익 | 가중평균 유효세율(%) | 법인세 | 전기 법인세 조정 | 법인세비용(PL)
2. 유효세율 분석: 당기 / 전기 / 변동(%)
```

**실제 데이터**: 세전이익 -3,268,583 / 법인세 0 (적자법인)

**공식**: `세전이익 × 가중평균 유효세율 = 분기 법인세`

| 항목 | CW 커버 여부 |
|------|-------------|
| 세전이익 | CW 커버 — `GenerateIncomeStatement` |
| 법인세 계산 | 미커버 — `TaxRuleEngine`은 손금 판정만, 실효세율 없음 |

---

### [46] C19-(2) (법인세 — 연간 확정)

**목적**: 연간 확정 법인세 전체 분석 4섹션 / 작성주기: Y

**4섹션 구조**:
```
1. 주요 구성요소: 당기법인세(미납/원천징수) / 전기 조정액
2. 유효세율 차이 분석: 이론세율 적용값 vs 실제 차이 요인별
3. OCI 관련 세금효과: 각 OCI 항목별 세전/세금효과/세후
4. 일시적 차이: 이연법인세자산/부채 변동 원천별
```

**도메인 개념**: 이연법인세 + 영구적/일시적 차이 분석

| 항목 | CW 커버 여부 |
|------|-------------|
| 이연법인세 | 미커버 — COA 1107/1208/2106/2205 계정 존재 |
| 일시적 차이 추적 | 미커버 |

---

### [47] C21 (보고기간 후 사건)

**목적**: 결산일 이후 ~ 패키지 제출 전 중요 사건 공시 / 작성주기: Q

**컬럼 구조**:
```
사건 유형 | 발생 내용 | 금액 | 처리 방향(수정/비수정 사건)
```

**9가지 유형**: M&A/사업중단/자산취득·수용/재해/구조조정/주식거래/자산가치·환율급변/세법변경/우발채무

**도메인 개념**: IFRS 10호 보고기간후사건 — 수정/비수정 사건 구분

| 항목 | CW 커버 여부 |
|------|-------------|
| 보고기간후 사건 | 미커버 |

---

## L섹션 — LINE Group 공시 (4시트)

---

### [48] L (섹션 목차)

**목적**: L섹션 4시트 목차 (일본어)

```
L1 開示(LINEグループ)-四半期 — 분기 공시
L2 開示(LINEグループ)-年度 — 연간 공시
L3 開示(LINEグループ)-監査報酬 — 감사보수
L4 事業セグメント — 사업 세그먼트
```

**CW 커버 여부**: 해당없음 (목차 시트)

---

### [49] L1 (LINE Group 분기 공시) — 100행 x 13컬럼

**목적**: LINE Group 연결 기준 분기 공시 데이터 수집 / 작성주기: Q

**공시 항목 4그룹**:
```
1. 금융상품 변동(C7-(4) 연계):
   단기/장기금융상품, 보증금(건물/기타), 장기대여금
   지분법투자(지분법/투자차액), 수령보증금

2. 리스 관련(C9-(2) 연계):
   금융리스 자산, 운용리스 약정

3. 종업원급여(C13 연계):
   DB채무, 외부적립자산

4. 차입금(C11 연계):
   LINE 그룹 기준 내부/외부 재분류
```

**특이점**: NBP(NAVER Business Platform)는 NAVER 연결에선 내부, LINE 연결에선 외부로 재분류

**도메인 개념**: LINE Group 연결 기준 재분류 + 4개 주석과 Cross-reference

| 항목 | CW 커버 여부 |
|------|-------------|
| 금융상품 분류 | 미커버 |
| 그룹 기준 재분류 | 해당없음 |

---

### [50] L2 (LINE Group 연간 공시)

**목적**: LINE Group 연간 집중리스크 공시 / 작성주기: Y

**컬럼 구조**:
```
집중리스크 — 주요 거래처별 채권 잔액
Clients: Google / Apple / (기타)
Balance of Trade and Other Receivables
```

**도메인 개념**: 거래처 집중도 리스크 (단일 거래처 의존도)

| 항목 | CW 커버 여부 |
|------|-------------|
| 거래처별 채권 | CW 커버 — `Counterparty` + 채권 계정 |
| 집중도 분석 | 미커버 |

---

### [51] L3 (감사보수)

**목적**: PwC 네트워크 감사·비감사 보수 공시

**컬럼 구조**:
```
AFS Number | Service Description | Currency
⑥ PwC Aarata(Audit) | ⑥-2 PCAOB | ⑥-3 SOX
⑦ PwC Network(Audit) | ⑨ PwC Aarata(Non-audit)
```

**도메인 개념**: 감사인 독립성 공시 — 감사보수 vs 비감사보수 구분

| 항목 | CW 커버 여부 |
|------|-------------|
| 감사보수 | 해당없음 (가계부 앱 범위 외) |

---

### [52] L4 (사업 세그먼트 — 일본어)

**목적**: LINE Group 주요 고객 및 세그먼트 매출 / 작성주기: Q

**컬럼 구조**:
```
主要な顧客名(주요 고객명) | 売上金額(매출금액) | 割合%(비율)
[LINE Group / 기타 고객별]
```

**기준**: PL 전체 매출 대비 10% 이상 고객만 공시 (IFRS 8 기준)

**도메인 개념**: IFRS 8 영업 세그먼트 — 주요 고객 집중도

| 항목 | CW 커버 여부 |
|------|-------------|
| 세그먼트 | 미커버 — `Perspective`가 뷰 필터 역할, 세그먼트 P&L 없음 |
| 주요 고객 10% 기준 | 미커버 |

---

## D섹션 — 기타 정보 (3시트)

---

### [53] D (섹션 목차)

**목적**: D섹션 3시트 목차

```
D1 이사회 의사록 / D2 주주총회 의사록 / D3 기타 현안
```

**CW 커버 여부**: 해당없음

---

### [54] D1 (이사회 의사록)

**목적**: 보고기간 중 이사회 의사록 요약

**컬럼 구조**:
```
No. | Date | Agenda | Summary
[반복/일상 안건: No./Date/Agenda만 / 중요 안건: 상세 요약]
```

**중요 안건 기재 항목**: 법인명, 대표이사, 자본금, 투자금액, 발행주식수(액면가/발행가), 납입기일

**도메인 개념**: 지배구조 투명성 — 중요 의사결정 이력

**CW 커버 여부**: 해당없음

---

### [55] D2 (주주총회 의사록)

**목적**: 보고기간 중 주주총회 의사록 요약

**컬럼 구조**: D1과 동일

**중요 안건 예시**: 주식 매매계약(매도자/매수자/주식수/계약금/계약일)

**CW 커버 여부**: 해당없음

---

### [56] D3 (기타 현안)

**목적**: HQ 재무팀과 협의 필요한 기타 현안 자유양식 기록

**컬럼 구조**:
```
No. | Agenda and Summarized Contents
```

**도메인 개념**: 자유양식 이슈 로그 — 패키지 작성 중 발견된 불확실성 기록

**CW 커버 여부**: 해당없음

---

## COA 시트

---

### [57] COA (계정과목표 — 1,918행 데이터 + 1행 헤더)

**목적**: NAVER 그룹 표준 계정과목 전체 정의

**컬럼 구조 (21컬럼 전수 — 엑셀 실측)**:
```
Col01: 계정코드      — 10자리 숫자 (모든 코드 길이 10 고정)
Col02: 계정명         — 영문 (예: "Cash on Hand", "Bank Deposits")
Col03: 상위계정코드   — 10자리 (부모 노드 참조, 최상위는 NULL)
Col04: 상위계정명     — 국문 (예: "자산", "유동자산", "현금")
Col05: 레벨           — 1~6 정수 (계층 깊이)
Col06: 계정구분       — 자산/부채/자본/수익/비용 (한국어)
Col07: 차변/대변      — "차변" 또는 "대변"
Col08: 유효시작일자   — datetime (예: 1999-01-01, 2016-05-01)
Col09: 유효종료일자   — datetime (예: 2999-12-31, 2016-04-30)
Col10: 채권/채무      — "현금" | "채권채무" | "수익비용" | NULL
Col11: 자금과목코드   — 5자리 숫자 (예: 23400) — 자금관리 계정 매핑
Col12: 자금과목명     — 대부분 NULL
Col13: 사용여부       — Y / N (Y=1,917건, N=1건)
Col14: 집계           — Y (510건) / NULL — 집계(상위) 노드 표시
Col15: 잔액           — NULL (전체 미사용)
Col16: 선급금         — Y (7건) / NULL — 선급금 성격 계정 태그
Col17: 공통비배부     — Y (10건) / NULL — 공통비 배부 대상 계정
Col18: 선수금잔액     — NULL (전체 미사용)
Col19: 외환평가       — Y (17건) / NULL — FX 재평가 대상 계정 태그
Col20: 기간인식       — Y (3건) / NULL — 기간귀속 배분 대상
Col21: Vendor         — "미설정"(817) / "선택"(1,099) / "필수"(2)
```

**통계 (엑셀 실측)**:
```
레벨 분포: L1(119) L2(49) L3(188) L4(373) L5(703) L6(486) — 총 1,918건
Nature 분포: 자산(529), 부채(399), 자본(109), 수익(235), 비용(646)
D/C 분포: 차변(1,178), 대변(740)
채권/채무(Col10): 현금(34), 채권채무(274), 수익비용(448), NULL(1,162)
Vendor(Col21): 미설정(817 — 집계/상위 노드), 선택(1,099 — 말단), 필수(2)
외환평가(Col19): 17건 — FX 재평가 대상 (외화예금, 외화채권채무 등)
선급금(Col16): 7건 / 공통비배부(Col17): 10건 / 기간인식(Col20): 3건
```

**코드 체계 (10자리 6계층)**:
```
XXXXXXXXXXXX (10자리 고정)
Level 1: X000000000  — 5대 분류 (자산/부채/자본/수익/비용)
Level 2: XX00000000  — 대분류 (유동/비유동)
Level 3: XXXX000000  — 중분류 (현금성/금융상품/채권 등)
Level 4: XXXXXXX000  — 소분류 (예금 종류)
Level 5: XXXXXXXX00  — 계정 (보통예금/CMA/MMF)
Level 6: XXXXXXXXXX  — 말단 (은행별/상품별 세분)
```

**대분류 11개 구역**:

| 코드 | 명칭 | 차/대 |
|------|------|-------|
| 1000000000 | Assets | 차변 |
| 2000000000 | Liabilities | 대변 |
| 3000000000 | Stockholders' Equity | 대변 |
| 4000000000 | Operating Revenue | 대변 |
| 5000000000 | Operating Expenses | 차변 |
| 6010000000 | Non-operating Income | 대변 |
| 6020000000 | Non-operating Expenses | 차변 |
| 6100000000 | Financial Income | 대변 |
| 6200000000 | Financial Expenses | 차변 |
| 7100000000 | Income Tax Expenses | 차변 |
| 9100000000 | Clearing Accounts | 혼합 |

**유동자산 L3 (1100000000)**:
```
1101000000 Cash and Cash Equivalents
1102000000 Short-term Financial Instruments
1103000000 Financial Assets at Fair Value (FVTPL)
1104000000 Derivatives
1105000000 Trade and Other Receivables
1105080000 Inventories
1106000000 Available for Sales Financial Assets
1107000000 Deferred Income Tax Assets (유동)
1108000000 Other Current Assets
1109000000 Current Portion of Held to Maturity Financial Assets
```

**비유동자산 L3 (1200000000)**:
```
1201000000 Property and Equipment (유형자산)
1202000000 Investment - Real Estate (투자부동산)
1203000000 Intangible Assets (무형자산)
1204000000 Long-term Financial Instruments
1205000000 Non-current AFS Financial Assets
1206000000 Held to Maturity Financial Assets
1207000000 Investments in Affiliates (지분법)
1208000000 Non-current Deferred Income Tax Assets
1209000000 Long-term Trade and Other Receivables
1210000000 Other Non-current Assets
1211000000 Non-current FVTPL Financial Assets
```

**영업비용 L3 (5001000000)** 27개:
```
Salaries / Retirement Benefits / Stock Option / Fringe Benefits / Travel / Entertainment
Bad Debt / Depreciation / Amortization / Communication / Utilities / Taxes&Dues
Rental / Insurance / Freight / Publication / Conference / Supplies / Commissions
Education / Outsourcing / Marketing / Event / Miscellaneous / Extraordinary Loss / Coin Refunds / COGS
```

**특이 설계**:
- `1212000000 Suspense Accounts`: 미결/보류 계정 전용
- `9100000000 Clearing Accounts`: 연결 정리·전표 자동화용 50+ 계정 (APAR/FA/AP/Withholdings/VAT/ShopN 등)
- 유효기간 쌍(`validFrom`/`validTo`): 계정 비활성화 이력 관리 (예: 2016-05-01 신규 계정)
- `채권/채무` 컬럼: 말단 계정에 현금/현금성 여부 태그

| 항목 | CW 커버 여부 |
|------|-------------|
| 계정 계층 구조 | CW 커버 — `DimensionPath` 기반 (문자열) |
| 10자리 숫자 코드 | 미커버 — 현재 숫자 코드 체계 없음 |
| 유효기간 관리(Col08-09) | 미커버 — 현재 `isActive` boolean만, validFrom/validTo 없음 |
| 채권/채무 태그(Col10) | 미커버 — 현금(34)/채권채무(274)/수익비용(448) 3분류 |
| 자금과목코드(Col11) | 미커버 — 자금관리 계정 별도 코드 체계 |
| 집계 플래그(Col14) | CW 커버(부분) — DimensionPath로 암묵적 집계, 명시적 플래그 없음 |
| 선급금/공통비배부/기간인식(Col16,17,20) | 미커버 — 계정 속성 태그 3종 |
| 외환평가 대상(Col19) | 미커버 — FX 재평가 대상 17개 계정 태그 |
| Vendor 필수/선택(Col21) | 미커버 — 거래처 입력 강제 수준 3단계 |
| Clearing 계정군(91xx) | 미커버 — 연결 정리용 50+ 계정 |
| 6레벨 계층 | CW 커버(부분) — `DimensionPath` 다단계 지원 |

---

## 전체 미커버 항목 집계

### MyMoney 흡수 우선순위

| 우선순위 | 항목 | 관련 시트 | 적용 Wave |
|---------|------|---------|---------|
| HIGH | CF 보고서 생성 (7분류, 113개 C코드) | A④CF | S09+ |
| HIGH | 자본변동표(CE) 생성 (5구성요소+OCI 5항목) | A③CE | S09+ |
| HIGH | 이연법인세 자산/부채 | C19-(2) | S08 |
| HIGH | 법인세 실효세율 계산 | C19-(1) | S08 |
| MEDIUM | COA 유효기간(validFrom/validTo) — Col08-09 | COA | S08+ |
| MEDIUM | COA 외환평가 대상 태그 — Col19 (17건) | COA | S08+ |
| MEDIUM | COA Vendor 필수/선택 — Col21 (거래처 입력 강제 3단계) | COA | S08+ |
| MEDIUM | COA 채권/채무 3분류 — Col10 (현금/채권채무/수익비용) | COA | S08+ |
| MEDIUM | 대손충당금 + 연령분석 | C6 | S08 |
| MEDIUM | 충당부채 롤포워드 (15컬럼 변동 추적) | C12 | S08 |
| MEDIUM | 감가상각/무형자산 상각 UseCase (9분류+6분류) | C9-(1), C10 | S09 |
| MEDIUM | 이자율 필드 + 만기 관리 | C11, C3-(4) | S09 |
| MEDIUM | 통화별 순포지션 뷰 (7통화 매트릭스) | C3-(3) | S09 |
| MEDIUM | SAD 조정분개 분리 (A①BS/A②PL Col18) | A①BS, A②PL | S09 |
| LOW | 공정가치 계층 분류 (L1/L2/L3) | C3-(5), C7 | 장기 |
| LOW | 유동성 만기 매트릭스 (1Y/1-5Y/5Y+) | C3-(2) | 장기 |
| LOW | OCI 처리 (AFS/보험수리적) | C7-(1), C13 | 장기 |
| LOW | 금융상품 통합 롤포워드 (14컬럼) | C7-(4) | 장기 |
| LOW | 세그먼트 P&L | L4 | 장기 |
| LOW | 계약부채 (포인트/선불금) | C2 | 장기 |
| 해당없음 | 연결 내부거래 소거 | B섹션 전체 | 해당없음 |
| 해당없음 | 다법인 계층 구조 | Consolidation Scope | 해당없음 |
| 해당없음 | 지배구조 (이사회/주총) | D섹션 전체 | 해당없음 |
| 해당없음 | 감사보수 | L3 | 해당없음 |

---

*58시트 전수 문서화 완료: 관리(4) + A(7) + B(5) + C(30) + L(4) + D(3) + COA(1) = 54개 섹션/독립시트*
*초판 분석일: 2026-04-19 | 분석자: Omar*
*컬럼 전수 대조 보강: 2026-04-20 | 엑셀 실측 기반 21컬럼(COA) + A/B 시트 ��중구조 + C시트 헤더 전수 반영*
