// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:mymoney/app/MyMoneyApp.dart';

void main() {
  testWidgets('앱 시작 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyMoneyApp());
    // 4탭 네비게이션 확인
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('거래'), findsOneWidget);
  });
}
