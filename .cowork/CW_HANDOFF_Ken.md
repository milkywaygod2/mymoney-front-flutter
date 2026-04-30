# CW_HANDOFF_Ken — Wave U2 + U3 완료 보고

## 담당자
- **에이전트**: Ken (사원, UI팀)
- **워크트리**: `E:\_Develop\dart\mymoney-front-flutter\.worktrees\wk-u23-ken`
- **브랜치**: `wk-u23-ken`

---

## 커밋 요약

| 커밋 해시 | 메시지 |
|-----------|--------|
| `06b43b7` | FEAT: Wave U2 Home 대시보드 + Wave U3 Journal 거래내역 UI 구현 |
| `ed31b23` | FEAT: U1 AppColors 토큰 적용 — 하드코딩 색상 전체 교체 |

---

## Wave U2 — Home 대시보드

### 변경 파일 목록

| 파일 | 라인 | 내용 |
|------|------|------|
| `lib/features/home/presentation/HomeBloc.dart` | 1–140 | ReportBloc 합성, HomeViewModel/HomeEvent/HomeState/HomeBloc 정의 |
| `lib/features/home/presentation/HomePage.dart` | 1–135 | V1/V2/V3 세그먼트 토글, 200ms FadeTransition 애니메이션 |
| `lib/features/home/presentation/HomeV1.dart` | 1–120 | Toss형: 인사 + 순자산카드 + 3-up + 이번달흐름 + PendingBox |
| `lib/features/home/presentation/HomeV2.dart` | 1–250 | 나무·물 은유: GrowthTree + LiquidGauge×3 + 수식 힌트 |
| `lib/features/home/presentation/HomeV3.dart` | 1–100 | 저울: ProportionalScale + PendingBox + FiveAccountBox |
| `lib/features/home/presentation/widgets/HomeBloc.dart` | — | — |
| `lib/features/home/presentation/widgets/NetWorthCard.dart` | 1–110 | 순자산 카드 + SparklineWidget |
| `lib/features/home/presentation/widgets/ThreeUpStats.dart` | 1–80 | 자산/부채/자본 3분할 미니 스탯 |
| `lib/features/home/presentation/widgets/MonthFlowBar.dart` | 1–115 | 수익/비용 가로 이중 바 |
| `lib/features/home/presentation/widgets/ProportionalScale.dart` | 1–230 | 시소 저울 CustomPainter (log2 tilt ±18°) |
| `lib/features/home/presentation/widgets/FiveAccountBox.dart` | 1–200 | 복식부기 항등식 2-tier 비례 박스 |
| `lib/features/home/presentation/widgets/PendingBox.dart` | 1–75 | 예약 거래 박스 (비어있으면 SizedBox.shrink) |

### DoD 체크 (Wave U2)
- [x] 3개 변주 토글 시 200ms fade 애니메이션
- [x] HomeV3 저울 tilt 동작 (log2(revenue/expense)×18°)
- [x] 예약 거래 없을 때 PendingBox 숨김
- [x] flutter analyze 0 error (warning은 기존 파일 포함)

---

## Wave U3 — Journal 거래내역

### 변경 파일 목록

| 파일 | 라인 | 내용 |
|------|------|------|
| `lib/features/journal/presentation/JournalPage.dart` | 전체 재작성 | V1/V2/V3 토글 컨테이너, 200ms FadeTransition |
| `lib/features/journal/presentation/JournalV1.dart` | 1–350 | 단식/복식 토글, 필터칩, 펼침 분개, DoubleEntryCard |
| `lib/features/journal/presentation/JournalV2.dart` | 1–200 | 분개장 그리드 (날짜\|차변\|대변 3col), 일 손익 합계 |
| `lib/features/journal/presentation/JournalV3.dart` | 1–110 | FROM→TO 흐름 카드 |
| `lib/features/journal/presentation/widgets/MiniPosting.dart` | 1–130 | log10 비례 높이, 배경 화살표 CustomPainter, 양쪽 신장 헬퍼 |
| `lib/features/journal/presentation/widgets/PostingCell.dart` | 1–65 | V2 분개장용 셀 |
| `lib/features/journal/presentation/widgets/FlowNode.dart` | 1–55 | V3 흐름 노드 |
| `lib/features/journal/presentation/widgets/FlowArrow.dart` | 1–65 | V3 그래디언트 점선 화살표 |
| `lib/features/journal/presentation/widgets/DCBadge.dart` | 1–35 | 차/대 뱃지 |
| `lib/features/journal/presentation/widgets/LedgerPosting.dart` | 1–65 | V1 펼침 분개 셀 |
| `lib/features/journal/presentation/widgets/DayGroupHeader.dart` | 1–55 | 날짜 그룹 헤더 + 일 손익 |

### DoD 체크 (Wave U3)
- [x] 4줄 분개 정확 렌더 (MiniPosting 양쪽 신장)
- [x] 일별 그룹 헤더 + 일 손익 (DayGroupHeader)
- [x] V1 단식 펼침 시 분개 표시 (LedgerPosting)
- [x] flutter analyze 0 error

---

## AppRouter 갱신

| 파일 | 변경 |
|------|------|
| `lib/app/router/AppRouter.dart` | `/home` → `HomePage` (HomeBloc 주입), `/journal` → `JournalPage` 연결 |

---

## 미완료 / TODO

- ~~색상 토큰: `// TODO: U1 머지 후 AppColors로 교체` 주석으로 전체 하드코딩 처리됨~~ → `ed31b23`에서 완료
- MiniPosting의 계정명/kind: 현재 `accountId.value` 표시 → Account 조회 연동 필요
- HomeBloc spark7d: 현재 단순 계산식 → 일별 스냅샷 쿼리 연동 필요

---

## 보고 일시
2026-05-01
