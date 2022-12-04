import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/inroduction_page/intro_banner.dart';
import 'package:linear/inroduction_page/intro_page.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LinearIntroBanner()));
    expect(find.byType(LinearIntroBanner), findsOneWidget);
  });

  testWidgets('Close Banner', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LinearIntroBanner()));
    await tester.pump();
    expect(find.byType(LinearIntroBanner), findsOneWidget);
    expect(find.byType(Container), findsNothing);
    expect(find.byType(IconButton), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SizedBox), findsNothing);
  });

  testWidgets('Redirect to Intro Pages', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: const LinearIntroBanner(),
        navigatorObservers: [mockObserver],
      ),
    );
    await tester.pump();
    expect(find.byType(LinearIntroBanner), findsOneWidget);
    expect(
        find.text('Click here to get to know the linear App!'), findsOneWidget);
    await tester.tap(find.text('Click here to get to know the linear App!'));
    await tester.pumpAndSettle();
    expect(find.byType(LinearIntro), findsOneWidget);
  });
}
