import 'package:flutter_test/flutter_test.dart';
import 'package:dart_practice/main.dart';

void main() {
  testWidgets('TOEIC Reading App loads and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ToeicExamApp());
    await tester.pump();

    // Check that TOEIC branding is present
    expect(find.textContaining('TOEIC'), findsWidgets);
  });
}
