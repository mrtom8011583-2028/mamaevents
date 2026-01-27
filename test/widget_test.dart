import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mama_events/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts and shows the title.
    // Note: We use find.byType(MaterialApp) as a basic check since
    // initialization might take time or show a splash screen.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
