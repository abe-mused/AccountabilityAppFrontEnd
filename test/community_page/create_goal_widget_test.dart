import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/pages/community_page/create_goal_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])
void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester
        .pumpWidget( MaterialApp(home: CreateGoalWidget(communityName: '', onSuccess: (newGoal) {},)));
    expect(find.byType(CreateGoalWidget), findsOneWidget);
  });

  test('Goal Body Field Changes', () {
    //setup
    final body = TextEditingController();
    //do
    body.text = 'Make five goals in practice';
    //test
    expect(body.text, 'Make five goals in practice');
  });

  test('Goal Days Field Changes', () {
    //setup
    final days = TextEditingController();
    //do
    days.text = '10';
    //test
    expect(days.text, '10');
  });

  testWidgets('Test Regex Validation - all fields filled', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(MaterialApp(
        home: CreateGoalWidget(communityName: '', onSuccess: (newGoal) {},)));
    //No info entered
    await tester.pump();
    await tester.tap(find.text("create goal"));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Please fill out all fields."), findsOneWidget);
  });

  testWidgets('ALERT BUTTON: Test Regex Validation - all fields filled',
      (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(MaterialApp(
        home: CreateGoalWidget(communityName: '', onSuccess: (newGoal) {},)));
    //No info entered
    await tester.pump();
    await tester.tap(find.text("create goal"));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Please fill out all fields."), findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Please fill out all fields."), findsNothing);
  });


}