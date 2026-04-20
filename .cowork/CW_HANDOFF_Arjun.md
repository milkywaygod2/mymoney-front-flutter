# CW_HANDOFF_Arjun.md

> 마지막 갱신: 2026-04-20 (Arjun-3 Opus)
> 에이전트: Arjun-3 (사원급 말단, Opus)
> 담당: Counterparty + OCR + Classification + Tax
> 브랜치: `agent-automation` (wk-w7-arjun은 이미 머지 완료)

---

## 이력

| 에이전트 | 모델 | 기간 | 주요 산출물 |
|---------|------|------|-----------|
| Arjun-1 | Sonnet | ~2026-04-19 | W7 Counterparty CRUD, W8 TaxRuleEngine |
| Arjun-2 | Sonnet | 2026-04-19 | QA Loop 6회, CW_ANALYSIS_Arjun.md 초판 |
| Arjun-3 | Opus | 2026-04-20 | 엑셀 전수 대조, v2.0 TF, 아키텍처 집필, COA GAP, 플랜 보강 |

---

## 완료 작업 — 코드 구현 (v1.0)

### W7 — S07 Counterparty data 레이어

**커밋**: `b2d293e` → `07cafd4` (agent-automation 머지)

| 파일 | 라인 수 | 내용 |
|------|---------|------|
| `lib/features/counterparty/data/CounterpartyDao.dart` | ~140 | Drift DAO — CRUD + alias + 검색 |
| `lib/features/counterparty/data/CounterpartyDao.g.dart` | ~210 | build_runner 자동 생성 |
| `lib/features/counterparty/data/CounterpartyRepository.dart` | ~120 | ICounterpartyRepository 구현체 |
| `lib/features/counterparty/data/CounterpartyMatcher.dart` | ~60 | ICounterpartyMatcher 구현체 |

### W8 — S08a 세무조정 규칙엔진

**커밋**: `3472273`

| 파일 | 내용 |
|------|------|
| `lib/features/tax/data/TaxRuleEngine.dart` | 11개 자동 판정 규칙 |
| `lib/features/tax/usecase/AutoClassifyDeductibility.dart` | 자동 deductibility 분류 |
| `lib/features/tax/usecase/ClassifyIncomeType.dart` | 소득 8종 자동 분류 |
| `lib/features/tax/presentation/TaxBloc.dart` | TaxBloc (4개 이벤트) |
| `lib/features/tax/presentation/TaxEvent.dart` | freezed v3 이벤트 |
| `lib/features/tax/presentation/TaxState.dart` | freezed v3 상태 |
| `lib/features/tax/presentation/TaxAdjustmentPage.dart` | 세무조정 3단계 UI |

---

## 완료 작업 — 이번 세션 (v2.0 아키텍처 TF)

### 1. 엑셀 11시트 컬럼 전수 대조

- 특수관계자 주석패키지 11시트 openpyxl Read → CW_ANALYSIS_Arjun.md 보강
- 주요 정정: 시트1(4섹션 구조), 시트4(47→46열), 시트7(22→21열), 시트8(18→14열), 시트9(10→9열)
- 누락 컬럼 10+ 발견 및 추가
- GAP 14건 식별 (A:3, B:5, C:6)

### 2. 아키텍처 v2.0 반영안 + TF 난상토론

- `CW_ARCH_PROPOSAL_Arjun.md` 작성 (반영안 + 교차 리뷰)
- TF 3라운드 참여: 4개 쟁점(OCI/비율/세그먼트/CF) 만장일치 합의
- 보정 3건 동의: CF 113코드, 매각예정 P3, entityType 일반화

### 3. CW_ARCHITECTURE.md v2.0 집필 (담당 섹션)

| 섹션 | 수정 내용 |
|------|-----------|
| §2.1 Transaction | INV-T8/T9 (reversalType 불변조건) |
| §2.2 Account | INV-A6 (isRevenueDeduction→EXPENSE), INV-A7 (isFxRevalTarget) |
| §2.4 Counterparty | INV-C4 + RelatedPartyType(5값)/EntityType(6값) enum |
| §2.5 Repository | ICounterpartyRepository +2 메서드 |
| §4.1 Drift | Counterparties +2컬럼, Transactions +2컬럼+source확장, Accounts +2컬럼 |
| §4.2 인덱스 | +4건 (relatedPartyType, referenceNo, isFxRevalTarget, reversalType) |
| §6.1 TaxRuleEngine | 대손충당금 규칙 추가 + 미판정 목록 수정 |
| §15 확장 예약 | +7건 + 환율 이중성 "구현 완료" 표시 |

### 4. COA GAP 분석 리서치

- `CW_RESEARCH_COA_GAP.md` 작성
- §12.1 현재 L2 ~30개 vs K-IFRS 필수 L3+ ~87개 + 가계부 전용 ~20개 = 총 107개 GAP
- 우선순위: P1 36경로 / P2 30경로 / P3 25경로 / P4 10경로

### 5. CW_PLAN.md 보강

- K-IFRS/SAP 참조 매핑 테이블 추가 (13행)
- CW_SUBJECTS.md 참조 제거 (16행 삭제, DoD 6건 교체, 대비 변경점 섹션 삭제)

---

## 핵심 설계 결정 (HANDOVER에서 병합)

### Counterparty Matcher 신뢰도 체계
```
1순위: 정확 일치 (alias DB) → confidence = 1.0
2순위: 부분 일치 (LIKE '%text%') → confidence = 0.7
3순위: 매칭 없음 → null 반환
```

### TaxRuleEngine 규칙 우선순위
```
손금불산입(nonDeductible) 판정 우선
→ 한도초과(deductibleLimited) 판정
→ 손금산입(deductible) 판정
→ 미판정(undetermined) fallback
```

### v2.0 추가 — RelatedPartyType 5단계
```dart
enum RelatedPartyType { parent, subsidiary, associate, affiliate, otherRelated }
```
- DB 저장: `.name` (camelCase)
- INV-C4: relatedPartyType != null → isRelatedParty = true (자동 동기)

### v2.0 추가 — 대손충당금 자동 판정
- LegalParameter key: `대손충당금_설정율_한도`
- paramType: TABLE, table: `{"일반채권":0.01,"금융기관채권":0.02}`
- §6.1 "자동 판정 불가" 목록에서 대손충당금 제거

---

## Gotcha / 주의사항 (HANDOVER에서 병합)

1. **enum 저장 포맷 혼용 절대 금지**: TransactionSource/Deductibility는 camelCase. TransactionStatus/SyncStatus/EntryType은 UPPERCASE.
2. **freezed v3**: abstract class + factory constructor. v2 @freezed annotation 방식 금지.
3. **DI 등록 순서**: DAOs → Repos → Infrastructure → UseCases → BLoCs → _connectBlocStreams()
4. **build_runner 필수**: Drift DAO 수정 시 반드시 `dart run build_runner build --delete-conflicting-outputs`
5. **BLoC Stream 5경로**: PerspectiveBloc→Journal/Report/Tax, JournalBloc→Tax/Report. 단일 stream.listen에서 3개 BLoC에 add.
6. **v2.0 신규 컬럼 추가 시**: 기존 isActive boolean 유지하면서 validFrom/validTo 추가 예정 (Omar 담당). Account 테이블 충돌 주의.

---

## 발견한 버그/이슈 이력 (HANDOVER에서 병합)

| 이슈 | 증상 | 해결 | 파일 |
|------|------|------|------|
| TransactionSource UPPERCASE 불일치 | DB 저장/읽기 예외 | Grace FIX `5c3abd4` — camelCase 통일 | TransactionRepository.dart:78,149 |
| SettlementPage BlocProvider crash | context.read 실패 | `e1a08f8` — getIt 교체 | SettlementPage.dart |
| AccountNature SQL 불일치 | UPPERCASE vs lowercase | `0713d18` — SQL UPPERCASE 통일 | ReportQueryService.dart |
| PerspectiveBloc 3중 subscription | 동일 이벤트 3번 dispatch | `5457d3e` — 단일 listen | Injection.dart:257-265 |
| BLoC 경로4 전체 재판정 | 성능 저하 | `d3794b9` — setPrevPostedIds diff | Injection.dart:271-288 |

---

## 산출 파일 전체 목록

| 파일 | 용도 |
|------|------|
| `.cowork/CW_ANALYSIS_Arjun.md` | 특수관계자 11시트 전수 분석 (보강 완료) |
| `.cowork/CW_ARCH_PROPOSAL_Arjun.md` | 아키텍처 v2.0 반영안 + 교차 리뷰 |
| `.cowork/CW_RESEARCH_COA_GAP.md` | §12 계정과목 vs K-IFRS GAP 분석 |
| `.cowork/CW_ARCHITECTURE.md` | v2.0 공동 편집 (§2/§4/§6/§15 담당) |
| `.cowork/CW_PLAN.md` | K-IFRS 참조 + CW_SUBJECTS 참조 제거 |
| `.cowork/HANDOVER_Arjun.md` | Sonnet→Opus 인수인계 원본 (읽기 전용) |

---

## 완료 작업 — v2.0 구현 (W7R~W14)

### W7R+W11 스키마+도메인 확장 (커밋 9b375b3)

- ExchangeRateTable purpose 주석에 AVERAGE/CLOSING 명시
- CounterpartyTable +relatedPartyType +entityType
- TransactionTable +referenceNo +reversalType, source에 systemAuditAdjustment 추가
- Enums.dart: RelatedPartyType(5값) + EntityType(6값) + ReversalType(2값) + TransactionSource.systemAuditAdjustment
- Counterparty.dart: +필드 + INV-C4 검증
- Transaction.dart: +필드 + voidTransaction에서 reversalOrigin 자동 설정
- ICounterpartyRepository: +findByRelatedPartyType +findRelatedParties
- LegalParameterSeeds.dart 신규: 대손충당금 설정율 한도 시드

### W12 규칙엔진+Repository 확장 (커밋 7429364)

- TaxRuleEngine: 대손충당금 규칙 추가 (deductibleLimited), 미판정 키워드에서 '대손충당'/'채권'/'대여금' 제거
- CounterpartyDao: +findByRelatedPartyType +findRelatedParties 쿼리
- CounterpartyRepository: +2메서드 구현, save()에 relatedPartyType/entityType 저장, _toDomain 매핑
- TransactionRepository: save()에 referenceNo/reversalType 저장, _toDomain 매핑, +findByReferenceNo
- TransactionDao: +findByReferenceNo 쿼리

### W13 분류엔진+Dashboard (커밋 65e4658)

- ClassificationRuleTable: +creditAccountId nullable FK (대변 계정 자동결정)
- ClassificationEngine: ClassificationResult에 creditAccountId 필드 추가, 매칭 시 반환
- AccountTable: +isRevenueDeduction bool (매출차감 플래그)
- DashboardPage: 전월 대비 ±% 칩 위젯 (_buildChangeChip)
- ReportBloc DashboardSummary: +netAssetsChangeRatio/revenueChangeRatio/expenseChangeRatio

### W14 UseCase (커밋 2337ba6)

- CalculateBadDebtAllowance.dart 신규: LP 설정율 한도 기반 채권 연령분석, 한도 초과분 산출
- GenerateProvisionRollforward.dart 신규: 기초+전입-사용-환입=기말 롤포워드

---

## 현재 상태

- v2.0 W7R~W14 **전부 완료** (워크트리 wk-v2-arjun, 커밋 4건)
- W15(Sync/Auth) + W7-OCR: **외부 의존 대기** (서버 API / ML Kit 패키지)
- 담당 영역 구현 완료 항목: Counterparty 확장, Tax 대손충당금, Classification creditAccountId, Dashboard 기간비교 UI

## 다음 대기 중

- team-lead 추가 지시 대기
- QA Loop v2.0 실행 대��� (3명 전원 구현 완료 후)
- 잔여 후보: ComparePeriods UseCase 연동 시 DashboardPage 활성화, CounterpartyMatcher relatedPartyType 활용 확장
