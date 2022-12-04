import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/pages/common_widgets/sort_posts_widget.dart';

void main() {

  onSortFunction(posts) {}

  List posts = [
    // oldest and a-z
    {
      'community': 'A',
      'creationDate': 0,
      'likes': [1, 2, 3],
      'commentCount': 1
    },
    //most liked
    {
      'community': 'B',
      'creationDate': 1,
      'likes': [1, 2, 3, 4],
      'commentCount': 1
    },
    //most comments and most ineractions
    {
      'community': 'C',
      'creationDate': 2,
      'likes': [1, 2, 3],
      'commentCount': 3
    },
    {
      'community': 'D',
      'creationDate': 3,
      'likes': [1, 2, 3],
      'commentCount': 1
    },
    //newest and z-a
    {
      'community': 'E',
      'creationDate': 4,
      'likes': [1, 2, 3],
      'commentCount': 1
    },
  ];
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SortPosts(
            posts: const [], onSort: onSortFunction, isCommunityPage: false)));
    expect(find.byType(SortPosts), findsOneWidget);
  });

  testWidgets('sort by newest', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SortPosts(
            posts: posts, onSort: onSortFunction, isCommunityPage: false)));

    await tester.pump();

    var mainButton = find.byKey(const Key("popupMenuKey"));
    expect(mainButton, findsOneWidget);

    await tester.tap(mainButton);

    await tester.pumpAndSettle();
    await tester.tap(find.text('Newest'));
    await tester.pump();
    expect(find.text('Newest'), findsOneWidget);
    expect(posts[0]['creationDate'], 4);
  });

  testWidgets('sort by oldest', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SortPosts(
            posts: posts, onSort: onSortFunction, isCommunityPage: false)));

    await tester.pump();

    var mainButton = find.byKey(const Key("popupMenuKey"));
    expect(mainButton, findsOneWidget);

    await tester.tap(mainButton);

    await tester.pumpAndSettle();
    await tester.tap(find.text('Oldest'));
    await tester.pump();
    expect(find.text('Oldest'), findsOneWidget);
    expect(posts[0]['creationDate'], 0);
  });

  testWidgets('sort by top liked', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SortPosts(
            posts: posts, onSort: onSortFunction, isCommunityPage: false)));

    await tester.pump();

    var mainButton = find.byKey(const Key("popupMenuKey"));
    expect(mainButton, findsOneWidget);

    await tester.tap(mainButton);

    await tester.pumpAndSettle();
    await tester.tap(find.text('Top Liked'));
    await tester.pump();
    expect(find.text('Top Liked'), findsOneWidget);
    expect(posts[0]['likes'].length, 4);
  });

  testWidgets('sort by Most Comments', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SortPosts(
            posts: posts, onSort: onSortFunction, isCommunityPage: false)));

    await tester.pump();

    var mainButton = find.byKey(const Key("popupMenuKey"));
    expect(mainButton, findsOneWidget);

    await tester.tap(mainButton);

    await tester.pumpAndSettle();
    await tester.tap(find.text('Most Comments'));
    await tester.pump();
    expect(find.text('Most Comments'), findsOneWidget);
    expect(posts[0]['commentCount'], 3);
  });

  testWidgets('sort by Most Interactions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SortPosts(
            posts: posts, onSort: onSortFunction, isCommunityPage: false)));

    await tester.pump();

    var mainButton = find.byKey(const Key("popupMenuKey"));
    expect(mainButton, findsOneWidget);

    await tester.tap(mainButton);

    await tester.pumpAndSettle();
    await tester.tap(find.text('Most Interactions'));
    await tester.pump();
    expect(find.text('Most Interactions'), findsOneWidget);
    expect(posts[0]['community'], 'C');
  });

  testWidgets('sort by Community A to Z', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SortPosts(
            posts: posts, onSort: onSortFunction, isCommunityPage: false)));

    await tester.pump();

    var mainButton = find.byKey(const Key("popupMenuKey"));
    expect(mainButton, findsOneWidget);

    await tester.tap(mainButton);

    await tester.pumpAndSettle();
    await tester.tap(find.text('Community A to Z'));
    await tester.pump();
    expect(find.text('Community A to Z'), findsOneWidget);
    expect(posts[0]['community'], 'A');
  });

  testWidgets('sort by Community Z to A', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SortPosts(
            posts: posts, onSort: onSortFunction, isCommunityPage: false)));

    await tester.pump();

    var mainButton = find.byKey(const Key("popupMenuKey"));
    expect(mainButton, findsOneWidget);

    await tester.tap(mainButton);

    await tester.pumpAndSettle();
    await tester.tap(find.text('Community Z to A'));
    await tester.pump();
    expect(find.text('Community Z to A'), findsOneWidget);
    expect(posts[0]['community'], 'E');
  });
}
