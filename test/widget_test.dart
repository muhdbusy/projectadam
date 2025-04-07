// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:day8_splash/main.dart'; // Ensure the right import for HomePage()

void main() {
  testWidgets('HomePage test', (WidgetTester tester) async {
    // Build the HomePage widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Verify if certain text or elements exist.
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('We promise that you\'ll have the most \nfuss-free time with us ever.'), findsOneWidget);

    // Add other interactions with widgets here as needed.
  });
}
