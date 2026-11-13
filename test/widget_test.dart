import 'package:flutter_test/flutter_test.dart';
import 'package:wintowin/main.dart';

void main() {
  testWidgets('WinToWinApp launches and renders 5 main navigation tabs', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WinToWinApp());
    await tester.pumpAndSettle();

    // Verify app brand title and 5 core tabs
    expect(find.text('WinToWin'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Board'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
