import 'package:flutter_test/flutter_test.dart';

import 'package:linear/login.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LoginPage());

    // Verify that our page contains the text we expect.
    expect(find.text('Linear Accountability App'), findsOneWidget);
    expect(
        find.text('Yo, this is the Linear Accountability App'), findsOneWidget);
  });
}
