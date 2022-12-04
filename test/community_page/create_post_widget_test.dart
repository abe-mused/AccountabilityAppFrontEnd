import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/pages/community_page/create_post_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])
void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester
        .pumpWidget( MaterialApp(home: CreatePostWidget(communityName: '', onSuccess: (newPost) {},)));
    expect(find.byType(CreatePostWidget), findsOneWidget);
  });

  test('Post Title Field Changes', () {
    //setup
    final body = TextEditingController();
    //do
    body.text = 'I made five goals in practice';
    //test
    expect(body.text, 'I made five goals in practice');
  });

  test('Post Body Field Changes', () {
    //setup
    final days = TextEditingController();
    //do
    days.text = 'Today at soccer practice I made 5 goals!!! I had fun!';
    //test
    expect(days.text, 'Today at soccer practice I made 5 goals!!! I had fun!');
  });

  testWidgets('Test Regex Validation - all fields filled', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(MaterialApp(
        home: CreatePostWidget(communityName: '', onSuccess: (newPost) {},)));
    //No info entered
    await tester.pump();
    await tester.tap(find.text("Submit"));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Please fill out all fields."), findsOneWidget);
  });

  testWidgets('ALERT BUTTON: Test Regex Validation - all fields filled',
      (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(MaterialApp(
        home: CreatePostWidget(communityName: '', onSuccess: (newPost) {},)));
    //No info entered
    await tester.pump();
    await tester.tap(find.text("Submit"));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Please fill out all fields."), findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Please fill out all fields."), findsNothing);
  });
}