import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/pages/profile_page/view_follows.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

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
    await tester.pumpWidget(
        MaterialApp(home: ViewFollowsPage(user: user, type: 'followers')));
    expect(find.byType(ViewFollowsPage), findsOneWidget);
    expect(find.text('3 Following'), findsOneWidget);
  });

  testWidgets('switch tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: ViewFollowsPage(user: user, type: 'followers')));
    expect(find.byType(ViewFollowsPage), findsOneWidget);
    expect(find.text('3 Following'), findsOneWidget);
    await tester.tap(find.text('3 Following'));
    await tester.pumpAndSettle();
    expect(find.text('3 Followers'), findsOneWidget);
  });

  testWidgets('redirect to following user profile',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        home: ViewFollowsPage(user: user, type: 'followers'),
        navigatorObservers: [mockObserver],
      ),
    );

    expect(find.byType(ViewFollowsPage), findsOneWidget);
    expect(find.text('3 Following'), findsOneWidget);

    expect(find.text('u/tanvirUsername2'), findsOneWidget);
    await tester.tap(find.text('u/tanvirUsername2'));

    for (int i = 0; i < 5; i++) {
      // because pumpAndSettle doesn't work with circular progress indicator
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.byType(ProfilePage), findsOneWidget);
  });
}
