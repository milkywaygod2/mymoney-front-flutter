# CW_HANDOFF_Grace.md — Grace 인계 문서

> 담당: Grace (ExchangeRate + Report + Settlement)
> 워크트리: `E:/_Develop/dart/mymoney-wk-grace` (브랜치: `wk-w8-grace`)
> 최종 갱신: 2026-04-19

---

## 완료 이력

| Wave | 태스크 | 커밋 | 변경 파일 |
|------|--------|------|-----------|
| W7 보조 | CounterpartyPage UI | `c736a2b` | `lib/features/counterparty/presentation/CounterpartyPage.dart` (805줄) |
| W8 | ExchangeRate DAO/Repo + 환산/미실현손익 UseCase | `254a7e0` | 5개 파일 (DAO, Repo, 2 UseCases, Interface 수정) |

---

## W7 보조: CounterpartyPage UI (`c736a2b`)

**파일**: `lib/features/counterparty/presentation/CounterpartyPage.dart:1-805`

**구현 내용**:
- `CounterpartyPage` — 거래처 관리 메인 페이지 (`StatefulWidget`, ICounterpartyRepository 주입)
  - 전체 거래처 로드 + 실시간 검색 필터 (이름/별칭/식별번호)
  - FAB → 거래처 추가 BottomSheet
  - 리스트 탭 → 상세 BottomSheet
- `_SearchBar` — 검색 바 (TextField + 실시간 onChanged)
- `_CounterpartyTile` — 리스트 타일 (이름 + 식별번호 + 신뢰도 뱃지 + 유형 아이콘)
- `_TypeIcon` — 거래처 유형별 아이콘 (법인/개인/정부기관/기타)
- `_ConfidenceBadge` — 신뢰도 뱃지 (verified/high/medium/low/unknown 5단계 색상)
- `_CounterpartyDetailSheet` — 상세 BottomSheet
  - 기본 정보 (유형/식별번호/연락처/주소/특수관계자)
  - alias 목록 + 삭제 (INV-C3 유일성 검증 포함)
  - alias 추가 입력란
- `_CounterpartyAddSheet` — 추가 BottomSheet
  - Form 유효성 검증 (이름 필수, 번호유형-번호 쌍 검증)
  - 거래처명/유형/식별번호/연락처/주소 입력

**특이사항**:
- BLoC 미구현 상태이므로 ICounterpartyRepository 직접 주입 방식으로 구현
- Wave 7 CounterpartyBloc 완성 후 BlocBuilder로 마이그레이션 필요
- alias id=0으로 임시 생성 (DB save 후 실제 ID 갱신 필요 — DAO 구현 몫)

---

## W8: ExchangeRate DAO/Repo + 환산/미실현손익 (`254a7e0`)

**변경 파일**:
- `lib/features/exchange/data/ExchangeRateDao.dart:1-79` (신규)
- `lib/features/exchange/data/ExchangeRateRepository.dart:1-87` (신규)
- `lib/features/exchange/usecase/ConvertCurrency.dart:1-96` (신규)
- `lib/features/exchange/usecase/EvaluateUnrealizedFxGain.dart:1-155` (신규)
- `lib/core/interfaces/IExchangeRateRepository.dart` (수정 — dynamic → ExchangeRateValue 타입 확정)

**구현 내용**:
- `ExchangeRateDao`: findRate/getLatestRate/saveRate/findRecentRates/deleteOlderThan
  - 인덱스 `idx_exchange_rates_lookup` 활용 (effectiveDate DESC, limit 1)
- `ExchangeRateRepository`: IExchangeRateRepository 구현, Drift row ↔ ExchangeRateValue VO 변환
  - `saveWithMeta()` 확장 메서드 (API 연동 시 날짜/출처 명시)
- `ConvertCurrency`: 거래 시점 환율 기준 통화 환산
  - 동일 통화 단락 처리 (1:1 환율 반환)
  - `ExchangeRateNotFoundError` 정의 (ConvertCurrency.dart에 포함)
- `EvaluateUnrealizedFxGain`: 온디맨드 미실현 외환차손익 계산 (저장 안 함)
  - 계정 성격(Asset/Liability)에 따른 손익 방향 결정 (아키텍처 7.3)
  - `execute()` (JEL 목록 일괄), `evaluateSingle()` (FlowCard 노드용)

**특이사항**:
- `ExchangeRateNotFoundError`는 `ConvertCurrency.dart`에 정의 (DomainErrors.dart 미수정)
- IExchangeRateRepository의 dynamic 타입을 ExchangeRateValue?/ExchangeRateValue로 확정

---

## 대기 중 (W8 이후)

| Subject | 태스크 | 상태 |
|---------|--------|------|
| S09 | ExchangeRate 캐시 갱신 정책 구현 (1일 1회) | 대기 |
| S09 | Flow Card 다통화 노드 UI | 대기 |
| S08b | ReportBloc + B/S·P/L·CF 집계 쿼리 | 대기 |
| S08b | 결산 5단계 UseCase | 대기 |
| S08b | 외환차손익 자동 전표 생성 | 대기 |
| S08b | 손익 마감 UseCase | 대기 |
| S08b | 결산 스냅샷 저장 | 대기 |
