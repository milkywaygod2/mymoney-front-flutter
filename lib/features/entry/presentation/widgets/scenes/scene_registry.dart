import 'package:flutter/material.dart';

import '../../EntryBloc.dart';
import 'Scene1.dart';
import 'Scene2.dart';
import 'Scene3.dart';
import 'Scene4.dart';
import 'Scene5.dart';
import 'Scene6.dart';

/// 씬 메타데이터
class SceneMeta {
  const SceneMeta({
    required this.title,
    required this.sub,
    required this.amount,
    required this.build,
  });
  final String title;
  final String sub;
  final String amount;
  final Widget Function(AnimationController) build;
}

/// 9개 씬 레지스트리
const List<SceneMeta> scenes = [
  SceneMeta(
    title: '카페 커피 · 현금결제',
    sub: '외식비 ₩5,500',
    amount: '₩5,500',
    build: _buildScene1,
  ),
  SceneMeta(
    title: '카페 커피 · 카드결제',
    sub: '외식비 ₩5,500',
    amount: '₩5,500',
    build: _buildScene2,
  ),
  SceneMeta(
    title: '예금 → 적금 이체',
    sub: '월 납입 ₩500,000',
    amount: '₩500,000',
    build: _buildScene3,
  ),
  SceneMeta(title: '대출 받음', sub: '주담대 ₩200,000,000', amount: '+₩200,000,000', build: _buildScene4),
  SceneMeta(title: '월급 입금', sub: '기본급 ₩3,200,000', amount: '+₩3,200,000', build: _buildScene5),
  SceneMeta(title: '대출 상환', sub: '주담대 원리금 ₩1,250,000', amount: '₩1,250,000', build: _buildScene6),
  SceneMeta(title: '이자 수익', sub: '예금이자 ₩12,400', amount: '+₩12,400', build: _buildScene1),
  SceneMeta(title: '부동산 매입', sub: '아파트 ₩600,000,000', amount: '₩600,000,000', build: _buildScene1),
  SceneMeta(title: '출자·증자', sub: '보통주 ₩50,000,000', amount: '+₩50,000,000', build: _buildScene1),
];

Widget _buildScene1(AnimationController c) => Scene1(controller: c);
Widget _buildScene2(AnimationController c) => Scene2(controller: c);
Widget _buildScene3(AnimationController c) => Scene3(controller: c);
Widget _buildScene4(AnimationController c) => Scene4(controller: c);
Widget _buildScene5(AnimationController c) => Scene5(controller: c);
Widget _buildScene6(AnimationController c) => Scene6(controller: c);

/// wave-6 §6.1 accountHint + parsedAmount 조합으로 씬 자동 선택
/// AccountId는 int 타입이므로 accountHint 문자열로 kind 추론
/// 매핑 실패 시 0 (Scene1) fallback
int selectScene(EntryState state) {
  final hint = (state.accountHint ?? '').toLowerCase();
  final amount = state.parsedAmount ?? 0;

  if (hint.contains('급여') || hint.contains('salary')) {
    return 4; // Scene5 월급
  }
  if (hint.contains('이자') || hint.contains('interest')) {
    return 6; // Scene7 이자수익
  }
  if (hint.contains('대출') && hint.contains('상환')) {
    return 5; // Scene6 대출상환
  }
  if (hint.contains('대출') || hint.contains('차입')) {
    return 3; // Scene4 대출받음
  }
  if (hint.contains('적금') || hint.contains('이체')) {
    return 2; // Scene3 이체
  }
  if (hint.contains('카드')) {
    return 1; // Scene2 카드결제
  }
  if (hint.contains('출자') || hint.contains('자본금')) {
    return 8; // Scene9 출자
  }
  if (hint.contains('부동산') || hint.contains('건물')) {
    return 7; // Scene8 부동산
  }
  // 금액 기반 추가 분기: 큰 금액은 대출로 추정
  if (amount > 10000000) {
    return 3;
  }
  return 0; // Scene1 현금결제 fallback
}
