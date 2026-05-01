# 조직도 (CW_STATE_ORG)

## 현재 Phase
Phase 7 (QA Loop 진행 중 — v3.0 UI QA, Wave U1~U6 완료 후 검증)

## 조직도

### 백엔드 팀 (mymoney-impl — 외부 의존 대기)
| 직급 | 이름 | 모델 | 상태 | 담당 영역 | 보고 대상 |
|------|------|------|------|-----------|-----------|
| 사용자 | (사용자) | - | 활성 | 최상급자 — 최종 승인 | - |
| 주임급 | team-lead | Opus | 활성 | 총괄 — 의장 겸임, 리뷰/머지 | 사용자 |
| 사원급 | Arjun-3 | Opus | 대기 | Counterparty+Tax+Classification (W15/OCR 블록) | team-lead |
| 사원급 | Grace-3 | Opus | 대기 | Report+비율+OCI+기간비교 (W15/OCR 블록) | team-lead |
| 사원급 | Omar-3 | Opus | 대기 | CF+CE+결산훅+스냅샷 (W15/OCR 블록) | team-lead |

### UI 팀 (ui-impl — Wave U1~U6 완료, v3.0 QA COMPLETE)
| 직급 | 이름 | 모델 | 상태 | 담당 영역 | 보고 대상 | 워크트리 |
|------|------|------|------|-----------|-----------|----------|
| 대리급(대행) | 메인 컨텍스트 | Sonnet | 활성 | UI 총괄 관리자 대행 | 사용자 | 없음 |
| 사원급 | Raj-2 | Sonnet | ✅ 퇴역 | QA U1+U6 완료 | 메인 | wk-u1-raj |
| 사원급 | Ken-2 | Sonnet | ✅ 퇴역 | QA U2+U3 완료 | 메인 | wk-u23-ken |
| 사원급 | Carlos-2 | Sonnet | ✅ 퇴역 | QA U4+U5 완료 | 메인 | wk-u456-carlos |

## 퇴역 이력
| 이름 | 모델 | 퇴역 사유 | 날짜 |
|------|------|----------|------|
| James | Opus | 세션 만료 (무응답) | 2026-04-19 |
| Priya | Opus | 세션 만료 (무응답) | 2026-04-19 |
| Wei | Opus | 세션 만료 (무응답) | 2026-04-19 |
| Sofia | Opus | 세션 만료 (무응답) | 2026-04-19 |
| Ryan | Opus | 세션 만료 (무응답) | 2026-04-19 |
| Arjun | Sonnet | 모델 전환 핸드오프 (Sonnet→Opus) | 2026-04-20 |
| Grace | Sonnet | 모델 전환 핸드오프 (Sonnet→Opus) | 2026-04-20 |
| Omar | Sonnet | 모델 전환 핸드오프 (Sonnet→Opus) | 2026-04-20 |
| Raj-2 | Sonnet | v3.0 UI QA COMPLETE — U1+U6 담당 완료 | 2026-05-02 |
| Ken-2 | Sonnet | v3.0 UI QA COMPLETE — U2+U3 담당 완료 | 2026-05-02 |
| Carlos-2 | Sonnet | v3.0 UI QA COMPLETE — U4+U5+U6 담당 완료 | 2026-05-02 |

## TF 이력
- TF-001: MyMoney Phase 0~2 (수요조사/기획/설계), 의장: James, 위원: Priya/Wei/Sofia/Ryan
- W0~W6: team-lead 주도 + TF 위원 병렬 (W3부터 team-lead 단독)
- W7~: mymoney-impl 팀 (Arjun/Grace/Omar) 편성
- 2026-04-20: Sonnet→Opus 모델 전환 (Arjun→Arjun-3, Grace→Grace-3, Omar→Omar-3)
- 2026-04-20: Phase 5 재편성 — v2.0 담당 영역 갱신 (인원 변경 없음)
- 2026-04-20: Phase 7 실행 완료 — W7R+W11+W12+W13+W14 (52태스크, 에러 0건)
- 2026-05-01: UI Wave U1~U6 구현 완료 — Raj(U1)/Ken(U2+U3)/Carlos(U4+U5+U6), agent-automation main 머지 완료
- 2026-05-01: v3.0 UI QA Loop 시작 — Raj-2/Ken-2/Carlos-2 (Step 1 GAP 6건 수정 중, Iteration 1)
- 2026-05-02: QA Loop Iteration 4 Step 1 — 디자인 레퍼런스(JSX 원본) 기준 재대조 지시 발송
- 2026-05-02: v3.0 UI QA Loop COMPLETE — Iteration 13 / 연속 2회 풀패스 (Iter 12+13) / GAP+FIXED 0건 / KNOWN-GAP 12건 등록. Raj-2·Ken-2·Carlos-2 퇴역.
