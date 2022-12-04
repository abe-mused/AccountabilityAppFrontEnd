import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/pages/common_widgets/create_community_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreateCommunityPage()));
    expect(find.byType(CreateCommunityPage), findsOneWidget);
  });

  test('Community Creation Box', () {
    //setup
    final communityName = TextEditingController();
    //do
    communityName.text = 'literature';
    //test
    expect(communityName.text, 'literature');
  });

}