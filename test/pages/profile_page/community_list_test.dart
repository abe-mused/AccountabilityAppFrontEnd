import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/pages/profile_page/community_list.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/community_page/community_page.dart';

void main() {
  User communities3 = User(
    username: 'tanvirUsername',
    name: 'tanvir',
    followers: [],
    following: [],
    communities: [
      {
        'communityName': 'Redirect',
        'dateJoined': '0',
        'firstStreakDate': 0,
        'lastStreakDate': 1620000000000,
      },
      {
        'communityName': 'B',
        'dateJoined': '0',
        'firstStreakDate': 0,
        'lastStreakDate': 1620000000000,
      },
      {
        'communityName': 'C',
        'dateJoined': '0',
        'firstStreakDate': 1620000000000,
        'lastStreakDate': 1620000000000,
      },
    ],
  );

  User moreThan3Communities = User(
    username: 'tanvirUsername',
    name: 'tanvir',
    followers: [],
    following: [],
    communities: [
      {
        'communityName': 'A',
        'dateJoined': 4,
        'firstStreakDate': 100,
        'creator': 'tanvirUsername',
        'lastStreakDate': 100,
      },
      {
        'communityName': 'B',
        'dateJoined': 1,
        'firstStreakDate': 1620000000000,
        'lastStreakDate': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'communityName': 'C',
        'dateJoined': 2,
        'firstStreakDate': 100,
        'lastStreakDate': 100,
      },
      {
        'communityName': 'D',
        'dateJoined': 0,
        'firstStreakDate': 1620000000000,
        'lastStreakDate': 1620000000000,
      },
      {
        'communityName': 'E',
        'dateJoined': 4,
        'firstStreakDate': 100,
        'lastStreakDate': 100,
      },
      {
        'communityName': 'F',
        'dateJoined': 5,
        'firstStreakDate': 100,
        'lastStreakDate': 100,
      },
      {
        'communityName': 'G',
        'dateJoined': 6,
        'firstStreakDate': 100,
        'lastStreakDate': 100,
      },
    ],
  );

  User emptyCommunities = User(
    username: 'tanvirUsername',
    name: 'tanvir',
    followers: [],
    following: [],
    communities: [],
  );

  User? userToDisplay;
  userToDisplay = emptyCommunities;

  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: moreThan3Communities,
    )));
    expect(find.byType(CommunityListWidget), findsOneWidget);
  });

  testWidgets('Doesnt give "see all communities" option with 3 communities',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: communities3,
    )));
    await tester.pumpAndSettle();
    expect(find.text("see all communities"), findsNothing);
  });

  testWidgets('Test if error message displays if community list is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: emptyCommunities,
    )));
    await tester.pumpAndSettle();
    expect(
        find.text(
            "It seems that ${userToDisplay!.name.split(" ").first} isn't in any communities... yet."),
        findsOneWidget);
  });

  testWidgets(
      'Test if "see all communities" option displays with more than 3 communities',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: moreThan3Communities,
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text("see all communities"));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('Close "All communities" alert dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: moreThan3Communities,
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text("see all communities"));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text("Close"));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Sort more than 3 communities by date joined',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: moreThan3Communities,
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text("see all communities"));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(ExpansionTile), findsOneWidget);
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('Date Joined')), findsOneWidget);
    await tester.tap(find.byKey(const Key('Date Joined')));
    await tester.pumpAndSettle();
    expect(moreThan3Communities.communities![0]['communityName'], 'D');
  });

  testWidgets('Sort more than 3 communities by Last Post Date',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: moreThan3Communities,
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text("see all communities"));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(ExpansionTile), findsOneWidget);
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('Last post date')), findsOneWidget);
    await tester.tap(find.byKey(const Key('Last post date')));
    await tester.pumpAndSettle();
    expect(moreThan3Communities.communities![0]['communityName'], 'B');
  });

  testWidgets('Sort more than 3 communities A-Z', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: moreThan3Communities,
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text("see all communities"));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(ExpansionTile), findsOneWidget);
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('Alphabetical (A-Z)')), findsOneWidget);
    await tester.tap(find.byKey(const Key('Alphabetical (A-Z)')));
    await tester.pumpAndSettle();
    expect(moreThan3Communities.communities![0]['communityName'], 'A');
  });

  testWidgets('Sort more than 3 communities Z-A', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: moreThan3Communities,
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text("see all communities"));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(ExpansionTile), findsOneWidget);
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('Alphabetical (Z-A)')), findsOneWidget);
    await tester.tap(find.byKey(const Key('Alphabetical (Z-A)')));
    await tester.pumpAndSettle();
    expect(moreThan3Communities.communities![0]['communityName'], 'G');
  });

  testWidgets('redirect to community page', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CommunityListWidget(
      user: communities3,
    )));
    expect(find.text('c/Redirect'), findsOneWidget);
    await tester.tap(find.text('c/Redirect'));
    expect(find.byType(CommunityListWidget), findsOneWidget);
  });
}
