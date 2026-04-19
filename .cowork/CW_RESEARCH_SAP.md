# CW_RESEARCH_SAP.md — SAP S/4HANA 선진 시스템 설계 조사

> 조사자: Omar-3 | 조사일: 2026-04-20
> 목적: SAP S/4HANA 핵심 개념 → MyMoney 가계부 흡수 가능 여부 판정
> 출처: SAP Help Portal, SAP Community, SAP Learning, 기타

---

## 1. SAP COA 구조

### 1.1 3계층 Chart of Accounts

SAP S/4HANA는 계정과목표를 3계층으로 관리한다.

| 계층 | 명칭 | 역할 | 전기 가능 |
|------|------|------|----------|
| **Operating COA** | 운영 계정과목표 | 일상 전기(FI+CO)에 사용. Company Code에 할당. | O (유일) |
| **Group COA** | 그룹 계정과목표 | 연결결산용. 그룹 전체 통일 코드. Operating COA의 각 계정에 Group 계정 매핑. | X (매핑만) |
| **Country COA** | 국가 계정과목표 | 해당 국가 법정 보고 요건 충족. Operating 계정에 대체 번호(alternative account number) 매핑. | X (매핑만) |

**MyMoney 대응**: 현재 단일 COA 구조 (`Account` 테이블). NAVER IFRS COA 분석에서 발견한 "로컬 COA → GCOA → IFRS" 3단계 매핑이 정확히 SAP의 Operating → Group 매핑과 동일 개념.

### 1.2 Account Group (계정 그룹)

SAP에서 계정과목은 **Account Group**으로 분류되며, 각 그룹에 번호 범위(Number Range)가 할당된다.

| Account Group | 번호 범위 예시 | 설명 |
|--------------|--------------|------|
| Assets | 100000-199999 | 자산 계정 |
| Liabilities | 200000-299999 | 부채 계정 |
| Equity | 300000-399999 | 자본 계정 |
| Revenue | 400000-499999 | 수익 계정 |
| Expenses | 500000-699999 | 비용 계정 |
| Secondary Cost Elements | 900000-999999 | 2차 원가요소 (CO 전용) |

**핵심 설계**:
- 번호 범위(Number Range)로 계정 성격(Nature)을 즉시 판별 가능
- 계정 그룹이 화면 레이아웃(입력 필드 제어)도 결정

**MyMoney 대응**: NAVER COA의 10자리 코드(1xxx=자산, 2xxx=부채, 3xxx=자본, 4xxx=수익, 5xxx=비용)가 SAP Account Group 개념과 동일. 현재 `Account.nature` enum으로 대응 중이며, 번호 범위까지는 불필요.

### 1.3 원가요소 (Cost Element) — Primary / Secondary

SAP S/4HANA에서는 FI와 CO가 **Universal Journal (ACDOCA)** 테이블로 통합되어, 모든 전표가 단일 테이블에 기록된다.

| 유형 | 설명 | 예시 |
|------|------|------|
| **Primary Cost Element** | 외부 거래(매출/매입/급여 등) — FI 전표와 1:1 | 급여비용, 임차료, 재료비 |
| **Secondary Cost Element** | 내부 배부(Assessment/Distribution) — CO 전용, 외부 거래 없음 | 간접비 배부, 내부 서비스 배부 |

**핵심 설계**: S/4HANA에서는 2차 원가요소도 G/L 계정으로 생성 (FI-CO 통합). 이전 ECC에서는 별도 마스터였음.

**MyMoney 대응**: 현재 1차 원가요소만 존재 (JEL = 외부 거래 기록). 2차 원가요소(내부 배부)는 가계부에서 "가족 간 비용 배분" 개념으로 변환 가능하나 MVP 범위 외.

---

## 2. SAP CO 모듈 (원가관리)

### 2.1 원가센터 (Cost Center)

**개념**: 비용이 발생하는 조직 단위. 매출을 직접 생성하지 않는 간접 부문.

| 속성 | 설명 |
|------|------|
| 계층 구조 | 표준 계층(Standard Hierarchy) — 트리 구조로 원가센터 집계 |
| 비용 범주 | 인건비/설비비/재료비/외주비 등 |
| 귀속 | 모든 비용 전표에 원가센터 필수 입력 |
| 배부 | 간접비를 원가대상(제품/프로젝트)에 배부 |

**가계부 대응**: "식비/교통비/주거비" 같은 비용 카테고리 = 원가센터의 단순화 버전. 현재 `Account.equityTypePath`(비용 분류)가 이 역할을 수행.

### 2.2 이익센터 (Profit Center)

**개념**: 수익과 비용을 모두 추적하여 내부 손익을 산출하는 단위.

| 속성 | 설명 |
|------|------|
| 수익+비용 | 매출과 비용 모두 귀속 → 내부 P/L 산출 |
| 조직 구조 | 사업부/제품라인/지역 등 임의 기준 |
| B/S 항목 | 자산/부채도 이익센터에 배분 가능 (내부 B/S) |

**가계부 대응**: `Perspective` = 이익센터의 가계부 버전. "남편 투자 포트폴리오" 프리셋 = 이익센터 "투자사업부"와 동일. Perspective가 수익/비용/자산/부채 모두를 필터링할 수 있으므로 이미 이익센터 기능을 포함.

### 2.3 내부주문 (Internal Order)

**개념**: 일시적/프로젝트성 비용을 추적하는 임시 비용 수집기.

| 유형 | 설명 | 예시 |
|------|------|------|
| Overhead Order | 간접비 추적 | 사무실 이전 프로젝트 |
| Investment Order | 자본적 지출 추적 → 자산화 | 건물 신축 |
| Accrual Order | 발생주의 조정 | 연간 보험료 월할 배분 |

**가계부 대응**: `Tags` = Internal Order의 경량 버전. "인테리어 프로젝트" 태그를 붙이면 프로젝트별 비용 추적 가능. 자산화(Investment Order)는 `Account` 생성으로 대응.

### 2.4 원가배부 방식

| 방식 | 설명 | 배부 기준 |
|------|------|---------|
| **Assessment** | 2차 원가요소로 총액 배부 (원래 원가요소 사라짐) | 통계 키 수치 (면적, 인원 등) |
| **Distribution** | 1차 원가요소 유지하며 배부 (원래 계정 보존) | 통계 키 수치 |
| **Activity Allocation** | 활동 수량(시간) 기반 배부 | 활동 유형별 단가 × 수량 |

**가계부 대응**: 공동 비용(월세, 공과금) → 가구 구성원 배분. 현재 `AccountOwnerShares.shareRatio`(지분율 10000 배율)로 소유자별 자동 배분이 가능. Assessment/Distribution 구분은 가계부에서 불필요.

### 2.5 Activity-Based Costing (ABC)

**개념**: 간접비를 활동(Process) 단위로 분해하여 정밀 배부. 전통적 배부(면적/인원 비례)보다 정확.

| 구성요소 | 설명 |
|---------|------|
| Process | 간접 활동 단위 (주문처리, 품질검사 등) |
| Cost Driver | 배부 동인 (주문 건수, 검사 횟수 등) |
| Template | 제품/서비스별 간접비 배부 수식 |
| Statistical Key Figure | 배부 기준 수치 (면적 m2, 인원 수 등) |

**가계부 대응**: 가계부에서 ABC 수준의 원가 배부는 과잉. 다만 "가족 1인당 비용" 같은 간단한 통계 키 수치는 ReportQueryService에서 파생 가능.

---

## 3. SAP MM 모듈 (재고/자재관리)

### 3.1 재고 평가 방법

| 방법 | SAP 코드 | 설명 | 가격 변동 처리 |
|------|---------|------|--------------|
| **이동평균법** | V (Moving Average) | 입고마다 가중평균 재계산 | 재고 가치에 즉시 반영 |
| **표준원가법** | S (Standard Price) | 기간 고정 가격, 차이는 가격차이 계정 | 차이 → PRD(Price Difference) 계정 |

**이동평균 계산**: `이동평균가 = 총 재고가치 / 총 재고수량`

입고 시: 재고가치 += 입고금액, 재고수량 += 입고수량 → 새 이동평균가 산출
출고 시: 이동평균가 × 출고수량 = 출고원가 (COGS)

**가계부 대응**: 가계부에서 재고 관리는 일반적으로 불필요. 다만 "주식 투자 포트폴리오"에서 평균 매입단가 계산은 이동평균법과 동일 개념. 현재 아키텍처에 재고 관련 설계 없음.

### 3.2 자재유형별 계정 자동결정 (Account Determination)

SAP MM에서 자재 이동(입고/출고/이관) 시 G/L 계정이 **자동 결정**된다.

| 결정 요소 | 설명 |
|---------|------|
| Valuation Class | 자재 유형별 평가 분류 (원재료/상품/반제품 등) |
| Transaction Type | 거래 유형 (입고/출고/재고이전 등) |
| Account Grouping | 계정 그룹별 자동 전기 규칙 |

**자동 전기 흐름**: 입고 → 차변: 재고(자산), 대변: GR/IR 정리 계정 → 송장 → 차변: GR/IR 정리, 대변: 매입채무

**가계부 대응**: `ClassificationEngine` (OCR 자동 분류)이 SAP Account Determination의 가계부 버전. 거래 텍스트 → 계정 자동 결정. 다만 SAP은 규칙 기반(Valuation Class × Transaction Type), MyMoney는 패턴 매칭 기반.

### 3.3 GR/IR (Goods Receipt / Invoice Receipt) 자동 전기

SAP의 3-Way Matching:

```
1. 구매주문(PO)      → 수량/가격 기준
2. 입고(GR)          → 차변: 재고, 대변: GR/IR Clearing
3. 송장수취(IR)      → 차변: GR/IR Clearing, 대변: 매입채무(AP)
→ GR/IR Clearing 잔액 = 0 (완전 매칭)
→ 잔액 != 0이면 가격/수량 차이 → 조정 전표
```

**가계부 대응**: 가계부에서 PO→GR→IR 3단계는 불필요. 다만 "카드 결제 → 실제 청구" 2단계는 유사. 현재 `Transaction.status` (Draft→Posted)로 대응. GR/IR Clearing 계정 개념은 `카드미지급금` 계정이 동일 역할.

---

## 4. 가계부 흡수 가능 vs 기업 전용 분류

### 4.1 가계부에 흡수할 만한 SAP 개념 (6개)

| # | SAP 개념 | 가계부 대응 | 흡수 방법 | 우선순위 |
|---|---------|-----------|---------|---------|
| 1 | **Profit Center → 내부 손익** | `Perspective` | 이미 구현. Perspective = 가계부의 이익센터. 수익+비용+자산+부채 필터링으로 내부 P/L+B/S 생성 가능. | 구현 완료 |
| 2 | **Account Group → 번호 범위 자동 분류** | `Account.nature` + `DimensionPath` | 이미 구현. nature(5종)가 Account Group, DimensionPath가 번호 범위 역할. | 구현 완료 |
| 3 | **Universal Journal (ACDOCA) → FI-CO 단일 테이블** | `JournalEntryLines` | 이미 구현. JEL 단일 테이블에 FI(차대변)+CO(activityTypeOverride) 통합. SAP S/4HANA와 동일 철학. | 구현 완료 |
| 4 | **Account Determination → 자동 계정 결정** | `ClassificationEngine` | 이미 구현(패턴 매칭). SAP은 규칙 기반(Valuation Class × Transaction Type). **향후**: ClassificationRule.patternType에 RULE_BASED 추가 시 SAP 수준 달성. | P3 확장 |
| 5 | **이동평균법 → 투자 평균단가** | (미구현) | 주식/펀드 투자 계좌에서 "평균 매입단가" 계산. `Account.countrySpecific` JSON에 `avgCostBasis` 저장하거나 별도 VO. | P3 예약 |
| 6 | **Statistical Key Figure → 가구원 배분 기준** | `AccountOwnerShares.shareRatio` | 이미 구현(지분율 배분). SAP의 통계 키 수치(면적/인원)를 가계부에서는 "소유 비율"로 단순화. | 구현 완료 |

### 4.2 기업 전용으로 스킵할 개념 (8개)

| # | SAP 개념 | 스킵 이유 |
|---|---------|---------|
| 1 | **Group COA / Country COA** | 다법인 연결결산 전용. 단일 가계부에 3계층 COA 불필요. |
| 2 | **Secondary Cost Element** | 내부 배부 전용 원가요소. 가계부에서 간접비 배부 개념 없음. |
| 3 | **Cost Center 계층** | 부서별 비용 추적. 가계부에서는 Account 분류로 충분. |
| 4 | **Internal Order (투자주문)** | 자본적 지출 추적 → 자산화. 가계부에서는 Account 생성으로 대체. |
| 5 | **Assessment vs Distribution 구분** | 2차 원가요소 배부 방식 차이. 가계부에서 내부 배부 없음. |
| 6 | **Activity-Based Costing** | 활동 기반 간접비 배부. 과도한 복잡성. |
| 7 | **GR/IR 3-Way Matching** | 구매주문→입고→송장 3단계. 가계부는 결제 1단계. |
| 8 | **표준원가법 + 가격차이 계정** | 제조업 전용 원가 관리. 가계부에서 제조 없음. |

### 4.3 §15 확장 예약에 넣을 만한 개념 (5개)

| # | SAP 개념 | 예약 이유 | MyMoney 적용 방법 |
|---|---------|---------|-----------------|
| 1 | **Operating COA ↔ External COA 매핑** | 외부 시스템(은행/카드사) 계정 코드와 MyMoney 계정 매핑. OFX/CSV 자동 임포트 시 계정 자동 결정에 활용. | `Account.externalCode: String?` nullable 필드 |
| 2 | **Accrual Order (발생주의 조정)** | 연간 보험료를 12개월로 배분, 선급비용 기간 인식. 현재 COA Col20 "기간인식" 태그(3건)와 연결. | `Account.isPeriodRecognition: bool` + 결산 플러그인 `AccrualPlugin` |
| 3 | **Profit Center B/S** | Perspective에 자산/부채도 귀속시켜 "남편의 순자산" B/S 생성. SAP의 이익센터 B/S와 동일. | 이미 `Perspective.dimensionFilters`로 가능. UseCase 추가만 필요. |
| 4 | **이동평균법 투자 단가** | 주식/펀드 매매 시 이동평균 매입단가 자동 계산. FIFO/LIFO 대비 세무적으로 유리. | `InvestmentLot` 테이블 또는 `Account.countrySpecific.avgCostBasis` |
| 5 | **Rule-Based Account Determination** | SAP의 Valuation Class × Transaction Type → 계정 자동 결정. OCR 후처리에서 규칙 기반 분류 강화. | `ClassificationRule.patternType` = `RULE_BASED` 추가, 조건 매트릭스 |

---

## 5. SAP 설계에서 얻은 아키텍처 인사이트

### 5.1 Universal Journal = 단일 진실의 원천 (Single Source of Truth)

SAP S/4HANA의 가장 큰 혁신은 ACDOCA 테이블 — FI/CO/AA/ML을 단일 테이블로 통합. MyMoney의 `JournalEntryLines` 테이블이 이미 이 철학을 따르고 있음.

**시사점**: JEL 테이블에 추가 필드(activityTypeOverride, ownerIdOverride 등)를 계속 확장하는 것은 SAP의 방향과 일치. 별도 CO 테이블을 만들지 말 것.

### 5.2 계정 그룹 = 화면 제어

SAP에서 Account Group은 단순 분류가 아니라 **화면 레이아웃을 결정**한다. 자산 계정 입력 시 "감가상각 내용연수" 필드가 보이고, 수익 계정 입력 시 안 보이는 식.

**시사점**: `Account.nature`에 따라 JEL 입력 UI의 필드 가시성을 제어하면 사용자 경험 향상. 예: 자산 계정 선택 시 "원래 통화" 필드 표시, 비용 계정 선택 시 "세무 분류" 필드 표시.

### 5.3 3계층 COA = 다목적 보고

Operating/Group/Country 3계층은 "같은 거래를 3가지 관점으로 보고"하는 구조.

**시사점**: MyMoney에서 `Account.externalCode` (은행 코드) + `Account.dimensionPath` (MyMoney 코드) 2계층으로 "은행 분류 vs 내 분류" 이중 뷰 제공 가능. v2.0 합의의 Account.cashFlowCategory도 사실상 "CF 보고서용 대체 분류"로 3번째 뷰.

### 5.4 Profit Center = Perspective

SAP Profit Center와 MyMoney Perspective의 매핑이 거의 완벽. SAP에서 Profit Center가 수익+비용+자산+부채를 모두 집계하듯, Perspective도 dimensionFilters로 전체 재무제표를 필터링.

**시사점**: Perspective를 "가계부의 이익센터"로 공식 포지셔닝. 향후 "Perspective별 B/S" = SAP "Profit Center B/S" 기능 추가 시 차별점.

---

## 6. 요약 — MyMoney 현재 아키텍처 vs SAP

| SAP 개념 | MyMoney v1.0 대응 | MyMoney v2.0 대응 | GAP |
|---------|-------------------|-------------------|-----|
| Universal Journal (ACDOCA) | JournalEntryLines | JEL + adjustmentType/reversalType | **완료** |
| Operating COA | Account + DimensionPath | + validFrom/validTo/cashFlowCategory | **v2.0** |
| Group COA | (없음) | §15 예약: Account.externalCode | **예약** |
| Country COA | (없음) | 불필요 (단일 국가) | **스킵** |
| Account Group | Account.nature (5종) | + vendorRequirement/isFxRevalTarget | **v2.0** |
| Primary Cost Element | Account (REVENUE/EXPENSE) | 변경 없음 | **완료** |
| Secondary Cost Element | (없음) | 불필요 | **스킵** |
| Cost Center | Account.equityTypePath | 변경 없음 | **완료** |
| Profit Center | Perspective | 변경 없음 | **완료** |
| Internal Order | Tags | 변경 없음 | **완료** |
| Assessment/Distribution | AccountOwnerShares | 변경 없음 | **완료** |
| Account Determination | ClassificationEngine | §15 예약: RULE_BASED | **예약** |
| Moving Average | (없음) | §15 예약: InvestmentLot | **예약** |
| GR/IR Clearing | 카드미지급금 계정 | 변경 없음 | **완료** |
| Standard Cost | (없음) | 불필요 | **스킵** |

---

*조사 완료 | Omar-3 | 2026-04-20*

Sources:
- [Chart of Accounts in SAP S/4 HANA](https://www.gauravconsulting.com/post/chart-of-accounts-in-sap-s-4-hana)
- [The chart of accounts: concept & SAP design (R/3 to S/4HANA)](https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-members/the-chart-of-accounts-concept-sap-design-r-3-to-s-4hana/ba-p/13450190)
- [Chart of Accounts: Different Types](https://help.sap.com/docs/SAP_S4HANA_CLOUD/0fa84c9d9c634132b7c4abb9ffdd8f06/32ed3c6435ea46afb4dbab6839fabe8e.html)
- [Understanding the Universal Journal in SAP S/4HANA](https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/understanding-the-universal-journal-in-sap-s-4hana/ba-p/13345726)
- [SAP CO Cost Center Management](https://www.geeksforgeeks.org/sap-co-cost-center-management/)
- [Improving Profitability and Cost Control with SAP CO](https://www.suretysystems.com/insights/improving-profitability-and-cost-control-with-sap-co-functionality/)
- [Moving Average Price vs. Standard Price in SAP](https://blog.sap-press.com/what-is-the-difference-between-moving-average-price-and-standard-price-in-sap)
- [SAP MM Account Determination](https://www.tutorialspoint.com/sap_mm/sap_mm_account_determination.htm)
- [Activity Based Costing (CO-OM-ABC)](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE/5e23dc8fe9be4fd496f8ab556667ea05/83b8bb536b13b44ce10000000a174cb4.html)
- [Mastering ACDOCA: Universal Journal Insights](https://sapinsider.org/articles/mastering-acdoca-7-essential-universal-journal-insights-for-sap-s-4hana-consultants-2025-edition/)
