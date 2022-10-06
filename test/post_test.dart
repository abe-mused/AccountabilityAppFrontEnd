import 'package:flutter_test/flutter_test.dart';

import 'package:linear/main.dart';
import 'package:linear/widgets/ProfileBox.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our page contains the text we expect.
    expect(find.text('Linear Accountability App'), findsOneWidget);
    expect(find.text('Yo, this is the Linear Accountability App'), findsOneWidget);
  });
}
