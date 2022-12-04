import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/pages/common_widgets/create_community_page.dart';
import 'package:linear/pages/search_page.dart';
import 'package:mockito/annotations.dart';
import 'package:linear/constants/routes.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])
void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester
        .pumpWidget( const MaterialApp(home: SearchPage()));
    expect(find.byType(SearchPage), findsOneWidget);
  });

  test('Search Bar Field Changes', () {
    //setup
    final body = TextEditingController();
    //do
    body.text = 'hockey';
    //test
    expect(body.text, 'hockey');
  });
  
}