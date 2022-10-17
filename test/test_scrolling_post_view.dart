import 'package:flutter_test/flutter_test.dart';
import 'package:linear/widgets/scrolling_post_view.dart';

void main() {
  testWidgets('ScrollingPostView has name and date', (WidgetTester tester) async {
    await tester.pumpWidget(ScrollingPostView(username: 'U', titleOfPost: 'T', postText: 'B', communityName: 'C', dateCreated: 'D'));

    final title_of_postFinder = find.text('T');
    final post_textFinder = find.text('B');
    final communityNameFinder = find.text('C');

    expect(title_of_postFinder, findsOneWidget);
    expect(post_textFinder, findsOneWidget);
    expect(communityNameFinder, findsOneWidget);
  });
}