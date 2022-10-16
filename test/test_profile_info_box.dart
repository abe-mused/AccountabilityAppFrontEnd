import 'package:flutter_test/flutter_test.dart';
import 'package:linear/widgets/profile_info_box.dart';

void main() {
  testWidgets('ProfileInfoBox has name and date', (WidgetTester tester) async {
    await tester.pumpWidget(ProfileInfoBox(username: 'U', dateJoined: 'D'));

    final usernameFinder = find.text('U');
    final dateJoinedFinder = find.text('D');

    expect(usernameFinder, findsOneWidget);
    expect(dateJoinedFinder, findsOneWidget);
  });
}