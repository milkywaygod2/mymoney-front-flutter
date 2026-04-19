# K-IFRS 표준 계정과목 전수 + 원가관리/재고자산 보강 리서치

> 조사자: Grace-3
> 일자: 2026-04-20
> 근거: K-IFRS 1001호(재무제표 표시), 1002호(재고자산), 법인세법 시행규칙 별지 제3호의2(표준재무상태표), XBRL 표준계정과목체계
> 목적: CW_ARCHITECTURE.md §12 대비 빠진 계정 경로 식별

---

## 1. K-IFRS 재무상태표 (B/S) 표준 계정과목

### 1.1 유동자산

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| 현금및현금성자산 | 유동(현금성) | **있음** |
| 단기금융상품 | 유동(단기금융) | **있음** |
| 당기손익-공정가치측정금융자산(유동) | 미기재 | **빠짐** → ASSET.CURRENT.FVTPL |
| 기타포괄손익-공정가치측정금융자산(유동) | 미기재 | **빠짐** → ASSET.CURRENT.FVOCI |
| 상각후원가측정금융자산(유동) | 미기재 | **빠짐** → ASSET.CURRENT.AMORTIZED_COST |
| 파생금융자산(유동) | 미기재 | **빠짐** → ASSET.CURRENT.DERIVATIVE |
| 매출채권및기타채권 | 유동(매출채권) | **있음** |
| 대손충당금 | 미기재 | **빠짐** → ASSET.CURRENT.TRADE_RECEIVABLE.ALLOWANCE |
| 계약자산 | 미기재 | **빠짐** → ASSET.CURRENT.CONTRACT_ASSET (IFRS 15) |
| **재고자산** | 유동(재고) — **세부 없음** | **세부 빠짐** (아래 §2 참조) |
| 당기법인세자산 | 미기재 | **빠짐** → ASSET.CURRENT.INCOME_TAX |
| 기타유동자산 (선급금/선급비용) | 유동(선급) | **있음** |
| 매각예정자산 | 미기재 | **빠짐** → ASSET.HELD_FOR_SALE (v2.0 P3 예약) |

### 1.2 비유동자산

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| 유형자산 | 비유동(유형) | **있음** |
| 투자부동산 | 미기재 | **빠짐** → ASSET.NON_CURRENT.INVESTMENT_PROPERTY |
| 무형자산 | 비유동(무형) | **있음** |
| 영업권 | 미기재(무형 하위) | **빠짐** → ASSET.NON_CURRENT.INTANGIBLE.GOODWILL |
| 관계기업투자 (지분법) | 비유동(투자) | **있음 (암묵적)** |
| 장기금융상품 | 미기재 | **빠짐** → ASSET.NON_CURRENT.FINANCIAL_INSTRUMENTS |
| 당기손익-공정가치측정금융자산(비유동) | 미기재 | **빠짐** → ASSET.NON_CURRENT.FVTPL |
| 기타포괄손익-공정가치측정금융자산(비유동) | 미기재 | **빠짐** → ASSET.NON_CURRENT.FVOCI |
| 상각후원가측정금융자산(비유동) | 미기재 | **빠짐** → ASSET.NON_CURRENT.AMORTIZED_COST |
| 이연법인세자산 | 미기재 | **빠짐** → ASSET.NON_CURRENT.DEFERRED_TAX (P4) |
| 장기매출채권및기타채권 | 미기재 | **빠짐** → ASSET.NON_CURRENT.LONG_TERM_RECEIVABLE |
| 기타비유동자산 | 비유동(기타) | **있음** |
| 사용권자산 (IFRS 16) | 미기재 | **빠짐** → ASSET.NON_CURRENT.RIGHT_OF_USE |

### 1.3 유동부채

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| 매입채무및기타채무 | 유동(미지급) | **있음** |
| 단기차입금 | 유동(단기차입) | **있음** |
| 유동성장기부채 | 미기재 | **빠짐** → LIABILITY.CURRENT.CURRENT_PORTION_LTD |
| 계약부채 | 미기재 | **빠짐** → LIABILITY.CURRENT.CONTRACT_LIABILITY (IFRS 15) |
| 충당부채(유동) | 미기재 | **빠짐** → LIABILITY.CURRENT.PROVISIONS |
| 당기법인세부채 | 미기재 | **빠짐** → LIABILITY.CURRENT.INCOME_TAX |
| 리스부채(유동) | 미기재 | **빠짐** → LIABILITY.CURRENT.LEASE (IFRS 16) |
| 파생금융부채(유동) | 미기재 | **빠짐** → LIABILITY.CURRENT.DERIVATIVE |
| 기타유동부채 (선수금/예수금) | 유동(예수/선수) | **있음** |
| 매각예정부채 | 미기재 | **빠짐** → LIABILITY.HELD_FOR_SALE (P3 예약) |

### 1.4 비유동부채

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| 장기차입금 | 비유동(장기차입) | **있음** |
| 사채 | 미기재 | **빠짐** → LIABILITY.NON_CURRENT.BONDS |
| 퇴직급여부채 (확정급여형) | 미기재 | **빠짐** → LIABILITY.NON_CURRENT.DEFINED_BENEFIT |
| 충당부채(비유동) | 미기재 | **빠짐** → LIABILITY.NON_CURRENT.PROVISIONS |
| 이연법인세부채 | 미기재 | **빠짐** → LIABILITY.NON_CURRENT.DEFERRED_TAX (P4) |
| 리스부채(비유동) | 미기재 | **빠짐** → LIABILITY.NON_CURRENT.LEASE (IFRS 16) |
| 파생금융부채(비유동) | 미기재 | **빠짐** → LIABILITY.NON_CURRENT.DERIVATIVE |
| 기타비유동부채 | 비유동(기타) | **있음** |

### 1.5 자본

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| 자본금 | 자본금 | **있음** |
| 자본잉여금 (주식발행초과금 등) | 미기재(자본금에 통합) | **세부 빠짐** |
| 기타자본구성요소 (자기주식 등) | 기타자본 | **있음 (포괄)** |
| 기타포괄손익누계액 | 미기재 | **빠짐** → v2.0 P1 OCI 5종 |
| 이익잉여금 | 이익잉여금 | **있음** |
| 비지배지분 | 미기재 | **빠짐** → EQUITY.MINORITY_INTEREST |

---

## 2. 재고자산 세부 계정 (현재 §12에 약한 부분)

### 2.1 K-IFRS 1002호 재고자산 분류

현재 §12: `유동(재고)` — 세부 분류 없음.

K-IFRS 및 법인세법 표준계정과목에 따른 재고자산 세부:

```
ASSET.CURRENT.INVENTORY (재고자산)
├── ASSET.CURRENT.INVENTORY.MERCHANDISE         -- 상품 (외부 매입 → 그대로 판매)
├── ASSET.CURRENT.INVENTORY.FINISHED_GOODS      -- 제품 (자체 제조 완성품)
├── ASSET.CURRENT.INVENTORY.SEMI_FINISHED       -- 반제품 (중간 완성품, 외부 판매 가능)
├── ASSET.CURRENT.INVENTORY.WORK_IN_PROGRESS    -- 재공품 (제조 진행 중)
├── ASSET.CURRENT.INVENTORY.RAW_MATERIALS       -- 원재료 (제조 투입 전 기본 재료)
├── ASSET.CURRENT.INVENTORY.SUPPLIES            -- 저장품 (소모품/포장재/수선용 부품 등)
├── ASSET.CURRENT.INVENTORY.IN_TRANSIT          -- 미착품 (운송 중 아직 도착하지 않은 상품)
└── ASSET.CURRENT.INVENTORY.VALUATION_ALLOWANCE -- 재고자산평가충당금 (저가법 적용 차액)
```

### 2.2 재고자산 흐름 (매출원가 산출)

```
[매출원가 산출 공식]
  기초재고자산 (기초상품 + 기초제품)
+ 당기매입액 (상품매입) 또는 당기제품제조원가
- 기말재고자산 (기말상품 + 기말제품)
- 타계정대체 (자가소비, 광고선전용 등)
= 매출원가 (Cost of Goods Sold)
```

### 2.3 재고평가방법 (K-IFRS 1002호 §25)

| 방법 | 설명 | K-IFRS 허용 |
|------|------|------------|
| 개별법 | 개별 단가 추적 | 허용 (고가 단품) |
| 선입선출법 (FIFO) | 먼저 매입 → 먼저 출고 | 허용 |
| 가중평균법 | 총액 / 총수량 | 허용 |
| 이동평균법 | 매입 시마다 평균 갱신 | 허용 (가중평균의 변형) |
| 후입선출법 (LIFO) | 나중 매입 → 먼저 출고 | **불허** (K-IFRS 1002호 §25) |
| 표준원가법 | 사전 결정 표준 단가 | 허용 (실제원가와 근사 시) |
| 소매재고법 | 소매가 × 원가율 | 허용 (유통업) |

### 2.4 재고자산 감액 (저가법)

```
장부금액 vs 순실현가능가치(NRV) 중 낮은 금액으로 평가
NRV = 추정 판매가격 - 추정 완성원가 - 추정 판매비용

감액분 → 매출원가에 가산 (재고자산평가손실)
환입분 → 매출원가에서 차감 (재고자산평가손실환입) — 당초 감액 한도 내
```

---

## 3. 원가관리 계정 구조 (제조원가)

### 3.1 제조원가명세서 계정과목

현재 §12에는 비용 분류에 "영업(급여/복리후생/접대/여비)" + "생활(식비/교통 등)"만 있고, **제조원가 관련 계정이 전혀 없음**.

```
EXPENSE.MANUFACTURING (제조원가)                      ← §12에 완전 부재
├── EXPENSE.MANUFACTURING.DIRECT_MATERIALS            -- 직접재료비
│   ├── .RAW_MATERIALS_USED                           -- 원재료 사용액
│   ├── .PURCHASED_PARTS                              -- 매입부품비
│   └── .SUBCONTRACTING                               -- 외주가공비
├── EXPENSE.MANUFACTURING.DIRECT_LABOR                -- 직접노무비
│   ├── .WAGES                                        -- 임금
│   ├── .ALLOWANCES                                   -- 제수당
│   └── .BONUS                                        -- 상여금
├── EXPENSE.MANUFACTURING.OVERHEAD                    -- 제조경비 (간접비)
│   ├── .INDIRECT_MATERIALS                           -- 간접재료비
│   ├── .INDIRECT_LABOR                               -- 간접노무비
│   ├── .DEPRECIATION_FACTORY                         -- 감가상각비(공장)
│   ├── .RENT_FACTORY                                 -- 임차료(공장)
│   ├── .UTILITIES_FACTORY                            -- 수도광열비(공장)
│   ├── .INSURANCE_FACTORY                            -- 보험료(공장)
│   ├── .REPAIR_MAINTENANCE                           -- 수선비
│   ├── .FACTORY_SUPPLIES                             -- 소모품비(공장)
│   └── .OTHER_OVERHEAD                               -- 기타 제조경비
└── EXPENSE.MANUFACTURING.TOTAL                       -- 당기 총 제조비용

[제조원가 산출 공식]
  기초재공품
+ 당기 총 제조비용 (직접재료비 + 직접노무비 + 제조경비)
- 기말재공품
= 당기제품제조원가
```

### 3.2 직접비/간접비 구분

| 구분 | 직접비 | 간접비 |
|------|--------|--------|
| 재료비 | 원재료비, 매입부품비 | 간접재료비, 소모품비(공장) |
| 노무비 | 생산직 임금, 상여금 | 간접노무비 (공장관리자, 수위) |
| 경비 | 외주가공비 | 감가상각비, 임차료, 수도광열비, 보험료 등 |

### 3.3 원가배부 (Cost Allocation)

```
간접비 배부 = 간접비 총액 × (배부 기준량 / 배부 기준 총량)

배부 기준:
- 직접노무시간 (가장 전통적)
- 기계가동시간
- 직접재료비 비율
- 활동기준원가(ABC): 활동별 원가동인 사용

현행 CW_ARCH 대응:
- DimensionValues.ACTIVITY_TYPE이 활동 구분을 일부 지원
- JEL.activityTypeOverride로 JEL별 활동 귀속 가능
- 그러나 원가배부 자동화 UseCase는 없음
```

---

## 4. 포괄손익계산서 (P/L) 표준 계정과목

### 4.1 영업수익

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| 매출액 (상품매출/제품매출/용역매출) | 영업(매출) | **있음 (통합)** |
| 매출원가 | 미기재 | **빠짐** → EXPENSE.COGS (아래 상세) |
| 매출총이익 | 미기재 (계산 필드) | **빠짐** (매출 - 매출원가) |

### 4.2 매출원가 (COGS) 세부 — §12에 완전 부재

```
EXPENSE.COGS (매출원가)                               ← §12에 완전 부재
├── EXPENSE.COGS.MERCHANDISE                          -- 상품매출원가
│   ├── .BEGINNING_INVENTORY                          -- 기초상품재고
│   ├── .PURCHASES                                    -- 당기상품매입액
│   ├── .PURCHASE_RETURNS                             -- 매입환출/에누리 (차감)
│   ├── .ENDING_INVENTORY                             -- 기말상품재고 (차감)
│   └── .INVENTORY_VALUATION_LOSS                     -- 재고자산평가손실
├── EXPENSE.COGS.MANUFACTURED                         -- 제품매출원가
│   ├── .BEGINNING_INVENTORY                          -- 기초제품재고
│   ├── .MANUFACTURING_COST                           -- 당기제품제조원가 (§3.1 참조)
│   ├── .ENDING_INVENTORY                             -- 기말제품재고 (차감)
│   └── .INVENTORY_VALUATION_LOSS                     -- 재고자산평가손실
└── EXPENSE.COGS.SERVICE                              -- 용역매출원가
    ├── .LABOR                                        -- 용역 인건비
    └── .OTHER                                        -- 용역 기타원가
```

### 4.3 판매비와관리비 (SGA)

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| 급여 | 영업(급여) | **있음** |
| 퇴직급여 | 미기재 | **빠짐** → EXPENSE.SGA.RETIREMENT_BENEFITS |
| 복리후생비 | 영업(복리후생) | **있음** |
| 접대비 | 영업(접대) | **있음** |
| 감가상각비 | 감가상각 | **있음** |
| 무형자산상각비 | 미기재 | **빠짐** → EXPENSE.SGA.AMORTIZATION |
| 대손상각비 | 미기재 | **빠짐** → EXPENSE.SGA.BAD_DEBT |
| 광고선전비 | 미기재 | **빠짐** → EXPENSE.SGA.ADVERTISING |
| 연구개발비 | 미기재 | **빠짐** → EXPENSE.SGA.RND |
| 경상연구개발비 | 미기재 | **빠짐** → EXPENSE.SGA.RND_EXPENSED |
| 여비교통비 | 영업(여비) | **있음** |
| 통신비 | 생활(통신) | **있음** |
| 수도광열비 | 생활(주거)에 통합 | **세부 빠짐** |
| 세금과공과 | 세금 | **있음** |
| 지급임차료 | 미기재 | **빠짐** → EXPENSE.SGA.RENT |
| 보험료 | 미기재 | **빠짐** → EXPENSE.SGA.INSURANCE |
| 수선비 | 미기재 | **빠짐** → EXPENSE.SGA.REPAIR |
| 운반비 | 미기재 | **빠짐** → EXPENSE.SGA.FREIGHT |
| 지급수수료 | 미기재 | **빠짐** → EXPENSE.SGA.COMMISSION |
| 외주용역비 | 미기재 | **빠짐** → EXPENSE.SGA.OUTSOURCING |

### 4.4 금융손익

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| 이자수익 | 금융(이자) | **있음** |
| 이자비용 | 금융(이자) | **있음** |
| 배당금수익 | 금융(배당) | **있음** |
| 외환차익/외환차손 | 금융(외환차익/차손) | **있음** |
| 외화환산이익/손실 | 미기재(외환 통합) | **빠짐** → REVENUE/EXPENSE.FINANCIAL.FX_TRANSLATION |
| 당기손익-공정가치측정금융자산 평가이익/손실 | 미기재 | **빠짐** → REVENUE/EXPENSE.FINANCIAL.FVTPL |
| 파생상품 평가이익/손실 | 미기재 | **빠짐** → REVENUE/EXPENSE.FINANCIAL.DERIVATIVE |
| 금융보증수수료수익 | 미기재 | **빠짐** (P4) |

### 4.5 기타손익

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| 유형자산처분이익/손실 | 투자(처분이익) | **있음** |
| 무형자산처분이익/손실 | 미기재 | **빠짐** |
| 투자부동산처분이익/손실 | 미기재 | **빠짐** |
| 기부금 | 기타 | **있음 (암묵적)** |
| 유형자산손상차손/환입 | 미기재 | **빠짐** → EXPENSE.IMPAIRMENT.PPE |
| 무형자산손상차손/환입 | 미기재 | **빠짐** → EXPENSE.IMPAIRMENT.INTANGIBLE |
| 잡이익/잡손실 | 기타 | **있음 (암묵적)** |

### 4.6 기타포괄손익 (OCI) — v2.0 P1 합의됨

| 계정과목 | CW_ARCH §12 | 상태 |
|---------|------------|------|
| FVOCI 평가손익 | 미기재 | **빠짐** → v2.0 P1 |
| 해외사업환산손익 | 미기재 | **빠짐** → v2.0 P1 |
| 지분법자본변동 | 미기재 | **빠짐** → v2.0 P1 |
| 보험수리적손익 | 미기재 | **빠짐** → v2.0 P1 |
| 현금흐름위험회피손익 | 미기재 | **빠짐** → v2.0 P1 |

---

## 5. 현재 §12 대비 빠진 계정 경로 목록 (전수)

### 5.1 즉시 필요 (가계부 MVP)

**재고자산 세부** (8경로):
```
ASSET.CURRENT.INVENTORY.MERCHANDISE           -- 상품
ASSET.CURRENT.INVENTORY.FINISHED_GOODS        -- 제품
ASSET.CURRENT.INVENTORY.SEMI_FINISHED         -- 반제품
ASSET.CURRENT.INVENTORY.WORK_IN_PROGRESS      -- 재공품
ASSET.CURRENT.INVENTORY.RAW_MATERIALS         -- 원재료
ASSET.CURRENT.INVENTORY.SUPPLIES              -- 저장품
ASSET.CURRENT.INVENTORY.IN_TRANSIT            -- 미착품
ASSET.CURRENT.INVENTORY.VALUATION_ALLOWANCE   -- 재고자산평가충당금
```

**매출원가** (10경로):
```
EXPENSE.COGS                                  -- 매출원가 (합계)
EXPENSE.COGS.MERCHANDISE                      -- 상품매출원가
EXPENSE.COGS.MERCHANDISE.BEGINNING            -- 기초상품재고
EXPENSE.COGS.MERCHANDISE.PURCHASES            -- 당기상품매입
EXPENSE.COGS.MERCHANDISE.ENDING               -- 기말상품재고 (차감)
EXPENSE.COGS.MANUFACTURED                     -- 제품매출원가
EXPENSE.COGS.MANUFACTURED.BEGINNING           -- 기초제품재고
EXPENSE.COGS.MANUFACTURED.MANUFACTURING_COST  -- 당기제품제조원가
EXPENSE.COGS.MANUFACTURED.ENDING              -- 기말제품재고 (차감)
EXPENSE.COGS.SERVICE                          -- 용역매출원가
```

**판관비 세부 누락분** (10경로):
```
EXPENSE.SGA.RETIREMENT_BENEFITS               -- 퇴직급여
EXPENSE.SGA.AMORTIZATION                      -- 무형자산상각비
EXPENSE.SGA.BAD_DEBT                          -- 대손상각비
EXPENSE.SGA.ADVERTISING                       -- 광고선전비
EXPENSE.SGA.RENT                              -- 지급임차료
EXPENSE.SGA.INSURANCE                         -- 보험료
EXPENSE.SGA.REPAIR                            -- 수선비
EXPENSE.SGA.FREIGHT                           -- 운반비
EXPENSE.SGA.COMMISSION                        -- 지급수수료
EXPENSE.SGA.OUTSOURCING                       -- 외주용역비
```

**금융자산/부채 IFRS 9 3분류** (6경로):
```
ASSET.CURRENT.FVTPL                           -- 유동 FVTPL
ASSET.CURRENT.FVOCI                           -- 유동 FVOCI
ASSET.CURRENT.AMORTIZED_COST                  -- 유동 상각후원가
ASSET.NON_CURRENT.FVTPL                       -- 비유동 FVTPL
ASSET.NON_CURRENT.FVOCI                       -- 비유동 FVOCI
ASSET.NON_CURRENT.AMORTIZED_COST              -- 비유동 상각후원가
```

**기타 즉시 필요** (8경로):
```
ASSET.CURRENT.DERIVATIVE                      -- 파생금융자산(유동)
ASSET.CURRENT.CONTRACT_ASSET                  -- 계약자산 (IFRS 15)
ASSET.CURRENT.INCOME_TAX                      -- 당기법인세자산
ASSET.NON_CURRENT.INVESTMENT_PROPERTY         -- 투자부동산
ASSET.NON_CURRENT.RIGHT_OF_USE                -- 사용권자산 (IFRS 16)
LIABILITY.CURRENT.CONTRACT_LIABILITY          -- 계약부채 (IFRS 15)
LIABILITY.CURRENT.INCOME_TAX                  -- 당기법인세부채
LIABILITY.CURRENT.CURRENT_PORTION_LTD         -- 유동성장기부채
```

### 5.2 중기 필요 (원가관리 확장)

**제조원가** (13경로):
```
EXPENSE.MANUFACTURING                         -- 제조원가 (합계)
EXPENSE.MANUFACTURING.DIRECT_MATERIALS        -- 직접재료비
EXPENSE.MANUFACTURING.DIRECT_MATERIALS.RAW    -- 원재료 사용액
EXPENSE.MANUFACTURING.DIRECT_MATERIALS.PARTS  -- 매입부품비
EXPENSE.MANUFACTURING.DIRECT_MATERIALS.SUB    -- 외주가공비
EXPENSE.MANUFACTURING.DIRECT_LABOR            -- 직접노무비
EXPENSE.MANUFACTURING.DIRECT_LABOR.WAGES      -- 임금
EXPENSE.MANUFACTURING.DIRECT_LABOR.ALLOWANCES -- 제수당
EXPENSE.MANUFACTURING.OVERHEAD                -- 제조경비 (간접비)
EXPENSE.MANUFACTURING.OVERHEAD.INDIRECT_MAT   -- 간접재료비
EXPENSE.MANUFACTURING.OVERHEAD.INDIRECT_LABOR -- 간접노무비
EXPENSE.MANUFACTURING.OVERHEAD.DEPRECIATION   -- 감가상각비(공장)
EXPENSE.MANUFACTURING.OVERHEAD.OTHER          -- 기타 제조경비
```

### 5.3 장기 예약

```
ASSET.NON_CURRENT.DEFERRED_TAX                -- 이연법인세자산 (P4)
ASSET.NON_CURRENT.LONG_TERM_RECEIVABLE        -- 장기매출채권
LIABILITY.NON_CURRENT.BONDS                   -- 사채
LIABILITY.NON_CURRENT.DEFINED_BENEFIT         -- 퇴직급여부채(DB형)
LIABILITY.NON_CURRENT.DEFERRED_TAX            -- 이연법인세부채 (P4)
LIABILITY.NON_CURRENT.LEASE                   -- 리스부채(비유동, IFRS 16)
LIABILITY.CURRENT.LEASE                       -- 리스부채(유동, IFRS 16)
EXPENSE.SGA.RND                               -- 연구개발비
```

---

## 6. 요약: §12 보강 필요 항목 수

| 범주 | 빠진 경로 수 | 우선순위 |
|------|------------|---------|
| 재고자산 세부 | 8 | **즉시 (MVP)** |
| 매출원가(COGS) | 10 | **즉시 (MVP)** |
| 판관비 세부 누락 | 10 | **즉시** |
| IFRS 9 금융자산 3분류 | 6 | **즉시** |
| 기타 B/S 계정 | 8 | **즉시** |
| OCI 5종 | 5 | **v2.0 P1 합의** |
| 제조원가 | 13 | **중기** |
| 장기 예약 | 8 | **장기** |
| **합계** | **68** | |

---

## 참고 출처

- [K-IFRS 표준계정과목체계 (XBRL 코리아)](http://xbrl.or.kr/?kboard_content_redirect=17)
- [법인세법 시행규칙 별지 제3호의2 표준재무상태표](https://www.law.go.kr/LSW/flDownload.do?gubun=&flSeq=160257531&bylClsCd=110202)
- [삼일아이닷컴 K-IFRS 기준서](https://www.samili.com/acc/IfrsKijun.asp?bCode=1978-1001)
- [K-IFRS 1002호 재고자산](https://www.samili.com/acc/IfrsKijun.asp?bCode=1978-1002)
- [재고자산 계정과목 실무 해설](https://m.cafe.daum.net/bspl/F4S/27)
- [K-IFRS 재무제표 표시 가이드](https://growme.kr/333)
- [금융감독원 XBRL 자료실](https://acct.fss.or.kr/fss/acc/bbs/view.jsp?url=/fss/ac/1277791244405&bbsid=1277791244405)
