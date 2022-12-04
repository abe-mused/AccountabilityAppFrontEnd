import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/pages/profile_page/view_follows.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/profile_page/profile_page.dart';

void main() {
  User user = User(
    username: 'tanvirUsername',
    name: 'tanvir',
    followers: ['tanvirUsername', 'tanvirUsername2', 'tanvirUsername3'],
    following: ['tanvirUsername', 'tanvirUsername2', 'tanvirUsername3'],
    communities: [],
  );

  testWidgets('followers tab', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: ViewFollowsPage(user: user, type: 'followers')));
    expect(find.byType(ViewFollowsPage), findsOneWidget);
    expect(find.text('3 Followers'), findsOneWidget);
  });

  testWidgets('following tab', (WidgetTester tester) async {
    User user = User(
      username: 'tanvirUsername',
      name: 'tanvir',
      followers: ['tanvirUsername', 'tanvirUsername2', 'tanvirUsername3'],
      following: ['tanvirUsername', 'tanvirUsername2', 'tanvirUsername3'],
      communities: [],
    );
    await tester.pumpWidget(
        MaterialApp(home: ViewFollowsPage(user: user, type: 'followers')));
    expect(find.byType(ViewFollowsPage), findsOneWidget);
    expect(find.text('3 Following'), findsOneWidget);
  });

  testWidgets('switch tabs', (WidgetTester tester) async {
    User user = User(
      username: 'tanvirUsername',
      name: 'tanvir',
      followers: ['tanvirUsername', 'tanvirUsername2', 'tanvirUsername3'],
      following: ['tanvirUsername', 'tanvirUsername2', 'tanvirUsername3'],
      communities: [],
    );
    await tester.pumpWidget(
        MaterialApp(home: ViewFollowsPage(user: user, type: 'followers')));
    expect(find.byType(ViewFollowsPage), findsOneWidget);
    expect(find.text('3 Following'), findsOneWidget);
    await tester.tap(find.text('3 Following'));
    await tester.pumpAndSettle();
    expect(find.text('3 Followers'), findsOneWidget);
  });
}