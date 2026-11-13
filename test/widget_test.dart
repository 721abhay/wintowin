import 'package:flutter_test/flutter_test.dart';
import 'package:wintowin/main.dart';

void main() {
  testWidgets('WinToWinApp launches and renders main navigation and home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WinToWinApp());
    await tester.pumpAndSettle();

    // Verify app title and navigation items exist.
    expect(find.text('WinToWin Mobile'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Readiness'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
