# CW_HANDOFF_Raj — Wave U1 Design System Foundation

**작성자**: Raj (wk-u1-raj)
**완료일**: 2026-05-01
**커밋 해시**: c237bd3
**브랜치**: wk-u1-raj

---

## 완료 항목 (DoD 체크리스트)

- [x] 6개 토큰 파일 생성 (AppColors/TextStyles/Spacing/Radius/Shadows/Motion)
- [x] AppTheme.dart 재정의 완료 (AppColors 기반 Material 3 ColorScheme)
- [x] pubspec.yaml 패키지 추가 (flutter_svg ^2.0.0, shared_preferences ^2.0.0)
- [x] pubspec.yaml fonts 경로 등록 (JetBrains Mono, Pretendard Variable)
- [x] shared/widgets/ 11개 파일 생성 완료
- [x] MyMoneyApp.dart AppTheme.dark()/light() 적용
- [x] flutter pub get 성공
- [x] flutter analyze — 신규 코드 0 error, 0 warning (기존 코드 warning은 Wave U1 범위 밖)

---

## 변경 파일 목록

| 파일 | 변경 유형 | 주요 내용 |
|------|-----------|-----------|
| `lib/app/theme/AppColors.dart` | 신규 | Nature 5색, primary tonal, semantic, dark/light 전체 | 
| `lib/app/theme/AppTextStyles.dart` | 신규 | display~label 스케일 + amountLg/Md/Sm (JetBrains Mono) |
| `lib/app/theme/AppSpacing.dart` | 신규 | sp1(4px)~sp8(64px) |
| `lib/app/theme/AppRadius.dart` | 신규 | xs~full + BorderRadius 상수 |
| `lib/app/theme/AppShadows.dart` | 신규 | shadow1/2/3 + glowLeaf/Well/Amber |
| `lib/app/theme/AppMotion.dart` | 신규 | fast/mid/slow/kick + Cubic 커브 4종 |
| `lib/app/theme/AppTheme.dart` | 전면 재작성 | AppColors 기반 dark()/light() 메서드 |
| `lib/app/MyMoneyApp.dart` | 수정 | AppTheme.dark()/light() 메서드 호출로 전환 (line 15-16) |
| `lib/shared/widgets/KickerBar.dart` | 신규 | 2px 레인보우 브랜드 라인 |
| `lib/shared/widgets/MoneyText.dart` | 신규 | JetBrains Mono 금액 텍스트 (3 크기) |
| `lib/shared/widgets/NatureBadge.dart` | 신규 | 5대 계정 뱃지 (nature 5색) |
| `lib/shared/widgets/IconBtn.dart` | 신규 | 36px 라운드 아이콘 버튼 |
| `lib/shared/widgets/SegmentToggle.dart` | 신규 | 세그먼트 컨트롤 위젯 |
| `lib/shared/widgets/AppChip.dart` | 신규 | 필터/렌즈 칩 위젯 |
| `lib/shared/widgets/KindIcon.dart` | 신규 | 5대 계정 이모지 위젯 |
| `lib/shared/widgets/DensityScope.dart` | 신규 | minimal/normal/dense InheritedWidget |
| `lib/shared/widgets/Sparkline.dart` | 신규 | 7일 추이 미니 선 그래프 CustomPainter |
| `lib/shared/widgets/LiquidGauge.dart` | 신규 | 물/포도주 게이지 CustomPainter |
| `lib/shared/widgets/GrowthTree.dart` | 신규 | 나무 성장 CustomPainter |
| `pubspec.yaml` | 수정 | flutter_svg, shared_preferences, 폰트 경로 추가 |
| `pubspec.lock` | 수정 | 패키지 lock 갱신 |

---

## 후속 Wave를 위한 참고사항

- **폰트 파일 미포함**: `assets/fonts/` 경로 등록만 완료. 실제 폰트 파일(JetBrainsMono-*.ttf, PretendardVariable.ttf)은 별도 추가 필요
- **AppTheme getter → 메서드 전환**: 기존 `AppTheme.dark` (getter)를 `AppTheme.dark()` (메서드)로 변경함. 다른 파일에서 참조 시 주의
- **withOpacity → withValues**: Flutter 3.x deprecation 대응으로 `.withValues(alpha:)` 사용
- **기존 warning 0건**: 커밋 d5a092b에서 전체 해소 완료 — flutter analyze No issues found

---

## Wave U2+ 연동 포인트

- `AppColors.darkAssetSurface` 등 nature-tinted surface 상수 → 카드/뱃지 배경
- `AppMotion.kick` + `AppMotion.kickCurve` → 전환 애니메이션
- `NatureBadge(AccountNature.asset)` → 계정 분류 표시
- `MoneyText(amount, size: MoneySize.lg)` → 잔액 표시
- `DensityScope.of(context)` → 밀도별 레이아웃 분기
