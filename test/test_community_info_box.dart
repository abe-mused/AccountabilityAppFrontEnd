import 'package:flutter_test/flutter_test.dart';
import 'package:linear/widgets/community_info_box.dart';

void main() {
  testWidgets('CommunityBoxInfo has name and date', (WidgetTester tester) async {
    await tester.pumpWidget(CommunityInfoBox(communityName: 'T', dateCreated: 'D'));

    final communityNameFinder = find.text('T');
    final dateCreatedFinder = find.text('D');

    expect(communityNameFinder, findsOneWidget);
    expect(dateCreatedFinder, findsOneWidget);
  });
}