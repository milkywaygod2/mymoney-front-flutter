# CW_HANDOFF_Carlos — Wave U4+U5+U6 완료 핸드오프

**에이전트**: Carlos (UI 팀 말단)
**브랜치**: wk-u456-carlos
**최종 갱신**: 2026-05-01

---

## 완료 커밋 목록

| 커밋 | 내용 |
|------|------|
| `ef15bd7` | FEAT: Wave U6 Report Dashboard 재작성 — 재무비율 그리드+B/S+P/L+CF폭포+CE테이블 |
| `b6578a0` | FEAT: Wave U5 AccountTree 재작성 — Browse/Map/Config 3모드+ClusterMap+MetaphorIcon |
| `98db0ad` | FEAT: Wave U4 Entry 거래입력 신규 — EntryPage+V1/V2/V3+EntryBloc+EntryAutoPlay |

---

## Wave U6 — Report Dashboard (ef15bd7)

### 변경 파일

| 파일 | 라인 | 내용 |
|------|------|------|
| `lib/features/report/presentation/DashboardPage.dart` | 1-370 | 재작성 — 재무비율+B/S+P/L+CF+CE 통합 + 기간 비교 토글 (MOM/QOQ/YOY) |
| `lib/features/report/presentation/RatioGrid.dart` | 1-210 | 신규 — 29종 재무비율 카드 그리드 (카테고리별 TabBar) |
| `lib/features/report/presentation/BSChart.dart` | 1-300 | 신규 — 자산/부채/자본 LinearProgressIndicator 차트 + 세부 항목 |
| `lib/features/report/presentation/PLChart.dart` | 1-315 | 신규 — 수익/비용/순이익 차트 + 세부 항목 |
| `lib/features/report/presentation/CFWaterfall.dart` | 1-285 | 신규 — CustomPainter 폭포 차트 (CFWaterfallFull도 포함) |
| `lib/features/report/presentation/CETable.dart` | 1-230 | 신규 — 자본변동표 5구성요소 롤포워드 Table 위젯 |

### DoD 달성 현황
- [x] W12~W14 모든 데이터(재무비율29종/B/S/P/L/CF/CE) 시각화로 노출
- [x] 기간 비교 토글 동작 (MOM/QOQ/YOY SegmentedButton)
- [x] flutter analyze 0 error

### 미완 / TODO
- CFWaterfall: `ReportBloc`에 `cashFlowStatement` 상태가 없어 `CFWaterfallFull`은 DashboardPage에서 미연결. 연결 시 `CFWaterfall` → `CFWaterfallFull`로 교체.
- CETable: `ReportBloc`에 `equityChangeStatement` 상태가 없어 `comprehensiveIncome` 기반 간이 표시. 연결 시 `GenerateEquityChangeStatement` 결과 직접 수신.
- 색상 토큰: `const Color(0x...)` 하드코딩 → U1 머지 후 `AppColors`로 교체 (TODO 주석 위치에 기재)

---

## Wave U5 — AccountTree (b6578a0)

### 변경 파일

| 파일 | 라인 | 내용 |
|------|------|------|
| `lib/features/account/presentation/AccountTreePage.dart` | 1-235 | 재작성 — 3모드 토글 + 검색/추가 AppBar |
| `lib/features/account/presentation/AccountBrowse.dart` | 1-105 | 신규 — 들여쓰기 트리 조회 + 검색 결과 |
| `lib/features/account/presentation/AccountMap.dart` | 1-50 | 신규 — 5클러스터 시각화 래퍼 |
| `lib/features/account/presentation/AccountConfig.dart` | 1-130 | 신규 — 메타포 선택 + 설명 카드 |
| `lib/features/account/presentation/widgets/ModeToggle.dart` | 1-40 | 신규 — 조회/지도/설정 SegmentedButton |
| `lib/features/account/presentation/widgets/TreeRow.dart` | 1-130 | 신규 — 들여쓰기+메타포아이콘+NatureChip |
| `lib/features/account/presentation/widgets/MetaphorIcon.dart` | 1-35 | 신규 — K-IFRS 성격별 이모지 (자산🌳 비용🍎 수익💧 부채🫙 자본🪣) |
| `lib/features/account/presentation/widgets/ClusterMap.dart` | 1-255 | 신규 — CustomPainter 5클러스터 + BottomSheet 목록 |
| `lib/features/account/presentation/widgets/MetaphorPicker.dart` | 1-120 | 신규 — 설정 모드 메타포 선택 위젯 |

### DoD 달성 현황
- [x] K-IFRS 계정 트리 정상 렌더 (AccountBrowse, equityTypePath 기반 자식 추출)
- [x] 3모드 토글 동작 (AnimatedSwitcher 200ms)
- [x] flutter analyze 0 error

### 미완 / TODO
- TreeRow의 자식 추출: 현재 AccountBrowse에서 depth 1 자식만 주입. 다단계 재귀 트리는 AccountBloc에 전체 목록이 있어야 완성 가능 (현재 listRoots에는 루트만 있음).
- AccountConfig.onSave: CreateAccount 이벤트에 equityTypeId/liquidityId 등 필수 DimensionValueId가 필요해 stub으로 처리.

---

## Wave U4 — Entry 거래입력 (98db0ad)

### 변경 파일

| 파일 | 라인 | 내용 |
|------|------|------|
| `lib/features/entry/presentation/EntryPage.dart` | 1-255 | 신규 — BottomSheet 컨테이너 (320ms 모션, V1/V2/V3 토글) |
| `lib/features/entry/presentation/EntryBloc.dart` | 1-225 | 신규 — 상태 관리 (자연어 파서 stub + 숫자패드 + OCR 결과 수신) |
| `lib/features/entry/presentation/EntryV1.dart` | 1-95 | 신규 — 자연어 입력 + 파싱 결과 표시 |
| `lib/features/entry/presentation/EntryV2.dart` | 1-75 | 신규 — 숫자패드 + AccountPicker 연동 |
| `lib/features/entry/presentation/EntryV3.dart` | 1-80 | 신규 — OcrBloc 연동 (캡처/인식중/결과 3단계 UI) |
| `lib/features/entry/presentation/widgets/EntryAutoPlay.dart` | 1-135 | 신규 — 2000ms AnimationController 3페이즈 (enter/fly/arrive) |
| `lib/features/entry/presentation/widgets/AmountHero.dart` | 1-50 | 신규 — 큰 금액 표시 영역 |
| `lib/features/entry/presentation/widgets/FromToFlow.dart` | 1-80 | 신규 — 출처→도착 칩 (대변/차변) |
| `lib/features/entry/presentation/widgets/NumPad.dart` | 1-100 | 신규 — 0~9+C+⌫ 숫자패드 |
| `lib/features/entry/presentation/widgets/AccountPicker.dart` | 1-110 | 신규 — AccountBloc 연동 계정 선택 모달 |
| `lib/features/entry/presentation/widgets/OcrCaptureView.dart` | 1-90 | 신규 — 카메라 프리뷰 stub + 가이드 프레임 CustomPainter |
| `lib/features/entry/presentation/widgets/OcrResultPanel.dart` | 1-120 | 신규 — OCR 파싱 결과 확인 패널 |

### DoD 달성 현황
- [x] BottomSheet 모달 진입 (320ms emphasized 모션)
- [x] V1→V2→V3 토글 시 데이터 보존 (EntryBloc 공유)
- [x] 저장 → EntryAutoPlay 2초 → 닫기 흐름
- [x] flutter analyze 0 error

### 미완 / TODO
- EntryBloc._onSave: CreateTransaction UseCase DI 연동 전까지 300ms stub 딜레이. 실연동 시 `CreateTransaction` 주입 후 교체.
- OcrCaptureView: image_picker 패키지 연동 전까지 stub 텍스트로 ProcessOcr 호출. 실카메라 연동 시 교체.
- AccountPicker: 현재 AccountBloc.listRoots(루트만)를 표시. 전체 계정 목록 표시 원할 시 AccountBloc에 findAll 이벤트 추가 필요.

---

## U1 머지 후 후속 작업 (색상 토큰 교체 위치)

### U6 DashboardPage.dart
- `Theme.of(context).colorScheme.primary` → `AppColors.primary`
- `const Color(0xFF4CAF50)` → `AppColors.income`
- `const Color(0xFFF44336)` → `AppColors.expense`

### U4 EntryPage/V1/V2/widgets
- `Theme.of(context).colorScheme.surfaceContainerHighest` → `AppColors.surface`
- FromToFlow의 출처/도착 색상 → `AppColors.debit` / `AppColors.credit`

### U5 ClusterMap/TreeRow
- `const Color(0xFF4CAF50)` 등 5색 → `AppColors.nature*` 시리즈

---

## 분석 메모

- `dart analyze lib/` 실행 결과: 신규 파일 error 0건 / 기존 파일 warning 4건 + info 8건 (수정 불가 — 기존 코드)
- EntryAutoPlay: 3페이즈 Interval 기반 CurvedAnimation 구현 (enter: 0~22%, fly: 22~72%, arrive: 72~94%)
- CFWaterfall: CustomPainter로 폭포 차트 수학 로직 구현 (running total → bar 상단 Y 계산)
- ClusterMap: 5클러스터 배치좌표(상대 비율) + 계정수 비례 버블 크기 + 관계선 CustomPainter
